#!/usr/bin/env bash

set -e
set -u

[ "${S3FS_UTIL_FLAG:-0}" -gt 0 ] && return 0

export S3FS_UTIL_FLAG=1

tui_repo_util_script_path=$(readlink -e "${BASH_SOURCE[0]}")
tui_repo_util_script_dir="${tui_repo_util_script_path%/*}"

# shellcheck source=../../util/util.sh
source "${tui_repo_util_script_dir}/../../util/util.sh"

declare talendRepoDir="${1:-}"
declare tuiRepo="${2:-}"

required talendRepoDir tuiRepo

[ ! -d "${talendRepoDir}" ] && errorMessage "talendRepoDir ${talendRepoDir} does not exist or is not a directory" && exit 1

mkdir -p "${tuiRepo}" "${tuiRepo}/6.3.1" "${tuiRepo}/dependencies"

ln -s ${talendRepoDir}/6.3.1/* "${tuiRepo}/6.3.1"
ln -s ${talendRepoDir}/dependencies/* "${tuiRepo}/dependencies"
