CREATE TABLE raw.TradeType (
    TT_ID CHAR(3),
    TT_NAME CHAR(12),
    TT_IS_SELL NUMERIC(1),
    TT_IS_MRKT NUMERIC(1)
);

BULK INSERT raw.TradeType FROM '/usr/config/data/gendata/Batch1/TradeType.txt' WITH
(
    FIRSTROW = 1,
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '0x0a',
    KEEPNULLS
);