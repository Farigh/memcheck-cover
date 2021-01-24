async function updateContentOnceLoaded1()
{
    var data =`
==1== Memcheck, a memory error detector<br />
==1== Copyright (C), and GNU GPL'd, by Julian Seward et al.<br />
==1== Using Valgrind and LibVEX; rerun with -h for copyright info<br />
==1== Command: fake_bin_with_multiple_local_dir<br />
==1== Parent PID: 1<br />
==1==<br />
==1== <span class="error_leak">Illegal memory pool address</span><br />
==1== &nbsp; &nbsp;at 0x10101042: my_func()  (<span class="leak_file_info">\`my proj\`/src/main.cpp:16</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: main  (<span class="leak_file_info">\`my proj\`/src/main.cpp:22</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef1234 is on thread 1's stack</span><br />
==1== &nbsp; &nbsp;in frame #0, created by my_func()  (<span class="leak_file_info">\`my proj\`/src/main.cpp:9</span>)<br />
==1==<br />
==1== <span class="error_leak">Syscall param write(buf) points to uninitialised byte(s)</span><br />
==1== &nbsp; &nbsp;at 0x10101042: write (<span class="leak_file_info">write.c:27</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: a_lib::function_call()  (<span class="leak_file_info">\`computation libs\`/src/Functionnality.cpp:13</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: MyLib::FunctionCall()  (<span class="leak_file_info">\`my proj\`/src/my_lib/ComputationWrapper.cpp:21</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: main  (<span class="leak_file_info">\`my proj\`/src/main.cpp:22</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef1234 is 0 bytes inside a block of size 4 alloc'd</span><br />
==1== &nbsp; &nbsp;at 0x10101042: operator new(unsigned long) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0x10101042: a_lib::function_call()  (<span class="leak_file_info">\`computation libs\`/src/Functionnality.cpp:10</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: MyLib::FunctionCall()  (<span class="leak_file_info">\`my proj\`/src/my_lib/ComputationWrapper.cpp:21</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: main  (<span class="leak_file_info">\`my proj\`/src/main.cpp:22</span>)<br />
==1== <span class="leak_context_info">&nbsp;Uninitialised value was created by a heap allocation</span><br />
==1== &nbsp; &nbsp;at 0x10101042: operator new(unsigned long) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0x10101042: a_lib::function_call()  (<span class="leak_file_info">\`computation libs\`/src/Functionnality.cpp:10</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: MyLib::FunctionCall()  (<span class="leak_file_info">\`my proj\`/src/my_lib/ComputationWrapper.cpp:21</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: main  (<span class="leak_file_info">\`my proj\`/src/main.cpp:22</span>)<br />
==1==<br />
==1== <span class="warning_leak">Conditional jump or move depends on uninitialised value(s)</span><br />
==1== &nbsp; &nbsp;at 0x10101042: another_lib::another_function_call()  (<span class="leak_file_info">\`another lib\`/src/AnotherFunctionnality.cpp:14</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: main  (<span class="leak_file_info">\`my proj\`/src/main.cpp:34</span>)<br />
==1== <span class="leak_context_info">&nbsp;Uninitialised value was created by a stack allocation</span><br />
==1== &nbsp; &nbsp;at 0x10101042: another_lib::another_function_call()  (<span class="leak_file_info">\`another lib\`/src/AnotherFunctionnality.cpp:5</span>)<br />
==1==<br />
==1==<br />
==1== <span class="valgrind_summary_title">HEAP SUMMARY:</span><br />
==1== &nbsp; &nbsp; in use at exit: 0 bytes in 0 blocks<br />
==1== &nbsp; total heap usage: 5 allocs, 5 frees, 149,512 bytes allocated<br />
==1==<br />
==1== All heap blocks were freed -- no leaks are possible<br />
==1==<br />
==1== For counts of detected and suppressed errors, rerun with: -v<br />
==1== <span class="valgrind_summary_title">ERROR SUMMARY:</span> 3 errors from 3 contexts (suppressed: 0 from 0)<br />
`;
    var analysis_div = document.getElementById('valgrind.result1.Report');
    analysis_div.innerHTML=data;
}
updateContentOnceLoaded1();
