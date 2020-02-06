-- main entry file that uses the gameapp module for a quick bootstrap
-- the gameapp is also useful for integration tests

-- we must require engine/pico8/api at the top of our main.lua, so API bridges apply to all modules
require("engine/pico8/api")

local demo_app = require("application/demo_app")

--#if log
local logging = require("engine/debug/logging")
local vlogger = require("engine/debug/visual_logger")
--#endif

local app = demo_app()

function _init()
  --#if log
  -- start logging before app in case we need to read logs about app start itself
  logging.logger:register_stream(logging.console_log_stream)
  logging.logger:register_stream(logging.file_log_stream)
  logging.file_log_stream.file_prefix = "wit_fight"

  -- clear log file on new game session (or to preserve the previous log,
  -- you could add a newline and some "[SESSION START]" tag instead)
  logging.file_log_stream:clear()

  -- start inactive (important to avoid uninitialized _msg_queue error
  --  when logging before calling set_vlogger_active in debug_demo)
  vlogger.vlog_stream.active = false
--#endif

  app.initial_gamestate = ':main_menu'
  app:start()
end

function _update60()
  app:update()
end

function _draw()
  app:draw()
end
