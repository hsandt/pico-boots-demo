-- main entry file that uses the gameapp module for a quick bootstrap
-- the gameapp is also useful for integration tests

local gameapp = require("engine/application/gameapp")
require("engine/core/class")
local input = require("engine/input/input")
local ui = require("engine/ui/ui")

local main_menu = require("menu/main_menu")
local debug_demo = require("demos/debug_demo")
local input_demo = require("demos/input_demo")
local visual = require("resources/visual")

local demo_app = derived_class(gameapp)

function demo_app.instantiate_gamestates() -- override
  return {main_menu(), debug_demo(), input_demo()}
end

function demo_app.on_start() -- override
  -- enable mouse devkit
  input:toggle_mouse(true)
  ui:set_cursor_sprite_data(visual.sprites.cursor)
end

function demo_app.on_reset() -- override
  ui:set_cursor_sprite_data(nil)
end

function demo_app:on_render() -- override
  ui:render_mouse()
end

return demo_app
