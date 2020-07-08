#!/usr/bin/env bash

# Deploy app binary (apk, aab, ipa) to Firebase app distribution

set -e

echo :: Running step $0

echo "Distributing $BUILD_NAME..."
fastlane distribute
echo "$BUILD_NAME distribution completed."

echo :: Step $0 completed
