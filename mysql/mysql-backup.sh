#!/bin/bash

set -e

MYSQL_USERNAME=${1}
MYSQL_PASSWORD=${2}
SERVER=${3:-'db'}
DATABASE=${4}
FILENAME=${5:-'backup'}
FILE_PATH=${6:-'/opt/backup'}

mysqldump -h ${SERVER} --skip-dump-date --quick --user=${MYSQL_USERNAME} --password=${MYSQL_PASSWORD} ${DATABASE} > ${FILE_PATH}${FILENAME}.sql || { echo "Error: Failed to backup mysql database. Exiting."; exit 1; }

echo "Done backing up the database to a file."
echo "Starting compression..."
tar czf ${FILE_PATH}${FILENAME}.tar.gz ${FILE_PATH}${FILENAME}.sql
echo "Done compressing the backup file."
