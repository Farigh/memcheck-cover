# ! /bin/bash

resolved_script_path=$(readlink -f $0)
current_script_dir=$(dirname $resolved_script_path)
current_full_path=$(readlink -e $current_script_dir)

test_utils_import=$(readlink -e "${current_full_path}/../utils.test.sh")
source "${test_utils_import}"

###################
###    TEST     ###
###################

function test_missing_mandatory_param()
{
    local test_out_dir=$(get_test_outdir)
    local memcheck_runner="$(get_tools_bin_dir)/memcheck_runner.sh"

    # Create output dir if needed
    [ ! -d "${test_out_dir}" ] && mkdir -p "${test_out_dir}"

    local test_std_output="${test_out_dir}test.out"
    local test_err_output="${test_out_dir}test.err.out"

    # Call the memcheck runner without the mandatory param
    $memcheck_runner -- dummy test > "${test_std_output}" 2> "${test_err_output}"
    local test_exit_code=$?

    ### Check test output

    # Expect an error message
    expect_output "${test_err_output}" "Error: Mandatory parameter '-o|--output-name' not provided"

    # Followed by the usage
    expect_output "${test_std_output}" "Info: Usage: ${memcheck_runner} [OPTIONS]... -- [BIN] [BIN_ARG]..."

    expect_exit_code $test_exit_code 1
}

# Init global
error_occured=0

test_missing_mandatory_param

exit $error_occured
