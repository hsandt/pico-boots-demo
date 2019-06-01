require("engine/test/bustedhelper")
require("game_helper")

describe('sum', function ()
  it('should return the sum of two numbers', function ()
    assert.are_equal(5, sum(2, 3))
  end)
end)
