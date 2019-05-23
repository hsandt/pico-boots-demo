#!/bin/bash

# Test all test files found in source

help() {
  echo "Usage: test.sh [PROJECT]

    PROJECT   'engine', 'game' or 'all' to test the corresponding modules"
}

# Check arguments
if [[ $# -lt 1 ]] ; then
	help
    exit 1
fi

PROJECT=$1
shift

# Configuration
LUA_PATH="src/?.lua;pico-boots/src/?.lua"

# Define directories to test based on PROJECT
ROOTS=""
COVERAGE_DIRS=""
if [[ $PROJECT = "engine" || $PROJECT = "all" ]] ; then
  ROOTS+="pico-boots/src"
  COVERAGE_DIRS+="^pico-boots/src/"
fi
if [[ $PROJECT = "game" || $PROJECT = "all" ]] ; then
  ROOTS+=" src"
  COVERAGE_DIRS+=" ^src/"  # match path from start to distinguish from pico-boots/src/
fi

echo "Testing $PROJECT..."

# Clean previous coverage
CLEAN_COVERAGE_CMD="rm -f luacov.stats.out luacov.report.out"
echo "> $CLEAN_COVERAGE_CMD"
bash -c "$CLEAN_COVERAGE_CMD"

# Run all unit tests
CORE_TEST_CMD="busted $ROOTS --lpath=\"$LUA_PATH\" -p \"test\" -c -v"

# Generate luacov report and display all uncovered lines (starting with *0) and coverage percentages
COVERAGE_OPTIONS="-c .luacov $COVERAGE_DIRS"
COVERAGE_CMD="luacov $COVERAGE_OPTIONS && echo $'\n\n= COVERAGE REPORT =\n' && grep -C 3 -P \"(?:(?:^|[ *])\*0|\d+%)\" luacov.report.out"

TEST_WITH_COVERAGE_CMD="$CORE_TEST_CMD && $COVERAGE_CMD"

echo "> $TEST_WITH_COVERAGE_CMD"
bash -c "$TEST_WITH_COVERAGE_CMD"
