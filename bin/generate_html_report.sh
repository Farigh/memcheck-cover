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

resolved_script_path=$(readlink -f "$0")
current_script_dir=$(dirname "${resolved_script_path}")
current_full_path=$(readlink -e "${current_script_dir}")

# Import common utils
source "${current_full_path}/utils.common.sh"

html_part_ext=".html.part"

awk_script_dir="${current_full_path}/awk/"

html_res_dir="${current_full_path}/html_res/"

last_analysis_result_id=0
analysis_result_id_prefix="valgrind.result"

default_config_output="memcheck-cover.config"
base_html_indent="                "

declare -A memcheck_violation_criticality
declare -A memcheck_client_check_criticality
declare -A memcheck_summary_criticality
declare -A memcheck_violation_criticality_example
declare -A memcheck_client_check_criticality_example
declare -A memcheck_summary_criticality_example
declare -a awk_memcheck_format_opt

################################################
###                 FUNCTIONS                ###
################################################

function print_usage()
{
    echo "${CYAN}Usage:${RESET_FORMAT} $0 [OPTIONS]..."
    echo "Parses all .${memcheck_result_ext} files from a given directory and generates an HTML"
    echo "report."
    echo ""
    echo "${CYAN}Options:${RESET_FORMAT}"
    echo "  -h|--help             Displays this help message."
    echo "  -g|--generate-config  Generates a '${default_config_output}' file in the current"
    echo "                        directory, containing the default configuration values."
    echo ""
    echo "  -c|--config=FILE      Loads the configuration from FILE. A sample configuration"
    echo "                        file can be generated using the --generate-config option."
    echo "                        If this option is not set, or values are missing in FILE,"
    echo "                        the default values will be used."
    echo "  -i|--input-dir=DIR    [${RED}MANDATORY${RESET_FORMAT}] Defines the input directory"
    echo "                        where the .${memcheck_result_ext} files are."
    echo "                        The files will be searched in directories"
    echo "                        recursivly."
    echo "  -o|--output-dir=DIR   [${RED}MANDATORY${RESET_FORMAT}] Defines the output directory"
    echo "                        where the HTML report will be produced."

    print_copyright_notice
}

