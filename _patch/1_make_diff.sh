#!/bin/bash

DIR_SOURCE=mecab/mecab
DIR_TARGET=mecab-ko/mecab-ko
DIR_EXCEPT='*.html'
SOURCE_BASE_COMMIT_ID=415f47d6119c4387a83e9f942e4ea2d47acf5bdc
SOURCE_LAST_COMMIT_ID=master
TARGET_BASE_COMMIT_ID=5a169db0e00ce973cada1353d93b76bc8655b346
TARGET_LAST_COMMIT_ID=master


function fn_init() {
    # set working directory
    SCRIPT_DIR="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
    cd ${SCRIPT_DIR}
}

function fn_checkout() {
    local DIR=$1
    local COMMIT_ID=$2

    cd ${DIR}

    git fetch
    git pull
    git checkout ${COMMIT_ID}
    git submodule update --init --recursive

    cd -
}

function fn_self_diff() {
    local DIR=$1
    local BASE_COMMIT_ID=$2
    local LAST_COMMIT_ID=$3
    local OUTPUT=$4

    PREVIOUS_DIR=$(pwd)
    cd ${DIR}

    git diff -wu --relative ${BASE_COMMIT_ID} ${LAST_COMMIT_ID} . > ${PREVIOUS_DIR}/${OUTPUT}

    cd -
}

function fn_cross_diff() {
    local SOURCE=$1
    local TARGET=$2
    local EXCEPT=$3
    local OUTPUT=$4

    diff -x ${EXCEPT} -wur ${SOURCE} ${TARGET} > ${OUTPUT}
}

function fn_main() {
    set -o xtrace
    fn_init
    fn_checkout ${DIR_SOURCE} ${SOURCE_LAST_COMMIT_ID}
    fn_checkout ${DIR_TARGET} ${TARGET_LAST_COMMIT_ID}
    fn_self_diff ${DIR_SOURCE} ${SOURCE_BASE_COMMIT_ID} ${SOURCE_LAST_COMMIT_ID} ./diff.source.patch
    fn_self_diff ${DIR_TARGET} ${TARGET_BASE_COMMIT_ID} ${TARGET_LAST_COMMIT_ID} ./diff.target.patch
    fn_checkout ${DIR_SOURCE} ${SOURCE_BASE_COMMIT_ID}
    fn_cross_diff ${DIR_SOURCE} ${DIR_TARGET} ${DIR_EXCEPT} ./diff.cross.patch
    set +o xtrace
}

fn_main
