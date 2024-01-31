if not crafting_bench.has.hopper then
	return
end

if hopper.add_container then
	hopper:add_container({
		{ "top", "crafting_bench:workbench", "dst" },
		{ "side", "crafting_bench:workbench", "src" },
		{ "bottom", "crafting_bench:workbench", "src" },
	})
end
