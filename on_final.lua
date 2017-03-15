modMinerTrade.doLoad()

minetest.register_on_leaveplayer(function(player)
	modMinerTrade.doSave()
end)

minetest.register_on_shutdown(function()
	modMinerTrade.doSave()
	minetest.log('action',"[STRONGBOX] "..modMinerTrade.translate("Saving strongbox from all players in the file '%s'!"):format(modMinerTrade.urlTabela))
end)
