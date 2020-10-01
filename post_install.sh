#!/bin/sh

# The latest version of UniFi:
VERSION=$(curl -Ls http://www.ui.com/downloads/unifi/debian/dists/stable/ubiquiti/binary-amd64/Packages.gz | zcat | grep Version: | grep -Eo '[0-9\.]+' | head -n 1)
UNIFI_SOFTWARE_URL="https://dl.ubnt.com/unifi/${VERSION}/UniFi.unix.zip"

# Add the fstab entries apparently required for OpenJDKse:
if [ $(grep -c fdesc /etc/fstab) -eq 0 ]; then
  echo -n "Adding fdesc filesystem to /etc/fstab..."
  echo -e "fdesc\t\t\t/dev/fd\t\tfdescfs\trw\t\t0\t0" >> /etc/fstab
  echo " done."
fi

if [ $(grep -c proc /etc/fstab) -eq 0 ]; then
  echo -n "Adding procfs filesystem to /etc/fstab..."
  echo -e "proc\t\t\t/proc\t\tprocfs\trw\t\t0\t0" >> /etc/fstab
  echo " done."
fi

# Run mount to mount the two new filesystems:
echo -n "Mounting new filesystems..."
/sbin/mount -a
echo " done."

# Switch to a temp directory for the Unifi download:
cd `mktemp -d -t unifi`

# Download the controller from Ubiquiti (assuming acceptance of the EULA):
echo -n "Downloading the UniFi controller software..."
fetch ${UNIFI_SOFTWARE_URL}
echo " done."

# Unpack the archive into the /usr/local directory:
echo -n "Installing UniFi controller in /usr/local..."
unzip -o UniFi.unix.zip -d /usr/local
echo " done."

# Update Unifi's symbolic link for mongod to point to the version we just installed:
echo -n "Updating mongod link..."
ln -sf /usr/local/bin/mongod /usr/local/UniFi/bin/mongod
echo " done."

# Fix permissions so it'll run
chmod u+x /etc/rc.d/unifi
sysrc -f /etc/rc.conf unifi_enable="YES"

# Start it up:
echo -n "Starting the unifi service..."
service unifi start
echo " done."

echo "Unifi successfully installed" > /root/PLUGIN_INFO