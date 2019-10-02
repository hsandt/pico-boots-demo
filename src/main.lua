-- main entry file that uses the gameapp module for a quick bootstrap
-- the gameapp is also useful for integration tests

-- we must require engine/pico8/api at the top of our main.lua, so API bridges apply to all modules
require("engine/pico8/api")

local demo_app = require("application/demo_app")

function _init()
  demo_app.initial_gamestate = ':main_menu'
  demo_app:start()
end

function _update60()
  demo_app:update()
end

function _draw()
  demo_app:draw()
end
