#@IgnoreInspection BashAddShebang
# shellcheck shell=bash disable=SC2034,SC1090,SC2164
#
# THIS IS NOT IMMUTABLE DEFINITION FILE, don't use it to enforce fixed version.
#
# See setenv-java.sh and tool-download.sh for the details how this is used.
# We use Zulu JDK from: https://www.azul.com/downloads/zulu-community
# For each platform you choose proper format (plain archive, not installer),
# copy the download link, change the final dir (for Zulu it's archive name without extension),
# change expected checksum (and check its format) and you're done.
#
# msys for Windows+Git, linux for Linux or darwin for OSX
case "${OSTYPE//[0-9.-]*/}" in
	msys)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu16.28.11-ca-jdk16.0.0-win_x64.zip
		FINAL_DIR=zulu16.28.11-ca-jdk16.0.0-win_x64
		ARCHIVE_SUM=6cbf98ada27476526a5f6dff79fd5f2c15e2f671818e503bdf741eb6c8fed3d4
		ARCHIVE_SUM_APP=sha256sum
		UNPACK_APP=unzip
		;;

	linux)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu16.28.11-ca-jdk16.0.0-linux_x64.tar.gz
		FINAL_DIR=zulu16.28.11-ca-jdk16.0.0-linux_x64
		ARCHIVE_SUM=236b5ea97aff3cb312e743848d7efa77faf305170e41371a732ca93c1b797665
		ARCHIVE_SUM_APP=sha256sum
		UNPACK_APP="tar xzvf"
		;;

esac
