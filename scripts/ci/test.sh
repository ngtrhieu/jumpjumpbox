#!/usr/bin/env bash

set -e

dir=$(dirname ${BASH_SOURCE})

source $dir/env.sh

$dir/prepare_license.sh
$dir/run_test.sh
