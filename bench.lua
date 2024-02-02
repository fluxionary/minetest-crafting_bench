local S = crafting_bench.S

local invsize_src = 2 * 4
local invsize_dst = 1 * 4

if crafting_bench.has.mcl_core then
	invsize_src = 2 * 3
	invsize_dst = 1 * 3
end

minetest.register_node("crafting_bench:workbench", {
	description = S("Workbench"),
	tiles = {
		"crafting_bench_workbench_top.png",
		"crafting_bench_workbench_bottom.png",
		"crafting_bench_workbench_side.png",
		"crafting_bench_workbench_side.png",
		"crafting_bench_workbench_back.png",
		"crafting_bench_workbench_front.png",
	},
	paramtype2 = "facedir",
	groups = crafting_bench.resources.groups,
	sounds = crafting_bench.resources.sounds,
	drawtype = "normal",
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", crafting_bench.resources.formspec)
		meta:set_string("infotext", S("Workbench"))
		local inv = meta:get_inventory()
		inv:set_size("src", invsize_src)
		inv:set_size("rec", 3 * 3)
		inv:set_size("dst", invsize_dst)
	end,
	can_dig = function(pos, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		return inv:is_empty("src") and inv:is_empty("dst")
	end,
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		local to_refund = minetest.deserialize(oldmetadata.fields.to_refund)
		if to_refund then
			for i = 1, #to_refund do
				if not minetest.add_item(pos, to_refund[i]) then
					crafting_bench.log("error", "lost %q @ %s", to_refund[i], minetest.pos_to_string(pos))
				end
			end
		end
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		if not minetest.is_player(player) or minetest.is_protected(pos, player:get_player_name()) then
			return 0
		end

		if to_list == "dst" then
			return 0
		elseif to_list == "rec" then
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			local stack = inv:get_stack(from_list, from_index)
			stack:set_count(1)
			inv:set_stack(to_list, to_index, stack)
			crafting_bench.update_timer(pos)
			return 0
		elseif from_list == "rec" then
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			inv:set_stack(from_list, from_index, "")
			crafting_bench.update_timer(pos)
			return 0
		end

		return count
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local stack = inv:get_stack(to_list, to_index)
		stack:set_count(count)

		crafting_bench.log(
			"action",
			"%s moves %s in workbench @ %s",
			player:get_player_name(),
			stack:to_string(),
			minetest.pos_to_string(pos)
		)

		crafting_bench.update_timer(pos)
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if not minetest.is_player(player) or minetest.is_protected(pos, player:get_player_name()) then
			return 0
		end

		if listname == "rec" then
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			stack:set_count(1)
			inv:set_stack("rec", index, stack)
			crafting_bench.update_timer(pos)
			return 0
		elseif listname == "dst" then
			return 0
		end

		return stack:get_count()
	end,
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		crafting_bench.log(
			"action",
			"%s put %s in workbench @ %s",
			player:get_player_name(),
			stack:to_string(),
			minetest.pos_to_string(pos)
		)

		crafting_bench.update_timer(pos)
	end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		if not minetest.is_player(player) or minetest.is_protected(pos, player:get_player_name()) then
			return 0
		end

		if listname == "rec" then
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			inv:set_stack("rec", index, "")
			crafting_bench.update_timer(pos)
			return 0
		end

		return stack:get_count()
	end,
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		crafting_bench.log(
			"action",
			"%s took %s from workbench @ %s",
			player:get_player_name(),
			stack:to_string(),
			minetest.pos_to_string(pos)
		)

		crafting_bench.update_timer(pos)
	end,
	on_timer = function(pos, elapsed)
		crafting_bench.do_craft(pos)

		if crafting_bench.can_craft(pos) then
			return true
		end
	end,
	on_blast = function(pos, intensity, owner)
		if owner and minetest.is_protected(pos, owner) then
			return
		end
		local items = { "crafting_bench:workbench" }
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local src = inv:get_list("src")
		for i = 1, #src do
			if not src[i]:is_empty() then
				items[#items + 1] = src[i]
			end
		end
		local dst = inv:get_list("dst")
		for i = 1, #dst do
			if not dst[i]:is_empty() then
				items[#items + 1] = dst[i]
			end
		end
		local to_refund = minetest.deserialize(meta:get("to_refund"))
		if to_refund then
			table.insert_all(items, to_refund)
		end
		minetest.remove_node(pos)
		return items
	end,
})
