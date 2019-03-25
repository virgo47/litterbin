# Can be sourced to set up current shell:
# . tools/setenv.sh
# Don't run it as a script as it does not set calling environment.
#
# It reads required tool versions from project's gradle.properties.
# With argument -v it runs the tools to print their versions.

type -t cygpath &> /dev/null && TOOLS_HOME=`cygpath "$TOOLS_HOME"`
export TOOLS_HOME="${TOOLS_HOME:-$HOME/tools}"
echo "TOOLS_HOME: $TOOLS_HOME"

[[ "${1:-}" == "-v" ]] && RUN_TOOL_VERSION="YES"

PROP_FILE=`dirname $BASH_SOURCE`/../gradle.properties

# cut finds the value, xargs trims potential spaces
PROJECT_JDK=`grep 'versionJdk' ${PROP_FILE} | cut -d= -f2 | xargs`
PROJECT_NODE=`grep 'versionNodejs' ${PROP_FILE} | cut -d= -f2 | xargs`
PROJECT_NPM=`grep 'versionNpm' ${PROP_FILE} | cut -d= -f2 | xargs`

. `dirname $BASH_SOURCE`/setenv-java.sh ""
. `dirname $BASH_SOURCE`/setenv-nodejs.sh ""

# Other project settings necessary for build
# ...