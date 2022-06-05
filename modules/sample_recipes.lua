-- function that defines example recipes
function define_sample_recipes()
    -- cw_define_mod(mod_name : string)
    cw_define_mod("modCubed")
    cw_define_mod("foo")
    -- cw_define_tab(mod_name : string, num_tabs : int)
    -- if you want three tabs, call this function 3 times
    cw_define_tabs("modCubed", 2)
    cw_define_tabs("foo", 5)
    -- cw_define_recipe({{item1 : string, amt1 : int}, {item2 : string, amt2 : int}, {item3 : string, amt3 : int} or nil}, output_item : string, output_amt : int)
    -- remember to prepend your mod_name if you are using modded items
    -- please define recipes AFTER DEFINING EVERYTHING ELSE
    cw_define_recipe({{"log", 5}}, "stone", 1, 1, "modCubed")
    cw_define_recipe({{"stone", 5}, {"waterproof", 7}, {"planks2", 10}}, "glue", 2, 1, "modCubed")
    cw_define_recipe({{"glue", 2}, {"stone", 15}}, "canister1", 1, 1, "foo")
    cw_define_recipe({{"log", 1}}, "log", 2, 2, "modCubed")
end