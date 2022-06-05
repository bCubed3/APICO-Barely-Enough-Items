# APICO Compatibility Workbench
 A workbench mod that lets different mods define their own recipes.
 
Usage :
 - define your mod and the number of tabs you want (up to 5)
 - define your recipes (up to 20 per tab)
Please remember to define recipes AFTER DEFINING EVERYTHING ELSE IN YOUR MOD.
Example code :
```lua
-- function that defines example recipes
function define_sample_recipes()
    -- define your mod with cw_define_mod(mod_name : string, tabs_num : int)
    cw_define_mod("modCubed")
    cw_define_mod("foo")
    -- define recipes with :
    -- cw_define_recipe({{item1 : string, amt1 : int}, {item2 : string, amt2 : int}, {item3 : string, amt3 : int} or nil},
    --                  output_item : string,
    --                  output_amt : int,
    --                  tab : int,
    --                  mod : string)
    -- remember to prepend your mod_name if you are using modded items
    cw_define_recipe({{"log", 5}}, "stone", 1, 1, "modCubed")
    cw_define_recipe({{"stone", 5}, {"waterproof", 7}, {"planks2", 10}}, "glue", 2, 1, "modCubed")
    cw_define_recipe({{"glue", 2}, {"stone", 15}}, "canister1", 1, 1, "foo")
    cw_define_recipe({{"log", 1}}, "log", 2, 2, "modCubed")
end
```
