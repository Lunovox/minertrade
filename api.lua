--FONTE: https://forum.minetest.net/viewtopic.php?pid=48124

minetest.register_privilege("checkchest",  {
	description=modMinerTrade.translate("Permission to open locked chests of other players"), 
	give_to_singleplayer=false,
})

modMinerTrade.safe = {}

modMinerTrade.getNodesInRange = function(pos, search_distance, node_name)
	if pos==nil then return 0 end
	if pos.x==nil or type(pos.x)~="number" then return 0 end
	if pos.y==nil or type(pos.y)~="number" then return 0 end
	if pos.z==nil or type(pos.z)~="number" then return 0 end
	if search_distance==nil or type(search_distance)~="number" and search_distance<=0 then return 0 end
	if node_name==nil or type(node_name)~="string" and node_name=="" then return 0 end

	local minp = {x=pos.x-search_distance,y=pos.y-search_distance, z=pos.z-search_distance}
	local maxp = {x=pos.x+search_distance,y=pos.y+search_distance, z=pos.z+search_distance}
	local nodes = minetest.env:find_nodes_in_area(minp, maxp, node_name)
	return #nodes
end

modMinerTrade.doSave = function()
	local file = io.open(modMinerTrade.urlTabela, "w")
	if file then
		file:write(minetest.serialize(modMinerTrade.safe))
		file:close()
		--minetest.log('action',"[MINERTRADE] Banco de dados salvo !")
	else
		minetest.log('error',"[MINERTRADE:ERRO] "..modMinerTrade.translate("The file '%s' is not in table format!"):format(modMinerTrade.urlTabela))
	end
end

modMinerTrade.doLoad = function()
	local file = io.open(modMinerTrade.urlTabela, "r")
	if file then
		modMinerTrade.safe = minetest.deserialize(file:read("*all"))
		file:close()
		if not modMinerTrade.safe or type(modMinerTrade.safe) ~= "table" then
			minetest.log('error',"[MINERTRADE:ERRO] "..modMinerTrade.translate("The file '%s' is not in table format!"):format(modMinerTrade.urlTabela))
			return { }
		else
			minetest.log('action',"[MINERTRADE] "..modMinerTrade.translate("Opening '%s'!"):format(modMinerTrade.urlTabela))
		end
	end
end

modMinerTrade.setSafeInventory = function(playername, tblListInventory)
	local newInv = minetest.create_detached_inventory_raw("safe_"..playername)
	newInv:set_list("safe", tblListInventory)
	local tamanho = newInv:get_size("safe")
	modMinerTrade.safe[playername] = { }
	for i=1,tamanho do
		modMinerTrade.safe[playername][i] = newInv:get_stack("safe", i):to_table()
	end
end


modMinerTrade.getSafeInventory = function(playername)
	local newInv = minetest.create_detached_inventory_raw("safe_"..playername)
	newInv:set_size("safe", modMinerTrade.size.width*modMinerTrade.size.height)	
	--local listInventory = { }
	for i=1,(modMinerTrade.size.width*modMinerTrade.size.height) do
		if modMinerTrade.safe and modMinerTrade.safe[playername] and modMinerTrade.safe[playername][i] then
			newInv:set_stack("safe", i, ItemStack(modMinerTrade.safe[playername][i]))
		else
			newInv:set_stack("safe", i, nil)
		end
	end
	return newInv:get_list("safe")	
end


