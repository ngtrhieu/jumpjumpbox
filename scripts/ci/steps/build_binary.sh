#!/usr/bin/env bash

# Build unity project into binary
# (.apk or .aab for Android, XCode project for iOS)

set -e

echo -e '\033[0;32m:: Running step $0'

echo ":: Building $BUILD_NAME for $BUILD_TARGET"
mkdir -p $BUILD_PATH

${UNITY_EXECUTABLE:-xvfb-run --auto-servernum --server-args='-screen 0 640x480x24' /opt/Unity/Editor/Unity} \
  -projectPath $PROJECT_PATH \
  -quit \
  -batchmode \
  -buildTarget $BUILD_TARGET \
  -customBuildTarget $BUILD_TARGET \
  -customBuildName $BUILD_NAME \
  -customBuildPath $BUILD_PATH \
  -executeMethod BuildCommand.PerformBuild \
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

echo "Checking build path $BUILD_PATH..."
ls -la $BUILD_PATH
if [ -z "$(ls -A $BUILD_PATH)" ]; then
  echo -e "\033[0;31mBuild folder empty. Exit 1"
  exit 1
fi

echo -e '\033[0;32m:: Step $0 completed'
