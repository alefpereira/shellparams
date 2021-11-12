#!/bin/bash
# Parse params using getopt to assist handling options.
#
# getopt parse both Unix/POSIX syntax and GNU syntax conventions and translate
# it to a single format (easy to parse) output.
#
# See links below for more information:
# Unix/POSIX Utility Conventions:
# https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap12.html
#
# GNU Program Argument Syntax Conventions:
# https://www.gnu.org/software/libc/manual/html_node/Argument-Syntax.html
#
# This example is greatly inspired by: https://www.shellscript.sh/tips/getopt

# Defaults
OPT_A=
OPT_B=unset # Can also use unset
OPT_C=false # Bash allows true or false
OPT_D='MyDefaultValue'

function usage {
  cat << EOF # Using cat to print help string for better indentation
Usage: shellparams [OPTIONS]...
Parse Unix/POSIX and GNU style params

Options:
  -a, --opta               Flag option "a"
  -b, --optb               Flag option "b"
  -c, --optc=OPTCVALUE     Option-argument "c"
  -d, --optd[=OPTDVALUE]   Optional Option-argument "d" (default is "$OPT_D")
  -h, --help               Shows this help

Example:
  shellparams "1stPositionalParam" -c "myCvalue" -b -a --optd "2ndPositionalParam_NOT_D_arg"
  shellparams "1stPositionalParam" -cmyCvalue -ba --optd="myDvalue" "2ndPositionalParam"
EOF
  exit 2
}

# getopt options
SHORT_OPTS="habc:d::"
LONG_OPTS="help,opta,optb,optc:,optd::"

# Parse params with getopt
PARSED_PARAMS=$(getopt -n $0 -o $SHORT_OPTS -l $LONG_OPTS -- "$@")

# Check last command (getopt params parsing) executed without error.
VALID_PARAMS=$?
if [ ! $VALID_PARAMS -eq 0 ]; then # 0 is ok, other than that is error
  usage
fi

echo "PARSED_PARAMS: $PARSED_PARAMS"

# Loop over getopt parsed params
eval set -- "$PARSED_PARAMS"
while :
do
  case "$1" in
    -a | --opta)  OPT_A=true            ; shift   ;;
    -b | --optb)  OPT_B=1               ; shift   ;;
    -c | --optc)  OPT_C="$2"            ; shift 2 ;;
    -d | --optd)  OPT_D="${2:-$OPT_D}"  ; shift 2 ;; # A=${B:-$C} sets A equal B if B is set to non-empty value, otherwise set A equals C
    -h | --help)  usage                 ;         ;;
    --) shift; break ;; # "--" is a special case indicating the ending of the options. The remaining parsed params are positional params.
  esac
done

echo "OPT_A  : $OPT_A"
echo "OPT_B  : $OPT_B"
echo "OPT_C  : $OPT_C"
echo "OPT_D  : $OPT_D"
echo "Positional Parameters: $@"
