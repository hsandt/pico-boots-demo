local gamestate = require("engine/application/gamestate")

-- main menu: gamestate for player navigating in main menu
local main_menu = derived_class(gamestate)

main_menu.type = "main_menu"

function main_menu:_init()
end

function main_menu:update()
end

function main_menu:render()
  api.print("main menu", 4*11, 6*12)
end

return main_menu
