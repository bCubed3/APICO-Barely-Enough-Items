-- function that defines example recipes
function define_sample_recipes()
    -- define your mod with cw_define_mod(mod_name : string, tabs_num : int)
    cw_define_mod("Vanilla", 5)
    -- define recipes with :
    -- cw_define_recipe({{item1 : string, amt1 : int}, {item2 : string, amt2 : int}, {item3 : string, amt3 : int} or nil},
    --                  output_item : string,
    --                  output_amt : int,
    --                  tab : int,
    --                  mod : string)
    -- remember to prepend your mod_name if you are using modded items
    -- also remember to define recipes AFTER DEFINING EVERYTHING ELSE IN YOUR MOD
    cw_define_recipe({{item = "log", amount = 10}}, "sawbench", 1, 1, "Vanilla")
    cw_define_recipe({{item = "log", amount = 10}, {item = "planks1", amount = 5}}, "workbench", 1, 1, "Vanilla")
    cw_define_recipe({{item = "log", amount = 10}, {item = "planks1", amount = 5}, {item = "sticks1", amount = 5}}, "crate1", 1, 1, "Vanilla")
    cw_define_recipe({{item = "log", amount = 10}, {item = "planks1", amount = 10}, {item = "sticks1", amount = 10}}, "crate2", 1, 1, "Vanilla")
    cw_define_recipe({{item = "log", amount = 10}, {item = "planks1", amount = 10}, {item = "sticks1", amount = 10}}, "bench", 1, 1, "Vanilla")
    cw_define_recipe({{item = "log", amount = 5}, {item = "planks1", amount = 5}, {item = "sticks1", amount = 10}}, "bin", 1, 1, "Vanilla")
    cw_define_recipe({{item = "log", amount = 5}, {item = "planks1", amount = 5}, {item = "waterproof", amount = 10}}, "raintank", 1, 1, "Vanilla")
    cw_define_recipe({{item = "log", amount = 5}, {item = "planks1", amount = 10}, {item = "waterproof", amount = 10}}, "barrel", 1, 1, "Vanilla")
    cw_define_recipe({{item = "sticks2", amount = 2}, {item = "glue", amount = 1}}, "cog", 1, 1, "Vanilla")
    cw_define_recipe({{item = "lilypad", amount = 1}}, "waterproof", 4, 1, "Vanilla")
    cw_define_recipe({{item = "propolis", amount = 2}}, "glue", 1, 1, "Vanilla")
    cw_define_recipe({{item = "planks1", amount = 2}, {item = "glue", amount = 2}}, "sign", 1, 1, "Vanilla")
    cw_define_recipe({{item = "planks2", amount = 10}, {item = "cog", amount = 5}, {item = "sawbench", amount = 1}}, "sawmill", 1, 1, "Vanilla")
    cw_define_recipe({{item = "barrel", amount = 1}, {item = "planks1", amount = 10}, {item = "waterproof", amount = 5}}, "infuser", 1, 1, "Vanilla")
    cw_define_recipe({{item = "barrel", amount = 1}, {item = "planks2", amount = 10}, {item = "waterproof", amount = 10}}, "fermenter", 1, 1, "Vanilla")
    cw_define_recipe({{item = "bottle", amount = 5}, {item = "planks1", amount = 10}}, "rack", 1, 1, "Vanilla")
    cw_define_recipe({{item = "log", amount = 5}, {item = "planks1", amount = 10}}, "magazine_rack", 1, 1, "Vanilla")
end