#!/usr/bin/env bash

set -e

echo -e "\033[0;32m:: Running $0\033[0m"

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

echo -e "\033[0;32m:: $0 completed\033[0m"
