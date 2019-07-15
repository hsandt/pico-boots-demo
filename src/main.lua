require("engine/pico8/api")

local flow = require("engine/application/flow")
local input = require("engine/input/input")

local main_menu = require("menu/main_menu")
local input_demo = require("demos/input_demo")

local i = 0

function _init()
  flow:add_gamestate(main_menu())
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
