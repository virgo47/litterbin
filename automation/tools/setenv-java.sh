# DON'T RUN THIS.
# You may source it, if $TOOLS_HOME is set: . setenv-java.sh <jdk-tag>
# Best to be sourced from master setenv.sh, not on its own.

# JDK is defined in a script sourced from $TOOLS_HOME/java/defs/JDK_TYPE-def.sh
# with fallback to $PROJECT_DIR/tools/jdk-def.sh.
# Definition script must set JDK_URL, JDK_DIR and UNPACK_APP variables.
# UNPACK_APP (containing necessary options) will be run in $JAVA_TOOLS
# to unpack jdk.tmp file.

# You can use setenv-java.sh to set/install other JDK/SDK version, but Gradle
# build will still complain, if you use the wrong JDK version.
JDK_TYPE=${1:-$PROJECT_JDK}

type -t cygpath &> /dev/null && TOOLS_HOME=`cygpath "$TOOLS_HOME"`
export JAVA_TOOLS="$TOOLS_HOME/java"

# determine DEF_FILE
DEF_FILE="$JAVA_TOOLS/defs/${JDK_TYPE}-def.sh"

# You may remove this section after this file is copied into project.
# It is here to allow various JDK installations without defs in user's $TOOLS_HOME.
[ -f "$DEF_FILE" ] || DEF_FILE="`dirname $BASH_SOURCE`/java/defs/${JDK_TYPE}-def.sh"

# Convenient fallback to version embedded for the project (not provided here, copy from defs).
# This is not necessary if you can rely on default defs in $TOOLS_HOME/java/defs.
if [[ -z "${1:-}" && ! -f "$DEF_FILE" ]]; then
	echo "Global $DEF_FILE not found, using local fallback..."
	DEF_FILE=`dirname $BASH_SOURCE`/jdk-def.sh
fi

if [[ -f "$DEF_FILE" ]]; then
	echo "Reading JDK definition from $DEF_FILE"
	. "$DEF_FILE"
	# this is important to export for all other tools, e.g. Gradle
	export JAVA_HOME="$JAVA_TOOLS/$JDK_DIR"

	echo "JAVA_HOME: $JAVA_HOME"

	# installing Java if missing
	if [[ ! -f "$JAVA_HOME/bin/java" ]]; then
		(
			echo "UNPACK_APP: $UNPACK_APP"
			mkdir -p "$JAVA_TOOLS"
			cd "$JAVA_TOOLS"
			echo "Downloading Java to provide: $JAVA_HOME"
			wget -cqO jdk.tmp ${JDK_URL}

			if [[ -n "${JDK_SUM:-}" ]]; then
				FILE_SUM=`${JDK_SUM_APP} jdk.tmp | cut -d' ' -f1`
				echo ${FILE_SUM}
				if [[ "$JDK_SUM" != "$FILE_SUM" ]]; then
					echo -e "\nChecksum failed for downloaded JDK\nExpected: $JDK_SUM\nDownload: $FILE_SUM\n"
					echo "Keeping invalid $JAVA_TOOLS/jdk.tmp for inspection. Remove it before trying again."
					exit 1
				fi
			fi
			${UNPACK_APP} jdk.tmp ${ARCHIVE_UNPACK_APP_TAIL_OPTS:-}
			rm jdk.tmp
		)
	fi

	if [[ -n "${RUN_TOOL_VERSION:-}" ]]; then
		"$JAVA_HOME/bin/java" -version
	fi
else
	echo "ERROR: Requested JDK version $JDK_TYPE, but no $DEF_FILE found!"
fi
