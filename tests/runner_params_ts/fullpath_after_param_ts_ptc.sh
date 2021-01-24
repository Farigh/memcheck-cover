#! /usr/bin/env bash

test_parameter=$1

resolved_script_path=$(readlink -f "$0")
current_script_dir=$(dirname "${resolved_script_path}")
current_full_path=$(readlink -e "${current_script_dir}")

test_utils_import=$(readlink -e "${current_full_path}/../utils.test.sh")
source "${test_utils_import}"

# List cases
test_cases=(
    "empty_value"
    "dummy_value"
    "tests_dir_value"
)

list_test_cases_option "$1"

############
### TEST ###
############

function test_fullpath_after_param()
{
    local param_to_test=$1
    local test_out_dir=$(get_test_outdir)
    local memcheck_runner="$(get_tools_bin_dir)/memcheck_runner.sh"

    local definitely_lost_bin=$(get_test_bin_fullpath "definitely_lost")

    # Create output dir if needed
    [ ! -d "${test_out_dir}" ] && mkdir -p "${test_out_dir}"

    # Define a different output for each test case
    local test_output_prefix="${test_out_dir}test-${param_to_test}"
    local test_std_output="${test_output_prefix}.out"
    local test_err_output="${test_output_prefix}.err.out"

    local tests_root_dir=$(dirname "${current_full_path}")

    local fullpath_after_value=""
    if [ "${param_to_test}" == "dummy_value" ]; then
        fullpath_after_value="/this/is/just/a/test/"
    elif [ "${param_to_test}" == "tests_dir_value" ]; then
        fullpath_after_value="${tests_root_dir}/"
    fi

    # Call the memcheck runner with it's output set to ${test_output_prefix}.memcheck
    # and the selected form of suppression generation param
    "${memcheck_runner}" -o"${test_output_prefix}" --fullpath-after="${fullpath_after_value}" -- "${definitely_lost_bin}" > "${test_std_output}" 2> "${test_err_output}"
    local test_exit_code=$?

    ### Check test output

    # Expect the output file to be printed
    expect_output "${test_std_output}" "Info: Adding '${fullpath_after_value}' to the fullpath-after"

    local memcheck_output="${test_output_prefix}.memcheck"
    anonymize_memcheck_file "${memcheck_output}"

    if [ "${param_to_test}" == "tests_dir_value" ]; then
        # Expect the path to have been shortened
        expect_output "${memcheck_output}" "==1==    by 0x10101042: main (bin/definitely_lost/main.cpp:10)"
    else
        # In every other cases, the fullpath have been activated without any replacement
        expect_output "${memcheck_output}" "==1==    by 0x10101042: main (${tests_root_dir}/bin/definitely_lost/main.cpp:10)"
    fi

    expect_empty_file "${test_err_output}"

    expect_exit_code $test_exit_code 0
}

# Init global
error_occured=0

# Run test
test_fullpath_after_param "${test_parameter}"

exit $error_occured
