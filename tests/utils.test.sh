# ! /bin/bash

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

function anonymize_memcheck_file()
{
    local file_to_anonymize=$1

    # Memcheck report contains process id at the start of each line
    # Replace this id with a 1
    local anonymize_sed_cmd="s/^==[0-9]*==/==1==/g"

    # The parent process id is printed
    anonymize_sed_cmd+=";s/\(==1== Parent PID:\) [0-9]*/\1 1/g"

    # Remove host specific dir path
    anonymize_sed_cmd+=";s# [^ ]*\(memcheck-cover/tests/bin/\)# \1#g"

    sed -i "${anonymize_sed_cmd}" "${file_to_anonymize}"
    sed -i "${anonymize_sed_cmd}" "${file_to_anonymize}"
}

###############################
###   PROPERTIES GETTERS    ###
###############################

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

function get_test_bin_dir()
{
    local resolved_test_path=$(readlink -f $0)
    local current_test_dir=$(dirname $resolved_test_path)
    local current_test_full_path=$(readlink -e $current_test_dir)

    readlink -e "${current_test_full_path}/../bin"
}

function get_tools_bin_dir()
{
    local resolved_test_path=$(readlink -f $0)
    local current_test_dir=$(dirname $resolved_test_path)
    local current_test_full_path=$(readlink -e $current_test_dir)

    readlink -e "${current_test_full_path}/../../bin"
}

function get_definitely_lost_bin()
{
    local test_bin_dir=$(get_test_bin_dir)

    local bin_name="definitely_lost"
    local definitely_lost_bin_dir="${test_bin_dir}/${bin_name}/"

    echo "${definitely_lost_bin_dir}out/${bin_name}"
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
        error "${RED}Expected output:${RESET_FORMAT}"
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
        error "${RED}Expected file not found:${RESET_FORMAT} ${expected_file}"
        error_occured=1
    fi
}

function expect_dir_content_to_match()
{
    local reference_dir=$1
    local to_compare_dir=$2

    local diff_output
    diff_output=$(diff -u "${reference_dir}" "${to_compare_dir}" 2>&1)

    if [ $? -ne 0 ]; then
        error "${RED}Directory does not match ref:${RESET_FORMAT}"
        local diff_output_with_special_char=$(echo "${diff_output}" | cat -A)
        print_with_indent "    " "${diff_output_with_special_char}"
        error_occured=1
    fi
}

function expect_file_content()
{
    local file_to_check=$1
    local expected_content=$2

    local file_content_match=$(grep --fixed-strings "${expected_content}" "${file_to_check}")
    if [ "${file_content_match}" == "" ]; then
        error "${RED}Expected ${file_to_check} content:${RESET_FORMAT}"
        print_with_indent "    " "${expected_content}"
        echo "${CYAN}But found:${RESET_FORMAT}"
        file_content=$(cat "${file_to_check}")
        print_with_indent "    " "${file_content}"
        error_occured=1
    fi
}

function expect_multiline_file_content()
{
    local file_to_check=$1
    local expected_multiline_content=$2

    OLDIFS=$IFS
    IFS=$'\n'
    local content_line
    for content_line in $(echo -e "${expected_multiline_content}"); do
        expect_file_content "${file_to_check}" "${content_line}"
    done
    IFS=$OLDIFS
}

function expect_exit_code()
{
    local test_exit_code=$1
    local expected_exit_code=$2

    if [ $test_exit_code -ne $expected_exit_code ]; then
        error "${RED}Expected exit code ${PURPLE}${expected_exit_code}${RED}, but got ${PURPLE}${test_exit_code}${RESET_FORMAT}"
        error_occured=1
    fi
}

# Source common utils from tools bin directory
source "$(get_tools_bin_dir)/utils.common.sh"
