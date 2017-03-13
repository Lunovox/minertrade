local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)



dofile(modpath.."/config.lua")
dofile(modpath.."/api.lua")
dofile(modpath.."/commands.lua")
dofile(modpath.."/item_atm.lua")
dofile(modpath.."/item_strongbox.lua")
--dofile(modpath.."/item_strongbox_old.lua")


dofile(modpath.."/item_miner_cash.lua")
-- dofile(modpath.."/item_barter_table.lua")
dofile(modpath.."/item_dispensing_machine.lua")
-- --dofile(path.."/item_rent_door.lua")



modMinerTrade.doLoad()

minetest.register_on_leaveplayer(function(player)
	modMinerTrade.doSave()
end)

minetest.register_on_shutdown(function()
	modMinerTrade.doSave()
	minetest.log('action',"[STRONGBOX] Salvando cofre de todos os jogadores no arquivo '"..modMinerTrade.urlTabela.."'!")
end)

minetest.log('action',"["..modname:upper().."] Carregado!")
