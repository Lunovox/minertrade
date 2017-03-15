minetest.register_privilege("checkstrongbox",  {
	description=modMinerTrade.translate("Lets you check the contents of another players strongbox."), 
	give_to_singleplayer=false,
})

modMinerTrade.propCheckStrongBox = function(playername, param)
		return {
		params = "<PlayerName>",
		description = modMinerTrade.translate("Lets you check the contents of another players strongbox."),
		func = function(playername, param)
			if minetest.get_player_privs(playername).checkstrongbox then
				local targetname = string.match(param, "^([^ ]+)$")
				if type(targetname)=="string" and targetname~="" then
					if modMinerTrade.safe and modMinerTrade.safe[targetname] then

						local inv = modMinerTrade.getDetachedInventory(targetname)
						minetest.show_formspec(
							playername,
							"safe_"..targetname,
							modMinerTrade.getFormspec(targetname)
						)
						return true
					else
						minetest.chat_send_player(playername, "[MINERTRADE:ERRO] "..modMinerTrade.translate("The strongbox of %s was not created yet!"):format(dump(targetname)))
					end
				else
					minetest.chat_send_player(playername, "[MINERTRADE:ERRO] /"..modMinerTrade.translate("checkstrongbox").." <PlayerName> | "..modMinerTrade.translate("Lets you check the contents of another players strongbox."))
				end
			else
				minetest.chat_send_player(playername, "[MINERTRADE:ERRO] "..modMinerTrade.translate("You do not have permission to run this command without the privileges 'checkstrongbox'!"))
			end
			return false
		end,
	}
end

minetest.register_chatcommand(modMinerTrade.translate("checkstrongbox"), modMinerTrade.propCheckStrongBox(playername, param))
minetest.register_chatcommand("csb", modMinerTrade.propCheckStrongBox(playername, param))
