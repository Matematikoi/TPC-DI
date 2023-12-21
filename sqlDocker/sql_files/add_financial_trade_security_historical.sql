-- Security Dimension
WITH SecurityTransformation AS (
	SELECT
		f.Symbol AS Symbol,
		f.IssueType AS Issue,
		s.ST_NAME AS Status,
		f.Name AS Name,
		f.ExID AS ExchangeID,
		dc.SK_CompanyID AS SK_CompanyID,
		f.ShOut AS SharesOutstanding,
		CAST(f.FirstTradeDate as DATE) AS FirstTrade,
		CAST(f.FirstTradeExchg as DATE) AS FirstTradeOnExchange,
		f.Dividend AS Dividend,
        CASE
            WHEN LEAD((SELECT BatchDate FROM raw.BatchDate)) OVER (PARTITION BY Symbol ORDER BY PTS ASC) IS NULL
            THEN 1
            ELSE 0
            END AS IsCurrent,
		CONVERT(DATETIME,STUFF(STUFF(STUFF(STUFF(REPLACE(F.PTS,'-',' '),5,0,'-'),8,0,'-'),14,0,':'),17,0,':'),120) AS EffectiveDate
	FROM raw.FinwireSecurity f, raw.StatusType s, DimCompany dc
	WHERE f.Status = s.ST_ID
	    AND((SUBSTRING(f.CoNameOrCIK, PATINDEX('%[^' + '0' + ']%', f.CoNameOrCIK), LEN(f.CoNameOrCIK)) = dc.CompanyID)
	        OR f.CoNameOrCIK = dc.Name)
	    AND CAST(LEFT(PTS, 8) as DATE) >= dc.EffectiveDate
	    AND CAST(LEFT(PTS, 8) as DATE) < dc.EndDate
)
SELECT
	IDENTITY(INT, 1, 1) AS SK_SecurityID,
	Symbol,
    Issue,
    Status,
    Name,
    ExchangeID,
    SK_CompanyID,
    SharesOutstanding,
    FirstTrade,
    FirstTradeOnExchange,
    Dividend,
    IsCurrent,
    1 AS BatchID,
    EffectiveDate,
    COALESCE( LEAD( EffectiveDate ) OVER ( PARTITION BY Symbol ORDER BY EffectiveDate ASC ), '9999-12-31 00:00:00' ) AS EndDate
INTO DimSecurity
FROM SecurityTransformation
ORDER BY Symbol, EffectiveDate;

-- Trade Dimension
WITH TradeTransformation AS (
	SELECT
        T.T_ID AS TradeID,
		A.SK_BrokerID AS SK_BrokerID,
		CASE
			WHEN CHARINDEX('SBMT', TH.TH_ST_ID) > 0 AND T.T_TT_ID IN ( 'TMB', 'TMS' ) OR CHARINDEX('PNDG', TH.TH_ST_ID) > 0 THEN TH.TH_DTS
		    WHEN CHARINDEX('CMPT', TH.TH_ST_ID) > 0 OR CHARINDEX('CNCL', TH.TH_ST_ID) > 0 THEN NULL
		END AS SK_CreateDateID,
		CASE
			WHEN CHARINDEX('SBMT', TH.TH_ST_ID) > 0 AND T.T_TT_ID IN ( 'TMB', 'TMS' ) OR CHARINDEX('PNDG', TH.TH_ST_ID) > 0 THEN TH.TH_DTS
		    WHEN CHARINDEX('CMPT', TH.TH_ST_ID) > 0 OR CHARINDEX('CNCL', TH.TH_ST_ID) > 0 THEN NULL
		END AS SK_CreateTimeID,
		CASE
			WHEN CHARINDEX('SBMT', TH.TH_ST_ID) > 0 AND T.T_TT_ID IN ( 'TMB', 'TMS' ) OR CHARINDEX('PNDG', TH.TH_ST_ID) > 0 THEN NULL
		    WHEN CHARINDEX('CMPT', TH.TH_ST_ID) > 0 OR CHARINDEX('CNCL', TH.TH_ST_ID) > 0 THEN TH.TH_DTS
		END AS SK_CloseDateID,
		CASE
			WHEN CHARINDEX('SBMT', TH.TH_ST_ID) > 0 AND T.T_TT_ID IN ( 'TMB', 'TMS' ) OR CHARINDEX('PNDG', TH.TH_ST_ID) > 0 THEN NULL
		    WHEN CHARINDEX('CMPT', TH.TH_ST_ID) > 0 OR CHARINDEX('CNCL', TH.TH_ST_ID) > 0 THEN TH.TH_DTS
		END AS SK_CloseTimeID,
		ST.ST_NAME AS Status,
		TT.TT_NAME AS DT_Type,
		T.T_IS_CASH AS CashFlag,
		S.SK_SecurityID AS SK_SecurityID,
		S.SK_CompanyID AS SK_CompanyID,
		T.T_QTY AS Quantity,
		T.T_BID_PRICE AS BidPrice,
		A.SK_CustomerID AS SK_CustomerID,
		A.SK_AccountID AS SK_AccountID,
		T.T_EXEC_NAME AS ExecutedBy,
		T.T_TRADE_PRICE AS TradePrice,
		T.T_CHRG AS Fee,
		T.T_COMM AS Commission,
		T.T_TAX AS Tax,
		1 AS BatchID
	FROM raw.Trade T
	INNER JOIN raw.TradeHistory TH ON T.T_ID = TH.TH_T_ID
	INNER JOIN raw.StatusType ST ON T.T_ST_ID = ST.ST_ID
	INNER JOIN raw.TradeType TT ON T.T_TT_ID = TT.TT_ID
	INNER JOIN DimSecurity S ON T.T_S_SYMB = S.Symbol AND TH.TH_DTS >= S.EffectiveDate AND TH.TH_DTS < S.EndDate
	INNER JOIN DimAccount A ON T.T_CA_ID = A.AccountID AND TH.TH_DTS >= A.EffectiveDate AND TH.TH_DTS < A.EndDate
)
SELECT
    TradeID,
    SK_BrokerID,
    MAX(DimCreateDate.SK_DateID) AS SK_CreateDateID,
    MAX(DimCreateTime.SK_TimeID) AS SK_CreateTimeID,
    MAX(DimCloseDate.SK_DateID) AS SK_CloseDateID,
    MAX(DimCloseTime.SK_TimeID) AS SK_CloseTimeID,
    Status,
    DT_Type,
    CashFlag,
    SK_SecurityID,
    SK_CompanyID,
    Quantity,
    BidPrice,
    SK_CustomerID,
    SK_AccountID,
    ExecutedBy,
    TradePrice,
    Fee,
    Commission,
    Tax,
    BatchID
