# msys for Windows+Git, linux for Linux or darwin for OSX
case "${OSTYPE//[0-9.-]*/}" in
	msys)
		JDK_URL=https://download.java.net/java/GA/jdk11/13/GPL/openjdk-11.0.1_windows-x64_bin.zip
		JDK_DIR=jdk-11.0.1
		JDK_SUM=289dd06e06c2cbd5e191f2d227c9338e88b6963fd0c75bceb9be48f0394ede21
		CHECKSUM_APP=sha256sum
		UNPACK_APP=unzip
		;;

	linux)
		JDK_URL=https://download.java.net/java/GA/jdk11/13/GPL/openjdk-11.0.1_linux-x64_bin.tar.gz
		JDK_DIR=jdk-11.0.1
		JDK_SUM=7a6bb980b9c91c478421f865087ad2d69086a0583aeeb9e69204785e8e97dcfd
		CHECKSUM_APP=sha256sum
		UNPACK_APP="tar xzvf"
		;;

	darwin)
		JDK_URL=https://download.java.net/java/GA/jdk11/13/GPL/openjdk-11.0.1_osx-x64_bin.tar.gz
		JDK_DIR=jdk-11.0.1
		JDK_SUM=fa07eee08fa0f3de541ee1770de0cdca2ae3876f3bd78c329f27e85c287cd070
		CHECKSUM_APP="shasum -a 256"
		UNPACK_APP="tar xzvf"
		UNPACK_APP_TAIL_OPTS=" -s #jdk-11.0.1.jdk/Contents/Home#jdk-11.0.1# jdk-11.0.1.jdk/Contents/Home"
		;;
esac
