local C = minetest.colorize
local F = minetest.formspec_escape

local S = crafting_bench.S

crafting_bench.resources.formspec = "size[10,10;]"
	.. "label[1,0;"
	.. S("source Material")
	.. "]"
	.. "list[context;src;1,1;2,4;]"
	.. "label[4,0;"
	.. S("recipe to use")
	.. "]"
	.. "list[context;rec;4,1;3,3;]"
	.. "label[7.5,0;"
	.. S("craft output")
	.. "]"
	.. "list[context;dst;8,1;1,4;]"
	.. "list[current_player;main;1,6;8,4;]"
	.. "listring[current_name;dst]"
	.. "listring[current_player;main]"
	.. "listring[current_name;src]"
	.. "listring[current_player;main]"

if crafting_bench.has.default then
	crafting_bench.resources.formspec = "size[10,10;]"
		.. default.gui_bg
		.. default.gui_bg_img
		.. default.gui_slots
		.. "label[1,0;"
		.. S("source material")
		.. "]"
		.. "list[context;src;1,1;2,4;]"
		.. "label[4,0;"
		.. S("recipe to use")
		.. "]"
		.. "list[context;rec;4,1;3,3;]"
		.. "label[7.5,0;"
		.. S("craft output")
		.. "]"
		.. "list[context;dst;8,1;1,4;]"
		.. "list[current_player;main;1,6;8,4;]"
		.. "listring[current_name;dst]"
		.. "listring[current_player;main]"
		.. "listring[current_name;src]"
		.. "listring[current_player;main]"
end

if crafting_bench.has.mcl_formspec then
	crafting_bench.resources.formspec = "formspec_version[4]"
		.. "size[11.75,10.425]"
		.. mcl_formspec.get_itemslot_bg_v4(1, 0.75, 2, 3)
		.. mcl_formspec.get_itemslot_bg_v4(5, 0.75, 3, 3)
		.. mcl_formspec.get_itemslot_bg_v4(10, 0.75, 1, 3)
		.. "label[1,0.375;"
		.. S("source material")
		.. "]"
		.. "list[context;src;1,0.75;2,4;]"
		.. "label[5,0.375;"
		.. S("recipe to use")
		.. "]"
		.. "list[context;rec;5,0.75;3,3;]"
		.. "label[9.5,0.375;"
		.. S("craft output")
		.. "]"
		.. "list[context;dst;10,0.75;1,4;]"
		.. "label[0.375,4.7;"
		.. F(C(mcl_formspec.label_color, S("inventory")))
		.. "]"
		.. mcl_formspec.get_itemslot_bg_v4(0.375, 5.1, 9, 3)
		.. "list[current_player;main;0.375,5.1;9,3;9]"
		.. mcl_formspec.get_itemslot_bg_v4(0.375, 9.05, 9, 1)
		.. "list[current_player;main;0.375,9.05;9,1;]"
		.. "listring[current_name;dst]"
		.. "listring[current_player;main]"
		.. "listring[current_name;src]"
		.. "listring[current_player;main]"
end
