async function updateContentOnceLoaded1()
{
    var data =`
==1== Memcheck, a memory error detector<br />
==1== Copyright (C), and GNU GPL'd, by Julian Seward et al.<br />
==1== Using Valgrind and LibVEX; rerun with -h for copyright info<br />
==1== Command: memcheck-cover/tests/bin/valgrind_warnings/out/valgrind_warnings<br />
==1== Parent PID: 1<br />
==1== <br />
==1== <span class="valgrind_warning">Warning: invalid file descriptor -1 in syscall write()</span><br />
==1== <span class="valgrind_warning">Warning: ignored attempt to set SIGSTOP handler in sigaction();</span><br />
==1== &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<span class="valgrind_warning_context">the SIGSTOP signal is uncatchable</span><br />
==1== <span class="valgrind_warning">Warning: bad signal number 65 in sigaction()</span><br />
==1== <span class="valgrind_warning">Warning: ignored attempt to set SIGRT32 handler in sigaction();</span><br />
==1== &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<span class="valgrind_warning_context">the SIGRT32 signal is used internally by Valgrind</span><br />
==1== <br />
==1== <span class="valgrind_summary_title">HEAP SUMMARY:</span><br />
==1== &nbsp; &nbsp; in use at exit: 0 bytes in 0 blocks<br />
==1== &nbsp; total heap usage: 0 allocs, 0 frees, 0 bytes allocated<br />
==1== <br />
==1== All heap blocks were freed -- no leaks are possible<br />
==1== <br />
==1== For lists of detected and suppressed errors, rerun with: -s<br />
==1== <span class="valgrind_summary_title">ERROR SUMMARY:</span> 0 errors from 0 contexts (suppressed: 0 from 0)<br />
`;
    var analysis_div = document.getElementById('valgrind.result1.Report');
    analysis_div.innerHTML=data;
}
updateContentOnceLoaded1();
