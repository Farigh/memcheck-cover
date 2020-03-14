#! /usr/bin/env bash

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

# Enable colors only if in interactive shell
if [ -t 1 ]; then
    RESET_FORMAT=$(echo -e '\e[00m')
    BOLD=$(echo -e '\e[1m')
    RED=$(echo -e '\e[31m')
    GREEN=$(echo -e '\e[32m')
    PURPLE=$(echo -e '\e[0;35m')
    ORANGE=$(echo -e '\e[38;5;208m')
    CYAN=$(echo -e '\e[0;36m')
fi

memcheck_result_ext="memcheck"

################################################
###                 FUNCTIONS                ###
################################################

function error()
{
    echo "${RED}Error:${RESET_FORMAT} $1" >&2
}

function info()
{
    echo "${CYAN}Info:${RESET_FORMAT} $1"
}

function print_copyright_notice()
{
    echo ""
    echo "Memcheck-cover  Copyright (C) 2020 GARCIN David"
    echo "This program comes with ABSOLUTELY NO WARRANTY."
    echo "This is free software, and you are welcome to redistribute it"
    echo "under certain conditions."
}

function print_with_indent()
{
    local indent_string=$1
    local to_print=$2

    echo "${to_print}" | awk '{ print "'"${indent_string}"'" $0; }'
}

function check_param()
{
    local opt_name=$1
    local opt_value=$2

    # Ensure a value was passed or the -- opt separator was not considered a param value
    if [ "${opt_value}" == "--" ] || [ "${opt_value}" == "" ]; then
        error "Option '${opt_name}' requires a value"
        print_usage
        exit 1
    # Ensure another opt was not considered a param value
    elif [[ "${opt_value}" == "-"* ]]; then
        error "Invalid value '${opt_value}' for option '${opt_name}'"
        print_usage
        exit 1
    fi
}

function check_mandatory_param()
{
    local opt_name=$1
    local opt_value=$2

    if [ "${opt_value}" == "" ]; then
        error "Mandatory parameter '${opt_name}' not provided"
        print_usage
        exit 1
    fi
}

function create_outdir_if_necessary()
{
    local dir_to_create=$1
    if [ ! -d "${dir_to_create}" ]; then
        info "Creating output directory '${dir_to_create}'"
        mkdir -p "${dir_to_create}"
        if [ $? -ne 0 ]; then
            error "Could not create output dir '${dir_to_create}'"
            exit 1
        fi
    fi
}
