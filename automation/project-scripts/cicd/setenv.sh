#@IgnoreInspection BashAddShebang
# shellcheck shell=bash disable=SC2034,SC1090,SC2164
#
# Can be sourced to set up current shell (assuming we're in project's root):
# . cicd/setenv.sh
# Don't run it as a script as it does not set calling environment.
#
# It reads required tool versions from project's gradle.properties.
# With argument -v it runs the tools to print their versions.

PROJECT_JDK=zulujdk-12.0.1
PROJECT_NODE=10.15.1
PROJECT_NPM=6.8.0

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." ; pwd)"
echo "PROJECT_ROOT: $PROJECT_ROOT"
export PROJECT_ROOT

type -t cygpath &> /dev/null && TOOLS_HOME="$(cygpath "$TOOLS_HOME")"
export TOOLS_HOME="${TOOLS_HOME:-$HOME/tools}"
echo "TOOLS_HOME: $TOOLS_HOME"

[[ "${1:-}" == "-v" ]] && RUN_TOOL_VERSION="YES"

. "$PROJECT_ROOT"/cicd/setenv-java.sh ""
. "$PROJECT_ROOT"/cicd/setenv-nodejs.sh ""

# Other project settings necessary for build
# ...
