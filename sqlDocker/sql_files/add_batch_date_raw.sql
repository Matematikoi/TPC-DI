CREATE TABLE raw.BatchDate (
	BatchDate DATE
)

BULK INSERT raw.BatchDate FROM '/usr/config/data/gendata/Batch1/BatchDate.txt' WITH
(
    FIRSTROW = 1,
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '\n',
    KEEPNULLS
)
