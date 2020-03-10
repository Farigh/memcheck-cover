#! /bin/awk

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
