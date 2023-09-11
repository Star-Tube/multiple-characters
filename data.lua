data:extend {
	{
		type = "custom-input",
		name = "switch-to-character",
		order = "character-aa",
		key_sequence = "U",
		include_selected_prototype = true
	},
	{
		type = "custom-input",
		name = "next-character",
		order = "character-ab",
		key_sequence = "SHIFT + U"
	},
	{
		type = "custom-input",
		name = "previous-character",
		order = "character-ac",
		key_sequence = "CONTROL + U"
	}
}

data:extend {
	{
		type = "item-subgroup",
		name = "character",
		group = "logistics",
		order = "f-a",
	}
}

local character = data.raw["character"]["character"];
character.localised_description = { "", { "entity-description.character" }, "\n",
	{ "multiple-characters.character-control-self" } }
character.icons = {
	{
		icon = "__multiple-characters__/graphics/character_base.png",
		icon_size = 128,
	},
	{
		icon = "__multiple-characters__/graphics/character_mask.png",
		icon_size = 128,
		tint = { 221, 127, 33, 100 }
	},
}
character.minable = {
	mining_time = 2,
	result = "character",
}

data:extend {
	{
		type = "item",
		name = "character",
		localised_description = { "", { "item-description.character" }, "\n",
			{ "multiple-characters.character-control" } },
		place_result = "character",
		subgroup = "character",
		order = "a",
		stack_size = 1,
		icons = {
			{
				icon = "__multiple-characters__/graphics/character_base.png",
				icon_size = 128,
			},
			{
				icon = "__multiple-characters__/graphics/character_mask.png",
				icon_size = 128,
				tint = { 221, 127, 33, 100 }
			},
		}
	},
	{
		type = "recipe",
		name = "character",
		category = "crafting",
		ingredients = {
			{
				type = "item",
				name = "power-armor-mk2",
				amount = 1,
			},
			{
				type = "item",
				name = "raw-fish",
				amount = 1,
			}
		},
		energy_required = 5,
		results = {
			{
				type = "item",
				name = "character",
				amount = 1,
			}
		},
		enabled = false,
	},
	{
		type = "technology",
		name = "character",
		order = "g-d-a",
		icons = {
			{
				icon = "__multiple-characters__/graphics/character_base.png",
				icon_size = 128,
			},
			{
				icon = "__multiple-characters__/graphics/character_mask.png",
				icon_size = 128,
				tint = { 221, 127, 33, 100 }
			},
		},
		unit = {
			count = 1000,
			time = 30,
			ingredients = {
				{ "automation-science-pack", 1 },
				{ "logistic-science-pack",   1 },
				{ "chemical-science-pack",   1 },
				{ "utility-science-pack",    1 },
			}
		},
		prerequisites = {
			"power-armor-mk2"
		},
		effects = {
			{
				type = "unlock-recipe",
				recipe = "character",
			}
		},
	}
}

function add_character(name, color)
	local new_character = table.deepcopy(data.raw["character"]["character"])
	new_character.name = name
	new_character.localised_description = { "", { "entity-description." .. name }, "\n",
		{ "multiple-characters.character-control-self" } }
	new_character.icons = {
		{
			icon = "__multiple-characters__/graphics/character_base.png",
			icon_size = 128,
		},
		{
			icon = "__multiple-characters__/graphics/character_mask.png",
			icon_size = 128,
			tint = color
		},
	}
	new_character.minable = {
		mining_time = 2,
		result = name,
	}


	local item = {
		type = "item",
		name = name,
		localised_description = { "", { "item-description." .. name }, "\n",
			{ "multiple-characters.character-control" } },
		order = "b",
		place_result = name,
		subgroup = "character",
		stack_size = 1,
		icons = {
			{
				icon = "__multiple-characters__/graphics/character_base.png",
				icon_size = 128,
			},
			{
				icon = "__multiple-characters__/graphics/character_mask.png",
				icon_size = 128,
				tint = color
			},
		},
		icon_size = 64,
	}

	data:extend { new_character, item }
	return new_character
end

