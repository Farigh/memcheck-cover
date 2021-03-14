#! /usr/bin/gawk -f

#####
##
## This script is a helper to increment the release version number
##
#####

{
    if ($0 ~ /\[Full Changelog\]\(https:\/\/github\.com\/Farigh\/memcheck-cover\/compare\/release-[0-9]+.[0-9]+\.\.\.HEAD\)/) {
        current_date = strftime("%Y-%m-%d")

        # Update unreleased changes compare link
        print "[Full Changelog](https://github.com/Farigh/memcheck-cover/compare/release-" new_version "...HEAD)"
        print ""

        # Add new version header
        print "## [v" new_version "](https://github.com/Farigh/memcheck-cover/releases/tag/release-" new_version ") (" current_date ")"
        print ""
        # Add new version changes compare link
        print gensub(/HEAD/, "release-" new_version, 1, $0)
    } else {
        print $0
    }
}
