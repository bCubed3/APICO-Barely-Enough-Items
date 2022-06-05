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
    -- also remember to define recipes AFTER DEFINING EVERYTHING ELSE IN YOUR MOD
    cw_define_recipe({{item = "log", amount = 5}}, "stone", 1, 1, "modCubed")
    cw_define_recipe({{item = "stone", amount = 5}, {item = "waterproof", amount = 7}, {item = "planks2", amount = 10}}, "glue", 2, 1, "modCubed")
    cw_define_recipe({{item = "glue", amount= 2}, {item = "stone", amount = 15}}, "canister1", 1, 1, "foo")
    cw_define_recipe({{item = "log", amount = 1}}, "log", 2, 2, "modCubed")
end