#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE EXTENSION hstore;
EOSQL
