#!/usr/bin/env bash

## we can use the internal var $FUNCNAME
## to get the current function name
function my_func() {
    echo "$FUNCNAME"
}
my_func

