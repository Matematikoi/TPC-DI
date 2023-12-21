WITH CashBalancesTransformation AS (SELECT
	DA.SK_CustomerID AS SK_CustomerID,
	DA.SK_AccountID AS SK_AccountID,
	DD.SK_DateID AS SK_DateID,
	SUM(CT_AMT) OVER (PARTITION BY SK_AccountID ORDER BY DateValue) Cash
FROM [dwh].[raw].[CashTransaction] CT, [dwh].[dbo].[DimAccount] DA, [dwh].[dbo]. [DimDate] DD
WHERE CT.CT_CA_ID = DA.AccountID
	AND CONVERT(DATE, CT_DTS) BETWEEN DA.EffectiveDate AND DA.EndDate
	AND CONVERT(DATE, CT_DTS) = DD.DateValue
)
SELECT 
         SK_CustomerID
	,SK_AccountID
	,SK_DateID
	,Cash
	, 1 as BATCHID
INTO FactCashBalances
FROM CashBalancesTransformation
