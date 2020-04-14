#! /usr/bin/env bash

resolved_script_path=$(readlink -f "$0")
current_script_dir=$(dirname "${resolved_script_path}")
current_full_path=$(readlink -e "${current_script_dir}")

test_utils_import=$(readlink -e "${current_full_path}/../utils.test.sh")
source "${test_utils_import}"

############
### TEST ###
############

function add_dummy_report_header()
{
    local report_command_name=$1
    echo "==1== Memcheck, a memory error detector"
    echo "==1== Copyright (C), and GNU GPL'd, by Julian Seward et al."
    echo "==1== Using Valgrind and LibVEX; rerun with -h for copyright info"
    echo "==1== Command: memcheck-cover/tests/${report_command_name}"
    echo "==1== Parent PID: 1"
    echo "==1== "
    echo "==1== "
    echo "==1== HEAP SUMMARY:"
    echo "==1==     in use at exit: 0 bytes in 0 blocks"
    echo "==1==   total heap usage: 25 allocs, 25 frees, 72,708 bytes allocated"
    echo "==1== "
}

function add_dummy_report_context()
{
    local context_decription=$1

    # Add dummy violation
    echo "==1== Mismatched free() / delete / delete []"
    echo "==1==    at 0xabcdef42: operator delete(void*) (in a_host_lib.so)"
    echo "==1==    by 0xabcdef43: main (main.cpp:17)"

    # Add context
    echo "==1==  ${context_decription}"
    echo "==1==    at 0xabcdef48: breakage::dummy_untested_contexts_func() (main.cpp:9)"
    echo "==1==    by 0xabcdef49: main (main.cpp:10)"
    echo "==1== "
}

function add_dummy_report_footer()
{
    local add_heuristic=$1

    echo "==1== LEAK SUMMARY:"
    echo "==1==    definitely lost: 0 bytes in 0 blocks"
    echo "==1==    indirectly lost: 0 bytes in 0 blocks"
    echo "==1==      possibly lost: 0 bytes in 0 blocks"
    echo "==1==    still reachable: 95 bytes in 6 blocks"

    if [ "${add_heuristic}" == "true" ]; then
        echo "==1==                       of which reachable via heuristic:"
        echo "==1==                         stdstring          : 56 bytes in 2 blocks"
        echo "==1==                         length64           : 16 bytes in 1 blocks"
        echo "==1==                         newarray           : 7 bytes in 1 blocks"
        echo "==1==                         multipleinheritance: 8 bytes in 1 blocks"
    fi

    echo "==1==         suppressed: 0 bytes in 0 blocks"
    echo "==1== "
    echo "==1== For counts of detected and suppressed errors, rerun with: -v"
    echo "==1== ERROR SUMMARY: 1 errors from 1 contexts (suppressed: 0 from 0)"
}

