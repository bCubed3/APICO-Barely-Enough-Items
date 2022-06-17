# Barely Enough Items
 A list of all items in the game, along with descriptions and recipes.
 
 Currently only shows vanilla and modded crafting recipes. Modders can add their own custom machine recipes with the following syntax :
 ```lua
 -- How to register your mod :
 ---@param mod_id string the mod id of your mod
 ---@param mod_name string the name of your mod to be displayed
 register_mod("bei", "Barely Enough Items")
 
 -- How to register your custom recipe :
 ---@param out string the oid of the output item
 ---@param _recipe table the recipe table
 ---@param _amt number the amount produced of the output item
 ---@param _mod string the mod_id of the mod adding the recipe
 ---@param _workstations table the list of machines this recipe work in
 register_recipe("planks1", {{item = "log", amount = 1}}, 2, "vanilla", {"sawbench", "sawmill", "sawmill2"}) 
 ```
 Do note that this only tells BEI to show the recipe. It does not actually create the recipe in the machine. Additionally, any recipes defined via `api_define_recipe()` are automatically added.

 
