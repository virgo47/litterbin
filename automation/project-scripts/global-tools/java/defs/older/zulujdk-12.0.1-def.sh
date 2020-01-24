#@IgnoreInspection BashAddShebang
# shellcheck shell=bash disable=SC2034,SC1090,SC2164
#
# msys for Windows+Git, linux for Linux or darwin for OSX
case "${OSTYPE//[0-9.-]*/}" in
	msys)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu12.2.3-ca-jdk12.0.1-win_x64.zip
		FINAL_DIR=zulu12.2.3-ca-jdk12.0.1-win_x64
		ARCHIVE_SUM=273d08a3a64844b60863d21803dedc19
		ARCHIVE_SUM_APP=md5sum
		UNPACK_APP=unzip
		;;

	linux)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu12.2.3-ca-jdk12.0.1-linux_x64.tar.gz
		FINAL_DIR=zulu12.2.3-ca-jdk12.0.1-linux_x64
		ARCHIVE_SUM=772a8d0b5f2e610d9061ed448c9221a8
		ARCHIVE_SUM_APP=md5sum
		UNPACK_APP="tar xzvf"
		;;

	darwin)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu12.2.3-ca-jdk12.0.1-macosx_x64.tar.gz
		FINAL_DIR=zulu12.2.3-ca-jdk12.0.1-macosx_x64
		ARCHIVE_SUM=5de94ba7649cc83d42a7528d0739f47d
		ARCHIVE_SUM_APP="md5 -r"
		UNPACK_APP="tar xzvf"
		;;
esac
