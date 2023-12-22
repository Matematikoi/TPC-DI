CREATE TABLE Audit
(
    DataSet   CHAR(20),
    BatchID   NUMERIC(5),
    Date      DATE,
    Attribute CHAR(50),
    Value     NUMERIC(15),
    DValue    NUMERIC(15, 5)
);

BULK INSERT Audit
FROM '/usr/config/output_audit.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2
);