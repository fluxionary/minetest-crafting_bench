minetest.register_lbm({
	name = "crafting_bench:refund",
	label = "refund crafting bench recipe",
	nodenames = { "crafting_bench:workbench" },
	run_at_every_load = true,
	action = function(pos, node, dtime_s)
		local meta = minetest.get_meta(pos)
		if meta:get("refunded") then
			return
		end

		local inv = meta:get_inventory()
		local to_refund = minetest.deserialize(meta:get("to_refund"))

		if not to_refund then
			to_refund = {}
			for i, item in ipairs(inv:get_list("rec")) do
				if not item:is_empty() then
					table.insert(to_refund, item:to_string())
					if item:get_count() > 1 then
						inv:set_stack("rec", i, item:peek_item())
					end
				end
			end

			meta:set_string("formspec", crafting_bench.resources.formspec)
			crafting_bench.update_timer(pos)
		end

		local remaining = {}
		for _, item in ipairs(to_refund) do
			local remainder = inv:add_item("dst", item)
			if not remainder:is_empty() then
				table.insert(remaining, remainder:to_string())
			end
		end

		if #remaining == 0 then
			meta:set_string("refunded", "true")
			meta:set_string("to_refund", "")
		else
			meta:set_string("to_refund", minetest.serialize(remaining))
		end
	end,
})
