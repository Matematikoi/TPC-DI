CREATE TABLE raw.Date (
    SK_DateID NUMERIC(11) NOT NULL,
    DateValue CHAR(20) NOT NULL,
    DateDesc CHAR(20) NOT NULL,
    CalendarYearID NUMERIC(4) NOT NULL,
    CalendarYearDesc CHAR(20) NOT NULL,
    CalendarQtrID NUMERIC(5) NOT NULL,
    CalendarQtrDesc CHAR(20) NOT NULL,
    CalendarMonthID NUMERIC(6) NOT NULL,
    CalendarMonthDesc CHAR(20) NOT NULL,
    CalendarWeekID NUMERIC(6) NOT NULL,
    CalendarWeekDesc CHAR(20) NOT NULL,
    DayOfWeekNum NUMERIC(1) NOT NULL,
    DayOfWeekDesc CHAR(10) NOT NULL,
    FiscalYearID NUMERIC(4) NOT NULL,
    FiscalYearDesc CHAR(20) NOT NULL,
    FiscalQtrID NUMERIC(5) NOT NULL,
    FiscalQtrDesc CHAR(20) NOT NULL,
    HolidayFlag NVARCHAR(5)
);

BULK INSERT raw.Date FROM '/usr/config/data/gendata/Batch1/Date.txt' WITH
(
    FIRSTROW = 1,
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '\n',
    KEEPNULLS
)
