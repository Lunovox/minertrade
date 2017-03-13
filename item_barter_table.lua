modMinerTrade.bartertable = {
	formspec = {
		main = "size[10,9.5]"..
			"label[3.5,0;MESA DE ESCAMBO\n(Jogador para Jogador)]"..
			"list[current_name;pl1;0,1;3,4;]"..
			"list[current_name;pl2;7,1;3,4;]"..
			"label[1,5;Seu inventario:]"..
			"list[current_player;main;1,5.5;8,4;]",
		pl1 = {
			start = "button[3,1;2.0,1;pl1_start;Abrir]",
			player = function(name) return "label[0,0.5;"..name.." oferece:]" end,
			accept1 = "button[3,1;2,1;pl1_accept1;Oferecer]"..
						 "button[3,2;2,1;pl1_cancel;Cancelar]",
			accept2 = "button[3,1;2,1;pl1_accept2;Confirmar]"..
						 "button[3,2;2,1;pl1_cancel;Cancelar]",
		},
		pl2 = {
			start = "button[5,1;2.0,1;pl2_start;Abrir]",
			player = function(name) return "label[7,0.5;"..name.." oferece:]" end,
			accept1 = "button[5,1;2,1;pl2_accept1;Oferecer]"..
						 "button[5,2;2,1;pl2_cancel;Cancelar]",
			accept2 = "button[5,1;2,1;pl2_accept2;Confirmar]"..
						 "button[5,2;2,1;pl2_cancel;Cancelar]",
		},
	}
}


modMinerTrade.bartertable.getPrivilegios = function(listname,playername,meta)
	if listname == "pl1" then
		if playername ~= meta:get_string("pl1") then
			return false
		elseif meta:get_int("pl1step") ~= 1 then
			return false
		end
	end
	if listname == "pl2" then
		if playername ~= meta:get_string("pl2") then
			return false
		elseif meta:get_int("pl2step") ~= 1 then
			return false
		end
	end
	return true
end

modMinerTrade.bartertable.update_formspec = function(meta)
	local formspec = modMinerTrade.bartertable.formspec.main --10:18:33: ERROR[ServerThread]: Assignment to undeclared global "formspec" inside a function at /home/lunovox/.minetest/mods/lunotrades/bartertable.lua:68.
	local pl_formspec = function (n)
		if meta:get_int(n.."step")==0 then
			formspec = formspec .. modMinerTrade.bartertable.formspec[n].start
		else
			formspec = formspec .. modMinerTrade.bartertable.formspec[n].player(meta:get_string(n))
			if meta:get_int(n.."step") == 1 then
				formspec = formspec .. modMinerTrade.bartertable.formspec[n].accept1
			elseif meta:get_int(n.."step") == 2 then
				formspec = formspec .. modMinerTrade.bartertable.formspec[n].accept2
			end
		end
	end
	pl_formspec("pl1") --10:18:33: ERROR[ServerThread]: Assignment to undeclared global "pl_formspec" inside a function at /home/lunovox/.minetest/mods/lunotrades/bartertable.lua:80.
	pl_formspec("pl2")
	meta:set_string("formspec",formspec)
end

modMinerTrade.bartertable.getInventario = function(inv,list,playername)
	local player = minetest.env:get_player_by_name(playername)
	if player then
		for k,v in ipairs(inv:get_list(list)) do
			player:get_inventory():add_item("main",v)
			inv:remove_item(list,v)
		end
	end
end

modMinerTrade.bartertable.cancel = function(meta)
	modMinerTrade.bartertable.getInventario(meta:get_inventory(),"pl1",meta:get_string("pl1"))
	modMinerTrade.bartertable.getInventario(meta:get_inventory(),"pl2",meta:get_string("pl2"))
	meta:set_string("pl1","")
	meta:set_string("pl2","")
	meta:set_int("pl1step",0)
	meta:set_int("pl2step",0)
end

