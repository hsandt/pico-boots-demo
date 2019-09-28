require("engine/core/math")
local sprite_data = require("engine/render/sprite_data")
local animated_sprite_data = require("engine/render/animated_sprite_data")
require("engine/render/color")

local sprites = {
  cursor = sprite_data(sprite_id_location(1, 0)),
  gem = {
    idle   = sprite_data(sprite_id_location(0, 1), nil, vector(4, 4), colors.peach),
    idle1  = sprite_data(sprite_id_location(1, 1), nil, vector(4, 4), colors.peach),  -- glitter +
    idle2  = sprite_data(sprite_id_location(2, 1), nil, vector(4, 4), colors.peach),  -- glitter x
    spin1  = sprite_data(sprite_id_location(0, 2), nil, vector(4, 4), colors.peach),
    spin2  = sprite_data(sprite_id_location(1, 2), nil, vector(4, 4), colors.peach),
    spin3  = sprite_data(sprite_id_location(2, 2), nil, vector(4, 4), colors.peach),
  }
}

local anim_sprites = {
  gem = {
    idle = animated_sprite_data.create(sprites.gem,
      {"idle", "idle1", "idle2", "idle1"},
      13, true),
    spin = animated_sprite_data.create(sprites.gem,
      {"idle", "spin1", "spin2", "spin3"},
      13, true)
  }
}

local visual_data = {
  sprites = sprites,
  anim_sprites = anim_sprites
}

return visual_data
