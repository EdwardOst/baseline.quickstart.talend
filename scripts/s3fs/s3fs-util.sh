#!/usr/bin/env bash

set -u

[ "${S3FS_UTIL_FLAG:-0}" -gt 0 ] && return 0

export S3FS_UTIL_FLAG=1

s3fs_util_script_path=$(readlink -e "${BASH_SOURCE[0]}")
s3fs_util_script_dir="${s3fs_util_script_path%/*}"

# shellcheck source=../util/util.sh
source "${s3fs_util_script_dir}/../util/util.sh"


s3fs_builder() {
    local package_manager="${1}"
    
    required package_manager

    [ ! "${package_manager}" == "yum" ] && [ ! "${package_manager}" == "apt" ] && errorMessage "invalid argument: package_manager valid values are yum or apt" && return 1
    s3fs_packages="s3fs_build_yum"
}

function s3fs_build_yum() {
    yum -y install automake fuse fuse-devel gcc-c++ git libcurl-devel libxml2-devel make openssl-devel
}

function s3fs_build_apt() {
    apt-get install build-essential libfuse-dev libcurl4-openssl-dev libxml2-dev mime-support automake libtool
    apt-get install pkg-config libssl-dev
}

function s3fs_build() {

    local s3fs_dir="${1:-${s3fs_dir:-}}"

    if [ -f "/usr/local/bin/s3fs" ]; then
        [ ! -L "/usr/bin/s3fs" ] && ln -s /usr/local/bin/s3fs /usr/bin/s3fs
        return 0
    fi

    "${s3fs_packages:-s3fs_build_yum}"

    local pushed=false
    if [ -n "${s3fs_dir}" ]; then
        try pushd "${s3fs_dir}"
        pushed=true
    elif [ ! -f autogen.sh ]; then
        if [ -d s3fs-fuse ]; then
            try pushd s3fs-fuse
            pushed=true
        else
            git clone https://github.com/s3fs-fuse/s3fs-fuse.git
            try pushd s3fs-fuse
            pushed=true
        fi
    else
        debugLog "INFO: s3fs found"
    fi

    ./autogen.sh
    ./configure
    make
    make install

    ln -s /usr/local/bin/s3fs /usr/bin/s3fs

    [ "${pushed}" == "true" ] && popd
    return 0
}


function s3fs_config() {

    local access_key="${1:-${access_key:-${TALEND_FACTORY_ACCESS_KEY:-}}}"
    local secret_key="${2:-${secret_key:-${TALEND_FACTORY_SECRET_KEY:-}}}"

    local credentials_file=~/.passwd-s3fs
    sed -i "s/# user_allow_other/user_allow_other/g" /etc/fuse.conf

    if [ -n "${access_key}" ] && [ -n "${secret_key}" ]; then
        echo "${access_key}:${secret_key}" > "${credentials_file}"
        chmod 600 "${credentials_file}"
    elif [ ! -f "${credentials_file}" ]; then
        errorMessage "Credential file ${credentials_file} must be set."
        return 0
    else
        # credentials_file will be generated by cloud formation
        debugLog "Credential file ${credentials_file} found."
    fi

}


function s3fs_mount() {

    local s3_bucket="${1:-}"
    local s3_path="${2:-/}"
    local s3_mount_dir="${3:-${s3_mount_dir:-${TALEND_FACTORY_REPO_MOUNT_DIR:-/opt/repo}}}"
    local s3_mount_root="${4:-${s3_mount_dir}}"
    local s3fs_umask="${5:-037}"
    local iam_role="${6:-auto}"
    local target_owner="${7:-${target_owner:-ec2-user}}"

    required s3_bucket s3_path s3_mount_dir s3_mount_root s3fs_umask

    debugVar s3_bucket; debugVar s3_path; debugVar s3_mount_dir; debugVar s3_mount_root; debugVar s3fs_umask; debugVar iam_role

    mkdir -p "${s3_mount_dir}"

    chown -R "${target_owner}:${target_owner}" "${s3_mount_root}"

    [ -n "${s3_path}" ] && [ "${s3_path:0:1}" != "/" ] && s3_path="/${s3_path}"
    [ -n "${s3_path}" ] && s3_path=":${s3_path}"

    if [ "${iam_role}" == "none" ]; then
        debugLog "s3fs ${s3_bucket}${s3_path} ${s3_mount_dir} -o allow_other -o mp_umask=${s3fs_umask}"
        try s3fs "${s3_bucket}${s3_path}" "${s3_mount_dir}" -o allow_other -o mp_umask="${s3fs_umask}"
    else
        debugLog "s3fs ${s3_bucket}${s3_path} ${s3_mount_dir} -o iam_role=auto -o allow_other -o mp_umask=${s3fs_umask}"
        try s3fs "${s3_bucket}${s3_path}" "${s3_mount_dir}" -o iam_role="${iam_role}" -o allow_other -o mp_umask="${s3fs_umask}"
    fi
}


function s3fs_file_attrib() {

    local filepath="${1:-}"
    local perm="${2:-640}"
    local target_owner="${3:-${target_owner:-ec2-user}}"

    required filepath perm owner

    debugLog "s3fs-chmod: ${filepath} ${target_owner}:${target_owner} ${perm}"

    chown "${target_owner}:${target_owner}" "${filepath}"
    chmod "${perm}" "${filepath}"
}


function s3fs_dir_attrib() {

    local target_owner="${1:-${target_owner:-ec2-user}}"
    local mount_dir="${2:-/opt/repo}"

    local mydir_list
    mydir_list=$(ls -d "${mount_dir}"/*/)
    for subdir in ${mydir_list}
    do
        echo "processing ${subdir}"
        chown "${target_owner}:${target_owner}" "${subdir}"
        chmod 750 "${subdir}"
        find "${subdir}" -type d -exec chown "${target_owner}:${target_owner}" {} \;
        find "${subdir}" -type d -exec chmod 750 {} \;
        find "${subdir}" -type f -name "*" -exec chown "${target_owner}:${target_owner}" {} \;
        find "${subdir}" -type f -name "*" -exec chmod 440 {} \;
        find "${subdir}" -type f -name "*.sh" -exec chmod 550 {} \;
    done
}
