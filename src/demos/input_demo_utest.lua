require("engine/test/bustedhelper")
local input_demo = require("demos/input_demo")

local flow = require("engine/application/flow")
local input = require("engine/input/input")
require("engine/render/color")
local ui = require("engine/ui/ui")

describe('input_demo', function ()

  local input_demo_state

  before_each(function ()
    input_demo_state = input_demo()
  end)

  describe('update', function ()

    setup(function ()
      stub(input_demo, "_go_back")
    end)

    teardown(function ()
      input_demo_state._go_back:revert()
    end)

    after_each(function ()
      input_demo_state._go_back:clear()
    end)

    it('(when no input is down) it should not call _go_back', function ()
      input_demo_state:update()

      local s = assert.spy(input_demo_state._go_back)
      s.was_not_called()
    end)

    it('(when input left is down and x just pressed) it should call _go_back', function ()
      input.players_btn_states[0][button_ids.left] = btn_states.pressed
      input.players_btn_states[0][button_ids.x] = btn_states.just_pressed

      input_demo_state:update()

      local s = assert.spy(input_demo_state._go_back)
      s.was_called(1)
      s.was_called_with(match.ref(input_demo_state))
    end)

  end)

  describe('_go_back', function ()

    setup(function ()
      stub(flow, "query_gamestate_type")
    end)

    teardown(function ()
      flow.query_gamestate_type:revert()
    end)

    it('should enter the main_menu state', function ()
      input_demo_state:_go_back()

      local s = assert.spy(flow.query_gamestate_type)
      s.was_called(1)
      s.was_called_with(flow, ':main_menu')
    end)

  end)

  describe('render', function ()

    setup(function ()
      stub(_G, "cls")
      stub(ui, "print_centered")
      stub(api, "print")
    end)

    teardown(function ()
      cls:revert()
      ui.print_centered:revert()
      api.print:revert()
    end)

    after_each(function ()
      cls:clear()
      ui.print_centered:clear()
      api.print:clear()
    end)

    it('should clear screen', function ()
      input_demo_state:render()

      assert.spy(cls).was_called(1)
    end)

    it('should print the demo title and back input instruction', function ()
      input_demo_state:render()

      local s = assert.spy(ui.print_centered)
      s.was_called(2)
      s.was_called_with("input demo", 64, 6, colors.white)
      s.was_called_with("(hold left + x: back to main menu)", 64, 12, colors.white)
    end)

    it('should print the current state of each button (with explanation)', function ()
      input.players_btn_states[0] = {
        [button_ids.left] = btn_states.released,
        [button_ids.right] = btn_states.just_pressed,
        [button_ids.up] = btn_states.pressed,
        [button_ids.down] = btn_states.just_released,
        [button_ids.o] = btn_states.released,
        [button_ids.x] = btn_states.just_pressed
      }

      input_demo_state:render()

      local s = assert.spy(api.print)
      s.was_called(8)

      s.was_called_with("0: released  1: just pressed", 6, 24, colors.white)
      s.was_called_with("2: pressed   3: just released", 6, 30, colors.white)

      s.was_called_with("left: 0", 10, 42, colors.white)
      s.was_called_with("right: 1", 10, 48, colors.white)
      s.was_called_with("up: 2", 10, 54, colors.white)
      s.was_called_with("down: 3", 10, 60, colors.white)
      s.was_called_with("o: 0", 10, 66, colors.white)
      s.was_called_with("x: 1", 10, 72, colors.white)
    end)

  end)

end)