modMinerTrade.getFormspec = function(playername, title)
	if not title then title = "" end
	local formspec = "size[9.5,10.5]"
		--.."bgcolor[#636D76FF;false]"
		--..default.gui_bg
		--..default.gui_bg_img
		--..default.gui_slots
		
		--.."bgcolor[#636D76FF;false]"
		.."background[-0.25,-0.25;10,11;safe_inside.png]"
		--listcolors[slot_bg_normal;slot_bg_hover;slot_border;tooltip_bgcolor;tooltip_fontcolor]
		.."listcolors[#3a4044CC;#636e7533;#74acd288;#CCCC00;#FFFFFF]"

		
		.."label[0,0;"..minetest.formspec_escape(title).."]"
		.."list[detached:safe_"..playername .. ";safe;"
			..((9.5 - modMinerTrade.size.width)/2)..","..(((4.6 - modMinerTrade.size.height)/2)+0.62)..";"
			..modMinerTrade.size.width..","..modMinerTrade.size.height
		..";]" -- <= ATENCAO: Nao pode esquecer o prefixo 'detached:xxxxxxx'
		.."list[current_player;main;0.75,6.25;8,4;]"
		
		.."button[0.75,5.25;3,1;btnRemoveAll;"..minetest.formspec_escape(modMinerTrade.translate("REMOVE ALL")).."]"
		.."tooltip[btnRemoveAll;"..minetest.formspec_escape(modMinerTrade.translate("Button under development (still not working)"))..";#CCCC00;#000000]"		
		.."button[5.75,5.25;3,1;btnDepositAll;"..minetest.formspec_escape(modMinerTrade.translate("DEPOSIT ALL")).."]"
		.."tooltip[btnDepositAll;"..minetest.formspec_escape(modMinerTrade.translate("Button under development (still not working)"))..";#CCCC00;#000000]"		

		.."listring[detached:safe_"..playername .. ";safe]"
		.."listring[current_player;main]"
	return formspec
end

modMinerTrade.isOpen = function(meta, player)
	if player:get_player_name() == meta:get_string("owner") 
		or minetest.get_player_privs(player:get_player_name()).server
		or minetest.get_player_privs(player:get_player_name()).checkchest
		or (minetest.get_modpath("tradelands") and modTradeLands.canInteract(player:getpos(), player:get_player_name()))
	then
		return true
	end
	return false
end

modMinerTrade.getDetachedInventory = function(playername)
	-- playername = player:get_player_name()
	local newInv = minetest.create_detached_inventory("safe_"..playername, { --trunk

		-- Called when a player wants to move items inside the inventory
		allow_move = function(inv, from_list, from_index, to_list, to_index, count, player) 
			return count
		end,

		-- Called when a player wants to put items into the inventory
		allow_put = function(inv, listname, index, stack, player) 
			return stack:get_count()
		end,

		-- Called when a player wants to take items out of the inventory
		allow_take = function(inv, listname, index, stack, player) 
			return stack:get_count()
		end,

		-- on_* - no return value
		-- Called after the actual action has happened, according to what was allowed.
		on_move = function(inv, from_list, from_index, to_list, to_index, count, player) 
			modMinerTrade.setSafeInventory(playername, inv:get_list("safe"))
			--minetest.log('action',playername.." colocou "..stack:get_count().." '"..stack:get_name().."' em seu cofre!")
		end,
		on_put = function(inv, listname, index, stack, player) 
			modMinerTrade.setSafeInventory(playername, inv:get_list("safe"))
			minetest.log('action',modMinerTrade.translate("Player '%s' has placed %02d '%s' in his safe!"):format(playername, stack:get_count(), stack:get_name()))
		end,
		on_take = function(inv, listname, index, stack, player) 
			modMinerTrade.setSafeInventory(playername, inv:get_list("safe"))
			minetest.log('action',modMinerTrade.translate("Player '%s' has removed %02d '%s' in his safe!"):format(playername, stack:get_count(), stack:get_name()))
		end,
		
	})
	local invList = modMinerTrade.getSafeInventory(playername)
	if invList~=nil and #invList>=1 then
		newInv:set_list("safe", invList)
	else
		newInv:set_size("safe", modMinerTrade.size.width*modMinerTrade.size.height)
	end
	
	return newInv
end

modMinerTrade.showInventory = function(player, ownername, title)
	local playername = player:get_player_name()
    local inv = modMinerTrade.getDetachedInventory(ownername)
    minetest.sound_play("sfx_alert", {object=player, max_hear_distance=5.0,})
	minetest.show_formspec(
		playername,
		"safe_"..ownername,
		modMinerTrade.getFormspec(ownername, title)
	)
end

--##############################################################################
modMinerTrade.floor_pos = function(pos)
	return {
		x=math.floor(pos.x),
		y=math.floor(pos.y),
		z=math.floor(pos.z)
	}
end

