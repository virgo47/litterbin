# msys for Windows+Git, linux for Linux or darwin for OSX
_OS=${OSTYPE//[0-9.-]*/}

JDK_URL_msys=https://download.java.net/java/GA/jdk11/13/GPL/openjdk-11.0.1_windows-x64_bin.zip
JDK_DIR_msys=jdk-11.0.1
JDK_SUM_msys=289dd06e06c2cbd5e191f2d227c9338e88b6963fd0c75bceb9be48f0394ede21

JDK_URL_linux=https://download.java.net/java/GA/jdk11/13/GPL/openjdk-11.0.1_linux-x64_bin.tar.gz
JDK_DIR_linux=jdk-11.0.1
JDK_SUM_linux=7a6bb980b9c91c478421f865087ad2d69086a0583aeeb9e69204785e8e97dcfd

JDK_URL_darwin=https://download.java.net/java/GA/jdk11/13/GPL/openjdk-11.0.1_osx-x64_bin.tar.gz
JDK_DIR_darwin=jdk-11.0.1.jdk
JDK_SUM_darwin=fa07eee08fa0f3de541ee1770de0cdca2ae3876f3bd78c329f27e85c287cd070

JDK_URL_VAR="JDK_URL_${_OS}"
JDK_DIR_VAR="JDK_DIR_${_OS}"
JDK_SUM_VAR="JDK_SUM_${_OS}"
JDK_URL="${!JDK_URL_VAR}"
JDK_DIR="${!JDK_DIR_VAR}"
JDK_SUM="${!JDK_SUM_VAR}"

[ "$_OS" = "darwin" ] && CHECKSUM_APP="md5 -r" || CHECKSUM_APP=md5sum
[[ "$JDK_URL" == *.zip ]] && UNPACK_APP=unzip || UNPACK_APP="tar xzvf"
