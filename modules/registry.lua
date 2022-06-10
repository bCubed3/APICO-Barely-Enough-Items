--registry.lua

MOD_REGISTRY = {}
ITEM_REGISTRY = {}
ITEM_LIST = {}
RECIPE_REGISTRY = {}
BLACKLISTED_ITEMS = {
    wall7 = ".",
    debugger1 = ".",
    bee = "."
}
BLACKLISTED_PATTERNS = {
    "npc%d+s",
    "seedling%d+"
}

function register_mod(mod_id, mod_name)
    mod_name =  mod_name or mod_id
    --api_log("mr", MOD_REGISTRY[mod_id])
    if MOD_REGISTRY[mod_id] == nil then
        MOD_REGISTRY[mod_id] = mod_name
    end
end

---
---@param out string oid of the output item
---@param _recipe table recipe for the output item
---@param _amt number amount the recipe produces
---@param _mod string mod name that adds the item / recipe
---@param _workstations table workstations the item is made in
function register_recipe(out, _recipe, _amt, _mod, _workstations)
    if type(_workstations) == "string" then
        _workstations = {_workstations}
    end
    RECIPE_REGISTRY[out] = {mod = _mod, recipe = _recipe, amount = _amt, workstations = _workstations}
    --register_item(out)
end

function register_item(oid, mod, itype)
    if ITEM_REGISTRY[oid] == nil and is_blacklisted(oid) == false then
        local idef = api_get_definition(oid)
        if idef ~= nil then
        ITEM_REGISTRY[oid] = {sprite = api_get_sprite("sp_" .. oid), name = idef["name"], mod = mod, itype = itype}
        local small_item = api_get_sprite("sp_" .. oid .. "_item")
        if small_item ~= 686 then
            ITEM_REGISTRY[oid]["sprite"] = small_item
        end
        if type(idef["machines"]) == "table" then
            for i=1, #idef["machines"] do
                register_item(idef["machines"][i])
            end
        end
        end
    end
end

function register_bee(bee)

end


function register_items()
    local vanilla_items = api_describe_oids(false)
    for i=1,#vanilla_items do
        register_item(vanilla_items[i], "vanilla", "item")
    end
    local modded_items = api_describe_oids(true)
    for k,v in pairs(modded_items) do
        for i=1,#v do
            register_item(v[i], k, "item")
        end
    end
    register_bees()
end

function register_bees()
    local vanilla_bees = api_describe_bees(false)
    api_log("vbees", vanilla_bees["chaotic"])
    for i=1,#vanilla_bees do
        register_item(vanilla_bees[i], "vanilla", "bee")
    end
    local modded_bees = api_describe_bees(true)
    for k,v in pairs(modded_bees) do
        for i=1,#v do
            register_item(v[i], k, "bee")
        end
    end
end

function filter_items(filter_raw)
    local filters, name_filter = get_filters(filter_raw)
    local item_reg = ITEM_REGISTRY
    if filters["oid"] ~= nil then
        item_reg = filter_items_oid(filters["oid"], item_reg)
    end
    if filters["mod"] ~= nil then
        item_reg = filter_items_mod(filters["mod"], item_reg)
    end
    if filters["tooltip"] ~= nil then
        item_reg = filter_items_tooltip(filters["tooltip"], item_reg)
    end
    return filter_items_name(name_filter, item_reg)
end

function get_filters(filter_raw)
    local _oid, filter_out = get_filter(filter_raw, ";[%a%d_]*")
    local _mod, filter_out = get_filter(filter_out, "@[%a%d_]*")
    --local _tooltip, filter_out = get_filter_tl(filter_out, "#'[%a%d_ ]'")
    return {oid = _oid, mod = _mod}, string.match(filter_out, "%S?.*%S?") --string.match(filter_out, "%S.*%S")
end

function get_filter(filter_raw, filter_pattern)
    local s, e = string.find(filter_raw, filter_pattern)
    if s ~= nil then
        local filter = string.sub(filter_raw, s + 1, e)
        return filter, string.gsub(filter_raw, filter_pattern, "")
    end
    return nil, filter_raw
end
function get_filter_tl(filter_raw, filter_pattern)
    local s, e = string.find(filter_raw, filter_pattern)
    if s ~= nil then
        local filter = string.sub(filter_raw, s + 2, e - 1)
        return filter, string.gsub(filter_raw, filter_pattern, "")
    end
    return nil, filter_raw
end

function filter_items_name(filter, item_reg)
    local out = {}
    for k,v in pairs(item_reg) do
        if string.find(string.lower(v["name"]), filter) ~= nil then
            table.insert(out, k)
        end
    end
    return out
end

function filter_items_oid(filter, item_reg)
    local out = {}
    for k,v in pairs(item_reg) do
        if string.find(k, filter) ~= nil then
            out[k] = v
        end
    end
    return out
end

function filter_items_mod(filter, item_reg)
    local out = {}
    for k,v in pairs(item_reg) do
        if string.find(string.lower(v["mod"]), filter) ~= nil then
            out[k] = v
        end
    end
    return out
end

function filter_items_tooltip(filter, item_reg)
    local out = {}
    for k,v in pairs(item_reg) do
        if string.find(string.lower(api_get_definition(k)["tooltip"]), filter) ~= nil then
            out[k] = v
        end
    end
    return out
end

function string_in(str1, str2)
    return str1 == string.sub(str2, 1, #str1)
end

function sort_helper(item1, item2)
    return table.sort({item1["name"], item2["name"]}) == {item1["name"], item2["name"]}
end

function is_blacklisted(oid)
    if BLACKLISTED_ITEMS[oid] ~= nil then
        return true
    end
    for i=1,#BLACKLISTED_PATTERNS do
        if string.match(oid, BLACKLISTED_PATTERNS[i]) ~= nil then
            return true
        end
    end
    return false
end