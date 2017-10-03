#!/usr/bin/env bash
set -e

docker-compose exec consul consul kv put service/rundeck/config.properties/dataSource.url jdbc:mysql://mysql-rundeck/rundeck?autoReconnect=true
docker-compose exec consul consul kv put service/rundeck/config.properties/dataSource.username rundeck
docker-compose exec consul consul kv put service/rundeck/config.properties/dataSource.password ilikerandomsecrets
docker-compose exec consul consul kv put service/rundeck/config.properties/rundeck.projectsStorageType db
