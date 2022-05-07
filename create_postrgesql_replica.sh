#!/bin/bash

# on PG_MASTER_HOST
# create replication user
# sudo su - postgres -c "psql CREATE USER $PG_REPLICATION_USER WITH REPLICATION ENCRYPTED PASSWORD '$PG_REPLICATION_USER_PASSWORD';"
# add to pg_hba.conf
# host replication $PG_REPLICATION_USER $PG_REPLICATION_HOST_ADDRESS md5

PG_VERSION=11
PG_MASTER_HOST=db65
PG_MASTER_HOST_PORT=5432
PG_REPLICATION_USER=replication
PG_REPLICATION_USER_PASSWORD=password
PG_DATA_DIRECTORY=/var/lib/pgsql

systemctl stop postgresql-${PG_VERSION}.service

rm -rf $PG_DATA_DIRECTORY/$PG_VERSION/data/*

sudo su - postgres -c "echo $PG_MASTER_HOST:$PG_MASTER_HOST_PORT:*:$PG_REPLICATION_USER:$PG_REPLICATION_USER_PASSWORD > .pgpass"
sudo su - postgres -c "chmod 600 .pgpass"

sudo -iu postgres pg_basebackup -h $PG_MASTER_HOST -p $PG_MASTER_HOST_PORT -U $PG_REPLICATION_USER -D $PG_DATA_DIRECTORY/$PG_VERSION/data --checkpoint=fast --wal-method=fetch -R -P -w

echo -e "trigger_file = '$PG_DATA_DIRECTORY/$PG_VERSION/data/trigger_file'" >> $PG_DATA_DIRECTORY/$PG_VERSION/data/recovery.conf

systemctl start postgresql-${PG_VERSION}.service
