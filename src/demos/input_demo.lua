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
end

function input_demo:render()
  cls()

  local y = 6
  -- todo: use vertical_layout
  api.print("left: "..input.players_btn_states[0][button_ids.left], 10, y, colors.white)
  y = y + 6
  api.print("right: "..input.players_btn_states[0][button_ids.right], 10, y, colors.white)
  y = y + 6
  api.print("up: "..input.players_btn_states[0][button_ids.up], 10, y, colors.white)
  y = y + 6
  api.print("down: "..input.players_btn_states[0][button_ids.down], 10, y, colors.white)
  y = y + 6
  api.print("o: "..input.players_btn_states[0][button_ids.o], 10, y, colors.white)
  y = y + 6
  api.print("x: "..input.players_btn_states[0][button_ids.x], 10, y, colors.white)
end

return input_demo
