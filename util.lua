local crafting_rate = crafting_bench.settings.crafting_rate

local function get_single_string(item)
	item = ItemStack(item)
	item:set_count(1)
	return item:to_string()
end

local function get_craft_result(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local needed = inv:get_list("rec")

	-- note: get_craft_result can be very slow, until minetest 5.7.0 is released
	-- see https://github.com/minetest/minetest/issues/13231
	local output, decremented_input = minetest.get_craft_result({
		method = "normal",
		width = 3,
		items = needed,
	})

	return output, decremented_input, needed
end

function crafting_bench.can_craft(pos)
	local output, decremented_input, needed = get_craft_result(pos)

	if output.item:is_empty() then
		return false
	end

	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local needed_counts = {}
	for _, item in ipairs(needed) do
		local itemstring = get_single_string(item)
		needed_counts[itemstring] = (needed_counts[itemstring] or 0) + item:get_count()
	end

	for itemstring, count in pairs(needed_counts) do
		local item = ItemStack(itemstring)
		item:set_count(count)
		if not inv:contains_item("src", item) then
			return false
		end
	end

	-- now we need to check whether there's enough room for all the output
	local to_add = { output.item }
	table.insert_all(to_add, output.replacements)
	table.insert_all(to_add, decremented_input.items)

	return futil.FakeInventory.room_for_all(inv, "dst", to_add)
end

function crafting_bench.do_craft(pos)
	local output, decremented_input, needed = get_craft_result(pos)

	if output.item:is_empty() then
		crafting_bench.log("error", "@ %s: tried to craft, but no output", minetest.pos_to_string(pos))
	end

	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	for i = 1, #needed do
		local item = needed[i]
		local taken = inv:remove_item("src", item)
		if not futil.items_equals(item, taken) then
			crafting_bench.log(
				"error",
				"@ %s: tried to take %s but only got %s",
				minetest.pos_to_string(pos),
				item:to_string(),
				taken:to_string()
			)
		end
	end
	local remainder = inv:add_item("dst", output.item)
	if not remainder:is_empty() then
		crafting_bench.log(
			"error",
			"@ %s: no room for %s, adding as an item in the world",
			minetest.pos_to_string(pos),
			remainder:to_string()
		)
		minetest.add_item(pos, remainder)
	end
	for _, item in ipairs(output.replacements) do
		remainder = inv:add_item("dst", item)
		if not remainder:is_empty() then
			crafting_bench.log(
				"error",
				"@ %s: no room for %s, adding as an item in the world",
				minetest.pos_to_string(pos),
				remainder:to_string()
			)
			minetest.add_item(pos, remainder)
		end
	end
	for _, item in ipairs(decremented_input.items) do
		remainder = inv:add_item("dst", item)
		if not remainder:is_empty() then
			crafting_bench.log(
				"error",
				"@ %s: no room for %s, adding as an item in the world",
				minetest.pos_to_string(pos),
				remainder:to_string()
			)
			minetest.add_item(pos, remainder)
		end
	end
end

function crafting_bench.update_timer(pos)
	local timer = minetest.get_node_timer(pos)
	local cc = crafting_bench.can_craft(pos)
	local timer_is_started = timer:is_started()
	if cc and not timer_is_started then
		timer:start(crafting_rate)
	elseif not cc and timer_is_started then
		timer:stop()
	end
end
