#! /usr/bin/gawk -f

#####
##
## This script is a helper to increment the release version number
##
#####

BEGIN {
    in_version_func = 0
}

# Version function declaration
/^function get_memcheck_cover_version\(\)$/ {
    in_version_func = 1
}

# Version function closing brace
/^}$/ {
    in_version_func = 0
}

{
    current_line = $0

    if (in_version_func == 1) {
        # Update version
        current_line = gensub(/echo "[0-9]+\.[0-9]+"/, "echo \"" new_version "\"", 1, current_line)
    }

    # Print the current line
    print current_line
}
