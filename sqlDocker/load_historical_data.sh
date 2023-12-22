#!/bin/sh

START=$(date +%s)


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
# Adds Trade Type
echo ADDING TRADE TYPE
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_trade_type_historical.sql
# Adds DimCustomer History
echo ADDING CUSTOMER DIMENSION
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_customer_dim_historical.sql
# Adds DimAccountHistory
echo ADDING Dim Account
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_account_dim_historical.sql
# Adds more dimensions
echo ADDING SECURITY DIMENSION
echo ADDING TRADE DIMENSION
echo ADDING FINANCIAL
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_financial_trade_security_historical.sql
# Adds Fact Watches History
echo ADDING FACT WATCHES
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_fact_watches_historical.sql
# Adds Fact Holdings
echo ADDING FACT HOLDINGS
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_fact_holdings_historical.sql
# Adds Prospect History
echo ADDING PROSPECT
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_prospect_historical.sql
# Adds Fact Cash Balances
echo ADDING FACT CASH BALANCES
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_fact_cash_balances_historical.sql
# Adds Fact Market History
echo ADDING FACT MARKET HISTORY
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_fact_market_history_historical.sql



END=$(date +%s)
DIFF=$(( $END - $START ))
echo historical_seconds,$DIFF  >> times.txt
