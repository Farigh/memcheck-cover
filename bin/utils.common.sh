#! /bin/bash

# Enable colors only if in interactive shell
if [ -t 1 ]; then
    RESET_FORMAT=$(echo -e '\e[00m')
    BOLD=$(echo -e '\e[1m')
    RED=$(echo -e '\e[31m')
    GREEN=$(echo -e '\e[32m')
    PURPLE=$(echo -e '\e[0;35m')
    ORANGE=$(echo -e '\e[38;5;208m')
    CYAN=$(echo -e '\e[0;36m')
fi

memcheck_result_ext="memcheck"

################################################
###                 FUNCTIONS                ###
################################################

function error()
{
    echo "${RED}Error:${RESET_FORMAT} $1" >&2
}

function info()
{
    echo "${CYAN}Info:${RESET_FORMAT} $1"
}

function print_with_indent()
{
    local indent_string=$1
    local to_print=$2

    echo "${to_print}" | awk '{ print "'"${indent_string}"'" $0; }'
}

function check_param()
{
    local opt_name=$1
    local opt_value=$2

    # Ensure a value was passed or the -- opt separator was not considered a param value
    if [ "${opt_value}" == "--" ] || [ "${opt_value}" == "" ]; then
        error "Option '${opt_name}' requires a value"
        print_usage
        exit 1
    # Ensure another opt was not considered a param value
    elif [[ "${opt_value}" == "-"* ]]; then
        error "Invalid value '${opt_value}' for option '${opt_name}'"
        print_usage
        exit 1
    fi
}

function check_mandatory_param()
{
    local opt_name=$1
    local opt_value=$2

    if [ "${opt_value}" == "" ]; then
        error "Mandatory parameter '${opt_name}' not provided"
        print_usage
        exit 1
    fi
}

function create_outdir_if_necessary()
{
    local dir_to_create=$1
    if [ ! -d "${dir_to_create}" ]; then
        info "Creating output directory '${dir_to_create}'"
        mkdir -p "${dir_to_create}"
        if [ $? -ne 0 ]; then
            error "Could not create output dir '${dir_to_create}'"
            exit 1
        fi
    fi
}
