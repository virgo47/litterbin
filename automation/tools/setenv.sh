# Can be sourced to set up current shell.
# Don't run it as a script as it does not set calling environment.
# It contains required Java version "tag", but this can be changed.
#
# JDK is defined in a script sourced from $TOOLS_HOME/defs/JDK_TYPE-def.sh with fallback to
# $PROJECT_DIR/tools/jdk-def.sh.
# Definition script must set JDK_URL, JDK_DIR and UNPACK_APP variables.
# UNPACK_APP (containing necessary options) will be run in $JAVA_TOOLS to unpack jdk.tmp file,
# see $PROJECT_DIR/tools/install-tools.sh for more.

# put project JDK version here
PROJECT_JDK_TYPE=zulujdk-11.0.2
JDK_TYPE=${1:-$PROJECT_JDK_TYPE}

export TOOLS_HOME="${TOOLS_HOME:-$HOME/tools}"
export JAVA_TOOLS="$TOOLS_HOME/java"

type -t cygpath &> /dev/null && TOOLS_HOME=`cygpath "$TOOLS_HOME"`

DEF_FILE="$JAVA_TOOLS/defs/${JDK_TYPE}-def.sh"

# You may remove this section after this file is copied into project.
# It is here to allow various JDK installations without defs in user's $TOOLS_HOME.
[ -f "$DEF_FILE" ] || DEF_FILE="`dirname $BASH_SOURCE`/java/defs/${JDK_TYPE}-def.sh"

# Convenient fallback to version embedded for the project (not provided here, copy from defs).
# This is not necessary if you can rely on default defs in $TOOLS_HOME/java/defs.
LOCAL_DEF_FILE="`dirname $BASH_SOURCE`/jdk-def.sh"

if [ -f "$DEF_FILE" ]; then
	echo "Using definition file: $DEF_FILE"
	. "$DEF_FILE"
elif [ -z "${1:-}" -a -f "$LOCAL_DEF_FILE" ]; then
	echo "Global $DEF_FILE not found, using local fallback..."
	. "$LOCAL_DEF_FILE"
	# you can use install-tools.sh to install other JDK/SDK version, but Gradle build will still
	# complain, if you use the wrong JDK version
else
	echo "Requested JDK version $JDK_TYPE, but no $DEF_FILE found!"
fi

if [ -n "$JDK_DIR" ]; then
  export JAVA_HOME="$JAVA_TOOLS/$JDK_DIR"

  echo "TOOLS_HOME: $TOOLS_HOME"
  echo "JAVA_HOME: $JAVA_HOME"

  export JDK_URL
  export JDK_SUM
  export UNPACK_APP
  export JDK_SUM_APP

  bash tools/install-tools.sh ${JDK_TYPE}

  # Other project settings necessary for build
  # TODO this probably should go to master setenv, while the rest goes to new setenv-jdk.sh or so
else
  echo "Nothing installed, JDK not defined properly!"
fi