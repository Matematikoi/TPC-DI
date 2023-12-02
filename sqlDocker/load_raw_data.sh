#!/bin/sh

# Add raw schema
echo ADDING RAW SCHEMA
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/create_raw_schema.sql
# Add tax rate
echo ADDING TAX RATE
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_tax_rate_raw.sql
#Add time
echo ADDING TIME
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_time_raw.sql
#Add date
echo ADDING DATE
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_date_raw.sql
#Add daily market
echo ADDING DAILY MARKET
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_daily_market_raw.sql
#Add cash transaction
echo ADDING CASH TRANSACTION
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_cash_transaction_raw.sql
# Add trade type
echo ADDING TRADE TYPE
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_trade_type_raw.sql
# Add watch history
echo ADDING WATCH HISTORY
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_watch_history_raw.sql
# Add finwire files
echo ADDING FINWIRE FILES
docker exec sqlserver python3 /usr/config/python_scripts/finwire_parsing.py
# Add company finwire
echo ADDING COMPANY FINWIRE
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_finwire_company_raw.sql
# Add financial finwire
echo ADDING FINANCIAL FINWIRE
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_finwire_financial_raw.sql
# Add security finwire
echo ADDING SECURITY FINWIRE
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_finwire_security_raw.sql
# Add Trade
echo ADDING TRADE
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_trade_raw.sql
# Add Customer Mgmt
echo ADDING CUSTOMER MGMT XML
docker exec sqlserver python3 /usr/config/python_scripts/customer_xml.py
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_customer_mgmt_raw.sql

