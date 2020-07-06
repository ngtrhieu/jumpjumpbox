#!/usr/bin/env bash

# Deploy app binary (apk, aab, ipa) to Firebase app distribution

set -e

echo "Distributing $BUILD_NAME..."

bundle install && yarn install
fastlane distribute

echo "$BUILD_NAME distribution completed."
