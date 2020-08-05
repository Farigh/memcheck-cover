#! /bin/bash

#####
##
## This script is a helper to generate release artifacts
##
## The following artifacts are created:
##   - The tarball containing the memcheck-cover assets
##   - The integrity-check file containing both sha256 and md5 signatures of the tarball
##
#####

resolved_script_path=$(readlink -f "$0")
current_script_dir=$(dirname "${resolved_script_path}")
current_full_path=$(readlink -e "${current_script_dir}")

source "${current_full_path}/../bin/utils.common.sh"

function error_and_exit()
{
    local error_message=$1

    error "${error_message}"
    exit 1
}

function create_outputs()
{
    local memcheck_cover_version=$(get_memcheck_cover_version)
    local tarball_name="memcheck-cover-${memcheck_cover_version}.tar.bz2"
    local signature_file="${tarball_name}.sig"

    local repo_root_dir="${current_full_path}/../"

    local archive_content=(
        "${repo_root_dir}bin/"
        "${repo_root_dir}CHANGELOG.md"
        "${repo_root_dir}LICENSE"
        "${repo_root_dir}README.md"
    )

    {
        # Go to the output directory
        cd "${out_dir}" || error_and_exit "Failed to go to the output directory"

        # Create tarball
        info "Generating archive for version ${memcheck_cover_version}..."
        tar cjf "${tarball_name}" "${archive_content[@]}" || error_and_exit "Failed to create tarball"

        info "Successfully created archive with the following content:"
        local tarball_content=$(tar tf "${tarball_name}")
        print_with_indent "   " "${tarball_content}"

        # Create signature file
        echo ""
        info "Generating signatures..."
        local md5_signature=$(md5sum "${tarball_name}")
        local sha256_signature=$(sha256sum "${tarball_name}")

        {
            echo "md5      ${md5_signature}"
            echo "sha256   ${sha256_signature}"
        } > "${signature_file}"

        info "Successfully created signatures with the following content:"
        local signature_content=$(cat "${signature_file}")
        print_with_indent "   " "${signature_content}"
    }
}

##############
##   MAIN   ##
##############

out_dir="${current_full_path}/out/"

# Cleanup potential previous run outputs
[ -d "${out_dir}" ]; rm -rf "${out_dir}"
mkdir -p "${out_dir}"

create_outputs