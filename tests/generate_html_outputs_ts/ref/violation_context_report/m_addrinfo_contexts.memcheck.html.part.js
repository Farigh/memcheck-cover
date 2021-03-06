async function updateContentOnceLoaded1()
{
    var data =`
==1== Memcheck, a memory error detector<br />
==1== Copyright (C), and GNU GPL'd, by Julian Seward et al.<br />
==1== Using Valgrind and LibVEX; rerun with -h for copyright info<br />
==1== Command: memcheck-cover/tests/m_addrinfo_contexts<br />
==1== Parent PID: 1<br />
==1== <br />
==1== <br />
==1== <span class="valgrind_summary_title">HEAP SUMMARY:</span><br />
==1== &nbsp; &nbsp; in use at exit: 0 bytes in 0 blocks<br />
==1== &nbsp; total heap usage: 25 allocs, 25 frees, 72,708 bytes allocated<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is on thread 1's stack</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is not stack'd, malloc'd or (recently) free'd</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is 4 bytes inside a block of size 4'012 alloc'd</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is 4 bytes inside a block of size 4'012 free'd</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is 4 bytes after a block of size 4'012 alloc'd</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is in the Text segment of mylib.so</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Block was alloc'd at</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== &nbsp; &nbsp;in frame #5, created by main() (<span class="leak_file_info">main.cpp:218</span>)<br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is just below the stack ptr.</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is on thread #1's stack</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is not stack'd, malloc'd or on a free list</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is 4 bytes inside a block of size 42 in arena "client"</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is 4 bytes after a block of size 42 in arena "client"</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is 4 bytes before a block of size 42 in arena "client"</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is 4 bytes inside an unallocated block of size 42 in arena "client"</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is 4 bytes after an unallocated block of size 42 in arena "client"</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is 4 bytes before an unallocated block of size 42 in arena "client"</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is 4 bytes inside a block of size 4'012 client-defined</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is 4 bytes inside a recently re-allocated block of size 4'012 alloc'd</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is 4 bytes inside a recently re-allocated block of size 4'012 free'd</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is 4 bytes inside a recently re-allocated block of size 4'012 client-defined</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is 4 bytes after a block of size 4'012 free'd</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is 4 bytes after a block of size 4'012 client-defined</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is 4 bytes after a recently re-allocated block of size 4'012 alloc'd</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is 4 bytes after a recently re-allocated block of size 4'012 free'd</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is 4 bytes after a recently re-allocated block of size 4'012 client-defined</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is 4 bytes before a block of size 4'012 alloc'd</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is 4 bytes before a block of size 4'012 free'd</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is 4 bytes before a block of size 4'012 client-defined</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is 4 bytes before a recently re-allocated block of size 4'012 alloc'd</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is 4 bytes before a recently re-allocated block of size 4'012 free'd</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is 4 bytes before a recently re-allocated block of size 4'012 client-defined</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is 4 bytes inside data symbol "dummy_symbol"</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is in the Unknown segment of mylib.so</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is in the Data segment of mylib.so</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is in the BSS segment of mylib.so</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is in the GOT segment of mylib.so</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is in the PLT segment of mylib.so</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is in the OPD segment of mylib.so</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is in the GOTPLT segment of mylib.so</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is in the brk data segment 0xabcdef01-0xabcdef02</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is 4 bytes after the brk data segment limit 0xabcdef01</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is in a -wx anonymous segment</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is in a r-x mapped file segment</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is in a rw- shared memory segment</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is in a r-- anonymous a_filename.txt segment</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is in a --x mapped file a_filename.txt segment</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Address 0xabcdef74 is in a -w- shared memory a_filename.txt segment</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Block was alloc'd by thread #3</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;Block was alloc'd by thread 475</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;4 bytes below stack pointer</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="warning_leak">Mismatched free() / delete / delete []</span><br />
==1== &nbsp; &nbsp;at 0xabcdef42: operator delete(void*) (in a_host_lib.so)<br />
==1== &nbsp; &nbsp;by 0xabcdef43: main (<span class="leak_file_info">main.cpp:17</span>)<br />
==1== <span class="leak_context_info">&nbsp;In stack guard protected page, 4 bytes below stack pointer</span><br />
==1== &nbsp; &nbsp;at 0xabcdef48: breakage::dummy_untested_contexts_func() (<span class="leak_file_info">main.cpp:9</span>)<br />
==1== &nbsp; &nbsp;by 0xabcdef49: main (<span class="leak_file_info">main.cpp:10</span>)<br />
==1== <br />
==1== <span class="valgrind_summary_title">LEAK SUMMARY:</span><br />
==1== &nbsp; &nbsp;definitely lost: 0 bytes in 0 blocks<br />
==1== &nbsp; &nbsp;indirectly lost: 0 bytes in 0 blocks<br />
==1== &nbsp; &nbsp; &nbsp;possibly lost: 0 bytes in 0 blocks<br />
==1== <span class="error_leak">&nbsp; &nbsp;still reachable: 95 bytes in 6 blocks</span><br />
==1== &nbsp; &nbsp; &nbsp; &nbsp; suppressed: 0 bytes in 0 blocks<br />
==1== <br />
==1== For counts of detected and suppressed errors, rerun with: -v<br />
==1== <span class="valgrind_summary_title">ERROR SUMMARY:</span> 1 errors from 1 contexts (suppressed: 0 from 0)<br />
`;
    var analysis_div = document.getElementById('valgrind.result1.Report');
    analysis_div.innerHTML=data;
}
updateContentOnceLoaded1();
