-- sample_recipes.lua

TABS = {
    crafting = 1,
    tools = 2,
    beekeeping = 3,
    decoration = 4,
    painting = 5
}

-- function that defines example recipes
function get_described_recipes()
    cw_define_mod("vanilla", "Vanilla", 5)
    local mods = api_describe_mods()
    for i=1,#mods do
        if MOD_REGISTRY[i] == nil then
            cw_define_mod(mods[i], mods[i], 5)
        end
    end

    local vanilla_recipes = api_describe_recipes(false)
    cw_define_recipes("vanilla", vanilla_recipes)
    local modded_recipes = api_describe_recipes(true)
    for mod,recipes in pairs(modded_recipes) do
        cw_define_recipes(mod, recipes)
    end
end

function cw_define_recipes(mod, mod_recipes)
    for tab,recipes in pairs(mod_recipes) do
        for i=1,#recipes do
            if type(mod_recipes[tab][i]) == "table" then
                local total = mod_recipes[tab][i]["total"] or 1
                local recipe = mod_recipes[tab][i]["recipe"]
                local item = mod_recipes[tab][i]["item"]
                cw_define_recipe(recipe, item, total, TABS[tab], mod)
            end
        end
    end
end
