--MOD.LUA
MOD_NAME = "bei"
TIMER = 0

function register()
    return {
        name = MOD_NAME,
        hooks = {"ready", "key", "clock", "click"},
        modules = {"sample_recipes", "item_book", "utils", "registry"}
    }
end

function init()
    prep_tooltip()
    make_keycodes()
    define_recipe_book()
    make_letter_lengths()
    register_mod("bei", "BEI")
    get_described_recipes()
    --api_blacklist_input(MOD_NAME .. "_recipe_book")
    api_log("bei", "init success")
    return "Success"
end

function ready()
    CUBE_SPR = api_get_sprite("sp_axe_item")
    api_log("bei", api_get_sprite("sp_axe_item"))
    api_blacklist_input(MOD_NAME .. "_recipe_book")
    --sort_registry()
    --api_log("registry", ITEM_REGISTRY)
    register_bees()
    register_butterflies()
    register_items()
    register_npcs()
    create_recipe_book()
    --api_give_item(MOD_NAME .. "_recipe_book", 1)
end

function key(keycode)
    if keycode ~= 16 then
        local hl = api_get_highlighted("menu")
        local hl_inst = api_get_inst(hl) or {}
        if api_gp(hl, "textbox_focused") then
            if hl ~= nil and hl_inst["oid"] == MOD_NAME .. "_recipe_book" then
                type_char(hl, keycode)
            end
        end
    end
end

function click(button, click_type)
    local highlighted = api_get_highlighted("menu")
    if highlighted ~= nil then
        local menu = api_get_inst(highlighted)
        if menu ~= nil and menu["oid"] == MOD_NAME .. "_recipe_book" and click_type == "PRESSED" then
            local mx = math.floor(menu["x"])
            local my = math.floor(menu["y"])
            local mouse_pos = api_get_mouse_position()
            if mx + SEARCH_BOX_POS["x"] < mouse_pos["x"] and mouse_pos["x"] < mx + SEARCH_BOX_POS["x"] + SEARCH_BOX_SIZE["x"] and my + SEARCH_BOX_POS["y"] < mouse_pos["y"] and mouse_pos["y"] < my + SEARCH_BOX_POS["y"] + SEARCH_BOX_SIZE["y"] then
                api_sp(menu["id"], "textbox_focused", true)
                if button == "RIGHT" then
                    api_sp(menu["id"], "search", "")
                    type_char(menu["id"], 8)
                end
            else
                api_sp(menu["id"], "textbox_focused", false)
            end
        end
    end
end

function clock()
    TIMER = TIMER + 1
end