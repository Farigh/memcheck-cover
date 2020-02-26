#! /bin/bash

resolved_script_path=$(readlink -f $0)
current_script_dir=$(dirname $resolved_script_path)
current_full_path=$(readlink -e $current_script_dir)

# Import common utils
source "${current_full_path}/utils.common.sh"

html_part_ext=".html.part"

awk_script_dir="${current_full_path}/awk/"

html_res_dir="${current_full_path}/html_res/"

last_analysis_result_id=0

################################################
###                 FUNCTIONS                ###
################################################

function print_usage()
{
    info "Usage: $0 [OPTIONS]..."
    echo "Parses all .${memcheck_result_ext} files from a given directory and generates an HTML"
    echo "report."
    echo ""
    echo "Options:"
    echo "  -h|--help             Displays this help message."
    echo "  -i|--input-dir=DIR    [${RED}MANDATORY${RESET_FORMAT}] Defines the input directory"
    echo "                        where the .${memcheck_result_ext} files are."
    echo "                        The files will be searched in directories"
    echo "                        recursivly."
    echo "  -o|--output-dir=DIR   [${RED}MANDATORY${RESET_FORMAT}] Defines the output directory"
    echo "                        where the HTML report will be produced."
}

function format_memcheck_report()
{
    local report_to_format=$1

    awk -f "${awk_script_dir}format_memcheck_report.awk" "${report_to_format}"
}

function get_memcheck_analysis_title()
{
    local memcheck_report_file=$1

    awk -f "${awk_script_dir}get_memcheck_analysis_title.awk" "${memcheck_report_file}"
}

function generate_html_part()
{
    local html_output_dir=$1
    local memcheck_input_dir_len=$2
    local memcheck_result=$3

    local content_indent="        "
    ((last_analysis_result_id++))
    local unique_analysis_id="valgrind.result${last_analysis_result_id}"

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

    # Compute memcheck title
    local memcheck_result_title=$(get_memcheck_analysis_title "${memcheck_result}")

    # HTML part output
    local html_part_output_fullpath="${current_part_output_dir}${current_part_filename}${html_part_ext}"

    # Add analysis title
    local visibility_arrow="<span id=\"${unique_analysis_id}.Arrow\">&#9658;</span>"
    local on_click_action="JavaScript: ToogleAnalysisResultVisibility('${unique_analysis_id}');"

    print_with_indent "${content_indent}" "<div class=\"memcheck_analysis_title\" onclick=\"${on_click_action}\">" > "${html_part_output_fullpath}"
    print_with_indent "${content_indent}    " "${visibility_arrow} ${memcheck_result_title}" >> "${html_part_output_fullpath}"
    print_with_indent "${content_indent}" "</div>" >> "${html_part_output_fullpath}"

    # Add analysis content
    print_with_indent "${content_indent}" "<div id=\"${unique_analysis_id}.Report\" class=\"memcheck_analysis_content hidden\">" >> "${html_part_output_fullpath}"

    local memcheck_report_content=$(format_memcheck_report "${memcheck_result}")
    print_with_indent "${content_indent}    " "${memcheck_report_content}" >> "${html_part_output_fullpath}"

    print_with_indent "${content_indent}" "</div>" >> "${html_part_output_fullpath}"
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

function generate_title()
{
    local print_indent=$1

    # Open the title div tag
    print_with_indent "${print_indent}" '<div class="report_title">'

    # Add title content
    print_with_indent "${print_indent}    " "Valgrind's memcheck report"

    # Close the title div tag
    print_with_indent "${print_indent}" "</div>"

    # Add a separator
    print_with_indent "${print_indent}" '<div class="report_separator"></div>'
}

function generate_html_header()
{
    cat "${html_res_dir}html_report.header"

    # Add report title part
    generate_title "        "
}

function generate_html_footer()
{
    cat "${html_res_dir}html_report.footer"
}

function generate_html_report()
{
    local memcheck_input_dir=$1
    local html_output_dir=$2

    local memcheck_input_dir_len=${#memcheck_input_dir}

    # Process each memcheck result file
    local memcheck_count=0
    local memcheck_result
    for memcheck_result in $(find "${memcheck_input_dir}" -name "*.${memcheck_result_ext}" -type f | sort); do

        generate_html_part "${html_output_dir}" "${memcheck_input_dir_len}" "${memcheck_result}"

        ((memcheck_count++))
    done

    if [ $memcheck_count -eq 0 ]; then
        error "No file with the '.${memcheck_result_ext}' extension found in input directory"
        exit 1
    fi

    # Generate HTML
    local output_index_file="${html_output_dir}index.html"
    info "Generating index.html..."

    generate_html_header > "${output_index_file}"

    for memcheck_html_part in $(find "${html_output_dir}" -name "*${html_part_ext}" -type f | sort); do
        cat "${memcheck_html_part}" >> "${output_index_file}"
    done

    generate_html_footer >> "${output_index_file}"

    # Deploy CSS stylesheet to output directory
    deploy_css_stylesheet "${html_output_dir}"

    # Deploy JavaScript file to output directory
    deploy_javascript_script "${html_output_dir}"
}

################################################
###                  GETOPT                  ###
################################################

html_output_dir=""
memcheck_input_dir=""
while getopts ":hi:o:-:" parsed_option; do
    case "${parsed_option}" in
        # Long options
        -)
            case "${OPTARG}" in
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
        i)
            memcheck_input_dir="${OPTARG}"
            check_param "-i" "${memcheck_input_dir}"
        ;;
        o)
            html_output_dir="${OPTARG}"
            check_param "-o" "${html_output_dir}"
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

info "Input directory set to: '${memcheck_input_dir}'"

create_outdir_if_necessary "${html_output_dir}"

generate_html_report "${memcheck_input_dir}" "${html_output_dir}"
