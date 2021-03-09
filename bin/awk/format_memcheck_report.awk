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

function escapeHTMLSymbols(str)
{
    # Escape HTML special char &
    output = gensub(/\&/, "\\&amp;", "g", str)

    # Escape HTML special char <
    output = gensub(/</, "\\&lt;", "g", output)

    # Escape HTML special char >
    return gensub(/>/, "\\&gt;", "g", output)
}

function escapeAwkSymbols(str)
{
    # Escape Awk special char \
    output = gensub(/\\/, "\\\\\\\\", "g", str)

    # Escape Awk special char &
    output = gensub(/\&/, "\\\\&", "g", output)

    return output
}

function escapeSpecialCharactersInArray(array_to_escape)
{
    for (ind in array_to_escape) {
        # User defined prefixes might contain HTML special chars, resolve those
        array_to_escape[ind] = escapeHTMLSymbols(array_to_escape[ind])

        # Escape ` to prevent any problem with the HTML content in the js file
        array_to_escape[ind] = gensub(/`/, "\\\\`", "g", array_to_escape[ind])

        # Finally, we need to escape Awk regex replacement special sequences
        array_to_escape[ind] = escapeAwkSymbols(array_to_escape[ind])
    }
}

function addSourceControlServerLink(str)
{
    output = str

    for (prefix in url_prefix_replacement) {
        regex = "^(==[0-9]*== .* \\()(" prefix ")([^:]*):([0-9]*)(\\).*)$"

        link_prefix = "<a class=\"leak_file_info\" href=\"" url_prefix_replacement[prefix] "\\3"
        link_suffix = "</a>"

        if (url_prefix_replacement_type[prefix] == "bitbucket") {
            link_prefix = link_prefix "#-"
        }
        else {
            # GitHub and GitLab share the same syntax
            link_prefix = link_prefix "#L"
        }

        output = gensub(regex, "\\1" link_prefix "\\4\">\\2\\3:\\4" link_suffix "\\5", 1, output)
    }

    return output
}

function substitutePathPrefixes(str)
{
    output = str

    for (prefix in path_prefix_replacement) {
        regex = "^(==[0-9]*== .* \\((<a [^>]+>)?)" prefix "([^:]*:[0-9]*)((<\\/a>)?\\).*)$"
        output = gensub(regex, "\\1" path_prefix_replacement[prefix] "\\3\\4", 1, output)
    }

    return output
}

BEGIN {
    escapeSpecialCharactersInArray(url_prefix_replacement)
    escapeSpecialCharactersInArray(path_prefix_replacement)
}

{
    output = $0

    # Escape HTML special chars
    output = escapeHTMLSymbols(output)

    # Replace consecutive spaces with non-breaking space to preserve valgrind report alignment
    output = gensub(/  /, " \\&nbsp;", "g", output)

    #############
    ## Customizable violations criticality
    #############

    # Definitely lost
    output = gensub(/^(==[0-9]*== )(.* blocks are definitely lost in loss record.*)/,
                    "\\1<span class=\"" definitely_lost_criticality "_leak\">\\2</span>", 1, output)

    # Indirectly lost
    output = gensub(/^(==[0-9]*== )(.* blocks are indirectly lost in loss record.*)/,
                    "\\1<span class=\"" indirectly_lost_criticality "_leak\">\\2</span>", 1, output)

    # Still reachable
    output = gensub(/^(==[0-9]*== )(.* blocks are still reachable in loss record.*)/,
                    "\\1<span class=\"" still_reachable_criticality "_leak\">\\2</span>", 1, output)

    # Possibly lost
    output = gensub(/^(==[0-9]*== )(.* blocks are possibly lost in loss record.*)/,
                    "\\1<span class=\"" possibly_lost_criticality "_leak\">\\2</span>", 1, output)

    # Invalid dealloc
    output = gensub(/^(==[0-9]*== )(Invalid free.*)/,
                    "\\1<span class=\"" dealloc_invalid_criticality "_leak\">\\2</span>", 1, output)

    # Mismatched dealloc
    output = gensub(/^(==[0-9]*== )(Mismatched free.*)/,
                    "\\1<span class=\"" dealloc_mismatched_criticality "_leak\">\\2</span>", 1, output)

    # Fishy argument value
    output = gensub(/^(==[0-9]*== )(Argument .* of function .* has a fishy \(possibly negative\) value:.*)/,
                    "\\1<span class=\"" fishy_argument_value_criticality "_leak\">\\2</span>", 1, output)

    # Invalid read
    output = gensub(/^(==[0-9]*== )(Invalid read of size .*)/,
                    "\\1<span class=\"" invalid_read_criticality "_leak\">\\2</span>", 1, output)

    # Invalid write
    output = gensub(/^(==[0-9]*== )(Invalid write of size .*)/,
                    "\\1<span class=\"" invalid_write_criticality "_leak\">\\2</span>", 1, output)

    # Uninitialized value conditionnal jump or move
    output = gensub(/^(==[0-9]*== )(Conditional jump or move depends on .*)/,
                    "\\1<span class=\"" uninitialized_value_jump_move_criticality "_leak\">\\2</span>", 1, output)

    # Uninitialized value use
    output = gensub(/^(==[0-9]*== )(Use of uninitialised value .*)/,
                    "\\1<span class=\"" uninitialized_value_use_criticality "_leak\">\\2</span>", 1, output)

    # Syscall param points to unaddressable byte(s)
    output = gensub(/^(==[0-9]*== )(Syscall param .* points to unaddressable byte.*)/,
                    "\\1<span class=\"" points_to_unaddressable_criticality "_leak\">\\2</span>", 1, output)

    # (Syscall param ?) contains unaddressable byte(s)
    output = gensub(/^(==[0-9]*== )(.* contains unaddressable byte.*)/,
                    "\\1<span class=\"" contains_unaddressable_criticality "_leak\">\\2</span>", 1, output)

    # Syscall param contains uninitialised byte(s)
    output = gensub(/^(==[0-9]*== )(Syscall param .* contains uninitialised byte.*)/,
                    "\\1<span class=\"" contains_uninitialized_criticality "_leak\">\\2</span>", 1, output)

    # Syscall param points to uninitialised byte(s)
    output = gensub(/^(==[0-9]*== )(Syscall param .* points to uninitialised byte.*)/,
                    "\\1<span class=\"" points_to_uninitialized_criticality "_leak\">\\2</span>", 1, output)

    # Illegal memory pool address
    output = gensub(/^(==[0-9]*== )(Illegal memory pool address.*)/,
                    "\\1<span class=\"" illegal_mem_pool_addr_criticality "_leak\">\\2</span>", 1, output)

    # Overlapping memory pool blocks
    output = gensub(/^(==[0-9]*== )(Block 0x[0-9a-fA-F]+\.\.0x[0-9a-fA-F]+ overlaps with block 0x[0-9a-fA-F]+\.\.0x[0-9a-fA-F]+)$/,
                    "\\1<span class=\"" overlapping_mem_pool_blocks_criticality "_leak\">\\2</span>", 1, output)

    # Overlapping source and destination
    output = gensub(/^(==[0-9]*== )(Source and destination overlap in .*)/,
                    "\\1<span class=\"" overlapping_src_dest_criticality "_leak\">\\2</span>", 1, output)

    # Jump to the invalid address
    output = gensub(/^(==[0-9]*== )(Jump to the invalid address.*)/,
                    "\\1<span class=\"" jump_to_invalid_addr_criticality "_leak\">\\2</span>", 1, output)

    #############
    ## Customizable client check violations criticality
    #############

    # Unaddressable byte(s) found during client check request
    output = gensub(/^(==[0-9]*== )(Unaddressable byte\(s\) found during client check request)/,
                    "\\1<span class=\"" unaddressable_found_client_check_criticality "_leak\">\\2</span>", 1, output)

    # Uninitialised byte(s) found during client check request
    output = gensub(/^(==[0-9]*== )(Uninitialised byte\(s\) found during client check request)/,
                    "\\1<span class=\"" uninitialised_found_client_check_criticality "_leak\">\\2</span>", 1, output)

    #############
    ## Customizable summary criticality
    #############

    # Highlight summary titles
    output = gensub(/^(==[0-9]*== )((HEAP|LEAK|ERROR) SUMMARY:)(.*)/,
                    "\\1<span class=\"valgrind_summary_title\">\\2</span>\\4", 1, output)

    # Highlight LEAK SUMMARY if any error occured (ie, not having "0 bytes in 0 blocks" output)
    output = gensub(/^(==[0-9]*== )(.*definitely lost: [1-9][0-9,]* bytes in [1-9][0-9,]* blocks.*)/,
                    "\\1<span class=\"" definitely_lost_summary_criticality "_leak\">\\2</span>", 1, output)
    output = gensub(/^(==[0-9]*== )(.*indirectly lost: [1-9][0-9,]* bytes in [1-9][0-9,]* blocks.*)/,
                    "\\1<span class=\"" indirectly_lost_summary_criticality "_leak\">\\2</span>", 1, output)
    output = gensub(/^(==[0-9]*== )(.*possibly lost: [1-9][0-9,]* bytes in [1-9][0-9,]* blocks.*)/,
                    "\\1<span class=\"" possibly_lost_summary_criticality "_leak\">\\2</span>", 1, output)
    output = gensub(/^(==[0-9]*== )(.*still reachable: [1-9][0-9,]* bytes in [1-9][0-9,]* blocks.*)/,
                    "\\1<span class=\"" still_reachable_summary_criticality "_leak\">\\2</span>", 1, output)

    # LEAK SUMMARY context
    output = gensub(/^(==[0-9]*==)(( \&nbsp;)+ of which reachable via heuristic:)$/,
                    "\\1<span class=\"leak_context_info\">\\2</span>", 1, output)

    #############
    ## Valgrind's warnings
    #############

    output = gensub(/^(==[0-9]*== )(Warning: invalid file descriptor [-0-9]+ in syscall .*)/,
                    "\\1<span class=\"valgrind_warning\">\\2</span>", 1, output)

    # Sigaction warnings
    output = gensub(/^(==[0-9]*== )(Warning: bad signal number [0-9]+ in sigaction\(\))/,
                    "\\1<span class=\"valgrind_warning\">\\2</span>", 1, output)
    output = gensub(/^(==[0-9]*== )(Warning: ignored attempt to set .* handler in sigaction\(\);)/,
                    "\\1<span class=\"valgrind_warning\">\\2</span>", 1, output)
    output = gensub(/^(==[0-9]*==( \&nbsp;)+)(the .* signal is used internally by Valgrind)/,
                    "\\1<span class=\"valgrind_warning_context\">\\3</span>", 1, output)
    output = gensub(/^(==[0-9]*==( \&nbsp;)+)(the .* signal is uncatchable)/,
                    "\\1<span class=\"valgrind_warning_context\">\\3</span>", 1, output)

    #############
    ## Context
    #############

    ## Highlight context headlines from valgrind's source file 'coregrind/m_addrinfo.c'
    output = gensub(/^(==[0-9]*== )(\&nbsp;Address 0x[0-9A-Fa-f]+ is .*)/, "\\1<span class=\"leak_context_info\">\\2</span>", 1, output)
    output = gensub(/^(==[0-9]*== )(\&nbsp;Block was alloc'd at)$/, "\\1<span class=\"leak_context_info\">\\2</span>", 1, output)
    output = gensub(/^(==[0-9]*== )(\&nbsp;Block was alloc'd by thread .*)/, "\\1<span class=\"leak_context_info\">\\2</span>", 1, output)
    output = gensub(/^(==[0-9]*== )(\&nbsp;(In stack guard protected page, )?[0-9]+ bytes below stack pointer)/,
                    "\\1<span class=\"leak_context_info\">\\2</span>", 1, output)

    # Only reindent this one
    output = gensub(/^(==[0-9]*== )(\&nbsp;in frame #[0-9]+, created by .*)/, "\\1\\&nbsp; \\2", 1, output)

    # Highlight context headlines from valgrind's source file 'coregrind/m_signals.c'
    output = gensub(/^(==[0-9]*== )(\&nbsp;Access not within mapped region.*)/, "\\1<span class=\"leak_context_info\">\\2</span>", 1, output)
    output = gensub(/^(==[0-9]*== )(\&nbsp;Bad permissions for mapped region.*)/, "\\1<span class=\"leak_context_info\">\\2</span>", 1, output)
    output = gensub(/^(==[0-9]*== )(\&nbsp;General Protection Fault.*)/, "\\1<span class=\"leak_context_info\">\\2</span>", 1, output)
    output = gensub(/^(==[0-9]*== )(\&nbsp;Illegal (opcode|operand|addressing mode|trap) at address .*)/,
                    "\\1<span class=\"leak_context_info\">\\2</span>", 1, output)
    output = gensub(/^(==[0-9]*== )(\&nbsp;Privileged (opcode|register) at address.*)/,
                    "\\1<span class=\"leak_context_info\">\\2</span>", 1, output)
    output = gensub(/^(==[0-9]*== )(\&nbsp;Coprocessor error at address .*)/, "\\1<span class=\"leak_context_info\">\\2</span>", 1, output)
    output = gensub(/^(==[0-9]*== )(\&nbsp;Internal stack error at address .*)/, "\\1<span class=\"leak_context_info\">\\2</span>", 1, output)
    output = gensub(/^(==[0-9]*== )(\&nbsp;Integer (divide by zero|overflow) at address .*)/,
                    "\\1<span class=\"leak_context_info\">\\2</span>", 1, output)
    output = gensub(/^(==[0-9]*== )(\&nbsp;FP (divide by zero|overflow|underflow|inexact|invalid operation|subscript out of range|denormalize) at address .*)/,
                    "\\1<span class=\"leak_context_info\">\\2</span>", 1, output)
    output = gensub(/^(==[0-9]*== )(\&nbsp;Invalid address alignment at address .*)/, "\\1<span class=\"leak_context_info\">\\2</span>", 1, output)
    output = gensub(/^(==[0-9]*== )(\&nbsp;Non-existent physical address at address .*)/, "\\1<span class=\"leak_context_info\">\\2</span>", 1, output)
    output = gensub(/^(==[0-9]*== )(\&nbsp;Hardware error at address .*)/, "\\1<span class=\"leak_context_info\">\\2</span>", 1, output)

    ## Highlight context headlines from valgrind's source file 'memcheck/mc_errors.c'
    output = gensub(/^(==[0-9]*== )(\&nbsp;Uninitialised value was created.*)/, "\\1<span class=\"leak_context_info\">\\2</span>", 1, output)

    # Highlight context headlines from valgrind's source file 'memcheck/mc_leakcheck.c'
    output = gensub(/^(==[0-9]*== )(Blocks allocation contexts:)/,
                    "\\1\\&nbsp;<span class=\"leak_context_info\">\\2</span>", 1, output)

    #############
    ## Valgrind's suppression entry
    #############

    # Valgrind suppression opening
    output = gensub(/^{$/, valgrind_suppression_opening "{", 1, output)

    # Valgrind suppression closing (add two ==== lines to seperate the suppression from the next violation)
    output = gensub(/^}$/, "}</div>====<br />====", 1, output)

    #############
    ## Advanced replacement options
    #############

    # Add source control server link if any
    output = addSourceControlServerLink(output)

    # Substitute path prefix if any
    output = substitutePathPrefixes(output)

    #############
    ## Additionnal infos
    #############

    # Valgrind hint message for some errors
    output = gensub(/^(==[0-9]*== )(This is usually caused by using VALGRIND_MALLOCLIKE_BLOCK in an inappropriate way.)/,
                    "\\1<span class=\"valgrind_hint\">\\2</span>", 1, output)

    # Highlight file and line
    output = gensub(/^(==[0-9]*== .* )\(([^:]*:[0-9]*)\)((<[^>]*>))?$/, "\\1\\3(<span class=\"leak_file_info\">\\2</span>)", 1, output)

    # Highlight program exit
    output = gensub(/^(==[0-9]*== )(Process terminating with .*)/, "\\1<span class=\"leak_program_exit\">\\2</span>", 1, output)

    # Highlight valgrind crash stacktrace
    output = gensub(/^(host stacktrace:)$/, "<span class=\"host_program_stacktrace\">\\1</span>", 1, output)

    # Add HTML end of line tag
    print output "<br />"
}
