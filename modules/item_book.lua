RB_CURSOR_SPR = -1
RB_SLOT_SPR = -1
DISPLAY_CHAR_AMT = 22


function prep_recipe_book()
    RB_CURSOR_SPR = api_define_sprite("rb_cursor", "sprites/recipe_book/recipe_book_cursor.png", 2)
    RB_SLOT_SPR = api_define_sprite("rb_slot", "sprites/recipe_book/rb_slot.png", 2)
end

function define_recipe_book()
    api_define_menu_object({
        id = "recipe_book",
        name = "Recipe_Book",
        define = "define_book",
        category = "Books",
        tooltip = "Hopefully all the items !",
        shop_key = false,
        shop_buy = 0,
        shop_sell = 0,
        center = true,
        layout = {},
        buttons = {"Close", "Move"},
        info = {},
        tools = {"mouse1", "hammer1"},
        placeable = true
    }, "sprites/recipe_book/recipe_book.png", "sprites/recipe_book/recipe_book_gui.png", {
        define = "recipe_book_define",
        draw = "draw_book"
    })
    prep_recipe_book()
end

function recipe_book_define(menu_id)
    api_dp(menu_id, "search", "")
    api_dp(menu_id, "cursor_index", 0)
    api_dp(menu_id, "cursor_relative", 0)
    api_dp(menu_id, "display_start", 0)
    api_log("rb", "defining buttons ...")
    define_items_buttons(menu_id, 174, 25)
    api_log("rb", "defined buttons !!")
    set_button_text(menu_id, 1)
end

function draw_book(menu_id)
    local menu = api_get_inst(menu_id)
    if menu ~= nil then
        local cam = api_get_cam()
        local mx = math.floor(menu["x"] - cam["x"])
        local my = math.floor(menu["y"] - cam["y"])
        local search_box_pos = {x = 20, y = 28}
        local sb_width = 126
        api_draw_sprite(menu["sprite_index"], 0, mx, my)
        local search_text = api_gp(menu_id, "search")
        local cursor_index = api_gp(menu_id, "cursor_index")
        local cursor_relative = api_gp(menu_id, "cursor_relative")
        local display_start = api_gp(menu_id, "display_start")
        local search_text = string.sub(search_text, display_start, display_start + DISPLAY_CHAR_AMT)
        api_draw_text(mx + search_box_pos["x"], my + search_box_pos["y"], search_text, false, "FONT_GREY", nil)
        local cursor_px = get_string_px(string.sub(search_text, 1, cursor_relative))
        api_draw_sprite(RB_CURSOR_SPR, 1, mx + search_box_pos["x"] + cursor_px, my + search_box_pos["y"])
        draw_item_buttons(menu_id)
        draw_item_sprites(menu_id, mx + 174 + 2, my + 25 + 2)
        draw_hovered_item_tooltip(menu_id)
    end
end

function define_items_buttons(menu_id, tx, ty)
    api_log("rb", "starting for loops ...")
    local spacing = {x = 23, y = 23}
    for by=1,9 do
        for bx=1,6 do
            api_define_button(menu_id, "item_button" .. (6 * (by - 1) + bx), tx + (bx - 1) * spacing["x"], ty + (by - 1) * spacing["y"], "", "item_click", "sprites/recipe_book/rb_slot.png")
            api_sp(api_gp(menu_id, "item_button" .. (6 * (by - 1) + bx)), "index", 1)
        end
    end
end

function draw_item_buttons(menu_id)
    for y=1,9 do
        for x=1,6 do
            api_draw_button(api_gp(menu_id, "item_button" .. (6 * (y - 1) + x)), false)
        end
    end
end

function draw_item_sprites(menu_id, tx, ty)
    local spacing = {x = 23, y = 23}
    for y=1,9 do
        for x=1,6 do
            local item_name = api_gp(api_gp(menu_id, "item_button" .. (6 * (y - 1) + x)), "text")
            if item_name ~= "" then
                api_draw_sprite(ITEM_REGISTRY[item_name]["sprite"], 0, tx + (x - 1) * spacing["x"], ty + (y - 1) * spacing["y"])
            end
        end
    end
end

function set_button_text(menu_id, filtered_item_list)
    local items_shown = 54
    for i=1,items_shown do
        if i <= #filtered_item_list then
            api_sp(api_gp(menu_id, "item_button" .. i), "text", filtered_item_list[i])
        else
            api_sp(api_gp(menu_id, "item_button" .. i), "text", "")
        end
    end
end

function type_char(menu_id, keycode)
    local pkey = KEYCODES[keycode]
    local search = api_gp(menu_id, "search")
    local ci = api_gp(menu_id, "cursor_index")
    if pkey == "BACKSPACE" then
        api_sp(menu_id, "search", modify_string(search, ci, "", true))
        move_cursor(menu_id, -1)
    elseif pkey == "LEFT" then
        move_cursor(menu_id, -1)
    elseif pkey == "RIGHT" then
        move_cursor(menu_id, 1)
    else
        ci = api_gp(menu_id, "cursor_index")
        api_sp(menu_id, "search", modify_string(search, ci, pkey, false))
        move_cursor(menu_id, 1)
    end
    set_button_text(menu_id, filter_items(api_gp(menu_id, "search")))
end

function move_cursor(menu_id, change)
    local ci = api_gp(menu_id, "cursor_index") + change
    local cr = api_gp(menu_id, "cursor_relative") + change
    local ds = api_gp(menu_id, "display_start") + change
    if 1 <= ci and ci <= #api_gp(menu_id, "search") then
        api_sp(menu_id, "cursor_index", ci)
        if cr < 1 or cr > DISPLAY_CHAR_AMT then
            api_sp(menu_id, "display_start", ds)
        else
            api_sp(menu_id, "cursor_relative", cr)
        end
    end
end

function modify_string(str, pos, change, insert)
    local out = ""
    if insert then
        out = string.sub(str, 1, pos - 1) .. change .. string.sub(str, pos + 1, -1)
    else
        out = string.sub(str, 1, pos) .. change .. string.sub(str, pos + 1, -1)
    end
    return out
end

function item_click(menu_id, button_id)
    api_log("press !", api_gp(button_id, "text"))
end

function draw_hovered_item_tooltip(menu_id)
	local hl_menu = api_get_highlighted("menu")
	if hl_menu == menu_id then
		local hl_button = api_get_highlighted("ui")
		if hl_button ~= nil then
			local item = api_gp(hl_button, "text")
			if item ~= "" then
				if api_gp(hl_button, "index") == 1 and item ~= nil then
					draw_tooltip(item, menu_id)
				end
			end
		end
	end
end