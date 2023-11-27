FROM mcr.microsoft.com/mssql/server:2017-latest
# Install essentials
RUN apt update
RUN apt install -y \
    build-essential \
    python3-pip

# Create a config directory
RUN mkdir -p /usr/config
RUN pip3 --no-cache-dir install pandas bs4 lxml

WORKDIR /usr/config

# Bundle config source
COPY . /usr/config

# Grant permissions for to our scripts to be executable
RUN chmod +x /usr/config/entrypoint.sh
RUN chmod +x /usr/config/configure-db.sh

ENTRYPOINT ["./entrypoint.sh"]
