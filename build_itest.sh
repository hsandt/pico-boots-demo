#!/bin/bash

# Build a PICO-8 cartridge for the integration tests.
# This is essentially a proxy script for pico-boots/scripts/build_game.sh with the right parameters.

# Extra options are passed to build_cartridge.sh (with $@).
# This is useful in particular for --symbols.

# Configuration: paths
picoboots_scripts_path="$(dirname "$0")/pico-boots/scripts"
game_src_path="$(dirname "$0")/src"
data_path="$(dirname "$0")/data"
build_output_path="$(dirname "$0")/build"

# Configuration: cartridge
author="hsandt"
title="pico-boots demo itests (all)"
cartridge_name="picoboots_demo_itest_all"
symbols='assert,log,visual_logger,tuner,profiler'

# Build from itest main for all itests
"$picoboots_scripts_path/build_game.sh"               \
  "$game_src_path" itest_main.lua itests              \
  -d "$data_path/data.p8" -M "$data_path/metadata.p8" \
  -a "$author" -t "$title"                            \
  -o "$build_output_path/$cartridge_name.p8"          \
  -s "$symbols"                                       \
  --minify
