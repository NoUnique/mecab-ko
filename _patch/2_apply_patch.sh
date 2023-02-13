#!/bin/bash

DIR_ROOT=../
DIR_SOURCE=mecab
DIR_TARGET=mecab-ko/mecab-ko
SOURCE_BASE_COMMIT_ID=415f47d6119c4387a83e9f942e4ea2d47acf5bdc
SOURCE_LAST_COMMIT_ID=master
TARGET_BASE_COMMIT_ID=5a169db0e00ce973cada1353d93b76bc8655b346
TARGET_LAST_COMMIT_ID=master


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

function fn_checkout() {
    local DIR=$1
    local COMMIT_ID=$2

    PREVIOUS_DIR=$(pwd)
    cd ${DIR}

    git fetch
    git pull
    git checkout ${COMMIT_ID}
    git submodule update --init --recursive

    cd -
}

function fn_patch() {
    local DIR=$1
    local PATCH=$2
    local LEVEL=$3

    PATCH=$(realpath ${PATCH})
    cd ${DIR}

    patch -p${LEVEL} -i ${PATCH} --force

    cd -
}

function fn_fix_version() {
    local DIR=$1
    WRONG_VERSION_FILE="swig/version.h"
    CORRECT_VERSION_FILE="configure"

    cd ${DIR}

    WRONG_VERSION=$(grep "VERSION" ${WRONG_VERSION_FILE} | cut -d ' ' -f6 | sed 's/\"//g')
    CORRECT_VERSION=$(grep "^\sVERSION" ${CORRECT_VERSION_FILE}| cut -d '=' -f2)

    sed -i "s/${WRONG_VERSION//\//\\\/}/${CORRECT_VERSION//\//\\\/}/g" ${WRONG_VERSION_FILE}

    cd -
}

function fn_main() {
    fn_init
    fn_copy ${DIR_SOURCE}/mecab ${DIR_ROOT}/
    fn_patch ${DIR_ROOT}/mecab ./diff.cross.patch 2
    fn_patch ${DIR_ROOT}/mecab ./diff.source.patch 1
    fn_checkout ${DIR_TARGET} ${TARGET_LAST_COMMIT_ID}
    fn_fix_version ${DIR_ROOT}/mecab
}

fn_main
