#!/usr/bin/env bash
###########################################################################
##                     Copyright (C) 2017 wystan
##
##       filename: utils.sh
##    description:
##        created: 2017-08-19 21:07:45
##         author: wystan
##
###########################################################################
function git_version() {
    if [[ $# == 1 && $1 == "-s" ]]; then
        ver="$(git branch|grep '*'|cut -d' ' -f2)-$(git rev-parse --short HEAD)"
    else
        ver="$(git branch|grep '*'|cut -d' ' -f2)-$(git rev-parse HEAD)"
    fi
    echo $ver
}

###########################################################################
git_version -s
