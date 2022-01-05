#!/bin/bash

DIR_SOURCE=mecab/mecab
DIR_TARGET=mecab-ko/mecab-ko
DIR_EXCEPT='*.html'
PATH_OUTPUT=./diff.raw

function fn_init() {
    # set working directory
    SCRIPT_DIR="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
    cd ${SCRIPT_DIR}
}

function fn_diff() {
    local SOURCE=$1
    local TARGET=$2
    local EXCEPT=$3
    local OUTPUT=$4

    diff -x ${EXCEPT} -wur --color ${SOURCE} ${TARGET} > ${OUTPUT}
}

function fn_main() {
    set -o xtrace
    fn_init
    fn_diff ${DIR_SOURCE} ${DIR_TARGET} ${DIR_EXCEPT} ${PATH_OUTPUT}
    set +o xtrace
}

fn_main
