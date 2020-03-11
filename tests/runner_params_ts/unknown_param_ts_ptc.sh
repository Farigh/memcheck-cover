# ! /bin/bash

test_parameter=$1

resolved_script_path=$(readlink -f "$0")
current_script_dir=$(dirname "${resolved_script_path}")
current_full_path=$(readlink -e "${current_script_dir}")

test_utils_import=$(readlink -e "${current_full_path}/../utils.test.sh")
source "${test_utils_import}"

# List cases
test_cases=(
    "-a "
    "-p"
    "-dummy "
    "--dummy"
    "--dummy="
    "--dummy=test"
    "--dummy test"
)

list_test_cases_option "$1"

###################
###    TEST     ###
###################

function test_unknown_param()
{
    local param_to_test=$1
    local test_out_dir=$(get_test_outdir)
    local memcheck_runner="$(get_tools_bin_dir)/memcheck_runner.sh"

    # Create output dir if needed
    [ ! -d "${test_out_dir}" ] && mkdir -p "${test_out_dir}"

    # Define a different output for each test case
    local filename_suffix=$(convert_to_filename_str "${param_to_test}")
    local test_output_prefix="${test_out_dir}test${filename_suffix}"
    local test_std_output="${test_output_prefix}.out"
    local test_err_output="${test_output_prefix}.err.out"

    # Call the memcheck runner with the selected unknown param
    "${memcheck_runner}" ${param_to_test} -- dummy > "${test_std_output}" 2> "${test_err_output}"
    local test_exit_code=$?

    ### Check test output

    # Expect an error message
    expected_opt_error=$(extract_param_part_from_str "${param_to_test}")
    expect_output "${test_err_output}" "Error: Unknown option '${expected_opt_error}'"

    # Followed by the usage
    expect_output "${test_std_output}" "Info: Usage: ${memcheck_runner} [OPTIONS]... -- [BIN] [BIN_ARG]..."

    expect_exit_code $test_exit_code 1
}

# Init global
error_occured=0

# Run test
test_unknown_param "${test_parameter}"

exit $error_occured
