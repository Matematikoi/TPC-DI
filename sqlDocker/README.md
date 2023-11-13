# Docker
Build the docker and then run it. 
To build it use 
```sh
cd sqlDocker
docker build --network host -t sqlserver:2017 .
```

To run the docker use
```sh
docker run --name sqlserver -e "MSSQL_USER=gabriel" -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=Ih4teMicrosoft#" -p 1433:1433 -d sqlserver:2017
```

To kill the docker, you can run 
```sh
```