async function updateContentOnceLoaded1()
{
    var data =`
==1== Memcheck, a memory error detector<br />
==1== Copyright (C), and GNU GPL'd, by Julian Seward et al.<br />
==1== Using Valgrind and LibVEX; rerun with -h for copyright info<br />
==1== Command: memcheck-cover/tests/bin/possibly_lost/out/possibly_lost<br />
==1== Parent PID: 1<br />
==1== <br />
==1== <br />
==1== <span class="valgrind_summary_title">HEAP SUMMARY:</span><br />
==1== &nbsp; &nbsp; in use at exit: 6 bytes in 1 blocks<br />
==1== &nbsp; total heap usage: 1 allocs, 0 frees, 6 bytes allocated<br />
==1== <br />
==1== <span class="warning_leak">6 bytes in 1 blocks are possibly lost in loss record 1 of 1</span><br />
==1== &nbsp; &nbsp;at 0x10101042: malloc (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0x10101042: strdup (<span class="leak_file_info">strdup.c:42</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: breakage::evil_possibly_lost_func() (<span class="leak_file_info">main.cpp:12</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: main (<span class="leak_file_info">main.cpp:21</span>)<br />
==1== <br />
==1== <span class="valgrind_summary_title">LEAK SUMMARY:</span><br />
==1== &nbsp; &nbsp;definitely lost: 0 bytes in 0 blocks<br />
==1== &nbsp; &nbsp;indirectly lost: 0 bytes in 0 blocks<br />
==1== <span class="warning_leak">&nbsp; &nbsp; &nbsp;possibly lost: 6 bytes in 1 blocks</span><br />
==1== &nbsp; &nbsp;still reachable: 0 bytes in 0 blocks<br />
==1== &nbsp; &nbsp; &nbsp; &nbsp; suppressed: 0 bytes in 0 blocks<br />
==1== <br />
==1== For lists of detected and suppressed errors, rerun with: -s<br />
==1== <span class="valgrind_summary_title">ERROR SUMMARY:</span> 1 errors from 1 contexts (suppressed: 0 from 0)<br />
`;
    var analysis_div = document.getElementById('valgrind.result1.Report');
    analysis_div.innerHTML=data;
}
updateContentOnceLoaded1();
