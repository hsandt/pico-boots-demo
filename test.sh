#!/bin/bash

# Test all test files found in source

# Configuration
ENGINE_SRC="pico-boots/src"

help() {
  echo "Usage: test.sh [FILE_BASE_NAME] [-p PROJECT]

ARGUMENTS
    FILE_BASE_NAME          basename of either the module to test or the test itself.
                            If FILE_BASE_NAME starts with 'utest_', it is stripped
                            to define MODULE. Else, it is directly assigned to MODULE.
                            A test file named 'utest_${MODULE}.lua' should exist.
                            If empty, all test files found in the target
                            project(s) are tested.
                            (optional, default: '')

OPTIONS
    -p, --project PROJECT   PROJECT must be 'engine', 'game' or 'all'.
                            Only test files found in the corresponding
                            directory(-ies) are tested.
                            (optional, default: 'all')
"
}

# Default parameters
MODULE=""
PROJECT="all"

# https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash

POSITIONAL=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -p | --project )
      if [[ $# -lt 2 ]] ; then
        echo "Missing argument for $1"
        help
        exit 1
      fi
      PROJECT="$2"
      shift # past argument
      shift # past value
      ;;
    -* )    # unknown option
      echo "Unknown option: '$1'"
      help
      exit 1
      ;;
    * )     # positional argument
      POSITIONAL+=("$1") # save it in an array for later
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL[@]}" # restore positional parameters

# Check positional arguments
if [[ $# -gt 1 ]] ; then
  echo "Too many arguments"
  help
  exit 1
fi

if [[ $# -gt 0 ]] ; then
  # if file basename designates a utest, already,
  # extract the name of the tested module
  if [[ ${1::6} = "utest_" ]] ; then
    MODULE=${1:6}
  else
    MODULE=$1
  fi
  shift
fi

if [[ -z $MODULE ]] ; then
  # no specific file to test, test them all (inside target project directories)
  TEST_FILE_PATTERN="utest_"
  MODULE_STR="all modules"
else
  # test specific module with exact full name to avoid issues with similar file names (busted uses Lua string.match where escaping is done with '%'')
  TEST_FILE_PATTERN="^utest_${MODULE}%.lua$"
  echo "P: $TEST_FILE_PATTERN"
  MODULE_STR="module $MODULE"
fi

# Define directories to test based on PROJECT
ROOTS=""
COVERAGE_DIRS=""

if [[ $PROJECT = "engine" || $PROJECT = "all" ]] ; then
  ROOTS+="$ENGINE_SRC"
  COVERAGE_DIRS+="^$ENGINE_SRC/"
fi

if [[ $PROJECT = "game" || $PROJECT = "all" ]] ; then
  ROOTS+=" src"
  COVERAGE_DIRS+=" ^src/"  # match path from start to distinguish from $ENGINE_SRC/
fi

# Just for better log message
if [[ $PROJECT = "all" ]] ; then
  PROJECT_STR="all projects"
else
  PROJECT_STR="project '$PROJECT'"
fi

echo "Testing $MODULE_STR in $PROJECT_STR..."

# Clean previous coverage
CLEAN_COVERAGE_CMD="rm -f luacov.stats.out luacov.report.out"
echo "> $CLEAN_COVERAGE_CMD"
bash -c "$CLEAN_COVERAGE_CMD"

# Run all unit tests
LUA_PATH="src/?.lua;$ENGINE_SRC/?.lua"
CORE_TEST_CMD="busted $ROOTS --lpath=\"$LUA_PATH\" -p \"$TEST_FILE_PATTERN\" -c -v"

# Generate luacov report and display all uncovered lines (starting with *0) and coverage percentages
COVERAGE_OPTIONS="-c .luacov $COVERAGE_DIRS"
COVERAGE_CMD="luacov $COVERAGE_OPTIONS && echo $'\n\n= COVERAGE REPORT =\n' && grep -C 3 -P \"(?:(?:^|[ *])\*0|\d+%)\" luacov.report.out"

TEST_WITH_COVERAGE_CMD="$CORE_TEST_CMD && $COVERAGE_CMD"
echo "> $TEST_WITH_COVERAGE_CMD"
bash -c "$TEST_WITH_COVERAGE_CMD"
