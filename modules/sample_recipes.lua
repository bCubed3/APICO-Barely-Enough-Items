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
    -- tab 1 recipes
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
    -- tab 2 recipes
    cw_define_recipe({{item = "sticks1", amount = 5}, {item = "planks1", amount = 5}}, "treetap1", 1, 2, "Vanilla")
    cw_define_recipe({{item = "sticks1", amount = 10}, {item = "planks1", amount = 5}}, "axe1", 1, 2, "Vanilla")
    cw_define_recipe({{item = "sticks1", amount = 10}, {item = "planks1", amount = 5}}, "pickaxe1", 1, 2, "Vanilla")
    cw_define_recipe({{item = "sticks1", amount = 10}, {item = "planks1", amount = 5}}, "spade1", 1, 2, "Vanilla")
    cw_define_recipe({{item = "sticks1", amount = 10}, {item = "planks1", amount = 10}}, "hammer1", 1, 2, "Vanilla")
    cw_define_recipe({{item = "sticks1", amount = 10}, {item = "stone", amount = 20}}, "axe2", 1, 2, "Vanilla")
    cw_define_recipe({{item = "sticks1", amount = 10}, {item = "stone", amount = 20}}, "pickaxe2", 1, 2, "Vanilla")
    cw_define_recipe({{item = "sticks1", amount = 10}, {item = "stone", amount = 30}}, "hammer2", 1, 2, "Vanilla")
    cw_define_recipe({{item = "sticks1", amount = 10}, {item = "stone", amount = 20}}, "spade2", 1, 2, "Vanilla")
    cw_define_recipe({{item = "planks1", amount = 2}, {item = "waterproof", amount = 5}}, "canister1", 1, 2, "Vanilla")
    -- tab 3 recipes
    cw_define_recipe({{item = "honeycomb", amount = 10}}, "beehive1", 1, 3, "Vanilla")
    cw_define_recipe({{item = "hive1", amount = 1}, {item = "crate2", amount = 1}, {item = "honeycomb", amount = 1}}, "beebox", 1, 3, "Vanilla")
    cw_define_recipe({{item = "honeycomb", amount = 10}, {item = "planks1", amount = 10}, {item = "log", amount = 10}}, "hive1", 1, 3, "Vanilla")
    cw_define_recipe({{item = "honeycomb", amount = 10}, {item = "planks2", amount = 10}, {item = "log", amount = 10}}, "hive2", 1, 3, "Vanilla")
    cw_define_recipe({{item = "honeycomb", amount = 15}, {item = "planks2", amount = 15}, {item = "log", amount = 5}}, "hive3", 1, 3, "Vanilla")
    cw_define_recipe({{item = "honeycomb", amount = 5}, {item = "planks1", amount = 5}, {item = "log", amount = 5}}, "rehab", 1, 3, "Vanilla")
    cw_define_recipe({{item = "planks1", amount = 4}, {item = "log", amount = 5}}, "predictor", 1, 3, "Vanilla")
    cw_define_recipe({{item = "honeycomb", amount = 5}, {item = "planks1", amount = 2}}, "frame1", 1, 3, "Vanilla")
    cw_define_recipe({{item = "honeycomb", amount = 5}, {item = "glue", amount = 2}, {item = "planks2", amount = 2}}, "frame2", 1, 3, "Vanilla")
    cw_define_recipe({{item = "honeycomb", amount = 5}, {item = "royaljelly", amount = 2}}, "queencells", 1, 3, "Vanilla")
    cw_define_recipe({{item = "frame1", amount = 2}, {item = "planks1", amount = 10}, {item = "log", amount = 10}}, "uncappingbench", 1, 3, "Vanilla")
    cw_define_recipe({{item = "glue", amount = 10}, {item = "planks1", amount = 15}, {item = "stone", amount = 20}}, "extractor", 1, 3, "Vanilla")
    cw_define_recipe({{item = "planks2", amount = 15}, {item = "cog", amount = 5}, {item = "uncappingbench", amount = 1}}, "uncapper", 1, 3, "Vanilla")
    cw_define_recipe({{item = "planks2", amount = 10}, {item = "cog", amount = 10}, {item = "extractor", amount = 1}}, "centrifuge", 1, 3, "Vanilla")
    cw_define_recipe({{item = "sawdust1", amount = 2}, {item = "glue", amount = 1}}, "sawdust2", 2, 3, "Vanilla")
end