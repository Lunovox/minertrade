lunotrades.rentdoorformspec = {
	renter = function(pos)
		local list_name = "nodemeta:"..pos.x..','..pos.y..','..pos.z
		local formspec = "size[8,10]"..
		"label[2.5,0;PORTAL DE ALUGUEL]"..
		
		--"label[0,0.5;O Locatador Oferece:]"..
		--"list[current_player;customer_gives;0,1;3,2;]"..
		--"label[0,3;O Cliente Recebe:]"..
		--"list[current_player;customer_gets;0,3.5;3,2;]"..
		
		"button[3,1.5;2,1;exchange;ACEITAR]"..
		
		"label[5,0.5;O Locatario Precisa:]"..
		"list["..list_name..";owner_wants;5,1;3,2;]"..
		--"label[5,3;A Maquina Oferece:]"..
		--"list["..list_name..";owner_gives;5,3.5;3,2;]"..

		"label[0,5.5;Inventario atual do cliente:]"..
		"list[current_player;main;0,6.0;8,4;]"
		
		return formspec
	end,
	owner = function(pos)
		local list_name = "nodemeta:"..pos.x..','..pos.y..','..pos.z
		local formspec = "size[8,10]"..
		
		"label[0,0;Voce Recebe (Seu Lucro):]"..
		"list["..list_name..";customers_gave;0,0.5;3,2;]"..

		--"label[0,2.5;Estoque a Oferetar:]"..
		--"list["..list_name..";stock;0,3;3,2;]"..

		"label[5,0;Voce aluga por:]"..
		"list["..list_name..";owner_wants;5,0.5;3,2;]"..

		--"label[5,2.5;Voce Oferece:]"..
		--"list["..list_name..";owner_gives;5,3;3,2;]"..

		--"label[2,5;(CTRL + Mouse = Interface do Cliente)]"..
		"label[0,5.5;Inventario atual do locatario:]"..
		"list[current_player;main;0,6;8,4;]"
		return formspec
	end,
}

function lunotrades.doCTRLRightClick(pos, node, clicker)
	if (
		minetest.get_modpath("landrush") 
		and type(landrush.get_owner)=="function" 
		and landrush.get_owner(pos)~=nil 
		and landrush.get_owner(pos)~="" 
	) then
		
		clicker:get_inventory():set_size("customer_gives", 3*2)
		clicker:get_inventory():set_size("customer_gets", 3*2)
		lunotrades.balcaodeloja.loja_atual[clicker:get_player_name()] = pos
		local meta = minetest.env:get_meta(pos)

		local inv = meta:get_inventory()
		if inv:is_empty("customers_gave") then
			inv:set_size("customers_gave", 3*2)
		end
		--inv:set_size("stock", 3*2)
		if inv:is_empty("owner_wants") then
			inv:set_size("owner_wants", 3*2)
		end
		--inv:set_size("owner_gives", 3*2)

		if landrush.get_owner(pos)~=clicker:get_player_name() then
			--minetest.chat_send_player(clicker:get_player_name(), "aaaaa Vc nao ser o proprietario!")
			minetest.show_formspec(clicker:get_player_name(),"lunotrades.rentdoor_formspec",lunotrades.rentdoorformspec.renter(pos))
		else
			--minetest.chat_send_player(clicker:get_player_name(), "bbbbb Vc SER o proprietario!")
			minetest.show_formspec(clicker:get_player_name(),"lunotrades.rentdoor_formspec",lunotrades.rentdoorformspec.owner(pos))
		end
	end
end

function lunotrades.ifOpenDoor(pos, clicker)
	if (
		not minetest.get_modpath("landrush") 
		or type(landrush.get_owner)~="function" 
		or landrush.get_owner(pos)==nil 
		or landrush.get_owner(pos)=="" 
		or landrush.get_owner(pos)==clicker:get_player_name()
	) then
		return true
	else
		local playername = clicker:get_player_name()
		local meta = minetest.get_meta(pos)
		local renter = meta:get_string("renter") --Jogador locatario
		local expiration = meta:get_string("expiration") --Jogador locatario
		local now = os.time()

		--minetest.chat_send_player(clicker:get_player_name(), "Proprietario '"..dump(landrush.get_owner(pos)).."'!")

		
		if expiration==nil or expiration=="" or now <= expiration then
			if renter == playername then
				return true
			else
				minetest.chat_send_player(clicker:get_player_name(), "Voce nao pode abrir esta porta alugada por '"..renter.."'!")
				minetest.sound_play("sfx_falha", {object = clicker, gain = 2.0, max_hear_distance = 10})
			end
		else
			minetest.chat_send_player(
				clicker:get_player_name(), 
				"Seu tempo de aluguel desta porta acabou. Favor segure CTRL e clique sobre a porta para pagar nova temporada de aluguel para '"..dump(landrush.get_owner(pos)).."'!"
			)
			minetest.sound_play("sfx_falha", {object = clicker, gain = 2.0, max_hear_distance = 10})
		end
		return false
		
		--[[
		meta:set_string("infotext", "Owned by "..playername)
		meta = minetest.get_meta(pt2)
		meta:set_string("doors_owner", playername)
		meta:set_string("infotext", "Owned by "..playername)

		minetest.chat_send_player(clicker:get_player_name(), "Essa comeia nao pertece a voce!")
 		minetest.sound_play("sfx_falha", {object = clicker, gain = 2.0, max_hear_distance = 10})
 		]]--
	end
