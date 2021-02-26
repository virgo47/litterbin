#@IgnoreInspection BashAddShebang
# shellcheck shell=bash disable=SC2034,SC1090,SC2164
#
# msys for Windows+Git, linux for Linux (darwin is not supported by newer defs)
case "${OSTYPE//[0-9.-]*/}" in
	msys)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu11.45.27-ca-jdk11.0.10-win_x64.zip
		FINAL_DIR=zulu11.45.27-ca-jdk11.0.10-win_x64
		ARCHIVE_SUM=eeae92780eeac4528141be3e0e587e87131430cf5c6b2cc3b6cf1f4f221f04e5
		ARCHIVE_SUM_APP=sha256sum
		UNPACK_APP=unzip
		;;

	linux)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu11.45.27-ca-jdk11.0.10-linux_x64.tar.gz
		FINAL_DIR=zulu11.45.27-ca-jdk11.0.10-linux_x64
		ARCHIVE_SUM=0bd85593bae021314378f3b146cfe36a6c9b0afd964d897c34201034ace3e785
		ARCHIVE_SUM_APP=sha256sum
		UNPACK_APP="tar xzvf"
		;;

esac
