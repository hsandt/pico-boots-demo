local gamestate = require("engine/application/gamestate")
require("engine/core/class")
local input = require("engine/input/input")
require("engine/render/color")
local ui = require("engine/ui/ui")

local menu_item = require("menu/menu_item")
local text_menu = require("menu/text_menu")

-- main menu: gamestate for player navigating in main menu
local main_menu = derived_class(gamestate)

main_menu.type = ':main_menu'

-- sequence of menu items to display, with their target states
main_menu._items = transform({
    {"debug demo", ':debug_demo'},
    {"input demo", ':input_demo'}
  }, unpacking(menu_item))

-- text_menu: text_menu    component handling menu display and selection
function main_menu:_init()
  self.text_menu = text_menu(main_menu._items)
end

function main_menu:on_enter()
  -- do not reset previous selection to retain last user choice
end

function main_menu:on_exit()
end

function main_menu:update()
  self.text_menu:update()
end

function main_menu:render()
  cls()

  local title_y = 48
  ui.print_centered("main menu", 64, title_y, colors.white)

  -- skip 4 lines and draw menu content
  self.text_menu:draw(title_y + 4 * character_height)
end

return main_menu
