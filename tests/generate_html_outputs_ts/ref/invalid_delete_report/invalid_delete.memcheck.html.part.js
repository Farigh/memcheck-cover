async function updateContentOnceLoaded1()
{
    var data =`
==1== Memcheck, a memory error detector<br />
==1== Copyright (C), and GNU GPL'd, by Julian Seward et al.<br />
==1== Using Valgrind and LibVEX; rerun with -h for copyright info<br />
==1== Command: memcheck-cover/tests/bin/invalid_delete/out/invalid_delete<br />
==1== Parent PID: 1<br />
==1== <br />
==1== <span class="warning_leak">Invalid free() / delete / delete[] / realloc()</span><br />
==1== &nbsp; &nbsp;at 0x10101042: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0x10101042: main (<span class="leak_file_info">main.cpp:18</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef1234 is in the Text segment of memcheck-cover/tests/bin/invalid_delete/out/invalid_delete</span><br />
==1== &nbsp; &nbsp;at 0x10101042: main (<span class="leak_file_info">main.cpp:16</span>)<br />
==1== <br />
==1== <span class="warning_leak">Invalid free() / delete / delete[] / realloc()</span><br />
==1== &nbsp; &nbsp;at 0x10101042: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0x10101042: breakage::evil_double_free() (<span class="leak_file_info">main.cpp:11</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: main (<span class="leak_file_info">main.cpp:20</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef1234 is 0 bytes inside a block of size 4 free'd</span><br />
==1== &nbsp; &nbsp;at 0x10101042: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0x10101042: breakage::evil_double_free() (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: main (<span class="leak_file_info">main.cpp:20</span>)<br />
==1== <span class="leak_context_info">&nbsp;Block was alloc'd at</span><br />
==1== &nbsp; &nbsp;at 0x10101042: operator new(unsigned long) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0x10101042: breakage::evil_double_free() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: main (<span class="leak_file_info">main.cpp:20</span>)<br />
==1== <br />
==1== <br />
==1== <span class="valgrind_summary_title">HEAP SUMMARY:</span><br />
==1== &nbsp; &nbsp; in use at exit: 0 bytes in 0 blocks<br />
==1== &nbsp; total heap usage: 2 allocs, 4 frees, 72,708 bytes allocated<br />
==1== <br />
==1== All heap blocks were freed -- no leaks are possible<br />
==1== <br />
==1== For lists of detected and suppressed errors, rerun with: -s<br />
==1== <span class="valgrind_summary_title">ERROR SUMMARY:</span> 2 errors from 2 contexts (suppressed: 0 from 0)<br />
`;
    var analysis_div = document.getElementById('valgrind.result1.Report');
    analysis_div.innerHTML=data;
}
updateContentOnceLoaded1();
