
CREATE TABLE raw.Trade (
	-- I have no idea why this are in the documentation but not here
    -- but I leave them here just because
    -- CDC_FLAG CHAR(1),
    -- CDC_DSN NUMERIC(12),
    T_ID NUMERIC(15),
    T_DTS DATETIME,
    T_ST_ID CHAR(4),
    T_TT_ID CHAR(3),
    T_IS_CASH BIT,
    T_S_SYMB CHAR(15),
    T_QTY NUMERIC(6),
    T_BID_PRICE NUMERIC(8,2),
    T_CA_ID NUMERIC(11),
    T_EXEC_NAME CHAR(49),
    T_TRADE_PRICE NUMERIC(8,2),
    T_CHRG NUMERIC(10,2),
    T_COMM NUMERIC(10,2),
    T_TAX NUMERIC(10,2),
);

BULK INSERT raw.Trade FROM '/usr/config/data/gendata/Batch1/Trade.txt' WITH
(
    FIRSTROW = 1,
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '0x0a',
    KEEPNULLS
)