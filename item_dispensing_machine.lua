modMinerTrade.dispensing = {
	loja_atual = {}
}
modMinerTrade.dispensing.formspec = {
	customer = function(pos)
		local list_name = "nodemeta:"..pos.x..','..pos.y..','..pos.z
		local formspec = "size[8,10.5]"
		--..default.gui_bg
		--..default.gui_bg_img
		--..default.gui_slots
		.."bgcolor[#004400DD;false]"
		--.."background[-0.5,0;8.5,11;dispensador_frente.png]"
		--listcolors[slot_bg_normal;slot_bg_hover;slot_border;tooltip_bgcolor;tooltip_fontcolor]
		.."listcolors[#00000055;#008800;#FFFFFF]"

		.."label[2,-0.25;MÁQUINA DE DISPENSADORA]"
		.."label[0,0.25;"..minetest.formspec_escape("* "..minetest.env:get_meta(pos):get_string("offer")).."]"
		
		.."label[0,1.0;O Cliente Oferece:]"
		.."list[current_player;customer_gives;0,1.5;3,2;]"
		
		.."label[0,3.5;O Cliente Recebe:]"
		.."list[current_player;customer_gets;0,4.0;3,2;]"

		.."button[3,2.0;2,1;exchange;ACEITAR]"

		.."label[0,6.0;Inventario atual do cliente:]"
		.."list[current_player;main;0,6.5;8,4;]"



		.."label[5,1.0;A Maquina Precisa:]"
		.."list["..list_name..";owner_wants;5,1.5;3,2;]"
		
		.."label[5,3.5;A Maquina Oferece:]"
		.."list["..list_name..";owner_gives;5,4.0;3,2;]"

		--.."listcolors[#00000000;#00000022;#00000000;#00000033;#FFFFFFFF]"
		--.."listcolors[#00000000;#00000033]"
		
		return formspec
	end,
	owner = function(pos)
		local list_name = "nodemeta:"..pos.x..','..pos.y..','..pos.z
		local formspec = "size[8,11]"
		.."bgcolor[#000000CC;false]"
		--listcolors[slot_bg_normal;slot_bg_hover;slot_border;tooltip_bgcolor;tooltip_fontcolor]
		.."listcolors[#88888844;#888888;#FFFFFF]"
		.."label[0,0;Itens Recebido (Seu Lucro):]"
		.."list["..list_name..";customers_gave;0,0.5;3,2;]"
		.."label[0,2.5;Estoque a Oferetar:]"
		.."list["..list_name..";stock;0,3;3,2;]"
		.."label[5,0;Voce Precisa:]"
		.."list["..list_name..";owner_wants;5,0.5;3,2;]"
		.."label[5,2.5;Voce Oferece:]"
		.."list["..list_name..";owner_gives;5,3;3,2;]"
		--.."label[0,5;Proprietario: Pressione (E) + Botao(RMB) no Mouse para a interface com o cliente]"
		--.."label[0,5;Vendedor: Evite o estoque baixo e guardar lucros no balcao.]"
		.."field[0.29,5.75;8,0.85;txtOffer;"
			.."Faça um anúncio sobre o que esta máquina dispensará:;"
			..minetest.formspec_escape(
				minetest.env:get_meta(pos):get_string("offer")
			).."]"
		.."label[0,6.25;Inventario atual do vendedor:]"
		.."list[current_player;main;0,6.75.0;8,4;]"
		.."label[2,10.75;(CTRL + Mouse = Interface do Cliente)]"
		return formspec
	end,
}

modMinerTrade.dispensing.getPrivilegio = function(listname,playername,meta)
	--[[if listname == "pl1" then
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
	end]]
	return true
end


modMinerTrade.dispensing.getInventario = function(inv,list,playername)
	player = minetest.env:get_player_by_name(playername)
	if player then
		for k,v in ipairs(inv:get_list(list)) do
			player:get_inventory():add_item("main",v)
			inv:remove_item(list,v)
		end
	end
end

modMinerTrade.dispensing.cancel = function(meta)
	--[[modMinerTrade.dispensing.getInventario(meta:get_inventory(),"pl1",meta:get_string("pl1"))
	modMinerTrade.dispensing.getInventario(meta:get_inventory(),"pl2",meta:get_string("pl2"))
	meta:set_string("pl1","")
	meta:set_string("pl2","")
	meta:set_int("pl1step",0)
	meta:set_int("pl2step",0)]]
