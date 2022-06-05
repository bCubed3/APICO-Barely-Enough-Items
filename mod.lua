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
    define_compat_workbench()
    return "Success"
end