#!/bin/bash

PWD=`pwd`

function useage {
    echo ""
}

function day {
    if [ $# -eq 1 ]
    then
        date "$1 days" +%Y%m%d
    else
        date +%Y%m%d
    fi
}

function check {
    if [ $# -lt 1 ]
    then
        return 0
    fi 
    if [[ $1 =~ ^[1-9][0-9]*$ ]]
    then
        return 1
    fi 
    return 0
}

function upload {
    mkdir -p /tmp/backup`day`
    cd /tmp/backup`day`
    local filename
    if [ $# -eq 1 ]
    then
        filename=`day`.`basename $1`.7z
    elif [ $# -eq 2 ]
    then
        filename=`day`.$2.7z
    fi
    7z a $filename $1
    cd $PWD
    ./dropbox_uploader.sh upload /tmp/backup`day`/$filename .
    rm -rf /tmp/backup`day`
}

function delete {
}

DIR=
day=
filename=

while getopts "D:d:f:" opt
do
    case $opt in
        D) DIR=$OPTARG;;
        d) check $OPTARG; [ $? -eq 1 ] && day=$OPTARG;;
        f) filename=$OPTARG;;
        ?) useage; exit 1;;
    esac
done

[   -d $DIR ] && upload $DIR $filename
[ ! -n $day ] && delete $day $DIR $filename
