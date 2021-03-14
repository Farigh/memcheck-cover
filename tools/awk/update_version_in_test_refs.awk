#! /usr/bin/gawk -f

#####
##
## This script is a helper to increment the release version number
##
#####

{
    if ($0 ~ /This report was generated using/) {
        print gensub(/v[0-9]+.[0-9]+/, "v" new_version, 1)
    } else {
        # Print the current line
        print $0
    }
}
