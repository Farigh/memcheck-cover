#! /usr/bin/env bash

test_parameter=$1

resolved_script_path=$(readlink -f "$0")
current_script_dir=$(dirname "${resolved_script_path}")
current_full_path=$(readlink -e "${current_script_dir}")

test_utils_import=$(readlink -e "${current_full_path}/../utils.test.sh")
source "${test_utils_import}"

# List cases
test_cases=(
    "invalid_file_format"
    "invalid_summary_criticality_key"
    "invalid_summary_criticality_value"
    "invalid_violation_criticality_key"
    "invalid_violation_criticality_value"
)

list_test_cases_option "$1"

############
### TEST ###
############

function generate_invalid_config()
{
    local param_to_test=$1

    if [ "${param_to_test}" == "invalid_summary_criticality_key" ]; then

        # The 'dummy' key does not exists
        echo "memcheck_summary_criticality['dummy']=\"error\""

    elif [ "${param_to_test}" == "invalid_summary_criticality_value" ]; then

        # Invalid criticality value
        echo "memcheck_summary_criticality['possibly_lost']=\"not a valid value\""

    elif [ "${param_to_test}" == "invalid_violation_criticality_key" ]; then

        # The 'dummy' key does not exists
        echo "memcheck_violation_criticality['dummy']=\"error\""

    elif [ "${param_to_test}" == "invalid_violation_criticality_value" ]; then

        # Invalid criticality value
        echo "memcheck_violation_criticality['definitely_lost']=\"not a valid value\""

    else # invalid_file_format

        # Having spaces around assignment is invalid bash syntaxe
        echo "memcheck_violation_criticality['definitely_lost'] = \"error\""

    fi
}

function test_invalid_config()
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

    local config_file="${test_output_prefix}.config"

    # Generate config
    generate_invalid_config "${param_to_test}" > "${config_file}"

    # Call the html report generator with the ${test_out_dir} as input directory
    # and the ${report_out_dir} as output directory
    "${generate_html_report}" -i "${test_out_dir}" -o "${test_out_dir}" -c "${config_file}" > "${test_std_output}" 2> "${test_err_output}"
    local test_exit_code=$?

    ### Check test output

    # Expect the output file to be printed
    declare -A expected_error
    expected_error['invalid_summary_criticality_key']="Error: Invalid configuration parameter: memcheck_summary_criticality['dummy']"
    expected_error['invalid_summary_criticality_value']="Error: Invalid configuration value 'not a valid value' for parameter: memcheck_summary_criticality['possibly_lost']"
    expected_error['invalid_violation_criticality_key']="Error: Invalid configuration parameter: memcheck_violation_criticality['dummy']"
    expected_error['invalid_violation_criticality_value']="Error: Invalid configuration value 'not a valid value' for parameter: memcheck_violation_criticality['definitely_lost']"
    expected_error['invalid_file_format']="Error: Loading configuration file '${config_file}' failed with errors:"

    expect_output "${test_err_output}" "${expected_error[${param_to_test}]}"

    expect_exit_code $test_exit_code 1
}

# Init global
error_occured=0

# Run test
test_invalid_config "${test_parameter}"

exit $error_occured
