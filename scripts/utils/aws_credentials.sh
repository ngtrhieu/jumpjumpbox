#!/usr/bin/env bash

# Create aws profile

echo :: Generating aws profile

mkdir -p ~/.aws

cat >~/.aws/credentials <<EOL
[default]
aws_access_key_id = ${AWS_ACCESS_KEY}
aws_secret_access_key = ${AWS_ACCESS_SECRET}
EOL

echo :: aws profile generated at ~/.aws/credentials
