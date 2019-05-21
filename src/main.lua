require("helper")

local i = 0

function _init()
  -- init code
end

function _update60()
  print("update: "..tostr(sum(t(), i)))
end

function _draw()
  -- draw code
end
