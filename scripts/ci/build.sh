#!/usr/bin/env bash

set -e  

dir=$(dirname ${BASH_SOURCE})

source $dir/env.sh

$dir/prepare_license.sh
$dir/build_binary.sh
$dir/distribute.sh