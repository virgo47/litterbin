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
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu13.29.9-ca-jdk13.0.2-win_x64.zip
		FINAL_DIR=zulu13.29.9-ca-jdk13.0.2-win_x64
		ARCHIVE_SUM=1fd91cf7720adfa428191b35adb359d24937fc42a09b46421434f73fcb2d9cd5
		ARCHIVE_SUM_APP=sha256sum
		UNPACK_APP=unzip
		;;

	linux)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu13.29.9-ca-jdk13.0.2-linux_x64.tar.gz
		FINAL_DIR=zulu13.29.9-ca-jdk13.0.2-linux_x64
		ARCHIVE_SUM=ecb3f9626a9bc810daeb0f4e7d69474b7ae19fe0634658713e009ca6b1f1be98
		ARCHIVE_SUM_APP=sha256sum
		UNPACK_APP="tar xzvf"
		;;

	darwin)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu13.29.9-ca-jdk13.0.2-macosx_x64.tar.gz
		FINAL_DIR=zulu13.29.9-ca-jdk13.0.2-macosx_x64
		ARCHIVE_SUM=ee86200843b38b263fd547982e99cabb491a3ecf6d9dc8f38f410184fa5012f5
		ARCHIVE_SUM_APP="shasum -a 256"
		UNPACK_APP="tar xzvf"
		;;
esac
