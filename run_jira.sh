#!/usr/bin/env bash

# https://registry.hub.docker.com/u/blacklabelops/jira/

docker run --name postgresql -d \
  -e 'PSQL_TRUST_LOCALNET=true' \
  -e 'DB_USER=jiradb' \
  -e 'DB_PASS=jellyfish' \
  -e 'DB_NAME=jiradb' \
  -p 5432:5432 \
  sameersbn/postgresql:9.4-1

docker run -it --link postgresql:postgres --rm postgres sh -c 'exec psql -h "$POSTGRES_PORT_5432_TCP_ADDR" -p "$POSTGRES_PORT_5432_TCP_PORT" -U postgres'

docker run -d --name jira \
    -e "DATABASE_URL=postgresql://jiradb@postgresql/jiradb" \
    -e "DB_PASSWORD=jellyfish"  \
    --link postgresql:postgresql \
    -p 8100:8080 blacklabelops/jira
