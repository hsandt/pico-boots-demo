# Pico-Boots Demo

This project demonstrates the features of the [Pico-Boots framework for PICO-8](https://github.com/hsandt/pico-boots).

## Build

### Supported platforms

Only Linux Ubuntu (and supposedly the Debian family) is fully supported to build the game from sources. Other Linux distributions and UNIX platforms should be able to run most scripts, providing the right tools are installed, but a few references like `gnome-terminal` in `run.sh` would require adaptation.

Development environments for Windows such as MinGW and Cygwin have not been tested.

### Build dependencies

#### Python 3.6

Prebuild and postbuild scripts are written in Python 3 and use 3.6 features such as formatted strings.

#### picotool

A build pipeline for PICO-8 ([GitHub](https://github.com/dansanderson/picotool))

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

### Run unit tests and headless integration tests

To run all the unit tests:

* `cd path/to/pico-boots-demo`
* `./test.sh`

The test script (test.sh) only works on Linux (it uses gnome-terminal).
