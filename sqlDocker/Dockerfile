FROM mcr.microsoft.com/mssql/server:2017-latest

# Install essentials
RUN apt update
RUN apt install -y build-essential python3 python3-pip

# Create a config directory
RUN mkdir -p /usr/config
WORKDIR /usr/config

# Bundle config source
COPY . /usr/config

# Install Python dependencies
RUN pip3 install --no-cache-dir pandas

# Copy the Python script inside Docker
COPY finwire_parsing.py /usr/config/data/gendata/

# Grant permissions for our scripts to be executable
RUN chmod +x /usr/config/entrypoint.sh
RUN chmod +x /usr/config/configure-db.sh

ENTRYPOINT ["./entrypoint.sh"]

