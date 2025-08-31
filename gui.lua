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
    local main_frame = screen_element.mult_chars_main_frame

    if main_frame == nil then
        main_frame = screen_element.add {
            type = "frame",
            name = "mult_chars_main_frame",
            caption = { "multiple-characters.window-title" },
        }
        main_frame.auto_center = true
    else
        main_frame.clear()
    end
    main_frame.style.use_header_filler = true

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
    controls_flow.style.minimal_width = 174 * 4
    controls_flow.style.horizontally_stretchable = true

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

---@param player LuaPlayer
function build_table(player)
    if player.gui.screen.mult_chars_main_frame == nil then return end

    local table = player.gui.screen.mult_chars_main_frame.content_frame.inner_frame.controls_flow.table
    if table == nil then return end
    table.clear()

    for _, character in pairs(storage.unit_number_character) do
        if not character.valid then goto continue end

        local outer_frame = table.add {
            type = "frame",
            direction = "horizontal",
            style = "mult_chars_char_frame"
        }

        build_frame(outer_frame, character, player)

        ::continue::
    end
end

---@param outer_frame LuaGuiElement
---@param character LuaEntity
---@param player LuaPlayer
function build_frame(outer_frame, character, player)
    local unit_number = character.unit_number

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
            character_unit_number = unit_number,
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
    h_flow.style.horizontally_stretchable = true
    h_flow.style.margin = 0
    h_flow.style.padding = 2
    h_flow.style.maximal_width = 150

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
            character_unit_number = unit_number,
        }
    }

    local name = nil
    if storage.character_name ~= nil then
        name = storage.character_name[unit_number]
    end
    if name == nil then
        name = player.name
    end

    if storage.renaming_character == nil then
        storage.renaming_character = {}
    end
    if storage.renaming_character[player.index] == unit_number then
        local textfield = h_flow.add {
            type = "textfield",
            name = "mult_chars_rename_field",
            text = name,
            icon_selector = true,
            tags = {
                character_unit_number = unit_number,
            }
        }
        textfield.style.width = 100
        textfield.style.natural_width = 100

        textfield.focus()
        textfield.select_all()
    else
        local label = h_flow.add {
            type = "label",
            caption = name
        }
        label.style.maximal_width = 100 - 20

        local v_flow = h_flow.add {
            type = "flow",
            direction = "vertical"
        }

        v_flow.add {
            type = "sprite-button",
            name = "mult_chars_rename_char",
            style = "mini_button",
            sprite = "utility/rename_icon",
            tags = {
                action = "mult_chars_rename_character",
                character_unit_number = unit_number,
            }
        }

        v_flow.add {
            type = "sprite-button",
            name = "mult_chars_recolor_char",
            style = "mini_button",
            sprite = "utility/color_picker",
            tags = {
                action = "mult_chars_recolor_character",
                character_unit_number = unit_number,
            }
        }
    end
end

---@param player LuaPlayer
function build_color_picker(player, color)
    local screen_element = player.gui.screen

    local color_picker = screen_element.mult_chars_color_picker

    if color_picker == nil then
        color_picker = screen_element.add {
            type = "frame",
            name = "mult_chars_color_picker",
        }
    else
        color_picker.clear()
    end

    color_picker.auto_center = true
    color_picker.bring_to_front()
    player.opened = color_picker

    local v_flow = color_picker.add {
        type = "flow",
        direction = "vertical"
    }

    local r_flow = v_flow.add {
        type = "flow",
        direction = "horizontal"
    }
    r_flow.style.vertical_align = "center"
    local r_label = r_flow.add {
        type = "label",
        caption = "Red: ",
    }
    r_label.style.width = 50
    r_flow.add {
        type = "slider",
        name = "mult_chars_r_slider",
        minimum_value = 0,
        maximum_value = 1,
        discrete_values = false,
        value = color.r,
    }

    local g_flow = v_flow.add {
        type = "flow",
        direction = "horizontal"
    }
    g_flow.style.vertical_align = "center"
    local g_label = g_flow.add {
        type = "label",
        caption = "Green: ",
    }
    g_label.style.width = 50
    g_flow.add {
        type = "slider",
        name = "mult_chars_g_slider",
        minimum_value = 0,
        maximum_value = 1,
        discrete_values = false,
        value = color.g,
    }

    local b_flow = v_flow.add {
        type = "flow",
        direction = "horizontal"
    }
    b_flow.style.vertical_align = "center"
    local b_label = b_flow.add {
        type = "label",
        caption = "Blue: ",
    }
    b_label.style.width = 50
    b_flow.add {
        type = "slider",
        name = "mult_chars_b_slider",
        minimum_value = 0,
        maximum_value = 1,
        discrete_values = false,
        value = color.b,
    }
