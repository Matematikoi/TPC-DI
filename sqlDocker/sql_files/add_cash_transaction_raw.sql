CREATE TABLE raw.CashTransaction (
    CT_CA_ID NUMERIC(11) NOT NULL,
	CT_DTS DATETIME NOT NULL,
	CT_AMT NUMERIC(10,2) NOT NULL,
	CT_NAME CHAR(100) NOT NULL
);

BULK INSERT raw.CashTransaction FROM '/usr/config/data/gendata/Batch1/CashTransaction.txt' WITH
(
    FIRSTROW = 1,
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '\n',
    KEEPNULLS
)
