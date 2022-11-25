-- utils.lua

KEYCODES = {}
LETTER_LENGTHS = {}
LETTERS = " 0123456789abcedfghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ;'@#.,!/\\-+_=?[]"
TOOLTIP_EDGE_SPR = -1
TOOLTIP_CENTER_SPR = -1
TOOLTIP_ITEM_BG_SPR = -1
TOOLTIP_EDGE_OFFSET = 3
X_OFFSET = 60
Y_OFFSET = 60

function prep_tooltip()
    TOOLTIP_EDGE_SPR = api_define_sprite("cw_tooltip_edge", "sprites/cw_tooltip_edge.png", 1)
	TOOLTIP_CENTER_SPR = api_define_sprite("cw_tooltip_center", "sprites/cw_tooltip_center.png", 1)
	TOOLTIP_ITEM_BG_SPR = api_define_sprite("tooltip_item_bg", "sprites/tooltip_item_bg.png", 1)
end

function make_keycodes()
    KEYCODES[8] = "BACKSPACE"
    KEYCODES[13] = "ENTER"
    KEYCODES[32] = " "
    KEYCODES[37] = "LEFT"
    KEYCODES[39] = "RIGHT"
    for i=48,57 do
        KEYCODES[i] = string.char(i)
    end
    for i=65,90 do
        KEYCODES[i] = string.char(i + 32)
    end
    KEYCODES[186] = ";"
    KEYCODES[188] = ","
    KEYCODES[189] = "-"
    KEYCODES[187] = "="
    KEYCODES[219] = "["
    KEYCODES[221] = "]"
    KEYCODES[222] = "'"
    KEYCODES[250] = "@"
    KEYCODES[251] = "#"
    for i=265,290 do
        KEYCODES[i] = string.char(i - 200)
    end
    KEYCODES[389] = "_"
    KEYCODES[387] = "+"
end

function make_letter_lengths()
    for i=1,#LETTERS do
        local letter = string.sub(LETTERS, i, i)
        if letter == "'" or letter == "!" or letter == "." then
            LETTER_LENGTHS[letter] = 1
        elseif letter == " " or letter == ";" or letter == "," then
            LETTER_LENGTHS[letter] = 2
        elseif letter == "i" or letter == "l" or letter == "1" or letter == "$" or letter == "-"
        or letter == "+" or letter == "[" or letter == "]" then
            LETTER_LENGTHS[letter] = 3
        elseif letter == "j" or letter == "k" then
            LETTER_LENGTHS[letter] = 4
        elseif letter == "@" then
            LETTER_LENGTHS[letter] = 9
        else
            LETTER_LENGTHS[letter] = 5
        end
    end
end

function get_string_px(str)
    local out = 0
    local letter = ""
    local line_length = 0
    for i=1,#str do
        letter = string.sub(str, i, i)
        if LETTER_LENGTHS[letter] ~= nil then
            out = out + LETTER_LENGTHS[letter] + 1
        else
            out = out + 6
        end
    end
    if out > 0 then
        out = out - 1
    end
    return out
end

function get_string_height(str, width)
    local out = 0
    local line_length = 0
    local word_length = 0
    for word in string.gmatch(str, "%S+") do
        word_length = get_string_px(word) + 3
        if line_length + word_length < width - 3 then
            line_length = line_length + word_length
        else
            line_length = word_length
            out = out + 1
        end        
    end
    --api_log("out", out)
    --api_log("line_length", line_length)
    return out + 1
end

function get_text_height(text_lines, width)
    local spacer = 0
    local spacing = 13
    for i=1,#text_lines do
        if text_lines[i]["text"] ~= nil then
            spacer = spacer + get_string_height(text_lines[i]["text"], width)
        end
    end
    return spacer * spacing
end

function get_lines_height(text_lines, width)
    local spacer = 0
    for i=1,#text_lines do
        if text_lines[i]["text"] ~= nil then
            spacer = spacer + get_string_height(text_lines[i]["text"], width)
        elseif text_lines[i]["spr"] ~= nil then
            spacer = spacer + 1
        end
    end
    return spacer
end

