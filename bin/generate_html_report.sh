#! /bin/bash

resolved_script_path=$(readlink -f $0)
current_script_dir=$(dirname $resolved_script_path)
current_full_path=$(readlink -e $current_script_dir)

# Import common utils
source "${current_full_path}/utils.common.sh"

html_part_ext=".html.part"

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

    local html_part_output_fullpath="${current_part_output_dir}${current_part_filename}${html_part_ext}"

    echo "<div>" > "${html_part_output_fullpath}"

    cat "${memcheck_result}" >> "${html_part_output_fullpath}"

    echo "</div>" >> "${html_part_output_fullpath}"
}

function generate_html_header()
{
    echo "<!doctype html>"
    echo "<html>"
    echo "    <head>"
    echo "    </head>"
    echo "    <body>"
}

function generate_html_footer()
{
    echo "    </body>"
    echo "</html>"
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
                    memcheck_input_dir="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
                    check_param "--input-dir" "${memcheck_input_dir}"
                ;;
                input-dir=*)
                    memcheck_input_dir=${OPTARG#*=}
                    check_param "--input-dir" "${memcheck_input_dir}"
                ;;
                output-dir)
                    html_output_dir="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
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
