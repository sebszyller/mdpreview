#!/bin/bash

function find_md {
    passed=$1
    
    if [[ -d $passed ]]; then
        mds=($(ls ${passed} | grep ".md$"))
        len=${#mds[@]}

        if [[ $len -eq 0 ]]; then
            echo "No md files found. Aborting."
        elif [[ $len -eq 1 ]]; then
            preview $(readlink -f $passed/${mds[0]})
        else
            echo "Found more than one md file. Going with the first one: ${mds[0]}"
            preview $(readlink -f $passed/${mds[0]})
        fi
    else
        abs_path=$(readlink -f ${passed})
        ext="${abs_path#*.}"

        if [[ "$ext" == "md" ]]; then
            preview $abs_path
        else
            echo "${passed} is not a md file. Aborting."
        fi
    fi
}

function preview {
    passed=$(readlink -f ${1})
    cd $(dirname $passed)

    stem="${passed%%.*}"
    output="${stem}_temp_preview.pdf"
    
    $(pandoc $passed -o $output)
    $(xdg-open $output)
    $(rm $output)
}

if [ "$#" -eq 0 ]; then
    find_md .
elif [ "$#" -eq 1 ]; then
    find_md $1
else
    echo "Too many arguments."
fi
