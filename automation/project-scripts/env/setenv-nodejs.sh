# DON'T RUN THIS.
# You may source it, if $TOOLS_HOME is set (use "" for project node-version):
# . setenv-nodejs.sh [node-version|""] [npm-version]
# Best to be sourced from master setenv.sh, not on its own.

NODE_VERSION=${1:-$PROJECT_NODE}
NPM_VERSION=${2:-$PROJECT_NPM}

type -t cygpath &> /dev/null && TOOLS_HOME=`cygpath "$TOOLS_HOME"`

# Node.js part
export NODE_TOOLS="$TOOLS_HOME/nodejs"

# determine DEF_FILE for Node
DEF_FILE="$NODE_TOOLS/defs/${NODE_VERSION}-def.sh"

# You may remove this section after this file is copied into project.
# It is here to allow various Node installations without defs in user's $TOOLS_HOME.
[ -f "$DEF_FILE" ] || DEF_FILE="`dirname $BASH_SOURCE`/../global-tools/node/defs/${NODE_VERSION}-def.sh"

if [[ -z "${1:-}" && ! -f "$DEF_FILE" ]]; then
	echo "Global $DEF_FILE not found, using local fallback..."
	DEF_FILE=`dirname $BASH_SOURCE`/nodejs-def.sh
fi

_OS="${OSTYPE//[0-9.-]*/}"

if [[ -f "$DEF_FILE" ]]; then
	echo "Reading definition from $DEF_FILE"
	# unsetting ARCHIVE_SUM in case definition file does not have it
	unset ARCHIVE_SUM

	. "$DEF_FILE"
	export NODE_HOME="${NODE_TOOLS}/${FINAL_DIR}"

	# On Windows there is no bin directory, on Linux/Mac there is
	NODE_BIN=${NODE_HOME}/bin
	[[ "$_OS" == "msys" ]] && NODE_BIN=${NODE_HOME}

	if [[ ! -f "$NODE_BIN/node" ]]; then
		(
			mkdir -p "$NODE_TOOLS"
			cd "$NODE_TOOLS"
			echo "Downloading Node.js to provide version: $NODE_VERSION"
			TMP_ARCHIVE="nodejs.tmp"
			wget -cqO ${TMP_ARCHIVE} ${ARCHIVE_URL}

			if [[ -n "${ARCHIVE_SUM:-}" ]]; then
				FILE_SUM=`${ARCHIVE_SUM_APP} ${TMP_ARCHIVE} | cut -d' ' -f1`
				if [[ "$ARCHIVE_SUM" != "$FILE_SUM" ]]; then
					echo -e "\nChecksum failed for downloaded archive\nExpected: $ARCHIVE_SUM\nDownload: $FILE_SUM\n"
					echo "Keeping invalid $NODE_TOOLS/${TMP_ARCHIVE} for inspection. Remove it before trying again."
					exit 1
				fi
			fi
			${UNPACK_APP} ${TMP_ARCHIVE} ${ARCHIVE_UNPACK_APP_TAIL_OPTS:-}
			rm ${TMP_ARCHIVE}
		)
	fi

	export NODE="$NODE_BIN/node"
	echo "NODE_HOME: $NODE_HOME"

	if [[ -n "${RUN_TOOL_VERSION:-}" ]]; then
		echo "Node version: `${NODE} -v`"
	fi
else
	echo "ERROR: Requested Node.js version ${NODE_VERSION}, but no ${DEF_FILE} found!"
	false
fi

# NPM part
export NPM_TOOLS="$TOOLS_HOME/npm"

# determine DEF_FILE for NPM
export NPM_HOME="${NPM_TOOLS}/npm-v${NPM_VERSION}"
NPM_BIN="${NPM_HOME}"/bin
NPM_CLI="${NPM_HOME}/lib/node_modules/npm/bin/npm-cli.js"
# On Windows there paths are different
if [[ "$_OS" == "msys" ]]; then
	NPM_BIN="${NPM_HOME}"
	NPM_CLI="${NPM_HOME}/node_modules/npm/bin/npm-cli.js"
fi

if [[ ! -f "$NPM_BIN/npm" ]]; then
	echo "Installing required Npm version ${NPM_VERSION}..."
	( PATH=${NODE_BIN}:$PATH ; ${NODE_BIN}/npm install -g --prefix ${NPM_HOME} npm@${NPM_VERSION} )
fi

export NPM="$NODE $NPM_CLI"
echo "NPM_HOME: $NPM_HOME"
if [[ -n "${RUN_TOOL_VERSION:-}" ]]; then
	echo "Npm version: `${NPM} -v`"
fi

if [[ -d "$NODE_BIN" && -d "$NPM_HOME" ]]; then
	# TODO: set path to project's node_modules as needed
	ADDITIONAL_PATH="$PROJECT_ROOT/app/ui/node_modules/.bin:$NPM_BIN:$NODE_BIN"
	if [[ "$PATH" != *"$ADDITIONAL_PATH"* ]]; then
		echo "Adding Node/Npm and node_modules/.bin to PATH"
		PATH=${ADDITIONAL_PATH}:$PATH
	fi
else
	echo "ERROR: Node.js/Npm environment is not set up properly!"
	false
fi
