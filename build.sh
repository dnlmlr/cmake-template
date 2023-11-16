#!/bin/bash

export CMAKE_GENERATOR="Unix Makefiles"
RELEASE_DIR="build/release"
DEBUG_DIR="build/debug"

function need_cmake() {
    local CHANGETIME_FILE="$1/.cmake-changetime"

    local CURRENT_CMAKE_TIME=$(stat -c %Y CMakeLists.txt)
    local LAST_CMAKE_TIME=0

    if [ -f "$CHANGETIME_FILE" ]; then
        LAST_CMAKE_TIME=$(cat "$CHANGETIME_FILE")
    fi

    if [ $CURRENT_CMAKE_TIME = $LAST_CMAKE_TIME ]; then
        return 1
    else
        return 0
    fi
}

function update_cmake_time() {
    stat -c %Y CMakeLists.txt >> "$1/.cmake-changetime"
}

case "$1" in
release|r)
    need_cmake $RELEASE_DIR \
        && cmake -B $RELEASE_DIR -DCMAKE_BUILD_TYPE=Release \
        && update_cmake_time $RELEASE_DIR
    make -C $RELEASE_DIR
    ;;

debug|d)
    need_cmake $DEBUG_DIR \
        && cmake -B $DEBUG_DIR -DCMAKE_BUILD_TYPE=Debug \
        && update_cmake_time $DEBUG_DIR
    make -C $DEBUG_DIR
    ;;
esac
