#!/bin/bash
# This is an ultimate universal build script - the goal is total build reproducibility.
# For Jenkins, we need one Build step of type "Execute shell" with command: bash build.sh
# For GitLab .gitlab-ci.yml from the project root is used.
#
# Developer can also run this instead of ./gradlew, arguments will be passed to gradlew.
# This script includes env/setenv.sh, that sets environment + downloads missing tools.
#
# In general: Hardly enything needs to be set on the build server except for:
# - $HOME/.gradle/gradle.properties with Nexus access must be set up.
# See doc/devel/rozbehanie.adoc for details.
#
# Be default runs CI build "clean build ...etc" Gradle tasks with --no-daemon flag,
# unless other list is provided as arguments (in that case daemon is used by default).

set -eu
set -o pipefail

cd "$(dirname "$0")"
# sets PROJECT_ROOT, TOOLS_HOME, ... and exports JAVA_HOME, NODE_HOME, and others
. env/setenv.sh

# setenv should not change current working dir, but just to be sure we set it
cd "$PROJECT_ROOT"

echo "Executing Gradle Wrapper in $PWD"
bash gradlew ${@:---console=plain --warning-mode all --stacktrace --no-daemon clean build ..etc}
