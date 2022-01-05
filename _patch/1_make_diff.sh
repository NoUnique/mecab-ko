#!/bin/bash

DIR_SOURCE=mecab/mecab/src
DIR_TARGET=mecab-ko/mecab-ko/src
PATH_OUTPUT=./diff.raw

function fn_init() {
    # set working directory
    SCRIPT_DIR="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
    cd ${SCRIPT_DIR}
}

function fn_diff() {
    local SOURCE=$1
    local TARGET=$2
    local OUTPUT=$3

    diff -wur --color ${SOURCE} ${TARGET} >> ${OUTPUT}
}

function fn_main() {
    fn_init
    fn_diff ${DIR_SOURCE} ${DIR_TARGET} ${PATH_OUTPUT}
}

fn_main
