#!/usr/bin/env bash

# Setup environment variables if it have not been set
#
# NOTE:
# - need to execute with `source`, i.e: `source ./env.sh` to load these variable into the environment.
# - use only VARIABLE=${VARIABLE:-DefaultValue} expansion form https://wiki.bash-hackers.org/syntax/pe to set default
# value so that we can preset from outside environment.

set -e

echo -e "\033[0;32m:: Running step $0\033[0m"

####################
# build settings
####################

# Build target, can either be "Android" or "iOS".
export BUILD_TARGET=${BUILD_TARGET:-"Android"}
echo "BUILD_TARGET ${BUILD_TARGET}"

# Test platform, can either be 'editmode' or 'playmode'.
export TEST_PLATFORM=${TEST_PLATFORM:-"editmode"}
echo "TEST_PLATFORM ${TEST_PLATFORM}"

# Name of the build file (i.e: apk, aab, ipa file)
export BUILD_NAME=${BUILD_NAME:-"Build$BUILD_TARGET"}
echo "BUILD_NAME ${BUILD_NAME}"

# Exporting as app bundle? (applicable for Android only)
export BUILD_APP_BUNDLE=${BUILD_APP_BUNDLE:-"false"}
echo "BUILD_APP_BUNDLE ${BUILD_APP_BUNDLE}"

# The bucket to upload builds and test reports to
export BUILD_BUCKET=${BUILD_BUCKET:-"jumpjumpbox-builds"}
echo "BUILD_BUCKET ${BUILD_BUCKET}"

# The bucket to upload build bundles to
export CONTENT_BUCKET=${CONTENT_BUCKET:-"jumpjumpbox-assets"}
echo "CONTENT_BUCKET ${CONTENT_BUCKET}"

# Unity addressable profile
export UNITY_ADDRESSABLE_PROFILE=${UNITY_ADDRESSABLE_PROFILE:-"CI"}
echo "UNITY_ADDRESSABLE_PROFILE ${UNITY_ADDRESSABLE_PROFILE}"

# Unity license content
export UNITY_LICENSE_CONTENT=${UNITY_LICENSE_CONTENT:-"$(cat ./secrets/Unity_lic.ulf)"}

####################
# generated variables (do not modify this section)
####################

# required by fastlane
export LC_ALL='en_US.UTF-8'
export LANG='en_US.UTF-8'

# Absolute path to Unity profile folder
export PROJECT_PATH="$(pwd)/unity"
echo "PROJECT_PATH ${PROJECT_PATH}"

# Absolute path to test_results folder
export RESULT_PATH="$(pwd)/test_results"
echo "RESULT_PATH ${RESULT_PATH}"

# Absolute path to builds folder
export BUILD_PATH="$(pwd)/builds/$BUILD_TARGET"
echo "BUILD_PATH ${BUILD_PATH}"

# Unity project version (sematic versionning)
export SEMATIC_VERSION="$(node $(pwd)/scripts/utils/get_project_version.js)"
echo "SEMATIC_VERSION ${SEMATIC_VERSION}"

# Unity app id (bundle identifier, reverse domain name format)
export APP_ID="$(node $(pwd)/scripts/utils/get_project_app_id.js)"
echo "APP_ID ${APP_ID}"

# Unity addressable's RemoteBuildPath
export UNITY_ADDRESSABLE_REMOTE_BUILD_PATH="ServerData/${BUILD_TARGET}/v${SEMATIC_VERSION}"
echo "UNITY_ADDRESSABLE_REMOTE_BUILD_PATH ${UNITY_ADDRESSABLE_REMOTE_BUILD_PATH}"

# Unity addressable's RemoteLoadPath
export UNITY_ADDRESSABLE_REMOTE_LOAD_PATH="https://${CONTENT_BUCKET}.s3-${AWS_REGION:-"ap-southeast-1"}.amazonaws.com/${BUILD_TARGET}/v${SEMATIC_VERSION}"
echo "UNITY_ADDRESSABLE_REMOTE_LOAD_PATH ${UNITY_ADDRESSABLE_REMOTE_LOAD_PATH}"

# Absolute path to the build file/xcode project folder
ANDROID_EXTENSION=$([ $BUILD_APP_BUNDLE = "false" ] && echo apk || echo aab)
if [ -n $SEMATIC_VERSION ]; then
    export VERSIONED_BUILD_NAME="${BUILD_NAME}_v${SEMATIC_VERSION}"
else
    export VERSIONED_BUILD_NAME="${BUILD_NAME}"
fi
echo "VERSIONED_BUILD_NAME ${VERSIONED_BUILD_NAME}"

export ANDROID_BUILD_PATH="${BUILD_PATH}/${VERSIONED_BUILD_NAME}.${ANDROID_EXTENSION}"
echo "ANDROID_BUILD_PATH ${ANDROID_BUILD_PATH}"

export IOS_BUILD_PATH="${BUILD_PATH}/${VERSIONED_BUILD_NAME}.ipa"
echo "IOS_BUILD_PATH ${IOS_BUILD_PATH}"

export IOS_XCODE_PROJECT_PATH="${BUILD_PATH}/${VERSIONED_BUILD_NAME}"
echo "IOS_XCODE_PROJECT_PATH ${IOS_XCODE_PROJECT_PATH}"

# secrets
export FIREBASE_CLI_TOKEN=${FIREBASE_CLI_TOKEN:-"$(cat ./secrets/firebase.token)"}
if [ -f ./secrets/credentials.sh ]; then source ./secrets/credentials.sh; fi
export MATCH_PASSWORD=$APPLE_PROVISION_PROFILE_PASSWORD

echo -e "\033[0;32m:: Step $0 completed\033[0m"
