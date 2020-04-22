minetest.register_privilege("salary",  {
   description=modMinerTrade.translate("Only players with this privilege will receive a daily payment."), 
   give_to_singleplayer=false,
})

modMinerTrade.payday = {
   salary = (minetest.setting_get("minertrade.payday.salary") or "minertrade:minercoin 1"),
   interval = (tonumber(minetest.setting_get("minertrade.payday.interval")) or 60)
}

minetest.after(3.5, function()
   modMinerTrade.payday.time = 0
   minetest.register_globalstep(function(dtime)
      modMinerTrade.payday.time = modMinerTrade.payday.time + dtime
      if modMinerTrade.payday.time >= modMinerTrade.payday.interval then
         modMinerTrade.payday.time = 0
         local dc = minetest.get_day_count()
         local players = minetest.get_connected_players()
         if #players >= 1 then
            for _, player in ipairs(players) do
               local lp = tonumber(player:get_meta():get_int("last_pay")) or 0
               if lp ~= dc then
                  local playername = player:get_player_name()
                  if minetest.get_player_privs(playername).salary then
                     local nameInvList = "safe"
                     local inv = modMinerTrade.getDetachedInventory(playername)
                     --minetest.chat_send_player(playername, "vazio = "..dump(inv:is_empty(nameInvList)))
                     local stack = ItemStack(modMinerTrade.payday.salary) 
                     local leftover = inv:add_item(nameInvList, stack) 
                     modMinerTrade.setSafeInventory(playername, inv:get_list(nameInvList))
         modMinerTrade.delSafeInventory(playername)
                     if leftover:get_count() > 0 then 
                        minetest.chat_send_player(
                           playername,
                           core.colorize("#00ff00", "["..modMinerTrade.translate("CITY HALL").."]: ")
                           ..modMinerTrade.translate("Your Strongbox is full! %2d items weren't added in your bank account."):format(leftover:get_count())
                        )
                        minetest.sound_play("sfx_alert", {object=player, max_hear_distance=5.0,})
                     else
                        minetest.chat_send_player(
                           playername,
                           core.colorize("#00ff00", "["..modMinerTrade.translate("CITY HALL").."]: ")
                           ..modMinerTrade.translate("The city hall deposited the %2d° salary in your bank account!"):format(dc)
                        )
                        minetest.sound_play("sfx_cash_register", {object=player, max_hear_distance=5.0,})
                     end 
                  end
                  player:get_meta():set_int("last_pay",dc)
               end
            end
         end
      end
   end)
end)







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


