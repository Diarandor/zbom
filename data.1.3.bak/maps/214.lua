local map = ...
local game = map:get_game()

---------------------------------------------
-- Dungeon 7: Tower of the Winds (Floor 5) --
---------------------------------------------

function map:on_started(destination)
  if not game:get_value("b1173") then chest_key_2:set_enabled(false) end
  warp_chuchu:set_enabled(false)
end

function warp:on_activated()
print("warp activated")
  local hero = map:get_entity("hero")
  if hero:get_direction() == 0 then --east
print("hero east")
    warp:set_destination_name("destination_3")
  elseif hero:get_direction() == 3 then --south
print("hero south")
    warp:set_destination_name("destination_2")
  elseif hero:get_direction() == 2 then -- west
print("hero west")
    warp:set_destination_name("destination_1")
  end
end

function switch_1:on_activated()
  hole_1:remove()
end
function switch_2:on_activated()
  hole_2:remove()
  hole_4:remove()
end
function switch_3:on_activated()
  hole_3:remove()
end

function switch_chest:on_activated()
  chest_key_2:set_enabled(true)
end

for enemy in map:get_entities("chuchu") do
  enemy.on_dead = function()
    if not map:has_entities("chuchu") then
      warp_chuchu:set_enabled(true)
    end
  end
end

function map:on_obtained_treasure(treasure_item, treasure_variant, treasure_savegame_variable)
  if treasure_name == shield then
    hole_item:set_enabled(false)
  end
end
