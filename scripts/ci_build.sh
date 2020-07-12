#!/usr/bin/env bash

set -e

echo :: Running $0

dir=$(dirname ${BASH_SOURCE})

docker run \
    -e BUILD_NAME \
    -e UNITY_LICENSE_CONTENT \
    -e BUILD_TARGET \
    -e UNITY_USERNAME \
    -e UNITY_PASSWORD \
    -e GOOGLE_KEYSTORE_PASS \
    -e GOOGLE_KEY_ALIAS_NAME \
    -e GOOGLE_KEY_ALIAS_PASS \
    -e UNITY_PROJECT_VERSION \
    -e UNITY_ADDRESSABLE_PROFILE \
    -e GIT_BRANCH \
    -w /project/ \
    -v $(pwd):/project/ \
    $IMAGE_NAME \
    /bin/bash -c $dir/ci/build.sh

echo :: $0 stopped
