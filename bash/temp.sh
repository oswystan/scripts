#!/usr/bin/env bash
###########################################################################
##                     Copyright (C) 2017 wystan
##
##       filename: temp.sh
##    description:
##        created: 2017-10-18 23:10:36
##         author: wystan
##
###########################################################################

function _start() {
    echo "==> start $1"
    echo "-------------------------------------------"
}

function _end() {
    if [ $1 -eq 0 ]; then
        echo "---------------- SUCCESS ------------------"
    else
        echo "**************** FAILED *******************"
        exit $1
    fi
}

function do_sth() {
    _start "downloading ..."
        mkdir dir1 && cd dir1
    [ $? -eq 0 ] && _end 0 || _end 1
}

function do_th() {
    _start "compiling ..."
        mkdir dir2 && cd dir2
    [ $? -eq 0 ] && _end 0 || _end 1
}

###########################################################################
do_sth
do_th
