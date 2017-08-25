#!/usr/bin/env bash

set -u

function assign() {
    local var="${1}"
    local value="${2}"

    printf -v "${var}" '%s' "${value}"
}


function getOutput() {

    local json_file="${1:-}"
    local outputKey="${2:-}"
    local var_ref="${3:-${outputKey}}"

    local jq_filter
    jq_filter=".Stacks[0].Outputs[] |  { key: .OutputKey, value: .OutputValue }  |  select ( .key | contains(\"${outputKey}\") ) | .value"
    local outputValue=$(jq "${jq_filter}" "${json_file}")
    assign "${var_ref}" "${outputValue}"
}

