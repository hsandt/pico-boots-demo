local flow = require("engine/application/flow")
local gamestate = require("engine/application/gamestate")
require("engine/core/class")
local input = require("engine/input/input")
require("engine/render/color")
local ui = require("engine/ui/ui")

-- main menu: gamestate for player navigating in main menu
local input_demo = derived_class(gamestate)

input_demo.type = ':input_demo'

function input_demo:_init()
end

function input_demo:on_enter()
end

function input_demo:on_exit()
end

function input_demo:update()
  -- no chord system yet, so check holding + press manually
  if input:is_down(button_ids.left) and input:is_just_pressed(button_ids.x) then
    self:_go_back()
  end
end

function input_demo:_go_back()
  flow:query_gamestate_type(':main_menu')
end

function input_demo:render()
  cls()

  -- todo: use vertical_layout
  local y = 6
  ui.print_centered("input demo", 64, y, colors.white)
  y = y + 6
  ui.print_centered("(hold left + x: back to main menu)", 64, y, colors.white)
  y = y + 12

  api.print("left: "..input:get_button_state(button_ids.left, 0), 10, y, colors.white)
  y = y + 6
  api.print("right: "..input:get_button_state(button_ids.right, 0), 10, y, colors.white)
  y = y + 6
  api.print("up: "..input:get_button_state(button_ids.up, 0), 10, y, colors.white)
  y = y + 6
  api.print("down: "..input:get_button_state(button_ids.down, 0), 10, y, colors.white)
  y = y + 6
  api.print("o: "..input:get_button_state(button_ids.o, 0), 10, y, colors.white)
  y = y + 6
  api.print("x: "..input:get_button_state(button_ids.x, 0), 10, y, colors.white)
end

return input_demo
