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

minetest.register_chatcommand(modMinerTrade.translate("checkstrongbox"), modMinerTrade.propCheckStrongBox())
minetest.register_chatcommand("csb", modMinerTrade.propCheckStrongBox())

--###############################################################################################################

minetest.register_chatcommand("minertrade", {
	params = "",
	description = "Exibe informações adicionais deste mod.",
	privs = {},
	func = function(name, param)
		minetest.chat_send_player(name, "    ", false)
		minetest.chat_send_player(name, "############################################################################################", false)
		minetest.chat_send_player(name, "### MINERTRADE                                                                           ###", false)
		minetest.chat_send_player(name, "### Desenvolvedor:'Lunovox Heavenfinder'<rui.gravata@gmail.com>                          ###", false)
		minetest.chat_send_player(name, "### Languages: English (Default), Portuguese                                             ###", false)
		minetest.chat_send_player(name, "### Download: https://github.com/Lunovox/minertrade                                      ###", false)
		minetest.chat_send_player(name, "### License GNU AGPL ( https://pt.wikipedia.org/wiki/GNU_Affero_General_Public_License ) ###", false)
		minetest.chat_send_player(name, "############################################################################################", false)
		minetest.chat_send_player(name, "", false)
		minetest.chat_send_player(name, "It adds various types of money, exchange table, Dispensing Machines, Strongbox in homes", false)
		minetest.chat_send_player(name, "interconnected with ATMs in stores.", false)

		minetest.chat_send_player(name, "", false)
		minetest.chat_send_player(name, "TYPES OF MONEYS:", false)
		minetest.chat_send_player(name, "   * Minercoin", false)
		minetest.chat_send_player(name, "   * Minermoney", false)
		minetest.chat_send_player(name, "   * Piggy Bank", false)
		minetest.chat_send_player(name, "   * Credit Card", false)

		minetest.chat_send_player(name, "", false)
		minetest.chat_send_player(name, "Exchange Table (P2P)", false)
		minetest.chat_send_player(name, "   * It makes safe exchanges from player to player without the need to put your items on ", false)
		minetest.chat_send_player(name, "     the ground.", false)

		minetest.chat_send_player(name, "", false)
		minetest.chat_send_player(name, "ADDED ITEMS:", false)
		minetest.chat_send_player(name, "   * Exchange Table (P2P) -> It makes safe exchanges from player to player without the need to put your items on the ground.", false)
		minetest.chat_send_player(name, "   * Dispensing Machine -> Sells your items, even if you are not online.", false)
		minetest.chat_send_player(name, "   * Personal Strongbox -> Save your money in this safe and withdraw your money at any shop that has an ATM.", false)
		minetest.chat_send_player(name, "   * Public ATM -> Save your money in the ATM, and withdraw your money in your Personal Safe or other ATM in the shops scattered around the map.", false)

		minetest.chat_send_player(name, "", false)
		minetest.chat_send_player(name, "############################################################################################", false)
		minetest.chat_send_player(name, name..", precione F10 e use a rolagem do mouse para ler todo este tutorial!!!", false)
	end,
})
