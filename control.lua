require("gui")

---@param player LuaPlayer
---@param target (LuaEntity|LuaPlayer)?
function switch_to(player, target)
	if target == nil then return end

	if target.type == "car" or target.type == "spider-vehicle" then
		local driver = target.get_driver()

		if driver ~= nil and driver.valid and driver.player ~= player then
			target = driver
		else
			target = target.get_passenger()

			if target == nil or not target.valid then return end
		end
	elseif target.type == "locomotive" or target.type == "cargo-wagon" or target.type == "fluid-wagon" or target.type == "artillery-wagon" then
		target = target.get_driver()
		if target == nil or not target.valid then return end
	end
	if target.type ~= "character" or target.force ~= player.force then
		return
	end

	local oldchar = player.character
	if target == oldchar or oldchar == nil then return end

	switch_character(player, target)
	update_queue(player, oldchar)

	update_guis()
end

---@param player LuaPlayer
---@param target (LuaEntity|LuaPlayer)?
---@return boolean
function is_valid_target(player, target)
	if target == nil then return false end

	if target.type == "car" or target.type == "spider-vehicle" then
		local driver = target.get_driver()

		if driver ~= nil and driver.valid and driver.player ~= player then
			target = driver
		else
			target = target.get_passenger()

			if target == nil or not target.valid then return false end
		end
	elseif target.type == "locomotive" or target.type == "cargo-wagon" or target.type == "fluid-wagon" or target.type == "artillery-wagon" then
		target = target.get_driver()
		if target == nil or not target.valid then return false end
	end
	if target.type ~= "character" or target.force ~= player.force then
		return false
	end

	local oldchar = player.character
	if target == oldchar or oldchar == nil then return false end

	return true
end

---@param player LuaPlayer
---@param target LuaEntity
function switch_character(player, target)
	local target_vehicle = nil
	local target_player = target.player
	if target.vehicle ~= nil and (target.vehicle.type == "car" or target.vehicle.type == "spider-vehicle") then
		target_vehicle = target.vehicle
	end

	if global.character_tag ~= nil then
		local tag = global.character_tag[target.unit_number]
		if tag ~= nil then
			global.character_tag[target.unit_number] = nil
			if tag.valid then
				if global.character_name == nil then
					global.character_name = {}
				end
				global.character_name[target.unit_number] = tag.text
				global.tag_character[tag.tag_number] = nil
				tag.destroy()
			end
		end
	end

	local old_char = player.character
	local vehicle = player.vehicle
	if target.surface ~= player.surface then
		player.set_controller { type = defines.controllers.ghost }
		if not player.teleport(target.position, target.surface) then
			player.set_controller { type = defines.controllers.character, character = old_char }
			return
		end
	end

	if target_player ~= nil then
		if settings.get_player_settings(player)["character-swap"].value and settings.get_player_settings(target.player)["character-swap"].value then
			local other_char = target_player.character

			target_player.set_controller { type = defines.controllers.ghost }
			player.set_controller { type = defines.controllers.character, character = target }
			target_player.set_controller { type = defines.controllers.character, character = old_char }

			if vehicle ~= nil and old_char ~= nil then
				if vehicle.type == "car" or vehicle.type == "spider-vehicle" then
					if vehicle.get_driver() == nil then
						vehicle.set_driver(old_char)
					elseif vehicle.get_passenger() == nil then
						vehicle.set_passenger(old_char)
					end
				elseif ((vehicle.type == "locomotive" or vehicle.type == "cargo-wagon" or vehicle.type == "fluid-wagon" or vehicle.type == "artillery-wagon") and (vehicle.get_driver() == nil)) then
					vehicle.set_driver(old_char)
				end
			end

			if target_vehicle ~= nil and other_char ~= nil then
				if target_vehicle.type == "car" or target_vehicle.type == "spider-vehicle" then
					if target_vehicle.get_driver() == nil then
						target_vehicle.set_driver(other_char)
					elseif target_vehicle.get_passenger() == nil then
						target_vehicle.set_passenger(other_char)
					end
				elseif vehicle ~= nil and (vehicle.type == "locomotive" or vehicle.type == "cargo-wagon" or vehicle.type == "fluid-wagon" or vehicle.type == "artillery-wagon") and vehicle.get_driver() == nil then
					target_vehicle.set_driver(other_char)
				end
			end
		end
	else
		player.set_controller { type = defines.controllers.character, character = target }

		old_char.walking_state = { walking = false, direction = defines.direction.south }

		old_char.minable = true
		target.minable = false

		if vehicle ~= nil and old_char ~= nil then
			if (vehicle.type == "car" or vehicle.type == "spider-vehicle") and vehicle.get_passenger() == nil then
				vehicle.set_passenger(old_char)
			elseif (vehicle.type == "locomotive" or vehicle.type == "cargo-wagon" or vehicle.type == "fluid-wagon" or vehicle.type == "artillery-wagon") and vehicle.get_driver() == nil then
				vehicle.set_driver(old_char)
			else
				add_chart_tag(player, old_char)
			end
		else
			add_chart_tag(player, old_char)
		end
	end

	if (global.character_queue ~= nil) then
		local queue = global.character_queue[player.index]
		if (queue ~= nil) then
			queue.last_index = target.unit_number
		end
	end

	if ((target_vehicle ~= nil) and (target_vehicle.get_driver() == nil) and (target == target_vehicle.get_passenger())) then
		target_vehicle.set_passenger(nil)
		target_vehicle.set_driver(target)
	end
