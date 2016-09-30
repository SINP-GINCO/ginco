#!/bin/bash
# Dumping script

#export some variables for auth
export PGHOST=localhost
export PGPORT=5432
export PGUSER=admin
#TODO: Adapt password !
export PGPASSWORD=YOURPASSWORD

today="$(date +'%d-%m-%Y')"
db=sinp
backup_dir="/home/user/db_backups"
filename=${backup_dir}/db_${today}.dump

if [ ! -d "$backup_dir" ]; then
  mkdir ${backup_dir}
fi

echo "Saving wait..."
pg_dump --format=c  ${db} > ${filename}
echo
echo "Database saved under ${filename}, to restore it use  pg_restore -d ${db} ${filename}"

