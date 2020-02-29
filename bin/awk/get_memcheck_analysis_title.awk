#! /bin/awk
BEGIN {
    report_status = "SUCCESS"
    report_status_class = "analysis_pass_status"
    analysis_cmd = ""
}

/==[0-9]*== Command: / {
    line_without_html_tag = gensub(/<.*>/, "", "g");
    analysis_cmd = gensub(/.*== Command: (.*\/)?(.*( .*)?)/, "\\2", 1, line_without_html_tag);
}

# Ensure no errors were reported
/==[0-9]*== ERROR SUMMARY: [0-9]* errors from / {
    if ($4 != 0) {
        report_status = "ERROR"
        report_status_class = "analysis_error_status"
    }
}

END {
    analysis_color_span="<span class=\"" report_status_class "\">"

    print "<span class=\"brace_recenter\">[</span>" analysis_color_span report_status "</span><span class=\"brace_recenter\">]</span> Command: " analysis_cmd
}
