#! /usr/bin/env bash

test_parameter=$1

resolved_script_path=$(readlink -f "$0")
current_script_dir=$(dirname "${resolved_script_path}")
current_full_path=$(readlink -e "${current_script_dir}")

test_utils_import=$(readlink -e "${current_full_path}/../utils.test.sh")
source "${test_utils_import}"

# List cases
test_cases=(
    "-c"
    "-c "
    "--config="
    "--config "
)

list_test_cases_option "$1"

############
### TEST ###
############

function test_config_param()
{
    local param_to_test=$1
    local test_out_dir=$(get_test_outdir)
    local generate_html_report="$(get_tools_bin_dir)/generate_html_report.sh"

    # Create output dir if needed
    [ ! -d "${test_out_dir}" ] && mkdir -p "${test_out_dir}"

    # Define a different output for each test case
    local filename_suffix=$(convert_to_filename_str "${param_to_test}")
    local test_output_prefix="${test_out_dir}test${filename_suffix}"
    local test_std_output="${test_output_prefix}.out"
    local test_err_output="${test_output_prefix}.err.out"

    local test_in_out_dir="${test_output_prefix}/"

    # Create output dir if needed
    [ ! -d "${test_in_out_dir}" ] && mkdir -p "${test_in_out_dir}"

    local config_file="${test_in_out_dir}dummy.config"

    # Add an emptyu memcheck file, at least one is requiered
    touch "${test_in_out_dir}dummy.memcheck"

    # An empty file is a valid config
    touch "${config_file}"

    # Call the html report generator with the same input and output directory
    # Pass the configuration file param
    "${generate_html_report}" -i"${test_in_out_dir}" -o"${test_in_out_dir}" ${param_to_test}"${config_file}" > "${test_std_output}" 2> "${test_err_output}"
    local test_exit_code=$?

    ### Check test output

    # Expect the output file to be print
    expect_output "${test_std_output}" "Info: Loading configuration from file '${config_file}'..."

    expect_empty_file "${test_err_output}"

    expect_exit_code $test_exit_code 0
}

# Init global
error_occured=0

# Run test
test_config_param "${test_parameter}"

exit $error_occured
