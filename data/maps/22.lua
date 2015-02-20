local map = ...
local game = map:get_game()

---------------------------------------------------------------------------------------------
-- Outside World C14 (Faron Woods/Beach) - Grove Temple Boss (Gohma), Bananas & Tokay Chef --
---------------------------------------------------------------------------------------------

if game:get_value("i1068") == nil then game:set_value("i1068", 0) end

function map:on_started(destination)
  if not game:get_value("b1058") then
    to_book_chamber:set_enabled(false)
    boss_heart:set_enabled(false)
    if destination ~= from_temple_boss then
      -- if not coming from the boss door then deactivate the boss
      if boss_gohma ~= nil then boss_gohma:set_enabled(false) end
    else
      if boss_gohma ~= nil then
	sol.audio.play_music("boss")
	boss_gohma:set_enabled(true)
      end
    end
  end
  if game:get_value("i1068") < 6 then
    npc_tokay_chef:remove()
    to_C15:remove()
  elseif game:get_value("i1068") == 6 then
    to_C15:remove()
  elseif game:get_value("i1068") > 6 then
    gerudo_ship:remove()
    map:set_entities_enabled("ship_block", false)
  end

  if destination == from_house_chef then
    sol.audio.play_music("beach")
  end
end

function npc_tokay_chef:on_interaction()
  game:start_dialog("chef.0.beach")
end

if boss_gohma ~= nil then
 function boss_gohma:on_dead()
  sol.audio.play_sound("boss_killed")
  boss_heart:set_enabled(true)
  sol.timer.start(200, function()
    sol.audio.play_music("faron_woods")
    to_book_chamber:set_enabled(true)
    to_temple_boss:set_enabled(false)
    to_temple_jade:set_enabled(false)
    sol.audio.play_sound("secret")
  end)
  game:set_value("b1058", true)
 end
end
