#!/usr/bin/env bash

set -e

dir=$(dirname ${BASH_SOURCE})

source $dir/steps/env.sh

yarn install && bundle install
$dir/steps/prepare_license.sh
$dir/steps/test.sh
