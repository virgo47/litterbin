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
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu15.29.15-ca-jdk15.0.2-win_x64.zip
		FINAL_DIR=zulu15.29.15-ca-jdk15.0.2-win_x64
		ARCHIVE_SUM=248ac29af98216610582652a628c16025da427f069a920abd1cef705e90f8781
		ARCHIVE_SUM_APP=sha256sum
		UNPACK_APP=unzip
		;;

	linux)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu15.29.15-ca-jdk15.0.2-linux_x64.tar.gz
		FINAL_DIR=zulu15.29.15-ca-jdk15.0.2-linux_x64
		ARCHIVE_SUM=be8ce1322bc8ded00374bd6ae1b9127d9b3547ccf526b7609bd63cdc49ac58bd
		ARCHIVE_SUM_APP=sha256sum
		UNPACK_APP="tar xzvf"
		;;

  # what about ARM?
	darwin)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu15.29.15-ca-jdk15.0.2-macosx_x64.tar.gz
		FINAL_DIR=zulu15.29.15-ca-jdk15.0.2-macosx_x64
		ARCHIVE_SUM=2a54122297c050caab353dfd8125286db75d25c8629574c056ec824c074f3958
		ARCHIVE_SUM_APP="shasum -a 256"
		UNPACK_APP="tar xzvf"
		;;
esac
