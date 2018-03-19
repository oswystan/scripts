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
git_version() {
    if [[ $# == 1 && $1 == "-s" ]]; then
        ver="$(git rev-parse --abbrev-ref HEAD)-$(git rev-parse --short HEAD)"
    else
        ver="$(git rev-parse --abbrev-ref HEAD)-$(git rev-parse HEAD)"
    fi
    echo $ver
}

###########################################################################
git_version -s
