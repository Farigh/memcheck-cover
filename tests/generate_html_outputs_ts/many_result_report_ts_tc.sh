# ! /bin/bash

test_parameter=$1

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
    local binary_name=$1
    local test_out_dir=$(get_test_outdir)
    local memcheck_runner="$(get_tools_bin_dir)/memcheck_runner.sh"

    local test_bin_fullpath=$binary_name
    if [ "${test_bin_fullpath}" == "true" ]; then
        test_bin_fullpath="true can take useless params and still be one true self"
    else
        test_bin_fullpath=$(get_test_bin_fullpath "${binary_name}")
    fi

    # Create output dir if needed
    [ ! -d "${test_out_dir}" ] && mkdir -p "${test_out_dir}"

    local test_std_output="${test_out_dir}${binary_name}.memcheck_gen.out"
    local test_err_output="${test_out_dir}${binary_name}.memcheck_gen.err.out"

    # Call the memcheck runner with it's output set to ${test_out_dir}${binary_name}.memcheck
    $memcheck_runner -o${test_out_dir}${binary_name} -- ${test_bin_fullpath} > "${test_std_output}" 2> "${test_err_output}"

    expect_file "${test_out_dir}${binary_name}.memcheck"

    anonymize_memcheck_file "${test_out_dir}${binary_name}.memcheck"
}

function generate_ref_report()
{
    local test_ref_report_dir="${current_full_path}/ref/many_result_report/"

    # Copy every other test's ref .html.part files
    local ref_path
    for ref_path in $(find ${current_full_path}/ref/ -mindepth 1 -maxdepth 1 -type d); do
        # Skip current test ref directory
        if [[ "${ref_path}" == *"many_result_report" ]]; then
            continue
        fi

        cp "${ref_path}/"*.html.part "${test_ref_report_dir}"
    done

    local last_report_id=0

    # Update the report id from those .html.part
    local html_part_file
    for html_part_file in $(find ${test_ref_report_dir} -name "*.html.part" -type f | sort); do
        ((last_report_id++))

        awk -i inplace                                                                                                     \
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
    done
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
    $generate_html_report -i ${test_out_dir} -o ${report_out_dir} > "${test_std_output}" 2> "${test_err_output}"
    local test_exit_code=$?

    ### Check test output

    # Compare report output with reference reports
    expect_dir_content_to_match "${test_ref_report_dir}" "${report_out_dir}"

    expect_exit_code $test_exit_code 0
}

# Init global
error_occured=0

# Prepare test
for binary_path in $(find $(get_test_bin_dir) -mindepth 1 -maxdepth 1 -type d); do
    binary_name=$(basename "${binary_path}")
    generate_memcheck_report "${binary_name}"
done

generate_memcheck_report "true"

# Generate ref report
generate_ref_report

# Run test
test_many_result_report

exit $error_occured
