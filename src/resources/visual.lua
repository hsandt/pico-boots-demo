require("engine/core/math")
local sprite_data = require("engine/render/sprite_data")

local visual = {
  sprites = {
    cursor = sprite_data(sprite_id_location(1, 0))
  }
}

return visual
