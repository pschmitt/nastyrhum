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
echo "SETUP"
read -rp "VPN Provider: " vpn_provider
read -rp "VPN Account Username: " vpn_username
read -rsp "VPN Account Password: " vpn_password; echo
read -rp "VPN Exit Point: " vpn_exit_point

sed "s|\(OPENVPN_PROVIDER\)=.*|\1=$vpn_provider|;
     s|\(OPENVPN_CONFIG\)=.*|\1=$vpn_exit_point|;
     s|\(OPENVPN_USERNAME\)=.*|\1=$vpn_username|;
     s|\(OPENVPN_PASSWORD\)=.*|\1=$vpn_password|" \
     "$DEST/docker-compose.credentials.yml.sample" > \
     "$DEST/docker-compose.credentials.yml"

echo
echo "Setup complete! All what's left to do is start the service:"
echo "# systemctl start nastyrhum.service"
echo
echo "You can edit your credentials here: $DEST/docker-compose.credentials.yml"
