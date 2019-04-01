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
cinst -y slack
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
cinst -y tortoisesvn
cinst -y wget
cinst -y jq
cinst -y cloc
```

Other tools for virtualization and other experiments:
```
cinst -y virtualbox
cinst -y vagrant
cinst -y packer
```

Greenshot, first [disable PrintScreen key in OneDrive](https://superuser.com/a/1239937): 
```
cinst -y greenshot
```

Programming (`ghc` is haskell):
```
cinst -y StrawberryPerl
cinst -y ruby
cinst -y ghc
cinst -y python3
```

With Python 3 (and PIP) we can install HTTPie *in non-admin shell*:
```
pip install --upgrade pip setuptools httpie
```

The rest:
```
cinst -y processhacker
cinst -y ditto
cinst -y gpg4win-light
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

## Installing fonts

Source * Pro fonts by Adobe, `svn` command necessary to avoid manual download.
Uses SVN trick to download subdirectory of GitHub project (`--force` needed if directory exists).
Go to some temporary/download directory and:
```
svn export https://github.com/adobe-fonts/source-sans-pro/branches/release/TTF
svn export --force https://github.com/adobe-fonts/source-serif-pro/branches/release/TTF
svn export --force https://github.com/adobe-fonts/source-code-pro/branches/release/TTF
```

After that open `TTF` folder, select all, right-click, install fonts.


## More Windows settings

### Wallpapers and logon screen

* Right-click on the desktop , Personalize
* **Background** section, **Background** select to **Slideshow** and choose the directory with my wallpapers (perhaps directly from OneDrive?)
* **Lock screen** section, choose a picture and check **Show lock screen background picture on the sign-in screen**.
* **Colors** section, switch of **Transparency effects**.

### Disable snap assist, autocorrect...

* **Settings** (`Win+I`), **System**, **Multitasking** section, toggle off **When I snap a window...**

* **Settings** (`Win+I`), **Devices**, **Typing** section, toggle off both **Autocorrect/Highlight misspelled...**
(This should, but does not help with Skype autocorrect, not even in versions that don't have other
options to turn it off.
Still better to have it off.)

### Firefox setup

Most things can be set from `about:config` URL (see parentheses, valid for Firefox 65):

* Toolbar right-click, Customize... add search bar (`browser.search.widget.inNavBar = true`)
* Options:
	* Ask to save logins and passwords for websites OFF (`signon.rememberSignons = false`)
	* Show search suggestions in address bar results OFF (`browser.urlbar.suggest.searches = false`)
	* Restore previous session (`browser.startup.page = 3`)
* More about:config (NTLM/Windows SSO + certificates):
	* `security.enterprise_roots.enabled = true`
	* `network.automatic-ntlm-auth.trusted-uris = company.com,hostnames-without-domain`
	* `network.negotiate-auth.trusted-uris = ...`


## ConEmu settings and tips

Best thing is to export settings from previous computer and import XML on the new one.

What I typically change:

* Go to Settings `Win+Alt+P`
* In **General**:
	* **Choose your startup task...** select - for me it's **Git bash**.
	* 
* In **Keys & Macro**:
	* Global hotkey for *Minimize/Restore* `` Ctrl+` `` collides with IDEA, change to `<None>`
(using `Win+2` anyway).
	* Switch to previous/next console change to `Alt+Left/Right`
	* Open new console popup is `Win+N` (good)
	* Scroll buffer one page up/down - change to `Shift+PgUp/Dn` (`Ctrl` by default) 
	* In **Keyboard** subscreen uncheck **Win+Number - activate console**.
* In **Features** check **Inject ConEmuHk** to support colors in shells properly.
* Settings XML can be placed next to `conemu.exe` and will be loaded instead of registry.
* Set it [as default term] (even if we run `cmd` from Start it will use ConEmu).
Go to **Integration**, **Default term** and check first checkboxes (Force..., Register..., Leave in TSA).
To support `cmd` in ConEmu from Total Commander as well, change the list of hooked executables to:
`explorer.exe|totalcmd.exe` (add more at will).
* In **Startup**/**Tasks**:
	* Choose your favourite task (e.g. **Git bash**) and set it as default for new console,
	and/or set some **Hotkey** for it (e.g. `Alt+B`).


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

Better yet is to copy `usercmd/wincmd.ini` from old computer/backup to a new one.

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