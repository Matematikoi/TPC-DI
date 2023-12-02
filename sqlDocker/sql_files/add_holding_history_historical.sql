INSERT INTO FactHoldings(SK_CustomerID, 
                         SK_AccountID, 
                         SK_SecurityID, 
                         SK_CompanyID, 
                         CurrentPrice, 
                         SK_DateID,
                         SK_TimeID, 
                         TradeID, 
                         CurrentTradeID, 
                         CurrentHolding, 
                         BatchID)
SELECT 
	DT.SK_CustomerID, 
	DT.SK_AccountID, 
	DT.SK_SecurityID, 
	DT.SK_CompanyID,
	DT.TradePrice AS CurrentPrice, 
	SK_CloseDateID AS SK_DateID,
	SK_CloseTimeID AS SK_TimeID,
	HH.HH_H_T_ID AS TradeID,
	HH.HH_T_ID AS CurrentTradeID,
	HH.HH_AFTER_QTY AS CurrentHolding,
	1 AS BatchID
FROM raw.HoldingHistory HH, DimTrade DT --assuming GOL makes DimTrade from Trade table 
WHERE HH.HH_T_ID = DT.TradeID