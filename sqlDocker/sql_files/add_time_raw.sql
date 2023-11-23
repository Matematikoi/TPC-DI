CREATE TABLE raw.Time (
    SK_TimeID NUMERIC(11) Not Null,
    TimeValue CHAR(20) Not Null,
    HourID NUMERIC(2) Not Null,
    HourDesc CHAR(20) Not Null,
    MinuteID NUMERIC(2) Not Null,
    MinuteDesc CHAR(20) Not Null,
    SecondID NUMERIC(2) Not Null,
    SecondDesc CHAR(20) Not Null,
    MarketHoursFlag NVARCHAR(5) ,
    OfficeHoursFlag NVARCHAR(5)
);

BULK INSERT raw.Time FROM '/usr/config/data/gendata/Batch1/Time.txt' WITH
(
    FIRSTROW = 1,
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '\n',
    KEEPNULLS
)
