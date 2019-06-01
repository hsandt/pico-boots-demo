local t = {}
require("game_helper")

function t.sub(a, b)
  return sum(a, b) - 2 * b
end

return t