INTO DimTrade
FROM TradeTransformation
LEFT JOIN DimDate AS DimCreateDate ON DimCreateDate.DateValue = CAST(TradeTransformation.SK_CreateDateID AS DATE)
LEFT JOIN DimTime AS DimCreateTime ON DimCreateTime.TimeValue = CAST(TradeTransformation.SK_CreateTimeID AS TIME)
LEFT JOIN DimDate AS DimCloseDate ON DimCloseDate.DateValue = CAST(TradeTransformation.SK_CloseDateID AS DATE)
LEFT JOIN DimTime AS DimCloseTime ON DimCloseTime.TimeValue = CAST(TradeTransformation.SK_CloseTimeID AS TIME)
GROUP BY
    TradeID,
    SK_BrokerID,
    Status,
    DT_Type,
    CashFlag,
    SK_SecurityID,
    SK_CompanyID,
    Quantity,
    BidPrice,
    SK_CustomerID,
    SK_AccountID,
    ExecutedBy,
    TradePrice,
    Fee,
    Commission,
    Tax,
    BatchID;

-- Financial table
WITH FinancialTransformation AS (
    SELECT CAST(CONCAT(SUBSTRING(PTS, 0, 5), '-', SUBSTRING(PTS, 5, 2) , '-', SUBSTRING(PTS, 7, 2), ' ', SUBSTRING(PTS, 10, 2), ':', SUBSTRING(PTS, 12, 2), ':', SUBSTRING(PTS, 14, 2)) AS DATETIME) AS PTS
        , CASE WHEN ISNUMERIC(CoNameOrCIK) = 1 THEN CAST(CoNameOrCIK AS INT) ELSE NULL END CIK
        , CASE WHEN ISNUMERIC(CoNameOrCIK) = 0 THEN CoNameOrCIK ELSE NULL END CoName
        , Year AS FI_YEAR
        , Quarter AS FI_QTR
        , QtrStartDate AS FI_QTR_START_DATE
        , Revenue AS FI_REVENUE
        , Earnings AS FI_NET_EARN
        , EPS AS FI_BASIC_EPS
        , DilutedEPS AS FI_DILUT_EPS
        , Margin AS FI_MARGIN
        , Inventory AS FI_INVENTORY
        , Assets AS FI_ASSETS
        , Liabilities AS FI_LIABILITY
        , ShOut AS FI_OUT_BASIC
        , DilutedShOut AS FI_OUT_DILUT
    FROM raw.FinwireFinancial F
)
SELECT
    COALESCE(dc.SK_CompanyID, NULL) AS SK_CompanyID,
    FI_YEAR,
    FI_QTR,
    FI_QTR_START_DATE,
    FI_REVENUE,
    FI_NET_EARN,
    FI_BASIC_EPS,
    FI_DILUT_EPS,
    FI_MARGIN,
    FI_INVENTORY,
    FI_ASSETS,
    FI_LIABILITY,
    FI_OUT_BASIC,
    FI_OUT_DILUT
INTO Financial
FROM FinancialTransformation ft
LEFT JOIN DimCompany dc ON (ft.CIK = dc.CompanyID OR ft.CoName = dc.Name) AND dc.IsCurrent = 1;