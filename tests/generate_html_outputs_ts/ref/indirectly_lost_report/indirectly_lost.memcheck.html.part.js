async function updateContentOnceLoaded1()
{
    var data =`
==1== Memcheck, a memory error detector<br />
==1== Copyright (C), and GNU GPL'd, by Julian Seward et al.<br />
==1== Using Valgrind and LibVEX; rerun with -h for copyright info<br />
==1== Command: memcheck-cover/tests/bin/indirectly_lost/out/indirectly_lost<br />
==1== Parent PID: 1<br />
==1== <br />
==1== <br />
==1== <span class="valgrind_summary_title">HEAP SUMMARY:</span><br />
==1== &nbsp; &nbsp; in use at exit: 96 bytes in 2 blocks<br />
==1== &nbsp; total heap usage: 3 allocs, 1 frees, 72,800 bytes allocated<br />
==1== <br />
==1== <span class="error_leak">48 bytes in 1 blocks are indirectly lost in loss record 1 of 2</span><br />
==1== &nbsp; &nbsp;at 0x10101042: operator new(unsigned long) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0x10101042: allocate (<span class="leak_file_info">new_allocator.h:111</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: allocate (<span class="leak_file_info">alloc_traits.h:436</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: std::__allocated_ptr&lt;std::allocator&lt;std::_Sp_counted_ptr_inplace&lt;breakage::LinkedElem, std::allocator&lt;breakage::LinkedElem&gt;, (__gnu_cxx::_Lock_policy)2&gt; &gt; &gt; std::__allocate_guarded&lt;std::allocator&lt;std::_Sp_counted_ptr_inplace&lt;breakage::LinkedElem, std::allocator&lt;breakage::LinkedElem&gt;, (__gnu_cxx::_Lock_policy)2&gt; &gt; &gt;(std::allocator&lt;std::_Sp_counted_ptr_inplace&lt;breakage::LinkedElem, std::allocator&lt;breakage::LinkedElem&gt;, (__gnu_cxx::_Lock_policy)2&gt; &gt;&amp;) (<span class="leak_file_info">allocated_ptr.h:104</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: __shared_count&lt;breakage::LinkedElem, std::allocator&lt;breakage::LinkedElem&gt; &gt; (<span class="leak_file_info">shared_ptr_base.h:635</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: __shared_ptr&lt;std::allocator&lt;breakage::LinkedElem&gt; &gt; (<span class="leak_file_info">shared_ptr_base.h:1295</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: shared_ptr&lt;std::allocator&lt;breakage::LinkedElem&gt; &gt; (<span class="leak_file_info">shared_ptr.h:344</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: allocate_shared&lt;breakage::LinkedElem, std::allocator&lt;breakage::LinkedElem&gt; &gt; (<span class="leak_file_info">shared_ptr.h:691</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: make_shared&lt;breakage::LinkedElem&gt; (<span class="leak_file_info">shared_ptr.h:707</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: breakage::evil_linked_ptr_indirectly_lost() (<span class="leak_file_info">main.cpp:25</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: main (<span class="leak_file_info">main.cpp:35</span>)<br />
==1== <br />
==1== <span class="error_leak">96 (48 direct, 48 indirect) bytes in 1 blocks are definitely lost in loss record 2 of 2</span><br />
==1== &nbsp; &nbsp;at 0x10101042: operator new(unsigned long) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0x10101042: allocate (<span class="leak_file_info">new_allocator.h:111</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: allocate (<span class="leak_file_info">alloc_traits.h:436</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: std::__allocated_ptr&lt;std::allocator&lt;std::_Sp_counted_ptr_inplace&lt;breakage::LinkedElem, std::allocator&lt;breakage::LinkedElem&gt;, (__gnu_cxx::_Lock_policy)2&gt; &gt; &gt; std::__allocate_guarded&lt;std::allocator&lt;std::_Sp_counted_ptr_inplace&lt;breakage::LinkedElem, std::allocator&lt;breakage::LinkedElem&gt;, (__gnu_cxx::_Lock_policy)2&gt; &gt; &gt;(std::allocator&lt;std::_Sp_counted_ptr_inplace&lt;breakage::LinkedElem, std::allocator&lt;breakage::LinkedElem&gt;, (__gnu_cxx::_Lock_policy)2&gt; &gt;&amp;) (<span class="leak_file_info">allocated_ptr.h:104</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: __shared_count&lt;breakage::LinkedElem, std::allocator&lt;breakage::LinkedElem&gt; &gt; (<span class="leak_file_info">shared_ptr_base.h:635</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: __shared_ptr&lt;std::allocator&lt;breakage::LinkedElem&gt; &gt; (<span class="leak_file_info">shared_ptr_base.h:1295</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: shared_ptr&lt;std::allocator&lt;breakage::LinkedElem&gt; &gt; (<span class="leak_file_info">shared_ptr.h:344</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: allocate_shared&lt;breakage::LinkedElem, std::allocator&lt;breakage::LinkedElem&gt; &gt; (<span class="leak_file_info">shared_ptr.h:691</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: make_shared&lt;breakage::LinkedElem&gt; (<span class="leak_file_info">shared_ptr.h:707</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: breakage::evil_linked_ptr_indirectly_lost() (<span class="leak_file_info">main.cpp:24</span>)<br />
==1== &nbsp; &nbsp;by 0x10101042: main (<span class="leak_file_info">main.cpp:35</span>)<br />
==1== <br />
==1== <span class="valgrind_summary_title">LEAK SUMMARY:</span><br />
==1== <span class="error_leak">&nbsp; &nbsp;definitely lost: 48 bytes in 1 blocks</span><br />
==1== <span class="error_leak">&nbsp; &nbsp;indirectly lost: 48 bytes in 1 blocks</span><br />
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
