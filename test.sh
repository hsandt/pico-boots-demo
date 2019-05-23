#!/bin/bash
# Test all test files found in source

echo "Testing all..."

# Clean previous coverage
CLEAN_COVERAGE_CMD="rm -f luacov.stats.out luacov.report.out"

# Run all unit tests
LUA_PATH="src/?.lua;pico-boots/src/?.lua"
CORE_TEST_CMD="busted src --lpath=\"$LUA_PATH\" -p \"test_\" -c -v"

# Generate luacov report and display all uncovered lines (starting with *0) and coverage percentages
COVERAGE_OPTIONS="-c .luacov_all"
COVERAGE_CMD="luacov $COVERAGE_OPTIONS && echo $'\n\n= COVERAGE REPORT =\n' && grep -C 3 -P \"(?:(?:^|[ *])\*0|\d+%)\" luacov.report.out"

FULL_TEST_CMD="$CLEAN_COVERAGE_CMD && $CORE_TEST_CMD && $COVERAGE_CMD"

echo "> $FULL_TEST_CMD"
bash -c "$FULL_TEST_CMD"
