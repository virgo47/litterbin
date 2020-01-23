#@IgnoreInspection BashAddShebang
# shellcheck shell=bash disable=SC2034,SC1090,SC2164
#
# msys for Windows+Git, linux for Linux or darwin for OSX
case "${OSTYPE//[0-9.-]*/}" in
	msys)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu12.3.11-ca-jdk12.0.2-win_x64.zip
		FINAL_DIR=zulu12.3.11-ca-jdk12.0.2-win_x64
		ARCHIVE_SUM=7b5c7d74e6abc38dfcd4b157f37c9faf9ec359008770c48e6e2f76eae435ac4e
		ARCHIVE_SUM_APP=sha256sum
		UNPACK_APP=unzip
		;;

	linux)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu12.3.11-ca-jdk12.0.2-linux_x64.tar.gz
		FINAL_DIR=zulu12.3.11-ca-jdk12.0.2-linux_x64
		ARCHIVE_SUM=660cacbed777b5f9048b1a2d6640422ca5921eddea086bc62cb78e9e453ae994
		ARCHIVE_SUM_APP=sha256sum
		UNPACK_APP="tar xzvf"
		;;

	darwin)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu12.3.11-ca-jdk12.0.2-macosx_x64.tar.gz
		FINAL_DIR=zulu12.3.11-ca-jdk12.0.2-macosx_x64
		ARCHIVE_SUM=46f1804b34e0474f0d2dd9079989d3527630fcecf343e071a218f51d4db7ab58
		ARCHIVE_SUM_APP="shasum -a 256"
		UNPACK_APP="tar xzvf"
		;;
esac
