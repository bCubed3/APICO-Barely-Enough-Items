KEYCODES = {}
LETTER_LENGTHS = {}
LETTERS = " 0123456789abcedfghijklmnopqrstuvwxyz;'@#"

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
    KEYCODES[222] = "'"
    KEYCODES[250] = "@"
    KEYCODES[251] = "#"
    for i=265,290 do
        KEYCODES[i] = string.char(i - 200)
    end
end

function make_letter_lengths()
    for i=1,#LETTERS do
        local letter = string.sub(LETTERS, i, i)
        if letter == "'" then
            LETTER_LENGTHS[letter] = 1
        elseif letter == " " or letter == ";" then
            LETTER_LENGTHS[letter] = 2
        elseif letter == "i" or letter == "l" or letter == "1" or letter == "$" then
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
    for i=1,#str do
        letter = string.sub(str, i, i)
        out = out + LETTER_LENGTHS[letter] + 1
    end
    if out > 0 then
        out = out - 1
    end
    return out
end

function draw_tooltip(oid, menu_id)
	local letter_size = 5.5
	local idef = api_get_definition(oid)
	local name = idef["name"]
	local holding_shift = api_get_key_down("SHFT")
	local tooltip = "Hold shift for info."
	local tooltip_size = {x = 117, y = 28}
	if holding_shift == 1 then
		tooltip = idef["tooltip"]
		tooltip_size["x"] = 171
	end
	local spacing = 13
	local space_nums = {0, 0}
	local size = api_get_game_size()
	
	if #name * letter_size + 1 > tooltip_size["x"] then
		space_nums[1] = ((#name * letter_size + 1) // tooltip_size["x"])
		tooltip_size["y"] = tooltip_size["y"] + spacing * space_nums[1]
	end
	if holding_shift == 1 then
		space_nums[1] = space_nums[1] + 2
		tooltip_size["y"] = tooltip_size["y"] + spacing * 2
		if #tooltip * letter_size + 1 > tooltip_size["x"] then
			space_nums[2] = ((#tooltip * letter_size + 1) // tooltip_size["x"])
			tooltip_size["y"] = tooltip_size["y"] + spacing * space_nums[2]
		end
		api_log("size", (#tooltip * letter_size + 1) / 171)
	end
	local left = size["width"] - tooltip_size["x"] - TOOLTIP_EDGE_OFFSET
	local top = size["height"] - tooltip_size["y"] - TOOLTIP_EDGE_OFFSET
	api_draw_sprite_ext(TOOLTIP_EDGE_SPR, 0, left, top - 1, tooltip_size["x"], 1, 0, 1, 1)
	api_draw_sprite_ext(TOOLTIP_EDGE_SPR, 0, left, top + tooltip_size["y"], tooltip_size["x"], 1, 0, 1, 1)
	api_draw_sprite_ext(TOOLTIP_EDGE_SPR, 0, left - 1, top, 1, tooltip_size["y"], 0, 1, 1)
	api_draw_sprite_ext(TOOLTIP_EDGE_SPR, 0, left + tooltip_size["x"], top, 1, tooltip_size["y"], 0, 1, 1)
	api_draw_sprite_ext(TOOLTIP_CENTER_SPR, 0, left, top, tooltip_size["x"], tooltip_size["y"], 0, 0, 0.9)
	local camera_pos = api_get_camera_position()
	local player_pos = api_get_player_position()
	local px = player_pos["x"] - camera_pos["x"]
	local py = player_pos["y"] - camera_pos["y"]
	api_draw_text(left + 3, top + 2, name, false, "FONT_WHITE", tooltip_size["x"])
	if holding_shift == 1 then
		api_draw_sprite(MOD_TOOLTIP_SPR, 0, left + 3, top + 3 + spacing)
		api_draw_text(left + 3 + 11, top + 2 + spacing, ITEM_REGISTRY[oid]["mod"], false, "FONT_ORANGE", tooltip_size["x"])
		api_draw_text(left + 3, top + 2 + spacing * 2, idef["category"], false, "FONT_BLUE", tooltip_size["x"])
	end
	api_draw_text(left + 3, top + 2 + 13 + spacing * space_nums[1], tooltip, false, "FONT_BGREY", tooltip_size["x"])
end