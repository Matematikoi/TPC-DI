CREATE TABLE raw.Industry (
    IN_ID CHAR(2) NOT NULL,
    IN_NAME CHAR(50) NOT NULL,
    IN_SC_ID CHAR(4) NOT NULL
 );

 BULK INSERT raw.Industry FROM '/usr/config/data/gendata/Batch1/Industry.txt' WITH
 (
     FIRSTROW = 1,
     FIELDTERMINATOR = '|',
     ROWTERMINATOR = '\n',
     KEEPNULLS
 )