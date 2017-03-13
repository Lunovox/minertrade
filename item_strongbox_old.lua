minetest.register_node("strongbox:safe", {
	description = "Cofre (12 Espacos)",
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
		meta:set_string("infotext", "Cofre (Propriedade de "..meta:get_string("owner")..")")
	end,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", "")
		meta:set_string("infotext", "Cofre")
		local inv = meta:get_inventory()
		inv:set_size("main", 6*2)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main") and strongbox.isOpen(meta, player)
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		if not strongbox.isOpen(meta, player) then
			minetest.log("action", 
				player:get_player_name().." tentou mover um objeto no cofre de "..meta:get_string("owner").." em "..minetest.pos_to_string(pos)
			)
			return 0
		end
		return count
	end,
    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if not strongbox.isOpen(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tentou por um objeto no cofre de "..
					meta:get_string("owner").." em "..
					minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if not strongbox.isOpen(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tentou pegar um objeto no cofre de "..
					meta:get_string("owner").." em "..
					minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" moveu um item no cofre em "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" colocou um item no cofre em "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" removeu um item no cofre em "..minetest.pos_to_string(pos))
	end,
	on_rightclick = function(pos, node, clicker)
		local meta = minetest.get_meta(pos)
		if strongbox.isOpen(meta, clicker) then
			minetest.show_formspec(
				clicker:get_player_name(),
				"strongbox:safe",
				strongbox.getFormspec(pos)
			)
		end
	end,
})

minetest.register_craft({
	output = 'strongbox:safe',
	recipe = {
		{"default:steelblock"	,"default:steelblock"	,"default:steelblock"},
		{"default:steelblock"	,""							,"default:mese"},
		{"default:steelblock"	,"default:steelblock"	,"default:steelblock"},
	}
})

minetest.register_alias("strongbox"		,"strongbox:safe")
minetest.register_alias("safe"			,"strongbox:safe")
minetest.register_alias("safeall"		,"strongbox:safe")
minetest.register_alias("safe-all"		,"strongbox:safe")
minetest.register_alias("caixaforte"	,"strongbox:safe")
minetest.register_alias("cofreforte"	,"strongbox:safe")
minetest.register_alias("cofre"			,"strongbox:safe")
