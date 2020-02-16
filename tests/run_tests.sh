#! /bin/bash

resolved_script_path=$(readlink -f $0)
current_script_dir=$(dirname $resolved_script_path)
current_full_path=$(readlink -e $current_script_dir)

bin_dir=$(readlink -e "${current_full_path}/../bin/")

overall_test_failed=0
overall_test_passed=0

test_suite_suffix="_ts"
test_case_suffix="_ts_tc.sh"
parameterized_test_case_suffix="_ts_ptc.sh"

# Enable colors only if in interactive shell
if [ -t 1 ]; then
    RESET_FORMAT=$(echo -e '\e[00m')
    BOLD=$(echo -e '\e[1m')
    RED=$(echo -e '\e[31m')
    GREEN=$(echo -e '\e[32m')
    PURPLE=$(echo -e '\e[0;35m')
    CYAN=$(echo -e '\e[0;36m')
fi

################################################
###                 FUNCTIONS                ###
################################################

function get_test_result_status()
{
    local test_failed=$1
    if [ $test_failed -eq 0 ]; then
        echo "${BOLD}${GREEN}PASS${RESET_FORMAT}"
    else
        echo "${BOLD}${RED}FAIL${RESET_FORMAT}"
    fi
}

function common_run_test()
{
    local test_runner=$1
    local param=$2

    # Run test
    "${test_runner}" "${bin_dir}/" "${param}"
    local test_result=$?

    if [ $test_result -eq 0 ]; then
        # Test passed
        ((local_test_passed++))
        ((overall_test_passed++))
    else
        # Test failed
        ((local_test_failed++))
        ((overall_test_failed++))
    fi
    local test_result_status=$(get_test_result_status $test_result)
    echo "** Done [${test_result_status}]"
}

function run_single_test()
{
    local test_runner=$1

    local test_name=${test_runner##*/}
    test_name=${test_name%${test_case_suffix}}
    echo "** Running test ${CYAN}${test_name}${RESET_FORMAT}"

    # Run test
    common_run_test "${test_runner}"
}

function run_parameterized_test()
{
    local test_runner=$1

    local test_name=${test_runner##*/}
    test_name=${test_name%${parameterized_test_case_suffix}}

    local test_case
    OLDIFS=$IFS
    IFS=$'\n'
    for test_case in $("${test_runner}" --list-cases); do
        echo "** Running test ${CYAN}${test_name}(${RESET_FORMAT}${test_case}${CYAN})${RESET_FORMAT}"

        # Run test
        common_run_test "${test_runner}" "${test_case}"
    done
    IFS=$OLDIFS
}

function run_testsuite()
{
    local testsuite_dir=$1

    local local_test_failed=0
    local local_test_passed=0

    # Cleanup previous run output if needed
    local testsuite_outdir="${testsuite_dir}/out/"
    if [ -d "${testsuite_outdir}" ]; then
        rm -r "${testsuite_outdir}"
    fi

    echo ""
    local test_suite_name=${testsuite_dir##*/}
    test_suite_name=${test_suite_name%${test_suite_suffix}}
    echo "**** Beginning of suite ${PURPLE}${test_suite_name}${RESET_FORMAT}"

    # Run all tests in testsuite
    for test_runner in $(find "${testsuite_dir}" -maxdepth 1 -name "*${parameterized_test_case_suffix}" -o -name "*${test_case_suffix}" -type f | sort); do
        if [[ "${test_runner}" == *"${parameterized_test_case_suffix}" ]]; then
            run_parameterized_test "${test_runner}"
        else
            run_single_test "${test_runner}"
        fi
    done

    # Print suite summary
    echo "**** Results:"
    echo "**    Suite test count: $((local_test_passed + local_test_failed))"
    echo "** Suite success count: ${local_test_passed}"
    echo "** Suite failure count: ${local_test_failed}"
    echo "****"
    local suite_result_status=$(get_test_result_status $local_test_failed)
    echo "********** End of suite ${PURPLE}${test_suite_name}${RESET_FORMAT} [${suite_result_status}]"
}

################################################
###                   MAIN                   ###
################################################

# Run each directories tests
for dir in $(find ${current_full_path} -mindepth 1 -maxdepth 1 -name "*${test_suite_suffix}" -type d | sort); do
    run_testsuite $dir
done

echo ""
# Print overall summary
suite_result_status=$(get_test_result_status $overall_test_failed)
echo "**** Summary [${suite_result_status}]"
echo "**    Total test count: $((overall_test_passed + overall_test_failed))"
echo "** Total success count: ${overall_test_passed}"
echo "** Total failure count: ${overall_test_failed}"
echo "********"
