Goal: Create VirtualBox image without any interaction

Inspiration: http://kappataumu.com/articles/creating-an-Ubuntu-VM-with-packer.html

What we need:
* Packer JSON configuration.
* [Preseed](https://help.ubuntu.com/lts/installation-guide/armhf/apb.html) file for Ubuntu.

How it works: Packer enters the long boot command that among other things specifies HTTP
server (is it Packer feature?) that will host preseed file.