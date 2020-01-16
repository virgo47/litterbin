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
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu8.44.0.9-ca-jdk8.0.242-win_x64.zip
		FINAL_DIR=zulu8.44.0.9-ca-jdk8.0.242-win_x64
		ARCHIVE_SUM=c4c14a122078f277d1d89b25a2a9f874e4b1859b6a892c01afdb445969e1dd0b
		ARCHIVE_SUM_APP=sha256sum
		UNPACK_APP=unzip
		;;

	linux)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu8.44.0.9-ca-jdk8.0.242-linux_x64.tar.gz
		FINAL_DIR=zulu8.44.0.9-ca-jdk8.0.242-linux_x64
		ARCHIVE_SUM=7731f08723cac4ad3d5e2fab4e80b275577ecf07a174033fdda5fc8bdaddaeea
		ARCHIVE_SUM_APP=sha256sum
		UNPACK_APP="tar xzvf"
		;;

	darwin)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu8.44.0.9-ca-jdk8.0.242-macosx_x64.tar.gz
		FINAL_DIR=zulu8.44.0.9-ca-jdk8.0.242-macosx_x64
		ARCHIVE_SUM=5855443780e71f3b74cdd6f644010abb9c3be7c185474f0ecaedd5271be46f63
		ARCHIVE_SUM_APP="shasum -a 256"
		UNPACK_APP="tar xzvf"
		;;
esac
