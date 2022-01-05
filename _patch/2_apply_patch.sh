#!/bin/bash

DIR_SOURCE=mecab
DIR_TARGET=../
PATCH=./diff.patch

function fn_init() {
    # set working directory
    SCRIPT_DIR="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
    cd ${SCRIPT_DIR}
}

function fn_copy() {
    local SOURCE=$1
    local TARGET=$2

    cp -rf ${SOURCE} ${TARGET}
}

function fn_patch() {
    local TARGET=$1
    local PATCH=$2
    local LEVEL=$3

    PATCH=$(realpath ${PATCH})
    cd ${TARGET}
    patch -p${LEVEL} < ${PATCH}
    cd -
}

function fn_main() {
    fn_init
    fn_copy ${DIR_SOURCE}/mecab ${DIR_TARGET}/
    fn_patch ${DIR_TARGET}/mecab ${PATCH} 2
}

fn_main
