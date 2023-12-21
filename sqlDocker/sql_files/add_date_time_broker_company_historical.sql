-- Date dimension
SELECT * INTO DimDate FROM raw.Date

-- Time dimension
SELECT * INTO DimTime FROM raw.Time

-- Broker dimension
SELECT
    IDENTITY(INT, 1, 1) AS SK_BrokerID,
    EmployeeID as BrokerID,
    ManagerID as ManagerID,
    EmployeeFirstName as FirstName,
    EmployeeLastName as LastName,
    EmployeeMI as MiddleInitial,
    EmployeeBranch as Branch,
    EmployeeOffice as Office,
    EmployeePhone as Phone,
    1 AS IsCurrent,
    1 as BatchID,
    (SELECT MIN(DateValue) FROM DimDate) as EffectiveDate,
    '9999-12-31' AS EndDate
INTO DimBroker
FROM raw.HR;

--Company Dimension New
SELECT
    IDENTITY(INT, 1, 1) AS SK_CompanyID,
    CIK as CompanyID,
    s.ST_NAME as Status,
    CompanyName as Name,
    i.IN_NAME as Industry,
    (CASE
        WHEN SPrating not in ('AAA','AA','AA+','AA-','A','A+','A-','BBB','BBB+','BBB-','BB','BB+','BB-','B','B+','B-','CCC','CCC+','CCC-','CC','C','D')
            THEN null
        ELSE c.SPrating END) as SPrating,
    (CASE
        WHEN SPrating not in ('AAA','AA','AA+','AA-','A','A+','A-','BBB','BBB+','BBB-','BB','BB+','BB-','B','B+','B-','CCC','CCC+','CCC-','CC','C','D')
            THEN null
        WHEN c.SPrating like 'A%' or c.SPrating like 'BBB%'
            THEN 0
        ELSE
            1
    END) as islowgrade,
    CEOname as CEO,
    AddrLine1 as AddressLine1,
    AddrLine2 as AddressLine2,
    PostalCode,
    City,
    StateProvince as State_Prov,
    Country,
    Description,
    FoundingDate,
    CAST(LEFT(c.PTS, 8) AS DATE) AS EffectiveDate,
    CASE
        WHEN LEAD(CAST(LEFT(c.PTS, 8) AS DATE)) OVER (PARTITION BY c.CIK ORDER BY CAST(LEFT(c.PTS, 8) AS DATE) ASC) IS NOT NULL
        THEN LEAD(CAST(LEFT(c.PTS, 8) AS DATE)) OVER (PARTITION BY c.CIK ORDER BY CAST(LEFT(c.PTS, 8) AS DATE) ASC)
        ELSE '9999-12-31'
    END AS EndDate,
    CASE
        WHEN LEAD(CAST(LEFT(c.PTS, 8) AS DATE)) OVER (PARTITION BY c.CIK ORDER BY CAST(LEFT(c.PTS, 8) AS DATE) ASC) IS NULL
        THEN 1
        ELSE 0
    END AS IsCurrent,
    1 as BatchID
INTO DimCompany
FROM raw.FinwireCompany c, raw.StatusType s, raw.Industry I
WHERE c.Status = s.ST_ID AND c.IndustryID = i.IN_ID;