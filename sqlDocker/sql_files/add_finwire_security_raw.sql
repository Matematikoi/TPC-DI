CREATE TABLE raw.FinwireSecurity (
    PTS NVARCHAR(15),
    RecType NVARCHAR(3),
    Symbol NVARCHAR(15),
    IssueType NVARCHAR(6),
    Status NVARCHAR(4),
    Name NVARCHAR(70),
    ExID NVARCHAR(6),
    ShOut NVARCHAR(13),
    FirstTradeDate NVARCHAR(8),
    FirstTradeExchg NVARCHAR(8),
    Dividend NVARCHAR(12),
    CoNameOrCIK NVARCHAR(60)
);

BULK INSERT raw.FinwireSecurity FROM '/usr/config/data/gendata/Batch1/SEC.csv' WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    KEEPNULLS
);