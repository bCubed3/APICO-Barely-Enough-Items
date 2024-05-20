-- item_book.lua

RB_CURSOR_SPR = -1
RB_SLOT_SPR = -1
TEXTBOX_SIZE = 122
RB_MENU = -1


function prep_recipe_book()
    RB_CURSOR_SPR = api_define_sprite("rb_cursor", "sprites/recipe_book/recipe_book_cursor.png", 2)
    RB_SLOT_SPR = api_define_sprite("rb_slot", "sprites/recipe_book/rb_slot.png", 2)
    RB_CRAFT_ARROW = api_define_sprite("rb_craft_arrow", "sprites/recipe_book/rb_craft_arrow.png", 1)
    RB_ITEM_UNDERLINE = api_define_sprite("rb_item_underline", "sprites/recipe_book/rb_item_underline.png", 1)
end

function create_recipe_book()
    local old_recipe_books = api_all_menu_objects(MOD_NAME .. "_recipe_book")
    for i=1,#old_recipe_books do
        api_destroy_inst(old_recipe_books[i])
    end
    api_create_obj(MOD_NAME .. "_recipe_book", 0, 0)
    api_library_add_book("recipe_book", "open_recipe_book", "sprites/recipe_book/recipe_book_button.png")
end

function open_recipe_book()
    api_toggle_menu(RB_MENU, true)
end

