#!/usr/bin/env bash

dir=$(dirname ${BASH_SOURCE})

BUILD_TARGET=iOS
source ./scripts/ci/steps/env.sh

bundle exec fastlane ios archive
