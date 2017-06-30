

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


minetest.register_craftitem("minertrade:piggybank", {
	description = modMinerTrade.translate("PIGGY BANK\n* equals 09 Minermoneys."),
	inventory_image = "obj_piggy_bank.png",
	stack_max=9, --Acumula 9 por slot
	groups = {cash=1, trade=1},
})

minetest.register_craft({
	output = "minertrade:piggybank",
	recipe = {
		{"minertrade:minermoney", "minertrade:minermoney", "minertrade:minermoney"},
		{"minertrade:minermoney", "minertrade:minermoney", "minertrade:minermoney"},
		{"minertrade:minermoney", "minertrade:minermoney", "minertrade:minermoney"}
	},
})

minetest.register_craft({
	output = "minertrade:minermoney 9",
	recipe = {
		{"minertrade:piggybank"},
	},
})


minetest.register_alias(
	modMinerTrade.translate("piggybank"), 
	"minertrade:piggybank"
)

--##########################################################################################################

minetest.register_craftitem("minertrade:creditcard", {
	description = modMinerTrade.translate("CREDIT CARD\n* equals 09 Piggy Banks."),
	inventory_image = "obj_credit_card.png",
	stack_max=9, --Acumula 9 por slot
	groups = {cash=1, trade=1},
})

minetest.register_craft({
	output = "minertrade:creditcard",
	recipe = {
		{"minertrade:piggybank", "minertrade:piggybank", "minertrade:piggybank"},
		{"minertrade:piggybank", "minertrade:piggybank", "minertrade:piggybank"},
		{"minertrade:piggybank", "minertrade:piggybank", "minertrade:piggybank"}
	},
})

minetest.register_craft({
	output = "minertrade:piggybank 9",
	recipe = {
		{"minertrade:creditcard"},
	},
})


minetest.register_alias(
	modMinerTrade.translate("creditcard"), 
	"minertrade:creditcard"
)

--##########################################################################################################


