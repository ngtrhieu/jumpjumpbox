#!/usr/bin/env bash

set -e

echo -e "\033[0;32m:: Running $0\033[0m"

dir=$(dirname ${BASH_SOURCE})

docker run \
  -e UNITY_LICENSE_CONTENT \
  -e TEST_PLATFORM \
  -e UNITY_USERNAME \
  -e UNITY_PASSWORD \
  -w /project/ \
  -v $(pwd):/project/ \
  $IMAGE_NAME \
  /bin/bash -c $dir/ci/test.sh

echo -e "\033[0;32m:: $0 completed\033[0m"
