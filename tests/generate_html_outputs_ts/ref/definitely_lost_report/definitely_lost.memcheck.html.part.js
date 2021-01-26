async function updateContentOnceLoaded1()
{
    var data =`
==1== Memcheck, a memory error detector<br />
==1== Copyright (C), and GNU GPL'd, by Julian Seward et al.<br />
==1== Using Valgrind and LibVEX; rerun with -h for copyright info<br />
==1== Command: memcheck-cover/tests/bin/definitely_lost/out/definitely_lost<br />
==1== Parent PID: 1<br />
==1== <br />
==1== <br />
==1== <span class="valgrind_summary_title">HEAP SUMMARY:</span><br />
==1== &nbsp; &nbsp; in use at exit: 4 bytes in 1 blocks<br />
==1== &nbsp; total heap usage: 2 allocs, 1 frees, 72,708 bytes allocated<br />
==1== <br />
==1== <span class="error_leak">4 bytes in 1 blocks are definitely lost in loss record 1 of 1</span><br />
==1== &nbsp; &nbsp;at 0x10101042: operator new(unsigned long) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0x10101042: breakage::evil_definitely_lost_func() (<span class="leak_file_info">main.cpp:4</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="valgrind_summary_title">LEAK SUMMARY:</span><br />
==1== <span class="error_leak">&nbsp; &nbsp;definitely lost: 4 bytes in 1 blocks</span><br />
==1== &nbsp; &nbsp;indirectly lost: 0 bytes in 0 blocks<br />
==1== &nbsp; &nbsp; &nbsp;possibly lost: 0 bytes in 0 blocks<br />
==1== &nbsp; &nbsp;still reachable: 0 bytes in 0 blocks<br />
==1== &nbsp; &nbsp; &nbsp; &nbsp; suppressed: 0 bytes in 0 blocks<br />
==1== <br />
==1== For counts of detected and suppressed errors, rerun with: -v<br />
==1== <span class="valgrind_summary_title">ERROR SUMMARY:</span> 1 errors from 1 contexts (suppressed: 0 from 0)<br />
`;
    var analysis_div = document.getElementById('valgrind.result1.Report');
    analysis_div.innerHTML=data;
}
updateContentOnceLoaded1();