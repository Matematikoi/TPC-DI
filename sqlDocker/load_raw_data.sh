#!/bin/sh

# Add raw schema
echo ADDING RAW SCHEMA
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/create_raw_schema.sql
# Add tax rate
echo ADDING TAX RATE
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_tax_rate_raw.sql
# Add trade type
echo ADDING TRADE TYPE
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_trade_type_raw.sql
# Add watch history
echo ADDING WATCH HISTORY
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_watch_history_raw.sql
# Add company finwire
echo ADDING COMPANY FINWIRE
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_finwire_company_raw.sql
# Add financial finwire
echo ADDING FINANCIAL FINWIRE
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_finwire_financial_raw.sql
# Add security finwire
echo ADDING SECURITY FINWIRE
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_finwire_security_raw.sql
