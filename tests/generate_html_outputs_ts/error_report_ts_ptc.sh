# ! /bin/bash

test_parameter=$1

resolved_script_path=$(readlink -f $0)
current_script_dir=$(dirname $resolved_script_path)
current_full_path=$(readlink -e $current_script_dir)

test_utils_import=$(readlink -e "${current_full_path}/../utils.test.sh")
source "${test_utils_import}"

# List all available test bin as test-cases
test_cases=()
for binary_path in $(find $(get_test_bin_dir) -mindepth 1 -maxdepth 1 -type d); do
    binary_name=$(basename "${binary_path}")
    test_cases+=("${binary_name}")
done

list_test_cases_option "$1"

############
### TEST ###
############

function generate_memcheck_report()
{
    local binary_name=$1
    local test_out_dir=$(get_test_outdir)
    local memcheck_runner="$(get_tools_bin_dir)/memcheck_runner.sh"
    local test_bin_fullpath=$(get_test_bin_fullpath "${binary_name}")

    local test_case_out_dir="${test_out_dir}${binary_name}/"

    # Create output dir if needed
    [ ! -d "${test_case_out_dir}" ] && mkdir -p "${test_case_out_dir}"

    local test_std_output="${test_case_out_dir}${binary_name}.memcheck_gen.out"
    local test_err_output="${test_case_out_dir}${binary_name}.memcheck_gen.err.out"

    # Call the memcheck runner with it's output set to ${test_case_out_dir}${binary_name}.memcheck
    $memcheck_runner -o${test_case_out_dir}${binary_name} -- ${test_bin_fullpath} > "${test_std_output}" 2> "${test_err_output}"

    expect_file "${test_case_out_dir}${binary_name}.memcheck"

    anonymize_memcheck_file "${test_case_out_dir}${binary_name}.memcheck"
}

function test_error_report()
{
    local binary_name=$1
    local test_out_dir=$(get_test_outdir)
    local generate_html_report="$(get_tools_bin_dir)/generate_html_report.sh"

    local test_case_out_dir="${test_out_dir}${binary_name}/"

    local test_std_output="${test_case_out_dir}test.out"
    local test_err_output="${test_case_out_dir}test.err.out"

    local test_ref_report_dir="${current_full_path}/ref/${binary_name}_report/"
    local report_out_dir="${test_case_out_dir}report/"

    # Call the html report generator with the ${test_case_out_dir} as input directory
    # and the ${report_out_dir} as output directory
    $generate_html_report -i ${test_case_out_dir} -o ${report_out_dir} > "${test_std_output}" 2> "${test_err_output}"
    local test_exit_code=$?

    ### Check test output

    # Expect HTML part files
    expect_file "${report_out_dir}${binary_name}.memcheck.html.part"

    # Compare report output with reference reports
    expect_dir_content_to_match "${test_ref_report_dir}" "${report_out_dir}"

    expect_exit_code $test_exit_code 0
}

# Init global
error_occured=0

# Prepare test
generate_memcheck_report "${test_parameter}"

# Run test
test_error_report "${test_parameter}"

exit $error_occured
