#!/bin/bash

# Run script to load audit data
echo RUNNING AUDIT DATA LOAD SCRIPT
docker exec sqlserver python3 /usr/config/python_scripts/audit.py
# Add Audit table
echo ADDING AUDIT TABLE
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/add_audit_table.sql
# Performing Tests
echo PERFORMING VALIDATION TESTS
echo
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -d dwh -i sql_files/audit_tests.sql