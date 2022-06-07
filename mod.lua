MOD_NAME = "compat_workbench"
TIMER = 0

function register()
    return {
        name = MOD_NAME,
        hooks = {"ready", "key", "clock"},
        modules = {"crafting", "sample_recipes", "item_book", "utils", "registry"}
    }
end

function init()
    make_keycodes()
    define_recipe_book()
    make_letter_lengths()
    define_sample_recipes()
    define_compat_workbench()
    
    --api_blacklist_input(MOD_NAME .. "_recipe_book")
    return "Success"
end

function ready()
    api_blacklist_input(MOD_NAME .. "_recipe_book")
    api_log("registry", ITEM_REGISTRY)
end

function key(keycode)
    hl = api_get_highlighted("menu")
    hl_inst = api_get_inst(hl)
    if hl ~= nil and hl_inst["oid"] == MOD_NAME .. "_recipe_book" then
        type_char(hl, keycode)
    end
end

function clock()
    TIMER = TIMER + 1
end