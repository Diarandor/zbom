local entity = ...
local map = entity:get_map()
local pushing = false

-- Ice block: special block made of ice that can fill a
-- somaria pit, turn lava solid, and possibly other things.

function entity:on_created()
  self:set_size(16, 16)
  self:snap_to_grid()
  self:set_modified_ground("ice") --is this useful?
  self:set_traversable_by("hero", false)
  self:set_traversable_by("custom_entity", true) --to allow pushing block into pit
  self:create_sprite("entities/ice_block")

  self:add_collision_test("facing", function(self, other)
    if other:get_type() == "hero" and not pushing then
      pushing = true
      local m = sol.movement.create("path")
      m:set_ignore_obstacles(false)
      m:set_snap_to_grid(true)

      if other:get_direction() == 0 then m:set_path({0,0})
      elseif other:get_direction() == 1 then m:set_path({2,2})
      elseif other:get_direction() == 2 then m:set_path({4,4})
      elseif other:get_direction() == 3 then m:set_path({6,6}) end
      m:start(self, function()
	pushing = false
      end)
    end
  end)

  self:add_collision_test("overlapping", function(self, other)
    local crust, switch
    if other:get_type() == "dynamic_tile" then
      local lpx, lpy, lpl = other:get_position()
      local lsx, lsy, lsl = other:get_size()
      self:clear_collision_tests()
      local sx, sy, sl = self:get_position()
      self:remove()
      if (sy < lpy + 32 or sy > lpy - 32) then
	if map:get_hero():get_direction() == 3 then
          crust = map:create_dynamic_tile({ x = sx-16, y = sy, layer = sl, width = 32, height = 32, pattern = "lava_crust", enabled_at_start = true })
	elseif map:get_hero():get_direction() == 1 then
          crust = map:create_dynamic_tile({ x = sx-16, y = sy-48, layer = sl, width = 32, height = 32, pattern = "lava_crust", enabled_at_start = true })
	elseif map:get_hero():get_direction() == 0 then
          crust = map:create_dynamic_tile({ x = sx+8, y = sy-16, layer = sl, width = 32, height = 32, pattern = "lava_crust", enabled_at_start = true })
	elseif map:get_hero():get_direction() == 2 then
          crust = map:create_dynamic_tile({ x = sx-40, y = sy-16, layer = sl, width = 32, height = 32, pattern = "lava_crust", enabled_at_start = true })
	end
        crust:snap_to_grid()
        sol.audio.play_sound("freeze")
	sol.timer.start(map, 15000, function()
	  crust:remove()
	end)
      end
    elseif other:get_type() == "fire" then
      sol.audio.play_sound("ice_melt")
      self:remove()
    elseif other:get_type() == "explosion" then
      sol.audio.play_sound("ice_melt")
      self:remove()
    end
  end)
end

--function entity:on_position_changed()
--  for switch in map:get_entities("switch") do
--    switch.active = false
--    if not self:overlaps(switch) then
--      switch:set_activated(false)
--      if switch:on_inactivated() ~= nil and switch.active then switch:on_inactivated() end
--    else
--      switch:set_activated(true)
--      if switch:on_activated() ~= nil and not switch.active then
--	switch:on_activated()
--	switch.active = true
--      end
--    end
--  end
--end

function entity:on_removed()
  --melting animation
end
