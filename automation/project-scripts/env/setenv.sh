# Can be sourced to set up current shell (assuming we're in project's root):
# . env/setenv.sh
# Don't run it as a script as it does not set calling environment.
#
# It reads required tool versions from project's gradle.properties.
# With argument -v it runs the tools to print their versions.

export ENV_SCRIPT_DIR=`dirname $BASH_SOURCE`
export PROJECT_ROOT=$( cd ${ENV_SCRIPT_DIR}/.. ; pwd )
echo "PROJECT_ROOT: $PROJECT_ROOT"

type -t cygpath &> /dev/null && TOOLS_HOME=`cygpath "$TOOLS_HOME"`
export TOOLS_HOME="${TOOLS_HOME:-$HOME/tools}"
echo "TOOLS_HOME: $TOOLS_HOME"

[[ "${1:-}" == "-v" ]] && RUN_TOOL_VERSION="YES"

PROP_FILE=$PROJECT_ROOT/gradle.properties

# cut finds the value, xargs trims potential spaces
PROJECT_JDK=`grep 'versionJdk' ${PROP_FILE} | cut -d= -f2 | xargs`
PROJECT_NODE=`grep 'versionNodejs' ${PROP_FILE} | cut -d= -f2 | xargs`
PROJECT_NPM=`grep 'versionNpm' ${PROP_FILE} | cut -d= -f2 | xargs`

. ${ENV_SCRIPT_DIR}/setenv-java.sh ""
. ${ENV_SCRIPT_DIR}/setenv-nodejs.sh ""

# Other project settings necessary for build
# ...