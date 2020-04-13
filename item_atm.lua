minetest.register_node("minertrade:atm", {
	description = modMinerTrade.translate("PUBLIC ATM\n* Save your money in the ATM, and withdraw your money in your Personal Safe or other ATM in the shops scattered around the map."),
	--inventory_image =  minetest.inventorycube("text_atm_front_1.png"),
	--inventory_image =  "text_atm_front_1.png",
	paramtype = "light",
	sunlight_propagates = true,
	light_source = default.LIGHT_MAX,
	paramtype2 = "facedir",
	
	--legacy_facedir_simple = true, --<=Nao sei para que serve!
	is_ground_content = false,
	groups = {cracky=1},
	--groups = {cracky=3,oddly_breakable_by_hand=3},
	--sounds = default.node_sound_glass_defaults(),
	tiles = {
		--[[
		"default_wood.png",
		"default_wood.png",
		"default_wood.png",
		"default_wood.png",
		"default_wood.png",
		"text_atm_front_1.png",
		--]]
		"safe_side.png",
		"safe_side.png",
		"safe_side.png",
		"safe_side.png",
		"safe_side.png",
		"safe_side.png^text_atm_front.png",
	},

	on_place = function(itemstack, placer, pointed_thing)
		local playername = placer:get_player_name()

		if not pointed_thing.type == "node" then
			return itemstack
		end

		local posAbove = pointed_thing.above --acima
		local posUnder = pointed_thing.under --abaixo
		if not placer or not placer:is_player() or
			not minetest.registered_nodes[minetest.get_node(posAbove).name].buildable_to
		then --Verifica se pode construir sobre os objetos construiveis
			return itemstack
		end
		
		local nodeUnder = minetest.get_node(posUnder)
		if minetest.registered_nodes[nodeUnder.name].on_rightclick then --Verifica se o itema na mao do jogador tem funcao rightclick
			return minetest.registered_nodes[nodeUnder.name].on_rightclick(posUnder, nodeUnder, placer, itemstack)
		end
		
		if 
			minetest.get_player_privs(playername).server 
			or modMinerTrade.getNodesInRange(posAbove, 2, "minertrade:dispensingmachine")>=1 
		then
			local facedir = minetest.dir_to_facedir(placer:get_look_dir())
			--minetest.chat_send_player(playername, "[ATM] aaaaaa")
			minetest.set_node(posAbove, {
				name = "minertrade:atm",
				param2 = facedir,
			})
			local meta = minetest.get_meta(posAbove)
			meta:set_string("infotext", modMinerTrade.translate("PUBLIC ATM\n* Save your money in the ATM, and withdraw your money in your Personal Safe or other ATM in the shops scattered around the map."))
			local now = os.time() --Em milisegundos
			if not minetest.get_player_privs(playername).server then
				meta:set_string("opentime", now+modMinerTrade.delayConstruct)
			else
				meta:set_string("opentime", now)
			end
			itemstack:take_item() -- itemstack:take_item() = Ok
		else
			minetest.chat_send_player(playername, 
				core.colorize("#00ff00", "["..modMinerTrade.translate("ATM").."]: ")
				..modMinerTrade.translate("You can not install this 'ATM' too far from a 'Dispensing Machine'!")
			)
			--return itemstack -- = Cancel
		end
		
		return itemstack
	end,
	
	on_rightclick = function(pos, node, clicker)
		local playername = clicker:get_player_name()
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", modMinerTrade.translate("PUBLIC ATM\n* Save your money in the ATM, and withdraw your money in your Personal Safe or other ATM in the shops scattered around the map."))
		local opentime = tonumber(meta:get_string("opentime")) or 0
		local now = os.time() --Em milisegundos
		if now >= opentime or minetest.get_player_privs(playername).server then
			modMinerTrade.showInventory(
					clicker, 
					playername, 
					modMinerTrade.translate("PUBLIC ATM - Account of '%s':"):format(playername)
				)
		else
			minetest.sound_play("sfx_failure", {object=clicker, max_hear_distance=5.0,})
			minetest.chat_send_player(playername, 
				core.colorize("#00ff00", "["..modMinerTrade.translate("ATM").."]: ")
				..modMinerTrade.translate("The ATM will only run %02d seconds after it is installed!"):format(opentime-now)
			)
		end
	end,
})

minetest.register_craft({
	output = 'minertrade:atm',
	recipe = {
		{"default:steel_ingot"	,"default:steel_ingot"		,"default:steel_ingot"},
		{"default:steel_ingot"	,"default:obsidian_glass"	,"default:steel_ingot"},
		{"default:steel_ingot"	,"default:mese"				,"default:steel_ingot"},
	}
})

minetest.register_alias(
	modMinerTrade.translate("atm"),
	"minertrade:atm"
)