modMinerTrade.getPosMachineName = function(pos)
	if type(posMachine)=="table" and type(posMachine.x)=="number" and type(posMachine.y)=="number" and type(posMachine.z)=="number" then
		return minetest.pos_to_string(modMinerTrade.floor_pos(posMachine))
	else
		minetest.log(
			"error",("[modMinerTrade.sendMailMachine(pos='%s')] "):format(dump(posMachine), dump(ownername), dump(message))
			..modMinerTrade.translate("The '%s' parameter must be of the position type (x,y,z)!"):format("pos")
		)
	end
end

modMinerTrade.sendMailMachine = function(posMachine, ownername, message)
	if minetest.get_modpath("correio") then
		local mailMachineInterval = (60*60)
		if type(posMachine)=="table" and type(posMachine.x)=="number" and type(posMachine.y)=="number" and type(posMachine.z)=="number" then
			local posMachineName = modMinerTrade.getPosMachineName(posMachine)
			if type(ownername)=="string" and ownername:trim()~="" and minetest.player_exists(ownername) then --Checks whether the owner really exists.
				if type(message)=="string" and message:trim()~="" then
					local agora = os.time()
					if type(modMinerTrade.machine_flags)~="table" then modMinerTrade.machine_flags={}	end
					if type(modMinerTrade.machine_flags[posMachineName])~="table" then modMinerTrade.machine_flags[posMachineName]={}	end
					if type(modMinerTrade.machine_flags[posMachineName].lastalert)~="number" or modMinerTrade.machine_flags[posMachineName].lastalert + mailMachineInterval < agora then
						local carta = modCorreio.set_mail(
							modMinerTrade.translate("DISPENSING MACHINE").." "..posMachineName, 
							ownername, 
							message:trim()
						)
						if carta~=nil then
							minetest.log('action',
								modMinerTrade.translate("A letter was sent by the dispensing machine '%s' to '%s' advising about '%s'!"):
								format(posMachineName, ownername , message)
							)
						else
							minetest.log(
								"error",("[modMinerTrade.sendMailMachine(posMachine='%s', ownername='%s', message='%s')] "):format(dump(posMachine), dump(ownername), dump(message))
								..modMinerTrade.translate("Due to an unknown error, it was not possible to send an email through the dispensing machine!")
							)
						end
						modMinerTrade.machine_flags[posMachineName].lastalert = agora
					end --if type(modMinerTrade.machine_flags[posMachineName].lastalert)~="number" or modMinerTrade.machine_flags[posMachineName].lastalert + mailMachineInterval < agora then
				else
					minetest.log(
						"error",("[modMinerTrade.sendMailMachine(posMachine='%s', ownername='%s', message='%s')] "):format(dump(posMachine), dump(ownername), dump(message))
						..modMinerTrade.translate("The '%s' parameter must be of the non-empty string type!"):format("message")
					)
				end
			else
				minetest.log(
					"error",("[modMinerTrade.sendMailMachine(posMachine='%s', ownername='%s', message='%s')] "):format(dump(posMachine), dump(ownername), dump(message))
					..modMinerTrade.translate("The '%s' parameter must be of the non-empty string type!"):format("ownername")
				)
			end
		else
			minetest.log(
				"error",("[modMinerTrade.sendMailMachine(posMachine='%s', ownername='%s', message='%s')] "):format(dump(posMachine), dump(ownername), dump(message))
				..modMinerTrade.translate("The '%s' parameter must be of the position type (x,y,z)!"):format("posMachine")
			)
		end
	end --if minetest.get_modpath("correio") then
end

minetest.errorDispensing = function(erroMessage, player, pos, ownername)
	if type(erroMessage)=="string" and erroMessage:trim()~="" then
		if player:is_player() then
			local playername = player:get_player_name()
			minetest.chat_send_player(playername, core.colorize("#00ff00", "["..modMinerTrade.translate("DISPENSING MACHINE").."]: ")..erroMessage)
			minetest.sound_play("sfx_failure", {object=player, max_hear_distance=5.0,})
		end
		if type(pos)~="nil" and type(ownername)=="string" and ownername:trim()~="" then
			modMinerTrade.sendMailMachine(pos, ownername, erroMessage)
		end
	else
		minetest.log(
			"error",("[minetest.errorDispensing(erroMessage='%s', player, pos, ownername)] "):format(dump(erroMessage))
			..modMinerTrade.translate("The '%s' parameter must be of the non-empty string type!"):format("erroMessage")
		)
	end
end



