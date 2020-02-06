local flow = require("engine/application/flow")
local gamestate = require("engine/application/gamestate")
require("engine/core/class")
local input = require("engine/input/input")
require("engine/render/color")
local ui = require("engine/ui/ui")

-- input demo: gamestate to demonstrate input features
local input_demo = new_class(gamestate)

input_demo.type = ':input_demo'

function input_demo:_init()
end

function input_demo:on_enter()
end

function input_demo:on_exit()
  -- in case mouse was disabled, restore it so you can continue using it in other demos
  input:toggle_mouse(true)
end

function input_demo:update()
  -- no chord system yet, so check holding + press manually
  if input:is_down(button_ids.left) and input:is_just_pressed(button_ids.x) then
    self:_go_back()
  elseif input:is_just_pressed(button_ids.o) then
    input:toggle_mouse()
  end
end

function input_demo:_go_back()
  flow:query_gamestate_type(':main_menu')
end

function input_demo:render()
  cls()

  -- todo: use vertical_layout

  -- print title and instructions
  local y = 6
  ui.print_centered("input demo", 64, y, colors.white)
  y = y + 6
  ui.print_centered("(hold left + x: back to main menu)", 64, y, colors.white)
  y = y + 12
  api.print("0: released  1: just pressed", 6, y, colors.white)
  y = y + 6
  api.print("2: pressed   3: just released", 6, y, colors.white)
  y = y + 12

  -- visualize player input
  api.print("player 1", 20, y, colors.white)
  api.print("player 2", 74, y, colors.white)
  y = y + 10
  api.print("left: "..input:get_button_state(button_ids.left, 0), 20, y, colors.white)
  api.print("left: "..input:get_button_state(button_ids.left, 1), 74, y, colors.white)
  y = y + 6
  api.print("right: "..input:get_button_state(button_ids.right, 0), 20, y, colors.white)
  api.print("right: "..input:get_button_state(button_ids.right, 1), 74, y, colors.white)
  y = y + 6
  api.print("up: "..input:get_button_state(button_ids.up, 0), 20, y, colors.white)
  api.print("up: "..input:get_button_state(button_ids.up, 1), 74, y, colors.white)
  y = y + 6
  api.print("down: "..input:get_button_state(button_ids.down, 0), 20, y, colors.white)
  api.print("down: "..input:get_button_state(button_ids.down, 1), 74, y, colors.white)
  y = y + 6
  api.print("o: "..input:get_button_state(button_ids.o, 0), 20, y, colors.white)
  api.print("o: "..input:get_button_state(button_ids.o, 1), 74, y, colors.white)
  y = y + 6
  api.print("x: "..input:get_button_state(button_ids.x, 0), 20, y, colors.white)
  api.print("x: "..input:get_button_state(button_ids.x, 1), 74, y, colors.white)
  y = y + 12

  -- visualize mouse cursor info
  local cursor_pos = input.get_cursor_position()
  api.print("cursor: ("..cursor_pos.x..", "..cursor_pos.y..")", 20, y, colors.white)
  y = y + 9

  ui.print_centered("(o: toggle mouse input)", 64, y, colors.white)
end

return input_demo
