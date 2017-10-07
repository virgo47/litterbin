#!/bin/bash

set -e

echo "Executing global root script"

echo "Machine build with packer on `date`" > /packer.log

# Updating and Upgrading dependencies
apt-get update -y -qq > /dev/null
apt-get upgrade -y -qq > /dev/null

# Install necessary libraries for guest additions and Vagrant NFS Share
apt-get -y -q install linux-headers-$(uname -r) build-essential dkms nfs-common
# Install guest additions
mkdir /tmp/isomount/
mount -t iso9660 -o loop,ro /home/vagrant/VBoxGuestAdditions_*.iso /tmp/isomount/
# We want to ignore exit status as it typically is not 0 even when it's OK
/tmp/isomount/VBoxLinuxAdditions.run ||:
umount /tmp/isomount
rm -f /home/vagrant/VBoxGuestAdditions_*.iso

# Install necessary dependencies
apt-get -y -q install curl wget git tmux vim

# Setup sudo to allow no-password sudo for "admin"
groupadd -r admin
usermod -a -G admin vagrant
cp /etc/sudoers /etc/sudoers.orig
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=admin' /etc/sudoers
sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers

# Installing Docker
curl -fsSL get.docker.com | sudo sh
usermod -aG docker vagrant
