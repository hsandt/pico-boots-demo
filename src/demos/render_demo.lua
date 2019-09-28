local flow = require("engine/application/flow")
local input = require("engine/input/input")
local animated_sprite = require("engine/render/animated_sprite")
require("engine/render/color")
local ui = require("engine/ui/ui")
local wtk = require("wtk/pico8wtk")

-- main menu: gamestate for player navigating in main menu
local render_demo = derived_class(gamestate)

render_demo.type = ':render_demo'

function render_demo:_init()
  self.gui = wtk.gui_root.new()
end

function render_demo:on_enter()
end

function render_demo:on_exit()
end

function render_demo:update()
  self.gui:update()

  if input:is_just_pressed(button_ids.x) then
    self:_go_back()
  end
end

function render_demo:_go_back()
  flow:query_gamestate_type(':main_menu')
end

function render_demo:render()
  cls()

  local y = 6
  ui.print_centered("render demo", 64, y, colors.white)
  y = y + 6
  ui.print_centered("(x: back to main menu)", 64, y, colors.white)

  self.gui:draw()

  self:draw_sprites()
end

function render_demo:draw_sprites()
end


return render_demo
