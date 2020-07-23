#!/usr/bin/env bash

set -e

dir=$(dirname ${BASH_SOURCE})

source $dir/steps/env.sh
node $dir/../utils/update_addressable_remote_load_path.js
$dir/steps/prepare_license.sh
$dir/steps/build_content.sh
$dir/steps/build_binary.sh
