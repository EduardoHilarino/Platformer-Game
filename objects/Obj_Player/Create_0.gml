// ** 1. Player Core Initialization **

    // * Fixed Physics Frame Rate *
		game_set_speed(60, gamespeed_fps);

    // * Preserve The Visual Sprite Origin *
    // The Core Physics Position Uses The Center Of The Feet
	    core_origin_offset_x = ((bbox_left + bbox_right + 1) * 0.5) - x;
	    core_origin_offset_y = (bbox_bottom + 1) - y;

    // * Initialize The Core Physics Controller *
		var _solid_layer = layer_get_id("Solid");
		
		if (_solid_layer == -1)
		{
			show_error("Tile Layer 'Solid' was not found!", true);
		}
		
		var _solid_tilemap = layer_tilemap_get_id(_solid_layer)
		
		if (_solid_tilemap == -1)
		{
			show_error("Layer 'Solid' must be a Tile Layer!", true);
		}
		
		core_world = {solids: [], platforms: [], solid_tilemap: _solid_tilemap};
	
	// * One Way Platform Inicialization *
		core_player = player_create(x + core_origin_offset_x, y + core_origin_offset_y);
		
	// * Disable Wall Speed Retention For Testing *
		core_player.c.WallSpeedRetentionTime = 0;

// ** 2. Player Visual Initialization **

    // * Initialize Animation State *
	    state = PlayerState.IDLE;
	    Scr_Player_Animation(state);

	// * Initialize Turn Animation *
		core_turning = false;
	
	// * Turn Animation Facing *
		core_turn_facing = 1;

	// * Remember Previous Movement Input *
		core_last_move_input = 0;

    // * Initialize Dash Effects *
	    core_last_event = core_player.last_event;
	    core_dash_trail_counter = 0;

// ** 3. Independent Game Systems **

	
	// * Checkpoint *
		respawn_x = x;
		respawn_y = y;

	// * Collision Mask *
		mask_index = Spr_Player_Idle;

	// * Camera *
		if (!instance_exists(obj_player_pixel))
		{
		    instance_create_layer(x, y, "Camera", obj_player_pixel);
		}

	// * Win *
		win = false;
	
	// * Death System *
		is_dead = false;
		
	// ** Movement Debug **

    // * Debug Configuration *
	    debug_movement = false;
	    debug_frame = 0;
	    debug_last_x = x;


