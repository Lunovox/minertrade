modMinerTrade = {
	urlTabela = minetest.get_worldpath().."/minertrade.db", --Extensao '.tbl' ou '.db'
	delayConstruct = 1800, -- Após colocar o atm ou o strongbox no chão existe um intervalo 1800 segundos para começar a utilizá-los.
	size = {
		width = 8, --Slots number of atm and strongbox (Default:6 Max:8)
		height = 4, --Slots number of atm and strongbox (Default:2 Max:4)
	},
}
