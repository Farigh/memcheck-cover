#! /usr/bin/env bash

resolved_script_path=$(readlink -f "$0")
current_script_dir=$(dirname "${resolved_script_path}")
current_full_path=$(readlink -e "${current_script_dir}")

test_utils_import=$(readlink -e "${current_full_path}/../utils.test.sh")
source "${test_utils_import}"

test_out_dir=$(get_testsuite_setup_outdir)

function generate_memcheck_report()
{
    local binary_name=$1
    local memcheck_runner="$(get_tools_bin_dir)/memcheck_runner.sh"

    local test_bin_fullpath
    if [ "${binary_name}" == "true" ]; then
        test_bin_fullpath=(true can take useless params and still be one true self)
    else
        local non_escaped_test_bin_fullpath=$(get_test_bin_fullpath "${binary_name}")
        test_bin_fullpath=("${non_escaped_test_bin_fullpath}")
    fi

    echo -n "    > Generating memcheck report for '${binary_name}'..."

    # Create output dir if needed
    [ ! -d "${test_out_dir}" ] && mkdir -p "${test_out_dir}"

    local test_std_output="${test_out_dir}${binary_name}.memcheck_gen.out"
    local test_err_output="${test_out_dir}${binary_name}.memcheck_gen.err.out"

    # Call the memcheck runner with it's output set to ${test_out_dir}${binary_name}.memcheck
    "${memcheck_runner}" -o"${test_out_dir}${binary_name}" -- "${test_bin_fullpath[@]}" > "${test_std_output}" 2> "${test_err_output}"

    expect_file "${test_out_dir}${binary_name}.memcheck"

    # Except for invalid_write and jump_to_invalid_addr (which segfaults),
    # the error out file should be empty
    if [ "${binary_name}" != "invalid_write" ] && [ "${binary_name}" != "jump_to_invalid_addr" ]; then
        error_occured=0
        expect_empty_file "${test_err_output}"
        if [ "${error_occured}" -ne 0 ]; then
            exit 1
        fi
    fi

    anonymize_memcheck_file "${test_out_dir}${binary_name}.memcheck"

    echo "Done"
}

function generate_memcheck_report_with_suppressions()
{
    local test_violation_out_dir="${test_out_dir}suppressions/"
    local memcheck_runner="$(get_tools_bin_dir)/memcheck_runner.sh"

    # Use uninitialized_value since it has multiple violations
    local binary_name="uninitialized_value"
    local test_binary_fullpath=$(get_test_bin_fullpath "${binary_name}")

    echo -n "    > Generating memcheck report with suppressions for '${binary_name}'..."

    # Create output dir if needed
    [ ! -d "${test_violation_out_dir}" ] && mkdir -p "${test_violation_out_dir}"

    local test_std_output="${test_violation_out_dir}${binary_name}.memcheck_gen.out"
    local test_err_output="${test_violation_out_dir}${binary_name}.memcheck_gen.err.out"

    # Call the memcheck runner with it's output set to ${test_violation_out_dir}${binary_name}.memcheck
    # and the suppression generation option
    "${memcheck_runner}" -o"${test_violation_out_dir}${binary_name}" -s -- "${test_binary_fullpath}" > "${test_std_output}" 2> "${test_err_output}"

    expect_file "${test_violation_out_dir}${binary_name}.memcheck"

    anonymize_memcheck_file "${test_violation_out_dir}${binary_name}.memcheck"

    echo "Done"
}

