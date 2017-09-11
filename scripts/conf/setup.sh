#!/usr/bin/env bash

set -e
set -u
set -x
set -o pipefail

setup_script_path=$(readlink -e "${BASH_SOURCE[0]}")
setup_script_dir="${setup_script_path%/*}"

# shellcheck source=../util/util.sh
source "${setup_script_dir}/../util/util.sh"

# shellcheck source=../util/string_util.sh
source "${setup_script_dir}/../util/string_util.sh"

# shellcheck source=../setup/build.sh
source "${setup_script_dir}/../factory/build.sh"

#export DEBUG_LOG=true


function setup() {

    local factory_ref="${1}"

    required factory_ref

    local default_factory="${!factory_ref}"
    local factory_name
    read -rp "enter factory name [${default_factory}]: " factory_name
    trim factory_name
    factory_name="${!factory_name:-${default_factory}}"
    required factory_name
    assign "${factory_ref}" "${factory_name}"

    [ -f "${factory_name}.properties" ] && echo "using ${factory_name}.properties" && return 0

    read -rp "enter aws access key: " access_key
    read -rp "enter aws secret key: " secret_key
    read -rp "enter talend userid: " talend_userid
    read -rp "enter talend password: " talend_password

    local umask_save
    umask_save=$(umask)
    umask 377
    cat > "${factory_name}.properties" <<-EOF && true
	export TALEND_FACTORY_NAME="${factory_name}"
	export TALEND_FACTORY_ACCESS_KEY="${access_key}"
	export TALEND_FACTORY_SECRET_KEY="${secret_key}"
	export TALEND_FACTORY_TALEND_USERID="${talend_userid}"
	export TALEND_FACTORY_TALEND_PASSWORD="${talend_password}"
	EOF

   result="${?}"
   umask "${umask_save}"
   return "${result}"
}



function factory() {

    local factory_dir="${1:-${factory_dir:-${TALEND_FACTORY_NAME}}}"

    required factory_dir

    [ ! -d "${factory_dir}" ] && errorMessage "invalid argument: factory_dir '${factory_dir}' does not exist" && return 1

    debugLog "attempting to source ${factory_dir}"

    for script_file in "${factory_dir}"/*.sh ; do
        if [ -r "${script_file}" ]; then
            debugLog "soucing ${script_file}"
            # shellcheck source=/dev/null
            source "${script_file}"
        fi
    done

    factory_env build
}
