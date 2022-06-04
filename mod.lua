MOD_NAME = "compat_workbench"

function register()
    return {
        name = MOD_NAME,
        hooks = {},
        modules = {"crafting"}
    }
end

function init()
    define_compat_workbench()
    return "Success"
end