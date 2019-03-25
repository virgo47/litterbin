# msys for Windows+Git, linux for Linux or darwin for OSX
_OS=${OSTYPE//[0-9.-]*/}

# https://www.azul.com/downloads/zulu/zulu-windows/
JDK_URL_msys=https://cdn.azul.com/zulu/bin/zulu8.36.0.1-ca-jdk8.0.202-win_x64.zip
JDK_DIR_msys=zulu8.36.0.1-ca-jdk8.0.202-win_x64
JDK_SUM_msys=8cc25a06a9d3c582d163a9d9c6515dac

# https://www.azul.com/downloads/zulu/zulu-linux/
JDK_URL_linux=https://cdn.azul.com/zulu/bin/zulu8.36.0.1-ca-jdk8.0.202-linux_x64.tar.gz
JDK_DIR_linux=zulu8.36.0.1-ca-jdk8.0.202-linux_x64
JDK_SUM_linux=c7f21dd17f417a1ac11aa7bf752c9fbf

# https://www.azul.com/downloads/zulu/zulu-mac/
JDK_URL_darwin=https://cdn.azul.com/zulu/bin/zulu8.36.0.1-ca-jdk8.0.202-macosx_x64.tar.gz
JDK_DIR_darwin=zulu8.36.0.1-ca-jdk8.0.202-macosx_x64
JDK_SUM_darwin=fe2f2a68eed7bb0a9b2e8fd40898aab9

JDK_URL_VAR="JDK_URL_${_OS}"
JDK_DIR_VAR="JDK_DIR_${_OS}"
JDK_SUM_VAR="JDK_SUM_${_OS}"
JDK_URL="${!JDK_URL_VAR}"
JDK_DIR="${!JDK_DIR_VAR}"
JDK_SUM="${!JDK_SUM_VAR}"

# Currently the checksums are defined with URL/DIR, but they should probably be baked-in
# project's Git version to enforce that exactly the same Java is used for build.

[ "$_OS" = "darwin" ] && JDK_SUM_APP="md5 -r" || JDK_SUM_APP=md5sum
[[ "$JDK_URL" == *.zip ]] && UNPACK_APP=unzip || UNPACK_APP="tar xzvf"
