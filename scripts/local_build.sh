#!/usr/bin/env bash

dir=$(dirname ${BASH_SOURCE})

IMAGE_NAME="ngtrhieu/unity3d-android" $dir/docker_build.sh
