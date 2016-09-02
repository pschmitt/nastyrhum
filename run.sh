#!/usr/bin/env bash

cd $(readlink -f $(dirname "$0"))/docker

case "$1" in
    relative|dev)
        ARG="-f docker-compose.relative-vols.yml"
        shift
        ;;
    help|h|-h|--help)
        echo "Usage $(basename $0) [relative] CMD"
        exit 0
        ;;
esac

[[ "$(uname -m)" == arm* ]] && ARG="$ARG -f docker-compose.armhf.yml"

docker-compose -f docker-compose.yml \
               -f docker-compose.credentials.yml \
               $ARG \
               "$@"
