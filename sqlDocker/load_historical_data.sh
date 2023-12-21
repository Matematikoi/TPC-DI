#!/bin/sh

# Adds priority dimension tables
echo ADDING DATE DIMENSION
echo ADDING TIME DIMENSION
echo ADDING BROKER DIMENSION
echo ADDING COMPANY DIMENSION
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_date_time_broker_company_historical.sql
# Adds Tax Rate
echo ADDING TAX RATE
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_tax_rate_historical.sql
# Adds HR
echo ADDING HR
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_hr_historical.sql
# Adds Industry
echo ADDING INDUSTRY
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_industry_historical.sql
# Adds Status Type
echo ADDING STATUS TYPE
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_status_type_historical.sql
# Adds more dimensions
echo ADDING SECURITY DIMENSION
echo ADDING TRADE DIMENSION
echo ADDING FINANCIAL
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_financial_trade_security_historical.sql
# Adds Trade Type
echo ADDING TRADE TYPE
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_trade_type_historical.sql
# Adds DimCustomer History
echo ADDING Dim Customer
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_customer_dim_historical.sql
# Adds Fact Watches History
echo ADDING FACT WATCHES
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_fact_watches_historical.sql
