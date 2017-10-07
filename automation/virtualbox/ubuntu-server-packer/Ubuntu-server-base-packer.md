Goal: Create VirtualBox image without any interaction

Inspiration: http://kappataumu.com/articles/creating-an-Ubuntu-VM-with-packer.html

What we need:
* Packer JSON configuration.
* [Preseed](https://help.ubuntu.com/lts/installation-guide/armhf/apb.html) file for Ubuntu.

How it works: Packer enters the long boot command that among other things specifies HTTP
server (Packer feature) that will host preseed file.

## Commands to get Vagrant BOX

In this directory, let's run the Packer:
```
packer build -force -var 'iso_url=file:///h:/work/iso-images/ubuntu-17.04-server-amd64.iso' vbox-ubuntu.json
```

Var specification is not necessary, if the path in config JSON matches. Next register the
Vagrant box: 
```
vagrant box add --force ubuntu-server-dev ubuntu-server-virtualbox.box
```

Next go to your Vagrant project directory ("workspace" for the box), create it if needed,
initiate the project and run Vagrant box:
```
cd .../vagrant-projects/ubuntu-server
vagrant init -mf ubuntu-server-dev
vagrant up
```

To get into the box just use:
```
vagrant ssh
```

This technically does something like:
```
ssh vagrant@localhost -p 2222
```


## Various issues

Once the box crashed with UI dialog (from VirtualBox) after `SSH auth method: private key`.
Not sure why, but on another host this did not happen, so perhaps just a glitch. (This happened
more than once, but trying again worked fine, seems to be VirtualBox problem.)


### Open questions

* How does Vagrantfile.template from Packer config relate to Vagrantfile in Vagrant project
directory?