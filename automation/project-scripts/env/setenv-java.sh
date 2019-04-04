# DON'T RUN THIS.
# You may source it, if $TOOLS_HOME is set: . setenv-java.sh <jdk-tag>
# Best to be sourced from master setenv.sh, not on its own.

# JDK is defined in a script sourced from $TOOLS_HOME/java/defs/JDK_TYPE-def.sh
# with fallback to $PROJECT_ROOT/env/jdk-def.sh.
# Definition script must set ARCHIVE_URL, FINAL_DIR and UNPACK_APP variables.
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
[ -f "$DEF_FILE" ] || DEF_FILE="`dirname $BASH_SOURCE`/../global-tools/java/defs/${JDK_TYPE}-def.sh"

# Convenient fallback to version embedded for the project (not provided here, copy from defs).
# This is not necessary if you can rely on default defs in $TOOLS_HOME/java/defs.
if [[ -z "${1:-}" && ! -f "$DEF_FILE" ]]; then
	echo "Global $DEF_FILE not found, using local fallback..."
	DEF_FILE=`dirname $BASH_SOURCE`/jdk-def.sh
fi

if [[ -f "$DEF_FILE" ]]; then
	echo "Reading definition from $DEF_FILE"
	# unsetting ARCHIVE_SUM in case definition file does not have it
	unset ARCHIVE_SUM

	. "$DEF_FILE"
	# this is important to export for all other tools, e.g. Gradle
	export JAVA_HOME="$JAVA_TOOLS/$FINAL_DIR"

	echo "JAVA_HOME: $JAVA_HOME"

	# installing Java if missing
	if [[ ! -f "$JAVA_HOME/bin/java" ]]; then
		(
			mkdir -p "$JAVA_TOOLS"
			cd "$JAVA_TOOLS"
			echo "Downloading Java to provide: $JAVA_HOME"
			TMP_ARCHIVE="jdk.tmp"
			wget -cqO ${TMP_ARCHIVE} ${ARCHIVE_URL}

			if [[ -n "${ARCHIVE_SUM:-}" ]]; then
				FILE_SUM=`${ARCHIVE_SUM_APP} ${TMP_ARCHIVE} | cut -d' ' -f1`
				if [[ "$ARCHIVE_SUM" != "$FILE_SUM" ]]; then
					echo -e "\nChecksum failed for downloaded archive\nExpected: $ARCHIVE_SUM\nDownload: $FILE_SUM\n"
					echo "Keeping invalid $JAVA_TOOLS/${TMP_ARCHIVE} for inspection. Remove it before trying again."
					exit 1
				fi
			fi
			${UNPACK_APP} ${TMP_ARCHIVE} ${ARCHIVE_UNPACK_APP_TAIL_OPTS:-}
			rm ${TMP_ARCHIVE}
		)
	fi

	if [[ -n "${RUN_TOOL_VERSION:-}" ]]; then
		"$JAVA_HOME/bin/java" -version
	fi
else
	echo "ERROR: Requested JDK version $JDK_TYPE, but no $DEF_FILE found!"
	false
fi
