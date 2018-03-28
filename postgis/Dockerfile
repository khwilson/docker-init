FROM mdillon/postgis:10

RUN apt-get update && apt-get install -y wget unzip zip

COPY add_data.sql /add_data.sql
COPY fill_data.sh /fill_data.sh
