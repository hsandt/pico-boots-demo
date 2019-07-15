# pico-boots demo

This project demonstrates the features of the [pico-boots framework for PICO-8](https://github.com/hsandt/pico-boots).

You can both try the demos directly by running the game (see "Build and run" section) and read the corresponding source code.

## Demos

* `main.lua` shows how to use the Flow system with gamestates. There is no specific demo for it, the whole app uses it, with 1 state for the main menu and 1 state per demo.
* `main_menu.lua` shows how to make a simple menu using the UI and Input modules. You will see the main menu when starting the app.
* `input_demo.lua` shows how to detect player input. In the main menu, select "INPUT DEMO", then press the different buttons (arrows and X/O in PICO-8) to see the input states change.

## Build

### Supported platforms

The build and test pipeline has been tested on Linux Ubuntu. Other Linux distributions and UNIX platforms should be able to run most scripts, providing the right tools are installed.

Development environments for Windows such as MinGW and Cygwin have not been tested.

### Build dependencies

#### Python 3.6

Prebuild and postbuild scripts are written in Python 3 and use 3.6 features such as formatted strings.

#### picotool

A build pipeline for PICO-8 ([GitHub](https://github.com/dansanderson/picotool)).

You must add `p8tool` to your `PATH`.

### Build and run

First, make sure the `pico8` executable is in your path.

The most straightforward way to build and run the game on Unix platforms is:

* `cd path/to/pico-boots-demo`
* `./build.sh`
* `./run.sh`

### Test dependencies

#### Lua 5.3

Tests run under Lua 5.3, although Lua 5.2 should also have the needed features (in particular the bit32 module).

#### busted

A Lua unit test framework ([GitHub](https://github.com/Olivine-Labs/busted))

`busted` must be in your path.

### Run unit tests and headless integration tests

To run all the (non-#mute) unit tests:

* `cd path/to/pico-boots-demo`
* `./test.sh`

## Coding conventions

Strings that are used as keys and are never shown to the user are written as `':key'` to imitate Ruby's symbol notation.
