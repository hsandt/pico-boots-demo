#!/bin/bash
# Run game.p8 with PICO-8 executable
pico8 -run build/game.p8 -screenshot_scale 4 -gif_scale 4 $@
