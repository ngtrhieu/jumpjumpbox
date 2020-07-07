#!/usr/bin/env bash

set -e

dir=$(dirname ${BASH_SOURCE})

source $dir/steps/env.sh

yarn install && bundle install
$dir/steps/app_distribution.sh
