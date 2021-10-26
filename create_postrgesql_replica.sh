#!/bin/bash

PG_VERSION=12
PG_MASTER_HOST=db
PG_MASTER_HOST_PORT=5432
PG_REPLICATION_USER=repluser
PG_REPLICATION_USER_PASSWORD=password
PG_DATA_DIRECTORY=/var/lib/pgsql


# Stop postgresql
systemctl stop postgresql-${PG_VERSION}.service

# CLean postgresql data directory
rm -rf $PG_DATA_DIRECTORY/$PG_VERSION/data/*

# Create pgpass
sudo su - postgres -c "echo $PG_MASTER_HOST:$PG_MASTER_HOST_PORT:*:$PG_REPLICATION_USER:$PG_REPLICATION_USER_PASSWORD > .pgpass"
sudo su - postgres -c "chmod 600 .pgpass"

# Copy database from master
sudo su - postgres -c "pg_basebackup -h $PG_MASTER_HOST -p $PG_MASTER_HOST_PORT -U $PG_REPLICATION_USER -D $PG_DATA_DIRECTORY/$PG_VERSION/data --checkpoint=fast --wal-method=fetch

# Create recovery.conf for old postgresql
if [ $PG_VERSION -lt 12 ]; then
    sudo su - postgres -c "echo trigger_file = $PG_DATA_DIRECTORY/$PG_VERSION/data/trigger_file >> $PG_DATA_DIRECTORY/$PG_VERSION/data/recovery.conf"
fi

# Start postgresql
systemctl start postgresql-${PG_VERSION}.service
