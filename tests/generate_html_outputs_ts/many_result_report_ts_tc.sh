#! /usr/bin/env bash

resolved_script_path=$(readlink -f "$0")
current_script_dir=$(dirname "${resolved_script_path}")
current_full_path=$(readlink -e "${current_script_dir}")

test_utils_import=$(readlink -e "${current_full_path}/../utils.test.sh")
source "${test_utils_import}"

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

function test_many_result_report()
{
    local test_out_dir=$(get_test_outdir)
    local generate_html_report="$(get_tools_bin_dir)/generate_html_report.sh"

    local test_std_output="${test_out_dir}test.out"
    local test_err_output="${test_out_dir}test.err.out"

    local test_ref_report_dir="${current_full_path}/ref/many_result_report/"
    local report_out_dir="${test_out_dir}report/"

    # Call the html report generator with the ${test_out_dir} as input directory
    # and the ${report_out_dir} as output directory
    "${generate_html_report}" -i "${test_out_dir}" -o "${report_out_dir}" > "${test_std_output}" 2> "${test_err_output}"
    local test_exit_code=$?

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
test_many_result_report

exit $error_occured
