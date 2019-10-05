#!/bin/bash

# Run itest with PICO-8 executable (itests only work in debug config)
# Pass any extra arguments to pico8
pico8 -run build/picoboots_demo_itest_all_debug.p8 -screenshot_scale 4 -gif_scale 4 $@
