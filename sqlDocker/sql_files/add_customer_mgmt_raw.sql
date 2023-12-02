CREATE TABLE raw.CustomerMgmt (
    ActionType CHAR(9),
    ActionTS DATETIME,
    Account_CA_NAME CHAR(50),
    Account_CA_B_ID CHAR(30),
    CA_ID CHAR(100),
    CA_TAX_ST NUMERIC(1),
    TaxInfo_C_NAT_TX_ID CHAR(4),
    TaxInfo_C_LCL_TX_ID CHAR(4),
    ContactInfo_C_PHONE_1_C_EXT CHAR(15),
    ContactInfo_C_PHONE_1_C_LOCAL CHAR(15),
    ContactInfo_C_PHONE_1_C_AREA_CODE CHAR(15),
    ContactInfo_C_PHONE_1_C_CTRY_CODE CHAR(15),
    ContactInfo_C_PHONE_2_C_EXT CHAR(15),
    ContactInfo_C_PHONE_2_C_LOCAL CHAR(15),
    ContactInfo_C_PHONE_2_C_AREA_CODE CHAR(15),
    ContactInfo_C_PHONE_2_C_CTRY_CODE CHAR(15),
    ContactInfo_C_PHONE_3_C_EXT CHAR(15),
    ContactInfo_C_PHONE_3_C_LOCAL CHAR(15),
    ContactInfo_C_PHONE_3_C_AREA_CODE CHAR(15),
    ContactInfo_C_PHONE_3_C_CTRY_CODE CHAR(15),
    ContactInfo_C_ALT_EMAIL CHAR(50),
    ContactInfo_C_PRIM_EMAIL CHAR(50),
    Address_C_CTRY CHAR(24),
    Address_C_STATE_PROV CHAR(20),
    Address_C_CITY CHAR(25),
    Address_C_ZIPCODE CHAR(12),
    Address_C_ADLINE2 CHAR(80),
    Address_C_ADLINE1 CHAR(80),
    Name_C_M_NAME CHAR(1),
    Name_C_F_NAME CHAR(20),
    Name_C_L_NAME CHAR(25),
    C_ID CHAR(10),
    C_TAX_ID CHAR(20),
    C_GNDR CHAR(1),
    C_TIER NUMERIC(1),
    C_DOB DATETIME
)


BULK INSERT raw.CustomerMgmt FROM '/usr/config/data/gendata/Batch1/CustomerMgmtParsed.csv' WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    KEEPNULLS
)