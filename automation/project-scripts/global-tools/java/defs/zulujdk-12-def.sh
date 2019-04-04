# msys for Windows+Git, linux for Linux or darwin for OSX
case "${OSTYPE//[0-9.-]*/}" in
	msys)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu12.1.3-ca-jdk12-win_x64.zip
		FINAL_DIR=zulu12.1.3-ca-jdk12-win_x64
		ARCHIVE_SUM=9befe203ca29773ec67661e23ac915cf
		ARCHIVE_SUM_APP=md5sum
		UNPACK_APP=unzip
		;;

	linux)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu12.1.3-ca-jdk12-linux_x64.tar.gz
		FINAL_DIR=zulu12.1.3-ca-jdk12-linux_x64
		ARCHIVE_SUM=ac440ed1afb02ba30c7820df8aaa1b37
		ARCHIVE_SUM_APP=md5sum
		UNPACK_APP="tar xzvf"
		;;

	darwin)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu12.1.3-ca-jdk12-macosx_x64.tar.gz
		FINAL_DIR=zulu12.1.3-ca-jdk12-macosx_x64
		ARCHIVE_SUM=bc696d037774eaa3553bc9037fc0dc2e
		ARCHIVE_SUM_APP="md5 -r"
		UNPACK_APP="tar xzvf"
		;;
esac