function draw_text_lines(text_lines, x, y, width, starting_line, num_lines)
    starting_line = starting_line or 0
    local spacing = 13
    local spacer = 0
    for i=1,#text_lines do
        -- if line is text
        if text_lines[i]["text"] ~= nil then
            local str = text_lines[i]["text"]
            local col = text_lines[i]["color"]
            local out = 0
            local line_length = 0
            local word_length = 0
            local line_out = ""
            for word in string.gmatch(str, "%S+") do
                word_length = get_string_px(word) + 3
                if line_length + word_length < width - 3 then
                    line_length = line_length + word_length
                    line_out = line_out .. word .. " "
                else
                    if starting_line <= spacer and spacer <= num_lines + starting_line then
                        api_draw_text(x, y + spacing * (spacer - starting_line), line_out, false, col)
                    end
                    spacer = spacer + 1
                    line_out = word .. " "
                    line_length = word_length
                    out = out + 1
                end
            end
            if starting_line <= spacer and spacer <= num_lines + starting_line then
                api_draw_text(x, y + spacing * (spacer - starting_line), line_out, false, col)
            end
            spacer = spacer + 1
        elseif text_lines[i]["spr"] ~= nil then
            if starting_line <= spacer and spacer <= num_lines + starting_line then
                --api_draw_sprite(get_reg_sprite("log"), 1, x, y + spacing * (spacer - starting_line) - 2)
                draw_sprite_list(text_lines[i]["spr"], x, y + spacing * (spacer - starting_line) - 4, false)
            end
            spacer = spacer + 1
        end
    end
    return spacer * spacing
end

function get_reg_sprite(oid)
    if FAKE_ITEM_REGISTRY[oid] ~= nil then
        return FAKE_ITEM_REGISTRY[oid]["sprite"]
    elseif ITEM_REGISTRY[oid] ~= nil and ITEM_REGISTRY[oid]["sprite"] ~= nil then
        return ITEM_REGISTRY[oid]["sprite"]
    else
        return CUBE_SPR
    end
end

function draw_sprite_list(oids, x, y, bg)
    if bg == nil then
        bg = true
    end
    local spacing = 3
    for i=1,#oids do
        if bg then
            api_draw_sprite(TOOLTIP_ITEM_BG_SPR, 0, x + (18 + spacing) * (i - 1), y)
        end
        api_draw_sprite(get_reg_sprite(oids[i]), 0, x + (18 + spacing) * (i - 1) + 1, y + 1)
    end
end

function draw_tooltip(oid, menu_id)
	local idef = api_get_definition(oid)
    if idef ~= nil then
        local name = idef["name"] or oid
        local durability = idef["durability"]
        local sell_price = idef["cost"]
        local machines = idef["machines"]
        if #machines ~= 0 then
            for m=1, #machines do
                machines[m] = machines[m]
            end
        end
        --api_log("bei", machines)
        if type(sell_price) == "table" then
            sell_price = sell_price["sell"]
        else
            sell_price = 0
        end
        local holding_shift = api_get_key_down("SHFT")
        local tooltip = "Hold shift for info"
        local tooltip_size = {x = 117, y = 28}
        if holding_shift == 1 then
            tooltip = idef["tooltip"]
            tooltip_size["x"] = 171
        end
        local size = api_get_game_size()
        local text_to_draw = {
            {text = name, color = "FONT_WHITE"},
            {text = MOD_REGISTRY[ITEM_REGISTRY[oid]["mod"]], color = "FONT_ORANGE"},
            {text = idef["category"], color = "FONT_BLUE"},
            {text = tooltip, color = "FONT_BGREY"}
        }
        if durability ~= nil then
            durability = math.floor(durability)
            table.insert(text_to_draw, {text = "Durability: " .. durability .. "/" .. durability, color = "FONT_YELLOW"})
        end
        if sell_price ~= 0 then
            if idef["honeycore"] == 1 then
                table.insert(text_to_draw, {text = "Sells for $" .. sell_price, color = "FONT_ORANGE"})
            else
                table.insert(text_to_draw, {text = "Sells for £" .. sell_price, color = "FONT_YELLOW"})
            end
        end
        if #machines ~= 0 and holding_shift == 1 then
            table.insert(text_to_draw, {text = "Use with:", color = "FONT_GREY"})
        end
        tooltip_size["y"] = get_text_height(text_to_draw, tooltip_size["x"] - 3) + 2
        --api_log("machines", machines)
        if #machines ~= 0 then
            tooltip_size["y"] = tooltip_size["y"] + 21
        end
        local left = size["width"] - tooltip_size["x"] - TOOLTIP_EDGE_OFFSET
        local top = size["height"] - tooltip_size["y"] - TOOLTIP_EDGE_OFFSET
        api_draw_sprite_ext(TOOLTIP_EDGE_SPR, 0, left, top - 1, tooltip_size["x"], 1, 0, 1, 1)
        api_draw_sprite_ext(TOOLTIP_EDGE_SPR, 0, left, top + tooltip_size["y"], tooltip_size["x"], 1, 0, 1, 1)
        api_draw_sprite_ext(TOOLTIP_EDGE_SPR, 0, left - 1, top, 1, tooltip_size["y"], 0, 1, 1)
        api_draw_sprite_ext(TOOLTIP_EDGE_SPR, 0, left + tooltip_size["x"], top, 1, tooltip_size["y"], 0, 1, 1)
        api_draw_sprite_ext(TOOLTIP_CENTER_SPR, 0, left, top, tooltip_size["x"], tooltip_size["y"], 0, 0, 0.9)
        draw_text_lines(text_to_draw, left + 3, top + 2, tooltip_size["x"] - 3, 0, 12)
        if #machines ~= 0 then
            draw_sprite_list(machines, left + 3, top + tooltip_size["y"] - 21)
        end
    elseif ITEM_REGISTRY[oid]["itype"] == "bee" then
        draw_bee_tooltip(oid, menu_id)
    end
