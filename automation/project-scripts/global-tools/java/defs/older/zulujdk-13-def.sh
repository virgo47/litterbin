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
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu13.27.9-ca-jdk13-win_x64.zip
		FINAL_DIR=zulu13.27.9-ca-jdk13-win_x64
		ARCHIVE_SUM=b73a14b5136dc0239e3e11a6a15768d51ba89422560f046a40653a95e9c208e8
		ARCHIVE_SUM_APP=sha256sum
		UNPACK_APP=unzip
		;;

	linux)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu13.27.9-ca-jdk13-linux_x64.tar.gz
		FINAL_DIR=zulu13.27.9-ca-jdk13-linux_x64
		ARCHIVE_SUM=539489cb9309941ca940c2c1b3227bb10ad7a788eb89e663a6dc0d8def6efe86
		ARCHIVE_SUM_APP=sha256sum
		UNPACK_APP="tar xzvf"
		;;

	darwin)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu13.27.9-ca-jdk13-macosx_x64.tar.gz
		FINAL_DIR=zulu13.27.9-ca-jdk13-macosx_x64
		ARCHIVE_SUM=620c02559836ebbe42a8ca17e27d5f25261523b5af364cc4c32f21c57398e287
		ARCHIVE_SUM_APP="shasum -a 256"
		UNPACK_APP="tar xzvf"
		;;
esac
