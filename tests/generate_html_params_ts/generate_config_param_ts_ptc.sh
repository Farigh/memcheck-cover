#! /usr/bin/env bash

test_parameter=$1

resolved_script_path=$(readlink -f "$0")
current_script_dir=$(dirname "${resolved_script_path}")
current_full_path=$(readlink -e "${current_script_dir}")

test_utils_import=$(readlink -e "${current_full_path}/../utils.test.sh")
source "${test_utils_import}"

# List cases
test_cases=(
    "-g"
    "--generate-config"
)

list_test_cases_option "$1"

############
### TEST ###
############

function test_generate_config_param()
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

    # Call the html report generator with the generate-config option
    # Move to the output dir first, since the file is generated in the current dir
    $(cd "${test_out_dir}" && "${generate_html_report}" ${param_to_test} > "${test_std_output}" 2> "${test_err_output}")
    local test_exit_code=$?

    ### Check test output

    # Expect the config file to be print
    expect_output "${test_std_output}" "Info: Generating configuration with default values: 'memcheck-cover.config'..."
    expect_output "${test_std_output}" "Done. The generated configuration can be modified and then loaded"
    expect_output "${test_std_output}" "by the current script using the --config option."
    expect_output "${test_std_output}" "If a violation is not set, the default value will be used."

    # Expect config file
    local output_config_file="${test_out_dir}memcheck-cover.config"
    expect_file "${output_config_file}"

    # Check config file content
    if [ $error_occured -eq 0 ]; then
        # Expect information header
        expect_file_content "${output_config_file}" "# Memcheck-cover configuration values."
        expect_file_content "${output_config_file}" "# Each violation criticality can be set to one of those values:"
        expect_file_content "${output_config_file}" "#    - warning"
        expect_file_content "${output_config_file}" "#    - error"
        expect_file_content "${output_config_file}" "# Case does not matter."

        # Expect at least one criticality value
        expect_file_content "${output_config_file}" "# Criticality for the following violations type:"
        expect_file_content "${output_config_file}" "memcheck_violation_criticality['"
    fi

    expect_exit_code $test_exit_code 0
}

# Init global
error_occured=0

# Run test
test_generate_config_param "${test_parameter}"

exit $error_occured
