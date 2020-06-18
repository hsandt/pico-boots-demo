local flow = require("engine/application/flow")
local gamestate = require("engine/application/gamestate")
require("engine/core/math")
local input = require("engine/input/input")
local animated_sprite = require("engine/render/animated_sprite")
require("engine/render/color")
local ui = require("engine/ui/ui")
local wtk = require("wtk/pico8wtk")

local visual_data = require("resources/visual_data")

-- render demo: gamestate to demonstrate render features
local render_demo = derived_class(gamestate)

render_demo.type = ':render_demo'

function render_demo:_init()
  self.gui = wtk.gui_root.new()

  -- the button "play spin" should turn into "play idle" when the 'spin' animation is played,
  --  and reversely, to allow toggling between the two
  -- however, it is simpler to create 2 buttons and toggle their visibility than changing
  --  the label and function of the button dynamically
  self.play_spin_button = wtk.button.new("play spin", function ()
      -- self is accessed from context here
      self.gem_anim_sprite:play('spin')
      self.play_spin_button.visible = false
      self.play_idle_button.visible = true
    end, colors.white)
  self.gui:add_child(self.play_spin_button, 0, 20)

  self.play_idle_button = wtk.button.new("play idle", function ()
      -- self is accessed from context here
      self.gem_anim_sprite:play('idle')
      self.play_spin_button.visible = true
      self.play_idle_button.visible = false
    end, colors.white)
  self.play_idle_button.visible = false
  self.gui:add_child(self.play_idle_button, 0, 20)

  -- we decide to initialize objects on game start, and preserve them in on_exit
  --  because they are cheap; a bigger project would initialize in on_enter
  --  and clean in on_exit
  self.gem_anim_sprite = animated_sprite(visual_data.anim_sprites.gem)
end

function render_demo:on_enter()
  self.gem_anim_sprite:play('idle')
end

function render_demo:on_exit()
end

function render_demo:update()
  self.gui:update()
  self.gem_anim_sprite:update()

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
  visual_data.sprites.gem.idle:render(vector(44, 64))
  self.gem_anim_sprite:render(vector(84, 64))
end

return render_demo