end

function lunotrades.doOpenDoor(pos, dir, replace, replace_dir, params)
	local p2 = minetest.get_node(pos).param2
	p2 = params[p2+1]

	local meta = minetest.get_meta(pos):to_table()
	minetest.set_node(pos, {name=replace_dir, param2=p2})
	minetest.get_meta(pos):from_table(meta)

	pos.y = pos.y-dir
	meta = minetest.get_meta(pos):to_table()
	minetest.set_node(pos, {name=replace, param2=p2})
	minetest.get_meta(pos):from_table(meta)
end

function lunotrades.on_rightclick(pos, dir, check_name, replace, replace_dir, params)
	pos.y = pos.y+dir
	if not minetest.get_node(pos).name == check_name then
		return
	end
	lunotrades.doOpenDoor(pos, dir, replace, replace_dir, params)
end

doors.register_door("lunotrades:rent_door", {
	description = "Porta de Aluguel (Aux+RightClick para Alugar)",
	inventory_image = "rent_door_inv.png",
	--groups = {snappy=1,bendy=2,cracky=1,melty=2,level=2,door=1},
	groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,door=1},
	tiles_bottom = {"rent_door_b.png", "rent_door_side.png"},
	tiles_top = {"rent_door_a.png", "rent_door_side.png"},
	sounds = default.node_sound_wood_defaults(),
	sound_open_door = "sfx_door_open",
	sound_close_door = "sfx_door_close",
	sunlight = false,
})

local instancias = {"lunotrades:rent_door_b_1", "lunotrades:rent_door_t_1", "lunotrades:rent_door_b_2", "lunotrades:rent_door_t_2"}

for _,ItemID in ipairs(instancias) do
	print("rent_door.ItemID="..ItemID)
	if minetest.registered_items[ItemID] ~= nil then
		local props = minetest.registered_items[ItemID]
		--[[
		props.allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
			local playername = player:get_player_name()
			local meta = minetest.env:get_meta(pos)
			if player:get_player_name() ~= meta:get_string("owner") then return 0 end
			return count
		end,
		props.allow_metadata_inventory_put = function(pos, listname, index, stack, player)
			local playername = player:get_player_name()
			local meta = minetest.env:get_meta(pos)
			if player:get_player_name() ~= meta:get_string("owner") then return 0 end
			return stack:get_count()
		end,
		props.allow_metadata_inventory_take = function(pos, listname, index, stack, player)
			local playername = player:get_player_name()
			local meta = minetest.env:get_meta(pos)
			if player:get_player_name() ~= meta:get_string("owner") then return 0 end
			return stack:get_count()
		end,
		]]--
		minetest.register_node(":"..ItemID, props)
	end
end

minetest.register_craft({
	output = 'lunotrades:rent_door',
	recipe = {
		{'default:steel_ingot','default:steel_ingot',''},
		{'default:steel_ingot','lunotrades:moneybag"',''},
		{'default:steel_ingot','default:steel_ingot',''}
	}
})

minetest.registered_nodes['lunotrades:rent_door_b_1'].on_rightclick = function(pos, node, clicker)
	if not clicker:get_player_control().aux1 then
		if lunotrades.ifOpenDoor(pos, clicker) then
			lunotrades.on_rightclick(pos, 1, "lunotrades:rent_door_t_1", "lunotrades:rent_door_b_2", "lunotrades:rent_door_t_2", {1,2,3,0})
		end
	else
		lunotrades.doCTRLRightClick(pos, node, clicker)
	end
end

minetest.registered_nodes['lunotrades:rent_door_t_1'].on_rightclick = function(pos, node, clicker)
	if not clicker:get_player_control().aux1 then
		if lunotrades.ifOpenDoor(pos, clicker) then
			lunotrades.on_rightclick(pos, -1, "lunotrades:rent_door_b_1", "lunotrades:rent_door_t_2", "lunotrades:rent_door_b_2", {1,2,3,0})
		end
	else
		lunotrades.doCTRLRightClick(pos, node, clicker)
	end
end

-- Fix for duplicating Bug!
-- Bug was caused, because the reverse order of the on_rightclick was not taken into account

minetest.registered_nodes['lunotrades:rent_door_b_2'].on_rightclick = function(pos, node, clicker)
	if not minetest.get_modpath("landrush") or landrush.can_interact(pos,clicker:get_player_name()) then
		lunotrades.on_rightclick(pos, 1, "lunotrades:rent_door_t_2", "lunotrades:rent_door_b_1", "lunotrades:rent_door_t_1", {3,0,1,2})
	end
end

minetest.registered_nodes['lunotrades:rent_door_t_2'].on_rightclick = function(pos, node, clicker)
	if not minetest.get_modpath("landrush") or landrush.can_interact(pos,clicker:get_player_name()) then
		lunotrades.on_rightclick(pos, -1, "lunotrades:rent_door_b_2", "lunotrades:rent_door_t_1", "lunotrades:rent_door_b_1", {3,0,1,2})
	end
end 
