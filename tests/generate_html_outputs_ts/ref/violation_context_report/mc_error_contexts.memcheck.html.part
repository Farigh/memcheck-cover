async function updateContentOnceLoaded3()
{
    var data =`
==1== Memcheck, a memory error detector<br />
==1== Copyright (C), and GNU GPL'd, by Julian Seward et al.<br />
==1== Using Valgrind and LibVEX; rerun with -h for copyright info<br />
==1== Command: memcheck-cover/tests/mc_error_contexts<br />
==1== Parent PID: 1<br />
==1== <br />
==1== <br />
==1== <span class="valgrind_summary_title">HEAP SUMMARY:</span><br />
==1== &nbsp; &nbsp; in use at exit: 0 bytes in 0 blocks<br />
==1== &nbsp; total heap usage: 25 allocs, 25 frees, 72,708 bytes allocated<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Uninitialised value was created by a heap allocation</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Uninitialised value was created by a stack allocation</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Uninitialised value was created by a client request</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Uninitialised value was created</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="valgrind_summary_title">LEAK SUMMARY:</span><br />
==1== &nbsp; &nbsp;definitely lost: 0 bytes in 0 blocks<br />
==1== &nbsp; &nbsp;indirectly lost: 0 bytes in 0 blocks<br />
==1== &nbsp; &nbsp; &nbsp;possibly lost: 0 bytes in 0 blocks<br />
==1== <span class="error_leak">&nbsp; &nbsp;still reachable: 95 bytes in 6 blocks</span><br />
==1== &nbsp; &nbsp; &nbsp; &nbsp; suppressed: 0 bytes in 0 blocks<br />
==1== <br />
==1== For counts of detected and suppressed errors, rerun with: -v<br />
==1== <span class="valgrind_summary_title">ERROR SUMMARY:</span> 1 errors from 1 contexts (suppressed: 0 from 0)<br />
`;
    var analysis_div = document.getElementById('valgrind.result3.Report');
    analysis_div.innerHTML=data;
}
updateContentOnceLoaded3();
