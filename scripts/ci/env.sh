#!/usr/bin/env bash

set -e

# required by fastlane
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# build settings
export BUILD_TARGET=${BUILD_TARGET:-"Android"}
export BUILD_NAME=${BUILD_NAME:-"BuildAndroid"}
export BUILD_APP_BUNDLE=${BUILD_APP_BUNDLE:-"false"}
export UNITY_PROJECT=${UNITY_PROJECT:-"unity"}

# paths
export PROJECT_PATH=${PROJECT_PATH:-"$(pwd)/$UNITY_PROJECT/"}
export RESULT_PATH=${RESULT_PATH:-"$(pwd)/test_results/"}
export BUILD_PATH=${BUILD_PATH:-"$(pwd)/builds/$BUILD_TARGET/"}

# export ANDROID_BUILD_PATH to point to .apk or .aab file
# depends on BUILD_APP_BUNDLE
if [ $BUILD_APP_BUNDLE = "false" ]; then
    export ANDROID_BUILD_PATH=$BUILD_PATH$BUILD_NAME.apk
else
    export ANDROID_BUILD_PATH=$BUILD_PATH$BUILD_NAME.aab
fi

# secrets
export UNITY_LICENSE_CONTENT=$(cat ./secrets/Unity_lic.ulf)
export FIREBASE_CLI_TOKEN=$(cat ./secrets/firebase.token)
