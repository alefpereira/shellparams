# Shell Command Line Parameters Parser Using getopt

Parse params using getopt to assist handling options.

The utility `getopt` parse both Unix/POSIX syntax and GNU syntax conventions and translate
it to a single format (easy to parse) output.

For instance, take the two examples below
```
$ getopt -o "abc:" -l "opta,optb,optc:" -- pos1 -b -a -c argC pos2
```
and
```
$ getopt -o "abc:" -l "opta,optb,optc:" -- -ba pos1 pos2 -cargC
```
For both of them, getopt generates the same parsed output
```
 -b -a -c 'argC' -- 'pos1' 'pos2'
```

Notice that on the left side of the double dash `--` there are the options, and its arguments when applied, and on the right side there are the positional arguments.
So this new array of parameters can be easily parsed with this while loop
```
while :
do
  case "$1" in
    -a | --opta)  OPT_A=true            ; shift   ;;
    -b | --optb)  OPT_B=true            ; shift   ;;
    -c | --optc)  OPT_C="$2"            ; shift 2 ;;
    --) shift; break ;;
  esac
done
```
Check the code for the full commented example.


## Little about how to use getopt
TLDR, you can use `getopt` like
`getopt -o "<optstring>" -l "<longoptstring>" -- <paramstoparse>`

where:
* `<optstring>` define the `-` options. Example: `"vh"` parse `-v` and `-h` options.
* `<longoptstring>` define the `--` long options. Example: `"version,help"` parse `--version` and `--help` options.
* `<paramstoparse>` are the parameters to parse with getopt. **Notice:** that there is a double dash `--` before it, and that the parameters are not passed as a string, but as command parameters.
* Options with arguments
    * To specify that an option, short or long, requires an argument, add `:` after the option string. Example: `-o "a:" -l "opta:"` will parse `-a` or `--opta` requiring an argument.
    * To specify that an option, short or long, has an optional argument, add `::` after the option string. Example: `-o "a::" -l "opta::"` will parse `-a` or `--opta` that may or may not have an argument.
    * (The script has examples and more comments on this)


## See links below for more information

* Unix/POSIX Utility Conventions:
https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap12.html

* GNU Program Argument Syntax Conventions:
https://www.gnu.org/software/libc/manual/html_node/Argument-Syntax.html

* This example is greatly inspired by: https://www.shellscript.sh/tips/getopt
