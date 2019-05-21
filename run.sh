#!/bin/bash
# Run game.p8 with PICO-8 executable, showing terminal for debug
gnome-terminal -- bash -x -c "pico8 -run build/game.p8 -gif_scale 4 $@"
