require("engine/test/bustedhelper")
local render_demo = require("demos/render_demo")

local flow = require("engine/application/flow")
local gamestate = require("engine/application/gamestate")
require("engine/core/math")
local input = require("engine/input/input")
local animated_sprite = require("engine/render/animated_sprite")
local sprite_data = require("engine/render/sprite_data")
local ui = require("engine/ui/ui")
local wtk = require("wtk/pico8wtk")

local visual_data = require("resources/visual_data")

describe('render_demo', function ()

  describe('class', function ()
    it('should derive from gamestate', function ()
      assert.are_equal(gamestate, getmetatable(render_demo).__index)
    end)
  end)

  describe('instance', function ()

    local render_demo_state

    before_each(function ()
      render_demo_state = render_demo()
    end)

    describe('init', function ()

      it('should create a gui root with 2 elements (buttons)', function ()
        assert.are_equal(wtk.gui_root, getmetatable(render_demo_state.gui))
        assert.are_equal(2, #render_demo_state.gui.children)
      end)

      it('should create gem animated sprite', function ()
        assert.is_not_nil(render_demo_state.gem_anim_sprite)
        assert.are_equal(visual_data.anim_sprites.gem, render_demo_state.gem_anim_sprite.data_table)
      end)

    end)

    describe('on_enter', function ()

      setup(function ()
        stub(animated_sprite, "play")
      end)

      teardown(function ()
        animated_sprite.play:revert()
      end)

      after_each(function ()
        animated_sprite.play:clear()
      end)

      it('should play gem "idle" animation', function ()
        render_demo_state:on_enter()

        assert.spy(animated_sprite.play).was_called(1)
        assert.spy(animated_sprite.play).was_called_with(render_demo_state.gem_anim_sprite, 'idle')
      end)

    end)

    describe('update', function ()

      setup(function ()
        stub(wtk.gui_root, "update")
        stub(animated_sprite, "update")
        stub(render_demo, "_go_back")
      end)

      teardown(function ()
        wtk.gui_root.update:revert()
        animated_sprite.update:revert()
        render_demo._go_back:revert()
      end)

      after_each(function ()
        wtk.gui_root.update:clear()
        animated_sprite.update:clear()
        render_demo._go_back:clear()
      end)

      it('should update gem animated sprite', function ()
        render_demo_state:update()

        local s = assert.spy(animated_sprite.update)
        s.was_called(1)
        s.was_called_with(match.ref(render_demo_state.gem_anim_sprite))
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

    describe('draw_sprites', function ()

      setup(function ()
        stub(sprite_data, "render")
        stub(animated_sprite, "render")
      end)

      teardown(function ()
        sprite_data.render:revert()
        animated_sprite.render:revert()
      end)

      after_each(function ()
        sprite_data.render:clear()
        animated_sprite.render:clear()
      end)

      it('should draw the animated gem sprite at some position', function ()
        render_demo_state:render()

        local s = assert.spy(sprite_data.render)
        s.was_called(1)
        s.was_called_with(visual_data.sprites.gem.idle, vector(44, 64))

        s = assert.spy(animated_sprite.render)
        s.was_called(1)
        s.was_called_with(match.ref(render_demo_state.gem_anim_sprite), vector(84, 64))
      end)

    end)

  end)

end)
