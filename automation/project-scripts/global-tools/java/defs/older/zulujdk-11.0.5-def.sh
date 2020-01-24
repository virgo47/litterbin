#@IgnoreInspection BashAddShebang
# shellcheck shell=bash disable=SC2034,SC1090,SC2164
#
# msys for Windows+Git, linux for Linux or darwin for OSX
case "${OSTYPE//[0-9.-]*/}" in
	msys)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu11.35.15-ca-jdk11.0.5-win_x64.zip
		FINAL_DIR=zulu11.35.15-ca-jdk11.0.5-win_x64
		ARCHIVE_SUM=4404cc26463cdaa2211dce13895e74cc234aae0d5047adcbf15b970f0f3054b7
		ARCHIVE_SUM_APP=sha256sum
		UNPACK_APP=unzip
		;;

	linux)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu11.35.15-ca-jdk11.0.5-linux_x64.tar.gz
		FINAL_DIR=zulu11.35.15-ca-jdk11.0.5-linux_x64
		ARCHIVE_SUM=1f46f59020dc61f8b80bb0fe82cf3f38e515cadc47e1f88f4d504107251e6abc
		ARCHIVE_SUM_APP=sha256sum
		UNPACK_APP="tar xzvf"
		;;

	darwin)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu11.35.15-ca-jdk11.0.5-macosx_x64.tar.gz
		FINAL_DIR=zulu11.35.15-ca-jdk11.0.5-macosx_x64
		ARCHIVE_SUM=a81a79379a4a367e2e26b22bb240a1eb77f45362fe8c532bbf914e39906d8104
		ARCHIVE_SUM_APP="shasum -a 256"
		UNPACK_APP="tar xzvf"
		;;
esac
