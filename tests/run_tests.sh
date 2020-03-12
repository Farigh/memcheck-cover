#! /bin/bash

resolved_script_path=$(readlink -f "$0")
current_script_dir=$(dirname "${resolved_script_path}")
current_full_path=$(readlink -e "${current_script_dir}")

bin_dir=$(readlink -e "${current_full_path}/../bin/")

# Import common utils
source "${bin_dir}/utils.common.sh"

overall_test_failed=0
overall_test_passed=0
overall_test_skipped=0

test_skipped_status="${ORANGE}SKIP${RESET_FORMAT}"

test_suite_suffix="_ts"
test_case_suffix="_ts_tc.sh"
parameterized_test_case_suffix="_ts_ptc.sh"

################################################
###                 FUNCTIONS                ###
################################################

function get_testsuite_dirs_ordered()
{
    find "${current_full_path}" -mindepth 1 -maxdepth 1 -name "*${test_suite_suffix}" -type d | sort
}

function get_test_runners_ordered()
{
    local testsuite_dir=$1
    find "${testsuite_dir}" -maxdepth 1 -name "*${parameterized_test_case_suffix}" -o -name "*${test_case_suffix}" -type f | sort
}

function get_testsuite_name_from_dir()
{
    local testsuite_dir=$1

    local test_suite_name=${testsuite_dir##*/}

    echo "${test_suite_name%${test_suite_suffix}}"
}

function get_test_name_from_script()
{
    local test_runner=$1

    local test_name=${test_runner##*/}

    echo "${test_name%_ts_*.sh}"
}

function get_test_result_status()
{
    local test_failed=$1
    if [ $test_failed -eq 0 ]; then
        echo "${BOLD}${GREEN}PASS${RESET_FORMAT}"
    else
        echo "${BOLD}${RED}FAIL${RESET_FORMAT}"
    fi
}

function is_parameterized_test()
{
    local test_runner=$1
    [[ "${test_runner}" == *"${parameterized_test_case_suffix}" ]]
}

function is_test_skipped()
{
    local potentially_skipped_test_full=$1

    # Run all tests if no test added
    if [ ${#tests_to_run[@]} -eq 0 ]; then
        return 1
    fi

    # Was test-case added ?
    if [ "${tests_to_run[${potentially_skipped_test_full}]}" != "" ]; then
        return 1
    fi

    # Was test added ?
    local potentially_skipped_test=${potentially_skipped_test_full%(*}
    if [ "${tests_to_run[${potentially_skipped_test}]}" != "" ]; then
        return 1
    fi

    # Was test-suite added ?
    local potentially_skipped_testsuite=${potentially_skipped_test%:*}
    [ "${tests_to_run[${potentially_skipped_testsuite}]}" == "" ]
}

function common_run_test()
{
    local test_suite_name=$1
    local test_runner=$2
    local param=$3

    local test_name=$(get_test_name_from_script "${test_runner}")

    local test_full_name="${test_suite_name}:${test_name}"
    local to_print_common="${CYAN}${test_name}${RESET_FORMAT}"
    if [ "${param}" != "" ]; then
        test_full_name+="(${test_case})"
        to_print_common+="${CYAN}(${RESET_FORMAT}${test_case}${CYAN})${RESET_FORMAT}"
    fi

    # Is test skipped ?
    if is_test_skipped "${test_full_name}"; then
        [ $display_skipped_tests -eq 1 ] && echo "** [${test_skipped_status}] ${to_print_common}"

        # Test skipped
        ((local_test_skipped++))
        ((overall_test_skipped++))
        return
    fi

    echo "** Running test ${to_print_common}"

    # Run test
    "${test_runner}" "${param}"
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
    local test_suite_name=$1
    local test_runner=$2

    # Run test
    common_run_test "${test_suite_name}" "${test_runner}"
}

function run_parameterized_test()
{
    local test_suite_name=$1
    local test_runner=$2

    local test_case
    OLDIFS=$IFS
    IFS=$'\n'
    for test_case in $("${test_runner}" --list-cases); do
        # Run test
        common_run_test "${test_suite_name}" "${test_runner}" "${test_case}"
    done
    IFS=$OLDIFS
}

function run_testsuite()
{
    local testsuite_dir=$1

    local local_test_failed=0
    local local_test_passed=0
    local local_test_skipped=0

    # Cleanup previous run output if needed
    local testsuite_outdir="${testsuite_dir}/out/"
    if [ -d "${testsuite_outdir}" ]; then
        rm -r "${testsuite_outdir}"
    fi

    echo ""
    local test_suite_name=$(get_testsuite_name_from_dir "${testsuite_dir}")
    echo "**** Beginning of suite ${PURPLE}${test_suite_name}${RESET_FORMAT}"

    # Run all tests in testsuite
    local test_runner
    while read -r test_runner; do
        if is_parameterized_test "${test_runner}"; then
            run_parameterized_test "${test_suite_name}" "${test_runner}"
        else
            run_single_test "${test_suite_name}" "${test_runner}"
        fi
    done < <(get_test_runners_ordered "${testsuite_dir}")

    # Print suite summary
    local local_total_test=$((local_test_passed + local_test_failed + local_test_skipped))
    echo "**** Results:"
    echo "**    Suite test count: ${local_total_test}"
    echo "** Suite success count: ${local_test_passed}"
    echo "** Suite failure count: ${local_test_failed}"
    echo "** Suite skipped count: ${local_test_skipped}"
    echo "****"
    local suite_result_status=""
    if [ $local_total_test -eq $local_test_skipped ]; then
        suite_result_status=$test_skipped_status
    else
        suite_result_status=$(get_test_result_status $local_test_failed)
    fi
    echo "********** End of suite ${PURPLE}${test_suite_name}${RESET_FORMAT} [${suite_result_status}]"
}

function print_usage()
{
    info "Usage: $0 [OPTIONS]..."
    echo "Runs the memcheck-cover tests"
    echo ""
    echo "Options:"
    echo "  -h|--help            Displays this help message."
    echo "  -l|--list            Lists all available test-suites, tests and test-cases"
    echo "  -r|--run-test=TEST   TEST can either be a test-suite, a test or a test-case."
    echo "                       Available TESTs can be obtained using the -l parameter."
    echo "  -s|--hide-skipped    If used, the skipped tests are not outputed to console."
    echo ""
    echo "${CYAN}Note:${RESET_FORMAT} - Adding a test-suite using the -r parameter will add all tests and"
    echo "        test-cases available in the test-suite."
    echo "      - Adding a test will only add the selected test to the tests to run."
    echo "        If the test is parameterized, every test-cases will be added."
}

function list_tests()
{
    # For each test-suite
    local testsuite_dir
    while read -r testsuite_dir; do
        local test_suite_name=$(get_testsuite_name_from_dir "${testsuite_dir}")

        echo ""
        echo "   Test-suite ${PURPLE}${test_suite_name}${RESET_FORMAT}"

        # For each test
        local test_runner
        while read -r test_runner; do
            local test_name=$(get_test_name_from_script "${test_runner}")

            local test_name_only="${PURPLE}${test_suite_name}${RESET_FORMAT}:${CYAN}${test_name}${RESET_FORMAT}"

            echo "      - Test ${test_name_only}"
            if is_parameterized_test "${test_runner}"; then
                # For each test-case
                local test_case
                for test_case in $("${test_runner}" --list-cases); do
                    echo "         - Test-case ${test_name_only}${CYAN}(${RESET_FORMAT}${test_case}${CYAN})${RESET_FORMAT}"
                done
            fi
        done < <(get_test_runners_ordered "${testsuite_dir}")
    done < <(get_testsuite_dirs_ordered)
}

function add_test_to_run()
{
    local test_to_add=$1

    local test_to_add_test_suite=${test_to_add%:*}
    local test_to_add_test=${test_to_add%(*}

    if [ ! -d "${current_full_path}/${test_to_add_test_suite}_ts" ]; then
        error "No ${PURPLE}${test_to_add_test_suite}${RESET_FORMAT} test-suite found"
        exit 1
    fi

    if [ "${test_to_add_test_suite}" == "${test_to_add}" ]; then
        info "Added the ${PURPLE}${test_to_add_test_suite}${RESET_FORMAT} test-suite"
    elif [ "${test_to_add_test}" == "${test_to_add}" ]; then
        info "Added the ${PURPLE}${test_to_add_test_suite}${RESET_FORMAT}:${CYAN}${test_to_add##*:}${RESET_FORMAT} test"
    else
        local test_to_add_no_suite=${test_to_add##*:}
        local test_to_add_test_name=${test_to_add_no_suite%(*}
        local test_to_add_param=${test_to_add_no_suite##*(}
        test_to_add_param=${test_to_add_param:0: -1}
        info "Added the ${PURPLE}${test_to_add_test_suite}${RESET_FORMAT}:${CYAN}${test_to_add_test_name}(${RESET_FORMAT}${test_to_add_param}${CYAN})${RESET_FORMAT} test-case"
    fi

    # Add the whole test_suite
    tests_to_run["${test_to_add}"]=1
}

################################################
###                  GETOPT                  ###
################################################

display_skipped_tests=1

declare -A tests_to_run
while getopts ":hlr:s-:" parsed_option; do
    case "${parsed_option}" in
        # Long options
        -)
            case "${OPTARG}" in
                run-test)
                    check_param "--run-test" "${!OPTIND}"
                    add_test_to_run "${!OPTIND}"
                    ((OPTIND++))
                ;;
                run-test=*)
                    check_param "--run-test" "${OPTARG#*=}"
                    add_test_to_run "${OPTARG#*=}"
                ;;
                hide-skipped)
                    display_skipped_tests=0
                ;;
                help)
                    print_usage
                    exit 0
                ;;
                list)
                    list_tests
                    exit 0
                ;;
                *)
                    error "Unknown option '--${OPTARG}'"
                    print_usage
                    exit 1
                ;;
            esac
        ;;
        # Short options
        h)
            print_usage
            exit 0
        ;;
        l)
            list_tests
            exit 0
        ;;
        r)
            check_param "-r" "${OPTARG}"
            add_test_to_run "${OPTARG}"
        ;;
        s)
            display_skipped_tests=0
        ;;
        :)
            error "Option '-${OPTARG}' requires a value"
            print_usage
            exit 1
        ;;
        ?)
            error "Unknown option '-${OPTARG}'"
            print_usage
            exit 1
        ;;
    esac
done

# OPTIND - 1 points to the last processed opt (should be the -t param value)
# Only shift if we processed at least 2 arg (-t + value)
if [ $OPTIND -gt 1 ]; then
    shift $((OPTIND - 1))
fi

if [ "$1" != "" ]; then
    error "Unexpected params: $@"
    print_usage
    exit 1
fi

################################################
###                   MAIN                   ###
################################################

# Run each directories tests
while read -r testsuite_dir; do
    run_testsuite "${testsuite_dir}"
done < <(get_testsuite_dirs_ordered)

echo ""
# Print overall summary
suite_result_status=$(get_test_result_status $overall_test_failed)
echo "**** Summary [${suite_result_status}]"
echo "**    Total test count: $((overall_test_passed + overall_test_failed + overall_test_skipped))"
echo "** Total success count: ${overall_test_passed}"
echo "** Total failure count: ${overall_test_failed}"
echo "** Total skipped count: ${overall_test_skipped}"
echo "********"

# Error on failure
exit ${overall_test_failed}
