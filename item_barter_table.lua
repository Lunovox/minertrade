lunotrades.balcaodeescambo = {}
lunotrades.balcaodeescambo.formspec = {
--[[
	main = "size[8,9]"..
		"list[current_name;pl1;0,0;3,4;]"..
		"list[current_name;pl2;5,0;3,4;]"..
		"list[current_player;main;0,5;8,4;]",
	pl1 = {
		start = "button[3,1;2,1;pl1_start;Oferecer]",
		player = function(name) return "label[3,0;"..name.."]" end,
		accept1 = "button[3,1;2,1;pl1_accept1;Confirmar]"..
					 "button[3,2;2,1;pl1_cancel;Cancelar]",
		accept2 = "button[3,1;2,1;pl1_accept2;Trocar]"..
					 "button[3,2;2,1;pl1_cancel;Cancelar]",
	},
	pl2 = {
		start = "button[4,1;2,1;pl2_start;Oferecer]",
		player = function(name) return "label[4,0;"..name.."]" end,
		accept1 = "button[4,1;2,1;pl2_accept1;Confirmar]"..
					 "button[4,2;2,1;pl2_cancel;Cancelar]",
		accept2 = "button[4,1;2,1;pl2_accept2;Trocar]"..
					 "button[4,2;2,1;pl2_cancel;Cancelar]",
	},
--]]
	main = "size[10,9.5]"..
		"label[3.5,0;MESA DE ESCAMBO (P2P)]"..
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

lunotrades.balcaodeescambo.getPrivilegios = function(listname,playername,meta)
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

lunotrades.balcaodeescambo.update_formspec = function(meta)
	local formspec = lunotrades.balcaodeescambo.formspec.main --10:18:33: ERROR[ServerThread]: Assignment to undeclared global "formspec" inside a function at /home/lunovox/.minetest/mods/lunotrades/balcaodeescambo.lua:68.
	local pl_formspec = function (n)
		if meta:get_int(n.."step")==0 then
			formspec = formspec .. lunotrades.balcaodeescambo.formspec[n].start
		else
			formspec = formspec .. lunotrades.balcaodeescambo.formspec[n].player(meta:get_string(n))
			if meta:get_int(n.."step") == 1 then
				formspec = formspec .. lunotrades.balcaodeescambo.formspec[n].accept1
			elseif meta:get_int(n.."step") == 2 then
				formspec = formspec .. lunotrades.balcaodeescambo.formspec[n].accept2
			end
		end
	end
	pl_formspec("pl1") --10:18:33: ERROR[ServerThread]: Assignment to undeclared global "pl_formspec" inside a function at /home/lunovox/.minetest/mods/lunotrades/balcaodeescambo.lua:80.
	pl_formspec("pl2")
	meta:set_string("formspec",formspec)
end

lunotrades.balcaodeescambo.getInventario = function(inv,list,playername)
	local player = minetest.env:get_player_by_name(playername)
	if player then
		for k,v in ipairs(inv:get_list(list)) do
			player:get_inventory():add_item("main",v)
			inv:remove_item(list,v)
		end
	end
end

lunotrades.balcaodeescambo.cancel = function(meta)
	lunotrades.balcaodeescambo.getInventario(meta:get_inventory(),"pl1",meta:get_string("pl1"))
	lunotrades.balcaodeescambo.getInventario(meta:get_inventory(),"pl2",meta:get_string("pl2"))
	meta:set_string("pl1","")
	meta:set_string("pl2","")
	meta:set_int("pl1step",0)
	meta:set_int("pl2step",0)
end

lunotrades.balcaodeescambo.exchange = function(meta)
	lunotrades.balcaodeescambo.getInventario(meta:get_inventory(),"pl1",meta:get_string("pl2"))
	lunotrades.balcaodeescambo.getInventario(meta:get_inventory(),"pl2",meta:get_string("pl1"))
	meta:set_string("pl1","")
	meta:set_string("pl2","")
	meta:set_int("pl1step",0)
	meta:set_int("pl2step",0)
end

minetest.register_node("lunotrades:balcaodeescambo", {
	description = "Mesa de Escambo (Player to Player)",
	tiles = {"balcao_topo.png", "balcao1_baixo.png", "balcao1_lado.png"},
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("infotext", "Mesa de Escambo (Player to Player)")
		meta:set_string("pl1","")
		meta:set_string("pl2","")
		lunotrades.balcaodeescambo.update_formspec(meta)
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
					if n == "pl1" and meta:get_int("pl2step") == 3 then lunotrades.balcaodeescambo.exchange(meta) end
					if n == "pl2" and meta:get_int("pl1step") == 3 then lunotrades.balcaodeescambo.exchange(meta) end
				end
				if fields[n.."_cancel"] then 
					minetest.sound_play("sfx_alert", {object=sender, max_hear_distance=5.0,})
					lunotrades.balcaodeescambo.cancel(meta) 
				end
			end
		end
		pl_receive_fields("pl1") --10:18:33: ERROR[ServerThread]: Assignment to undeclared global "pl_receive_fields" inside a function at /home/lunovox/.minetest/mods/lunotrades/balcaodeescambo.lua:156.
		pl_receive_fields("pl2")
		-- End
		lunotrades.balcaodeescambo.update_formspec(meta)
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.env:get_meta(pos)
		if not lunotrades.balcaodeescambo.getPrivilegios(from_list,player:get_player_name(),meta) then return 0 end
		if not lunotrades.balcaodeescambo.getPrivilegios(to_list,player:get_player_name(),meta) then return 0 end
		return count
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.env:get_meta(pos)
		if not lunotrades.balcaodeescambo.getPrivilegios(listname,player:get_player_name(),meta) then return 0 end
		return stack:get_count()
	end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.env:get_meta(pos)
		if not lunotrades.balcaodeescambo.getPrivilegios(listname,player:get_player_name(),meta) then return 0 end
		return stack:get_count()
	end,
})


--[[
minetest.register_craft({
	output = 'lunotrades:balcaodeescambo',
	recipe = {
		{"group:wood"		,"group:wood"	,"group:wood"},
		{"default:stick"	,"wool:red"		,"default:stick"},
		{"default:stick"	,"wool:red"		,"default:stick"},
	}
})
]]--
minetest.register_craft({
	output = 'lunotrades:balcaodeescambo',
	recipe = {
		{"group:wood"	,"group:wood"},
		{"group:wood"	,"group:wood"},
	}
})



minetest.register_alias("balcaodeescambo"	, "lunotrades:balcaodeescambo")
minetest.register_alias("balcaodetroca"	, "lunotrades:balcaodeescambo")
minetest.register_alias("mesadeescambo"	, "lunotrades:balcaodeescambo")
minetest.register_alias("mesadetroca"		, "lunotrades:balcaodeescambo")
