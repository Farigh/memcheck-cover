#! /usr/bin/env bash

test_parameter=$1

resolved_script_path=$(readlink -f "$0")
current_script_dir=$(dirname "${resolved_script_path}")
current_full_path=$(readlink -e "${current_script_dir}")

test_utils_import=$(readlink -e "${current_full_path}/../utils.test.sh")
source "${test_utils_import}"

# List cases
test_cases=(
    "-s"
    "--gen-suppressions"
)

list_test_cases_option "$1"

############
### TEST ###
############
function test_suppression_param()
{
    local param_to_test=$1
    local test_out_dir=$(get_test_outdir)
    local memcheck_runner="$(get_tools_bin_dir)/memcheck_runner.sh"

    local definitely_lost_bin=$(get_test_bin_fullpath "definitely_lost")

    # Create output dir if needed
    [ ! -d "${test_out_dir}" ] && mkdir -p "${test_out_dir}"

    # Define a different output for each test case
    local test_output_prefix="${test_out_dir}test${param_to_test}"
    local test_std_output="${test_output_prefix}.out"
    local test_err_output="${test_output_prefix}.err.out"

    # Call the memcheck runner with it's output set to ${test_output_prefix}.memcheck
    # and the selected form of suppression generation param
    "${memcheck_runner}" -o"${test_output_prefix}" ${param_to_test} -- "${definitely_lost_bin}" > "${test_std_output}" 2> "${test_err_output}"
    local test_exit_code=$?

    ### Check test output

    # Expect ignore file to be print
    expect_output "${test_std_output}" "Info: Valgrind suppression generation enabled"

    local expected_file="${test_output_prefix}.memcheck"
    expect_file "${expected_file}"
    if [ "${error_occured}" -eq 0 ]; then
        expect_file_content "${expected_file}" "== Command: ${definitely_lost_bin// /\\ }"

        # Expect suppression generation
        expect_file_content "${expected_file}" "   <insert_a_suppression_name_here>"
        expect_file_content "${expected_file}" "   Memcheck:Leak"
        expect_file_content "${expected_file}" "   fun:_ZN8breakage25evil_definitely_lost_funcEv"
    fi

    expect_empty_file "${test_err_output}"

    expect_exit_code $test_exit_code 0
}

# Init global
error_occured=0

# Run test
test_suppression_param "${test_parameter}"

exit $error_occured
