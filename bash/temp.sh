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
    echo "###########################################"
    echo "## $1"
    echo "###########################################"
}

function _end() {
    if [ $1 -eq 0 ]; then
        echo "################ SUCCESS ##################"
    else
        echo "################ FAILED ###################"
    fi
}

function do_sth() {
    _start "start downloading" && \
        mkdir dir1 && cd dir2 && \
    _end 0 || _end 1
}

###########################################################################
do_sth
