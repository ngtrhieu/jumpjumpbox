#!/usr/bin/env bash

dir=$(dirname ${BASH_SOURCE})

TEST_PLATFORM=editmode IMAGE_NAME="ngtrhieu/unity3d" $dir/docker_test.sh
TEST_PLATFORM=playmode IMAGE_NAME="ngtrhieu/unity3d" $dir/docker_test.sh
