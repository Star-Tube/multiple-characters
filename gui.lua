function toggle_gui(player)
    if player == nil then return end
    local main_frame = player.gui.screen.mult_chars_main_frame

    if main_frame == nil then
        build_gui(player)
    else
        main_frame.destroy()
    end
end

function update_guis()
    for _, player in pairs(game.players) do
        build_table(player)
    end
end

function build_gui(player)
    if player == nil then return end

    local screen_element = player.gui.screen
    local main_frame = screen_element.add {
        type = "frame",
        name = "mult_chars_main_frame",
        caption = { "multiple-characters.window-title" }
    }
    main_frame.auto_center = true

    player.opened = main_frame

    local content_frame = main_frame.add {
        type = "frame",
        name = "content_frame",
        style = "mult_chars_content_frame"
    }

    local frame = content_frame.add {
        type = "frame",
        name = "inner_frame",
        style = "deep_frame_in_shallow_frame",
    }

    local controls_flow = frame.add {
        type = "scroll-pane",
        name = "controls_flow",
        horizontal_scroll_policy = "never",
        style = "mult_chars_controls_flow",
        -- vertical_scroll_policy = "always",
    }
    controls_flow.style.maximal_height = 500
    controls_flow.style.minimal_width = 608
    controls_flow.style.horizontally_stretchable = "on"

    -- controls_flow.style = "controller_logistics_scroll_pane"
    -- controls_flow.style.maximal_height = 400

    local table = controls_flow.add {
        type = "table",
        name = "table",
        column_count = 4,
        style = "mult_chars_table"
    }

    build_table(player)
end

function build_table(player)
    if player.gui.screen.mult_chars_main_frame == nil then return end

    local table = player.gui.screen.mult_chars_main_frame.content_frame.inner_frame.controls_flow.table
    table.clear()

    for _, character in pairs(global.unit_number_character) do
        if not character.valid then goto continue end

        local outer_frame = table.add {
            type = "frame",
            direction = "horizontal",
            style = "mult_chars_char_frame"
        }

        local v_flow = outer_frame.add {
            type = "flow",
            direction = "vertical"
        }
        v_flow.style.vertical_spacing = 12

        local button = v_flow.add {
            type = "button",
            style = "mult_chars_minimap_button",
            tags = {
                action = "mult_chars_switch_character",
                character_unit_number = character.unit_number,
            }
        }

        local chart_player_index = nil
        local position = character.position
        if character.player ~= nil then
            chart_player_index = character.player.index
            position = nil
        end

        local minimap = button.add {
            type = "minimap",
            position = position,
            chart_player_index = chart_player_index,
            surface_index = character.surface_index,
            zoom = 1,
            ignored_by_interaction = true,
            style = "mult_chars_minimap"
        }

        local frame = v_flow.add {
            type = "frame",
            style = "deep_frame_in_shallow_frame",
        }
        local h_flow = frame.add {
            type = "flow",
            direction = "horizontal"
        }
        h_flow.style.vertical_align = "center"
        h_flow.style.horizontal_align = "left"
        h_flow.style.horizontally_stretchable = "on"
        h_flow.style.margin = 0
        h_flow.style.padding = 2

        local style = "mult_chars_character_button"
        if player == character.player then
            style = "mult_chars_active_character_button"
        elseif character.player ~= nil then
            style = "mult_chars_other_character_button"
        end

        h_flow.add {
            type = "sprite-button",
            name = "mult_chars_char",
            sprite = "item/" .. character.name,
            style = style,
            tags = {
                action = "mult_chars_switch_character",
                character_unit_number = character.unit_number,
            }
        }

        local name = nil
        if global.character_name ~= nil then
            name = global.character_name[character.unit_number]
        end
        if name == nil then
            name = player.name
        end

        local label = h_flow.add { type = "label", caption = name }
        ::continue::
    end
end

script.on_event(defines.events.on_gui_closed, function(event)
    if event.element and event.element.name == "mult_chars_main_frame" then
        local player = game.get_player(event.player_index)
        toggle_gui(player)
    end
end)

script.on_event(defines.events.on_gui_click, function(event)
    if event.element.tags ~= nil and event.element.tags.action == "mult_chars_switch_character" then
        local player = game.players[event.player_index]
        local character = global.unit_number_character[event.element.tags.character_unit_number]
        switch_to(player, character)
    end
end)

script.on_event(defines.events.on_gui_closed, function(event)
    if event.element and event.element.name == "mult_chars_main_frame" then
        local player = game.players[event.player_index]
        toggle_gui(player)
    end
end)