if settings.startup["character-upgrades"].value then
	-- fast character
	local fast_character = add_character("fast-character", { 64, 192, 192, 100 })
	fast_character.running_speed = fast_character.running_speed * 1.5

	data:extend {
		{
			type = "recipe",
			name = "fast-character",
			category = "crafting",
			ingredients = {
				{
					type = "item",
					name = "character",
					amount = 1,
				},
				{
					type = "item",
					name = "exoskeleton-equipment",
					amount = 5,
				}
			},
			results = {
				{
					type = "item",
					name = "fast-character",
					amount = 1,
				}
			},
			energy_required = 5,
			enabled = false,
		},
		{
			type = "technology",
			name = "fast-character",
			order = "g-d-b",
			icons = fast_character.icons,
			unit = {
				count = 1000,
				time = 30,
				ingredients = {
					{ "automation-science-pack", 1 },
					{ "logistic-science-pack",   1 },
					{ "chemical-science-pack",   1 },
					{ "utility-science-pack",    1 },
				}
			},
			prerequisites = {
				"character",
				"exoskeleton-equipment"
			},
			effects = {
				{
					type = "unlock-recipe",
					recipe = "fast-character",
				}
			},
		}
	}

	-- long range character
	local long_range_character = add_character("long-range-character", { 255, 64, 64, 200 })
	long_range_character.build_distance = long_range_character.build_distance * 1.5
	long_range_character.drop_item_distance = long_range_character.drop_item_distance * 1.5
	long_range_character.reach_distance = long_range_character.reach_distance * 1.5
	long_range_character.reach_resource_distance = long_range_character.reach_resource_distance * 1.5
	long_range_character.item_pickup_distance = long_range_character.item_pickup_distance * 1.5
	long_range_character.loot_pickup_distance = long_range_character.loot_pickup_distance * 1.5

	data:extend {
		{
			type = "recipe",
			name = "long-range-character",
			category = "crafting",
			ingredients = {
				{
					type = "item",
					name = "character",
					amount = 1,
				},
				{
					type = "item",
					name = "long-handed-inserter",
					amount = 10,
				}
			},
			results = {
				{
					type = "item",
					name = "long-range-character",
					amount = 1,
				}
			},
			energy_required = 5,
			enabled = false,
		},
		{
			type = "technology",
			name = "long-range-character",
			order = "g-d-c",
			icons = long_range_character.icons,
			unit = {
				count = 1000,
				time = 30,
				ingredients = {
					{ "automation-science-pack", 1 },
					{ "logistic-science-pack",   1 },
					{ "chemical-science-pack",   1 },
					{ "utility-science-pack",    1 },
				}
			},
			prerequisites = {
				"character",
			},
			effects = {
				{
					type = "unlock-recipe",
					recipe = "long-range-character",
				}
			},
		}
	}

	-- stronger character
	local strong_character = add_character("strong-character", { 255, 255, 64, 200 })
	strong_character.max_health = strong_character.max_health * 1.5
	strong_character.inventory_size = strong_character.inventory_size * 1.5
	strong_character.mining_speed = strong_character.mining_speed * 1.5
	strong_character.resistances = {
		{
			type = "physical",
			decrease = 2,
			percent = 5,
		}
	}

	data:extend {
		{
			type = "recipe",
			name = "strong-character",
			category = "crafting",
			ingredients = {
				{
					type = "item",
					name = "character",
					amount = 1,
				},
				{
					type = "item",
					name = "heavy-armor",
					amount = 1,
				},
				{
					type = "item",
					name = "steel-chest",
					amount = 10,
				}
			},
			results = {
				{
					type = "item",
					name = "strong-character",
					amount = 1,
				}
			},
			energy_required = 5,
			enabled = false,
		},
		{
			type = "technology",
			name = "strong-character",
			order = "g-d-d",
			icons = strong_character.icons,
			unit = {
				count = 1000,
				time = 30,
				ingredients = {
					{ "automation-science-pack", 1 },
					{ "logistic-science-pack",   1 },
					{ "chemical-science-pack",   1 },
					{ "utility-science-pack",    1 },
				}
			},
			prerequisites = {
				"character",
			},
			effects = {
				{
					type = "unlock-recipe",
					recipe = "strong-character",
				}
			},
		}
	}

	-- allround_character
	local allround_character = add_character("allround-character", { 64, 255, 64, 200 })
	allround_character.running_speed = allround_character.running_speed * 1.25
	allround_character.build_distance = allround_character.build_distance * 1.25
	allround_character.drop_item_distance = allround_character.drop_item_distance * 1.25
	allround_character.reach_distance = allround_character.reach_distance * 1.25
	allround_character.reach_resource_distance = allround_character.reach_resource_distance * 1.25
	allround_character.item_pickup_distance = allround_character.item_pickup_distance * 1.25
	allround_character.loot_pickup_distance = allround_character.loot_pickup_distance * 1.25
	allround_character.max_health = allround_character.max_health * 1.25
	allround_character.inventory_size = allround_character.inventory_size * 1.25
	allround_character.mining_speed = allround_character.mining_speed * 1.25
	allround_character.resistances = {
		{
			type = "physical",
			decrease = 1,
			percent = 2.5,
		}
	}

	data:extend {
		{
			type = "recipe",
			name = "allround-character",
			category = "crafting",
			ingredients = {
				{
					type = "item",
					name = "fast-character",
					amount = 1,
				},
				{
					type = "item",
					name = "long-range-character",
					amount = 1,
				},
				{
					type = "item",
					name = "strong-character",
					amount = 1,
				},
			},
			results = {
				{
					type = "item",
					name = "allround-character",
					amount = 1,
				}
			},
			energy_required = 5,
			enabled = false,
		},
		{
			type = "technology",
			name = "allround-character",
			order = "g-d-e",
			icons = allround_character.icons,
			unit = {
				count = 1500,
				time = 30,
				ingredients = {
					{ "automation-science-pack", 1 },
					{ "logistic-science-pack",   1 },
					{ "chemical-science-pack",   1 },
					{ "utility-science-pack",    1 },
				}
			},
			prerequisites = {
				"fast-character",
				"long-range-character",
				"strong-character",
			},
			effects = {
				{
					type = "unlock-recipe",
					recipe = "allround-character",
				}
			},
		}
	}
end
