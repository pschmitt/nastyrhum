#!/usr/bin/env bash

DEST=${DEST:-/srv/nastyrhum}

if [[ $EUID -ne 0 ]]
then
    echo "This script requires root privileges" >&2
    exit 2
fi

if [[ -e "$DEST" ]]
then
    echo "Destination directory $DEST is not empty"
    exit 3
fi

# Get the code
if git clone https://github.com/pschmitt/nastyrhum "$DEST" > /dev/null 2>&1
then
    echo "The code has been checked out to $DEST"
else
    echo "Code checkout failed."
    exit 4
fi


# Install the systemd service file (only if running systemd)
if pidof systemd > /dev/null
then
    if cp "$DEST/nastyrhum.service" /etc/systemd/system
    then
        echo "Systemd service installed"
    else
        echo "Failed to install systemd service" >&2
    fi
fi


echo "Setup complete!"
echo
echo "Now please create $DEST/docker-compose.credentials.yml to configure your VPN settings"
echo "# cp -a $DEST/docker-compose.credentials.yml.sample $DEST/docker-compose.credentials.yml"
