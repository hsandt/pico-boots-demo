#!/bin/bash
# Build game.p8 file from the main source file
# Requirements:
# - main source file must be at src/main.lua
# - other game source files must be in src/ and required via relative path from src/
# - engine must be cloned in pico-boots and engine source files must be required via relative path from pico-boots/src


MAIN_FILEPATH="src/main.lua"
LUA_PATH="$(pwd)/src/?.lua;$(pwd)/pico-boots/src/?.lua"
OUTPUT_FILEPATH="build/game.p8"

echo "Building '$MAIN_FILEPATH' -> '$OUTPUT_FILEPATH'"

# clean up any existing output file
rm -f "$OUTPUT_FILEPATH"

echo ""
echo "Pre-build..."

# Copy metadata.p8 to future output file path. When generating the .p8, p8tool will preserve the __label__ present
# at the output file path, so this is effectively a way to setup the label.
# However, title and author are lost during the process and must be manually added to the header with add_metadata.py
mkdir -p build

if [[ -f data/metadata.p8 ]]; then
	CP_LABEL_CMD="cp data/metadata.p8 \"$OUTPUT_FILEPATH\""
	echo "> $CP_LABEL_CMD"
	bash -c "$CP_LABEL_CMD"
fi


if [[ $? -ne 0 ]]; then
    echo "Pre-build step failed, STOP."
    exit 1
fi

echo ""
echo "Build..."

# Build the game from the main script
BUILD_CMD="p8tool build --lua \"$MAIN_FILEPATH\" --lua-path=\"$LUA_PATH\" 						   \
  --gfx data/data.p8 --gff data/data.p8 --map data/data.p8 --sfx data/data.p8 --music data/data.p8 \
  \"$OUTPUT_FILEPATH\""
echo "> $BUILD_CMD"
bash -c "$BUILD_CMD"

if [[ $? -ne 0 ]]; then
    echo "Build step failed, STOP."
    exit 1
fi

echo ""
echo "Post-build..."

# Add metadata to cartridge
# Since label has been setup during Prebuild, we don't need to add it with add_metadata.py anymore
# Thefore, for the `label_filepath` argument just pass the none value "-"
ADD_HEADER_CMD="postbuild/add_metadata.py \"$OUTPUT_FILEPATH\" \"-\" \"pico-boots demo\" \"hsandt\""
echo "> $ADD_HEADER_CMD"
bash -c "$ADD_HEADER_CMD"

if [[ $? -ne 0 ]]; then
	echo "Add metadata failed, STOP."
	exit 1
fi

echo ""
echo "Build succeeded: $OUTPUT_FILEPATH"
exit 0
