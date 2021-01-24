#! /usr/bin/env bash

test_parameter=$1

resolved_script_path=$(readlink -f "$0")
current_script_dir=$(dirname "${resolved_script_path}")
current_full_path=$(readlink -e "${current_script_dir}")

test_utils_import=$(readlink -e "${current_full_path}/../utils.test.sh")
source "${test_utils_import}"

# List cases
test_cases=(
    "deletion"
    "with_substitution_lt_and_gt"
    "with_substitution_backslash"
    "with_substitution_backquote"
)

list_test_cases_option "$1"

############
### TEST ###
############

function setup_test()
{
    local test_case=$1
    local test_out_dir=$(get_test_outdir)
    local generate_html_report="$(get_tools_bin_dir)/generate_html_report.sh"

    # Create output dir if needed
    local test_case_out_dir="${test_out_dir}${test_case}/"
    [ ! -d "${test_case_out_dir}" ] && mkdir -p "${test_case_out_dir}"

    # Create config files
    local useless_result=$(cd "${test_case_out_dir}" && "${generate_html_report}" -g)
    local config_file="${test_case_out_dir}memcheck-cover.config"
    expect_file "${config_file}"
	
    if [ "${test_case}" == "with_substitution_lt_and_gt" ]; then
		{
			echo "memcheck_path_prefix_replacement[\"/var/user/git_repos/computation_libs\"]=\"<computation libs>\"" 
			echo "memcheck_path_prefix_replacement[\"/var/user/git_repos/my_proj\"]=\"<my proj>\"" 
			echo "memcheck_path_prefix_replacement[\"/var/user/git_repos/another_libs\"]=\"<another lib>\"" 
		} >> "${config_file}"
    elif [ "${test_case}" == "with_substitution_backslash" ]; then
		{
			echo "memcheck_path_prefix_replacement[\"/var/user/git_repos/computation_libs\"]=\"[deps \\\\ computation]\"" 
			echo "memcheck_path_prefix_replacement[\"/var/user/git_repos/my_proj\"]=\"[my proj]\"" 
			echo "memcheck_path_prefix_replacement[\"/var/user/git_repos/another_libs\"]=\"[deps \\\\ another lib]\"" 
		} >> "${config_file}"
    elif [ "${test_case}" == "with_substitution_backquote" ]; then
		{
			echo "memcheck_path_prefix_replacement[\"/var/user/git_repos/computation_libs\"]=\"\\\`computation libs\\\`\""
			echo "memcheck_path_prefix_replacement[\"/var/user/git_repos/my_proj\"]=\"\\\`my proj\\\`\"" 
			echo "memcheck_path_prefix_replacement[\"/var/user/git_repos/another_libs\"]=\"\\\`another lib\\\`\""
		} >> "${config_file}"
    else
		{
			echo "memcheck_path_prefix_replacement[\"/var/user/git_repos/computation_libs/\"]=\"\"" 
			echo "memcheck_path_prefix_replacement[\"/var/user/git_repos/my_proj/\"]=\"\"" 
			echo "memcheck_path_prefix_replacement[\"/var/user/git_repos/another_libs/\"]=\"\""
		} >> "${config_file}"
    fi

    # Copy memcheck report if not already done
    local test_resx_dir=$(get_test_resources_dir)
    cp "${test_resx_dir}fake_multiple_path_report.memcheck" "${test_case_out_dir}"
}

function test_path_prefix_substitution()
{
    local test_case=$1
    local test_out_dir=$(get_test_outdir)
    local generate_html_report="$(get_tools_bin_dir)/generate_html_report.sh"

    local test_case_out_dir="${test_out_dir}${test_case}/"
    local test_std_output="${test_case_out_dir}test.out"
    local test_err_output="${test_case_out_dir}test.err.out"

    local test_ref_report_dir="${current_full_path}/ref/path_prefix_substitution/${test_case}_report/"
    local report_out_dir="${test_case_out_dir}report/"

    local config_file="${test_case_out_dir}memcheck-cover.config"

    # Call the html report generator with the ${test_case_out_dir} as input directory
    # and the ${report_out_dir} as output directory
    "${generate_html_report}" -i "${test_case_out_dir}" -o "${report_out_dir}" -c "${config_file}" > "${test_std_output}" 2> "${test_err_output}"
    local test_exit_code=$?

    ### Check test output

    # Expect HTML part files
    expect_file "${report_out_dir}fake_multiple_path_report.memcheck.html.part.js"

    # Compare report output with reference reports
    expect_content_to_match "${test_ref_report_dir}" "${report_out_dir}"

    expect_exit_code $test_exit_code 0
}

# Init global
error_occured=0

# Setup test
setup_test "${test_parameter}"

# Run test
test_path_prefix_substitution "${test_parameter}"

exit $error_occured
