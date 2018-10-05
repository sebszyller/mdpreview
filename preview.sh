#!/bin/bash

FILE= # file to be previewed

function getlink {
    # use readlink -f if available
    echo $(greadlink -f $1)
}

function openpdf {
    # use xdg-open if available
    $(open --wait-apps $1)
}

function find_md {
    local passed=$1
    
    if [[ -d $passed ]]; then
        local mds=($(ls ${passed} | grep ".md$"))
        local len=${#mds[@]}

        if [[ $len -eq 0 ]]; then
            echo "No md files found. Aborting."
            exit -1 
        elif [[ $len -eq 1 ]]; then
            FILE=$passed/${mds[0]}
        else
            echo "Found more than one md file. Going with the first one: ${mds[0]}"
            FILE=$passed/${mds[0]}
        fi
    else
        local ext=${passed##*.}

        if [[ "$ext" == "md" ]]; then
            FILE=$passed
        else
            echo "${passed} is not a md file. Aborting."
            exit -1
        fi
    fi
}

function preview {
    local passed=$(getlink ${1})
    cd $(dirname $passed)
    local stem=${passed%%.*}
    local output="${stem}_temp_preview.pdf"

    pandoc $passed -o $output
    openpdf $output
    rm $output
}

if [ "$#" -eq 0 ]; then
    find_md .
elif [ "$#" -eq 1 ]; then
    find_md $1
else
    echo "Too many arguments."
    exit -1
fi

preview $FILE

exit 0