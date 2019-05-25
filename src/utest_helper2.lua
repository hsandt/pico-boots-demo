require("engine/test/bustedhelper")
local h2 = require("helper2")

describe('sub', function ()
  it('should return the difference of two numbers', function ()
    assert.are_equal(-1, h2.sub(2, 3))
  end)
end)
