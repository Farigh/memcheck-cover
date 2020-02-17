# ! /bin/bash

bin_dir=$1

resolved_script_path=$(readlink -f $0)
current_script_dir=$(dirname $resolved_script_path)
current_full_path=$(readlink -e $current_script_dir)

test_utils_import=$(readlink -e "${current_full_path}/../utils.test.sh")
source "${test_utils_import}"

###################
###    TEST     ###
###################

function test_cant_create_outdir()
{
    local test_out_dir=$(get_test_outdir)
    local memcheck_runner="${bin_dir}memcheck_runner.sh"

    # Use true as it's a simple, 0 returning cmd
    local test_cmd="true"

    # Create output dir if needed
    [ ! -d "${test_out_dir}" ] && mkdir -p "${test_out_dir}"

    # Create out as a file, so that the out/dummy file
    local dummy_runner_ouput_dir="${test_out_dir}out"
    touch "${dummy_runner_ouput_dir}"

    local test_std_output="${test_out_dir}test.out"
    local test_err_output="${test_out_dir}test.err.out"

    # Call the memcheck runner
    $memcheck_runner -o ${dummy_runner_ouput_dir}/dummy -- ${test_cmd} > "${test_std_output}" 2> "${test_err_output}"
    local test_exit_code=$?

    ### Check test output

    # Expect an error message
    expect_output "${test_err_output}" "Error: Provided output name sub-dir '${dummy_runner_ouput_dir}/' exists but is not a directory"

    expect_exit_code $test_exit_code 1
}

# Init global
error_occured=0

test_cant_create_outdir

exit $error_occured
