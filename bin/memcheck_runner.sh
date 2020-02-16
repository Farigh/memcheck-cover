#! /bin/bash

# Enable colors only if in interactive shell
if [ -t 1 ]; then
    RESET_FORMAT=$(echo -e '\e[00m')
    RED=$(echo -e '\e[31m')
    CYAN=$(echo -e '\e[0;36m')
fi

memcheck_result_ext="memcheck"

################################################
###                CHECK DEPS                ###
################################################

if ! which valgrind > /dev/null 2>&1; then
    error "Valgrind binary not found, please install it"
    exit 1
fi

################################################
###                 FUNCTIONS                ###
################################################

function print_usage()
{
    info "Usage: $0 [OPTIONS]... -- [BIN] [BIN_ARG]..."
    echo "Runs the BIN with the BIN_ARGs through valgrind memcheck analyser."
    echo ""
    echo "Options:"
    echo "  -h|--help               Displays this help message."
    echo "  -i|--ignore=FILE        Provides valgrind FILE as the suppression file."
    echo "  -o|--output-name=NAME   [${RED}MANDATORY${RESET_FORMAT}] Defines the output file name"
    echo "                          (will be suffixed with the .${memcheck_result_ext} extension)."
    echo "  -s|--gen-suppressions   Enables valgrind suppression generation in the output file,"
    echo "                          those can be used to create a suppression file."
}

function error()
{
    echo "${RED}Error:${RESET_FORMAT} $1" >&2
}

function info()
{
    echo "${CYAN}Info:${RESET_FORMAT} $1"
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

function print_args()
{
    while [ $# -gt 0 ]; do
        local param=$(echo $1 | sed 's/"/\\"/g')
        echo -n "\"${param}\" "
        shift
    done
}

################################################
###                  GETOPT                  ###
################################################

memcheck_output_name=""
memcheck_ignore_file=""
enable_suppression=0
while getopts ":hi:o:s-:" parsed_option; do
    case "${parsed_option}" in
        # Long options
        -)
            case "${OPTARG}" in
                ignore)
                    memcheck_ignore_file="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
                    check_param "--ignore" "${memcheck_ignore_file}"
                ;;
                ignore=*)
                    memcheck_ignore_file=${OPTARG#*=}
                    check_param "--ignore" "${memcheck_ignore_file}"
                ;;
                output-name)
                    memcheck_output_name="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
                    check_param "--output-name" "${memcheck_output_name}"
                ;;
                output-name=*)
                    memcheck_output_name=${OPTARG#*=}
                    check_param "--output-name" "${memcheck_output_name}"
                    shift
                ;;
                gen-suppressions)
                    enable_suppression=1
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
            memcheck_ignore_file="${OPTARG}"
            check_param "-i" "${memcheck_ignore_file}"
        ;;
        s)
            enable_suppression=1
        ;;
        o)
            memcheck_output_name="${OPTARG}"
            check_param "-o" "${memcheck_output_name}"
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

# OPTIND - 1 points to the last processed opt (should be --), shift that -1, so we have "--" as first arg
# Only do that if we processed at least 1 arg
if [ $OPTIND -gt 1 ]; then
    shift $(($OPTIND - 2))
fi

if [ "$1" == "--" ]; then
    # Shift the '--' arg
    shift
else
    error "Expected param order: <runner args> -- <bin and args>"
    print_usage
    exit 1
fi

if [ $# -le 0 ]; then
    error "No binary provided"
    print_usage
    exit 1
fi

if [ "${memcheck_output_name}" == "" ]; then
    error "Mandatory parameter '-o|--output-name' not provided"
    print_usage
    exit 1
fi

################################################
###                   MAIN                   ###
################################################

memcheck_output_file="${memcheck_output_name}.${memcheck_result_ext}"

valgrind_opts=(
    "--track-origins=yes"
    "--leak-check=full"
    "--show-reachable=yes"
    "--num-callers=50"
    "--fair-sched=yes"
    "--log-file=${memcheck_output_file}"
)

# Add ignore option if provided
if [ "${memcheck_ignore_file}" != "" ]; then
    if [ ! -f "${memcheck_ignore_file}" ]; then
        error "Ignore file '${memcheck_ignore_file}' could not be found, or is not a file"
        print_usage
        exit 1
    fi

    valgrind_opts+=("--suppressions=${memcheck_ignore_file}")
    info "Memcheck suppression file set to: '${memcheck_ignore_file}'"
fi

# Add suppression generation if asked for
if [ $enable_suppression -eq 1 ]; then
    valgrind_opts+=("--gen-suppressions=all")
    info "Valgrind suppression generation enabled"
fi

# Output option
info "Output file set to: '${memcheck_output_file}'"
ouput_file_dir=$(dirname "${memcheck_output_file}")
if [ ! -d "${ouput_file_dir}" ]; then
    info "Creating output directory '${ouput_file_dir}/'"
    mkdir -p "${ouput_file_dir}"
fi

# Run the given args through valgrind memcheck analyser
bin_cmd=$(print_args "$@")
info "Running the following cmd with valgrind:"
echo "      ${bin_cmd}"

valgrind "${valgrind_opts[@]}" -- "$@"
