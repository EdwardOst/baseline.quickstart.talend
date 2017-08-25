#!/usr/bin/env bash

set -e
set -u
set -o pipefail

install_script_path=$(readlink -e "${BASH_SOURCE[0]}")
install_script_dir="${install_script_path%/*}"

# shellcheck source=../util/util.sh
source "${install_script_dir}/../util/util.sh"

# shellcheck source=../util/string_util.sh
source "${install_script_dir}/../util/string_util.sh"

# shellcheck source=../factory/build.sh
source "${install_script_dir}/setup.sh"

#export DEBUG_LOG=true

# requires sudo
[ "$(id -u)" -ne 0 ] && echo "install must be run as root" && exit

declare quickstart_name="${1:-}"

required quickstart_name

setup quickstart_name
echo "using ${quickstart_name}.properties"
source "${quickstart_name}.properties"

declare config_dir="${quickstart_name}"

[ "${config_dir}" == "talend" ] \
     && [ ! -d "${quickstart_name}" ] \
     && echo "directory ${config_dir} does not exist.  Using ${install_script_dir}/talend" 1>&2 \
     && config_dir="${install_script_dir}/talend"

[ ! -d "${config_dir}" ] \
    && echo "directory ${config_dir} does not exist.  Using ${install_script_dir}/config" 1>&2 \
    && config_dir="${install_script_dir}/config"

factory "${config_dir}"
