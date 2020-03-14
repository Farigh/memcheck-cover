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

BEGIN {
    error_count = 0
    warning_count = 0
    info_count = 0
}

/class="error_leak"/ {
    ++error_count
}

/class="warning_leak"/ {
    ++warning_count
}

/class="leak_context_info"/ {
    ++info_count
}

END {
    # Compute report status
    report_status = "SUCCESS"
    report_status_class = "analysis_pass_status"

    if (error_count != 0) {
        report_status = "ERROR"
        report_status_class = "analysis_error_status"
    } else if (warning_count != 0) {
        report_status = "WARNING"
        report_status_class = "analysis_warning_status"
    }

    # Add opening brace (span is used to vertical recenter)
    output_buffer = "<span class=\"brace_recenter\">[</span>"

    # Add status span
    output_buffer = output_buffer "<span class=\"" report_status_class "\">" report_status "</span>"

    # Add closing brace (span is used to vertical recenter)
    output_buffer = output_buffer "<span class=\"brace_recenter\">]</span>"

    # Output result status
    print output_buffer
}
