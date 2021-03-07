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
    local generate_html_report="$(get_tools_bin_dir)/generate_html_report.sh"

    # Create output dir if needed
    [ ! -d "${test_out_dir}" ] && mkdir -p "${test_out_dir}"

    # Create config files
    local useless_result=$(cd "${test_out_dir}" && "${generate_html_report}" -g)
    local config_file="${test_out_dir}memcheck-cover.config"
    expect_file "${config_file}"

    # Create output dir if needed
    [ ! -d "${test_out_dir}" ] && mkdir -p "${test_out_dir}"

    {
        # Path prefix substitution
        echo "memcheck_path_prefix_replacement[\"/var/user/git_repos/computation_libs\"]=\"[deps / computation]\""
        echo "memcheck_path_prefix_replacement[\"/var/user/git_repos/my_proj\"]=\"[my proj]\""
        echo "memcheck_path_prefix_replacement[\"/var/user/git_repos/another_libs\"]=\"[deps / another lib]\""

        # Source control link generation
        echo "memcheck_url_prefix_replacement[\"/var/user/git_repos/computation_libs/\"]=\"http://mygithub.io/example/example_project/blob/master/\""
        echo "memcheck_url_prefix_replacement[\"/var/user/git_repos/my_proj/\"]=\"http://mygitlab.io/example/example_project/-/blob/master/\""
        echo "memcheck_url_prefix_replacement[\"/var/user/git_repos/another_libs/\"]=\"http://mybitbucket.io/example/example_project/src/master/\""
        echo "memcheck_url_prefix_replacement_type[\"/var/user/git_repos/computation_libs/\"]=\"github\""
        echo "memcheck_url_prefix_replacement_type[\"/var/user/git_repos/my_proj/\"]=\"gitlab\""
        echo "memcheck_url_prefix_replacement_type[\"/var/user/git_repos/another_libs/\"]=\"bitbucket\""
    } >> "${config_file}"

    # Copy memcheck report if not already done
    local test_resx_dir=$(get_test_resources_dir)
    cp "${test_resx_dir}fake_multiple_path_report.memcheck" "${test_out_dir}"
}

function test_combined_path_substitution_and_url_link()
{
    local test_out_dir=$(get_test_outdir)
    local generate_html_report="$(get_tools_bin_dir)/generate_html_report.sh"

    local test_std_output="${test_out_dir}test.out"
    local test_err_output="${test_out_dir}test.err.out"

    local test_ref_report_dir="${current_full_path}/ref/combined_path_substitution_and_url_link_report/"
    local report_out_dir="${test_out_dir}report/"

    local config_file="${test_out_dir}memcheck-cover.config"

    # Call the html report generator with the ${test_out_dir} as input directory
    # and the ${report_out_dir} as output directory
    "${generate_html_report}" -i "${test_out_dir}" -o "${report_out_dir}" -c "${config_file}" > "${test_std_output}" 2> "${test_err_output}"
    local test_exit_code=$?

    ### Check test output

    # Expect HTML part files
    expect_file "${report_out_dir}fake_multiple_path_report.memcheck.html.part.js"

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
test_combined_path_substitution_and_url_link

exit $error_occured
