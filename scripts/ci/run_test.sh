!/usr/bin/env bash

set -x

echo "Testing $BUILD_NAME for $TEST_PLATFORM"

CODE_COVERAGE_PACKAGE="com.unity.testtools.codecoverage"
PACKAGE_MANIFEST_PATH="Packages/manifest.json"

${UNITY_EXECUTABLE:-xvfb-run --auto-servernum --server-args='-screen 0 640x480x24' /opt/Unity/Editor/Unity} \
  -projectPath ${PROJECT_PATH} \
  -runTests \
  -testPlatform $TEST_PLATFORM \
  -testResults $RESULT_PATH/$TEST_PLATFORM-results.xml \
  -logFile /dev/stdout \
  -batchmode \
  -enableCodeCoverage \
  -coverageResultsPath $RESULT_PATH/$TEST_PLATFORM-coverage \
  -coverageOptions "generateAdditionalMetrics;generateHtmlReport;generateHtmlReportHistory;generateBadgeReport;assemblyFilters:+Assembly-CSharp" \
  -debugCodeOptimization

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

if grep $CODE_COVERAGE_PACKAGE $PACKAGE_MANIFEST_PATH; then
  cat $RESULT_PATH/$TEST_PLATFORM-coverage/Report/Summary.xml | grep Linecoverage
  mv $RESULT_PATH/$TEST_PLATFORM-coverage/$UNITY_PROJECT-opencov/*Mode/TestCoverageResults_*.xml $RESULT_PATH/$TEST_PLATFORM-coverage/coverage.xml
  rm -r $RESULT_PATH/$TEST_PLATFORM-coverage/$UNITY_PROJECT-opencov/
  mv $PROJECT_PATH/CodeCoverage $RESULT_PATH/CodeCoverage
else
  {
    echo -e "\033[33mCode Coverage package not found in $PACKAGE_MANIFEST_PATH. Please install the package \"Code Coverage\" through Unity's Package Manager to enable coverage reports.\033[0m"
  } 2>/dev/null
fi

cat $RESULT_PATH/$TEST_PLATFORM-results.xml | grep test-run | grep Passed
exit $UNITY_EXIT_CODE