function init_criticality_levels()
{
    #############################################
    ##        Default error violations         ##
    #############################################

    # Definitely lost
    memcheck_violation_criticality['definitely_lost']="error"
    memcheck_violation_criticality_example['definitely_lost']="4 bytes in 1 blocks are definitely lost in loss record 1 of 1"

    # Indirectly lost
    memcheck_violation_criticality['indirectly_lost']="error"
    memcheck_violation_criticality_example['indirectly_lost']="48 bytes in 1 blocks are indirectly lost in loss record 1 of 2"

    # Still reachable
    memcheck_violation_criticality['still_reachable']="error"
    memcheck_violation_criticality_example['still_reachable']="10 bytes in 1 blocks are still reachable in loss record 1 of 1"

    # Invalid read
    memcheck_violation_criticality['invalid_read']="error"
    memcheck_violation_criticality_example['invalid_read']="Invalid read of size 8"

    # Invalid write
    memcheck_violation_criticality['invalid_write']="error"
    memcheck_violation_criticality_example['invalid_write']="Invalid write of size 4"

    # Syscall param points to unaddressable byte(s)
    memcheck_violation_criticality['points_to_unaddressable']="error"
    memcheck_violation_criticality_example['points_to_unaddressable']="Syscall param read(buf) points to unaddressable byte(s)"

    # (Syscall param ?) contains unaddressable byte(s)
    memcheck_violation_criticality['contains_unaddressable']="error"
    memcheck_violation_criticality_example['contains_unaddressable']="Syscall param write(buf) contains unaddressable byte(s)"

    # Syscall param contains uninitialised byte(s)
    memcheck_violation_criticality['contains_uninitialized']="error"
    memcheck_violation_criticality_example['contains_uninitialized']="Syscall param exit_group(status) contains uninitialised byte(s)"

    # Syscall param points to uninitialised byte(s)
    memcheck_violation_criticality['points_to_uninitialized']="error"
    memcheck_violation_criticality_example['points_to_uninitialized']="Syscall param write(buf) points to uninitialised byte(s)"

    # Illegal memory pool address
    memcheck_violation_criticality['illegal_mem_pool_addr']="error"
    memcheck_violation_criticality_example['illegal_mem_pool_addr']="Illegal memory pool address"

    #############################################
    ##       Default warning violations        ##
    #############################################

    # Possibly lost
    memcheck_violation_criticality['possibly_lost']="warning"
    memcheck_violation_criticality_example['possibly_lost']="6 bytes in 1 blocks are possibly lost in loss record 1 of 1"

    # Invalid dealloc
    memcheck_violation_criticality['dealloc_invalid']="warning"
    memcheck_violation_criticality_example['dealloc_invalid']="Invalid free() / delete / delete[] / realloc()"

    # Mismatched dealloc
    memcheck_violation_criticality['dealloc_mismatched']="warning"
    memcheck_violation_criticality_example['dealloc_mismatched']="Mismatched free() / delete / delete []"

    # Fishy argument value
    memcheck_violation_criticality['fishy_argument_value']="warning"
    memcheck_violation_criticality_example['fishy_argument_value']="Argument 'size' of function malloc has a fishy (possibly negative) value: -1"

    # Uninitialized value conditionnal jump or move
    memcheck_violation_criticality['uninitialized_value_jump_move']="warning"
    memcheck_violation_criticality_example['uninitialized_value_jump_move']="Conditional jump or move depends on uninitialised value(s)"

    # Uninitialized value use
    memcheck_violation_criticality['uninitialized_value_use']="warning"
    memcheck_violation_criticality_example['uninitialized_value_use']="Use of uninitialised value of size 8"

    #############################################
    ##  Default client check error violations  ##
    #############################################

    # Unaddressable byte(s) found during client check request
    memcheck_client_check_criticality['unaddressable_found']="error"
    memcheck_client_check_criticality_example['unaddressable_found']="Unaddressable byte(s) found during client check request"

    # Uninitialised byte(s) found during client check request
    memcheck_client_check_criticality['uninitialised_found']="error"
    memcheck_client_check_criticality_example['uninitialised_found']="Uninitialised byte(s) found during client check request"

    ################################
    ##    Default leak summary    ##
    ################################

    # Definitely lost
    memcheck_summary_criticality['definitely_lost']="error"
    memcheck_summary_criticality_example['definitely_lost']="definitely lost: 4 bytes in 1 blocks"

    # Indirectly lost
    memcheck_summary_criticality['indirectly_lost']="error"
    memcheck_summary_criticality_example['indirectly_lost']="indirectly lost: 4 bytes in 1 blocks"

    # Possibly lost
    memcheck_summary_criticality['possibly_lost']="warning"
    memcheck_summary_criticality_example['possibly_lost']="possibly lost: 4 bytes in 1 blocks"

    # Still reachable
    memcheck_summary_criticality['still_reachable']="error"
    memcheck_summary_criticality_example['still_reachable']="still reachable: 4 bytes in 1 blocks"
}

