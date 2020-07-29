#! /usr/bin/env bash

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
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
######

resolved_script_path=$(readlink -f "$0")
current_script_dir=$(dirname "${resolved_script_path}")
current_full_path=$(readlink -e "${current_script_dir}")

root_dir=$(readlink -e "${current_full_path}/../")

# Force colored output in github-ci
if [ "${GITHUB_RUN_ID}" != "" ]; then
    memcheck_cover_always_use_colors="true"
fi

# Import common utils
source "${root_dir}/bin/utils.common.sh"

# Check requirement
require_bin_or_die "shellcheck"

error_occured=0

while read -r shell_script; do
    shell_script_stripped_name="${shell_script:((${#root_dir} + 1))}"
    info "Checking file '${shell_script_stripped_name}'..."

    if ! shellcheck -s bash --color -e SC2155,SC1090,SC1107 "${shell_script}" \
         | gawk -f "${current_full_path}/awk/shellcheck_errors_filter.awk"; then
        error_occured=1
    fi
done < <(find "${root_dir}" -name "*.sh" -type f | sort | gawk -f "${root_dir}/bin/awk/order_files_first.awk")

exit $error_occured
