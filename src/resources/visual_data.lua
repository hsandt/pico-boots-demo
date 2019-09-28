require("engine/core/math")
local sprite_data = require("engine/render/sprite_data")
local animated_sprite_data = require("engine/render/animated_sprite_data")
require("engine/render/color")

local sprites = {
  cursor = sprite_data(sprite_id_location(1, 0)),
  gem = {
    idle   = sprite_data(sprite_id_location(0, 1), nil, vector(4, 4), colors.peach),
    shine1 = sprite_data(sprite_id_location(1, 1), nil, vector(4, 4), colors.peach),
    shine2 = sprite_data(sprite_id_location(2, 1), nil, vector(4, 4), colors.peach),
  }
}

local anim_sprites = {
  gem = {
    idle = animated_sprite_data.create(sprites.gem, {"idle"}),
    shine = animated_sprite_data.create(sprites.gem,
      {"idle", "shine1", "shine2", "shine1"},
      13, true)
  }
}

local visual_data = {
  sprites = sprites,
  anim_sprites = anim_sprites
}

return visual_data
