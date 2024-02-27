#!/bin/sh


_kill_recurse() {
    cpids=`pgrep -P $1|xargs`
    for cpid in $cpids;
    do
        _kill_recurse $cpid
    done
    kill -9 $1 > /dev/null
}


_term() {
    if [[ $1 != '' ]]; then
        if ps -p $1 > /dev/null; then
            _kill_recurse $1
        fi
    fi
}


function _help {
    b="\033[1m"
    n="\033[0m"

    echo -e "${b}USAGE:${n}"
    echo    "  $(basename $0) [options] <command> <file1> [<file2> ... <fileN>]"
    echo    ""
    echo -e "${b}OPTIONS:${n}"
    echo -e "  ${b}-c${n}\tClear terminal screen before reload <command>."
    echo -e "  ${b}-v${n}\tVerbose reloading."
    echo -e "  ${b}-h${n}\tShow help and exit."
    echo    ""
    echo -e "${b}EXAMPLES:${n}"
    echo    "  Reload program when main.py is updated:"
    echo    ""
    echo -e "    ${b}\$${n} $(basename $0) \"python main.py\" main.py"
    echo    ""
    echo    "  Reload program when main.py or lib.py is updated:"
    echo    ""
    echo -e "    ${b}\$${n} $(basename $0) \"python main.py\" main.py lib.py"
    echo    ""
    echo    "  Reload web server when any .py files in project is added or modified:"
    echo    ""
    echo -e "    ${b}\$${n} $(basename $0) \"python server.py\" \$(find . -name \"*.py\")"
    echo    ""
    echo    "  or with config file"
    echo    ""
    echo -e "    ${b}\$${n} $(basename $0) \"python server.py\" \$(find . -name \"*.py\") config.yml"
    echo    ""
}


main() {
    clear_screen=false
    verbose=false

    OPTIND=1
    while getopts "cvh" option
    do 
        case "${option}"
        in
            c)
              clear_screen=true
              ;;
            v)
              verbose=true
              ;;
            h) 
              _help
              exit 0
              ;;
            \?)
              echo "Unknown option"
              exit 1
              ;;
        esac
    done
    shift $((OPTIND-1))

    if (( $# < 2 )); then
        echo "$(basename $0): not enough arguments, run \"$(basename $0) -h\" for help."
        exit 1
    fi

    script=$1
    shift

    a=''
    pid=''
    quit=false
    trap "_term; quit=true" SIGINT

    while ! $quit; do
        b=`/bin/ls -l --time-style=full-iso $*`
        if [[ $a != $b ]]; then
            _term $pid
            [[ $clear_screen == true ]] && clear
            [[ $verbose == true ]] && [[ $pid != '' ]] && echo "$(basename $0): Reloading..."
            a=$b && { pid=$(eval $script>&3 & echo $!); } 3>&1
        fi
        sleep .5
    done

    exit 0
}

main "$@"
