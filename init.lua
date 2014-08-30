
minetest.register_node( 'experimental:inv_move_demo', {
	description = 'Demo node for node inventory related calls in the lua api',
	name  = 'demo',
	tiles = {'default_chest_front.png^default_ladder.png'},
	groups = {cracky=3,oddly_breakable_by_hand=3},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",
			"size[8,9]"..
		        "list[current_name;main;1,1;6,1;]"..
		        "list[current_player;main;0,4;8,4;]" );
		meta:set_string("infotext", "Demo node for node inventory related calls in the lua api")
                local inv = meta:get_inventory()
                inv:set_size("main", 6) -- so that moving inventory around is possible

		-- fill with items for testing
		inv:set_stack("main", 2, "default:brick 1")
		inv:set_stack("main", 3, "default:sandstone 2")
		inv:set_stack("main", 4, "default:wood 10")
		inv:set_stack("main", 5, "default:stone 20")
		inv:set_stack("main", 6, "default:mese 99")
	end,
	
	--^ Called when a player wants to move items inside the inventory
	--^ Return value: number of items allowed to move
	allow_metadata_inventory_move = function(pos, from_list, from_index,
            to_list, to_index, count, player)

		minetest.chat_send_player( player:get_player_name(),
			'allow_metadata_inventory_move called with parameters: '..
			minetest.serialize( {
				pos=pos, from_list=from_list, from_index=from_index, 
				to_list=to_list, to_index=to_index, count=count,
				player=player:get_player_name() }));
		return 0; -- deny all moves
	end,

	--^ Called when a player wants to put something into the inventory
	--^ Return value: number of items allowed to put
	--^ Return value: -1: Allow and don't modify item count in inventory
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)

		minetest.chat_send_player( player:get_player_name(),
			'allow_metadata_inventory_put  called with parameters: '..
			minetest.serialize( {
				pos=pos, listname=listname, index=index,
				stack={stack=stack:get_name(), count=stack:get_count()},
				player=player:get_player_name() }));
		return 0; -- deny all attempts to put anything
	end,

	--^ Called when a player wants to take something out of the inventory
	--^ Return value: number of items allowed to take
	--^ Return value: -1: Allow and don't modify item count in inventory
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)

		minetest.chat_send_player( player:get_player_name(),
			'allow_metadata_inventory_take called with parameters: '..
			minetest.serialize( {
				pos=pos, listname=listname, index=index,
				stack={stack=stack:get_name(), count=stack:get_count()},
				player=player:get_player_name() }));
		return stack:get_count(); -- allow to take all
	end,

	-- ^ Called after the actual action has happened, according to what was allowed.
	-- ^ No return value
	on_metadata_inventory_move = function(pos, from_list, from_index,
            to_list, to_index, count, player)

		minetest.chat_send_player( player:get_player_name(),
			'on_metadata_inventory_move called with parameters: '..
			minetest.serialize( {
				pos=pos, from_list=from_list, from_index=from_index,
				to_list=to_list, to_index = to_index, count=count,
				player=player:get_player_name() }));
	end,

	on_metadata_inventory_put = function(pos, listname, index, stack, player)

		minetest.chat_send_player( player:get_player_name(),
			'on_metadata_inventory_put called with parameters: '..
			minetest.serialize( {
				pos=pos, listname=listname, index=index, 
				stack={stack=stack:get_name(), count=stack:get_count()},
				player=player:get_player_name() }));
	end,

	on_metadata_inventory_take = function(pos, listname, index, stack, player)

		minetest.chat_send_player( player:get_player_name(),
			'on_metadata_inventory_take called with parameters: '..
			minetest.serialize( {
				pos=pos, listname=listname, index=index,
				stack={stack=stack:get_name(), count=stack:get_count()},
				player=player:get_player_name() }));
	end,

	-- ^ fields = {name1 = value1, name2 = value2, ...}
	-- ^ Called when an UI form (e.g. sign text input) returns data
	-- ^ default: nil
	on_receive_fields = function(pos, formname, fields, sender)

		minetest.chat_send_player( sender:get_player_name(),
			'on_receive_fields called with parameters: '..
			minetest.serialize( {
				pos=pos, formname=formname, fields=fields,
				sender=sender:get_player_name() }));
	end,
})
