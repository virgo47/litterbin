# Setup of new bash

## Switching Java versions

Switching between Java versions (JAVA_HOME and PATH) with jX macros with `~/.profile`:
```bash
# This script assumes existing environment variables in Windows.
# These MUST have short path format as spaces in JAVA_HOME path are strongly discouraged.

JAVA7_HOME=`cygpath $JAVA7_HOME`
JAVA8_HOME=`cygpath $JAVA8_HOME`
JAVA9_HOME=`cygpath $JAVA9_HOME`
JAVA9ZULU_HOME=`cygpath $JAVA9ZULU_HOME`

function fixpath() {
  PATH=`echo $PATH |
    sed -e "s%/c/PROGRA~./Java/jdk[^:]*%$JAVA_HOME/bin%gI" \
      -e "s%/c/work/tools/zulu[^:]*%$JAVA_HOME/bin%gI"`
  echo "Current JAVA_HOME=$JAVA_HOME"
  java -version
}

function j7() {
  JAVA_HOME=$JAVA7_HOME
  fixpath
}

function j8() {
  JAVA_HOME=$JAVA8_HOME
  fixpath
}

function j9() {
  JAVA_HOME=$JAVA9_HOME
  fixpath
}

function j9z() {
  setjava $JAVA9ZULU_HOME
}

function setjava() {
  JAVA_HOME=$1
  fixpath
}

echo
setjava `cygpath $JAVA_HOME`
echo "
Use macros j7/j8/j9/j9z (Zulu) to switch quickly between Javas (JAVA_HOME, PATH)
"
```

This requires that **all those variables have short path (or at least no spaces)** which can be checked
by `dir /x` (on Windows) or even switched in Rapid Environment Editor directly. This also uses `cygpath`,
but that one is available as part of git bash environment.

## Aliases

My `.bashrc` (can be in `.profile` instead, but I guess there is no harm in `.bashrc`):
```bash
# Edit Bash RC
alias eb="vim ~/.bashrc && . ~/.bashrc"

# git aliases
#
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

# grep aliases
alias gi="grep -i"
alias gr="grep -r"
alias gri="grep -ri"

echo "Aliases set up:"
alias
```

## Git

This is one-off configuration of Git:
```
alias.lg=log --format='%C(yellow)%h%Creset %C(magenta)%ad %C(bold cyan)(%an)%Creset %s%C(auto)%d'
alias.lgg=log --graph --format='%C(yellow)%h%Creset %C(magenta)%ad %C(bold cyan)(%an)%Creset %s%C(auto)%d'
alias.lu=log @{u}..
```

But it can be found in `~/.gitconfig`:
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