function load_configuration()
{
    # Initialise default values
    init_criticality_levels

    # Load provided config, if any
    if [ "${config_file}" != "" ]; then

        # Ensure config file exists
        if [ ! -f "${config_file}" ]; then
            error "Configuration file '${config_file}' not found."
            exit 1
        fi

        declare -A memcheck_valid_violation_criticality_keys
        declare -A memcheck_valid_summary_criticality_keys
        declare -A memcheck_valid_client_check_criticality_keys

        # List all valid keys from the default values
        local valid_key
        for valid_key in "${!memcheck_violation_criticality[@]}"; do
            memcheck_valid_violation_criticality_keys[$valid_key]="valid"
        done
        for valid_key in "${!memcheck_summary_criticality[@]}"; do
            memcheck_valid_summary_criticality_keys[$valid_key]="valid"
        done
        for valid_key in "${!memcheck_client_check_criticality[@]}"; do
            memcheck_valid_client_check_criticality_keys[$valid_key]="valid"
        done

        info "Loading configuration from file '${config_file}'..."

        # Ensure the file can be sourced safely
        local try_source=$(source "${config_file}" 2>&1)
        if [ "${try_source}" != "" ]; then
            error "Loading configuration file '${config_file}' failed with errors:"
            echo "${try_source}"
            exit 1
        fi

        # Source the configuration
        source "${config_file}"

        local config_error_occured=0

        # Ensure the provided key from the configuration are valid
        local key_to_check
        for key_to_check in "${!memcheck_violation_criticality[@]}"; do
            # Ensure the key is valid
            if [ "${memcheck_valid_violation_criticality_keys[${key_to_check}]}" == "" ]; then
                error "Invalid configuration parameter: memcheck_violation_criticality['${key_to_check}']"
                ((++config_error_occured))
            # Ensure the value is valid
            elif [ "${memcheck_violation_criticality[${key_to_check}],,}" != "error" ] \
              && [ "${memcheck_violation_criticality[${key_to_check}],,}" != "warning" ]; then
                error "Invalid configuration value '${memcheck_violation_criticality[${key_to_check}]}' for parameter: memcheck_violation_criticality['${key_to_check}']"
                ((++config_error_occured))
            fi
        done
        for key_to_check in "${!memcheck_summary_criticality[@]}"; do
            # Ensure the key is valid
            if [ "${memcheck_valid_summary_criticality_keys[${key_to_check}]}" == "" ]; then
                error "Invalid configuration parameter: memcheck_summary_criticality['${key_to_check}']"
                ((++config_error_occured))
            # Ensure the value is valid
            elif [ "${memcheck_summary_criticality[${key_to_check}],,}" != "error" ] \
              && [ "${memcheck_summary_criticality[${key_to_check}],,}" != "warning" ]; then
                error "Invalid configuration value '${memcheck_summary_criticality[${key_to_check}]}' for parameter: memcheck_summary_criticality['${key_to_check}']"
                ((++config_error_occured))
            fi
        done
        for key_to_check in "${!memcheck_client_check_criticality[@]}"; do
            # Ensure the key is valid
            if [ "${memcheck_valid_client_check_criticality_keys[${key_to_check}]}" == "" ]; then
                error "Invalid configuration parameter: memcheck_client_check_criticality['${key_to_check}']"
                ((++config_error_occured))
            # Ensure the value is valid
            elif [ "${memcheck_client_check_criticality[${key_to_check}],,}" != "error" ] \
              && [ "${memcheck_client_check_criticality[${key_to_check}],,}" != "warning" ]; then
                error "Invalid configuration value '${memcheck_client_check_criticality[${key_to_check}]}' for parameter: memcheck_client_check_criticality['${key_to_check}']"
                ((++config_error_occured))
            fi
        done

        unset memcheck_valid_violation_criticality_keys
        unset memcheck_valid_summary_criticality_keys
        unset memcheck_valid_client_check_criticality_keys

        if [ $config_error_occured -ne 0 ]; then
            exit 1
        fi
    fi
}

