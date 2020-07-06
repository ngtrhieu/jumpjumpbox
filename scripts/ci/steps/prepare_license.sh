#!/usr/bin/env bash

# Prepare Unity license and Android keystore.

set -e
mkdir -p /root/.cache/unity3d
mkdir -p /root/.local/share/unity3d/Unity/

UPPERCASE_BUILD_TARGET=${BUILD_TARGET^^}

if [ $UPPERCASE_BUILD_TARGET = "ANDROID" ]; then
    if [ -n $ANDROID_KEYSTORE_BASE64 ]; then
        echo '$ANDROID_KEYSTORE_BASE64 found, decoding content into keystore.keystore'
        echo $ANDROID_KEYSTORE_BASE64 | base64 --decode >keystore.keystore
    elif [ -f "$(pwd)/secrets/keystore.keystore" ]; then
        echo 'Keystore found inside secrets folder, copy to root folder.'
        cat $(pwd)/secrets/keystore.keystore >keystore.keystore
    else
        echo 'ANDROID_KEYSTORE'" env var not found, building with Unity's default debug keystore"
    fi
fi

LICENSE="UNITY_LICENSE_CONTENT_"$UPPERCASE_BUILD_TARGET

if [ -z "${!LICENSE}" ]; then
    echo "$LICENSE env var not found, using default UNITY_LICENSE_CONTENT env var"
    LICENSE=UNITY_LICENSE_CONTENT
else
    echo "Using $LICENSE env var"
fi

echo "Writing $LICENSE to license file /root/.local/share/unity3d/Unity/Unity_lic.ulf"
echo "${!LICENSE}" | tr -d '\r' >/root/.local/share/unity3d/Unity/Unity_lic.ulf
