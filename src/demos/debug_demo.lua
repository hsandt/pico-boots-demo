local flow = require("engine/application/flow")
local gamestate = require("engine/application/gamestate")
require("engine/core/class")
local codetuner = require("engine/debug/codetuner")
local logging = require("engine/debug/logging")
local profiler = require("engine/debug/profiler")
local vlogger = require("engine/debug/visual_logger")
local input = require("engine/input/input")
require("engine/render/color")
local ui = require("engine/ui/ui")
local wtk = require("wtk/pico8wtk")

local function log_in_default_category()
  log("some info")
end

local function log_in_specific_category()
  log("some info for ui", 'ui')
end

local function warn_in_default_category()
  warn("some warning")
end

local function err_in_default_category()
  err("some error")
end

local function set_ui_category_active(checkbox)
  logging.logger.active_categories.ui = checkbox.value
end

local function set_log_stream_active(checkbox)
  logging.file_log_stream.active = checkbox.value
end

local function set_profiler_active(checkbox)
  if checkbox.value then
    profiler.window:show(colors.red)
  else
    profiler.window:hide()
  end
end

local function set_vlogger_active(checkbox)
  if checkbox.value then
    -- model: actually queue logs into the vlogger
    vlogger.vlog_stream.active = true

    -- view: show the vlogger window,
    --  on only 3 lines to avoid hiding the ui above
    -- hotfix until we upgrade wtk: gui.x/y is currently ignored,
    --  so we must change the x/y of the v_layout widget instead
    -- vlogger.window.gui.y = 116
    vlogger.window.gui.children[1].y = 116
    vlogger.window:show(2)
  else
    -- model: stop queuing log
    vlogger.vlog_stream.active = false
    -- view: hide vlogger window
    vlogger.window:hide()
  end
end

--#if tuner
local function set_codetuner_visible_active(checkbox)
  if checkbox.value then
    codetuner.active = true
    codetuner:show()
  else
    codetuner.active = false
    codetuner:hide()
  end
end
--#endif

local test_table = {
  value = 5,
  text = "hello"
}

local function log_dump_test_table()
  log(dump(test_table))
end

-- debug demo: gamestate to demonstrate debug features
local debug_demo = new_class(gamestate)

debug_demo.type = ':debug_demo'

function debug_demo:_init()
  self.gui = wtk.gui_root.new()

  self.v_layout = wtk.vertical_layout.new(10, colors.dark_blue)
  self.gui:add_child(self.v_layout, 0, 20)

  local log_label = wtk.label.new("press button to log to console", colors.white)
  self.v_layout:add_child(log_label)

  local b

  b = wtk.button.new("log to default category", log_in_default_category, colors.white)
  self.v_layout:add_child(b)

  b = wtk.button.new("log to ui category", log_in_specific_category, colors.white)
  self.v_layout:add_child(b)

  b = wtk.button.new("warn to default category", warn_in_default_category, colors.white)
  self.v_layout:add_child(b)

  b = wtk.button.new("error to default category", err_in_default_category, colors.white)
  self.v_layout:add_child(b)

  b = wtk.button.new("log table dump", log_dump_test_table, colors.white)
  self.v_layout:add_child(b)

  local t

  t = wtk.checkbox.new("ui category active", logging.logger.active_categories.ui, set_ui_category_active)
  self.v_layout:add_child(t)

  t = wtk.checkbox.new("file log stream active", logging.file_log_stream.active, set_log_stream_active)
  self.v_layout:add_child(t)

  t = wtk.checkbox.new("show profiler", profiler.window.gui.visible, set_profiler_active)
  self.v_layout:add_child(t)

  t = wtk.checkbox.new("show visual logger", vlogger.window.gui.visible, set_vlogger_active)
  self.v_layout:add_child(t)

--#if tuner
  t = wtk.checkbox.new("show and activate code tuner", codetuner.active, set_codetuner_visible_active)
  self.v_layout:add_child(t)
--#endif
end

function debug_demo:on_enter()
end

function debug_demo:on_exit()
end

function debug_demo:update()
  self.gui:update()

  if input:is_just_pressed(button_ids.x) then
    self:_go_back()
  end
end

function debug_demo:_go_back()
  flow:query_gamestate_type(':main_menu')
end

function debug_demo:render()
  cls()

  local y = 6
  ui.print_centered("debug demo", 64, y, colors.white)
  y = y + 6
  ui.print_centered("(x: back to main menu)", 64, y, colors.white)

  self.gui:draw()

  -- demonstrate code tuner by drawing a rectangle at a tunable position, above the ui
  local x0 = tuned("rect x", 64)
  local y0 = tuned("rect y", 116)
  rectfill(x0, y0, x0 + 8, y0 + 8, colors.yellow)
end

return debug_demo
