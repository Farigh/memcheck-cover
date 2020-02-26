# ! /bin/bash

# Enable colors only if in interactive shell
if [ -t 1 ]; then
    RESET_FORMAT=$(echo -e '\e[00m')
    RED=$(echo -e '\e[31m')
    CYAN=$(echo -e '\e[0;36m')
fi

function list_test_cases_option()
{
    local script_opt=$1
    if [ "${script_opt}" == "--list-cases" ]; then
        local test_case
        for test_case in "${test_cases[@]}"; do
            echo "${test_case}"
        done
        exit 0
    fi
}

function get_test_outdir()
{
    local resolved_test_path=$(readlink -f $0)
    local current_test_dir=$(dirname $resolved_test_path)
    local current_test_full_path=$(readlink -e $current_test_dir)

    local current_test_name=$0
    current_test_name=${current_test_name##*/}
    current_test_name=${current_test_name%_ts_*.sh}

    echo "${current_test_full_path}/out/${current_test_name}/"
}

###############################
###   STRING MANIPULATION   ###
###############################

function convert_to_filename_str()
{
    local input_str=$1

    # Replace space
    local convert_sed_cmds="s# #.space.#g"

    # Replace =
    convert_sed_cmds+=";s#=#.equals.#g"

    # Remove any trailing point
    convert_sed_cmds+=";s#\.\$##"

    echo "${input_str}" | sed "${convert_sed_cmds}"
}

function extract_param_part_from_str()
{
    local str_to_extract_from=$1

    local expected_opt_error="${str_to_extract_from}"

    # Trim trailing space if needed
    if [ "${expected_opt_error: -1}" == " " ]; then
        expected_opt_error="${expected_opt_error:0:-1}"
    fi

    # If short option, trim the option 'value' (ie. -dummy becomes -d)
    if [ "${expected_opt_error:1:1}" != "-" ]; then
        expected_opt_error="${expected_opt_error:0:2}"
    fi

    # Remove anything after a space if any
    expected_opt_error="${expected_opt_error% *}"

    echo "${expected_opt_error}"
}

###############################
###       PRINT UTILS       ###
###############################

function error()
{
    echo "${RED}Error: $1${RESET_FORMAT}" >&2
}

function info()
{
    echo "${CYAN}$1${RESET_FORMAT}"
}

function print_with_indent()
{
    local indent_string=$1
    local to_print=$2

    echo "${to_print}" | awk '{ print "'"${indent_string}"'" $0; }'
}

###############################
###      TEST ASSERTS       ###
###############################

function expect_output()
{
    local test_output_file=$1
    local expected_content=$2

    local found_expected_line=$(grep --fixed-strings "${expected_content}" "${test_output_file}")
    if [ "${found_expected_line}" == "" ]; then
        error "Expected output:"
        print_with_indent "    " "${expected_content}"
        echo "${CYAN}Could not be found in test output:${RESET_FORMAT}"
        print_with_indent "    " "$(cat ${test_output_file})"
        error_occured=1
    fi
}

function expect_file()
{
    local expected_file=$1

    if [ ! -f "${expected_file}" ]; then
        error "Expected file not found: ${expected_file}"
        error_occured=1
    fi
}

function expect_file_content()
{
    local file=$1
    local expected_content=$2

    local file_content_match=$(grep --fixed-strings "${expected_content}" "${file}")
    if [ "${file_content_match}" == "" ]; then
        error "Expected ${file} content:"
        print_with_indent "    " "${expected_content}"
        echo "${CYAN}But found:${RESET_FORMAT}"
        file_content=$(cat "${file}")
        print_with_indent "    " "${file_content}"
        error_occured=1
    fi
}

function expect_exit_code()
{
    local test_exit_code=$1
    local expected_exit_code=$2

    if [ $test_exit_code -ne $expected_exit_code ]; then
        error "Expected exit code ${expected_exit_code}, but got ${test_exit_code}"
        error_occured=1
    fi
}
