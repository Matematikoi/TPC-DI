CREATE TABLE raw.HR    (
    EmployeeID NUMERIC(11) NOT NULL,
    ManagerID NUMERIC(11) NOT NULL,
    EmployeeFirstName CHAR(30) NOT NULL,
    EmployeeLastName CHAR(30) NOT NULL,
    EmployeeMI CHAR(1),
    EmployeeJobCode NUMERIC(3) ,
    EmployeeBranch CHAR(30),
    EmployeeOffice CHAR(10),
    EmployeePhone CHAR(14)

 );

 BULK INSERT raw.HR FROM '/usr/config/data/gendata/Batch1/HR.csv' WITH
 (
     FIRSTROW = 1,
     FIELDTERMINATOR = ',',
     ROWTERMINATOR = '\n',
     KEEPNULLS
 )