#!/bin/sh

set -e

if [ -z "$1" ]; then
	packer build -force vbox-ubuntu.json
else
	packer build -force -var iso_url="$1" vbox-ubuntu.json
fi

vagrant box add --force ubuntu-server-dev ubuntu-server-virtualbox.box

echo << EOF
DONE!

Now head to your vagrant project directory and use it:
cd .../vagrant-projects/ubuntu-server
vagrant init -mf ubuntu-server-dev
vagrant up
vagrant ssh
EOF