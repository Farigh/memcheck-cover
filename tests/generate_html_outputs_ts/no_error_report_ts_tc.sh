# ! /bin/bash

resolved_script_path=$(readlink -f $0)
current_script_dir=$(dirname $resolved_script_path)
current_full_path=$(readlink -e $current_script_dir)

test_utils_import=$(readlink -e "${current_full_path}/../utils.test.sh")
source "${test_utils_import}"

############
### TEST ###
############

function generate_memcheck_report()
{
    local test_out_dir=$(get_test_outdir)
    local memcheck_runner="$(get_tools_bin_dir)/memcheck_runner.sh"
    local no_error_bin="true can take useless params and still be one true self"

    # Create output dir if needed
    [ ! -d "${test_out_dir}" ] && mkdir -p "${test_out_dir}"

    local test_std_output="${test_out_dir}memcheck_gen.out"
    local test_err_output="${test_out_dir}memcheck_gen.err.out"

    # Call the memcheck runner with it's output set to ${test_out_dir}true.memcheck
    $memcheck_runner -o${test_out_dir}true -- ${no_error_bin} > "${test_std_output}" 2> "${test_err_output}"

    expect_file "${test_out_dir}true.memcheck"

    anonymize_memcheck_file "${test_out_dir}true.memcheck"
}

function test_definitely_lost_report()
{
    local test_out_dir=$(get_test_outdir)
    local generate_html_report="$(get_tools_bin_dir)/generate_html_report.sh"

    local test_std_output="${test_out_dir}test.out"
    local test_err_output="${test_out_dir}test.err.out"

    local test_ref_report_dir="${current_full_path}/ref/no_error_report/"
    local report_out_dir="${test_out_dir}report/"

    # Call the html report generator with the ${test_out_dir} as input directory
    # and the ${report_out_dir} as output directory
    $generate_html_report -i ${test_out_dir} -o ${report_out_dir} > "${test_std_output}" 2> "${test_err_output}"
    local test_exit_code=$?

    ### Check test output

    # Expect HTML part files
    expect_file "${report_out_dir}true.memcheck.html.part"

    # Compare report output with reference reports
    expect_dir_content_to_match "${test_ref_report_dir}" "${report_out_dir}"

    expect_exit_code $test_exit_code 0
}

# Init global
error_occured=0

# Prepare test
generate_memcheck_report

# Run test
test_definitely_lost_report

exit $error_occured
