# Vagrant And VirtualBox Troubleshooting

In general, in case of strange glitches and unexpected behavior, the best strategy seems to be
**reinstall/upgrade VirtualBox and restart the computer** before doing any other investigation.

## Vagrant/VBox works in a single shell

After `vagrant up` Vagrant with VirtualBox starts without problem.
The trouble is that `vagrant ssh` is not working from another shell.

**Questions:** Is this caused by ConEmu? NO.
I couldn't find any indication or significant SET (environment) difference.
Even "manual" ssh works just fine, the process obviously runs and repeated `vagrant up` crashes
from another shell (but indicates box already being up in the original one).

Problem is that even `VBoxManage list runningvms` shows no running VMs although `list vms` shows
the same VM like in the working shell.

**Solution:** It seems like something (Windows Update?) messed with VirtualBox and it needs to
be reinstalled.
Updating Chocolatey packages related to VirtualBox (and Vagrant in the process) and computer
restart helped to solve the problem.


## Handy commands

* **Manual SSH** into the box.
Need to figure out the IP:port which can be localhost:2222 (redirected) or `guest:22` where guest
is IP of the virtual machine (if reachable from host).
The final command may look like this:
    ```
    ssh -p 2222 -i .vagrant/machines/default/virtualbox/private_key \
      -l vagrant -o StrictHostKeyChecking=no localhost
    ```

* ...