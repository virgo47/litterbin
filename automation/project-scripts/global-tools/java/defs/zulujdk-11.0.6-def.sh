#@IgnoreInspection BashAddShebang
# shellcheck shell=bash disable=SC2034,SC1090,SC2164
#
# msys for Windows+Git, linux for Linux or darwin for OSX
case "${OSTYPE//[0-9.-]*/}" in
	msys)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu11.37.17-ca-jdk11.0.6-win_x64.zip
		FINAL_DIR=zulu11.37.17-ca-jdk11.0.6-win_x64
		ARCHIVE_SUM=a9695617b8374bfa171f166951214965b1d1d08f43218db9a2a780b71c665c18
		ARCHIVE_SUM_APP=sha256sum
		UNPACK_APP=unzip
		;;

	linux)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu11.37.17-ca-jdk11.0.6-linux_x64.tar.gz
		FINAL_DIR=zulu11.37.17-ca-jdk11.0.6-linux_x64
		ARCHIVE_SUM=360626cc19063bc411bfed2914301b908a8f77a7919aaea007a977fa8fb3cde1
		ARCHIVE_SUM_APP=sha256sum
		UNPACK_APP="tar xzvf"
		;;

	darwin)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu11.37.17-ca-jdk11.0.6-macosx_x64.tar.gz
		FINAL_DIR=zulu11.37.17-ca-jdk11.0.6-macosx_x64
		ARCHIVE_SUM=e1fe56769f32e2aaac95e0a8f86b5a323da5af3a3b4bba73f3086391a6cc056f
		ARCHIVE_SUM_APP="shasum -a 256"
		UNPACK_APP="tar xzvf"
		;;
esac
