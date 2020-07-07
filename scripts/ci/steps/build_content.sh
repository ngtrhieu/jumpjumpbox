#!/usr/bin/env bash

# Build unity project into binary
# (.apk or .aab for Android, XCode project for iOS)

set -e

echo "Building content $BUILD_NAME for $BUILD_TARGET"

${UNITY_EXECUTABLE:-xvfb-run --auto-servernum --server-args='-screen 0 640x480x24' /opt/Unity/Editor/Unity} \
  -projectPath $PROJECT_PATH \
  -quit \
  -batchmode \
  -buildTarget $BUILD_TARGET \
  -customBuildTarget $BUILD_TARGET \
  -customBuildName $BUILD_NAME \
  -customBuildPath $BUILD_PATH \
  -addressableProfile $UNITY_BUILD_PROFILE \
  -executeMethod BuildContentCommand.PerformBuild \
  -logFile /dev/stdout

UNITY_EXIT_CODE=$?

if [ $UNITY_EXIT_CODE -eq 0 ]; then
  echo "Run succeeded, no failures occurred"
elif [ $UNITY_EXIT_CODE -eq 2 ]; then
  echo "Run succeeded, some tests failed"
elif [ $UNITY_EXIT_CODE -eq 3 ]; then
  echo "Run failure (other failure)"
else
  echo "Unexpected exit code $UNITY_EXIT_CODE"
fi

ls -la $PROJECT_PATH/ServerData
[ -n "$(ls -A $PROJECT_PATH/ServerData)" ]
# fail job if the build folder is empty