modMinerTrade.bartertable.exchange = function(meta)
	modMinerTrade.bartertable.getInventario(meta:get_inventory(),"pl1",meta:get_string("pl2"))
	modMinerTrade.bartertable.getInventario(meta:get_inventory(),"pl2",meta:get_string("pl1"))
	meta:set_string("pl1","")
	meta:set_string("pl2","")
	meta:set_int("pl1step",0)
	meta:set_int("pl2step",0)
end

minetest.register_node("minertrade:bartertable", {
	description = "Mesa de Escambo (Jogador para Jogador)",
	tiles = {"balcao_topo.png", "balcao1_baixo.png", "balcao1_lado.png"},
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("infotext", "Mesa de Escambo (Player to Player)")
		meta:set_string("pl1","")
		meta:set_string("pl2","")
		modMinerTrade.bartertable.update_formspec(meta)
		local inv = meta:get_inventory()
		inv:set_size("pl1", 3*4)
		inv:set_size("pl2", 3*4)
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		local meta = minetest.env:get_meta(pos)
		local pl_receive_fields = function(n)
			if fields[n.."_start"] and meta:get_string(n) == "" then
				minetest.sound_play("sfx_alert", {object=sender, max_hear_distance=5.0,})
				meta:set_string(n,sender:get_player_name())
			end
			if meta:get_string(n) == "" then
				meta:set_int(n.."step",0)
			elseif meta:get_int(n.."step")==0 then
				meta:set_int(n.."step",1)
			end
			if sender:get_player_name() == meta:get_string(n) then
				if meta:get_int(n.."step")==1 and fields[n.."_accept1"] then
					minetest.sound_play("sfx_alert", {object=sender, max_hear_distance=5.0,})
					meta:set_int(n.."step",2)
				end
				if meta:get_int(n.."step")==2 and fields[n.."_accept2"] then
					minetest.sound_play("sfx_alert", {object=sender, max_hear_distance=5.0,})
					meta:set_int(n.."step",3)
					if n == "pl1" and meta:get_int("pl2step") == 3 then modMinerTrade.bartertable.exchange(meta) end
					if n == "pl2" and meta:get_int("pl1step") == 3 then modMinerTrade.bartertable.exchange(meta) end
				end
				if fields[n.."_cancel"] then 
					minetest.sound_play("sfx_alert", {object=sender, max_hear_distance=5.0,})
					modMinerTrade.bartertable.cancel(meta) 
				end
			end
		end
		pl_receive_fields("pl1") --10:18:33: ERROR[ServerThread]: Assignment to undeclared global "pl_receive_fields" inside a function at /home/lunovox/.minetest/mods/lunotrades/bartertable.lua:156.
		pl_receive_fields("pl2")
		-- End
		modMinerTrade.bartertable.update_formspec(meta)
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.env:get_meta(pos)
		if not modMinerTrade.bartertable.getPrivilegios(from_list,player:get_player_name(),meta) then return 0 end
		if not modMinerTrade.bartertable.getPrivilegios(to_list,player:get_player_name(),meta) then return 0 end
		return count
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.env:get_meta(pos)
		if not modMinerTrade.bartertable.getPrivilegios(listname,player:get_player_name(),meta) then return 0 end
		return stack:get_count()
	end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.env:get_meta(pos)
		if not modMinerTrade.bartertable.getPrivilegios(listname,player:get_player_name(),meta) then return 0 end
		return stack:get_count()
	end,
})


minetest.register_craft({
	output = 'minertrade:bartertable',
	recipe = {
		{"group:wood"	,"group:wood"},
		{"group:wood"	,"group:wood"},
	}
})

minetest.register_alias("bartertable"		, "minertrade:bartertable")
minetest.register_alias("balcaodeescambo"	, "minertrade:bartertable")
minetest.register_alias("balcaodetroca"	, "minertrade:bartertable")
minetest.register_alias("mesadeescambo"	, "minertrade:bartertable")
minetest.register_alias("mesadetroca"		, "minertrade:bartertable")
