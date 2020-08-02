#! /usr/bin/env bash

test_parameter=$1

resolved_script_path=$(readlink -f "$0")
current_script_dir=$(dirname "${resolved_script_path}")
current_full_path=$(readlink -e "${current_script_dir}")

test_utils_import=$(readlink -e "${current_full_path}/../utils.test.sh")
source "${test_utils_import}"

# List cases
test_cases=(
    "-i"
    "-i "
    "--input-dir="
    "--input-dir "
    "-o"
    "-o "
    "--output-dir="
    "--output-dir "
)

list_test_cases_option "$1"

############
### TEST ###
############

function is_input_param()
{
    local opt_to_test=$1

    # An input param starts with -i for it's short form or --i for it's long one
    [ "${opt_to_test:0:2}" == "-i" ] || [ "${opt_to_test:0:3}" == "--i" ]
}

function test_in_dir_out_dir_param()
{
    local param_to_test=$1
    local test_out_dir=$(get_test_outdir)
    local generate_html_report="$(get_tools_bin_dir)/generate_html_report.sh"

    # Create output dir if needed
    [ ! -d "${test_out_dir}" ] && mkdir -p "${test_out_dir}"

    # Define a different output for each test case
    local filename_suffix=$(convert_to_filename_str "${param_to_test}")
    local test_output_prefix="${test_out_dir}test${filename_suffix}"
    local test_std_output="${test_output_prefix}.out"
    local test_err_output="${test_output_prefix}.err.out"

    local report_out_dir="${test_output_prefix}/"

    local in_dir_param="-i"
    local out_dir_param="${param_to_test}"
    if is_input_param "${param_to_test}"; then
        in_dir_param="${param_to_test}"
        out_dir_param="-o"
    fi

    # Create a dummy memcheck file
    local first_memcheck_content="1st dummy file\nand a 2nd line for it"
    echo -e "${first_memcheck_content}" > "${test_out_dir}dummy.memcheck"

    # Create a 2nd dummy memcheck file
    local second_memcheck_content="2nd dummy file\nand a 2nd line for it too"
    [ ! -d "${test_out_dir}subdir/" ] && mkdir "${test_out_dir}subdir/"
    echo -e "${second_memcheck_content}" > "${test_out_dir}subdir/dummy2.memcheck"

    # Call the html report generator with the ${test_out_dir} as input directory
    # and the ${report_out_dir} as output directory
    "${generate_html_report}" ${in_dir_param}"${test_out_dir}" ${out_dir_param}"${report_out_dir}" > "${test_std_output}" 2> "${test_err_output}"
    local test_exit_code=$?

    ### Check test output

    # Expect the output file to be print
    expect_output "${test_std_output}" "Info: Input directory set to: '${test_out_dir}'"
    expect_output "${test_std_output}" "Info: Creating output directory '${report_out_dir}'"

    # Expect progress outputs
    expect_output "${test_std_output}" "Info: Generating index.html..."
    expect_output "${test_std_output}" "Info: Processing memcheck file 'dummy.memcheck' ..."
    expect_output "${test_std_output}" "Info: Processing memcheck file 'subdir/dummy2.memcheck' ..."

    # Expect HTML part files
    expect_file "${report_out_dir}dummy.memcheck.html.part.js"
    expect_file "${report_out_dir}subdir/dummy2.memcheck.html.part.js"

    # Check index.html content
    local expected_index_html_file="${report_out_dir}index.html"
    expect_file "${expected_index_html_file}"
    if [ "${error_occured}" -eq 0 ]; then
        # Header generation occured
        expect_file_content "${expected_index_html_file}" "<!doctype html>"

        # Dummy content 1 added
        expect_multiline_file_content "${report_out_dir}dummy.memcheck.html.part.js" "${first_memcheck_content}"
        expect_multiline_file_content "${expected_index_html_file}" "<script src=\"dummy.memcheck.html.part.js\" async=\"async\"></script>"

        # Dummy content 2 added
        expect_multiline_file_content "${report_out_dir}subdir/dummy2.memcheck.html.part.js" "${second_memcheck_content}"
        expect_multiline_file_content "${expected_index_html_file}" "<script src=\"subdir/dummy2.memcheck.html.part.js\" async=\"async\"></script>"

        # Footer generation occured
        expect_file_content "${expected_index_html_file}" "</html>"
    fi

    expect_empty_file "${test_err_output}"

    expect_exit_code $test_exit_code 0
}

# Init global
error_occured=0

# Run test
test_in_dir_out_dir_param "${test_parameter}"

exit $error_occured
