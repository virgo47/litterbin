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
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu14.28.21-ca-jdk14.0.1-win_x64.zip
		FINAL_DIR=zulu14.28.21-ca-jdk14.0.1-win_x64
		ARCHIVE_SUM=9cb078b5026a900d61239c866161f0d9558ec759aa15c5b4c7e905370e868284
		ARCHIVE_SUM_APP=sha256sum
		UNPACK_APP=unzip
		;;

	linux)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu14.28.21-ca-jdk14.0.1-linux_x64.tar.gz
		FINAL_DIR=zulu14.28.21-ca-jdk14.0.1-linux_x64
		ARCHIVE_SUM=48bb8947034cd079ad1ef83335e7634db4b12a26743a0dc314b6b861480777aa
		ARCHIVE_SUM_APP=sha256sum
		UNPACK_APP="tar xzvf"
		;;

	darwin)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu14.28.21-ca-jdk14.0.1-macosx_x64.tar.gz
		FINAL_DIR=zulu14.28.21-ca-jdk14.0.1-macosx_x64
		ARCHIVE_SUM=088bd4d0890acc9f032b738283bf0f26b2a55c50b02d1c8a12c451d8ddf080dd
		ARCHIVE_SUM_APP="shasum -a 256"
		UNPACK_APP="tar xzvf"
		;;
esac
