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
}

styles["mult_chars_minimap_button"] = {
    type = "button_style",
    parent = "button",
    padding = 1,
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
            position = { 183, 128 },
            corner_size = 8,
            tint = { 0, 0, 0, 1 },
            scale = 0.5,
            draw_type = "inner"
        }
    },
    hovered_graphical_set =
    {
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
    },
    clicked_graphical_set =
    {
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
    },
    disabled_graphical_set =
    {
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
    },
    selected_graphical_set =
    {
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
    },
    selected_hovered_graphical_set =
    {
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
    },
    selected_clicked_graphical_set =
    {
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
    },
}

styles["mult_chars_minimap"] = {
    type = "minimap_style",
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
        overall_tiling_vertical_size = 196 - 8,
        overall_tiling_vertical_spacing = 16,
        overall_tiling_vertical_padding = 8,
        overall_tiling_horizontal_size = 144 - 8,
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
    -- parent = "slot_table",
    -- vertically_stretchable = "on",
    horizontally_stretchable = "off",
    horizontal_spacing = 0,
    vertical_spacing = 0,
    margin = 0,
}
