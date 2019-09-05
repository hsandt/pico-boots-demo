-- main entry file that uses flow module interface directly to make update a gamestate FSM

-- must require at main top, to be used in any required modules from here
require("engine/pico8/api")

local logging = require("engine/debug/logging")

local flow = require("engine/application/flow")
local input = require("engine/input/input")
local ui = require("engine/ui/ui")

local main_menu = require("menu/main_menu")
local debug_demo = require("demos/debug_demo")
local input_demo = require("demos/input_demo")
local visual = require("resources/visual")

function _init()
  -- register console log stream to output logs to the console
  logging.logger:register_stream(logging.console_log_stream)
  logging.logger:register_stream(logging.file_log_stream)
  logging.file_log_stream.file_prefix = "pico_boots_demo_with_flow"

  -- clear log file on new game session (or to preserve the previous log,
  -- you could add a newline and some "[SESSION START]" tag instead)
  logging.file_log_stream:clear()

  flow:add_gamestate(main_menu())
  flow:add_gamestate(debug_demo())
  flow:add_gamestate(input_demo())
  flow:query_gamestate_type(main_menu.type)

  -- enable mouse devkit
  input:toggle_mouse(true)
  ui:set_cursor_sprite_data(visual.sprites.cursor)
end

function _update60()
  input:process_players_inputs()
  flow:update()
end

function _draw()
  flow:render()
  ui:render_mouse()
end
