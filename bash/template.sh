#!/bin/bash
log_file="log.txt"

################################
# some basic functions for log
################################
ts() {
    echo "$(date '+%Y-%m-%dT%T.%3N%z')"
}

log_start() {
    echo "[I|$(ts)]##########################################################"
    echo "[I|$(ts)] start program  : $0"
    echo "[I|$(ts)]##########################################################"
    echo ""
}

logi() {
    echo "[I|$(ts)]$*"
}

logw() {
    echo "[W|$(ts)]$*"
}

loge() {
    echo "[E|$(ts)]$*"
}

log_end() {
    echo ""
    echo "[I|$(ts)]##########################################################"
    echo "[I|$(ts)] finished $0"
    echo "[I|$(ts)]##########################################################"
}
safe_exec() {
    if [ $# -eq 0 ]; then
        exit 1
    fi

    $*
    if [ $? -ne 0 ]; then
        loge "fail to do [$*]"
        exit 1
    fi
}

do_work() {
    log_start

    log_end
}

################################
## main
################################
mkdir -p `dirname $log_file`

if [ $# -eq 0 ]; then
    do_work >$log_file 2>&1
else
    $*
fi
