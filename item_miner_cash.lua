

--#########################################################################################

minetest.register_craftitem("minertrade:minercoin", {
	description = modMinerTrade.translate("MINERCOIN\n* Basic craftable money with gold and steel."),
	inventory_image = "obj_minecoin.png",
	stack_max=9, --Acumula 9 por slot
	groups = {cash=1, trade=1},
})

minetest.register_craft({
	output = "minertrade:minercoin",
	recipe = {
		{"default:gold_ingot","default:steel_ingot","default:gold_ingot"},
	},
	--https://github.com/minetest/minetest_game/blob/master/mods/default/craftitems.lua
})

minetest.register_craft({
	type = "cooking",
	output = "default:gold_ingot",
	recipe = "minertrade:minercoin",
	cooktime = 5,
})

minetest.register_alias(
	modMinerTrade.translate("minercoin"), 
	"minertrade:minercoin"
)

--##########################################################################################################

minetest.register_craftitem("minertrade:minermoney", {
	description = modMinerTrade.translate("MINERMONEY\n* equals 09 Minercoins."),
	inventory_image = "obj_minemoney.png",
	stack_max=9, --Acumula 9 por slot
	groups = {cash=1, trade=1},
})

minetest.register_craft({
	output = "minertrade:minermoney",
	recipe = {
		{"minertrade:minercoin", "minertrade:minercoin", "minertrade:minercoin"},
		{"minertrade:minercoin", "minertrade:minercoin", "minertrade:minercoin"},
		{"minertrade:minercoin", "minertrade:minercoin", "minertrade:minercoin"}
	},
})

minetest.register_craft({
	output = "minertrade:minercoin 9",
	recipe = {
		{"minertrade:minermoney"},
	},
})


minetest.register_alias(
	modMinerTrade.translate("minermoney"), 
	"minertrade:minermoney"
)

--##########################################################################################################


minetest.register_craftitem("minertrade:checkbank", {
	description = modMinerTrade.translate("CHECK BANK\n* equals 09 Minermoneys."),
	inventory_image = "obj_bank_check.png",
	stack_max=9, --Acumula 9 por slot
	groups = {cash=1, trade=1},
})

minetest.register_craft({
	output = "minertrade:checkbank",
	recipe = {
		{"minertrade:minermoney", "minertrade:minermoney", "minertrade:minermoney"},
		{"minertrade:minermoney", "minertrade:minermoney", "minertrade:minermoney"},
		{"minertrade:minermoney", "minertrade:minermoney", "minertrade:minermoney"}
	},
})

minetest.register_craft({
	output = "minertrade:minermoney 9",
	recipe = {
		{"minertrade:checkbank"},
	},
})


minetest.register_alias(
	modMinerTrade.translate("checkbank"), 
	"minertrade:checkbank"
)

--##########################################################################################################

minetest.register_craftitem("minertrade:creditcard", {
	description = modMinerTrade.translate("CREDIT CARD (Unowned)\n* equals 09 Check Banks.\n* Allows you to access the bank account of the credit card owner anywhere in the world."),
	inventory_image = "obj_credit_card.png",
	--stack_max=9, --Acumula 9 por slot
	groups = {cash=1, trade=1},
	on_use = function(itemstack, player)
		local playername = player:get_player_name()
		local meta = itemstack:get_meta()
		local old_data = minetest.deserialize(itemstack:get_metadata())
		if old_data then
			meta:from_table({ fields = old_data })
		end
		local tmpDatabase = meta:to_table().fields
		
		if type(tmpDatabase.ownername)~="string" or tmpDatabase.ownername=="" then
			tmpDatabase.ownername = playername
			tmpDatabase.description = modMinerTrade.translate("CREDIT CARD of '%s'"):format(tmpDatabase.ownername)
			local invPlayer = player:get_inventory()
			local new_stack
			local count = itemstack:get_count()
			itemstack:set_count(count - 1)
			new_stack = ItemStack("minertrade:creditcard")
			new_stack:get_meta():from_table({ fields = tmpDatabase })
			if invPlayer:room_for_item("main", new_stack) then
				invPlayer:add_item("main", new_stack)
			else
				minetest.add_item(player:get_pos(), new_stack)
			end
			minetest.chat_send_player(playername,
				core.colorize("#00ff00", "["..modMinerTrade.translate("CREDIT CARD").."]: ")
				..modMinerTrade.translate("Your name has been saved to this credit card. Anyone using this credit card will be able to access the '%s' bank account."):format(tmpDatabase.ownername)
			)
			minetest.sound_play("sfx_alert", {object=player, max_hear_distance=5.0,})
			return itemstack
		end
		modMinerTrade.showInventory(
			player, 
			tmpDatabase.ownername, 
			modMinerTrade.translate("ACCOUNT BANK of '%s':"):format(tmpDatabase.ownername)
		)
		return itemstack
	end,
})

minetest.register_craft({
	output = "minertrade:creditcard",
	recipe = {
		{"minertrade:checkbank", "minertrade:checkbank", "minertrade:checkbank"},
		{"minertrade:checkbank", "minertrade:checkbank", "minertrade:checkbank"},
		{"minertrade:checkbank", "minertrade:checkbank", "minertrade:checkbank"}
	},
})

minetest.register_craft({
	output = "minertrade:checkbank 9",
	recipe = {
		{"minertrade:creditcard"},
	},
})


minetest.register_alias(
	modMinerTrade.translate("creditcard"), 
	"minertrade:creditcard"
)

--##########################################################################################################


