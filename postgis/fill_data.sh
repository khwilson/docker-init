#!/bin/bash

set -e
set -x

export PGHOST=pgdb
export PGPORT=5432
export PGUSER=postgres
export PGPASSWORD=apassword
export PGDATABASE=postgres

mkdir -p /gisdata/temp
psql -f add_data.sql
psql -c "SELECT Loader_Generate_Nation_Script('debbie')" -tA > /gisdata/nation_script_load.sh

cd /gisdata
cat nation_script_load.sh
. nation_script_load.sh

for ST in 'MD' 'DC' 'VA'; do
  psql -c "SELECT Loader_Generate_Script(ARRAY['${ST}'], 'debbie')" -tA > /gisdata/loader.sh
  cd /gisdata
  sed 's/tiger_staging.'$ST'_tabblock /tiger_staging.'$ST'_tabblock10 /' loader.sh > loader_all.sh
  . loader_all.sh  
done

psql -f cleanup.sql
