MOD_NAME = "compat_workbench"

function register()
    return {
        name = MOD_NAME,
        hooks = {},
        modules = {"crafting", "sample_recipes"}
    }
end

function init()
    define_sample_recipes()
    api_set_devmode(true)
    define_compat_workbench()
    api_give_item(MOD_NAME .. "_compat_workbench", 1)
    return "Success"
end