function generate_default_config()
{
    # Initialise default values
    init_criticality_levels

    info "Generating configuration with default values: '${default_config_output}'..."

    {
        # Add information header
        echo "######"
        echo "# Memcheck-cover configuration values."
        echo "# Each violation criticality can be set to one of those values:"
        echo "#    - warning"
        echo "#    - error"
        echo "# Case does not matter."
        echo "######"

        # Add each default values, alphabetically ordered, with example comment
        local opt
        for opt in $(echo "${!memcheck_violation_criticality[@]}" | xargs -n1 | sort -g | xargs); do
            echo ""
            echo "# Criticality for the following violation type:"
            echo "#    ${memcheck_violation_criticality_example[${opt}]}"
            echo "memcheck_violation_criticality['${opt}']=\"${memcheck_violation_criticality[${opt}]}\""
        done

        # Add client check default values
        echo ""
        echo ""
        echo "######"
        echo "# The following configuration values changes the level of **client check request** valgrind's report."
        echo "# Such checks are provided by valgrind's header <memcheck.h>"
        echo "# (see: https://valgrind.org/docs/manual/mc-manual.html#mc-manual.clientreqs)"
        echo "######"

        # Add each default values, alphabetically ordered, with example comment
        for opt in $(echo "${!memcheck_client_check_criticality[@]}" | xargs -n1 | sort -g | xargs); do
            echo ""
            echo "# Criticality for the following violation type:"
            echo "#    ${memcheck_client_check_criticality_example[${opt}]}"
            echo "memcheck_client_check_criticality['${opt}']=\"${memcheck_client_check_criticality[${opt}]}\""
        done

        # Add leak summary header
        echo ""
        echo ""
        echo "######"
        echo "# The following configuration values changes the level of valgrind's report"
        echo "# LEAK SUMMARY section."
        echo "######"

        # Add each default values, alphabetically ordered, with example comment
        for opt in $(echo "${!memcheck_summary_criticality[@]}" | xargs -n1 | sort -g | xargs); do
            echo ""
            echo "# Criticality for the following leak summary type: ${memcheck_summary_criticality_example[${opt}]}"
            echo "memcheck_summary_criticality['${opt}']=\"${memcheck_summary_criticality[${opt}]}\""
        done
    } > "${default_config_output}"

    echo "Done. The generated configuration can be modified and then loaded"
    echo "by the current script using the --config option."
    echo "If a violation is not set, the default value will be used."
}

function get_files_with_ext_in_dir_ordered()
{
    local file_extension=$1
    local location_dir=$2

    find "${location_dir}" -name "*${file_extension}" -type f | sort | gawk -f "${awk_script_dir}order_files_first.awk"
}

function format_memcheck_report()
{
    local report_to_format=$1

    gawk -f "${awk_script_dir}format_memcheck_report.awk"  "${awk_memcheck_format_opt[@]}" "${report_to_format}"
}

function get_memcheck_report_summary()
{
    local html_output_dir=$1

    local file
    while read -r file; do
        cat "${file}"
    done < <(get_files_with_ext_in_dir_ordered "${html_part_ext}" "${html_output_dir}") | \
    gawk -f "${awk_script_dir}get_memcheck_report_summary.awk"
}

function get_memcheck_report_type_infos()
{
    local memcheck_report_file=$1

    gawk -f "${awk_script_dir}get_memcheck_report_summary.awk" -v only_print_content_type_infos="true" "${memcheck_report_file}"
}

function get_analysis_result_cmd()
{
    local memcheck_report_file=$1

    gawk "/==[0-9]*== Command: / { \
             line_without_html_tag = gensub(/<.*>/, \"\", \"g\"); \
             print \"Command: \" gensub(/.*== Command: (.*\\/)?(.*( .*)?)/, \"\\\\2\", 1, line_without_html_tag); \
         }" "${memcheck_report_file}"
}

function get_memcheck_analysis_title()
{
    local unique_analysis_id=$1
    local memcheck_report_file=$2

    local analysis_result_status=$(gawk -f "${awk_script_dir}get_memcheck_analysis_status.awk" "${memcheck_report_file}")
    local analysis_result_cmd=$(get_analysis_result_cmd "${memcheck_report_file}")

    local full_analysis_part_ext=".${memcheck_result_ext}${html_part_ext}"

    # Trim output directory
    local report_name="${memcheck_result_html_part:${#html_output_dir}}"

    # Remove result ext
    report_name="${report_name:0:-${#full_analysis_part_ext}}"

    # Add spaces around /
    report_name="${report_name//\// \/ }"

    local result="${analysis_result_status} "
    result+="<span id=\"${unique_analysis_id}.Title.Cmd\">"
    result+="${analysis_result_cmd}"
    result+="</span>"
    result+="<span id=\"${unique_analysis_id}.Title.Name\" class=\"hidden\">"
    result+="Analysis name: ${report_name}"
    result+="</span>"

    echo "${result}"
}

