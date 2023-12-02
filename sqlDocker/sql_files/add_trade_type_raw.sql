CREATE TABLE raw.TradeType (
    TT_ID CHAR(3) Not NULL,
    TT_NAME CHAR(12) Not NULL,
    TT_IS_SELL numeric(1) Not NULL,
    TT_IS_MRKT numeric(1) Not NULL
);

BULK INSERT raw.TradeType FROM '/usr/config/data/gendata/Batch1/TradeType.txt' WITH
(
    FIRSTROW = 1,
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '0x0a',
    KEEPNULLS
);
