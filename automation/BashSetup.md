# Setup of new bash

## Switching Java versions

Switching between Java versions (`JAVA_HOME` and `PATH`) with `setjava XY` macros in `~/.profile`:
```bash
# This script assumes existing environment variables in Windows.
# These MUST have short path format as spaces in JAVA_HOME path are strongly discouraged.

function setjava() {
  JAVA_HOME_VAR="JAVA${1}_HOME"
  JAVA_HOME_VAL="${!JAVA_HOME_VAR}"
  if [ -z "$JAVA_HOME_VAL" ]; then
    echo "No value set for $JAVA_HOME_VAR"  ci
    return
  fi

  echo "Using $JAVA_HOME_VAR with value $JAVA_HOME_VAL"
  JAVA_HOME="$(cygpath $JAVA_HOME_VAL)"
  TOOLS_HOME="$(cygpath $TOOLS_HOME)"
  # Now to fix PATH to new JAVA_HOME (TOOLS_HOME is defined in environment)
  PATH="$(echo $PATH |                                    
    sed \                                                 
      -e "s%/c/PROGRA~./Java/jdk[^:]*%$JAVA_HOME/bin%gI" \
      -e "s%$TOOLS_HOME/java/[^:]*%$JAVA_HOME/bin%gI")"   
  if ! type -p java &> /dev/null; then
    echo "Adding java to PATH"
    PATH=$JAVA_HOME/bin:$PATH
  fi
  java -version
}

echo "Use macros \"setjava <version>\" to switch between Javas (JAVA_HOME, PATH).
Version number is from JAVA<version>_HOME. Available Javas:"
printenv | grep '^JAVA.*_HOME=' || echo "None? Do something about it!"

echo
if [ -n "$JAVA_HOME" ]; then
  setjava ''
  echo
fi
```

This requires that **all those variables have short path (or at least no spaces)** which can be
checked by `dir /x` (on Windows) or even switched in Rapid Environment Editor directly. This also
uses `cygpath`, but that one is available as part of git bash environment.

## Aliases

My `.bashrc` (can be in `.profile` instead, but I guess there is no harm in `.bashrc`):
```bash
# Edit Bash RC
alias eb="vim ~/.bashrc && . ~/.bashrc"

# git aliases
#
alias gb="git checkout"
alias gbm="git checkout master"
alias gbd="git checkout develop"
# --all to update all tracked branches
alias gp="git pull --all"
# git pull with rebase (this better be default using global config)
alias gpr="git pull --all --rebase"
# git pull but without rebase (overriding pull.rebase=true from config)
alias gpm="git pull --all --no-rebase"
# git pull with rebase and autostash when local changes are in the way
alias gpa="git pull --all --rebase --autostash"
alias gf="git fetch --all"
# lg is already git alias: log with one-line format
alias gl="git lg"
# HEAD and upstream, shows also fetched commits not on local branch
# notice the quoting to avoid early backtick evaluation
alias gll='git lg `git rev-parse --abbrev-ref HEAD @{u}`'
# log not-pushed yet (local, but not in upstream)
alias gu="git lu"
alias gs="git st" # st is already git alias: status -sb (short + branch info)
alias gca="git commit -am"
# commits resolved files after merge using default/prepared merge message
alias gcm="git commit -a --no-edit"

# grep aliases
alias gi="grep -i"
alias gr="grep -r"
alias gri="grep -ri"

# gradle-wrapper-wrapper with plain console output (useful for redirecting)
alias gwp="gw --console plain"

echo "Aliases set up:"
alias
```

## Git

Configuration of Git can be found in `~/.gitconfig`:
```
[user]                              
	name = virgo47
	email = virgo47@gmail.com
[core]
	autocrlf = true
[http]
[log]
	date = format:%Y-%m-%d %H:%M
[alias]
	ll = log --format='%C(yellow)%h%Creset %C(magenta)%ad %C(bold cyan)(%an)%Creset %s%C(auto)%d'
	lg = log --graph --format='%C(yellow)%h%Creset %C(magenta)%ad %C(bold cyan)(%an)%Creset %s%C(auto)%d'
	lu = log @{u}.. --graph --format='%C(yellow)%h%Creset %C(magenta)%ad %C(bold cyan)(%an)%Creset %s%C(auto)%d'
	st = status -sb
[pull]
	rebase = true
```

Global name/email settings can be corporate values for corporate computer, which means that in
each GitHub or other private repo I have to run:

```
git config user.name virgo47
git config user.email virgo47@gmail.com
```
