CREATE TABLE DimAccount(
    SK_AccountID int IDENTITY(1,1) PRIMARY KEY,
    AccountID NUMERIC(11),
    BrokerID NUMERIC(11),
    SK_BrokerID NUMERIC(11),
    CustomerID NUMERIC(11),
    SK_CustomerID NUMERIC(11),
    Status VARCHAR(10),
    AccountDesc VARCHAR(50),
    TaxStatus NUMERIC(1),
    IsCurrent BIT,
    BatchID NUMERIC(5),
    EffectiveDate DATE,
    EndDate DATE,
    ActionType VARCHAR(50),
)
BULK INSERT DimAccount FROM '/usr/config/data/gendata/Batch1/AccountDim.csv' WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    KEEPNULLS
)
--SURROGATE KEYS--

CREATE TABLE news(
    SK_AccountID NUMERIC(6))
INSERT INTO news (SK_AccountID)
SELECT SK_AccountID
FROM 
    (SELECT DISTINCT SK_AccountID
            FROM DimAccount 
            WHERE ActionType IN ('NEW', 'ADDACCT')
    ) new
--UPDATE CUSTOMER--
CREATE TABLE upd(
    SK_AccountID NUMERIC(6))
INSERT INTO news (SK_AccountID)
SELECT SK_AccountID
FROM 
    (SELECT DISTINCT SK_AccountID
            FROM DimAccount 
            WHERE actiontype = 'UPDCUST'
    ) upc
--INACTIVE--
CREATE TABLE ina(
    SK_AccountID NUMERIC(6))
INSERT INTO news (SK_AccountID)
SELECT *
FROM 
    (SELECT DISTINCT SK_AccountID
            FROM DimAccount 
            WHERE actiontype = 'INACT'
    ) inac    
--Brokers--
CREATE TABLE brokers(
    BrokerID NUMERIC(11),
    SK_BrokerID NUMERIC(11),
    EffectiveDate DATE,
    EndDate DATE)
INSERT INTO brokers (BrokerID, SK_BrokerID, EffectiveDate, EndDate)
SELECT *
FROM 
    (
        SELECT BrokerID, SK_BrokerID, EffectiveDate, EndDate
            FROM (
                SELECT BrokerID, SK_BrokerID, EffectiveDate, EndDate,
                    ROW_NUMBER() OVER(PARTITION BY BrokerID ORDER BY EndDate DESC) AS rn
                FROM DimBroker
            ) RankedBrokers
            WHERE rn = 1
    ) broke
--Customers--
CREATE TABLE customers(
    CustomerID NUMERIC(11),
    SK_CustomerID NUMERIC(11),
    EffectiveDate DATE,
    EndDate DATE)
INSERT INTO customers (CustomerID, SK_CustomerID,EffectiveDate,EndDate)
SELECT *
FROM 
    (
        SELECT CustomerID, SK_CustomerID, EffectiveDate, EndDate
            FROM (
                SELECT CustomerID, SK_CustomerID, EffectiveDate, EndDate,
                    ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY EndDate DESC) AS rn
                FROM DimCustomer
            ) RankedCustomers
            WHERE rn = 1
    ) customer


--New 1--
UPDATE A
SET 
    A.SK_BrokerID = B.SK_BrokerID
FROM DimAccount A
INNER JOIN news N on A.SK_AccountID = N.SK_AccountID
INNER JOIN brokers B on A.BrokerID = B.BrokerID
WHERE A.EffectiveDate >= B.EffectiveDate
AND   A.EndDate <= B.EndDate
--New 1--
UPDATE A
SET 
    A.SK_CustomerID = C.SK_CustomerID
FROM DimAccount A
INNER JOIN news N on A.SK_AccountID = N.SK_AccountID
INNER JOIN customers C ON A.CustomerID = C.CustomerID
WHERE A.EffectiveDate >= C.EffectiveDate
AND   A.EndDate <= C.EndDate
--UPD--
UPDATE A
SET 
    A.SK_CustomerID = C.SK_CustomerID
FROM DimAccount A
INNER JOIN upd U on A.SK_AccountID = U.SK_AccountID
LEFT JOIN customers C ON A.CustomerID = C.CustomerID
--INACT--
UPDATE A
SET 
   A.SK_CustomerID = C.SK_CustomerID 
FROM DimAccount A
INNER JOIN ina I on A.SK_AccountID = I.SK_AccountID
LEFT JOIN customers C ON A.CustomerID = C.CustomerID


ALTER TABLE DimAccount
    DROP COLUMN BrokerID, CustomerID,ActionType;

DROP TABLE news, upd, ina, brokers, customers;
