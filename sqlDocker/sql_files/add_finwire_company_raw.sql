CREATE TABLE raw.FinwireCompany (
    PTS NVARCHAR(15),
    RecType NVARCHAR(3),
    CompanyName NVARCHAR(60),
    CIK NVARCHAR(10),
    Status NVARCHAR(4),
    IndustryID NVARCHAR(2),
    SPrating NVARCHAR(4),
    FoundingDate NVARCHAR(8),
    AddrLine1 NVARCHAR(80),
    AddrLine2 NVARCHAR(80),
    PostalCode NVARCHAR(12),
    City NVARCHAR(25),
    StateProvince NVARCHAR(20),
    Country NVARCHAR(24),
    CEOname NVARCHAR(46),
    Description NVARCHAR(150)
);

BULK INSERT raw.FinwireCompany FROM '/usr/config/data/gendata/Batch1/CMP.csv' WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    KEEPNULLS
);
