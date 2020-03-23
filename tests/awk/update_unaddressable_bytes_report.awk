#! /usr/bin/gawk -f

######
# Memcheck-cover test-runner utility
# Copyright (C) 2020  GARCIN David <https://github.com/Farigh/memcheck-cover>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
######

###
# Duplicate the 'points to unaddressable byte' error :
#   ==1== Syscall param read(buf) points to unaddressable byte(s)
#   ==1==    at 0x10101042: read (read.c:27)
#   ==1==    by 0x10101042: read (unistd.h:44)
#   ==1==    by 0x10101042: breakage::evil_call_points_to_unaddressable_bytes() (main.cpp:11)
#   ==1==    by 0x10101042: main (main.cpp:17)
#   ==1==  Address 0x0 is not stack'd, malloc'd or (recently) free'd
#
# And replace 'points to' with 'contains'.
# This kind of error does not seem to be possible since version 3 of valgrind, no more tests expects this one.
BEGIN {
    in_context = 0
    buffer = ""
}

# Start of the 'points to' violation context
/Syscall param .* points to unaddressable byte/ {
    in_context = 1
}

# Flush on blank line if any buffer was set
/^==[0-9]*== $/ {
    if (in_context == 1)
    {
        # Append valgrind's thread context blank line and the duplicated buffer
        print "==1== \n" buffer

        # Reset buffer variables
        in_context = 0
        buffer = ""
    }
}

{
    if (in_context == 1)
    {
        if (buffer == "")
        {
            # Rename 'points to' to 'contains' to emulate this violation
            # and append to the buffer
            buffer = gensub(/points to/, "contains", 1, $0)
        }
        else
        {
            # Append the context line to the buffer
            buffer = buffer "\n" $0
        }
    }

    # Print the current line
    print $0
}
