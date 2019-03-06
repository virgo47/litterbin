# Faster setup of new Windows

Start with Chocolatey package system - in *administrative* cmd:
```
@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))"
```

All the following commands are with `cmd` syntax (e.g. `"` instead of `'`).
By default Chocolatey downloads into TEMP directory, which results in repeated downloads, when
you experiment a lot with the same package. You may point it to a specific directory like this:
```
choco config set cacheLocation "c:\ProgramData\Chocolatey\tmp-cache"
```
Also [see here](https://github.com/chocolatey/choco/wiki/How-To-Change-Cache). As a result
you have to take care of the directory and maybe clean it up sometimes. You can also pack this
cache directory and move it elsewhere to do offline installation.
(!) TODO: check how this works, because [there is more to it](http://stackoverflow.com/questions/18528919/how-to-install-chocolatey-packages-offline).

To allow packages without checksums (avoiding prompt every time):
```
choco feature enable -n allowEmptyChecksums
```

To find out what is installed using Chocolatey, use `choco list -l` or shortcut `clist -l`.
Without `-l` it prints all available packages. Using `clist -li` prints also applications
that are not installed using Chocolatey, but could have been.

We can install and download virtually any other favourite tool (lines with `#` comments run
in PowerShell/Boxstarter Shell, in `cmd` you need to strip the end and replace `'` with `"`
as needed):
```
cinst -y classic-shell
cinst -y firefox
cinst -y notepad2
cinst -y notepadreplacer -installarguments "/notepad=C:\Progra~1\Notepad2\Notepad2.exe /verysilent"
cinst -y TotalCommander
cinst -y rapidee
cinst -y GoogleChrome
cinst -y FoxitReader
cinst -y k-litecodecpackfull
cinst -y foobar2000
cinst -y gimp
cinst -y fsviewer
cinst -y imagemagick
```
Classic Shell set to Aero, small icons.

Developer's tools mandatory:
```
cinst -y git
cinst -y ConEmu
cinst -y putty
cinst -y winscp
cinst -y 7zip.commandline
cinst -y unzip
cinst -y vim
```

Other tools for virtualization and other experiments:
```
cinst -y virtualbox
cinst -y vagrant
cinst -y packer
```

Programming (`ghc` is haskell):
```
cinst -y StrawberryPerl
cinst -y ruby
cinst -y ghc
```

The rest:
```
cinst -y Handle
cinst -y procexp
cinst -y gpg4win-light
cinst -y tortoisesvn
cinst -y openvpn-community
cinst -y licecap
cinst -y nodejs-lts

REM instal WinPcap in advance manually, seems the chocolatey package is broken
cinst -y wireshark
```

We can install various GnuWin32 packages:
```
cinst -y gnuwin32-coreutils.install
cinst -y gnuwin32-grep.install
cinst -y gnuwin32-sed.install
```

**But instead** we can use existing Git and add `c:\Program Files\Git\usr\bin` and
`c:\Program Files\Git\mingw64\bin` to the `PATH` (especially the first one).

## ConEmu settings and tips

* Go to Settings `Win+Alt+P`
* In **Keys & Macro**:
	* Global hotkey for *Minimize/Restore* `` Ctrl+` `` collides with IDEA, change to `<None>`
(using `Win+2` anyway).
	* Switch to previous/next console change to `Alt+Left/Right`
	* Open new console popup is `Win+N` (good)
	* Scroll buffer one page up/down - change to `Shift+PgUp/Dn` (`Ctrl` by default) 
	* In **Keyboard** subscreen uncheck **Win+Number - activate console**.
* In **Features** check **Inject ConEmuHk** to support colors in shells properly
* Settings XML can be placed next to `conemu.exe` and will be loaded instead of registry
* Set it [as default term] (even if we run `cmd` from Start it will use ConEmu). Go to
**Integration**, **Default term** and check first checkboxes (Force..., Register..., Leave in TSA).
To support `cmd` in ConEmu from Total Commander as well, change the list of hooked executables to:
`explorer.exe|totalcmd.exe` (add more at will).

### Problem - Pin to task bar for Admin

If we pin `powershell` (or `cmd.exe`) to the task bar, it will start in ConEmu, but if we change
its properties **Shortcut/Advanced...** and check **Run as administrator** it will not use ConEmu
anymore. On the other hand, if we add `-new_console:a` after the command in **Shortcut**,
**Target** input field it runs as Admin - but it creates new taskbar icon not on the same position
(e.g. I can't use `Win+2` to switch to it, instead it creates new tab with new Admin PowerShell).

Better solution is to use shortcut with target
`"c:\Program Files\ConEmu\ConEmu64.exe" powershell.exe -new_console:a` (ConEmu location with
Chocolatey installation, probably default as well) **and** set **Run as administrator** via
shortcut (advanced) settings.

If we prefer `cmd.exe` instead, just use that instead of `powershell.exe`.

TODO: How to script this?

### Problem - refresh of environment variables

Because any terminal window is attached to the existing ConEmu, not even `Win`, `cmd`, **Enter**
will create a command line with current environment variables after change. We have to close all
existing console tabs first, restart the ConEmu completely and then see the result.

To try it we can start `ConEmu64.exe -nosingle` which forces new window and process. After that
all the new consoles open there and the old ones can be closed at our leisure.


## Setting PATH and other environment variables permanently

SETX is the command that should handle it, `/M` tells it to use system environment, not local one.
```
SETX /M JAVA_HOME "c:\Program Files\Java\jdk1.8.0_92"
```

TODO: Is it possible ot use other variable in PATH? How to display unexpanded variable string?


## Problem: Windows 10 and sticky corners on dual monitor

Could have been solved in Windows 8.1 with registry trick, not anymore. Microsoft screwed big time.


## Problem: Blurry fonts on dual monitor

Set both monitors to the same size of font (typically it is 125% on the notebook and 100% on
external monitor, 125% is rather too much for the monitor, so 100% is better for both).


## Problem: `Ctrl+Alt+F8` resets monitors

This combo also collides with IDEA. It's used by *Intel HD Graphics Control Panel Service* and
cannot be disabled (unlike other shortcuts of that service). The whole service can be disabled
as [described here](http://stackoverflow.com/a/35109007/658826).


## Git Bash Here in Total Commander

Based on [my blog](https://virgo47.wordpress.com/2013/05/05/git-bash-here-in-console2-in-total-commander-with-keyboard-shortcut-hotkey/)
where it is for Console2 - this time for ConEmu.
Setup for user command in Total Commander is (as found in `AppData\Roaming\GHISLER\usercmd.ini`):

```
[em_git_bash_here]
button=C:\Program Files\Git\git-bash.exe
cmd=""C:\Program Files\ConEmu\ConEmu64.exe""
param=/cmd {Git bash}
menu=Git Bash Here
```

This counts on existing ConEmu task called "Git bash", so I recommend setting tasks first.

Older version with `-run` that stopped working suddenly, `/cmd` seems to work better now
(but even better/easier with ConEmu task as above):

```
[em_git_bash_here]
button=C:\Program Files\Git\git-bash.exe
cmd=""C:\Program Files\ConEmu\ConEmu64.exe""
param=-run "C:\Program Files\Git\git-bash.exe" --no-cd --command=usr/bin/bash.exe -l -i
menu=Git Bash Here
```

`-run` is important otherwise every space separated parameter would be interpreted as a new
console and using quotes around everything wouldn't work either.

Then also add this to `wincmd.ini`
in the same directory like `usercmd.ini` (both `Alt+B` and `Ctrl+B` launch Git Bash):

```
[Shortcuts]
C+B=em_git_bash_here
A+B=em_git_bash_here
```