MOD_REGISTRY = {}
ITEM_REGISTRY = {}
ITEM_LIST = {}
RECIPE_REGISTRY = {}

function register_mod(mod_id, mod_name)
    MOD_REGISTRY[mod_id] = mod_name
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

function register_item(oid)
    if ITEM_REGISTRY[oid] == nil then
        local idef = api_get_definition(oid)
        ITEM_REGISTRY[oid] = {sprite = api_get_sprite("sp_" .. oid), name = idef["name"], mod = "placeholder"}
        local small_item = api_get_sprite("sp_" .. oid .. "_item")
        api_log("si", small_item)
        if small_item ~= 683 then
            api_log("si", small_item)
            ITEM_REGISTRY[oid]["sprite"] = small_item
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