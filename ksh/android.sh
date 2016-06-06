#!/bin/ksh
######################################################################################
##                                                                                  ##
##                               android utils                                      ##
##                                                                                  ##
######################################################################################


function bk() {
    count=1
    if [ $# -gt 0 ]; then
        count=$1
    fi

    while [ $count -gt 0 ]
    do
        adb shell input keyevent 4
        count=`expr $count - 1`
    done
}
