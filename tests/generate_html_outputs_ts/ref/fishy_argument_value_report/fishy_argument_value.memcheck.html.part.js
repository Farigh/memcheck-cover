async function updateContentOnceLoaded1()
{
    var data =`
==1== Memcheck, a memory error detector<br />
==1== Copyright (C), and GNU GPL'd, by Julian Seward et al.<br />
==1== Using Valgrind and LibVEX; rerun with -h for copyright info<br />
==1== Command: memcheck-cover/tests/bin/fishy_argument_value/out/fishy_argument_value<br />
==1== Parent PID: 1<br />
==1== <br />
==1== <span class="warning_leak">Argument 'size' of function malloc has a fishy (possibly negative) value: -1</span><br />
==1== &nbsp; &nbsp;at 0x10101042: malloc (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0x10101042: breakage::evil_fishy_alloc() (<span class="leak_file_info">main.cpp:11</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: main (<span class="leak_file_info">main.cpp:18</span>)<br />
==1== <br />
==1== <br />
==1== <span class="valgrind_summary_title">HEAP SUMMARY:</span><br />
==1== &nbsp; &nbsp; in use at exit: 0 bytes in 0 blocks<br />
==1== &nbsp; total heap usage: 2 allocs, 2 frees, 76,800 bytes allocated<br />
==1== <br />
==1== All heap blocks were freed -- no leaks are possible<br />
==1== <br />
==1== For lists of detected and suppressed errors, rerun with: -s<br />
==1== <span class="valgrind_summary_title">ERROR SUMMARY:</span> 1 errors from 1 contexts (suppressed: 0 from 0)<br />
`;
    var analysis_div = document.getElementById('valgrind.result1.Report');
    analysis_div.innerHTML=data;
}
updateContentOnceLoaded1();
