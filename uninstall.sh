#!/usr/bin/env bash

DEST=$(readlink -f $(dirname "$0"))

rm -irf "$DEST" /etc/systemd/system/nastyrhum.service