end

modMinerTrade.dispensing.exchange = function(meta)
	--[[modMinerTrade.dispensing.getInventario(meta:get_inventory(),"pl1",meta:get_string("pl2"))
	modMinerTrade.dispensing.getInventario(meta:get_inventory(),"pl2",meta:get_string("pl1"))
	meta:set_string("pl1","")
	meta:set_string("pl2","")
	meta:set_int("pl1step",0)
	meta:set_int("pl2step",0)]]
end

modMinerTrade.dispensing.canOpen = function(pos, playername)
	local meta = minetest.env:get_meta(pos)
	if 
		meta:get_string("owner")==playername 
		or (minetest.get_modpath("tradelands") and modTradeLands.canInteract(pos, playername))
	then
		return true
	end
	return false
end

local box_format = {
	type = "fixed",
	fixed = { {-.5,-.5,-.3125,    .5,.5+1/3,.3125}	}
}

minetest.register_node("minertrade:dispensingmachine", {
	description = "Maquina Dispensadora (Vende itens por você)",
	--tiles = {"balcao_topo.png", "balcao2_baixo.png", "balcao2_lado.png"},
	
	drawtype = "nodebox",
	paramtype = "light", --Nao sei pq, mas o blco nao aceita a luz se nao tiver esta propriedade
	paramtype2 = "facedir",
	sunlight_propagates = true,
	light_source = LIGHT_MAX,
	node_box = box_format,
	selection_box = box_format,
	tiles = {
		"dispensador_cima.png", 
		"dispensador_baixo.png", 
		"dispensador_esquerda.png", 
		"dispensador_direita.png", 
		"dispensador_traz.png", 
		"dispensador_frente_grande.png"--.."^[transformfx"
	},
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	sounds = default.node_sound_wood_defaults(),
	after_place_node = function(pos, placer, itemstack)
		local owner = placer:get_player_name()
		local meta = minetest.env:get_meta(pos)
		meta:set_string("infotext", "Maquina Dispensadora de '"..owner.."'")
		meta:set_string("owner",owner)
		--[[meta:set_string("pl1","")
		meta:set_string("pl2","")]]
		local inv = meta:get_inventory()
		inv:set_size("customers_gave", 3*2)
		inv:set_size("stock", 3*2)
		inv:set_size("owner_wants", 3*2)
		inv:set_size("owner_gives", 3*2)
	end,
	on_rightclick = function(pos, node, clicker, itemstack)
		--print("minertrade:dispensing.on_rightclick aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
		clicker:get_inventory():set_size("customer_gives", 3*2)
		clicker:get_inventory():set_size("customer_gets", 3*2)
		modMinerTrade.dispensing.loja_atual[clicker:get_player_name()] = pos
		local meta = minetest.env:get_meta(pos)
		local clickername = clicker:get_player_name()
		if modMinerTrade.dispensing.canOpen(pos, clickername) and not clicker:get_player_control().aux1 then
			minetest.show_formspec(clickername,"modMinerTrade.balcaodeloja_formspec",modMinerTrade.dispensing.formspec.owner(pos))
		else
			minetest.show_formspec(clickername,"modMinerTrade.balcaodeloja_formspec",modMinerTrade.dispensing.formspec.customer(pos))
		end
		--return itemstack
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local playername = player:get_player_name()
		local meta = minetest.env:get_meta(pos)
		if not modMinerTrade.dispensing.canOpen(pos, playername) then return 0 end
		return count
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local playername = player:get_player_name()
		local meta = minetest.env:get_meta(pos)
		if not modMinerTrade.dispensing.canOpen(pos, playername) then return 0 end
		return stack:get_count()
	end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		local playername = player:get_player_name()
		local meta = minetest.env:get_meta(pos)
		if not modMinerTrade.dispensing.canOpen(pos, playername) then return 0 end
		return stack:get_count()
	end,
	can_dig = function(pos, player)
		local playername = player:get_player_name()
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		local isCanDig = inv:is_empty("stock") and inv:is_empty("customers_gave") and inv:is_empty("owner_wants") and inv:is_empty("owner_gives")
		if isCanDig~=true then
			minetest.chat_send_player(playername,"[AVISO]: A Máquina Dispensadora não pode ser retirada antes de ser esvaziada!")
			minetest.sound_play("sfx_alert", {object=player, max_hear_distance=5.0,})
		end
		return isCanDig
	end
})

minetest.register_on_player_receive_fields(function(sender, formname, fields)
	if formname == "modMinerTrade.balcaodeloja_formspec" then
		local name = sender:get_player_name()
		local pos = modMinerTrade.dispensing.loja_atual[name]
		local meta = minetest.env:get_meta(pos)
		local owner = meta:get_string("owner")
		--minetest.chat_send_player(name,"owner('"..owner.."') == name('"..name.."')")
		
		
		
		
		if modMinerTrade.dispensing.canOpen(pos, name) and sender:get_player_control().aux1 then
			minetest.chat_send_player(name,"Voce nao pode trocar na sua propria maquina!")
			minetest.sound_play("sfx_alert", {object=sender, max_hear_distance=5.0,})
			return
		else
			--minetest.chat_send_player(name,"fields="..dump(fields))
			if fields.txtOffer ~= nil then
				if fields.txtOffer ~= "" then
					meta:set_string("offer", fields.txtOffer)
					meta:set_string("infotext", 
						"Maquina Dispensadora de '"..owner.."'.\n\n"
						--.."Oferta: \n"..
						.."    * "..fields.txtOffer
					)
				else
					meta:set_string("offer", "")
					meta:set_string("infotext", "Maquina Dispensadora de '"..owner.."'.")
				end
			end
			
			
			local minv = meta:get_inventory()
			local pinv = sender:get_inventory()
			local invlist_tostring = function(invlist)
				local out = {}
				for i, item in pairs(invlist) do
					out[i] = item:to_string()
				end
				return out
			end
			local wants = minv:get_list("owner_wants")
			local gives = minv:get_list("owner_gives")
			if wants == nil or gives == nil then return end -- do not crash the server
			-- Check if we can exchange
			local can_exchange = true
			local owners_fault = false
			for i, item in pairs(wants) do
				if not pinv:contains_item("customer_gives",item) then
					can_exchange = false
				end
			end
			for i, item in pairs(gives) do
				if not minv:contains_item("stock",item) then
					can_exchange = false
					owners_fault = true
				end
			end
			if can_exchange then
				for i, item in pairs(wants) do
					pinv:remove_item("customer_gives",item)
					minv:add_item("customers_gave",item)
				end
				for i, item in pairs(gives) do
					minv:remove_item("stock",item)
					pinv:add_item("customer_gets",item)
				end
				minetest.chat_send_player(name,"Escambo feito!")
				minetest.sound_play("sfx_cash_register", {object=sender, max_hear_distance=5.0,})
			elseif fields.quit==nil then
				if owners_fault then
					minetest.chat_send_player(name,"O estoque de '"..owner.."' acabou. Contacte-o!")
				else
					minetest.chat_send_player(name,"O escambo nao pode ser feito. Verifique se voce ofereceu o que a maquina pede!")
				end
				minetest.sound_play("sfx_alert", {object=sender, max_hear_distance=5.0,})
			end
		end
	end
end)

minetest.register_craft({
	output = 'minertrade:dispensingmachine',
	recipe = {
		{"dye:dark_green"	,"default:steel_ingot"	,"default:steel_ingot"},
		{"default:glass"	,""							,"default:steel_ingot"},
		{"dye:dark_green"	,"default:steel_ingot"	,"default:mese"},
		--COMENTaRIO: dye:dark_green = dye:blue[B2] + dye:yellow[C2]
	}
})


minetest.register_alias("maquinadispensadora"	,"minertrade:dispensingmachine")
minetest.register_alias("dispensadora"				,"minertrade:dispensingmachine")
minetest.register_alias("maquinadeloja"			,"minertrade:dispensingmachine")
minetest.register_alias("balcaodeloja"				,"minertrade:dispensingmachine")
minetest.register_alias("caixadeloja"				,"minertrade:dispensingmachine")
minetest.register_alias("loja"						,"minertrade:dispensingmachine")
