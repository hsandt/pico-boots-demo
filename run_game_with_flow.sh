#!/bin/bash

# Run game.p8 with PICO-8 executable
# Pass any extra arguments to pico8
pico8 -run build/picoboots_demo_with_flow.p8 -screenshot_scale 4 -gif_scale 4 $@
