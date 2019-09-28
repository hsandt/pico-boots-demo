-- main entry file that uses the gameapp module for a quick bootstrap
-- the gameapp is also useful for integration tests

local gameapp = require("engine/application/gameapp")
require("engine/core/class")
local codetuner = require("engine/debug/codetuner")
local logging = require("engine/debug/logging")
local profiler = require("engine/debug/profiler")
local vlogger = require("engine/debug/visual_logger")
local input = require("engine/input/input")
local ui = require("engine/ui/ui")

local main_menu = require("menu/main_menu")
local debug_demo = require("demos/debug_demo")
local input_demo = require("demos/input_demo")
local render_demo = require("demos/render_demo")
local visual_data = require("resources/visual_data")

local demo_app = derived_class(gameapp)

function demo_app.instantiate_gamestates() -- override
  return {main_menu(), debug_demo(), input_demo(), render_demo()}
end

function demo_app.on_pre_start() -- override
  -- register console log stream to output logs to the console
  -- do this in pre-start so we can access log as early as possible
  logging.logger:register_stream(logging.console_log_stream)
  logging.logger:register_stream(logging.file_log_stream)
  logging.file_log_stream.file_prefix = "pico_boots_demo"
  logging.logger:register_stream(vlogger.vlog_stream)
  -- start inactive (important to avoid uninitialized _msg_queue error
  --  when logging before calling set_vlogger_active in debug_demo)
  vlogger.vlog_stream.active = false

  -- clear log file on new game session (or to preserve the previous log,
  -- you could add a newline and some "[SESSION START]" tag instead)
  logging.file_log_stream:clear()
end

function demo_app.on_post_start() -- override
  -- enable mouse devkit
  input:toggle_mouse(true)
  ui:set_cursor_sprite_data(visual_data.sprites.cursor)
end

function demo_app.on_reset() -- override
  ui:set_cursor_sprite_data(nil)
end

function demo_app.on_update() -- override
  profiler.window:update()
  vlogger.window:update()
  codetuner:update_window()
end

function demo_app:on_render() -- override
  profiler.window:render()
  vlogger.window:render()
  codetuner:render_window()

  -- always draw cursor on top
  ui:render_mouse()
end

return demo_app
