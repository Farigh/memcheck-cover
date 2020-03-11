# ! /bin/bash

test_parameter=$1

resolved_script_path=$(readlink -f "$0")
current_script_dir=$(dirname "${resolved_script_path}")
current_full_path=$(readlink -e "${current_script_dir}")

test_utils_import=$(readlink -e "${current_full_path}/../utils.test.sh")
source "${test_utils_import}"

# List cases
test_cases=(
    "-o "
    "-o"
    "--output-name "
    "--output-name="
)

list_test_cases_option "$1"

############
### TEST ###
############

function test_output_param()
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

    # Call the memcheck runner with it's output set to ${test_output_prefix}/test.memcheck
    local output_file_prefix="${test_output_prefix}/test"
    "${memcheck_runner}" ${param_to_test}"${output_file_prefix}" -- ${test_cmd} > "${test_std_output}" 2> "${test_err_output}"
    local test_exit_code=$?

    ### Check test output

    # Expect the output file to be print
    local expected_file="${output_file_prefix}.memcheck"
    expect_output "${test_std_output}" "Info: Output file set to: '${expected_file}'"
    expect_output "${test_std_output}" "Info: Creating output directory '${test_output_prefix}/'"

    # Followed by the cmd
    expect_output "${test_std_output}" "Info: Running the following cmd with valgrind:"

    expect_file "${expected_file}"
    if [ $error_occured -eq 0 ]; then
        expect_file_content "${expected_file}" "== Command: ${test_cmd}"
    fi

    expect_exit_code $test_exit_code 0
}

# Init global
error_occured=0

# Run test
test_output_param "${test_parameter}"

exit $error_occured
