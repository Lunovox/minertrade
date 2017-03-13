minetest.register_privilege("checkchest",  {
	description="Jogador pode usar cheat", 
	give_to_singleplayer=false,
})

modMinerTrade.doCheckStrongBox = function(playername, param)
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
			minetest.chat_send_player(playername, "[STRONGBOX:ERRO] O cofre de "..dump(targetname).." nao foi criado ainda!")
		end
	else
		minetest.chat_send_player(playername, "[STRONGBOX:ERRO] /checkstrongbox <PlayerName>")
	end
	return false
end

minetest.register_chatcommand("checkstrongbox", {
	params = "<JogadorAlvo>",
	description = "verifica o Cofre do jogador alvo",
	privs = {checkchest=true},
	func = function(playername, param)
		return modMinerTrade.doCheckStrongBox(playername, param)
	end,
})

minetest.register_chatcommand("csb", {
	params = "<JogadorAlvo>",
	description = "verifica o Cofre do jogador alvo",
	privs = {checkchest=true},
	func = function(playername, param)
		return modMinerTrade.doCheckStrongBox(playername, param)
	end,
})

minetest.register_chatcommand("checarcofre", {
	params = "<JogadorAlvo>",
	description = "verifica o Cofre do jogador alvo",
	privs = {checkchest=true},
	func = function(playername, param)
		return modMinerTrade.doCheckStrongBox(playername, param)
	end,
})
