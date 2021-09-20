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
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu17.28.13-ca-jdk17.0.0-win_x64.zip
		FINAL_DIR=zulu17.28.13-ca-jdk17.0.0-win_x64
		ARCHIVE_SUM=f4437011239f3f0031c794bb91c02a6350bc941d4196bdd19c9f157b491815a3
		ARCHIVE_SUM_APP=sha256sum
		UNPACK_APP=unzip
		;;

	linux)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu17.28.13-ca-jdk17.0.0-linux_x64.tar.gz
		FINAL_DIR=zulu17.28.13-ca-jdk17.0.0-linux_x64
		ARCHIVE_SUM=37c4f8e48536cceae8c6c20250d6c385e176972532fd35759fa7d6015c965f56
		ARCHIVE_SUM_APP=sha256sum
		UNPACK_APP="tar xzvf"
		;;

esac
