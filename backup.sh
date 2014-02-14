#!/bin/bash

BASEPATH=$(cd `dirname $0`; pwd)

function useage {
    echo "VPS Baskup Shell v0.1.1"
    echo "funcman(hyq1986@gmail.com)"
    echo ""
    echo "Usage: ./backup.sh -D full_path [-f package_name] [-d retention]"
    echo "  -------- options --------"
    echo "  -D      Specifies the directory for backup, must be full path."
    echo "  -f      Name of the backup package."
    echo "  -d      Retention period of the backup package."
}

function day {
    if [ $# -eq 1 ]
    then
        date -d "$1day ago" +%Y%m%d
    else
        date +%Y%m%d
    fi
}

function check {
    [ $# -lt 1 ] && return 0
    [[ $1 =~ ^[1-9][0-9]*$ ]] && return 1
    return 0
}

function upload {
    local filename
    [ $# -eq 1 ] && filename=`day`.`basename $1`.7z
    [ $# -eq 2 ] && filename=`day`.$2.7z
    7z a $filename $1 > /dev/null
    $BASEPATH/dropbox_uploader.sh upload /tmp/backup`day`/$filename .
}

function delete {
    local halfname
    [ $# -eq 2 ] && halfname=.`basename $2`.7z
    [ $# -eq 3 ] && halfname=.$3.7z
    $BASEPATH/dropbox_uploader.sh list | awk "\$3 ~ \"$halfname\" {print \$3}" > files1.txt
    for((i=0;i<$1;++i)); do echo "`day $i`$halfname" >> files2.txt; done
    grep -Fvxf <(grep -Fxf files1.txt files2.txt ) files1.txt files2.txt | awk -F ':' '$1=="files1.txt" {print $2}' > timeout_files.txt
    for file in `cat timeout_files.txt`; do $BASEPATH/dropbox_uploader.sh delete $file; done 
}

while getopts "D:d:f:" opt
do
    case $opt in
        D) DIR=$OPTARG;;
        d) check $OPTARG; [ $? -eq 1 ] && day=$OPTARG;;
        f) filename=$OPTARG;;
        ?) useage; exit 1;;
    esac
done

TEMPPATH=/tmp/backup`day`
[ -d $TEMPPATH ] && rm -rf $TEMPPATH
mkdir -p $TEMPPATH
cd $TEMPPATH
[[ -n $DIR ]] && [ -d $DIR ] && upload $DIR $filename && [[ -n $day ]] && delete $day $DIR $filename
cd $PWD
rm -rf $TEMPPATH