end

function draw_bee_tooltip(oid, menu_id)
    local idef = ITEM_REGISTRY[oid]
    if idef ~= nil then
        local name = idef["name"]
        local holding_shift = api_get_key_down("SHFT")
        local tooltip = "Hold shift to view traits"
        local tooltip_size = {x = 117, y = 28}
        local machines = {"beehive1", "hive1"}
        if holding_shift == 1 then
            tooltip = "Release shift to hide traits"
        end
        local size = api_get_game_size()
        local text_to_draw = {
            {text = name, color = "FONT_WHITE"},
            {text = MOD_REGISTRY[ITEM_REGISTRY[oid]["mod"]], color = "FONT_ORANGE"},
            {text = "Bee", color = "FONT_BLUE"}
            --{text = tooltip, color = "FONT_BGREY"}
        }
        tooltip_size["y"] = get_text_height(text_to_draw, tooltip_size["x"] - 3) + 2
        --api_log("machines", machines)
        if #machines ~= 0 then
            tooltip_size["y"] = tooltip_size["y"] + 21
        end
        local left = size["width"] - tooltip_size["x"] - TOOLTIP_EDGE_OFFSET
        local top = size["height"] - tooltip_size["y"] - TOOLTIP_EDGE_OFFSET
        api_draw_sprite_ext(TOOLTIP_EDGE_SPR, 0, left, top - 1, tooltip_size["x"], 1, 0, 1, 1)
        api_draw_sprite_ext(TOOLTIP_EDGE_SPR, 0, left, top + tooltip_size["y"], tooltip_size["x"], 1, 0, 1, 1)
        api_draw_sprite_ext(TOOLTIP_EDGE_SPR, 0, left - 1, top, 1, tooltip_size["y"], 0, 1, 1)
        api_draw_sprite_ext(TOOLTIP_EDGE_SPR, 0, left + tooltip_size["x"], top, 1, tooltip_size["y"], 0, 1, 1)
        api_draw_sprite_ext(TOOLTIP_CENTER_SPR, 0, left, top, tooltip_size["x"], tooltip_size["y"], 0, 0, 0.9)
        draw_text_lines(text_to_draw, left + 3, top + 2, tooltip_size["x"] - 3, 0, 12)
        if #machines ~= 0 then
            draw_sprite_list(machines, left + 3, top + tooltip_size["y"] - 21)
        end
    end
end

function trim(s)
    if type(s) == "string" then
        --api_log("bei", s .. ", " .. #s)
        return string.gsub(s, "^%s*(.-)%s*$", "%1")
    end
    return s
end
