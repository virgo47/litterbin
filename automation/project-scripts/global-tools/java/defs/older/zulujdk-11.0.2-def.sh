#@IgnoreInspection BashAddShebang
# shellcheck shell=bash disable=SC2034,SC1090,SC2164
#
# msys for Windows+Git, linux for Linux or darwin for OSX
case "${OSTYPE//[0-9.-]*/}" in
	msys)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu11.29.11-ca-jdk11.0.2-win_x64.zip
		FINAL_DIR=zulu11.29.11-ca-jdk11.0.2-win_x64
		ARCHIVE_SUM=c160559d36e9478bd1bd471f4caf33d2
		ARCHIVE_SUM_APP=md5sum
		UNPACK_APP=unzip
		;;

	linux)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu11.29.11-ca-jdk11.0.2-linux_x64.tar.gz
		FINAL_DIR=zulu11.29.11-ca-jdk11.0.2-linux_x64
		ARCHIVE_SUM=06a3df0ff56a1430c1cb8a3d05f1c752
		ARCHIVE_SUM_APP=md5sum
		UNPACK_APP="tar xzvf"
		;;

	darwin)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu11.29.11-ca-jdk11.0.2-macosx_x64.tar.gz
		FINAL_DIR=zulu11.29.11-ca-jdk11.0.2-macosx_x64
		ARCHIVE_SUM=08ca5b03544d7070039859fe2f3b626b
		ARCHIVE_SUM_APP="md5 -r"
		UNPACK_APP="tar xzvf"
		;;
esac
