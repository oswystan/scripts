#!/usr/bin/env bash
###########################################################################
##                     Copyright (C) 2019 wystan
##
##       filename: checker.sh
##    description:
##        created: 2019-03-19 18:43:10
##         author: wystan
##
###########################################################################

##prerequisite: ssh-copy-id xx@x.x.x.x

declare -a app_servers=(
    "1.1.1.1"
    "2.1.1.1"
);

declare -a app_cmds=(
    "netstat -ant|grep 9980"
);

function check_status() {
    declare -a servers=("${!1}")
    declare -a cmds=("${!2}")
    for srv in "${servers[@]}"
    do
        echo "*************************${srv}**************************"
        for cmd in "${cmds[@]}"
        do
            ssh $srv "$cmd || echo '>> ERROR!! <<'"
            echo "---------"
        done
        echo ""
    done
}

###########################################################################
check_status app_servers[@] app_cmds[@]




