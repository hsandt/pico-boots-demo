local gamestate = require("engine/application/gamestate")
require("engine/core/class")
local ui = require("engine/ui/ui")

-- main menu: gamestate for player navigating in main menu
local debug_demo = derived_class(gamestate)

debug_demo.type = ':debug_demo'

function debug_demo:_init()
end

function debug_demo:on_enter()
end

function debug_demo:on_exit()
end

function debug_demo:update()
end

function debug_demo:render()
  cls()

  local y = 6
  ui.print_centered("debug demo", 64, y, colors.white)
end

return debug_demo
