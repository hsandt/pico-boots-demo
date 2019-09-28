require("engine/test/bustedhelper")
local render_demo = require("demos/render_demo")

local flow = require("engine/application/flow")
local input = require("engine/input/input")
local ui = require("engine/ui/ui")
local wtk = require("wtk/pico8wtk")

describe('render_demo', function ()

  local render_demo_state

  before_each(function ()
    render_demo_state = render_demo()
  end)

  describe('init', function ()

    it('should create a gui root', function ()
      assert.are_equal(wtk.gui_root, getmetatable(render_demo_state.gui))
    end)

  end)

  describe('update', function ()

    setup(function ()
      stub(wtk.gui_root, "update")
      stub(render_demo, "_go_back")
    end)

    teardown(function ()
      wtk.gui_root.update:revert()
      render_demo._go_back:revert()
    end)

    after_each(function ()
      wtk.gui_root.update:clear()
      render_demo._go_back:clear()
    end)

    it('should update render_demo gui', function ()
      render_demo_state:update()

      local s = assert.spy(render_demo_state.gui.update)
      s.was_called(1)
      s.was_called_with(match.ref(render_demo_state.gui))
    end)

    it('(when no input is down) it should not call _go_back', function ()
      render_demo_state:update()

      local s = assert.spy(render_demo_state._go_back)
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
        render_demo_state:update()

        local s = assert.spy(render_demo_state._go_back)
        s.was_called(1)
        s.was_called_with(match.ref(render_demo_state))
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
      render_demo_state:_go_back()

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
      --  having indirect calls to low-level render functions, making it hard to count them
      stub(wtk.gui_root, "draw")
      stub(render_demo, "draw_sprites")
    end)

    teardown(function ()
      cls:revert()
      ui.print_centered:revert()
      wtk.gui_root.draw:revert()
      render_demo.draw_sprites:revert()
    end)

    after_each(function ()
      cls:clear()
      ui.print_centered:clear()
      wtk.gui_root.draw:clear()
      render_demo.draw_sprites:clear()
    end)

    it('should clear screen', function ()
      render_demo_state:render()

      assert.spy(cls).was_called(1)
    end)

    it('should print the demo title', function ()
      render_demo_state:render()

      local s = assert.spy(ui.print_centered)
      s.was_called(2)
      s.was_called_with("render demo", 64, 6, colors.white)
      s.was_called_with("(x: back to main menu)", 64, 12, colors.white)
    end)

    it('should draw the gui', function ()
      render_demo_state:render()

      local s = assert.spy(render_demo_state.gui.draw)
      s.was_called(1)
      s.was_called_with(match.ref(render_demo_state.gui))
    end)

    it('should draw the demo sprites', function ()
      render_demo_state:render()

      local s = assert.spy(render_demo_state.draw_sprites)
      s.was_called(1)
      s.was_called_with(match.ref(render_demo_state))
    end)

  end)

end)
