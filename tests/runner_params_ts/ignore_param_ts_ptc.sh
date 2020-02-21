# ! /bin/bash

test_parameter=$1

resolved_script_path=$(readlink -f $0)
current_script_dir=$(dirname $resolved_script_path)
current_full_path=$(readlink -e $current_script_dir)

test_utils_import=$(readlink -e "${current_full_path}/../utils.test.sh")
source "${test_utils_import}"

# List cases
test_cases=(
    "-i "
    "-i"
    "--ignore "
    "--ignore="
)

list_test_cases_option "$1"

############
### TEST ###
############

function test_ignore_param()
{
    local param_to_test=$1
    local test_out_dir=$(get_test_outdir)
    local memcheck_runner="$(get_tools_bin_dir)/memcheck_runner.sh"

    local definitely_lost_bin=$(get_definitely_lost_bin)
    local definitely_lost_ignore_file="${current_full_path}/definitely_lost.ignore"

    # Create output dir if needed
    [ ! -d "${test_out_dir}" ] && mkdir -p "${test_out_dir}"

    # Define a different output for each test case
    local filename_suffix=$(convert_to_filename_str "${param_to_test}")
    local test_output_prefix="${test_out_dir}test${filename_suffix}"
    local test_std_output="${test_output_prefix}.out"
    local test_err_output="${test_output_prefix}.err.out"

    # Call the memcheck runner with it's output set to ${test_output_prefix}.memcheck
    # and the selected form of ignore param
    $memcheck_runner -o${test_output_prefix} ${param_to_test}${definitely_lost_ignore_file} -- ${definitely_lost_bin} > "${test_std_output}" 2> "${test_err_output}"
    local test_exit_code=$?

    ### Check test output

    # Expect ignore file to be print
    expect_output "${test_std_output}" "Info: Memcheck suppression file set to: '${definitely_lost_ignore_file}'"

    local expected_file="${test_output_prefix}.memcheck"
    expect_file "${expected_file}"
    if [ $error_occured -eq 0 ]; then
        expect_file_content "${expected_file}" "== Command: ${definitely_lost_bin}"

        # Expect suppression to have occured
        expect_file_content "${expected_file}" "== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 1 from 1)"
    fi

    expect_exit_code $test_exit_code 0
}

# Init global
error_occured=0

# Run test
test_ignore_param "${test_parameter}"

exit $error_occured
