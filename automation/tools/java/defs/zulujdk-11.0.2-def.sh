# msys for Windows+Git, linux for Linux or darwin for OSX
_OS=${OSTYPE//[0-9.-]*/}

JDK_URL_msys=https://cdn.azul.com/zulu/bin/zulu11.29.11-ca-jdk11.0.2-win_x64.zip
JDK_DIR_msys=zulu11.29.11-ca-jdk11.0.2-win_x64
JDK_SUM_msys=c160559d36e9478bd1bd471f4caf33d2

JDK_URL_linux=https://cdn.azul.com/zulu/bin/zulu11.29.11-ca-jdk11.0.2-linux_x64.tar.gz
JDK_DIR_linux=zulu11.29.11-ca-jdk11.0.2-linux_x64
JDK_SUM_linux=06a3df0ff56a1430c1cb8a3d05f1c752

JDK_URL_darwin=https://cdn.azul.com/zulu/bin/zulu11.29.11-ca-jdk11.0.2-macosx_x64.tar.gz
JDK_DIR_darwin=zulu11.29.11-ca-jdk11.0.2-macosx_x64
JDK_SUM_darwin=08ca5b03544d7070039859fe2f3b626b

JDK_URL_VAR="JDK_URL_${_OS}"
JDK_DIR_VAR="JDK_DIR_${_OS}"
JDK_SUM_VAR="JDK_SUM_${_OS}"
JDK_URL="${!JDK_URL_VAR}"
JDK_DIR="${!JDK_DIR_VAR}"
JDK_SUM="${!JDK_SUM_VAR}"

[ "$_OS" = "darwin" ] && CHECKSUM_APP="md5 -r" || CHECKSUM_APP=md5sum
[[ "$JDK_URL" == *.zip ]] && UNPACK_APP=unzip || UNPACK_APP="tar xzvf"