function generate_html_part()
{
    local html_output_dir=$1
    local memcheck_input_dir_len=$2
    local memcheck_result=$3

    local memcheck_result_sub_path="${memcheck_result:${memcheck_input_dir_len}}"
    info "Processing memcheck file '${memcheck_result_sub_path}' ..."

    # Create output subdir if needed
    local current_part_output_dir="${html_output_dir}"
    local current_part_dirname=$(dirname "${memcheck_result_sub_path}")
    local current_part_filename=$(basename "${memcheck_result_sub_path}")
    if [ "${current_part_dirname}" != "." ]; then
        current_part_output_dir="${html_output_dir}${current_part_dirname}/"
        mkdir -p "${current_part_output_dir}"
    fi

    # HTML part output
    local html_part_output_fullpath="${current_part_output_dir}${current_part_filename}${html_part_ext}"

    ((last_analysis_result_id++))
    local unique_analysis_id="${analysis_result_id_prefix}${last_analysis_result_id}"

    # Generate .html.part file
    {
        echo "async function updateContentOnceLoaded${last_analysis_result_id}()"
        echo "{"
        echo "    var data =\`"

        local memcheck_report_content=$(format_memcheck_report "${memcheck_result}")
        echo "${memcheck_report_content}"

        echo "\`;"
        echo "    var analysis_div = document.getElementById('${unique_analysis_id}.Report');"
        echo "    analysis_div.innerHTML=data;"
        echo "}"
        echo "updateContentOnceLoaded${last_analysis_result_id}();"
    } > "${html_part_output_fullpath}"
}

function generate_html_part_integration()
{
    local html_output_dir=$1
    local memcheck_result_html_part=$2

    local content_indent="${base_html_indent}"
    ((last_analysis_result_id++))
    local unique_analysis_id="${analysis_result_id_prefix}${last_analysis_result_id}"

    # Compute memcheck title
    local memcheck_result_title=$(get_memcheck_analysis_title "${unique_analysis_id}" "${memcheck_result_html_part}")

    # Add analysis title
    local expand_div='<div class="expand"><div></div></div>'
    local visibility_icon="<span id=\"${unique_analysis_id}.VisibilityIcon\">${expand_div}</span>"
    local on_click_action="JavaScript: ToggleAnalysisResultVisibility('${unique_analysis_id}');"

    local memcheck_report_type_infos='<span class="analysis_type_infos">'
    memcheck_report_type_infos+=$(get_memcheck_report_type_infos "${memcheck_result_html_part}")
    memcheck_report_type_infos+="</span>"

    print_with_indent "${content_indent}" "<div class=\"memcheck_analysis_title\" onclick=\"${on_click_action}\">"
    print_with_indent "${content_indent}    " "${visibility_icon} ${memcheck_result_title} ${memcheck_report_type_infos}"
    print_with_indent "${content_indent}" "</div>"

    # Add analysis content
    print_with_indent "${content_indent}" "<div id=\"${unique_analysis_id}.Report\" class=\"memcheck_analysis_content hidden\">"

    # Add loader animation (will be displayed until the html part is fully loaded and replace it)
    print_with_indent "${content_indent}    " "<span class=\"result_loader\"></span><span class=\"result_loader_text\"></span>"

    # Close analysis content
    print_with_indent "${content_indent}" "</div>"
}

function deploy_css_stylesheet()
{
    local output_dir=$1
    cp "${html_res_dir}memcheck-cover.css" "${output_dir}"
}

function deploy_javascript_script()
{
    local output_dir=$1
    cp "${html_res_dir}memcheck-cover.js" "${output_dir}"
}

