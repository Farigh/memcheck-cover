#! /bin/bash

#####
##
## This script is a helper to set the current tests output as the new reference
##
## This script expects the `make tests` target to have been called first
##
#####

resolved_script_path=$(readlink -f "$0")
current_script_dir=$(dirname "${resolved_script_path}")
current_full_path=$(readlink -e "${current_script_dir}")

memcheck_cover_test_dir="${current_full_path}/../tests/generate_html_outputs_ts/"

for test_ref_dir in "${memcheck_cover_test_dir}/ref/"*; do
    test_name=$(basename "${test_ref_dir}")

    if [ "${test_name}" == "many_result_report" ] || [ "${test_name}" == "no_error_report" ] \
        || [ "${test_name}" == "violation_context_report" ] || [ "${test_name}" == "violation_suppression_report" ]; then
        cp -f "${memcheck_cover_test_dir}out/${test_name}/report/"*html* "${test_ref_dir}"
    elif [ "${test_name}" == "path_prefix_substitution" ]; then
        for testcase_ref_dir in "${memcheck_cover_test_dir}/ref/${test_name}/"*; do
            test_case_name=$(basename "${testcase_ref_dir}")
            cp -f "${memcheck_cover_test_dir}out/${test_name}/${test_case_name:0: -7}/report/"*html* "${test_ref_dir}/${test_case_name}"
        done
    else
        test_name="${test_name:0: -7}"

        cp -f "${memcheck_cover_test_dir}out/error_report/${test_name}-default_criticality/report/"*html* "${test_ref_dir}"
    fi
done
