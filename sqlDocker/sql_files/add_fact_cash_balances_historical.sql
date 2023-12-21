WITH CashBalancesTransformation AS (SELECT
	DA.SK_CustomerID AS SK_CustomerID,
	DA.SK_AccountID AS SK_AccountID,
	DD.SK_DateID AS SK_DateID,
	SUM(CT_AMT) OVER (PARTITION BY SK_AccountID ORDER BY DateValue) Cash
FROM raw.CashTransaction CT, DimAccount DA, DimDate DD
WHERE CT.CT_CA_ID = DA.AccountID
	AND CONVERT(DATE, CT_DTS) BETWEEN DA.EffectiveDate AND DA.EndDate
	AND CONVERT(DATE, CT_DTS) = DD.DateValue
)
SELECT 
     SK_CUSTOMER_ID
	,SK_ACCOUNT_ID
	,SK_DATE_ID
	,Cash
	, 1 as BATCHID
INTO FactCashBalances
FROM CashBalancesTransformation
