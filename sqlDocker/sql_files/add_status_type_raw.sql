CREATE TABLE raw.StatusType (
    ST_ID CHAR(4) NOT NULL,
    ST_NAME CHAR(10) NOT NULL
 );

 BULK INSERT raw.StatusType FROM '/usr/config/data/gendata/Batch1/StatusType.txt' WITH
 (
     FIRSTROW = 1,
     FIELDTERMINATOR = '|',
     ROWTERMINATOR = '\n',
     KEEPNULLS
 )