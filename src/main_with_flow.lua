-- main entry file that uses flow module interface directly to make update a gamestate FSM

-- must require at main top, to be used in any required modules from here
require("engine/pico8/api")

-- register console log stream to output logs to the console
local logging = require("engine/debug/logging")
logging.logger:register_stream(logging.console_log_stream)

local flow = require("engine/application/flow")
local input = require("engine/input/input")

local main_menu = require("menu/main_menu")
local debug_demo = require("demos/debug_demo")
local input_demo = require("demos/input_demo")

function _init()
  flow:add_gamestate(main_menu())
  flow:add_gamestate(debug_demo())
  flow:add_gamestate(input_demo())
  flow:query_gamestate_type(main_menu.type)
end

function _update60()
  input:process_players_inputs()
  flow:update()
end

function _draw()
  flow:render()
end
