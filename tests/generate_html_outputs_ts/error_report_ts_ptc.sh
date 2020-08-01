#! /usr/bin/env bash

test_parameter=$1

resolved_script_path=$(readlink -f "$0")
current_script_dir=$(dirname "${resolved_script_path}")
current_full_path=$(readlink -e "${current_script_dir}")

test_utils_import=$(readlink -e "${current_full_path}/../utils.test.sh")
source "${test_utils_import}"

# List all available test bin as test-cases
test_cases=()
while read -r binary_path; do
    binary_name=$(basename "${binary_path}")

    test_cases+=("${binary_name},default_criticality")

    # Only the default is relevent for valgrind's warning (since it's not configurable)
    if [ "${binary_name}" != "valgrind_warnings" ]; then
        test_cases+=("${binary_name},all_warnings_criticality")
        test_cases+=("${binary_name},all_errors_criticality")
    fi
done < <(find "$(get_test_bin_dir)" -mindepth 1 -maxdepth 1 -type d | sort)

list_test_cases_option "$1"

############
### TEST ###
############

function setup_test()
{
    local binary_name=$1
    local criticality_config_type=$2
    local test_out_dir=$(get_test_outdir)
    local testsuite_setup_out_dir=$(get_testsuite_setup_outdir)

    # Create output dir if needed
    local current_test_out_dir="${test_out_dir}${binary_name}-${criticality_config_type}/"
    [ ! -d "${current_test_out_dir}" ] && mkdir -p "${current_test_out_dir}"

    cp "${testsuite_setup_out_dir}${binary_name}.memcheck" "${current_test_out_dir}"
}

function convert_ref()
{
    local test_ref_report_dir=$1
    local new_criticality_level=$2

    # Convert ref HTML parts
    local new_criticality_css_class="${new_criticality_level}_leak"
    gawk -i inplace "{                                                                        \
                        print gensub(/class=\"[^\"]*_leak\"/,                                 \
                                     \"class=\\\"${new_criticality_css_class}\\\"\", \"g\");  \
                     }"                                                                       \
        "${test_ref_report_dir}"*.html.part

    ####
    # Convert ref HTML file
    ####

    # Convert report title
    local status_pass_color="var(--summary-status-pass-font-color)"
    local status_warning_color="var(--summary-status-warning-font-color)"
    local status_error_color="var(--summary-status-error-font-color)"

    local warning_percentage="100"
    if [ "${new_criticality_level}" == "error" ]; then
        warning_percentage="0"
    fi
    local new_criticality_css_bg=' style="background-image: linear-gradient(to right, '
    new_criticality_css_bg+="${status_pass_color} 0%, ${status_warning_color} 0%, ${status_warning_color} ${warning_percentage}%, "
    new_criticality_css_bg+="${status_error_color} ${warning_percentage}%"
    new_criticality_css_bg+=", ${status_error_color} 100%);\">"
    local sed_replace_title="s/\(report_summary_ratio\" title=\"\)[^:]*: \([0-9]*\"\).*/\\1${new_criticality_level^}s: \\2${new_criticality_css_bg}/g"

    # Convert summary (right after the title)
    local sed_replace_summary="s/\(report_summary_\)[ew][^\"]*\">[^:]*:/\\1${new_criticality_level}s\">${new_criticality_level^}s:/g"

    # Convert analysis title status
    local sed_replace_analysis_status="s/\(analysis_\)[^_]*\(_status\">\)[^<]*/\\1${new_criticality_level}\\2${new_criticality_level^^}/g"

    sed -i "${sed_replace_title};${sed_replace_summary};${sed_replace_analysis_status}" "${test_ref_report_dir}index.html"
}

function test_error_report()
{
    local binary_name=$1
    local criticality_config_type=$2
    local test_out_dir=$(get_test_outdir)
    local generate_html_report="$(get_tools_bin_dir)/generate_html_report.sh"

    local test_case_out_dir="${test_out_dir}${binary_name}-${criticality_config_type}/"

    local test_std_output="${test_case_out_dir}test.out"
    local test_err_output="${test_case_out_dir}test.err.out"

    local test_ref_report_dir="${current_full_path}/ref/${binary_name}_report/"
    local report_out_dir="${test_case_out_dir}report/"

    if [ "${criticality_config_type}" != "default_criticality" ]; then
        # Copy default criticality ref dir
        local current_test_case_out_dir="${test_case_out_dir}ref/"

        mkdir -p "${current_test_case_out_dir}"
        cp "${test_ref_report_dir}"* "${current_test_case_out_dir}"
        test_ref_report_dir="${current_test_case_out_dir}"

        local all_criticality_level="error"
        if [ "${criticality_config_type}" == "all_warnings_criticality" ]; then
            all_criticality_level="warning"
        fi

        # Replace default criticality by the selected one
        convert_ref "${test_ref_report_dir}" "${all_criticality_level}"

        # Add the config file to the params
        local testsuite_setup_out_dir=$(get_testsuite_setup_outdir)
        local config_param=(-c "${testsuite_setup_out_dir}memcheck-cover.${all_criticality_level}.config")
    fi

    # Call the html report generator with the ${test_case_out_dir} as input directory
    # and the ${report_out_dir} as output directory
    "${generate_html_report}" -i "${test_case_out_dir}" -o "${report_out_dir}" "${config_param[@]}" > "${test_std_output}" 2> "${test_err_output}"
    local test_exit_code=$?

    ### Check test output

    # Expect HTML part files
    expect_file "${report_out_dir}${binary_name}.memcheck.html.part"

    # Compare report output with reference reports
    expect_content_to_match "${test_ref_report_dir}" "${report_out_dir}"

    expect_exit_code $test_exit_code 0
}

# Init global
error_occured=0

test_binary_param="${test_parameter%%,*}"
test_criticality_config_type="${test_parameter##*,}"

# Setup test
setup_test "${test_binary_param}" "${test_criticality_config_type}"

# Run test
test_error_report "${test_binary_param}" "${test_criticality_config_type}"

exit $error_occured