end

script.on_event(defines.events.on_gui_closed,
    ---@param event EventData.on_gui_closed
    function(event)
        if event.element and event.element.name == "mult_chars_main_frame" then
            local player = game.get_player(event.player_index)
            storage.renaming_character[event.player_index] = nil
            toggle_gui(player)
        elseif event.element and event.element.name == "mult_chars_color_picker" then
            local player = game.get_player(event.player_index)

            local color = storage.recoloring_character[event.player_index].color
            local unit_number = storage.recoloring_character[event.player_index].unit_number

            if color then
                storage.unit_number_character[unit_number].color = color
            end

            storage.recoloring_character[event.player_index] = nil

            event.element.destroy()
            toggle_gui(player)
        end
    end)

script.on_event(defines.events.on_gui_click,
    ---@param event EventData.on_gui_click
    function(event)
        if not (event.element and event.element.tags) then return end

        if event.element.tags.action == "mult_chars_switch_character" then
            local player = game.players[event.player_index]
            local character = storage.unit_number_character[event.element.tags.character_unit_number]
            switch_to(player, character)
        elseif event.element.tags.action == "mult_chars_rename_character" then
            local player = game.players[event.player_index]
            if storage.renaming_character == nil then
                storage.renaming_character = {}
            end
            storage.renaming_character[event.player_index] = event.element.tags.character_unit_number
            build_gui(player)
        elseif event.element.tags.action == "mult_chars_recolor_character" then
            local player = game.players[event.player_index]
            if storage.recoloring_character == nil then
                storage.recoloring_character = {}
            end

            local color = storage.unit_number_character[event.element.tags.character_unit_number].color
            color.a = 0.5
            storage.recoloring_character[event.player_index] = {
                unit_number = event.element.tags.character_unit_number,
                color = color
            }
            build_color_picker(player, color)
        end
    end)

script.on_event(defines.events.on_gui_confirmed,
    ---@param event EventData.on_gui_confirmed
    function(event)
        if event.element.name == "mult_chars_rename_field" then
            storage.renaming_character[event.player_index] = nil
            rename_character(event.element.tags.character_unit_number, event.element.text)
            build_gui(game.players[event.player_index])
        end
    end
)

script.on_event(defines.events.on_gui_value_changed,
    ---@param event EventData.on_gui_value_changed
    function(event)
        if not (storage.recoloring_character and storage.recoloring_character[event.player_index]) then return end

        local color = storage.recoloring_character[event.player_index].color or { r = 0, g = 0, b = 0, a = 1 }

        if event.element.name == "mult_chars_r_slider" then
            color.r = event.element.slider_value
        elseif event.element.name == "mult_chars_g_slider" then
            color.g = event.element.slider_value
        elseif event.element.name == "mult_chars_b_slider" then
            color.b = event.element.slider_value
        else
            return
        end

        storage.recoloring_character[event.player_index].color = color

        local unit_number = storage.recoloring_character[event.player_index].unit_number

        storage.unit_number_character[unit_number].color = color
    end
)
