CREATE TABLE High_Low  (
    DM_DATE DATE ,
    DM_S_SYMB CHAR(15) ,
    DM_CLOSE NUMERIC(8,2),
    DM_HIGH NUMERIC(8,2) ,
    DM_LOW NUMERIC(8,2) ,
    DM_VOL NUMERIC(12),
	FiftyTwoWeekHigh NUMERIC(8,2),
	FiftyTwoWeekLow NUMERIC(8,2),
	FiftyTwoWeekHighDate DATE,
	FiftyTwoWeekLowDate DATE
)
INSERT INTO High_Low ( DM_DATE ,
    DM_S_SYMB  ,
    DM_CLOSE ,
    DM_HIGH ,
    DM_LOW ,
    DM_VOL ,
	FiftyTwoWeekHigh ,
	FiftyTwoWeekLow ,
	FiftyTwoWeekHighDate ,
	FiftyTwoWeekLowDate )
SELECT *  
FROM 
( 
	SELECT DM1.*, MIN(DM2.DM_DATE) AS FiftyTwoWeekHighDate, MIN(DM3.DM_DATE) AS FiftyTwoWeekLowDate
    FROM
	(
		SELECT 
			DM.DM_DATE, 
			DM.DM_S_SYMB, 
			DM.DM_CLOSE, 
			DM.DM_HIGH, 
			DM.DM_LOW, 
			DM.DM_VOL, 
			MAX(DM.DM_HIGH) OVER(PARTITION BY DM.DM_S_SYMB ORDER BY DM.DM_DATE ROWS BETWEEN 365 PRECEDING AND CURRENT ROW) AS FiftyTwoWeekHigh, 
			MIN(DM.DM_LOW) OVER(PARTITION BY DM.DM_S_SYMB ORDER BY DM.DM_DATE ROWS BETWEEN 365 PRECEDING AND CURRENT ROW) AS FiftyTwoWeekLow
		FROM raw.DailyMarket DM
	  
	) DM1 
	
	INNER JOIN raw.DailyMarket DM2
		ON DM2.DM_HIGH = DM1.FiftyTwoWeekHigh
		AND DM2.DM_DATE BETWEEN CONVERT(DATE, DATEADD(DAY, -365, DM1.DM_DATE)) AND DM1.DM_DATE
	INNER JOIN raw.DailyMarket DM3
		ON DM3.DM_LOW = DM1.FiftyTwoWeekLow
		AND DM3.DM_DATE BETWEEN CONVERT(DATE, DATEADD(DAY, -365, DM1.DM_DATE)) AND DM1.DM_DATE
	GROUP BY DM1.DM_DATE, DM1.DM_S_SYMB, DM1.DM_CLOSE, DM1.DM_HIGH, DM1.DM_LOW, DM1.DM_VOL, DM1.FiftyTwoWeekHigh, DM1.FiftyTwoWeekLow
) High_Low_temp

--Totaleps--
CREATE TABLE Totaleps (
CoNameOrCIK NVARCHAR(MAX),
Total_EPS NUMERIC(8,2),
PostingDate DATE
)
INSERT INTO Totaleps (CoNameOrCIK, Total_EPS, PostingDate )
SELECT * FROM (
	SELECT
		CoNameOrCIK,
		SUM(CAST(EPS AS FLOAT)) OVER(PARTITION BY Quarter ORDER BY Year, Quarter ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS Total_EPS,
		PostingDate
	FROM raw.FinwireFinancial
) Totaleps_temp

-- CompanyEarnings --
CREATE TABLE CompanyEarnings(
SK_CompanyID VARCHAR(4),
Total_EPS NUMERIC(8,2),
PostingDate Date
)
INSERT INTO CompanyEarnings(SK_CompanyID, Total_EPS, PostingDate)
SELECT * FROM  (
	SELECT SK_CompanyID, TOTALEPS.Total_EPS, TOTALEPS.PostingDate
	FROM DimCompany DC, TOTALEPS 
	WHERE ISNUMERIC(TOTALEPS.CoNameOrCIK) = 1
	AND DC.CompanyID = CAST(TOTALEPS.CoNameOrCIK AS INT)
	
	UNION
	SELECT  SK_CompanyID, TOTALEPS.Total_EPS, TOTALEPS.PostingDate
	FROM DimCompany DC,  TOTALEPS
	WHERE ISNUMERIC(TOTALEPS.CoNameOrCIK) = 0
	AND DC.Name = TOTALEPS.CoNameOrCIK
	
	
) CompanyEarnings_temp

SELECT
	HL.DM_CLOSE AS ClosePrice, 
	HL.DM_HIGH AS DayHigh, 
	HL.DM_LOW AS DayLow,
	HL.DM_VOL AS Volume,
    DS.SK_SecurityID,
    DS.SK_CompanyID,
	DD1.SK_DateID AS SK_DateID,
	HL.FiftyTwoWeekHigh,
	DD2.SK_DateID AS SK_FiftyTwoWeekHighDate,
	HL.FiftyTwoWeekLow,
	DD3.SK_DateID AS SK_FiftyTwoWeekLowDate,
	HL.DM_CLOSE / CE.Total_EPS AS PERatio,
	DS.Dividend / HL.DM_CLOSE * 100 AS Yield, 
	1 AS BatchID
into FactMarketHistory
FROM High_Low HL,
DimSecurity DS, 
CompanyEarnings CE, 
DimDate DD1,
DimDate DD2,
DimDate DD3
WHERE 
HL.DM_S_SYMB = DS.Symbol and DS.IsCurrent=1
AND DS.SK_CompanyID = CE.SK_CompanyID
AND HL.DM_DATE = DD1.DateValue
AND HL.FiftyTwoWeekHighDate = DD2.DateValue
AND HL.FiftyTwoWeekLowDate = DD3.DateValue
AND HL.DM_DATE BETWEEN DS.EffectiveDate AND DS.EndDate
AND CE.PostingDate BETWEEN DS.EffectiveDate AND DS.EndDate
AND HL.DM_DATE=CE.PostingDate
