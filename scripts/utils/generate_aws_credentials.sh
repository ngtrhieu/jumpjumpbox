#!/usr/bin/env bash

# Create aws profile

if [ -n $AWS_ACCESS_KEY ] || [ -n $AWS_ACCESS_SECRET ]; then
  echo -e '\033[0;31m:: Failed to generate AWS profile'
  echo -e '\033[0;31mEither AWS_ACCESS_KEY or AWS_ACCESS_SECRET is not set.'
  exit 1
fi

echo :: Generating aws profile...

mkdir -p ~/.aws

cat >~/.aws/credentials <<EOL
[default]
aws_access_key_id = ${AWS_ACCESS_KEY}
aws_secret_access_key = ${AWS_ACCESS_SECRET}
EOL

echo :: aws profile generated at ~/.aws/credentials
