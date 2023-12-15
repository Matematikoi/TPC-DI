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

-- Company Dimension
SELECT
    IDENTITY(INT, 1, 1) AS SK_CompanyID,
    CIK as CompanyID,
    CASE WHEN LEAD( (SELECT TOP 1 BatchDate FROM raw.BatchDate) ) OVER ( PARTITION BY CIK ORDER BY PTS ASC ) IS NULL THEN 1 ELSE 0 END AS IsCurrent,
	(SELECT TOP 1 BatchDate FROM raw.BatchDate) as EffectiveDate,
	COALESCE( LEAD( (SELECT TOP 1 BatchDate FROM raw.BatchDate) ) OVER ( PARTITION BY CIK ORDER BY PTS ASC ), '9999-12-31' ) AS EndDate,
	1 as BatchID,
	CompanyName as Name,
	SPrating as SPRating,
	CEOname as CEO,
	Description,
	FoundingDate,
	AddrLine1 as AddressLine1,
	AddrLine2 as AddressLine2,
	PostalCode,
	City,
	StateProvince as State_Prov,
	Country,
	s.ST_NAME as Status,
	i.IN_NAME as Industry,
	(CASE WHEN SPrating LIKE 'A%' OR SPrating LIKE 'BBB%' THEN 0 ELSE 1 END) as IsLowGrade
INTO DimCompany
FROM raw.FinwireCompany c, raw.StatusType s, raw.Industry I
WHERE c.Status = s.ST_ID AND c.IndustryID = i.IN_ID;