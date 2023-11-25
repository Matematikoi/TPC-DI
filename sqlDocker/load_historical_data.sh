#!/bin/sh

# Adds Tax Rate
echo ADDING TAX RATE
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_tax_rate_historical.sql
# Adds Trade Type
echo ADDING TRADE TYPE
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_trade_type_historical.sql
# Adds Watch History
echo ADDING WATCH HISTORY
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_watch_history_historical.sql