end

---@param player LuaPlayer
---@param oldchar LuaEntity
function update_queue(player, oldchar)
	local newchar = player.character
	if newchar == oldchar or newchar == nil or oldchar == nil then
		return
	end

	if global.character_queue == nil then
		global.character_queue = {}
	end

	local queue = global.character_queue[player.index]
	if queue == nil then
		queue = {}
		queue.nodes = {}
		global.character_queue[player.index] = queue
	end

	local node1 = queue.nodes[oldchar.unit_number]
	if node1 == nil or node1.next == nil or node1.next.prev ~= node1 then
		node1 = { body = oldchar, unit = oldchar.unit_number }
		node1.next = node1
		node1.prev = node1
		queue.nodes[oldchar.unit_number] = node1
	end

	local node2 = queue.nodes[newchar.unit_number]
	if node2 == node1.next then return end
	if node2 == nil or node2.body ~= newchar or node2.next == nil or node2.prev == nil or node2.next.prev ~= node2 or node2.prev.next ~= node2 then
		node2 = { body = newchar, unit = newchar.unit_number }
		queue.nodes[newchar.unit_number] = node2
	else
		local n2n = node2.next
		local n2p = node2.prev
		n2n.prev = n2p
		n2p.next = n2n
	end

	local nn = node1.next
	node2.next = nn
	node2.prev = node1
	nn.prev = node2
	node1.next = node2
end

---@param player LuaPlayer
---@param rev boolean
function cycle_body(player, rev)
	if global.character_queue == nil then return end
	local queue = global.character_queue[player.index]
	if queue == nil then return end

	if player.character == nil then return end
	local node = queue.nodes[player.character.unit_number]
	if node == nil and queue.last_index ~= nil then
		node = queue.nodes[queue.last_index]
	end
	if node == nil then return end
	local orgnode = node

	if rev then
		node = node.prev
	else
		node = node.next
	end
	if node == nil then
		global.character_queue[player.index] = nil
		return
	end

	local body = node.body
	while body == nil or not body.valid or body.type ~= "character" or body.player ~= nil or body.force ~= player.force do
		local np = node.prev
		local nn = node.next
		if nn == nil or np == nil or nn.prev == nil or np.next == nil or nn == node or np == node then
			global.character_queue[player.index] = nil
			return
		end
		if body == nil or not body.valid or body.type ~= "character" then
			np.next = nn
			nn.prev = np
			node.next = node
			node.prev = node
		end
		if node == orgnode then return end
		if rev then node = np else node = nn end
		body = node.body
	end

	switch_character(player, body)
end

---@param oldunit LuaEntity
---@param newchar LuaEntity
function change_character_entity(oldunit, newchar)
	local newunit = newchar.unit_number
	if oldunit == nil or newunit == nil or newunit == oldunit then return end

	if global.character_tag ~= nil and global.tag_character ~= nil then
		local tag = global.character_tag[oldunit]
		if tag ~= nil and tag.valid and tag.tag_number ~= nil then
			global.character_tag[oldunit] = nil
			global.character_tag[newunit] = tag
			global.tag_character[tag.tag_number] = newchar
		end

		if global.character_name ~= nil then
			local name = global.character_name[oldunit]
			if name ~= nil then
				global.character_name[oldunit] = nil
				global.character_name[newunit] = name
			end
		end
	end

	if global.character_queue ~= nil then
		for _, queue in pairs(global.character_queue) do
			local node = queue.nodes[oldunit]
			if node ~= nil then
				node.body = newchar
				node.unit = newunit
				queue.nodes[oldunit] = nil
				queue.nodes[newunit] = node
			end
			if queue.last_index == oldunit then
				queue.last_index = newunit
			end
		end
	end
