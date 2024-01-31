if not crafting_bench.has.mcl_core then
	return
end

minetest.override_item("crafting_bench:workbench", {
	_mcl_hardness = 3,
	_mcl_blast_resistance = 3,
})
