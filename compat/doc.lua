if not crafting_bench.has.doc then
	return
end

local S = crafting_bench.S
local crafting_rate = crafting_bench.settings.crafting_rate

local usage_help = S(
	"the inventory on the left is for raw materials, the inventory on the right holds finished products. "
		.. "the crafting grid in the center defines what recipe this workbench will make use of; "
		.. "place raw materials into it in the crafting pattern corresponding to what you want to build."
)

if (crafting_bench.has.hopper and hopper.add_container ~= nil) or crafting_rate.has.mcl_hoppers then
	usage_help = usage_help
		.. "\n\n"
		.. S(
			"this workbench is compatible with hoppers. "
				.. "hoppers will insert into the raw material inventory and remove items from the finished goods inventory."
		)
end

minetest.override_item("crafting_bench:workbench", {
	_doc_items_longdesc = S(
		"a workbench that does work for you. set a crafting recipe and provide raw materials and items will "
			.. "magically craft themselves once every @1 seconds.",
		tostring(crafting_rate)
	),
	_doc_items_usagehelp = usage_help,
})
