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
    output=gensub(/^(==[0-9]*== )(.*definitely lost .*)/,
                  "\\1<span class=\"" definitely_lost_criticality "_leak\">\\2</span>", 1, output)

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
    ## Context
    #############

    # Highlight context headlines
    output=gensub(/^(==[0-9]*== )(\&nbsp;Address 0x[0-9A-Fa-f]* is .*)/, "\\1<span class=\"leak_context_info\">\\2</span>", 1, output)
    output=gensub(/^(==[0-9]*== )(\&nbsp;Block was alloc'd at)/, "\\1<span class=\"leak_context_info\">\\2</span>", 1, output)
    output=gensub(/^(==[0-9]*== )(\&nbsp;Access not within mapped region.*)/, "\\1<span class=\"leak_context_info\">\\2</span>", 1, output)
    output=gensub(/^(==[0-9]*== )(\&nbsp;Uninitialised value was created by a.*)/, "\\1<span class=\"leak_context_info\">\\2</span>", 1, output)

    # Highlight file and line
    output=gensub(/^(==[0-9]*== .* \()([^:]*:[0-9]*)\)$/, "\\1<span class=\"leak_file_info\">\\2</span>)", 1, output)

    # Highlight program exit
    output=gensub(/^(==[0-9]*== )(Process terminating with .*)/, "\\1<span class=\"leak_program_exit\">\\2</span>", 1, output)

    # Add HTML end of line tag
    print output "<br />"
}
