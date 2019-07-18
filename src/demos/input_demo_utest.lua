require("engine/test/bustedhelper")
local input_demo = require("demos/input_demo")

local input = require("engine/input/input")
require("engine/render/color")
local ui = require("engine/ui/ui")

describe('input_demo', function ()

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
      input_demo:render()

      assert.spy(cls).was_called(1)
    end)

    it('should print the demo title', function ()
      input_demo:render()

      local s = assert.spy(ui.print_centered)
      s.was_called(1)
      s.was_called_with("input demo", 64, 6, colors.white)
    end)

    it('should print the current state of each button', function ()
      input.players_btn_states[0] = {
        [button_ids.left] = btn_states.released,
        [button_ids.right] = btn_states.just_pressed,
        [button_ids.up] = btn_states.pressed,
        [button_ids.down] = btn_states.just_released,
        [button_ids.o] = btn_states.released,
        [button_ids.x] = btn_states.just_pressed
      }

      input_demo:render()

      local s = assert.spy(api.print)
      s.was_called(6)
      s.was_called_with("left: 0", 10, 18, colors.white)
      s.was_called_with("right: 1", 10, 24, colors.white)
      s.was_called_with("up: 2", 10, 30, colors.white)
      s.was_called_with("down: 3", 10, 36, colors.white)
      s.was_called_with("o: 0", 10, 42, colors.white)
      s.was_called_with("x: 1", 10, 48, colors.white)
    end)

  end)

end)
