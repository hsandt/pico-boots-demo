require("engine/test/bustedhelper")
local main_menu = require("menu/main_menu")

local gamestate = require("engine/application/gamestate")
local input = require("engine/input/input")
require("engine/render/color")
local ui = require("engine/ui/ui")

local text_menu = require("menu/text_menu")

describe('main_menu', function ()

  describe('class', function ()
    it('should derive from gamestate', function ()
      assert.are_equal(gamestate, getmetatable(main_menu).__index)
    end)
  end)

  describe('instance', function ()

    describe('init', function ()
      it('should set text menu to a new text menu with given items', function ()
        local menu = main_menu()

        assert.are_equal(main_menu._items, menu._items)
      end)
    end)

    describe('(with instance)', function ()

      local menu

      before_each(function ()
        menu = main_menu()
      end)

      describe('update', function ()

        setup(function ()
          stub(text_menu, "update")
        end)

        teardown(function ()
          text_menu.update:revert()
        end)

        it('should update text_menu', function ()
          menu:update()

          local s = assert.spy(text_menu.update)
          s.was_called(1)
          s.was_called_with(match.ref(menu.text_menu))
        end)

      end)

      describe('render', function ()

        setup(function ()
          stub(ui, "print_centered")
          -- stub text_menu.draw completely to avoid altering the count of ui.print_centered calls
          stub(text_menu, "draw")
        end)

        teardown(function ()
          ui.print_centered:revert()
          text_menu.draw:revert()
        end)

        after_each(function ()
          ui.print_centered:clear()
          text_menu.draw:clear()
        end)

        it('should print "main menu" centered, in white', function ()
          menu:render()

          local s = assert.spy(ui.print_centered)
          s.was_called(1)
          s.was_called_with("main menu", 64, 48, colors.white)
        end)

        it('should draw text_menu 4 lines below "main menu"', function ()
          menu:render()

          local s = assert.spy(text_menu.draw)
          s.was_called(1)
          s.was_called_with(match.ref(menu.text_menu), 48 + 4 * 6)
        end)

      end)

    end)

  end)  -- instance

end)
