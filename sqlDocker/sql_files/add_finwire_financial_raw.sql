CREATE TABLE raw.FinwireFinancial (
    PTS NVARCHAR(15),
    RecType NVARCHAR(3),
    Year NVARCHAR(4),
    Quarter NVARCHAR(1),
    QtrStartDate NVARCHAR(8),
    PostingDate NVARCHAR(8),
    Revenue NVARCHAR(17),
    Earnings NVARCHAR(17),
    EPS NVARCHAR(12),
    DilutedEPS NVARCHAR(12),
    Margin NVARCHAR(12),
    Inventory NVARCHAR(17),
    Assets NVARCHAR(17),
    Liabilities NVARCHAR(17),
    ShOut NVARCHAR(13),
    DilutedShOut NVARCHAR(13),
    CoNameOrCIK NVARCHAR(MAX)
);

BULK INSERT raw.FinwireFinancial FROM '/usr/config/data/gendata/Batch1/FIN.csv' WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    KEEPNULLS
);