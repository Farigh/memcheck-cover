#! /bin/awk

{
    output=$0

    # Add HTML end of line tag
    print output "<br />"
}
