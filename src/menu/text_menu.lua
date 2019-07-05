require("engine/application/constants")
require("engine/render/color")
local flow = require("engine/application/flow")
local input = require("engine/input/input")
local ui = require("engine/ui/ui")

local menu_item = require("menu/menu_item")

-- text menu: class representing a menu with labels and arrow-based navigation
local text_menu = new_class()

-- parameters
-- items: {menu_item}      sequence of items to display
--
-- state
-- selection_index: int    index of the item currently selected
function text_menu:_init(items)
  -- parameters
  self.items = items

  -- state
  self.selection_index = 1
end

-- handle navigation input
function text_menu:update()
  if input:is_just_pressed(button_ids.up) then
    self:select_previous()
  elseif input:is_just_pressed(button_ids.down) then
    self:select_next()
  elseif input:is_just_pressed(button_ids.o) then
    self:confirm_selection()
  end
end

function text_menu:select_previous()
  -- clamp selection
  self.selection_index = max(self.selection_index - 1, 1)
end

function text_menu:select_next()
  -- clamp selection
  self.selection_index = min(self.selection_index + 1, #self.items)
end

function text_menu:confirm_selection()
  flow:query_gamestate_type(self.items[self.selection_index].target_state)
end

-- render menu, starting at top y, with text centered on x
function text_menu:draw(top)
  local y = top

  for item in all(self.items) do
    ui.print_centered(item.label, screen_width / 2, y, colors.white)
    y = y + character_height
  end

  api.print(">", 4*10, 6*(12+self.selection_index))
end

return text_menu
