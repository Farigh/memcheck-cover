async function updateContentOnceLoaded1()
{
    var data =`
==1== Memcheck, a memory error detector<br />
==1== Copyright (C), and GNU GPL'd, by Julian Seward et al.<br />
==1== Using Valgrind and LibVEX; rerun with -h for copyright info<br />
==1== Command: memcheck-cover/tests/bin/invalid_read/out/invalid_read<br />
==1== Parent PID: 1<br />
==1== <br />
==1== <span class="error_leak">Invalid read of size 4</span><br />
==1== &nbsp; &nbsp;at 0x10101042: breakage::evil_invalid_read() (<span class="leak_file_info">main.cpp:25</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: main (<span class="leak_file_info">main.cpp:31</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef1234 is 0 bytes inside a block of size 4 free'd</span><br />
==1== &nbsp; &nbsp;at 0x10101042: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0x10101042: operator() (<span class="leak_file_info">unique_ptr.h:42</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: ~unique_ptr (<span class="leak_file_info">unique_ptr.h:42</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: breakage::evil_get_value() (<span class="leak_file_info">main.cpp:13</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: breakage::evil_invalid_read() (<span class="leak_file_info">main.cpp:25</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: main (<span class="leak_file_info">main.cpp:31</span>)<br />
==1== <span class="leak_context_info">&nbsp;Block was alloc'd at</span><br />
==1== &nbsp; &nbsp;at 0x10101042: operator new(unsigned long) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0x10101042: make_unique&lt;breakage::MyStruct&gt; (<span class="leak_file_info">unique_ptr.h:42</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: breakage::evil_get_value() (<span class="leak_file_info">main.cpp:13</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: breakage::evil_invalid_read() (<span class="leak_file_info">main.cpp:25</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: main (<span class="leak_file_info">main.cpp:31</span>)<br />
==1== <br />
==1== <br />
==1== <span class="valgrind_summary_title">HEAP SUMMARY:</span><br />
==1== &nbsp; &nbsp; in use at exit: 0 bytes in 0 blocks<br />
==1== &nbsp; total heap usage: 3 allocs, 3 frees, 76,804 bytes allocated<br />
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
