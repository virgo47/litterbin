# msys for Windows+Git, linux for Linux or darwin for OSX
case "${OSTYPE//[0-9.-]*/}" in
	msys)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu8.36.0.1-ca-jdk8.0.202-win_x64.zip
		FINAL_DIR=zulu8.36.0.1-ca-jdk8.0.202-win_x64
		ARCHIVE_SUM=8cc25a06a9d3c582d163a9d9c6515dac
		ARCHIVE_SUM_APP=md5sum
		UNPACK_APP=unzip
		;;

	linux)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu8.36.0.1-ca-jdk8.0.202-linux_x64.tar.gz
		FINAL_DIR=zulu8.36.0.1-ca-jdk8.0.202-linux_x64
		ARCHIVE_SUM=c7f21dd17f417a1ac11aa7bf752c9fbf
		ARCHIVE_SUM_APP=md5sum
		UNPACK_APP="tar xzvf"
		;;

	darwin)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu8.36.0.1-ca-jdk8.0.202-macosx_x64.tar.gz
		FINAL_DIR=zulu8.36.0.1-ca-jdk8.0.202-macosx_x64
		ARCHIVE_SUM=fe2f2a68eed7bb0a9b2e8fd40898aab9
		ARCHIVE_SUM_APP="md5 -r"
		UNPACK_APP="tar xzvf"
		;;
esac
