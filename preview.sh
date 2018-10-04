#!/bin/bash

function getlink {
    # use readlink -f if available
    echo $(greadlink -f $1)
}

function openpdf {
    # use xdg-open if available
    $(open --wait-apps $1)
}

function find_md {
    passed=$1
    
    if [[ -d $passed ]]; then
        mds=($(ls ${passed} | grep ".md$"))
        len=${#mds[@]}

        if [[ $len -eq 0 ]]; then
            echo "No md files found. Aborting."
        elif [[ $len -eq 1 ]]; then
            preview $(getlink $passed/${mds[0]})
        else
            echo "Found more than one md file. Going with the first one: ${mds[0]}"
            preview $(getlink $passed/${mds[0]})
        fi
    else
        abs_path=$(getlink ${passed})
        ext="${abs_path#*.}"

        if [[ "$ext" == "md" ]]; then
            preview $abs_path
        else
            echo "${passed} is not a md file. Aborting."
        fi
    fi
}

function preview {
    passed=$(getlink ${1})
    cd $(dirname $passed)
    stem="${passed%%.*}"
    output="${stem}_temp_preview.pdf"

    $(pandoc $passed -o $output)
    $(openpdf $output)
    $(rm $output)
}

if [ "$#" -eq 0 ]; then
    find_md .
elif [ "$#" -eq 1 ]; then
    find_md $1
else
    echo "Too many arguments."
fi
