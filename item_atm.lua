minetest.register_node("minertrade:atm", {
	description = "Caixa Eletronico (ATM) - Guarde o seu dinheiro neste Caixa Eletrônico, e retire seu dinheiro em seu Cofre Pessoal ou qualquer outro Caixa Eletrônico espalhado pelo mapa.",
	--inventory_image =  minetest.inventorycube("text_atm_front_1.png"),
	--inventory_image =  "text_atm_front_1.png",
	paramtype = "light",
	sunlight_propagates = true,
	light_source = default.LIGHT_MAX,
	paramtype2 = "facedir",
	--legacy_facedir_simple = true, --<=Nao sei para que serve!
	tiles = {
		"default_wood.png",
		"default_wood.png",
		"default_wood.png",
		"default_wood.png",
		"default_wood.png",
		"text_atm_front_1.png",
	},
	is_ground_content = false,
	--groups = {cracky=1},
	groups = {cracky=3,oddly_breakable_by_hand=3},
	--sounds = default.node_sound_glass_defaults(),

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
			meta:set_string("infotext", "Caixa Eletronico (ATM) - Guarde o seu dinheiro neste Caixa Eletrônico, e retire seu dinheiro em seu Cofre Pessoal ou qualquer outro Caixa Eletrônico espalhado pelo mapa.")
			local now = os.time() --Em milisegundos
			if not minetest.get_player_privs(playername).server then
				meta:set_string("opentime", now+modMinerTrade.delayConstruct)
			else
				meta:set_string("opentime", now)
			end
			itemstack:take_item() -- itemstack:take_item() = Ok
		else
			minetest.chat_send_player(playername, "[ATM] Voce nao pode por este caixa eletronico muito longe de uma Maquina Dispensadora!")
			--return itemstack -- = Cancel
		end
		
		return itemstack
	end,
	
	on_rightclick = function(pos, node, clicker)
		local playername = clicker:get_player_name()
		local meta = minetest.get_meta(pos)
		local opentime = tonumber(meta:get_string("opentime")) or 0
		local now = os.time() --Em milisegundos
		if now >= opentime or minetest.get_player_privs(playername).server then
			local inv = modMinerTrade.getDetachedInventory(playername)
			minetest.show_formspec(
				playername,
				"safe_"..playername,
				modMinerTrade.getFormspec(playername)
			)
		else
			minetest.chat_send_player(playername, "[ATM] O Caixa Eletronico so vai funcionar "..(opentime-now).." segundos depois de instalado!")
		end
	end,
})

minetest.register_craft({
	output = 'minertrade:atm',
	recipe = {
		{"default:wood"	,"default:wood"				,"default:wood"},
		{"default:wood"	,"default:obsidian_glass"	,"default:wood"},
		{"default:wood"	,"default:mese"				,"default:wood"},
	}
})

minetest.register_alias("atm"					,"minertrade:atm")
minetest.register_alias("atmbox"				,"minertrade:atm")
minetest.register_alias("caixaeletronico"	,"minertrade:atm")
