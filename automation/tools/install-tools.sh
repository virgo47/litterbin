#!/bin/bash
# Install missing tools, notably JDK based on requirements from tools/setenv.sh.
# Prints nothing if everything is OK.
#
# JDK is checked under $TOOLS_HOME/java directory, TOOLS_HOME defaults to $HOME/tools
# (see setenv.sh for more).
#
# This script requires basic shell utils plus following programs:
# wget for JDK download (must be on PATH, e.g. via Chocolatey on Windows)
# unzip (Windows+Git) or GNU tar (Linux/OSX) for JDK installation (based on UNPACK_APP)
set -eu
set -o pipefail

if [ ! -f "$JAVA_HOME/bin/java" ]; then
	mkdir -p "$JAVA_TOOLS"
	cd "$JAVA_TOOLS"
	echo "Downloading Java to provide: $JAVA_HOME"
	wget -cqO jdk.tmp $JDK_URL

	if [ -n "${JDK_SUM:-}" ]; then
		FILE_SUM=`$JDK_SUM_APP jdk.tmp | cut -d' ' -f1`
		echo $FILE_SUM
		if [ "$JDK_SUM" != "$FILE_SUM" ]; then
			echo -e "\nChecksum failed for downloaded JDK\nExpected: $JDK_SUM\nDownload: $FILE_SUM\n"
			echo "Keeping invalid $JAVA_TOOLS/jdk.tmp for inspection. Remove it before trying again."
			exit 1
		fi
	fi
	$UNPACK_APP jdk.tmp
	rm jdk.tmp
else
	echo
	echo "Already installed..."
fi
"$JAVA_HOME/bin/java" -version