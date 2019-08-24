local integrationtest = require("engine/test/integrationtest")
local itest_manager = integrationtest.itest_manager
local input = require("engine/input/input")
local flow = require("engine/application/flow")

itest_manager:register_itest('player select credits',
    -- keep active_gamestate for now, for retrocompatibility with pico-sonic...
    -- but without gamestate_proxy, not used
    {':main_menu'}, function ()

  -- enter title menu
  setup_callback(function ()
    flow:change_gamestate_by_type(':main_menu')
  end)

  wait(1.0)

  -- press down input, causing a just pressed input
  -- => cursor should point to "input"
  act(function ()
    input.simulated_buttons_down[0][button_ids.down] = true
  end)

  wait(0.5)

  -- release down input
  act(function ()
    input.simulated_buttons_down[0][button_ids.down] = false
  end)

  wait(0.5)

  -- player presses o, causing a just pressed input
  -- => should enter credits state
  act(function ()
    input.simulated_buttons_down[0][button_ids.o] = true
  end)

  wait(0.5)

  -- release o after 30 frames
  -- after just 1 frame, we have already entered
  act(function ()
    input.simulated_buttons_down[0][button_ids.o] = false
  end)

  -- check that we entered the credits state
  final_assert(function ()
    return flow.curr_state.type == ':input_demo', "current game state is not ':input_demo', has instead type: '"..flow.curr_state.type.."'"
  end)

end)
