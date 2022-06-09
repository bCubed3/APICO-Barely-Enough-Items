# Barely Enough Items
 A list of all* items in the game, along with descriptions and recipes.
 
 *Not all items are implemented yet.

# Compatibility workbench
 A workbench that lets different mods define their own recipes.
 
Usage :
 - define your mod and the number of tabs you want (up to 5)
 - define your recipes (up to 20 per tab)
Please remember to define recipes AFTER DEFINING EVERYTHING ELSE IN YOUR MOD.
Example code :
```lua
-- function that defines example recipes
function define_sample_recipes()
    -- define your mod with cw_define_mod(mod_name : string, tabs_num : int)
    cw_define_mod("modCubed", 2)
    cw_define_mod("foo", 5)
    -- define recipes with :
    -- cw_define_recipe({{item = "item1", amount = amt1}, {item = "item2", amount = amt2}, {item = "item3", amount = amt3}},
    --                  output_item : string,
    --                  output_amt : int,
    --                  tab : int,
    --                  mod : string)
    -- remember to prepend your mod_name if you are using modded items
    cw_define_recipe({{item = "log", amount = 5}}, "stone", 1, 1, "modCubed")
    cw_define_recipe({{item = "stone", amount = 5}, {item = "waterproof", amount = 7}, {item = "planks2", amount = 10}}, "glue", 2, 1, "modCubed")
    cw_define_recipe({{item = "glue", amount= 2}, {item = "stone", amount = 15}}, "canister1", 1, 1, "foo")
    cw_define_recipe({{item = "log", amount = 1}}, "log", 2, 2, "modCubed")
end
```
