async function updateContentOnceLoaded1()
{
    var data =`
==1== Memcheck, a memory error detector<br />
==1== Copyright (C), and GNU GPL'd, by Julian Seward et al.<br />
==1== Using Valgrind and LibVEX; rerun with -h for copyright info<br />
==1== Command: memcheck-cover/tests/bin/uninitialized_value/out/uninitialized_value<br />
==1== Parent PID: 1<br />
==1== <br />
==1== <span class="warning_leak">Conditional jump or move depends on uninitialised value(s)</span><br />
==1== &nbsp; &nbsp;at 0x10101042: breakage::evil_jump_on_stack_uninitialized_value() (<span class="leak_file_info">main.cpp:14</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: main (<span class="leak_file_info">main.cpp:34</span>)<br />
==1== <span class="leak_context_info">&nbsp;Uninitialised value was created by a stack allocation</span><br />
==1== &nbsp; &nbsp;at 0x10101042: breakage::evil_jump_on_stack_uninitialized_value() (<span class="leak_file_info">main.cpp:5</span>)<br />
==1== <br />
==1== <span class="warning_leak">Conditional jump or move depends on uninitialised value(s)</span><br />
==1== &nbsp; &nbsp;at 0x10101042: std::ostreambuf_iterator&lt;char, std::char_traits&lt;char&gt; &gt; std::num_put&lt;char, std::ostreambuf_iterator&lt;char, std::char_traits&lt;char&gt; &gt; &gt;::_M_insert_int&lt;long&gt;(std::ostreambuf_iterator&lt;char, std::char_traits&lt;char&gt; &gt;, std::ios_base&amp;, char, long) const (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0x10101042: std::ostream&amp; std::ostream::_M_insert&lt;long&gt;(long) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0x10101042: breakage::evil_use_of_uninitialized_value() (<span class="leak_file_info">main.cpp:26</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: main (<span class="leak_file_info">main.cpp:35</span>)<br />
==1== <span class="leak_context_info">&nbsp;Uninitialised value was created by a heap allocation</span><br />
==1== &nbsp; &nbsp;at 0x10101042: operator new(unsigned long) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0x10101042: breakage::evil_use_of_uninitialized_value() (<span class="leak_file_info">main.cpp:23</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: main (<span class="leak_file_info">main.cpp:35</span>)<br />
==1== <br />
==1== <span class="warning_leak">Use of uninitialised value of size 42</span><br />
==1== &nbsp; &nbsp;at 0x10101042: ??? (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0x10101042: std::ostreambuf_iterator&lt;char, std::char_traits&lt;char&gt; &gt; std::num_put&lt;char, std::ostreambuf_iterator&lt;char, std::char_traits&lt;char&gt; &gt; &gt;::_M_insert_int&lt;long&gt;(std::ostreambuf_iterator&lt;char, std::char_traits&lt;char&gt; &gt;, std::ios_base&amp;, char, long) const (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0x10101042: std::ostream&amp; std::ostream::_M_insert&lt;long&gt;(long) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0x10101042: breakage::evil_use_of_uninitialized_value() (<span class="leak_file_info">main.cpp:26</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: main (<span class="leak_file_info">main.cpp:35</span>)<br />
==1== <span class="leak_context_info">&nbsp;Uninitialised value was created by a heap allocation</span><br />
==1== &nbsp; &nbsp;at 0x10101042: operator new(unsigned long) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0x10101042: breakage::evil_use_of_uninitialized_value() (<span class="leak_file_info">main.cpp:23</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: main (<span class="leak_file_info">main.cpp:35</span>)<br />
==1== <br />
==1== <span class="warning_leak">Conditional jump or move depends on uninitialised value(s)</span><br />
==1== &nbsp; &nbsp;at 0x10101042: ??? (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0x10101042: std::ostreambuf_iterator&lt;char, std::char_traits&lt;char&gt; &gt; std::num_put&lt;char, std::ostreambuf_iterator&lt;char, std::char_traits&lt;char&gt; &gt; &gt;::_M_insert_int&lt;long&gt;(std::ostreambuf_iterator&lt;char, std::char_traits&lt;char&gt; &gt;, std::ios_base&amp;, char, long) const (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0x10101042: std::ostream&amp; std::ostream::_M_insert&lt;long&gt;(long) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0x10101042: breakage::evil_use_of_uninitialized_value() (<span class="leak_file_info">main.cpp:26</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: main (<span class="leak_file_info">main.cpp:35</span>)<br />
==1== <span class="leak_context_info">&nbsp;Uninitialised value was created by a heap allocation</span><br />
==1== &nbsp; &nbsp;at 0x10101042: operator new(unsigned long) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0x10101042: breakage::evil_use_of_uninitialized_value() (<span class="leak_file_info">main.cpp:23</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: main (<span class="leak_file_info">main.cpp:35</span>)<br />
==1== <br />
==1== <span class="warning_leak">Conditional jump or move depends on uninitialised value(s)</span><br />
==1== &nbsp; &nbsp;at 0x10101042: std::ostreambuf_iterator&lt;char, std::char_traits&lt;char&gt; &gt; std::num_put&lt;char, std::ostreambuf_iterator&lt;char, std::char_traits&lt;char&gt; &gt; &gt;::_M_insert_int&lt;long&gt;(std::ostreambuf_iterator&lt;char, std::char_traits&lt;char&gt; &gt;, std::ios_base&amp;, char, long) const (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0x10101042: std::ostream&amp; std::ostream::_M_insert&lt;long&gt;(long) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0x10101042: breakage::evil_use_of_uninitialized_value() (<span class="leak_file_info">main.cpp:26</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: main (<span class="leak_file_info">main.cpp:35</span>)<br />
==1== <span class="leak_context_info">&nbsp;Uninitialised value was created by a heap allocation</span><br />
==1== &nbsp; &nbsp;at 0x10101042: operator new(unsigned long) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0x10101042: breakage::evil_use_of_uninitialized_value() (<span class="leak_file_info">main.cpp:23</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: main (<span class="leak_file_info">main.cpp:35</span>)<br />
==1== <br />
==1== <br />
==1== <span class="valgrind_summary_title">HEAP SUMMARY:</span><br />
==1== &nbsp; &nbsp; in use at exit: 0 bytes in 0 blocks<br />
==1== &nbsp; total heap usage: 3 allocs, 3 frees, 76,804 bytes allocated<br />
==1== <br />
==1== All heap blocks were freed -- no leaks are possible<br />
==1== <br />
==1== For counts of detected and suppressed errors, rerun with: -v<br />
==1== <span class="valgrind_summary_title">ERROR SUMMARY:</span> 5 errors from 5 contexts (suppressed: 0 from 0)<br />
`;
    var analysis_div = document.getElementById('valgrind.result1.Report');
    analysis_div.innerHTML=data;
}
updateContentOnceLoaded1();
