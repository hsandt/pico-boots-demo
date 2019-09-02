#!/bin/bash

# Build game with picotool

# Configuration: paths
game_src_path="$(dirname "$0")/src"
data_path="$(dirname "$0")/data"
build_output_path="$(dirname "$0")/build"
picoboots_scripts_path="$(dirname "$0")/pico-boots/scripts"

# Configuration: cartridge
author="hsandt"
title="pico-boots demo with flow"
cartridge_name="picoboots_demo_with_flow"

# Build
"$picoboots_scripts_path/build_game.sh"                               \
  "$game_src_path" main_with_flow.lua                                 \
  -d "$data_path/data.p8" -m "$data_path/metadata.p8"                 \
  -a "$author" -t "$title"                                            \
  -o "$build_output_path/$cartridge_name.p8"                          \
  --minify
