INSERT INTO DimBroker (IsCurrent,
                       EffectiveDate, 
                       EndDate, 
                       BatchID, 
                       BrokerID, 
                       ManagerID, 
                       FirstName, 
                       LastName,
                       MiddleInitial, 
                       Branch, 
                       Office,
                       Phone)
SELECT 
	1 AS IsCurrent,
	(SELECT MIN(DateValue) FROM DimDate) as EffectiveDate,
	'9999-12-31' AS EndDate,
	1 as BatchID, 
	EmployeeID as BrokerID, 
	ManagerID as ManagerID, 
	EmployeeFirstName as FirstName, 
	EmployeeLastName as LastName, 
	EmployeeMI as MiddleInitial, 
	EmployeeBranch as Branch, 
	EmployeeOffice as Office, 
	EmployeePhone as Phone
FROM raw.HR
WHERE EmployeeJobCode = 314
