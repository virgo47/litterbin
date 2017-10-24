# Setup of new bash

## Switching Java versions

Switching between Java versions (JAVA_HOME and PATH) with jx macros with `~/.profile`:
```
JAVA6_HOME=/c/PROGRA~2/Java/JDK16~1.0_4
JAVA7_HOME=/c/PROGRA~2/Java/JDK17~1.0_7
JAVA8_HOME=/c/PROGRA~1/Java/JDK18~1.0_1
JAVA9_HOME=/c/PROGRA~1/Java/JDK-9
ZULU9_HOME=/c/work/tools/ZULU90~1.0-W

function fixpath() {
  PATH=`echo $PATH |
    sed -e "s%/c/PROGRA~./Java/JDK[^:]*%$JAVA_HOME/bin%g" \
      -e "s%/c/work/tools/ZULU[^:]*%$JAVA_HOME/bin%g"`
  echo "Current JAVA_HOME=$JAVA_HOME"
  java -version
}

function j6() {
  JAVA_HOME=$JAVA6_HOME
  fixpath
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
  JAVA_HOME=$ZULU9_HOME
  fixpath
}

echo
j8
echo "
Use macros j6/j7/j8/j9/j9z (Zulu) to switch quickly between Javas (JAVA_HOME, PATH)
"
```

This requires that **all those variables have short path (no spaces)** which can be checked
by `dir /x` (on Windows) or even switched in Rapid Environment Editor directly.

## Aliases

My `.bashrc` (can be in `.profile` instead, but I guess there is no harm in `.bashrc`):
```
# Edit Bash RC
alias eb="vim ~/.bashrc && . ~/.bashrc"

# git aliases
alias gl="git lg" # lg is already git alias
alias gs="git status"

# grep aliases
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
        lg = log --format='%C(yellow)%h%Creset %C(magenta)%ad %C(bold cyan)(%an)%Creset %s%C(auto)%d'
        lgg = log --graph --format='%C(yellow)%h%Creset %C(magenta)%ad %C(bold cyan)(%an)%Creset %s%C(auto)%d'
        lu = log @{u}..
```

Global name/email settings can be corporate values for corporate computer, which means that in
each GitHub or other private repo I have to run:

```
git config user.name virgo47
git config user.email virgo47@gmail.com
```