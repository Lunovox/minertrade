--[[
minetest.after(3.5, function()
   modMinerTrade.payday = { 
      interval = (60 *24) / (tonumber(minetest.setting_get("time_speed")) or 72),
      time = 0
   }
   modMinerTrade.payday.interval = 1
   minetest.register_globalstep(function(dtime)
      modMinerTrade.payday.time = modMinerTrade.payday.time + dtime
      if modMinerTrade.payday.time >= modMinerTrade.payday.interval then

      end
   end)
end)
--]]

minetest.after(3.5, function()
   local interval = 5
   local time = 0
   minetest.register_globalstep(function(dtime)
      time = time + dtime
      if time >= interval then
         time = 0
         local dc = minetest.get_day_count()
         local players = minetest.get_connected_players()
         local salary = "minertrade:minercoin 1"
         if #players >= 1 then
            for _, player in ipairs(players) do
               local playername = player:get_player_name()
               local inv = modMinerTrade.getSafeInventory(ownername)
               local lp = tonumber(player:get_meta("last_pay")) or 0
               if lp ~= dc then
                  player:set_meta("last_pay",dc)
                  minetest.chat_send_player(
                     playername,
                     core.colorize("#00ff00", "["..modMinerTrade.translate("CITY HALL").."]: ")
                     ..modMinerTrade.translate("The city hall deposited your salary in your bank account!")
                  )
                  minetest.sound_play("sfx_cash_register", {object=player, max_hear_distance=5.0,})
                  inv:add_item("safe_"..playername, salary)
               end
            end
         end
      end
   end)
end)

