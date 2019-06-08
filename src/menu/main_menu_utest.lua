require("engine/test/bustedhelper")
local main_menu = require("menu/main_menu")

describe('main_menu', function ()

  describe('init', function ()

  end)

  describe('render', function ()

    setup(function ()
      stub(api, "print")
    end)

    teardown(function ()
      api.print:revert()
    end)

    it('should print "starts", "credits" and cursor ">" in front of start in white', function ()
      main_menu:render()

      local s = assert.spy(api.print)
      s.was_called(1)
      s.was_called_with("main menu", 4*11, 6*12)
    end)

  end)

end)
