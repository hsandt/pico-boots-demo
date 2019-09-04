require("engine/test/bustedhelper")
local debug_demo = require("demos/debug_demo")

require("engine/render/color")
local ui = require("engine/ui/ui")

describe('debug_demo', function ()

  local debug_demo_state

  before_each(function ()
    debug_demo_state = debug_demo()
  end)

  describe('render', function ()

    setup(function ()
      stub(_G, "cls")
      stub(ui, "print_centered")

    end)

    teardown(function ()
      cls:revert()
      ui.print_centered:revert()
    end)

    after_each(function ()
      cls:clear()
      ui.print_centered:clear()
    end)

    it('should clear screen', function ()
      debug_demo_state:render()

      assert.spy(cls).was_called(1)
    end)

    it('should print the demo title', function ()
      debug_demo_state:render()

      local s = assert.spy(ui.print_centered)
      s.was_called(1)
      s.was_called_with("debug demo", 64, 6, colors.white)
    end)

  end)

end)
