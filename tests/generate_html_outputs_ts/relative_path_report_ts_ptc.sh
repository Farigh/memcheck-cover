#! /usr/bin/env bash

test_parameter=$1

resolved_script_path=$(readlink -f "$0")
current_script_dir=$(dirname "${resolved_script_path}")
current_full_path=$(readlink -e "${current_script_dir}")

test_utils_import=$(readlink -e "${current_full_path}/../utils.test.sh")
source "${test_utils_import}"

# List all available test bin as test-cases
test_cases=(
    "relative_path"
    "relative_path_no_leading_slash"
    "current_dir_in_path"
    "current_dir_in_path_no_leading_slash"
    "current_dir_out_path"
    "current_dir_out_path_no_leading_slash"
)

list_test_cases_option "$1"

############
### TEST ###
############

function setup_test()
{
    local test_out_dir=$(get_test_outdir)
    local testsuite_setup_out_dir=$(get_testsuite_setup_outdir)

    # Create output dir if needed
    [ ! -d "${test_out_dir}test/bin/" ] && mkdir -p "${test_out_dir}test/bin/"

    cp "${testsuite_setup_out_dir}"*.memcheck "${test_out_dir}test/bin/"

    # Move back the 'true' result to the root directory
    mv "${test_out_dir}test/bin/true.memcheck" "${test_out_dir}"

    # Move the 'invalid_delete' result to another sub-directory
    [ ! -d "${test_out_dir}z/test/bin/" ] && mkdir -p "${test_out_dir}z/test/bin/"
    mv "${test_out_dir}test/bin/invalid_delete.memcheck" "${test_out_dir}z/test/bin/"

    # Add a suppression example
    [ ! -d "${test_out_dir}suppressions/" ] && mkdir -p "${test_out_dir}suppressions/"
    cp "${testsuite_setup_out_dir}suppressions/uninitialized_value.memcheck" "${test_out_dir}suppressions/"
}

function error_and_exit()
{
    local error_message=$1

    error "${error_message}"
    exit 1
}

function test_relative_path_report()
{
    local test_type=$1

    local test_out_dir=$(get_test_outdir)
    local generate_html_report="$(get_tools_bin_dir)/generate_html_report.sh"

    local test_std_output="${test_out_dir}test.out"
    local test_err_output="${test_out_dir}test.err.out"

    local test_ref_report_dir="${current_full_path}/ref/many_result_report/"
    local report_out_dir="${test_out_dir}${test_type}/report/"

    # Compute parameters
    local report_generation_dir=""
    local report_in_dir_param=""
    local report_out_dir_param=""

    # Move to the base-dir for "relative_path" tests
    if [[ "${test_type}" == "relative_path"* ]]; then
        report_generation_dir=$(dirname "${test_out_dir}")
        report_in_dir_param=$(basename "${test_out_dir}")
        report_out_dir_param="${report_in_dir_param}/${test_type}/report"
    # Use current dir for "current_dir_in_path" tests
    elif [[ "${test_type}" == "current_dir_in_path"* ]]; then
        report_generation_dir="${test_out_dir}"
        report_in_dir_param="."
        report_out_dir_param="${test_type}/report/"
    else
        # Use the report dir for "current_dir_out_path" tests
        report_generation_dir="${report_out_dir}"
        report_in_dir_param="../.."
        report_out_dir_param="."

        # Report outdir needs to exist
        [ ! -d "${report_out_dir}" ] && mkdir -p "${report_out_dir}"
    fi

    if [[ "${test_type}" != *"_no_leading_slash" ]]; then
        report_in_dir_param+="/"
        report_out_dir_param+="/"
    fi

    # Move to the appropriate directory
    cd "${report_generation_dir}" > /dev/null || error_and_exit "Could not move to '${report_generation_dir}' directory"

    # Call the html report generator with the ${report_in_dir_param} as input directory
    # and the ${report_out_dir_param} as output directory
    "${generate_html_report}" -i "${report_in_dir_param}" -o "${report_out_dir_param}" > "${test_std_output}" 2> "${test_err_output}"
    local test_exit_code=$?

    # Restore directory
    cd - > /dev/null || error_and_exit "Could not move to back to the initial directory"

    ### Check test output

    # Compare report output with reference reports
    expect_content_to_match "${test_ref_report_dir}" "${report_out_dir}"

    expect_empty_file "${test_err_output}"

    expect_exit_code $test_exit_code 0
}

# Init global
error_occured=0

# Setup test
setup_test

# Run test
test_relative_path_report "${test_parameter}"

exit $error_occured
