-- main entry file that uses the gameapp module for a quick bootstrap
-- the gameapp is also useful for integration tests

local gameapp = require("engine/application/gameapp")
require("engine/core/class")

local main_menu = require("menu/main_menu")
local debug_demo = require("demos/debug_demo")
local input_demo = require("demos/input_demo")

local demo_app = derived_class(gameapp)

function demo_app.instantiate_gamestates() -- override
  return {main_menu(), debug_demo(), input_demo()}
end

return demo_app
