minetest.register_node("minertrade:strongbox", {
	description = "Cofre - Guarde seu dinheiro neste cofre e retire seu dinheiro em qualquer loja que possua um Caixa Eletrônico",
	--inventory_image = "safe_front.png",
	paramtype = "light",
	paramtype2 = "facedir",
	tiles = {
		"safe_side.png",
		"safe_side.png",
		"safe_side.png",
		"safe_side.png",
		"safe_side.png",
		"safe_front.png",
	},
	is_ground_content = false,
	groups = {cracky=1},
	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Cofre (Propriedade de "..meta:get_string("owner")..") - Guarde seu dinheiro neste cofre e retire seu dinheiro em qualquer loja que possua um Caixa Eletrônico.")
		local now = os.time() --Em milisegundos
		meta:set_string("opentime", now+modMinerTrade.delayConstruct)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		if modMinerTrade.isOpen(meta, player) then
			--local inv = meta:get_inventory()
			--inv:set_list("safe", { })
			--return inv:is_empty("main") and modMinerTrade.isOpen(meta, player)
			return true
		else
			return false
		end
	end,
	on_rightclick = function(pos, node, clicker)
		local playername = clicker:get_player_name()
		local meta = minetest.get_meta(pos)
		local ownername = meta:get_string("owner")
		if modMinerTrade.isOpen(meta, clicker) then
			local opentime = tonumber(meta:get_string("opentime")) or 0
			local now = os.time() --Em milisegundos
			if now >= opentime or minetest.get_player_privs(playername).server then
				local inv = modMinerTrade.getDetachedInventory(ownername)
				minetest.show_formspec(
					playername,
					"safe_"..ownername,
					modMinerTrade.getFormspec(ownername)
				)
			else
				minetest.chat_send_player(playername, "[COFRE] O cofre so vai funcionar "..(opentime-now).." segundos depois de instalado!")
			end
		else
			minetest.chat_send_player(playername, "[COFRE] Este cofre pertence a '"..ownername.."'!")
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

minetest.register_alias("strongbox"		,"minertrade:strongbox")
minetest.register_alias("cofre"			,"minertrade:strongbox")
minetest.register_alias("cofreforte"	,"minertrade:strongbox")
minetest.register_alias("caixaforte"	,"minertrade:strongbox")
