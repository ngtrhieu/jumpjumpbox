#!/usr/bin/env bash

dir=$(dirname ${BASH_SOURCE})

UNITY_BUILD_PROFILE="Default" IMAGE_NAME=${IMAGE_NAME:-"ngtrhieu/unity3d-android"} $dir/ci_build.sh
