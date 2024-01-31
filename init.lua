futil.check_version({ year = 2023, month = 2, day = 27 }) -- required for FakeInventory.room_for_all

minetest.register_alias("castle:workbench", "crafting_bench:workbench")

crafting_bench = fmod.create()

crafting_bench.dofile("util")
crafting_bench.dofile("resources", "init")

crafting_bench.dofile("bench")

crafting_bench.dofile("refund_craft")
crafting_bench.dofile("craft")

crafting_bench.dofile("compat", "init")
