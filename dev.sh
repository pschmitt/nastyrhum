#!/usr/bin/env sh

docker-compose -f docker-compose.yml -f docker-compose.credentials.yml -f docker-compose.relative-vols.yml "$@"
