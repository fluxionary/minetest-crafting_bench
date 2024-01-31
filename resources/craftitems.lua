crafting_bench.resources.craftitems = {}

if crafting_bench.has.default then
	crafting_bench.resources.craftitems.steel = "default:steel_ingot"
	crafting_bench.resources.craftitems.tree = "group:tree"
	crafting_bench.resources.craftitems.wood = "group:wood"
end

if crafting_bench.has.mcl_core then
	crafting_bench.resources.craftitems.steel = "mcl_core:iron_ingot"
	crafting_bench.resources.craftitems.tree = "mcl_core:tree"
	crafting_bench.resources.craftitems.wood = "mcl_core:wood"
end
