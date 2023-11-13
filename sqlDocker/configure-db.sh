#!/bin/bash

sleep 3

# Run the setup script to create the DB and the schema in the DB
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Ih4teMicrosoft# -i setup.sql

echo ======================
echo FINISHED CONFIGURE DB
echo ======================
