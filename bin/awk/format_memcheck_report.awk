#! /bin/awk

{
    output=$0

    # Escape HTML special char &
    output=gensub(/\&/, "\\&amp;", "g", output)

    # Escape HTML special char <
    output=gensub(/</, "\\&lt;", "g", output)

    # Escape HTML special char >
    output=gensub(/>/, "\\&gt;", "g", output)

    # Replace consecutive spaces with non-breaking space to preserve valgrind report alignment
    output=gensub(/  /, " \\&nbsp;", "g", output)

    # Highlight errors
    output=gensub(/^(==[0-9]*== )(.*definitely lost .*)/, "\\1<span class=\"error_leak\">\\2<\/span>", 1, output)

    # Highlight file and line
    output=gensub(/^(==[0-9]*== .* \()([^:]*:[0-9]*))$/, "\\1<span class=\"leak_file_info\">\\2<\/span>)", 1, output)

    # Highlight LEAK SUMMARY if any error occured (ie, not having "0 bytes in 0 blocks" output)
    output=gensub(/^(==[0-9]*== )(.* lost: [1-9][0-9,]* bytes in [1-9][0-9,]* blocks.*)/, "\\1<span class=\"error_leak\">\\2<\/span>", 1, output)
    output=gensub(/^(==[0-9]*== )(.*still reachable: [1-9][0-9,]* bytes in [1-9][0-9,]* blocks.*)/, "\\1<span class=\"error_leak\">\\2<\/span>", 1, output)

    # Add HTML end of line tag
    print output "<br />"
}
