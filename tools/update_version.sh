#! /bin/bash

#####
##
## This script is a helper to increment the release version number
##
#####

new_version=$1
resolved_script_path=$(readlink -f "$0")
current_script_dir=$(dirname "${resolved_script_path}")
current_full_path=$(readlink -e "${current_script_dir}")

common_utils_script="${current_full_path}/../bin/utils.common.sh"

source "${common_utils_script}"

function error_and_exit()
{
    local error_message=$1

    error "${error_message}"
    exit 1
}

##############
##   MAIN   ##
##############

if ! [[ "${new_version}" =~ ^[0-9]+.[0-9]$ ]]; then
    error_and_exit "Invalid version: '${PURPLE}${new_version}${RESET_FORMAT}'"
else
    info "New version: ${PURPLE}${new_version}${RESET_FORMAT}"
fi

###
# Update version number
###
gawk -i inplace -vnew_version="${new_version}" -f "${current_full_path}/awk/update_version.awk" "${common_utils_script}"

echo ""

###
# Update all tests' references
###

file_common_prefix=$(readlink -e "${current_full_path}/../")"/"

while IFS= read -r -d '' file_to_update; do
    file_to_update=$(readlink -e "${file_to_update}")
    info "Updating '${file_to_update:${#file_common_prefix}}'"

    gawk -i inplace -vnew_version="${new_version}" -f "${current_full_path}/awk/update_version_in_test_refs.awk" "${file_to_update}"
done < <(find "${current_full_path}/../tests/"*"/ref/" -name index.html -type f -print0)

make -C "${current_full_path}/../" test

###
# Update Changelog
###

changelog_file="${current_full_path}/../CHANGELOG.md"
gawk -i inplace -vnew_version="${new_version}" -f "${current_full_path}/awk/update_version_in_changelog.awk" "${changelog_file}"
