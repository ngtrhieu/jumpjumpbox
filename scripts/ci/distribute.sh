#!/usr/bin/env bash

set -e

echo "Distributing $BUILD_NAME..."

# install ruby and node dependencies
bundle install && yarn install

# distribute build over to Firebase app distribution
fastlane distribute

echo "$BUILD_NAME distribution completed."