end

---@param player LuaPlayer
---@param character LuaEntity
function add_chart_tag(player, character)
	if player == nil or character == nil then
		return
	end
	local icon = character.name

	local name = nil
	if global.character_name ~= nil then
		name = global.character_name[character.unit_number]
	end
	if name == nil then
		name = player.name
	end

	local ctag = player.force.add_chart_tag(character.surface,
		{
			position = character.position,
			icon = { type = "item", name = icon },
			text = name,
			last_user = player
		})
	if ctag ~= nil then
		if (global.tag_character == nil) then
			global.tag_character = {}
			global.character_tag = {}
		end
		global.tag_character[ctag.tag_number] = character
		global.character_tag[character.unit_number] = ctag
	end
end

---@param character LuaEntity?
function register_character(character)
	if character == nil then return end

	if global.unit_number_character == nil then
		global.unit_number_character = {}
	end

	global.unit_number_character[character.unit_number] = character
	update_guis()
end

---@param character LuaEntity
function unregister_character(character)
	global.unit_number_character[character.unit_number] = nil

	if global.character_tag[character.unit_number] ~= nil then
		local tag = global.character_tag[character.unit_number]

		global.character_tag[character.unit_number] = nil
		global.tag_character[tag.tag_number] = nil

		tag.destroy()
	end

	update_guis()
end

script.on_configuration_changed(function(config_data)
	if global.unit_number_character ~= nil then
		for _, character in pairs(global.unit_number_character) do
			unregister_character(character)
		end
	end

	for _, surface in pairs(game.surfaces) do
		for _, character in pairs(surface.find_entities_filtered { type = "character" }) do
			register_character(character)
		end
	end
end)

script.on_event(defines.events.on_player_respawned, function(event)
	local player = game.players[event.player_index]
	local newchar = player.character
	if newchar == nil or not newchar.valid then return end

	if global.character_queue == nil then return end
	local queue = global.character_queue[player.index]
	if queue == nil then return end
	if queue.nodes[newchar.unit_number] ~= nil then return end

	for _, node in pairs(queue.nodes) do
		if node.body == nil or not node.body.valid then
			change_character_entity(node.unit, newchar)
			return
		end
	end
end)

script.on_event("switch-to-character", function(event)
	local player = game.players[event.player_index]
	local target = player.selected
	if is_valid_target(player, target) then
		switch_to(player, target)
	else
		toggle_gui(player)
	end
end)

script.on_event("previous-character", function(event)
	local player = game.players[event.player_index]
	cycle_body(player, true)
end)

script.on_event("next-character", function(event)
	local player = game.players[event.player_index]
	cycle_body(player, false)
end)

script.on_event(defines.events.on_chart_tag_removed, function(event)
	if not (global.tag_character ~= nil and event.tag ~= nil and event.tag.valid) then return end

	local character = global.tag_character[event.tag.tag_number]
	if character == nil then return end

	global.tag_character[event.tag.tag_number] = nil
	if not character.valid then return end

	global.character_tag[character.unit_number] = nil
	if event.player_index == nil then return end

	local player = game.players[event.player_index]
	if player == nil then return end

	switch_to(player, character)
end)

script.on_event(defines.events.on_player_joined_game, function(event)
	local player = game.players[event.player_index]
	local character = player.character
	if character == nil then
		character = player.cutscene_character
	end

	register_character(character)

	if character ~= nil then
		character.minable = false
	end
end)

script.on_event(defines.events.on_built_entity, function(event)
	if event.created_entity.type ~= "character" then return end

	local character = event.created_entity
	register_character(character)

	update_guis()
end)

script.on_event(defines.events.on_player_respawned, function(event)
	local player = game.players[event.player_index]
	local character = player.character
	if character == nil then
		character = player.cutscene_character
	end

	register_character(character)

	if character ~= nil then
		character.minable = false
	end
end)

script.on_event(defines.events.on_player_created, function(event)
	local player = game.players[event.player_index]
	local character = player.character
	if character == nil then
		character = player.cutscene_character
	end

	register_character(character)
end)

script.on_event(defines.events.on_pre_player_died, function(event)
	local character = game.player[event.player_index].character
	unregister_character(character)
end)

script.on_event(defines.events.on_player_mined_entity, function(event)
	if event.entity.type ~= "character" then return end

	unregister_character(event.entity)
end)

script.on_event(defines.events.on_entity_died, function(event)
	if event.entity.type ~= "character" then return end

	unregister_character(event.entity)
end)
