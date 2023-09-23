local minimap_size = 150

local styles = data.raw["gui-style"].default

styles["mult_chars_content_frame"] = {
    type = "frame_style",
    parent = "inside_shallow_frame_with_padding",
    vertically_stretchable = "on"
}

styles["mult_chars_char_frame"] = {
    type = "frame_style",
    graphical_set =
    {
        base = { position = { 68, 0 }, corner_size = 8 },
        shadow = {
            position = { 200, 128 },
            corner_size = 8,
            tint = { 0, 0, 0, 0.35 },
            scale = 0.5,
            draw_type = "outer"
        },
    },
    width = minimap_size + 16 + 8,
    height = minimap_size + 44 + 24 + 12,
    padding = 8,
}

local minimap_button_graphical_set = {
    base =
    {
        position = { 85, 0 },
        corner_size = 8,
        center = { position = { 42, 8 }, size = { 1, 1 } },
        draw_type = "outer"
    },
    shadow = {
        position = { 183, 128 },
        corner_size = 8,
        tint = { 0, 0, 0, 1 },
        scale = 0.5,
        draw_type = "inner"
    }
}

styles["mult_chars_minimap_button"] = {
    type = "button_style",
    parent = "button",
    padding = 1,
    width = minimap_size,
    height = minimap_size,
    default_graphical_set = minimap_button_graphical_set,
    hovered_graphical_set = minimap_button_graphical_set,
    clicked_graphical_set = minimap_button_graphical_set,
    disabled_graphical_set = minimap_button_graphical_set,
    selected_graphical_set = minimap_button_graphical_set,
    selected_hovered_graphical_set = minimap_button_graphical_set,
    selected_clicked_graphical_set = minimap_button_graphical_set,
}

styles["mult_chars_minimap"] = {
    type = "minimap_style",
    width = minimap_size - 2,
    height = minimap_size - 2,
    vertical_align = "center",
    horizontal_align = "center",
    default_graphical_set =
    {
        base =
        {
            position = { 85, 0 },
            corner_size = 8,
            center = { position = { 42, 8 }, size = { 1, 1 } },
            draw_type = "outer"
        },
        shadow = {
            position = { 200, 128 },
            corner_size = 8,
            tint = { 0, 0, 0, 1 },
            scale = 0.5,
            draw_type = "outer"
        }
    },
}

styles["mult_chars_controls_flow"] = {
    type = "scroll_pane_style",
    graphical_set = {},
    background_graphical_set =
    {
        position = { 282, 17 },
        corner_size = 8,
        overall_tiling_vertical_size = minimap_size + 72 - 8,
        overall_tiling_vertical_spacing = 16,
        overall_tiling_vertical_padding = 8,
        overall_tiling_horizontal_size = minimap_size + 16 - 8,
        overall_tiling_horizontal_spacing = 16,
        overall_tiling_horizontal_padding = 8,
    },
    padding = 0,
    extra_padding_when_activated = 0,
}

styles["mult_chars_controls_textfield"] = {
    type = "textbox_style",
    width = 36
}

styles["mult_chars_table"] = {
    type = "table_style",
    horizontally_stretchable = "off",
    horizontal_spacing = 0,
    vertical_spacing = 0,
    margin = 0,
}

styles["mult_chars_character_button"] = {
    type = "button_style",
    parent = "button",
    width = 40,
    height = 40,
    padding = 0,
    default_graphical_set =
    {
        position = { 0, 0 },
        corner_size = 8
    }
}

styles["mult_chars_active_character_button"] = {
    type = "button_style",
    parent = "button",
    width = 40,
    height = 40,
    padding = 0,
    default_graphical_set =
    {
        position = { 51, 17 },
        corner_size = 8
    },
}

styles["mult_chars_other_character_button"] = {
    type = "button_style",
    parent = "button",
    width = 40,
    height = 40,
    padding = 0,
}
