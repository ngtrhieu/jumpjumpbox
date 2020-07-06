#!/usr/bin/env bash

# Create aws profile

mkdir -p ~/.aws

cat >~/.aws/credentials <<EOL
[default]
aws_access_key_id = ${ARTIFACTS_KEY}
aws_secret_access_key = ${ARTIFACTS_SECRET}
EOL
