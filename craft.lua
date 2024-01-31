local ci = crafting_bench.resources.craftitems

if ci.wood and ci.tree and ci.steel then
	minetest.register_craft({
		output = "crafting_bench:workbench",
		recipe = {
			{ ci.steel, ci.steel, ci.steel },
			{ ci.wood, ci.wood, ci.steel },
			{ ci.tree, ci.tree, ci.steel },
		},
	})
end