function generate_result_summary()
{
    local html_output_dir=$1
    local print_indent=$2

    # Open the report summary div tag
    print_with_indent "${print_indent}" '<div class="report_summary">'

    # Add report summary infos
    local report_summary_content=$(get_memcheck_report_summary "${html_output_dir}")
    print_with_indent "${print_indent}    " "${report_summary_content}"

    # Add expand all button
    print_with_indent "${print_indent}    " '<div title="Expand all" onclick="JavaScript: ExpandAll();" class="expandall"><div></div><div></div><div></div></div>'

    # Add collapse all button
    print_with_indent "${print_indent}    " '<div title="Collapse all" onclick="JavaScript: CollapseAll();" class="collapseall"><div></div><div></div><div></div></div>'

    # Add title type selection button (command or result file)
    local toggle_title_type_button_content='<div onclick="JavaScript: ToggleAnalysisTitleType();" id="analysis_title_type_button"'
    toggle_title_type_button_content+=' class="analysis_title_type_button">Toggle title: Analysis name</div>'
    print_with_indent "${print_indent}    " "${toggle_title_type_button_content}"

    # Close the report summary div tag
    print_with_indent "${print_indent}" "</div>"
}

function resolve_placeholder()
{
    local file_to_process=$1
    local placeholder=$2
    local replacement=$3

    gawk -v placeholder="%{${placeholder}}" -v replacement="${replacement}" "{ print gensub(placeholder, replacement, 1) }" "${file_to_process}"
}

