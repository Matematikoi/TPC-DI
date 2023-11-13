CREATE TABLE raw.TaxRate (
    TX_ID CHAR(4) Not NULL,
    TX_NAME CHAR(50) Not NULL,
    TX_RATE numeric(6,5) Not NULL
);

BULK INSERT raw.TaxRate FROM '/usr/config/data/gendata/Batch1/TaxRate.txt' WITH
(
    FIRSTROW = 1,
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '0x0a',
    KEEPNULLS
)
