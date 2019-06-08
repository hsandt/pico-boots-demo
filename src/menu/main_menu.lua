local gamestate = require("engine/application/gamestate")
local ui = require("engine/ui/ui")
require("engine/render/color")

-- main menu: gamestate for player navigating in main menu
local main_menu = derived_class(gamestate)

main_menu.type = "main_menu"

function main_menu:_init()
end

function main_menu:update()
end

function main_menu:render()
  cls()
  ui.print_centered("main menu", 64, 64, colors.white)
end

return main_menu
