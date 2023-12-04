CREATE TABLE raw.TradeHistory (
    TH_T_ID NUMERIC(15),
    TH_DTS DATETIME,
    TH_ST_ID CHAR(5),
);

BULK INSERT raw.TradeHistory FROM '/usr/config/data/gendata/Batch1/TradeHistory.txt' WITH
(
    FIRSTROW = 1,
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '0x0a',
    KEEPNULLS
);
