MOD_NAME = "compat_workbench"

function register()
    return {
        name = MOD_NAME,
        hooks = {},
        modules = {"crafting", "sample_recipes"}
    }
end

function init()
    define_compat_workbench()
    define_sample_recipes()
    api_set_devmode(true)
    
    return "Success"
end