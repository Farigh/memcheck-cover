#! /usr/bin/env bash

test_parameter=$1

resolved_script_path=$(readlink -f "$0")
current_script_dir=$(dirname "${resolved_script_path}")
current_full_path=$(readlink -e "${current_script_dir}")

test_utils_import=$(readlink -e "${current_full_path}/../utils.test.sh")
source "${test_utils_import}"

# List cases
test_cases=(
    "no_types"
    "unknown_types"
    "lower_case_types"
    "snake_case_types"
    "mixed_case_types"
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

    {
        if [ "${test_case}" == "no_types" ] || [ "${test_case}" == "unknown_types" ]; then
            echo "memcheck_url_prefix_replacement[\"/var/user/git_repos/computation_libs/\"]=\"whatever\""
            echo "memcheck_url_prefix_replacement[\"/var/user/git_repos/my_proj/\"]=\"whatever\""
            echo "memcheck_url_prefix_replacement[\"/var/user/git_repos/another_libs/\"]=\"whatever\""

            if [ "${test_case}" == "no_types" ]; then
                echo "memcheck_url_prefix_replacement_type[\"/var/user/git_repos/computation_libs/\"]=\"\""
                echo "memcheck_url_prefix_replacement_type[\"/var/user/git_repos/my_proj/\"]=\"\""
                echo "memcheck_url_prefix_replacement_type[\"/var/user/git_repos/another_libs/\"]=\"\""
            else
                echo "memcheck_url_prefix_replacement_type[\"/var/user/git_repos/computation_libs/\"]=\"unknown\""
                echo "memcheck_url_prefix_replacement_type[\"/var/user/git_repos/my_proj/\"]=\"unknown\""
                echo "memcheck_url_prefix_replacement_type[\"/var/user/git_repos/another_libs/\"]=\"unknown\""
            fi
        else
            echo "memcheck_url_prefix_replacement[\"/var/user/git_repos/computation_libs/\"]=\"http://mygithub.io/example/example_project/blob/master/\""
            echo "memcheck_url_prefix_replacement[\"/var/user/git_repos/my_proj/\"]=\"http://mygitlab.io/example/example_project/-/blob/master/\""
            echo "memcheck_url_prefix_replacement[\"/var/user/git_repos/another_libs/\"]=\"http://mybitbucket.io/example/example_project/src/master/\""

            if [ "${test_case}" == "lower_case_types" ]; then
                echo "memcheck_url_prefix_replacement_type[\"/var/user/git_repos/computation_libs/\"]=\"github\""
                echo "memcheck_url_prefix_replacement_type[\"/var/user/git_repos/my_proj/\"]=\"gitlab\""
                echo "memcheck_url_prefix_replacement_type[\"/var/user/git_repos/another_libs/\"]=\"bitbucket\""
            elif [ "${test_case}" == "snake_case_types" ]; then
                echo "memcheck_url_prefix_replacement_type[\"/var/user/git_repos/computation_libs/\"]=\"GitHub\""
                echo "memcheck_url_prefix_replacement_type[\"/var/user/git_repos/my_proj/\"]=\"GitLab\""
                echo "memcheck_url_prefix_replacement_type[\"/var/user/git_repos/another_libs/\"]=\"BitBucket\""
            else
                echo "memcheck_url_prefix_replacement_type[\"/var/user/git_repos/computation_libs/\"]=\"GITHUB\""
                echo "memcheck_url_prefix_replacement_type[\"/var/user/git_repos/my_proj/\"]=\"gitLAB\""
                echo "memcheck_url_prefix_replacement_type[\"/var/user/git_repos/another_libs/\"]=\"BITbucket\""
            fi
        fi
    } >> "${config_file}"

    # Copy memcheck report if not already done
    local test_resx_dir=$(get_test_resources_dir)
    cp "${test_resx_dir}fake_multiple_path_report.memcheck" "${test_case_out_dir}"
}

function test_path_url_link_generation()
{
    local test_case=$1
    local test_out_dir=$(get_test_outdir)
    local generate_html_report="$(get_tools_bin_dir)/generate_html_report.sh"

    local test_case_out_dir="${test_out_dir}${test_case}/"
    local test_std_output="${test_case_out_dir}test.out"
    local test_err_output="${test_case_out_dir}test.err.out"

    local test_ref_report_dir="${current_full_path}/ref/path_url_link_generation_report/"
    local report_out_dir="${test_case_out_dir}report/"

    local config_file="${test_case_out_dir}memcheck-cover.config"

    # Call the html report generator with the ${test_case_out_dir} as input directory
    # and the ${report_out_dir} as output directory
    "${generate_html_report}" -i "${test_case_out_dir}" -o "${report_out_dir}" -c "${config_file}" > "${test_std_output}" 2> "${test_err_output}"
    local test_exit_code=$?

    ### Check test output

    if [ "${test_case}" == "no_types" ] || [ "${test_case}" == "unknown_types" ]; then

        if [ "${test_case}" == "no_types" ]; then
            expect_output "${test_err_output}" "Error: 'memcheck_url_prefix_replacement_type' not set for key '/var/user/git_repos/computation_libs/'"
            expect_output "${test_err_output}" "Error: 'memcheck_url_prefix_replacement_type' not set for key '/var/user/git_repos/another_libs/'"
            expect_output "${test_err_output}" "Error: 'memcheck_url_prefix_replacement_type' not set for key '/var/user/git_repos/my_proj/'"
        else
            expect_output "${test_err_output}" "Error: Invalid configuration value 'unknown' for parameter: memcheck_url_prefix_replacement_type['/var/user/git_repos/computation_libs/']"
            expect_output "${test_err_output}" "Error: Invalid configuration value 'unknown' for parameter: memcheck_url_prefix_replacement_type['/var/user/git_repos/another_libs/']"
            expect_output "${test_err_output}" "Error: Invalid configuration value 'unknown' for parameter: memcheck_url_prefix_replacement_type['/var/user/git_repos/my_proj/']"
        fi

        expect_exit_code $test_exit_code 1
    else
        # Expect HTML part files
        expect_file "${report_out_dir}fake_multiple_path_report.memcheck.html.part.js"

        # Compare report output with reference reports
        expect_content_to_match "${test_ref_report_dir}" "${report_out_dir}"

        expect_empty_file "${test_err_output}"

        expect_exit_code $test_exit_code 0
    fi
}

# Init global
error_occured=0

# Setup test
setup_test "${test_parameter}"

# Run test
test_path_url_link_generation "${test_parameter}"

exit $error_occured
