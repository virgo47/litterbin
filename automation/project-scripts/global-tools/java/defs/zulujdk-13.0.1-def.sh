#@IgnoreInspection BashAddShebang
# shellcheck shell=bash disable=SC2034,SC1090,SC2164
#
# See setenv-java.sh for the details how this is used.
# We use Zulu JDK from: https://www.azul.com/downloads/zulu-community
# For each platform you choose proper format (plain archive, not installer),
# copy the download link, change the final dir (for Zulu it's archive name without extension),
# change expected checksum (and check its format) and you're done.
#
# msys for Windows+Git, linux for Linux or darwin for OSX
case "${OSTYPE//[0-9.-]*/}" in
	msys)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu13.28.11-ca-jdk13.0.1-win_x64.zip
		FINAL_DIR=zulu13.28.11-ca-jdk13.0.1-win_x64
		ARCHIVE_SUM=ff088cc86b47986325f70c40fd2f8591686dca1909df7cae26e9a1fc029401db
		ARCHIVE_SUM_APP=sha256sum
		UNPACK_APP=unzip
		;;

	linux)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu13.28.11-ca-jdk13.0.1-linux_x64.tar.gz
		FINAL_DIR=zulu13.28.11-ca-jdk13.0.1-linux_x64
		ARCHIVE_SUM=9532b53972b36f64e5bc9fbadc73be25c75b5b1a06dbc84f8934086d57cbaf48
		ARCHIVE_SUM_APP=sha256sum
		UNPACK_APP="tar xzvf"
		;;

	darwin)
		ARCHIVE_URL=https://cdn.azul.com/zulu/bin/zulu13.28.11-ca-jdk13.0.1-macosx_x64.tar.gz
		FINAL_DIR=zulu13.28.11-ca-jdk13.0.1-macosx_x64
		ARCHIVE_SUM=eb8c3cc0b83da8305add0bb6cc3d8df5a8691e06fe2b9dbc510df27df0432448
		ARCHIVE_SUM_APP="shasum -a 256"
		UNPACK_APP="tar xzvf"
		;;
esac
