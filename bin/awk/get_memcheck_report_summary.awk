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

###
# Input params:
#   - only_print_content_type_infos (Optional) If set to "true", only the
#                                   analysis report type infos are outputed

BEGIN {
    total_error_count = 0
    total_warning_count = 0
    total_info_count = 0

    success_report_count = 0
    warning_report_count = 0
    error_report_count = 0

    current_report_level = ""
}

function endOfPreviousReport()
{
    if (current_report_level != "")
    {
        if (current_report_level == "S")
        {
            ++success_report_count
        }
        else if (current_report_level == "W")
        {
            ++warning_report_count
        }
        else
        {
            ++error_report_count
        }
    }

    # Reset level to Success for next report
    current_report_level = "S"
}

/==[0-9]*== Command: / {
    endOfPreviousReport();
}

/class="error_leak"/ {
    ++total_error_count
    current_report_level = "E"
}

/class="warning_leak"/ || /class="valgrind_warning"/ {
    ++total_warning_count

    # Only update the status if the report is still successful
    if (current_report_level == "S")
    {
        current_report_level = "W"
    }
}

/class="leak_context_info"/ {
    ++total_info_count
}

END {
    endOfPreviousReport()

    total_reports_count = success_report_count + warning_report_count + error_report_count

    if (total_reports_count > 0)
    {
        success_percent = 100 * success_report_count / total_reports_count
        warning_percent = 100 * warning_report_count / total_reports_count
        warning_percent = warning_percent + success_percent
    }
    else
    {
        success_percent = 100
        warning_percent = 100
    }

    green_color = "#00CF00"

    ratio_style = "background-image: linear-gradient(to right, "
    ratio_style = ratio_style green_color " " success_percent "%, orange " success_percent "%, "
    ratio_style = ratio_style "orange " warning_percent "%, red " warning_percent "%, "
    ratio_style = ratio_style "red 100%);"

    summary_ratio_title = ""

    if (success_report_count != 0)
    {
        summary_ratio_title = summary_ratio_title "Success: " success_report_count
    }

    if (warning_report_count != 0)
    {
        if (summary_ratio_title != "")
        {
            summary_ratio_title = summary_ratio_title "   |   "
        }
        summary_ratio_title = summary_ratio_title "Warnings: " warning_report_count
    }

    if (error_report_count != 0)
    {
        if (summary_ratio_title != "")
        {
            summary_ratio_title = summary_ratio_title "   |   "
        }
        summary_ratio_title = summary_ratio_title "Errors: " error_report_count
    }

    # Print report result
    if (only_print_content_type_infos != "true")
    {
        print "<div class=\"report_summary_title\">Result summary:</div>"
        print "<div class=\"report_summary_ratio\" title=\"" summary_ratio_title "\" style=\"" ratio_style "\">"
        print "    Pass: " success_report_count " / " total_reports_count
        print "</div>"
    }

    if (total_error_count != 0)
    {
        print "<div class=\"report_summary_errors\">Errors: " total_error_count "</div>"
    }

    if (total_warning_count != 0)
    {
        print "<div class=\"report_summary_warnings\">Warnings: " total_warning_count "</div>"
    }

    if (total_info_count != 0)
    {
        print "<div class=\"report_summary_infos\">Infos: " total_info_count "</div>"
    }

    if (only_print_content_type_infos != "true")
    {
        print "<br /><br />"
    }
}
