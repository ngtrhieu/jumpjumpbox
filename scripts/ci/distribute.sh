#!/usr/bin/env bash

set -e

dir=$(dirname ${BASH_SOURCE})

source $dir/env.sh

$dir/steps/app_distribution.sh
