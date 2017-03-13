minetest.register_privilege("checkstrongbox",  {
	description="Permite verificar o conteúdo do cofre de outro jogador", 
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
	description = "Verifica o conteúdo do cofre de um jogador",
	privs = {checkstrongbox=true},
	func = function(playername, param)
		return modMinerTrade.doCheckStrongBox(playername, param)
	end,
})

minetest.register_chatcommand("csb", {
	params = "<JogadorAlvo>",
	description = "Verifica o conteúdo do cofre de um jogador",
	privs = {checkstrongbox=true},
	func = function(playername, param)
		return modMinerTrade.doCheckStrongBox(playername, param)
	end,
})

minetest.register_chatcommand("checarcofre", {
	params = "<JogadorAlvo>",
	description = "Verifica o conteúdo do cofre de um jogador",
	privs = {checkstrongbox=true},
	func = function(playername, param)
		return modMinerTrade.doCheckStrongBox(playername, param)
	end,
})
