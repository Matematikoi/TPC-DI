#!/bin/sh

# Add raw schema
echo ADDING RAW SCHEMA
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/create_raw_schema.sql
# Add tax rate
echo ADDING TAX RATE
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_tax_rate_raw.sql
# Add trade history
echo ADDING TRADE HISTORY
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_trade_type_raw.sql
# Add Trade
echo ADDING TRADE
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_trade_raw.sql
# Add Customer Mgmt
echo ADDING CUSTOMER MGMT XML
docker exec sqlserver python3 /usr/config/python_scripts/customer_xml.py
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_customer_mgmt_raw.sql

