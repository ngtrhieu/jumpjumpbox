#!/usr/bin/env bash

set -e

dir=$(dirname ${BASH_SOURCE})

source $dir/env.sh

$dir/steps/prepare_license.sh
$dir/steps/build_binary.sh
