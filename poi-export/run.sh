#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

# remove existing views so that imposm can clean up the database properly
psql -v ON_ERROR_STOP=1 < drop-tables.sql

# import OSM data into postgis
imposm import \
  -connection postgis://${PGUSER}:${PGPASSWORD}@${PGHOST}/${PGDATABASE} \
  -dbschema-import public \
  -mapping mapping.yml \
  -srid 4326 \
  -read ${DATA_DIR}/${OSM_PBF_FILENAME} \
  -write \
  -overwritecache

# process imported data
psql -v ON_ERROR_STOP=1 < create-tables.sql

# export data to CSV
psql -v ON_ERROR_STOP=1 <<-EOSQL
  \COPY (SELECT * FROM pois_export) TO '${DATA_DIR}/${OUTPUT_FILENAME}' WITH DELIMITER ',' CSV HEADER;
EOSQL

echo 'done.'
