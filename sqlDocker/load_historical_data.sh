#!/bin/sh

# Adds Tax Rate
echo ADDING TAX RATE
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_tax_rate_historical.sql

echo ADDING HOLDING 
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_holding_history_historical.sql

echo ADDING HR
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_hr_historical.sql

echo ADDING INDUSTRY
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_industry_historical.sql

echo ADDING PROSPECT
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_prospect_historical.sql

echo ADDING STATUS TYPE
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_status_type_historical.sql
#Adds Daily Market
echo ADDING DAILY MARKET
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_daily_market_historical.sql
#Adds Cash Transaction
echo ADDING CASH TRANSACTION
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_cash_transaction_historical.sql
# Adds Trade Type
echo ADDING TRADE TYPE
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_trade_type_historical.sql
# Adds Watch History
echo ADDING WATCH HISTORY
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_watch_history_historical.sql
