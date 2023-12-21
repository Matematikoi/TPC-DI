--Fact Holdings
SELECT
    h.HH_H_T_ID AS TradeID,
    h.HH_T_ID AS CurrentTradeID,
    t.SK_CustomerID,
    t.SK_AccountID,
	t.SK_SecurityID,
	t.SK_CompanyID,
    SK_CloseDateID AS SK_DateID,
	SK_CloseTimeID AS SK_TimeID,
	t.TradePrice AS CurrentPrice,
	h.HH_AFTER_QTY AS CurrentHolding,
	1 AS BatchID
INTO FactHoldings
FROM raw.HoldingHistory h, DimTrade t
WHERE h.HH_T_ID = t.TradeID;
