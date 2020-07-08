#!/usr/bin/env bash

set -e

echo :: Running $0

dir=$(dirname ${BASH_SOURCE})

docker run \
  -e UNITY_LICENSE_CONTENT \
  -e TEST_PLATFORM \
  -e UNITY_USERNAME \
  -e UNITY_PASSWORD \
  -e TRAVIS_BRANCH \
  -w /project/ \
  -v $(pwd):/project/ \
  $IMAGE_NAME \
  /bin/bash -c $dir/ci/test.sh

echo :: $0 stopped
