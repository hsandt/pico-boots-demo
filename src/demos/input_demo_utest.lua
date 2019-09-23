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
      input_demo._go_back:revert()
    end)

    after_each(function ()
      input_demo._go_back:clear()
    end)

    it('(when no input is down) it should not call _go_back', function ()
      input_demo_state:update()

      local s = assert.spy(input_demo_state._go_back)
      s.was_not_called()
    end)

    describe('(when input left is down and x just pressed)', function ()

      setup(function ()
        input.players_btn_states[0][button_ids.left] = btn_states.pressed
        input.players_btn_states[0][button_ids.x] = btn_states.just_pressed
      end)

      teardown(function ()
        input:init()
      end)

      it('it should call _go_back', function ()
        input.players_btn_states[0][button_ids.left] = btn_states.pressed
        input.players_btn_states[0][button_ids.x] = btn_states.just_pressed

        input_demo_state:update()

        local s = assert.spy(input_demo_state._go_back)
        s.was_called(1)
        s.was_called_with(match.ref(input_demo_state))
      end)

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

    describe('(with some inputs for both players)', function ()

      setup(function ()
        input.players_btn_states = {
          [0] = {
            [button_ids.left] = btn_states.released,
            [button_ids.right] = btn_states.just_pressed,
            [button_ids.up] = btn_states.pressed,
            [button_ids.down] = btn_states.just_released,
            [button_ids.o] = btn_states.released,
            [button_ids.x] = btn_states.just_pressed
          },
          [1] = {
            [button_ids.left] = btn_states.just_pressed,
            [button_ids.right] = btn_states.released,
            [button_ids.up] = btn_states.just_released,
            [button_ids.down] = btn_states.just_released,
            [button_ids.o] = btn_states.pressed,
            [button_ids.x] = btn_states.just_released
          }
        }

        pico8.mousepos.x = 12
        pico8.mousepos.y = 45
      end)

      teardown(function ()
        input:init()

        pico8.mousepos.x = 0
        pico8.mousepos.y = 0
      end)

      it('should print the current state of each button (with explanation)', function ()
        input_demo_state:render()

        local s = assert.spy(api.print)
        s.was_called(17)

        s.was_called_with("0: released  1: just pressed", 6, 24, colors.white)
        s.was_called_with("2: pressed   3: just released", 6, 30, colors.white)

        s.was_called_with("player 1", 20, 42, colors.white)
        s.was_called_with("left: 0", 20, 52, colors.white)
        s.was_called_with("right: 1", 20, 58, colors.white)
        s.was_called_with("up: 2", 20, 64, colors.white)
        s.was_called_with("down: 3", 20, 70, colors.white)
        s.was_called_with("o: 0", 20, 76, colors.white)
        s.was_called_with("x: 1", 20, 82, colors.white)

        s.was_called_with("player 2", 74, 42, colors.white)
        s.was_called_with("left: 1", 74, 52, colors.white)
        s.was_called_with("right: 0", 74, 58, colors.white)
        s.was_called_with("up: 3", 74, 64, colors.white)
        s.was_called_with("down: 3", 74, 70, colors.white)
        s.was_called_with("o: 2", 74, 76, colors.white)
        s.was_called_with("x: 3", 74, 82, colors.white)

        s.was_called_with("cursor: (12, 45)", 20, 94, colors.white)
      end)

    end)

  end)

end)
