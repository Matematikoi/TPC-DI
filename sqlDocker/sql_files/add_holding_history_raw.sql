CREATE TABLE raw.HoldingHistory (
    HH_H_T_ID NUMERIC(15) NOT NULL,
    HH_T_ID NUMERIC(15) NOT NULL,
    HH_BEFORE_QTY NUMERIC(6) NOT NULL,
    HH_AFTER_QTY NUMERIC(6) NOT NULL
 );

 BULK INSERT raw.HoldingHistory FROM '/usr/config/data/gendata/Batch1/HoldingHistory.txt' WITH
 (
     FIRSTROW = 1,
     FIELDTERMINATOR = '|',
     ROWTERMINATOR = '\n',
     KEEPNULLS
 )