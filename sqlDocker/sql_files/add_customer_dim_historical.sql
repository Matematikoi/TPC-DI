 -- Pending primary key
 CREATE TABLE DimCustomer (
    SK_CustomerID int IDENTITY(1,1) PRIMARY KEY,
    CustomerID NVARCHAR(80) ,
    TaxId NVARCHAR(20) ,
    Status NVARCHAR(10) ,
    LastName NVARCHAR(30) ,
    FirstName NVARCHAR(30) ,
    MiddleInitial NVARCHAR(1) ,
    Gender NVARCHAR(1) ,
    Tier NUMERIC(1) ,
    DOB DATE,
    AddressLine1 NVARCHAR(80) ,
    AddressLine2 NVARCHAR(80) ,
    PostalCode NVARCHAR(12) ,
    City NVARCHAR(25) ,
    StateProv NVARCHAR(20) ,
    Country NVARCHAR(24) ,
    Phone1 NVARCHAR(30) ,
    Phone2 NVARCHAR(30) ,
    Phone3 NVARCHAR(30) ,
    Email1 NVARCHAR(50) ,
    Email2 NVARCHAR(50) ,
    NationalTaxRateDesc NVARCHAR(50) ,
    NationalTaxRate NUMERIC(6,5)  ,
    LocalTaxRateDesc NVARCHAR(50) ,
    LocalTaxRate NUMERIC(6,5)  ,
    AgencyID NVARCHAR(30),
    CreditRating NUMERIC(6),
    NetWorth NUMERIC(11),
    MarketingNameplate NVARCHAR(100),
    IsCurrent BIT   ,
    BatchID NUMERIC(5)  ,
    EffectiveDate DATE ,
    EndDate DATE ,
    nationalTaxId NVARCHAR(80) ,
    localTaxId NVARCHAR(80) 
 )

BULK INSERT DimCustomer FROM '/usr/config/data/gendata/Batch1/CustomerDim.csv' WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    KEEPNULLS
)

UPDATE dimCustomer
SET 
    dimCustomer.NationalTaxRate=tr.TX_RATE , 
    dimCustomer.NationalTaxRateDesc=tr.TX_NAME 
FROM dimCustomer c
INNER JOIN
TaxRate tr
ON c.nationalTaxId = tr.TX_ID ;

UPDATE dimCustomer
SET 
    dimCustomer.LocalTaxRate=tr.TX_RATE , 
    dimCustomer.LocalTaxRateDesc=tr.TX_NAME 
FROM dimCustomer c
INNER JOIN
TaxRate tr
ON c.localTaxId = tr.TX_ID ;

UPDATE dimCustomer
SET 
    dimCustomer.AgencyId=p.AgencyID , 
    dimCustomer.CreditRating=p.CreditRating ,
    dimCustomer.NetWorth =p.NetWorth 
FROM dimCustomer c
INNER JOIN
raw.Prospect p
ON UPPER(p.FirstName)  = UPPER(c.FirstName)
AND UPPER(p.LastName) = UPPER(c.LastName)
AND UPPER(p.PostalCode) = UPPER(c.PostalCode)
AND UPPER(p.AddressLine1) = UPPER(c.AddressLine1)
AND UPPER(p.AddressLine2) = UPPER(c.AddressLine2)
WHERE
c.IsCurrent =1;