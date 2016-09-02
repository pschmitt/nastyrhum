# nastyrhum

This repo holds everything needed to run on a NAS.

## Installation

Step 1: Review the content of `install.sh`

Step 2:

```bash
curl -sSL "https://raw.githubusercontent.com/pschmitt/nastyrhum/master/install.sh" | sudo bash
```

To install to another directory than the default (`/srv/nastyrhum`) you can use
the `DEST` environment variable:

```bash
DEST=/tmp/ntr ./install.sh
```

Similarly you can skip the setup by setting `SKIP_SETUP`:

```bash
SKIP_SETUP=1 DEST=/tmp/ntr ./install.sh
```

## ARM

ARM uses other, ARMhf specific images. Confer `docker-compose.armhf.yml`

### NFS Server

On the Raspberry Pi one needs to install some dependencies for the NFS server to
work:

```bash
apt install nfs-kernel-server
modprobe nfs nfsd
```

FIXME: Is the `modprobe` call necessary? Isn't a reboot enough? ie. do these
kernel modules get loaded automatically?
