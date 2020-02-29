#! /bin/awk
BEGIN {
    analysis_cmd = ""
    error_count = 0
    warning_count = 0
    info_count = 0
}

/==[0-9]*== Command: / {
    line_without_html_tag = gensub(/<.*>/, "", "g");
    analysis_cmd = gensub(/.*== Command: (.*\/)?(.*( .*)?)/, "\\2", 1, line_without_html_tag);
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
    report_status = "SUCCESS"
    report_status_class = "analysis_pass_status"

    if (error_count != 0) {
        report_status = "ERROR"
        report_status_class = "analysis_error_status"
    } else if (warning_count != 0) {
        report_status = "WARNING"
        report_status_class = "analysis_warning_status"
    }

    analysis_color_span="<span class=\"" report_status_class "\">"

    opening_brace = "<span class=\"brace_recenter\">[</span>"
    closing_brace = "<span class=\"brace_recenter\">]</span>"

    # Result status
    output_str = opening_brace analysis_color_span report_status "</span>" closing_brace

    # Add command as title
    output_str = output_str " Command: " analysis_cmd

    print output_str
}
