#!/usr/bin/env bash

set -e

dir=$(dirname ${BASH_SOURCE})

source $dir/steps/env.sh
$dir/steps/prepare_license.sh
$dir/steps/build_content.sh
$dir/steps/build_binary.sh
