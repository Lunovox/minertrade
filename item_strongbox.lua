minetest.register_node("minertrade:strongbox", {
	description = modMinerTrade.translate("STRONGBOX\n* Save your money in this safe and withdraw your money at any shop that has an ATM."),
	--inventory_image = "safe_front.png",
	
	paramtype = "light",
	sunlight_propagates = true,
	light_source = default.LIGHT_MAX,
	paramtype2 = "facedir",
	
	is_ground_content = false,
	groups = {cracky=1},
	tiles = {
		"safe_side.png",
		"safe_side.png",
		"safe_side.png",
		"safe_side.png",
		"safe_side.png",
		"safe_front.png",
	},
	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		local ownername = placer:get_player_name() or ""
		meta:set_string("owner", ownername)
		meta:set_string("infotext", modMinerTrade.translate("STRONGBOX (Property of '%s')\n* Save your money in this safe and withdraw your money at any shop that has an ATM."):format(ownername))
		local now = os.time() --Em milisegundos
		meta:set_string("opentime", now+modMinerTrade.delayConstruct)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		if modMinerTrade.isOpen(meta, player) then
			return true
		else
			return false
		end
	end,
	on_rightclick = function(pos, node, clicker)
		local playername = clicker:get_player_name()
		local meta = minetest.get_meta(pos)
		local ownername = meta:get_string("owner")
		meta:set_string("infotext", modMinerTrade.translate("STRONGBOX (Property of '%s')\n* Save your money in this safe and withdraw your money at any shop that has an ATM."):format(ownername))
		if modMinerTrade.isOpen(meta, clicker) then
			local opentime = tonumber(meta:get_string("opentime")) or 0
			local now = os.time() --Em milisegundos
			if now >= opentime or minetest.get_player_privs(playername).server then
				modMinerTrade.showInventory(
					clicker, 
					ownername, 
					modMinerTrade.translate("STRONGBOX owned by '%s':"):format(ownername)
				)
			else
				minetest.sound_play("sfx_failure", {object=clicker, max_hear_distance=5.0,})
				minetest.chat_send_player(playername, 
					core.colorize("#00ff00", "["..modMinerTrade.translate("STRONGBOX").."]: ")
					..modMinerTrade.translate("The safe is going to work %02d seconds after it is installed!"):format(opentime-now)
				)
			end
		else
			minetest.sound_play("sfx_failure", {object=clicker, max_hear_distance=5.0,})
			minetest.chat_send_player(playername, 
				core.colorize("#00ff00", "["..modMinerTrade.translate("STRONGBOX").."]: ")
				..modMinerTrade.translate("You do not have access to the safe belonging to '%s'!"):format(ownername)
			)
		end
	end,
})

minetest.register_craft({
	output = 'minertrade:strongbox',
	recipe = {
		{"default:steel_ingot"	,"default:steel_ingot"	,"default:steel_ingot"},
		{"default:steel_ingot"	,""							,"default:mese_crystal"},
		{"default:steel_ingot"	,"default:steel_ingot"	,"default:steel_ingot"},
	}
})

minetest.register_alias(
	modMinerTrade.translate("strongbox"),
	"minertrade:strongbox"
)