function setup_test()
{
    local test_out_dir=$(get_test_outdir)

    # Create output dir if needed
    [ ! -d "${test_out_dir}" ] && mkdir -p "${test_out_dir}"

    # TODO : Add a representative c++ test for each context

    ####
    # Generate a dummy report with all the supported contexts
    # from valgrind's source file 'coregrind/m_addrinfo.c'
    {
        # Add valgrind's header
        add_dummy_report_header "m_addrinfo_contexts"

        # Tested contexts
        add_dummy_report_context "Address 0xabcdef74 is on thread 1's stack"
        add_dummy_report_context "Address 0xabcdef74 is not stack'd, malloc'd or (recently) free'd"
        add_dummy_report_context "Address 0xabcdef74 is 4 bytes inside a block of size 4'012 alloc'd"
        add_dummy_report_context "Address 0xabcdef74 is 4 bytes inside a block of size 4'012 free'd"
        add_dummy_report_context "Address 0xabcdef74 is 4 bytes after a block of size 4'012 alloc'd"
        add_dummy_report_context "Address 0xabcdef74 is in the Text segment of mylib.so"
        add_dummy_report_context "Block was alloc'd at"
        add_dummy_report_context "in frame #5, created by main() (main.cpp:218)"

        # Untested contexts
        add_dummy_report_context "Address 0xabcdef74 is just below the stack ptr."
        add_dummy_report_context "Address 0xabcdef74 is on thread #1's stack"
        add_dummy_report_context "Address 0xabcdef74 is not stack'd, malloc'd or on a free list"
        add_dummy_report_context 'Address 0xabcdef74 is 4 bytes inside a block of size 42 in arena "client"'
        add_dummy_report_context 'Address 0xabcdef74 is 4 bytes after a block of size 42 in arena "client"'
        add_dummy_report_context 'Address 0xabcdef74 is 4 bytes before a block of size 42 in arena "client"'
        add_dummy_report_context 'Address 0xabcdef74 is 4 bytes inside an unallocated block of size 42 in arena "client"'
        add_dummy_report_context 'Address 0xabcdef74 is 4 bytes after an unallocated block of size 42 in arena "client"'
        add_dummy_report_context 'Address 0xabcdef74 is 4 bytes before an unallocated block of size 42 in arena "client"'

        add_dummy_report_context "Address 0xabcdef74 is 4 bytes inside a block of size 4'012 client-defined"
        add_dummy_report_context "Address 0xabcdef74 is 4 bytes inside a recently re-allocated block of size 4'012 alloc'd"
        add_dummy_report_context "Address 0xabcdef74 is 4 bytes inside a recently re-allocated block of size 4'012 free'd"
        add_dummy_report_context "Address 0xabcdef74 is 4 bytes inside a recently re-allocated block of size 4'012 client-defined"
        add_dummy_report_context "Address 0xabcdef74 is 4 bytes after a block of size 4'012 free'd"
        add_dummy_report_context "Address 0xabcdef74 is 4 bytes after a block of size 4'012 client-defined"
        add_dummy_report_context "Address 0xabcdef74 is 4 bytes after a recently re-allocated block of size 4'012 alloc'd"
        add_dummy_report_context "Address 0xabcdef74 is 4 bytes after a recently re-allocated block of size 4'012 free'd"
        add_dummy_report_context "Address 0xabcdef74 is 4 bytes after a recently re-allocated block of size 4'012 client-defined"
        add_dummy_report_context "Address 0xabcdef74 is 4 bytes before a block of size 4'012 alloc'd"
        add_dummy_report_context "Address 0xabcdef74 is 4 bytes before a block of size 4'012 free'd"
        add_dummy_report_context "Address 0xabcdef74 is 4 bytes before a block of size 4'012 client-defined"
        add_dummy_report_context "Address 0xabcdef74 is 4 bytes before a recently re-allocated block of size 4'012 alloc'd"
        add_dummy_report_context "Address 0xabcdef74 is 4 bytes before a recently re-allocated block of size 4'012 free'd"
        add_dummy_report_context "Address 0xabcdef74 is 4 bytes before a recently re-allocated block of size 4'012 client-defined"

        add_dummy_report_context 'Address 0xabcdef74 is 4 bytes inside data symbol "dummy_symbol"'
        add_dummy_report_context "Address 0xabcdef74 is in the Unknown segment of mylib.so"
        add_dummy_report_context "Address 0xabcdef74 is in the Data segment of mylib.so"
        add_dummy_report_context "Address 0xabcdef74 is in the BSS segment of mylib.so"
        add_dummy_report_context "Address 0xabcdef74 is in the GOT segment of mylib.so"
        add_dummy_report_context "Address 0xabcdef74 is in the PLT segment of mylib.so"
        add_dummy_report_context "Address 0xabcdef74 is in the OPD segment of mylib.so"
        add_dummy_report_context "Address 0xabcdef74 is in the GOTPLT segment of mylib.so"
        add_dummy_report_context "Address 0xabcdef74 is in the brk data segment 0xabcdef01-0xabcdef02"
        add_dummy_report_context "Address 0xabcdef74 is 4 bytes after the brk data segment limit 0xabcdef01"
        add_dummy_report_context "Address 0xabcdef74 is in a -wx anonymous segment"
        add_dummy_report_context "Address 0xabcdef74 is in a r-x mapped file segment"
        add_dummy_report_context "Address 0xabcdef74 is in a rw- shared memory segment"
        add_dummy_report_context "Address 0xabcdef74 is in a r-- anonymous a_filename.txt segment"
        add_dummy_report_context "Address 0xabcdef74 is in a --x mapped file a_filename.txt segment"
        add_dummy_report_context "Address 0xabcdef74 is in a -w- shared memory a_filename.txt segment"

        add_dummy_report_context "Block was alloc'd by thread #3"
        add_dummy_report_context "Block was alloc'd by thread 475"
        add_dummy_report_context "4 bytes below stack pointer"
        add_dummy_report_context "In stack guard protected page, 4 bytes below stack pointer"

        # Add valgrind's footer
        add_dummy_report_footer
    } > "${test_out_dir}/m_addrinfo_contexts.memcheck"

    ####
    # Generate a dummy report with all the supported contexts
    # from valgrind's source file 'coregrind/m_signals.c'
    {
        # Add valgrind's header
        add_dummy_report_header "m_signals_contexts"

        # Tested contexts
        add_dummy_report_context "Access not within mapped region at address 0xabcdef74"
        add_dummy_report_context "Bad permissions for mapped region at address 0xabcdef74"

        # Untested contexts
        add_dummy_report_context "General Protection Fault"
        add_dummy_report_context "Illegal opcode at address 0xabcdef74"
        add_dummy_report_context "Illegal operand at address 0xabcdef74"
        add_dummy_report_context "Illegal addressing mode at address 0xabcdef74"
        add_dummy_report_context "Illegal trap at address 0xabcdef74"
        add_dummy_report_context "Privileged opcode at address 0xabcdef74"
        add_dummy_report_context "Privileged register at address 0xabcdef74"
        add_dummy_report_context "Coprocessor error at address 0xabcdef74"
        add_dummy_report_context "Internal stack error at address 0xabcdef74"
        add_dummy_report_context "Integer divide by zero at address 0xabcdef74"
        add_dummy_report_context "Integer overflow at address 0xabcdef74"
        add_dummy_report_context "FP divide by zero at address 0xabcdef74"
        add_dummy_report_context "FP overflow at address 0xabcdef74"
        add_dummy_report_context "FP underflow at address 0xabcdef74"
        add_dummy_report_context "FP inexact at address 0xabcdef74"
        add_dummy_report_context "FP invalid operation at address 0xabcdef74"
        add_dummy_report_context "FP subscript out of range at address 0xabcdef74"
        add_dummy_report_context "FP denormalize at address 0xabcdef74"
        add_dummy_report_context "Invalid address alignment at address 0xabcdef74"
        add_dummy_report_context "Non-existent physical address at address 0xabcdef74"
        add_dummy_report_context "Hardware error at address 0xabcdef74"

        # Add valgrind's footer
        add_dummy_report_footer
    } > "${test_out_dir}/m_signals_contexts.memcheck"

    ####
    # Generate a dummy report with all the supported contexts
    # from valgrind's source file 'memcheck/mc_leakcheck.c'
    {
        # Add valgrind's header
        add_dummy_report_header "mc_leakcheck_contexts"

        # Add valgrind's footer with the "of which reachable via heuristic:" part of the LEAK SUMMARY
        add_dummy_report_footer "true"
    } > "${test_out_dir}/mc_leakcheck_contexts.memcheck"

    ####
    # Generate a dummy report with all the supported contexts
    # from valgrind's source file 'memcheck/mc_errors.c'
    {
        # Add valgrind's header
        add_dummy_report_header "mc_error_contexts"

        # Tested contexts
        add_dummy_report_context "Uninitialised value was created by a heap allocation"
        add_dummy_report_context "Uninitialised value was created by a stack allocation"

        # Untested contexts
        add_dummy_report_context "Uninitialised value was created by a client request"
        add_dummy_report_context "Uninitialised value was created"

        # Add valgrind's footer
        add_dummy_report_footer
    } > "${test_out_dir}/mc_error_contexts.memcheck"
}

function test_many_result_report()
{
    local test_out_dir=$(get_test_outdir)
    local generate_html_report="$(get_tools_bin_dir)/generate_html_report.sh"

    local test_std_output="${test_out_dir}test.out"
    local test_err_output="${test_out_dir}test.err.out"

    local test_ref_report_dir="${current_full_path}/ref/violation_context_report/"
    local report_out_dir="${test_out_dir}report/"

    # Call the html report generator with the ${test_out_dir} as input directory
    # and the ${report_out_dir} as output directory
    "${generate_html_report}" -i "${test_out_dir}" -o "${report_out_dir}" > "${test_std_output}" 2> "${test_err_output}"
    local test_exit_code=$?

    ### Check test output

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
test_many_result_report

exit $error_occured
