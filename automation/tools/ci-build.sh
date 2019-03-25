#!/bin/bash
# This is an ultimate CI build script - the goal is total build reproducibility.
# For Jenkins, we need one Build step of type "Execute shell" with command: bash ci-build.sh
# For GitLab .gitlab-ci.yml from the project root is used.
#
# It downloads required Java if missing, see tools/setenv-java.sh for details.
# See tools/setenv.sh for details about environment.
# In general: Hardly enything needs to be set on the build server except for:
# - $HOME/.gradle/gradle.properties with Nexus access must be set up.
# See doc/devel/rozbehanie.adoc for details.
#
# Be default runs "clean build dist" Gradle tasks, unless other list is provided as arguments.

set -eu
set -o pipefail

cd `dirname $0`
PROJECT_ROOT=`pwd`
echo "PROJECT_ROOT: $PROJECT_ROOT"

# sets JDK_TYPE, TOOLS_HOME, ... and exports JAVA_HOME
. tools/setenv.sh

cd "$PROJECT_ROOT"

echo "Executing Gradle Wrapper in `pwd`"
bash gradlew --console=plain --no-daemon --warning-mode all --stacktrace ${*:-clean build dist}
