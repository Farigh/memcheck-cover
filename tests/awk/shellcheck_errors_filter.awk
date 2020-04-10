#! /usr/bin/gawk -f

######
# Memcheck-cover test-runner utility
# Copyright (C) 2020  GARCIN David <https://github.com/Farigh/memcheck-cover>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
######

###
# shellcheck has ignore directives but I don't want to impact the code
# with comments for it. So lets ignore violation by hand.
BEGIN {
    error_occured = 0
    reset_buffers()
}

function reset_buffers()
{
    for (i in previous_lines)
        delete previous_lines[i]

    previous_line_index=0
}

function print_buffers()
{
    # Print the buffer content only if more the 2 lines are found
    #    line 0: violation location infos (file:line)
    #    line 1: violation line content
    #    line 2-n: violation details
    if (2 in previous_lines)
    {
        print ""
        for (i in previous_lines)
            print previous_lines[i]
        print ""

        ++error_occured
    }
}

{
    # Empty line
    if ($0 ~ /^$/)
    {
        print_buffers()
        reset_buffers()
    }
    # `memcheck_result_ext` is set by utils.common.sh
    else if (($0 ~ /\^-- SC2154: memcheck_result_ext is referenced but not assigned\./) \
             && ((previous_lines[0] ~ /bin\/memcheck_runner\.sh line 50:/) \
                 || (previous_lines[0] ~ /bin\/generate_html_report\.sh line 55:/)))
    {
    }
    # Those elements are defined in utils.common.sh but used by the ones importing it
    else if ((($0 ~ /\^-- SC2034: memcheck_result_ext appears unused\. Verify it or export it\./) \
              || ($0 ~ /\^-- SC2034: BOLD appears unused\. Verify it or export it\./) \
              || ($0 ~ /\^-- SC2034: GREEN appears unused\. Verify it or export it\./) \
              || ($0 ~ /\^-- SC2034: PURPLE appears unused\. Verify it or export it\./) \
              || ($0 ~ /\^-- SC2034: ORANGE appears unused\. Verify it or export it\./)) \
             && (previous_lines[0] ~ /bin\/utils\.common\.sh line [0-9]+:/))
    {
    }
    # This call to a sub-shell is intended to
    else if (($0 ~ /\^-- SC2091: Remove surrounding \$\(\) to avoid executing output./) \
             && (previous_lines[0] ~ /tests\/generate_html_params_ts\/generate_config_param_ts_ptc\.sh line 41:/))
    {
    }
    # `test_cases` is set by the caller
    else if (($0 ~ /\^-- SC2154: test_cases is referenced but not assigned \(did you mean 'test_case'\?\)\./) \
             && (previous_lines[0] ~ /tests\/utils\.test\.sh line 26:/))
    {
    }
    # `error_occured` is used by the caller
    else if (($0 ~ /\^-- SC2034: error_occured appears unused\. Verify it or export it\./) \
             && (previous_lines[0] ~ /tests\/utils\.test\.sh line 265:/))
    {
    }
    # `useless_result` in only set to prevent evaluation of it's assigned sub-shell output
    else if (($0 ~ /\^-- SC2034: useless_result appears unused./) \
             && (previous_lines[0] ~ /tests\/generate_html_outputs_ts\/ts_setup\.sh line 111:/))
    {
    }
    # In tests, `test_cases` variable is declared and then processed by a function from utils.test.sh
    else if (($0 ~ /\^-- SC2034: test_cases appears unused\./) \
             && (previous_lines[0] ~ /tests\/[^\/]+\/.+\.sh line [0-9]+:/))
    {
    }
    # In tests, `param_to_test` is voluntarily not quote to check space behaviour
    else if (($0 ~ /\^-- SC2086: Double quote to prevent globbing and word splitting\./) \
             && (previous_lines[0] ~ /tests\/[^\/]+\/.+\.sh line [0-9]+:/) \
             && (previous_lines[1] ~ / \$\{param_to_test\}/))
    {
    }
    # In tests, `in_dir_param` and `out_dir_param` are voluntarily not quote to check space behaviour
    else if (($0 ~ /\^-- SC2086: Double quote to prevent globbing and word splitting\./) \
             && (previous_lines[0] ~ /tests\/generate_html_params_ts\/in_dir_out_dir_param_ts_ptc\.sh line 73:/))
    {
    }
    else
    {
        previous_lines[previous_line_index] = $0

        ++previous_line_index
    }
}

END {
    print_buffers()

    exit error_occured
}