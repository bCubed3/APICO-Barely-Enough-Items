MOD_REGISTRY = {}
ITEM_REGISTRY = {}
ITEM_LIST = {}
RECIPE_REGISTRY = {}

function register_mod(mod)
    table.insert(MOD_REGISTRY, mod)
end

function register_item(oid)
    if ITEM_REGISTRY[oid] == nil then
        local idef = api_get_definition(oid)
        ITEM_REGISTRY[oid] = {sprite = api_get_sprite("sp_" .. oid), name = idef["name"], mod = "placeholder"}
    end
end

function filter_items(filter_raw)
    --get_filters(filter_raw)
    return filter_items_name(filter_raw)
end

function get_filters(filter_raw)
    api_log("filters", "getting_filters ")
    local filters = {}
    
    api_log("oidfilter", oid_filter)
    if oid_filter ~= nil and oid_filter ~= "" then
        table.insert(filters, oid_filter)
    end
end

function get_filter(filter_raw, filter_pattern)
    local s, e = string.find(filter_raw, filter_pattern)
    if s ~= nil then
        local oid_filter = string.sub(filter_raw, s, e)
    end
end

function filter_items_name(filter)
    local out = {}
    for k,v in pairs(ITEM_REGISTRY) do
        if string.find(string.lower(v["name"]), filter) ~= nil then
            table.insert(out, k)
        end
    end
    return out
end

function string_in(str1, str2)
    return str1 == string.sub(str2, 1, #str1)
end


---
---@param out string oid of the output item
---@param _recipe table recipe for the output item
---@param _amt number amount the recipe produces
---@param _mod string mod name that adds the item / recipe
---@param _workstation string oid of the mod that the recipe is in
function register_recipe(out, _recipe, _amt, _mod, _workstation)
    RECIPE_REGISTRY[out] = {mod = _mod, recipe = _recipe, amount = _amt, workstation = _workstation}
    register_item(out)
end