function define_recipe_book()
    api_define_menu_object2({
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
        placeable = true,
        invisible = true
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
    api_dp(menu_id, "display_end", 0)
    api_dp(menu_id, "selected_item", nil)
    api_dp(menu_id, "bei_scroll", 0)
    api_dp(menu_id, "search_results", nil)
    api_dp(menu_id, "si_workstations", nil)
    api_dp(menu_id, "text_scroll", 0)
    --api_log("rb", "defining buttons ...")
    define_items_buttons(menu_id, 174, 25)
    for i=1,3 do
        api_define_button(menu_id, "recipe_item" .. i, 382 + (i - 1) * 23, 25, "", "item_click", "sprites/recipe_book/rb_slot.png")
        api_sp(api_gp(menu_id, "recipe_item" .. i), "index", 1)
    end
    set_button_text(menu_id, filter_items(""))
    api_define_button(menu_id, "button_items_up", 234, 11, "", "items_up", "sprites/recipe_book/rb_up.png")
    api_define_button(menu_id, "button_items_down", 234, 235, "", "items_down", "sprites/recipe_book/rb_down.png")
    api_define_button(menu_id, "item_large", 334, 25, "", "bei_do_nothing", "sprites/recipe_book/rb_slot_large.png")
    api_define_button(menu_id, "crafting_bench", 451, 48, "rotating_workstation", "wb_item_click", "sprites/recipe_book/rb_slot.png")
    api_define_button(menu_id, "text_down", 387, 243, "", "text_down", "sprites/recipe_book/rb_down.png")
    api_define_button(menu_id, "text_up", 405, 243, "", "text_up", "sprites/recipe_book/rb_up.png")
    api_sp(api_gp(menu_id, "crafting_bench"), "index", 1)
    api_sp(api_gp(menu_id, "item_large"), "index", 1)
    RB_MENU = menu_id
    local objs = api_get_menu_objects()
    for i=1,#objs do
        if objs[i]["oid"] == MOD_NAME .. "_recipe_book" then
            api_set_immortal(objs[i]["id"], true)
        end
    end
end

-- draw the book itself
function draw_book(menu_id)
    local menu = api_get_inst(menu_id)
    if menu ~= nil then
        local cam = api_get_cam()
        local mx = math.floor(menu["x"] - cam["x"])
        local my = math.floor(menu["y"] - cam["y"])
        local search_box_pos = {x = 20, y = 28}
        --local sb_width = 126
        api_draw_sprite(menu["sprite_index"], 0, mx, my)
        local search_text = api_gp(menu_id, "search")
        local cursor_index = api_gp(menu_id, "cursor_index")
        local cursor_relative = api_gp(menu_id, "cursor_relative")
        local display_start = api_gp(menu_id, "display_start")
        local display_end = api_gp(menu_id, "display_end")
        search_text = string.sub(search_text, display_start, display_end)
        api_draw_text(mx + search_box_pos["x"], my + search_box_pos["y"], search_text, false, "FONT_GREY", nil)
        local cursor_px = get_string_px(string.sub(search_text, 1, cursor_relative))
        --api_log("cpx", cursor_px)
        -- draw search bar cursor
        api_draw_sprite(RB_CURSOR_SPR, 1, mx + search_box_pos["x"] + cursor_px, my + search_box_pos["y"])
        draw_item_buttons(menu_id)
        draw_item_sprites(menu_id, mx + 174 + 2, my + 25 + 2)
        draw_hovered_item_tooltip(menu_id)
        local selected_item = api_gp(menu_id, "selected_item")
        if selected_item ~= nil then
            if ITEM_REGISTRY[selected_item]["itype"] == "npc" then
                draw_npc_info(menu_id, mx + 334 + 4, my + 25 + 4)
            elseif ITEM_REGISTRY[selected_item]["itype"] == "bee" then
                draw_bee_info(menu_id, mx + 334 + 4, my + 25 + 4)
            elseif ITEM_REGISTRY[selected_item]["itype"] == "butterfly" then
                draw_butterfly_info(menu_id, mx + 334 + 4, my + 25 + 4)
            else
                draw_item_info(menu_id, mx + 334 + 4, my + 25 + 4)
            end
        end
        
        -- draw arrow buttons
        api_draw_button(api_gp(menu_id, "button_items_down"), false)
        api_draw_button(api_gp(menu_id, "button_items_up"), false)
        --api_draw_text(0, 100, "ci : " .. cursor_index .. ", cr : " .. cursor_relative .. ", ds : " .. display_start .. ", de : " .. display_end, true)
    end
end

-- draw information about the item, for ALL TYPES OF ITEM
function draw_info(menu_id, x, y, selected_item, recipe, text)
    if selected_item ~= nil then
        --local idef = api_get_definition(selected_item)
        api_draw_button(api_gp(menu_id, "item_large"), false)
        api_draw_sprite(RB_ITEM_UNDERLINE, 0, x - 3, y + 37)
        
        if recipe ~= nil then
            api_draw_button(api_gp(menu_id, "crafting_bench"), false)
            api_draw_sprite(RB_CRAFT_ARROW, 0, x + 42, y + 18)
            -- draw the 3 recipe items
            -- the workstation is drawn elsewhere (rotating_workstation)
            for i=1,3 do
                local ri_button = api_gp(menu_id, "recipe_item" .. i)
                api_draw_button(ri_button, false)
                local recipe_item = ITEM_REGISTRY[api_gp(ri_button, "text")]
                if recipe_item ~= nil then
                    if recipe_item["itype"] == "bee" then
                        api_draw_sprite(recipe_item["sprite"], 0, x + 46 + (i - 1) * 23 - 1, y - 2 - 1)
                    else
                        api_draw_sprite(recipe_item["sprite"], 0, x + 46 + (i - 1) * 23, y - 2)
                    end
                end
            end
            for i=1,3 do
                if recipe["recipe"][i] ~= nil and recipe["recipe"][i]["amount"] > 1 then
                    api_draw_number(x + 42 + (i) * 23, y - 2 + 20, recipe["recipe"][i]["amount"])
                end
            end
        end
        if ITEM_REGISTRY[selected_item]["itype"] == "bee" or ITEM_REGISTRY[selected_item]["itype"] == "butterfly" then
            api_draw_sprite_ext(ITEM_REGISTRY[selected_item]["sprite"], 0, x - 2, y - 2, 2, 2, 0, 0, 1)
        else
            api_draw_sprite_ext(ITEM_REGISTRY[selected_item]["sprite"], 0, x, y, 2, 2, 0, 0, 1)
        end
        if recipe ~= nil and recipe["amount"] > 1 then
            api_draw_number(x + 37, y + 38, recipe["amount"])
        end
        
        if recipe ~= nil then
            local crafting_bench = recipe["workstations"]
            if #crafting_bench ~= 0 then
                api_draw_sprite(ITEM_REGISTRY[crafting_bench[TIMER % #crafting_bench + 1]]["sprite"], 0, x + 115, y + 21)
            end
        end
        local num_lines = get_lines_height(text, 143)
        local text_height = 0
        local text_scroll = api_gp(menu_id, "text_scroll")
        --api_log("ts", text_scroll)
        if num_lines > 12 then
            api_draw_button(api_gp(menu_id, "text_down"), false)
            api_draw_button(api_gp(menu_id, "text_up"), false)
            if text_scroll > num_lines - 12 then
                api_sp(menu_id, "text_scroll", num_lines - 12)
                text_scroll = num_lines - 12
            end
            text_height = draw_text_lines(text, x - 7, y + 42, 143, text_scroll, 12)
        else
            if text_scroll > 0 then
                api_sp(menu_id, "text_scroll", 0)
            end
            text_height = draw_text_lines(text, x - 7, y + 42, 143, 0, 12)
        end
        return text_height
    end
end

-- default draw call for items (calls draw_info)
function draw_item_info(menu_id, x, y)
    local selected_item = api_gp(menu_id, "selected_item")
    if selected_item ~= nil then
        local idef = api_get_definition(selected_item)
        local text_to_draw = {}
        if idef ~= nil then
            text_to_draw = {
                {text = idef["name"] or selected_item, color = "FONT_BOOK"},
                {text = MOD_REGISTRY[ITEM_REGISTRY[selected_item]["mod"]], color = "FONT_ORANGE"},
                {text = idef["category"], color = "FONT_BLUE"},
                {text = idef["tooltip"], color = "FONT_BOOK"},
                {text = "oid : " .. selected_item, color = "FONT_GREY"}
            }
            local sell = 0
            local buy = 0
            if idef["cost"] ~= nil then
                sell = idef["cost"]["sell"]
                buy = idef["cost"]["buy"]
            end
            if sell ~= 0 then
                if idef["honeycore"] == 1 then
                    table.insert(text_to_draw, 4, {text = "Sells for $" .. sell, color = "FONT_ORANGE"})
                else
                    table.insert(text_to_draw, 4, {text = "Sells for £" .. sell, color = "FONT_YELLOW"})
                end
            end
            if buy ~= 0 then
                if idef["honeycore"] == 1 then
                    table.insert(text_to_draw, 5, {text = "Buy for $" .. buy, color = "FONT_ORANGE"})
                else
                    table.insert(text_to_draw, 5, {text = "Buy for £" .. buy, color = "FONT_YELLOW"})
                end
            end
        end
        local text_height = draw_info(menu_id, x, y, selected_item, RECIPE_REGISTRY[selected_item], text_to_draw)
    end
end

-- separate info draw for npcs
function draw_npc_info(menu_id, x, y)
    local selected_item = api_gp(menu_id, "selected_item")
    if selected_item ~= nil then
        local idef = api_get_definition(selected_item)
        local text_to_draw = {}
        if idef ~= nil then
            text_to_draw = {
                {text = idef["name"], color = "FONT_BOOK"},
                {text = MOD_REGISTRY[ITEM_REGISTRY[selected_item]["mod"]], color = "FONT_ORANGE"},
                {text = idef["category"], color = "FONT_BLUE"},
                {text = idef["tooltip"], color = "FONT_BOOK"},
                {text = "oid : " .. selected_item, color = "FONT_GREY"}
            }
        end
        local text_height = draw_info(menu_id, x, y, selected_item, RECIPE_REGISTRY[selected_item], text_to_draw)
        draw_npc_shop(selected_item, x - 7, y + 42 + text_height)
    end
end

-- separate info draw for bees
function draw_bee_info(menu_id, x, y)
    local selected_item = api_gp(menu_id, "selected_item")
    if selected_item ~= nil then
        local idef = ITEM_REGISTRY[selected_item]
        local text_to_draw = {}
        if idef ~= nil then
            --api_log("desc", idef["desc"])
            text_to_draw = {
                {text = idef["name"], color = "FONT_BOOK"},
                {text = MOD_REGISTRY[ITEM_REGISTRY[selected_item]["mod"]], color = "FONT_ORANGE"},
                {text = "Bee", color = "FONT_BLUE"},
                {text = idef["desc"], color = "FONT_BOOK"},
                {text = "oid : " .. selected_item, color = "FONT_GREY"}
            }
            if idef["req"] ~= nil and idef["req"] ~= "" then
                table.insert(text_to_draw, 5, {text = "Bred : " .. idef["req"], color = "FONT_BOOK"})
            end
        end
        local text_height = draw_info(menu_id, x, y, selected_item, RECIPE_REGISTRY[selected_item], text_to_draw)
    end
end

-- draw separate info for butterflies
function draw_butterfly_info(menu_id, x, y)
    local selected_item = api_gp(menu_id, "selected_item")
    if selected_item ~= nil then
        local idef = ITEM_REGISTRY[selected_item]
        local text_to_draw = {}
        if idef ~= nil then
            --api_log("desc", idef["desc"])
            local enjoys_rain = "does not enjoy"
            if idef["pluviophile"] == 1 then
                enjoys_rain = "enjoys"
            end
            text_to_draw = {
                {text = idef["name"], color = "FONT_BOOK"},
                {text = MOD_REGISTRY[ITEM_REGISTRY[selected_item]["mod"]], color = "FONT_ORANGE"},
                {text = "Tier " .. math.floor(idef["tier"]) .. " Butterfly", color = "FONT_BLUE"},
                {text = "Flowers:", color = "FONT_RED"},
                {spr = idef["flowers"]},
                {text = "Flora:", color = "FONT_RED"},
                {spr = {idef["flora"]}},
                {text = idef["desc"], color = "FONT_BOOK"},
                {text = "The " .. idef["title"] .. " butterfly exhibits " .. string.lower(idef["behavior"]) .. " behaviour and " .. enjoys_rain .. " the rain. It prefers a " .. string.lower(idef["climate"]) .. " climate and can be found in the " .. string.lower(idef["biome"]) .. " biome.", color = "FONT_GREY"},
                {text = "oid : " .. selected_item, color = "FONT_GREY"}
            }
            if idef["req"] ~= nil and idef["req"] ~= "" then
                table.insert(text_to_draw, 5, {text = "Bred : " .. idef["req"], color = "FONT_BOOK"})
            end
        end
        local text_height = draw_info(menu_id, x, y, selected_item, RECIPE_REGISTRY[selected_item], text_to_draw)
    end
end

-- draw the items sold by npcs (currently does not work with rotating stock)
function draw_npc_shop(selected_item, x, y)
    local item = ""
    local price = ""
    local hc = ""
    if NPC_REGISTRY[selected_item] ~= nil then
        for i=1,#NPC_REGISTRY[selected_item] do
            item = NPC_REGISTRY[selected_item][i]["item"]
            price = NPC_REGISTRY[selected_item][i]["buy"]
            hc = NPC_REGISTRY[selected_item][i]["honeycore"]
            api_draw_sprite(RB_SLOT_SPR, 0, x + 23 * ((i - 1) % 5), y + 23 * ((i - 1) // 5))
            api_draw_sprite(ITEM_REGISTRY[item]["sprite"], 0, x + 2 + 23 * ((i - 1) % 5), y + 2 + 23 * ((i - 1) // 5))
            if hc then
                api_draw_number(x + 22 + 23 * ((i - 1) % 5), y + 22 + 23 * ((i - 1) // 5), "$".. math.floor(price), "FONT_ORANGE")
            else
                api_draw_number(x + 22 + 23 * ((i - 1) % 5), y + 22 + 23 * ((i - 1) // 5), "£".. math.floor(price), "FONT_YELLOW")
            end
        end
    end
end

function define_items_buttons(menu_id, tx, ty)
    --api_log("rb", "starting for loops ...")
    local spacing = {x = 23, y = 23}
    for by=1,9 do
        for bx=1,6 do
            api_define_button(menu_id, "item_button" .. (6 * (by - 1) + bx), tx + (bx - 1) * spacing["x"], ty + (by - 1) * spacing["y"], "", "item_click", "sprites/recipe_book/rb_slot.png")
            api_sp(api_gp(menu_id, "item_button" .. (6 * (by - 1) + bx)), "index", 1)
        end
    end
end

-- draw buttons for items in search preview
function draw_item_buttons(menu_id)
    for y=1,9 do
        for x=1,6 do
            api_draw_button(api_gp(menu_id, "item_button" .. (6 * (y - 1) + x)), false)
        end
    end
end

-- draw sprites in search preview
function draw_item_sprites(menu_id, tx, ty)
    local spacing = {x = 23, y = 23}
    for y=1,9 do
        for x=1,6 do
            local item_name = api_gp(api_gp(menu_id, "item_button" .. (6 * (y - 1) + x)), "text")
            if item_name ~= "" then
                if ITEM_REGISTRY[item_name]["itype"] == "bee" or ITEM_REGISTRY[item_name]["itype"] == "butterfly" then
                    api_draw_sprite(ITEM_REGISTRY[item_name]["sprite"], 0, tx + (x - 1) * spacing["x"] - 1, ty + (y - 1) * spacing["y"] - 1)
                else
                    api_draw_sprite(ITEM_REGISTRY[item_name]["sprite"], 0, tx + (x - 1) * spacing["x"], ty + (y - 1) * spacing["y"])
                end
            end
        end
    end
end

function set_button_text(menu_id, filtered_item_list)
    table.sort(filtered_item_list)
    api_sp(menu_id, "search_results", filtered_item_list)
    local scroll = api_gp(menu_id, "bei_scroll") * 6
    local items_shown = 54
    for i=1,items_shown do
        if math.floor(i + scroll) <= #filtered_item_list then
            api_sp(api_gp(menu_id, "item_button" .. i), "text", filtered_item_list[math.floor(i + scroll)])
        else
            api_sp(api_gp(menu_id, "item_button" .. i), "text", "")
        end
    end
end

function type_char(menu_id, keycode)
    --api_log("keycode", keycode)
    api_sp(menu_id, "bei_scroll", 0)
    local pkey = -1
    if api_get_key_down("SHFT") == 1 then
        pkey = KEYCODES[keycode + 200]
    else
        pkey = KEYCODES[keycode]
    end
    
    local search = api_gp(menu_id, "search")
    local ci = api_gp(menu_id, "cursor_index")
    local cr = api_gp(menu_id, "cursor_relative")
    local ds = api_gp(menu_id, "display_start")
    local de = api_gp(menu_id, "display_end")
    if pkey == "BACKSPACE" then
        if ci > 0 then
            if ci > cr then
                api_sp(menu_id, "search", modify_string(search, ci, "", true))
                api_sp(menu_id, "cursor_index", ci - 1)
                scroll_textbox_left(menu_id, 1)
            else
                api_sp(menu_id, "search", modify_string(search, ci, "", true))
                move_cursor(menu_id, -1)
            end
        end
    elseif pkey == "ENTER" then
    elseif keycode == 16 then
    elseif pkey == "CTRL" then
    elseif pkey == "LEFT" then
        move_cursor(menu_id, -1)
    elseif pkey == "RIGHT" then
        move_cursor(menu_id, 1)
    else
        ci = api_gp(menu_id, "cursor_index")
        api_sp(menu_id, "search", modify_string(search, ci, pkey, false))
        scroll_textbox_right(menu_id, 1)
        move_cursor(menu_id, 1)
    end
    de = api_gp(menu_id, "display_end")
    search = api_gp(menu_id, "search")
    if de > #search then
        api_sp(menu_id, "display_end", #search)
    end
    set_button_text(menu_id, filter_items(api_gp(menu_id, "search")))
end

function move_cursor(menu_id, change)
    local ci = api_gp(menu_id, "cursor_index") + change
    local cr = api_gp(menu_id, "cursor_relative") + change
    local search = api_gp(menu_id, "search")
    local ds = api_gp(menu_id, "display_start")
    local de = api_gp(menu_id, "display_end")
    -- step 1 : check if it can be moved there
    if 0 <= ci and ci <= #search then
        api_sp(menu_id, "cursor_index", ci)
        if ci > de then
            scroll_textbox_right(menu_id, change)
        elseif ci < ds then
            scroll_textbox_left(menu_id, -change)
        end
        if (change > 0 and cr <= de - ds + 1) or (change < 0 and cr >= 0) then
            api_sp(menu_id, "cursor_relative", cr)
        end
    end
end

function scroll_textbox_right(menu_id, amount)
    local search = api_gp(menu_id, "search")
    local ds = api_gp(menu_id, "display_start")
    local de = api_gp(menu_id, "display_end")
    local new_de = de + amount
    api_sp(menu_id, "display_end", new_de)
    if get_string_px(string.sub(search, ds, new_de)) > TEXTBOX_SIZE then
        api_sp(menu_id, "display_start", ds + amount)
    end
end

function scroll_textbox_left(menu_id, amount)
    local search = api_gp(menu_id, "search")
    local ds = api_gp(menu_id, "display_start")
    local de = api_gp(menu_id, "display_end")
    local new_ds = ds - amount
    api_sp(menu_id, "display_start", new_ds)
    if get_string_px(string.sub(search, new_ds, de)) > TEXTBOX_SIZE then
        api_sp(menu_id, "display_end", de - amount)
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
    local item = api_gp(button_id, "text")
    if item ~= "" then
        set_item(menu_id, item)
    end
end

function set_item(menu_id, item)
    if item ~= nil then
        api_sp(menu_id, "selected_item", item)
        api_sp(menu_id, "text_scroll", 0)
        local recipe = RECIPE_REGISTRY[item]
        for i=1,3 do
            if recipe ~= nil and i <= #recipe["recipe"] then
                api_sp(api_gp(menu_id, "recipe_item" .. i), "text", recipe["recipe"][i]["item"])
            else
                api_sp(api_gp(menu_id, "recipe_item" .. i), "text", "")
            end
        end
        --api_sp(api_gp(menu_id, "crafting_bench"), "text", recipe["workstations"])
        if recipe ~= nil then
            api_sp(menu_id, "si_workstations", recipe["workstations"])
        end
    end
end

function draw_hovered_item_tooltip(menu_id)
	local hl_menu = api_get_highlighted("menu")
	if hl_menu == menu_id then
		local hl_button = api_get_highlighted("ui")
		if hl_button ~= nil then
			local item = api_gp(hl_button, "text")
            if item == "rotating_workstation" then
                if api_gp(hl_button, "index") == 1 then
					local workstations = api_gp(menu_id, "si_workstations")
                    if workstations ~= nil then
                        draw_tooltip(workstations[TIMER % #workstations + 1], menu_id)
                    end
                end
            elseif item ~= "" then
                if api_gp(hl_button, "index") == 1 and item ~= nil then
                    draw_tooltip(item, menu_id)
                end
            end
		end
	end
end

function items_down(menu_id)
    scroll_items(menu_id, 1)
end

function items_up (menu_id)
    scroll_items(menu_id, -1)
end

function scroll_items(menu_id, change)
    local new_scroll = api_gp(menu_id, "bei_scroll") + change
    
    local sr = api_gp(menu_id, "search_results")
    if (new_scroll + 8) * 6 <= #sr and (new_scroll >= 0) then
        api_sp(menu_id, "bei_scroll", new_scroll)
        set_button_text(menu_id, sr)
    end
end

function wb_item_click(menu_id)
    local workstations = api_gp(menu_id, "si_workstations")
    if workstations ~= nil then
        set_item(menu_id, workstations[TIMER % #workstations + 1])
    end
end

function text_up(menu_id)
    local text_scroll = api_gp(menu_id, "text_scroll")
    if text_scroll >= 1 then
        api_sp(menu_id, "text_scroll", text_scroll - 1)
    end
end

function text_down(menu_id)
    local text_scroll = api_gp(menu_id, "text_scroll")
    api_sp(menu_id, "text_scroll", text_scroll + 1)
end

function bei_do_nothing(menu_id)
	-- hello !
	-- if you've made it this far, good job, and i apologize for my code
	-- good luck !
	-- this function does nothing
end
