#@IgnoreInspection BashAddShebang
# shellcheck shell=bash disable=SC2034,SC1090,SC2164
#
# msys for Windows+Git, linux for Linux or darwin for OSX
case "${OSTYPE//[0-9.-]*/}" in
	msys)
		ARCHIVE_URL=https://nodejs.org/download/release/v10.15.1/node-v10.15.1-win-x64.zip
		FINAL_DIR=node-v10.15.1-win-x64
		ARCHIVE_UNPACK_APP=unzip
		;;

	linux)
		ARCHIVE_URL=https://nodejs.org/download/release/v10.15.1/node-v10.15.1-linux-x64.tar.gz
		FINAL_DIR=node-v10.15.1-linux-x64
		ARCHIVE_UNPACK_APP="tar xzvf"
		;;

	darwin)
		ARCHIVE_URL=https://nodejs.org/download/release/v10.15.1/node-v10.15.1-darwin-x64.tar.gz
		FINAL_DIR=node-v10.15.1-darwin-x64
		ARCHIVE_UNPACK_APP="tar xzvf"
		;;
esac
