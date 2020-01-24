#@IgnoreInspection BashAddShebang
# shellcheck shell=bash disable=SC2034,SC1090,SC2164
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
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu8.42.0.23-ca-jdk8.0.232-win_x64.zip
		FINAL_DIR=zulu8.42.0.23-ca-jdk8.0.232-win_x64
		ARCHIVE_SUM=b30fdb828f0990bf9245447205e9f2ac0ebca6ca6feffb353414c74e6f14207f
		ARCHIVE_SUM_APP=sha256sum
		UNPACK_APP=unzip
		;;

	linux)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu8.42.0.23-ca-jdk8.0.232-linux_x64.tar.gz
		FINAL_DIR=zulu8.42.0.23-ca-jdk8.0.232-linux_x64
		ARCHIVE_SUM=e6a9d177933d45f9f1d38bf14e098b5a3fe4806d9efb549066d1cfb4b03fe56f
		ARCHIVE_SUM_APP=sha256sum
		UNPACK_APP="tar xzvf"
		;;

	darwin)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu8.42.0.23-ca-jdk8.0.232-macosx_x64.tar.gz
		FINAL_DIR=zulu8.42.0.23-ca-jdk8.0.232-macosx_x64
		ARCHIVE_SUM=7f6a554df83d4043744443534284216ffeae3d9907b5adedc8cf23dd36ab70fa
		ARCHIVE_SUM_APP="shasum -a 256"
		UNPACK_APP="tar xzvf"
		;;
esac
