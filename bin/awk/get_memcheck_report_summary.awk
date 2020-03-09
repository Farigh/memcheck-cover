#! /bin/awk
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

/class="warning_leak"/ {
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

    success_percent = 100 * success_report_count / total_reports_count
    warning_percent = 100 * warning_report_count / total_reports_count
    warning_percent = warning_percent + success_percent

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

    print "<div class=\"report_summary_title\">Result summary:</div>"
    print "<div class=\"report_summary_ratio\" title=\"" summary_ratio_title "\" style=\"" ratio_style "\">"
    print "    Pass: " success_report_count " / " total_reports_count
    print "</div>"

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

    print "<br /><br />"
}
