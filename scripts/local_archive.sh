#!/usr/bin/env bash

dir=$(dirname ${BASH_SOURCE})

BUILD_TARGET=iOS
source ./scripts/ci/steps/env.sh

# These variables should be available in TRAVIS
if [ -f './secrets/xcode_env.sh' ]; then
  source ./secrets/xcode_env.sh
else
  echo '
Cannot find ./secrets/xcode_env.sh file!!
Please create ./secrets/xcode_env.sh file which these information:

export AWS_ACCESS_KEY=[actual value]
export AWS_ACCESS_SECRET=[actual value]
export MATCH_PASSWORD=[actual value]

Make sure the AWS profile used have S3 read access to the bucket where match ecryped xcode provision profile.
Make sure MATCH_PASSWORd is the password used to encrypt xcode provisional profile.
'
  exit 1
fi

bundle exec fastlane ios archive