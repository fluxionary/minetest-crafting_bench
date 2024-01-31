crafting_bench.resources.groups = {}

if crafting_bench.has.default then
	crafting_bench.resources.groups = { choppy = 2, oddly_breakable_by_hand = 2, flammable = 2 }
end

if crafting_bench.has.mcl_core then
	crafting_bench.resources.groups = { axey = 2, handy = 1, flammable = -1, container = 4 }
end
