CREATE TABLE raw.Prospect (
    AgencyID CHAR(30) NOT NULL,
    LastName CHAR(30) NOT NULL,
    FirstName CHAR(30) NOT NULL,
    MiddleInitial CHAR(1),
    Gender CHAR(1),
    AddressLine1 CHAR(80),
    AddressLine2 CHAR(80),
    PostalCode CHAR(12),
    City CHAR(25) NOT NULL,
    State CHAR(20) NOT NULL,
    Country CHAR(24),
    Phone CHAR(30),
    Income NUMERIC(9),
    NumberCars Numeric(2),
    NumberChildren Numeric(2),
    MaritalStatus CHAR(1),
    Age NUMERIC(3),
    CreditRating NUMERIC(4),
    OwnOrRentFlag CHAR(1),
    Employer CHAR(30),
    NumberCreditCards NUMERIC(2),
    NetWorth NUMERIC (12)

 );

 BULK INSERT raw.Prospect FROM '/usr/config/data/gendata/Batch1/Prospect.csv' WITH
 (
     FIRSTROW = 1,
     FIELDTERMINATOR = ',',
     ROWTERMINATOR = '\n',
     KEEPNULLS
 )