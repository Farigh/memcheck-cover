#! /usr/bin/gawk -f

######
# Memcheck-cover is an HTML report generator on top of valgrind's memcheck
# Copyright (C) 2020  GARCIN David <https://github.com/Farigh/memcheck-cover>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
######

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
