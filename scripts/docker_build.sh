#!/usr/bin/env bash

set -e

dir=$(dirname ${BASH_SOURCE})

docker run \
    -e BUILD_NAME \
    -e UNITY_LICENSE_CONTENT \
    -e BUILD_TARGET \
    -e UNITY_USERNAME \
    -e UNITY_PASSWORD \
    -e ANDROID_KEYSTORE \
    -e ANDROID_KEYSTORE_PASS \
    -e ANDROID_KEY_ALIAS_NAME \
    -e ANDROID_KEY_ALIAS_PASS \
    -e GIT_BRANCH \
    -w /project/ \
    -v $(pwd):/project/ \
    $IMAGE_NAME \
    /bin/bash -c $dir/ci/build.sh
