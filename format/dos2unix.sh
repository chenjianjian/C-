#!/bin/bash

function scandir()
{
    local cur_dir workdir
    workdir=$1
    cd ${workdir}
    if [ ${workdir} = "/" ];then
        cur_dir=""
    else
        cur_dir=$(pwd)
    fi

    for dirlist in $(ls ${cur_dir})
    do
        if test -d ${dirlist};then
            cd ${dirlist}
            scandir ${cur_dir}/${dirlist}
            cd ..
        else
            echo ${dirlist}
            sed 's/\t/    /g' ${dirlist} > tmp.txt
            dos2unix -n tmp.txt ${dirlist}
            rm tmp.txt
        fi
    done
}

if test -d $1;then
    scandir $1
    sync
elif test -f $1;then
    echo "you input a file but not a directory,pls reinput and try again"
    exit 1
else
    echo "the Directory isn't exist which you input,pls input a new one"
    exit 1
fi


