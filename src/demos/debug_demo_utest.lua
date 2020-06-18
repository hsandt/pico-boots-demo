require("engine/test/bustedhelper")
local profiler = require("engine/debug/profiler")
local debug_demo = require("demos/debug_demo")
local wtk = require("wtk/pico8wtk")

local flow = require("engine/application/flow")
local gamestate = require("engine/application/gamestate")
local input = require("engine/input/input")
require("engine/render/color")
local ui = require("engine/ui/ui")

describe('debug_demo', function ()

  describe('class', function ()
    it('should derive from gamestate', function ()
      assert.are_equal(gamestate, getmetatable(debug_demo).__index)
    end)
  end)

  describe('instance', function ()

    local debug_demo_state

    before_each(function ()
      debug_demo_state = debug_demo()
    end)

    describe('init', function ()

      it('should create a gui root', function ()
        assert.are_equal(wtk.gui_root, getmetatable(debug_demo_state.gui))
      end)

      it('should add a vertical layout with 11 elements to the gui root', function ()
        assert.are_equal(wtk.vertical_layout, getmetatable(debug_demo_state.v_layout))
        assert.are_equal(debug_demo_state.v_layout, debug_demo_state.gui.children[1])
        assert.are_equal(11, #debug_demo_state.v_layout.children)
        -- we don't detail the elements further, as it would mostly be testing data
      end)

    end)

    describe('update', function ()

      setup(function ()
        stub(wtk.gui_root, "update")
        stub(debug_demo, "_go_back")
      end)

      teardown(function ()
        wtk.gui_root.update:revert()
        debug_demo._go_back:revert()
      end)

      after_each(function ()
        wtk.gui_root.update:clear()
        debug_demo._go_back:clear()
      end)

      it('should update debug_demo gui', function ()
        debug_demo_state:update()

        local s = assert.spy(debug_demo_state.gui.update)
        s.was_called(1)
        s.was_called_with(match.ref(debug_demo_state.gui))
      end)

      it('(when no input is down) it should not call _go_back', function ()
        debug_demo_state:update()

        local s = assert.spy(debug_demo_state._go_back)
        s.was_not_called()
      end)

      describe('(when x just pressed)', function ()

        setup(function ()
          input.players_btn_states[0][button_ids.left] = btn_states.pressed
          input.players_btn_states[0][button_ids.x] = btn_states.just_pressed
        end)

        teardown(function ()
          input:init()
        end)

        it('it should call _go_back', function ()
          debug_demo_state:update()

          local s = assert.spy(debug_demo_state._go_back)
          s.was_called(1)
          s.was_called_with(match.ref(debug_demo_state))
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
        debug_demo_state:_go_back()

        local s = assert.spy(flow.query_gamestate_type)
        s.was_called(1)
        s.was_called_with(flow, ':main_menu')
      end)

    end)

    describe('render', function ()

      setup(function ()
        stub(_G, "cls")
        stub(ui, "print_centered")
        -- spy gui_root.draw, but also stub to avoid
        --  having indirect rectfill calls making it hard to count them
        stub(wtk.gui_root, "draw")
        stub(_G, "tuned", function (name, default_value)
          -- simulate the user having modified the tuned values a bit
          return default_value + 10
        end)
        stub(_G, "rectfill")
      end)

      teardown(function ()
        cls:revert()
        ui.print_centered:revert()
        wtk.gui_root.draw:revert()
        tuned:revert()
        rectfill:revert()
      end)

      after_each(function ()
        cls:clear()
        ui.print_centered:clear()
        wtk.gui_root.draw:clear()
        tuned:clear()
        rectfill:clear()
      end)

      it('should clear screen', function ()
        debug_demo_state:render()

        assert.spy(cls).was_called(1)
      end)

      it('should print the demo title', function ()
        debug_demo_state:render()

        local s = assert.spy(ui.print_centered)
        s.was_called(2)
        s.was_called_with("debug demo", 64, 6, colors.white)
        s.was_called_with("(x: back to main menu)", 64, 12, colors.white)
      end)

      it('should draw the gui', function ()
        debug_demo_state:render()

        local s = assert.spy(debug_demo_state.gui.draw)
        s.was_called(1)
        s.was_called_with(match.ref(debug_demo_state.gui))
      end)

      it('should draw a yellow rectangle to demonstrate codetuner', function ()
        debug_demo_state:render()

        local s = assert.spy(rectfill)
        s.was_called(1)
        -- take simulated tuning of +10 into account
        s.was_called_with(74, 126, 82, 134, colors.yellow)
      end)

    end)

  end)

end)