function generate_html_header()
{
    local html_output_dir=$1
    local imports_content=""

    local html_output_dir_len=${#html_output_dir}

    # Import html parts as asynchronous scripts
    local memcheck_html_part
    while read -r memcheck_html_part; do
        local memcheck_html_part_subpath=${memcheck_html_part:${html_output_dir_len}}

        # Add asynchronous scripts so the page content gets loaded first, then the report divs contents
        imports_content+="\n        <script src=\"${memcheck_html_part_subpath}\" async=\"async\"></script>"
    done < <(get_files_with_ext_in_dir_ordered "${html_part_ext}" "${html_output_dir}")

    resolve_placeholder "${html_res_dir}html_report.header" "html_part_imports" "${imports_content}" | \
    resolve_placeholder "" "html_report_title" "Valgrind's memcheck report"

    # Add result summary before details
    generate_result_summary "${html_output_dir}" "${base_html_indent}"
}

function generate_html_footer()
{
    resolve_placeholder "${html_res_dir}html_report.footer" "html_generation_tool_version" "$(get_memcheck_cover_version)"
}

function generate_html_report()
{
    local memcheck_input_dir=$1
    local html_output_dir=$2

    # Populate awk "format memcheck report" script options
    local opt
    for opt in "${!memcheck_violation_criticality[@]}"; do
        # Add violation criticality config, lower cased
        awk_memcheck_format_opt+=(-v "${opt}_criticality=${memcheck_violation_criticality[${opt}],,}")
    done
    for opt in "${!memcheck_summary_criticality[@]}"; do
        # Add violation criticality config, lower cased
        awk_memcheck_format_opt+=(-v "${opt}_summary_criticality=${memcheck_summary_criticality[${opt}],,}")
    done
    for opt in "${!memcheck_client_check_criticality[@]}"; do
        # Add violation criticality config, lower cased
        awk_memcheck_format_opt+=(-v "${opt}_client_check_criticality=${memcheck_client_check_criticality[${opt}],,}")
    done

    local memcheck_input_dir_len=${#memcheck_input_dir}

    # Process each memcheck result file
    local memcheck_count=0
    local memcheck_result
    while read -r memcheck_result; do

        generate_html_part "${html_output_dir}" "${memcheck_input_dir_len}" "${memcheck_result}"

        ((memcheck_count++))
    done < <(get_files_with_ext_in_dir_ordered ".${memcheck_result_ext}" "${memcheck_input_dir}")

    # Reset last_analysis_result_id so the id matches the async loading ones
    last_analysis_result_id=0

    if [ $memcheck_count -eq 0 ]; then
        error "No file with the '.${memcheck_result_ext}' extension found in input directory"
        exit 1
    fi

    # Generate HTML
    local output_index_file="${html_output_dir}index.html"
    info "Generating index.html..."

    generate_html_header "${html_output_dir}" > "${output_index_file}"

    local memcheck_html_part
    while read -r memcheck_html_part; do
        generate_html_part_integration "${html_output_dir}" "${memcheck_html_part}" >> "${output_index_file}"
    done < <(get_files_with_ext_in_dir_ordered "${html_part_ext}" "${html_output_dir}")

    generate_html_footer >> "${output_index_file}"

    # Deploy CSS stylesheet to output directory
    deploy_css_stylesheet "${html_output_dir}"

    # Deploy JavaScript file to output directory
    deploy_javascript_script "${html_output_dir}"
}

################################################
###                  GETOPT                  ###
################################################

config_file=""
html_output_dir=""
memcheck_input_dir=""
while getopts ":c:ghi:o:-:" parsed_option; do
    case "${parsed_option}" in
        # Long options
        -)
            case "${OPTARG}" in
                config=*)
                    config_file=${OPTARG#*=}
                    check_param "--config" "${config_file}"
                ;;
                config)
                    config_file="${!OPTIND}"; ((OPTIND++))
                    check_param "--config" "${config_file}"
                ;;
                input-dir)
                    memcheck_input_dir="${!OPTIND}"; ((OPTIND++))
                    check_param "--input-dir" "${memcheck_input_dir}"
                ;;
                input-dir=*)
                    memcheck_input_dir=${OPTARG#*=}
                    check_param "--input-dir" "${memcheck_input_dir}"
                ;;
                output-dir)
                    html_output_dir="${!OPTIND}"; ((OPTIND++))
                    check_param "--output-dir" "${html_output_dir}"
                ;;
                output-dir=*)
                    html_output_dir=${OPTARG#*=}
                    check_param "--output-dir" "${html_output_dir}"
                    shift
                ;;
                generate-config)
                    generate_default_config
                    exit 0
                ;;
                help)
                    print_usage
                    exit 0
                ;;
                *)
                    error "Unknown option '--${OPTARG}'"
                    print_usage
                    exit 1
                ;;
            esac
        ;;
        # Short options
        c)
            config_file="${OPTARG}"
            check_param "-c" "${config_file}"
        ;;
        i)
            memcheck_input_dir="${OPTARG}"
            check_param "-i" "${memcheck_input_dir}"
        ;;
        o)
            html_output_dir="${OPTARG}"
            check_param "-o" "${html_output_dir}"
        ;;
        g)
            generate_default_config
            exit 0
        ;;
        h)
            print_usage
            exit 0
        ;;
        :)
            error "Option '-${OPTARG}' requires a value"
            print_usage
            exit 1
        ;;
        ?)
            error "Unknown option '-${OPTARG}'"
            print_usage
            exit 1
        ;;
    esac
done

check_mandatory_param "-i|--input-dir" "${memcheck_input_dir}"
check_mandatory_param "-o|--output-dir" "${html_output_dir}"

if [ ! -d "${memcheck_input_dir}" ]; then
    error "Could not access input dir '${memcheck_input_dir}': No such directory"
    exit 1
fi

# -e test returns false if /path/to/a exists but is not a dir if it has a trailing /
html_output_dir_not_trailling="${html_output_dir}"
if [ "${html_output_dir_not_trailling: -1}" == "/" ]; then
    html_output_dir_not_trailling="${html_output_dir_not_trailling:0:-1}"
fi

if [ -e "${html_output_dir_not_trailling}" ] && [ ! -d "${html_output_dir}" ]; then
    error "Provided output directory '${html_output_dir}' exists but is not a directory"
    exit 1
fi

################################################
###                   MAIN                   ###
################################################

# Check bin requirement
require_bin_or_die "gawk"

info "Input directory set to: '${memcheck_input_dir}'"

create_outdir_if_necessary "${html_output_dir}"

load_configuration

generate_html_report "${memcheck_input_dir}" "${html_output_dir}"
