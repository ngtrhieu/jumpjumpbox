#!/usr/bin/env bash

dir=$(dirname ${BASH_SOURCE})

UNITY_BUILD_PROFILE="Default" IMAGE_NAME="ngtrhieu/unity3d-android" $dir/docker_build.sh
