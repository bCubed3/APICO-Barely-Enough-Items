-- sample_recipes.lua

TABS = {
    crafting = 1,
    tools = 2,
    beekeeping = 3,
    decoration = 4,
    painting = 5
}

--function register_rotating_stock()

--end

-- function that defines example recipes
function get_described_recipes()
    register_mod("vanilla", "Vanilla")
    local mods = api_describe_mods()
    for i=1,#mods do
        if MOD_REGISTRY[i] == nil then
            register_mod(mods[i], mods[i])
        end
    end

    local vanilla_recipes = api_describe_recipes(false)
    register_recipes("vanilla", vanilla_recipes, {"workbench"})
    local modded_recipes = api_describe_recipes(true)
    for mod,recipes in pairs(modded_recipes) do
        register_recipes(mod, recipes, {"workbench2"})
    end
end

function register_recipes(mod, mod_recipes, wb)
    for tab,recipes in pairs(mod_recipes) do
        for i=1,#recipes do
            if type(mod_recipes[tab][i]) == "table" then
                local total = mod_recipes[tab][i]["total"] or 1
                local recipe = mod_recipes[tab][i]["recipe"]
                local item = mod_recipes[tab][i]["item"]
                register_recipe(item, recipe, total, mod, wb)
            end
        end
    end
end
