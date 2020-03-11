local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)

dofile(modpath.."/config.lua") -- <== Antes de carregar tudo!
dofile(modpath.."/translate.lua") -- <== Antes de 'api.lua'!
dofile(modpath.."/api.lua")
dofile(modpath.."/item_atm.lua")
dofile(modpath.."/item_strongbox.lua")
--dofile(modpath.."/item_strongbox_old.lua")


dofile(modpath.."/item_miner_cash.lua")
dofile(modpath.."/item_exchange_table.lua")
dofile(modpath.."/item_dispensing_machine.lua")
-- --dofile(path.."/item_rent_door.lua")

dofile(modpath.."/payday.lua") -- <== Pay diary per playing in server.
dofile(modpath.."/commands.lua")
dofile(modpath.."/on_final.lua") -- <== Only after load all code!

minetest.log('action',"["..modname:upper().."] Loaded!")