function generate_many_result_report_ref_report()
{
    local test_ref_report_dir="${current_full_path}/ref/many_result_report/"

    echo -n "    > Generating ${CYAN}many_result_report${RESET_FORMAT} test ref report..."

    [ ! -d "${test_ref_report_dir}suppressions/" ] && mkdir -p "${test_ref_report_dir}suppressions/"
    [ ! -d "${test_ref_report_dir}test/bin/" ] && mkdir -p "${test_ref_report_dir}test/bin/"
    [ ! -d "${test_ref_report_dir}z/test/bin/" ] && mkdir -p "${test_ref_report_dir}z/test/bin/"

    # Copy every other test's ref HTML part files
    local ref_path
    while read -r ref_path; do
        # Skip generated context reports
        if [[ "${ref_path}" == *"many_result_report" ]] \
		   || [[ "${ref_path}" == *"violation_context_report" ]] \
		   || [[ "${ref_path}" == *"path_prefix_substitution" ]] \
		   || [[ "${ref_path}" == *"path_url_link_generation_report" ]] \
		   || [[ "${ref_path}" == *"combined_path_substitution_and_url_link_report" ]]; then
            continue
        fi

        if [[ "${ref_path}" == *"violation_suppression_report" ]]; then
            cp "${ref_path}/"*.html.part.js "${test_ref_report_dir}suppressions/"
        else
            cp "${ref_path}/"*.html.part.js "${test_ref_report_dir}test/bin/"
        fi
    done < <(find "${current_full_path}/ref/" -mindepth 1 -maxdepth 1 -type d)

    # Move back the 'true' result to the root directory
    mv "${test_ref_report_dir}test/bin/true.memcheck.html.part.js" "${test_ref_report_dir}"

    # Move the 'invalid_delete' result to another sub-directory
    mv "${test_ref_report_dir}test/bin/invalid_delete.memcheck.html.part.js" "${test_ref_report_dir}z/test/bin/"

    local last_report_id=0

    # Update the report id from those HTML part
    local html_part_file
    while read -r html_part_file; do
        ((last_report_id++))

        gawk -i inplace                                                                                                    \
           "{                                                                                                              \
                output = \$0;                                                                                              \
                                                                                                                           \
                if (output ~ \"valgrind.result1\") {                                                                       \
                    output = gensub(/valgrind\\.result1/, \"valgrind.result${last_report_id}\", 1, output);                \
                } else if (output ~ \"updateContentOnceLoaded1\") {                                                        \
                    output = gensub(/updateContentOnceLoaded1/, \"updateContentOnceLoaded${last_report_id}\", 1, output);  \
                };                                                                                                         \
                print output;                                                                                              \
            }" "${html_part_file}"
    done < <(find "${test_ref_report_dir}" -name "*.html.part.js" -type f | sort | gawk -f "$(get_tools_bin_dir)/awk/order_files_first.awk")

    echo "Done"
}

function generate_criticality_config()
{
    local all_criticality_level=$1
    local generate_html_report="$(get_tools_bin_dir)/generate_html_report.sh"

    echo -n "    > Generating all ${all_criticality_level} criticality config file..."

    # Generate default config file
    local result_config_file="${test_out_dir}memcheck-cover.${all_criticality_level}.config"
    local useless_result=$(cd "${test_out_dir}" && "${generate_html_report}" -g)
    mv "${test_out_dir}memcheck-cover.config" "${result_config_file}"

    if [ "${all_criticality_level}" != "default" ]; then
        # Replace all config values with the selected one
        # (uppercase the 1st char to check the case insensitivity works properly)
        sed -i "s/=\"[^\"]*\"/=\"${all_criticality_level^}\"/g" "${result_config_file}"
    fi

    # Add path replacement to avoid host specific dir path
    local test_bin_dir=$(get_test_bin_dir)
    echo "memcheck_path_prefix_replacement[\"${test_bin_dir}\"]=\"\"" >> "${result_config_file}"

    echo "Done"
}

testsuite_setup_begin

    # Generate test bins memcheck reports
    test_bin_dir=$(get_test_bin_dir)
    while read -r binary_path; do
        binary_name=$(basename "${binary_path}")
        generate_memcheck_report "${binary_name}"

        if [ "${binary_name}" == "unaddressable_bytes" ]; then
            gawk -i inplace -f "$(get_test_bin_dir)/../awk/update_unaddressable_bytes_report.awk" "${test_out_dir}${binary_name}.memcheck"
        fi
    done < <(find "${test_bin_dir}" -mindepth 1 -maxdepth 1 -type d)

    generate_criticality_config "default"
    generate_criticality_config "error"
    generate_criticality_config "warning"

    # Generate one with true (so we have a successful representative output)
    generate_memcheck_report "true"

    # Generate one with violation suppressions
    generate_memcheck_report_with_suppressions

    # Generate ref report for many_result_report test
    generate_many_result_report_ref_report

testsuite_setup_end
