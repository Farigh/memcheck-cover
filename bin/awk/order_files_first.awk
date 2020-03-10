#! /bin/awk

function cmp_dir(key1, value1, key2, value2)
{
    # Sort index forcing string value comparison, ascending order
    key1 = key1 ""
    key2 = key2 ""
    if (key1 < key2)
        return -1
    return (key1 != key2)
}

{
    dirname = gensub(/(.*\/)[^/]*/, "\\1", 1);
    dir_to_files[dirname] = dir_to_files[dirname] $0 "\n"
}

END {
    PROCINFO["sorted_in"] = "cmp_dir"
    for (dirname in dir_to_files)
    {
        printf("%s", dir_to_files[dirname])
    }
}
