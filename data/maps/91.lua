local map = ...
local game = map:get_game()
local poe_guided
local position_step = 1
local positions = {
  { x = 1040, y = 544 },
  { x = 928, y = 800 },
  { x = 696, y = 896 },
  { x = 408, y = 1000 },
  { x = 456, y = 608 },
  { x = 448, y = 408 },
  { x = 544, y = 216 },
  { x = 384, y = 184 },
  { x = 184, y = 136 },
  { x = 192, y = 0 }
}

--------------------------------------------
-- Outside World B4 (Forest of Deception) --
--------------------------------------------

if game.deception_fog_overlay == nil then
  if game:get_item("bottle_1"):get_variant() == 8 or -- If hero has a Poe Soul,
   game:get_item("bottle_2"):get_variant() == 8 or -- then it's easier to see.
   game:get_item("bottle_3"):get_variant() == 8 or
   game:get_item("bottle_4"):get_variant() == 8 then
    game.deception_fog_overlay = sol.surface.create("effects/fog.png")
    game.deception_fog_overlay:set_opacity(168)
    poe_guided = true
  else
    game.deception_fog_overlay = sol.surface.create("effects/fog.png")
    game.deception_fog_overlay:set_opacity(216)
    poe_guided = false
    poe_guide:remove()
  end
end

function map:on_started(destination)
  local hero_x, hero_y = map:get_hero():get_position()
  if hero_y > 16 then  -- If coming from the north end of the map, fog is already present.
    if game.deception_fog_overlay then game.deception_fog_overlay:fade_in(150, function()
      if poe_guided then game.deception_fog_overlay:set_opacity(168) else game.deception_fog_overlay:set_opacity(216) end
    end) end
  end
end

local function next_poe_step()
  position_step = position_step + 1
  if position_step <= 10 then
    local position = (positions[position_step])
    local m = sol.movement.create("target")
    m:set_speed(40)
    m:set_smooth(true)
    m:set_target(position.x, position.y)
    poe_guide:get_sprite():set_animation("walking")
    m:start(poe_guide)
    sol.timer.start(map, 8000, function() next_poe_step() end)
  end
end

function sensor_poe_guide:on_activated()
  if hero:get_direction() == 1 then -- Only start if hero is facing up (coming from Maruge Swamp).
    game:start_dialog("poe.0.forest_deception")
    local position = (positions[position_step])
    local m = sol.movement.create("target")
    m:set_speed(48)
    m:set_smooth(true)
    m:set_target(position.x, position.y)
    poe_guide:get_sprite():set_animation("walking")
    m:start(poe_guide)
    sol.timer.start(map, 5000, function() next_poe_step() end)
  end
end

function to_C4:on_activated()
  game.deception_fog_overlay:fade_out(150)
  sol.timer.start(game, 1000, function() game.deception_fog_overlay = nil end)
end

function map:on_draw(dst_surface)
  if game.deception_fog_overlay ~= nil then game.deception_fog_overlay:draw(dst_surface) end
end