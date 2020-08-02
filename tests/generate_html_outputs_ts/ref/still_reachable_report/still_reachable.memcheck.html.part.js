async function updateContentOnceLoaded1()
{
    var data =`
==1== Memcheck, a memory error detector<br />
==1== Copyright (C), and GNU GPL'd, by Julian Seward et al.<br />
==1== Using Valgrind and LibVEX; rerun with -h for copyright info<br />
==1== Command: memcheck-cover/tests/bin/still_reachable/out/still_reachable<br />
==1== Parent PID: 1<br />
==1== <br />
==1== <br />
==1== <span class="valgrind_summary_title">HEAP SUMMARY:</span><br />
==1== &nbsp; &nbsp; in use at exit: 10 bytes in 1 blocks<br />
==1== &nbsp; total heap usage: 2 allocs, 1 frees, 72,714 bytes allocated<br />
==1== <br />
==1== <span class="error_leak">10 bytes in 1 blocks are still reachable in loss record 1 of 1</span><br />
==1== &nbsp; &nbsp;at 0x10101042: operator new[](unsigned long) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0x10101042: breakage::evil_still_reachable() (<span class="leak_file_info">main.cpp:6</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: main (<span class="leak_file_info">main.cpp:12</span>)<br />
==1== <br />
==1== <span class="valgrind_summary_title">LEAK SUMMARY:</span><br />
==1== &nbsp; &nbsp;definitely lost: 0 bytes in 0 blocks<br />
==1== &nbsp; &nbsp;indirectly lost: 0 bytes in 0 blocks<br />
==1== &nbsp; &nbsp; &nbsp;possibly lost: 0 bytes in 0 blocks<br />
==1== <span class="error_leak">&nbsp; &nbsp;still reachable: 10 bytes in 1 blocks</span><br />
==1== &nbsp; &nbsp; &nbsp; &nbsp; suppressed: 0 bytes in 0 blocks<br />
==1== <br />
==1== For counts of detected and suppressed errors, rerun with: -v<br />
==1== <span class="valgrind_summary_title">ERROR SUMMARY:</span> 0 errors from 0 contexts (suppressed: 0 from 0)<br />
`;
    var analysis_div = document.getElementById('valgrind.result1.Report');
    analysis_div.innerHTML=data;
}
updateContentOnceLoaded1();
