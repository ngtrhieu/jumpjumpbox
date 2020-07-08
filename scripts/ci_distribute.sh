#!/usr/bin/env bash

set -e

echo :: Running $0

dir=$(dirname ${BASH_SOURCE})

$dir/ci/distribute.sh

echo :: $0 stopped
