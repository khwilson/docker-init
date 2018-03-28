INSERT INTO tiger.loader_platform(os, declare_sect, pgbin, wget, unzip_command, psql, path_sep,
                                  loader, environ_set_command, county_process_command)
SELECT 'debbie', 'TMPDIR="/gisdata/temp/"
UNZIPTOOL=unzip
WGETTOOL="/usr/bin/wget"
export PGBIN=/usr/lib/postgresql/10/bin
PSQL=${PGBIN}/psql
SHP2PGSQL=shp2pgsql
cd /gisdata', pgbin, wget, unzip_command, psql, path_sep,
       loader, environ_set_command, county_process_command
  FROM tiger.loader_platform
  WHERE os = 'sh';

UPDATE tiger.loader_lookuptables SET load = true WHERE load = false AND lookup_name IN('tract', 'bg', 'tabblock');
