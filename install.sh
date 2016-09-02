#!/usr/bin/env bash

DEST=${DEST:-/srv/nastyrhum}
CREDENTIALS_FILE="${DEST}/docker/docker-compose.credentials.yml"

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
# if pidof systemd > /dev/null
if [[ -e /etc/systemd/system ]]
then
    if cp "$DEST/nastyrhum.service" /etc/systemd/system
    then
        # Edit the service file if required
        if [[ "$DEST" != /srv/nastyrhum ]]
        then
            sed -i "s|/srv/nastyrhum|$DEST|g" /etc/systemd/system/nastyrhum.service
        fi
        echo "The systemd service has been installed (nastyrhum.service)"
    else
        echo "Failed to install systemd service" >&2
    fi
fi

echo
echo "Setup complete! All what's left to do is configure the vpn and start the service:"
echo
echo "Adjust the credentials here: $CREDENTIALS_FILE"
echo "NOTE: There is a sample config at ${CREDENTIALS_FILE}.sample"
echo
echo "To start the service:"
echo "# systemctl start nastyrhum.service"
echo
