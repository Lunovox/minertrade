

--#########################################################################################

minetest.register_craftitem("minertrade:minecoin", {
	description = "Minermoeda (Dinheiro Craftável)",
	inventory_image = "obj_minecoin.png",
	stack_max=9, --Acumula 9 por slot
	groups = { mobs=1 },
})

minetest.register_craft({
	output = "minertrade:minecoin",
	recipe = {
		{"default:gold_ingot","default:steel_ingot","default:gold_ingot"},
	},
	--https://github.com/minetest/minetest_game/blob/master/mods/default/craftitems.lua
})

minetest.register_craft({
	type = "cooking",
	output = "default:gold_ingot",
	recipe = "minertrade:minecoin",
	cooktime = 5,
})

minetest.register_alias("minecoin", "minertrade:minecoin")
minetest.register_alias("minemoeda", "minertrade:minecoin")

--##########################################################################################################

minetest.register_craftitem("minertrade:minemoney", {
	description = "Minercedula (Vale 9 Minermoedas)",
	inventory_image = "obj_minemoney.png",
	stack_max=9, --Acumula 9 por slot
	groups = { mobs=1 },
})

minetest.register_craft({
	output = "minertrade:minemoney",
	recipe = {
		{"minertrade:minecoin", "minertrade:minecoin", "minertrade:minecoin"},
		{"minertrade:minecoin", "minertrade:minecoin", "minertrade:minecoin"},
		{"minertrade:minecoin", "minertrade:minecoin", "minertrade:minecoin"}
	},
})

minetest.register_craft({
	output = "minertrade:minecoin 9",
	recipe = {
		{"minertrade:minemoney"},
	},
})


minetest.register_alias("minemoney", "minertrade:minemoney")
minetest.register_alias("minedinheiro", "minertrade:minemoney")

--##########################################################################################################


minetest.register_craftitem("minertrade:piggybank", {
	description = "Cofre Porquinho (Vale 9 Minercedulas)",
	inventory_image = "obj_piggy_bank.png",
	stack_max=9, --Acumula 9 por slot
	groups = { mobs=1 },
})

minetest.register_craft({
	output = "minertrade:piggybank",
	recipe = {
		{"minertrade:minemoney", "minertrade:minemoney", "minertrade:minemoney"},
		{"minertrade:minemoney", "minertrade:minemoney", "minertrade:minemoney"},
		{"minertrade:minemoney", "minertrade:minemoney", "minertrade:minemoney"}
	},
})

minetest.register_craft({
	output = "minertrade:minemoney 9",
	recipe = {
		{"minertrade:piggybank"},
	},
})


minetest.register_alias("piggybank"			, "minertrade:piggybank")
minetest.register_alias("cofreporquinho"	, "minertrade:piggybank")

--##########################################################################################################

minetest.register_craftitem("minertrade:creditcard", {
	description = "Cartão de Crédito (Vale 9 Cofre-Porquinhos)",
	inventory_image = "obj_credit_card.png",
	stack_max=9, --Acumula 9 por slot
	groups = { mobs=1 },
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


minetest.register_alias("creditcard"		, "minertrade:creditcard")
minetest.register_alias("cataodecredito"	, "minertrade:creditcard")

--##########################################################################################################


