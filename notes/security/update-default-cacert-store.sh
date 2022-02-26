#!/bin/bash

set -eu

JKS_FILE=${1:-}
if [ -z "$JKS_FILE" ]; then
    >&2 echo "USAGE: this-script.sh <jks-file>"
    exit 1
fi
echo "Importing JKS: $JKS_FILE"

echo "Using: $JAVA_HOME"

if [ -d $JAVA_HOME/lib/security ]; then
    CACERTS_DIR=$JAVA_HOME/lib/security
elif [ -d $JAVA_HOME/jre/lib/security ]; then
    CACERTS_DIR=$JAVA_HOME/jre/lib/security
else
    >&2 echo "ERROR: Directory with cacert not located in JDK/JRE"
    exit 2
fi
echo "JKS directory: $CACERTS_DIR"

CACERTS_FILE=$CACERTS_DIR/cacerts
if [ ! -f ${CACERTS_FILE}.orig ]; then
    cp $CACERTS_FILE ${CACERTS_FILE}.orig
    echo "Original file was preserved as ${CACERTS_FILE}.orig"
else
    echo "Original file was preserved previously, skipping"
fi

# To work with cacerts file in JDK 9+ you can use just -cacerts instead of -keystore <path>.
# But this does not work for JDK 8 and lower, and I want to locate the file for backup anyway.
# Also -importkeystore requires -destkeystore parameter with path.

# this will ask for source store password (likely "changeit", just like destination's)
keytool -importkeystore -srckeystore $JKS_FILE -destkeystore $CACERTS_FILE -deststorepass changeit
