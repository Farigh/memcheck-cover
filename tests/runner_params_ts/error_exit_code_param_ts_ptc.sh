#! /usr/bin/env bash

test_parameter=$1

resolved_script_path=$(readlink -f "$0")
current_script_dir=$(dirname "${resolved_script_path}")
current_full_path=$(readlink -e "${current_script_dir}")

test_utils_import=$(readlink -e "${current_full_path}/../utils.test.sh")
source "${test_utils_import}"

# List cases
test_cases=(
    "--error-exitcode "
    "--error-exitcode="
)

list_test_cases_option "$1"

############
### TEST ###
############

function test_error_exit_code_param()
{
    local param_to_test=$1
    local memcheck_runner="$(get_tools_bin_dir)/memcheck_runner.sh"
    local test_out_dir=$(get_test_outdir)

    # Use true as it's a simple, 0 returning cmd
    local test_cmd="true"

    # Create output dir if needed
    [ ! -d "${test_out_dir}" ] && mkdir -p "${test_out_dir}"

    # Define a different output for each test case
    local filename_suffix=$(convert_to_filename_str "${param_to_test}")
    local test_output_prefix="${test_out_dir}test${filename_suffix}"
    local test_std_output="${test_output_prefix}.out"
    local test_err_output="${test_output_prefix}.err.out"

    # Call the memcheck runner with its exit-code set to 42
    local exit_code_value=42

    "${memcheck_runner}" -o"${test_output_prefix}" ${param_to_test}"${exit_code_value}" -- "${test_cmd}" > "${test_std_output}" 2> "${test_err_output}"
    local test_exit_code=$?

    ### Check test output

    # Expect the output file to be printed
    expect_output "${test_std_output}" "Info: Valgrind error-exitcode set to '${exit_code_value}'"

    # Followed by the cmd
    expect_output "${test_std_output}" "Info: Running the following cmd with valgrind:"

    local memcheck_output="${test_output_prefix}.memcheck"
    expect_file "${memcheck_output}"
    expect_file_content "${memcheck_output}" "== Command: ${test_cmd}"

    expect_empty_file "${test_err_output}"

    expect_exit_code $test_exit_code 0
}

# Init global
error_occured=0

# Run test
test_error_exit_code_param "${test_parameter}"

exit $error_occured
