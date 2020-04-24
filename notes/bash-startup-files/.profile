# This script assumes existing environment variables in Windows.
# These MUST have short path format as spaces in JAVA_HOME path are strongly discouraged.

# tag::setjava[]
function setjava() {
  if [ -z "$1" ]; then
    echo "Version number is from JAVA<version>_HOME. Available Javas:"
    printenv | egrep '^JAVA[^_]+_HOME=' || echo "None? Do something about it!"
    return
  fi
  JAVA_HOME_VAR="JAVA${1}_HOME"
  JAVA_HOME_VAL="${!JAVA_HOME_VAR}"
  if [ -z "$JAVA_HOME_VAL" ]; then
    echo "No value set for $JAVA_HOME_VAR"
    return
  fi

  echo "Using $JAVA_HOME_VAR with value $JAVA_HOME_VAL"
  export JAVA_HOME="$(cygpath $JAVA_HOME_VAL)"
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

echo "Use macros \"setjava <version>\" to switch between Javas (JAVA_HOME, PATH)."
setjava ''

echo
if [ -n "$JAVA_HOME" ]; then
  echo "Using predefined JAVA_HOME"
  java -version
  echo
fi
# end::setjava[]

alias http='winpty http'
