--MOD.LUA
MOD_NAME = "bei"
TIMER = 0

function register()
    return {
        name = MOD_NAME,
        hooks = {"ready", "key", "clock"},
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
    register_items()
    register_npcs()
    create_recipe_book()
end

function key(keycode)
    if keycode ~= 16 then
        local hl = api_get_highlighted("menu")
        local hl_inst = api_get_inst(hl) or {}
        if hl ~= nil and hl_inst["oid"] == MOD_NAME .. "_recipe_book" then
            type_char(hl, keycode)
        end
    end
end

function clock()
    TIMER = TIMER + 1
end