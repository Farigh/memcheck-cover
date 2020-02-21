# ! /bin/bash

test_parameter=$1

resolved_script_path=$(readlink -f $0)
current_script_dir=$(dirname $resolved_script_path)
current_full_path=$(readlink -e $current_script_dir)

test_utils_import=$(readlink -e "${current_full_path}/../utils.test.sh")
source "${test_utils_import}"

# List cases
test_cases=(
    "-i"
    "-i "
    "--input-dir="
    "--input-dir "
    "-o"
    "-o "
    "--output-dir="
    "--output-dir "
)

list_test_cases_option "$1"

############
### TEST ###
############

function is_input_param()
{
    local opt_to_test=$1

    # An input param starts with -i for it's short form or --i for it's long one
    [ "${opt_to_test:0:2}" == "-i" ] || [ "${opt_to_test:0:3}" == "--i" ]
}

function test_missing_mandatory_param()
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

    local other_mandatory_param="-i"
    local expected_option_error="-o|--output-dir"
    if is_input_param "${param_to_test}"; then
        other_mandatory_param="-o"
        expected_option_error="-i|--input-dir"
    fi

    # Call the html report generator with the other mandatory option only
    $generate_html_report ${other_mandatory_param} ${test_out_dir} > "${test_std_output}" 2> "${test_err_output}"
    local test_exit_code=$?

    ### Check test output

    # Expect an error message
    expect_output "${test_err_output}" "Error: Mandatory parameter '${expected_option_error}' not provided"

    # Followed by the usage
    expect_output "${test_std_output}" "Info: Usage: ${generate_html_report} [OPTIONS]..."

    expect_exit_code $test_exit_code 1
}

# Init global
error_occured=0

# Run test
test_missing_mandatory_param "${test_parameter}"

exit $error_occured
