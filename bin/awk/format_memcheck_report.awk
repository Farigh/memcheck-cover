#! /usr/bin/gawk -f

######
# Memcheck-cover is an HTML report generator on top of valgrind's memcheck
# Copyright (C) 2020  GARCIN David <https://github.com/Farigh/memcheck-cover>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
######

{
    output=$0

    # Escape HTML special char &
    output=gensub(/\&/, "\\&amp;", "g", output)

    # Escape HTML special char <
    output=gensub(/</, "\\&lt;", "g", output)

    # Escape HTML special char >
    output=gensub(/>/, "\\&gt;", "g", output)

    # Replace consecutive spaces with non-breaking space to preserve valgrind report alignment
    output=gensub(/  /, " \\&nbsp;", "g", output)

    #############
    ## Customizable violations criticality
    #############

    # Definitely lost
    output=gensub(/^(==[0-9]*== )(.* blocks are definitely lost in loss record.*)/,
                  "\\1<span class=\"" definitely_lost_criticality "_leak\">\\2</span>", 1, output)

    # Indirectly lost
    output=gensub(/^(==[0-9]*== )(.* blocks are indirectly lost in loss record.*)/,
                  "\\1<span class=\"" indirectly_lost_criticality "_leak\">\\2</span>", 1, output)

    # Still reachable
    output=gensub(/^(==[0-9]*== )(.* blocks are still reachable in loss record.*)/,
                  "\\1<span class=\"" still_reachable_criticality "_leak\">\\2</span>", 1, output)

    # Possibly lost
    output=gensub(/^(==[0-9]*== )(.* blocks are possibly lost in loss record.*)/,
                  "\\1<span class=\"" possibly_lost_criticality "_leak\">\\2</span>", 1, output)

    # Invalid dealloc
    output=gensub(/^(==[0-9]*== )(Invalid free.*)/,
                  "\\1<span class=\"" dealloc_invalid_criticality "_leak\">\\2</span>", 1, output)

    # Mismatched dealloc
    output=gensub(/^(==[0-9]*== )(Mismatched free.*)/,
                  "\\1<span class=\"" dealloc_mismatched_criticality "_leak\">\\2</span>", 1, output)

    # Fishy argument value
    output=gensub(/^(==[0-9]*== )(Argument .* of function .* has a fishy \(possibly negative\) value:.*)/,
                  "\\1<span class=\"" fishy_argument_value_criticality "_leak\">\\2</span>", 1, output)

    # Invalid read
    output=gensub(/^(==[0-9]*== )(Invalid read of size .*)/,
                  "\\1<span class=\"" invalid_read_criticality "_leak\">\\2</span>", 1, output)

    # Invalid write
    output=gensub(/^(==[0-9]*== )(Invalid write of size .*)/,
                  "\\1<span class=\"" invalid_write_criticality "_leak\">\\2</span>", 1, output)

    # Uninitialized value conditionnal jump or move
    output=gensub(/^(==[0-9]*== )(Conditional jump or move depends on .*)/,
                  "\\1<span class=\"" uninitialized_value_jump_move_criticality "_leak\">\\2</span>", 1, output)

    # Uninitialized value use
    output=gensub(/^(==[0-9]*== )(Use of uninitialised value .*)/,
                  "\\1<span class=\"" uninitialized_value_use_criticality "_leak\">\\2</span>", 1, output)

    # Syscall param points to unaddressable byte(s)
    output=gensub(/^(==[0-9]*== )(Syscall param .* points to unaddressable byte.*)/,
                  "\\1<span class=\"" points_to_unaddressable_criticality "_leak\">\\2</span>", 1, output)

    # (Syscall param ?) contains unaddressable byte(s)
    output=gensub(/^(==[0-9]*== )(.* contains unaddressable byte.*)/,
                  "\\1<span class=\"" contains_unaddressable_criticality "_leak\">\\2</span>", 1, output)

    # Syscall param contains uninitialised byte(s)
    output=gensub(/^(==[0-9]*== )(Syscall param .* contains uninitialised byte.*)/,
                  "\\1<span class=\"" contains_uninitialized_criticality "_leak\">\\2</span>", 1, output)

    # Syscall param points to uninitialised byte(s)
    output=gensub(/^(==[0-9]*== )(Syscall param .* points to uninitialised byte.*)/,
                  "\\1<span class=\"" points_to_uninitialized_criticality "_leak\">\\2</span>", 1, output)

    # Illegal memory pool address
    output=gensub(/^(==[0-9]*== )(Illegal memory pool address.*)/,
                  "\\1<span class=\"" illegal_mem_pool_addr_criticality "_leak\">\\2</span>", 1, output)

    # Overlapping source and destination
    output=gensub(/^(==[0-9]*== )(Source and destination overlap in .*)/,
                  "\\1<span class=\"" overlapping_src_dest_criticality "_leak\">\\2</span>", 1, output)

    # Jump to the invalid address
    output=gensub(/^(==[0-9]*== )(Jump to the invalid address.*)/,
                  "\\1<span class=\"" jump_to_invalid_addr_criticality "_leak\">\\2</span>", 1, output)

    #############
    ## Customizable client check violations criticality
    #############

    # Unaddressable byte(s) found during client check request
    output=gensub(/^(==[0-9]*== )(Unaddressable byte\(s\) found during client check request)/,
                  "\\1<span class=\"" unaddressable_found_client_check_criticality "_leak\">\\2</span>", 1, output)

    # Uninitialised byte(s) found during client check request
    output=gensub(/^(==[0-9]*== )(Uninitialised byte\(s\) found during client check request)/,
                  "\\1<span class=\"" uninitialised_found_client_check_criticality "_leak\">\\2</span>", 1, output)

    #############
    ## Customizable summary criticality
    #############

    # Highlight LEAK SUMMARY if any error occured (ie, not having "0 bytes in 0 blocks" output)
    output=gensub(/^(==[0-9]*== )(.*definitely lost: [1-9][0-9,]* bytes in [1-9][0-9,]* blocks.*)/,
                  "\\1<span class=\"" definitely_lost_summary_criticality "_leak\">\\2</span>", 1, output)
    output=gensub(/^(==[0-9]*== )(.*indirectly lost: [1-9][0-9,]* bytes in [1-9][0-9,]* blocks.*)/,
                  "\\1<span class=\"" indirectly_lost_summary_criticality "_leak\">\\2</span>", 1, output)
    output=gensub(/^(==[0-9]*== )(.*possibly lost: [1-9][0-9,]* bytes in [1-9][0-9,]* blocks.*)/,
                  "\\1<span class=\"" possibly_lost_summary_criticality "_leak\">\\2</span>", 1, output)
    output=gensub(/^(==[0-9]*== )(.*still reachable: [1-9][0-9,]* bytes in [1-9][0-9,]* blocks.*)/,
                  "\\1<span class=\"" still_reachable_summary_criticality "_leak\">\\2</span>", 1, output)

    #############
    ## Valgrind's warnings
    #############

    output=gensub(/^(==[0-9]*== )(Warning: invalid file descriptor [-0-9]+ in syscall .*)/,
                  "\\1<span class=\"valgrind_warning\">\\2</span>", 1, output)

    # Sigaction warnings
    output=gensub(/^(==[0-9]*== )(Warning: bad signal number [0-9]+ in sigaction\(\))/,
                  "\\1<span class=\"valgrind_warning\">\\2</span>", 1, output)
    output=gensub(/^(==[0-9]*== )(Warning: ignored attempt to set .* handler in sigaction\(\);)/,
                  "\\1<span class=\"valgrind_warning\">\\2</span>", 1, output)
    output=gensub(/^(==[0-9]*==( \&nbsp;)+)(the .* signal is used internally by Valgrind)/,
                  "\\1<span class=\"valgrind_warning_context\">\\3</span>", 1, output)
    output=gensub(/^(==[0-9]*==( \&nbsp;)+)(the .* signal is uncatchable)/,
                  "\\1<span class=\"valgrind_warning_context\">\\3</span>", 1, output)

    #############
    ## Context
    #############

    # Highlight context headlines
    output=gensub(/^(==[0-9]*== )(\&nbsp;Address 0x[0-9A-Fa-f]+ is .*)/, "\\1<span class=\"leak_context_info\">\\2</span>", 1, output)
    output=gensub(/^(==[0-9]*== )(\&nbsp;Block was alloc'd at)/, "\\1<span class=\"leak_context_info\">\\2</span>", 1, output)
    output=gensub(/^(==[0-9]*== )(\&nbsp;Access not within mapped region.*)/, "\\1<span class=\"leak_context_info\">\\2</span>", 1, output)
    output=gensub(/^(==[0-9]*== )(\&nbsp;Uninitialised value was created.*)/, "\\1<span class=\"leak_context_info\">\\2</span>", 1, output)
    output=gensub(/^(==[0-9]*== )(\&nbsp;Bad permissions for mapped region.*)/, "\\1<span class=\"leak_context_info\">\\2</span>", 1, output)

    # Highlight file and line
    output=gensub(/^(==[0-9]*== .* \()([^:]*:[0-9]*)\)$/, "\\1<span class=\"leak_file_info\">\\2</span>)", 1, output)

    # Highlight program exit
    output=gensub(/^(==[0-9]*== )(Process terminating with .*)/, "\\1<span class=\"leak_program_exit\">\\2</span>", 1, output)

    # Add HTML end of line tag
    print output "<br />"
}
