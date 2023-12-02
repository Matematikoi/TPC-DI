CREATE TABLE raw.WatchHistory (
    W_C_ID NUMERIC(11),
    W_S_SYMB CHAR(15),
    W_DTS DATETIME,
    W_ACTION CHAR(4)
);

BULK INSERT raw.WatchHistory FROM '/usr/config/data/gendata/Batch1/WatchHistory.txt' WITH
(
    FIRSTROW = 1,
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '\n',
    KEEPNULLS
)
