// ** 1. Player Life State **

    // * Suspend Physics During Death And Victory *
    // Existing Animation End And Respawn Events Can Continue Running
    if (state == PlayerState.DEATH || state == PlayerState.WIN)
    {
        exit;
    }

// ** 2. Player Input **

    // * Horizontal And Vertical Input *
    var _input = input_empty();

    _input.mx = keyboard_check(ord("D")) - keyboard_check(ord("A"));
    _input.my = keyboard_check(ord("S")) - keyboard_check(ord("W"));

    // * Jump Input *
    _input.jump = keyboard_check(vk_space);
    _input.jump_pressed = keyboard_check_pressed(vk_space);

    // * Air Dash Input *
    // Reject Ground Input Instead Of Buffering A Dash For The Next Jump
    _input.dash_pressed = keyboard_check_pressed(vk_shift);

    // * Climb Input *
    _input.grab = keyboard_check(ord("C"));

// ** 3. Player Physics **

    // * Remember Previous Velocity For Turn Animation *
    var _previous_vx = core_player.vx;
	
	// * Remember Previous Vertical Movement *
	var _was_grounded = core_player.grounded;
	var _previous_vy = core_player.vy;

    // * Run The Complete Celeste Movement Controller *
    tick(core_player, core_world, _input, 1 / 60);
		
    // * Synchronize The GameMaker Instance Position *
    x = core_player.px - core_origin_offset_x;
    y = core_player.py - core_origin_offset_y;

	// * Running And Landing Dust Effects *
	
		// Landing Dust
		if (!_was_grounded && core_player.grounded)
		{
		    var _impact_speed = max(0, _previous_vy);

		    if (_impact_speed > 55)
		    {
		        var _strength = clamp(_impact_speed / core_player.c.MaxFall, 0, 1);

		        // Left Dust Burst
		        Scr_Spawn_Dust_Burst(core_player.px - 2, core_player.py - 1, 0, -1, 5, 0.7 + _strength * 0.53);

		        // Right Dust Burst
		        Scr_Spawn_Dust_Burst(core_player.px + 2, core_player.py - 1, 0, -1, 5, 0.7 + _strength * 0.53);
		    }
		}
	
		// Running Dust
		
		if (core_player.grounded && core_player.state == "normal" && abs(core_player.vx) > 65)
		{
			dust_run_timer--;
			
			if (dust_run_timer <= 0)
			{	
				// Dynamic Particle Frequency 
				dust_run_timer = (abs(core_player.vx) > 85) ? 6 : 9;
				
				// Running Dust Particles
				repeat (irandom_range(2, 3))	
				{
					Scr_Spawn_Dust(core_player.px - sign(core_player.vx) * 3, core_player.py - 1, 1, irandom_range(0.45, 0.65));
				}
			}
		}	
		
		else
		{
			dust_run_timer = 0;	
		}
		
		// Jumping Dust
		if (core_player.jump_fx_id > dust_last_jump_id)
		{
			var _event = core_player.last_event;
			
			// Wall Jump Dust
			if (_event == "wall jump" || _event == "super wall jump" || _event == "climb jump")
			{
				// Direction Away From Wall
				var _away = sign(core_player.vx);
				
				if (_event == "climb jump" || _away == 0)
				{
					_away = -core_player.facing;	
				}
				
				// Create Dust Along Wall
				Scr_Spawn_Dust_Burst(core_player.px - _away * 6, core_player.py - height(core_player) * 0.5, _away, 0, 4, 1);
			}
			
					
			else
			{
				// Ground Jump Dust
				Scr_Spawn_Dust_Burst(core_player.px, core_player.py - 1, 0, -1, 4, 0.65);
			}
		}
		
		dust_last_jump_id = core_player.jump_fx_id;
		
		// Wall Slide Dust
		
		// Detect Wall Slide
		var _wall_sliding = 
		core_player.state == "normal" &&
		!core_player.grounded &&
		core_player.vy > 12 &&
		core_player.slide_timer > 0 &&
		_input.my != 1 &&
		( _input.mx == core_player.facing ||
		( _input.mx == 0 && _input.grab)) &&
		wall_check(core_player, core_world, core_player.facing, 1);
		
		// Spawm Wall Dust 
		if (_wall_sliding)
		{
			dust_slide_timer--;
			
			if (dust_slide_timer <= 0)
			{
				dust_slide_timer = 7;
				
				Scr_Spawn_Dust_Burst(core_player.px + core_player.facing * 4, core_player.py - 5, -core_player.facing, 0, 2, 0.5);
			}
				
		}
		
		else
		{
			dust_slide_timer = 0;	
		}

 // ** 4. Player Animation **

    // * Detect Horizontal Wall Contact *
    var _pushing_wall = 
	(core_player.grounded && _input.mx != 0 && wall_check(core_player, core_world, _input.mx, 1));

    // * Detect Direction Reversal *
    var _direction_changed = 
	(_input.mx != 0 && core_last_move_input != 0 && _input.mx != core_last_move_input);

    // * Detect Turn Animation *
    var _turn_requested = 
	(core_player.state != "climb" && core_player.grounded && !core_turning && !_pushing_wall && _direction_changed && abs(_previous_vx) > 20);

	if (_turn_requested)
	{
	    // * Preserve Previous Facing Direction *
	    core_turn_facing = sign(_previous_vx);

	    // * Start Turn Animation *
	    core_turning = true;
	}

    // * Remember Movement Input *
    if (_input.mx != 0)
    {
        core_last_move_input = _input.mx;
    }

    // * Cancel Turn In Air *
    if (!core_player.grounded)
    {
        core_turning = false;
    }

    // * Determine Visual State *
    var _visual_state = PlayerState.IDLE;

    if (core_player.state == "dash")
    {
        _visual_state = PlayerState.DASH;
        core_turning = false;
    }
	
	else if (core_player.state == "climb")
	{
		_visual_state = PlayerState.CLIMB;
		core_turning = false;
	}
	
    else if (!core_player.grounded)
    {
        _visual_state = (core_player.vy < 0)
            ? PlayerState.JUMP
            : PlayerState.FALL;
    }
	
    else if (core_turning)
    {
        _visual_state = PlayerState.TURN;
    }
	
    else if (_pushing_wall)
    {
        _visual_state = PlayerState.IDLE;
    }
	
    else if (_input.mx != 0 && abs(core_player.vx) > 5)
    {
        _visual_state = PlayerState.RUN;
    }

    // * Update Sprite Only When The Visual State Changes *
	if (state != _visual_state)
	{
	    // * Restore Animation Speed After Climbing *
	    if (state == PlayerState.CLIMB)
	    {
	        image_speed = 1;
	    }

	    state = _visual_state;
	    Scr_Player_Animation(state);
	}
	
	// * Climb Animation Speed *
	if (state == PlayerState.CLIMB)
	{
		if (core_player.climb_move != 0 && abs(core_player.vy) > 5)
		{
			image_speed = 1;
		}
		
		else
		{
			image_speed = 0;
			image_index = 11;
		}
	}	

	// * Update Facing Direction *

	// ** Squash And Stretch System **

	// * Continuous Movement Deformation *
	var _target_x = 1;
	var _target_y = 1;

	if (core_player.state == "dash")
	{
	    if (abs(core_player.dash_x) >= abs(core_player.dash_y))
	    {
	        _target_x = 1.05;
	        _target_y = 0.98;
	    }
		
	    else
	    {
	        _target_x = 0.98;
	        _target_y = 1.05;
	    }
	}
	
	else if (core_player.state == "climb")
	{
	    _target_x = 1;
	    _target_y = 1;
	}
	
	else if (!core_player.grounded)
	{
	    if (core_player.vy < -35)
	    {
	        _target_x = 0.97;
	        _target_y = 1.05;
	    }
		
	    else if (core_player.vy > 45)
	    {
	        _target_x = 0.98;
	        _target_y = 1.04;
	    }
	}

	// * Detect Movement Events *
	var _jump_started =
	    squash_was_grounded
	    && !core_player.grounded
	    && core_player.vy < -35;

	var _landed = !squash_was_grounded && core_player.grounded && _previous_vy > 40;

	var _dash_started = !squash_was_dashing && core_player.state == "dash" && !core_player.dash_pending;

	// * Event Deformation *
	var _pulse = false;
	var _pulse_x = 1;
	var _pulse_y = 1;

	if (_landed)
	{
	    _pulse_x = 1.14;
	    _pulse_y = 0.88;
	    _pulse = true;

	    squash_jump_next = false;
	}
	
	else if (_dash_started)
	{
	    if (abs(core_player.dash_x) >= abs(core_player.dash_y))
	    {
	        _pulse_x = 1.07;
	        _pulse_y = 0.97;
	    }
		
	    else
	    {
	        _pulse_x = 0.97;
	        _pulse_y = 1.07;
	    }

	    _pulse = true;
	    squash_jump_next = false;
	}
	
	else if (_jump_started)
	{
	    // * Compress At Jump Launch *
	    _pulse_x = 1.12;
	    _pulse_y = 0.90;
	    _pulse = true;

	    squash_jump_next = true;
	}
	
	else if (squash_jump_next)
	{
	    // * Stretch On The Following Frame *
	    _pulse_x = 0.94;
	    _pulse_y = 1.10;
	    _pulse = true;

	    squash_jump_next = false;
	}

	// * Apply Deformation *
	if (_pulse)
	{
	    squash_x = 1 + (_pulse_x - 1) * squash_intensity;
	    squash_y = 1 + (_pulse_y - 1) * squash_intensity;
	}
	
	else
	{
	    _target_x = 1 + (_target_x - 1) * squash_intensity;
	    _target_y = 1 + (_target_y - 1) * squash_intensity;

	    squash_x = lerp(squash_x, _target_x, 0.25);
	    squash_y = lerp(squash_y, _target_y, 0.25);
	}

	// * Apply Visual Scale *
	if (state == PlayerState.TURN)
	{
	    image_xscale = core_turn_facing * squash_x;
	}
	
	else
	{
	    image_xscale = core_player.facing * squash_x;
	}

	image_yscale = squash_y;

	// * Remember Previous States *
	squash_was_grounded = core_player.grounded;
	squash_was_dashing = core_player.state == "dash" && !core_player.dash_pending;
	
// ** 5. Dash Effects **

    // * Detect Dash Launch *
    if (core_last_event != core_player.last_event)
    {
        if (core_player.last_event == "dash")
        {
            // Dash Particles
            // Create dash particle burst
            repeat (10)
            {	
				// Dash Direction
				var _dx = core_player.dash_x;
				var _dy = core_player.dash_y;
				
				// Perperdicular Direction
				var _side_x = -_dy;
				var _side_y = _dx;
				
				// Random spread
				var _spread = random_range(-0.25, 0.25);
                var _speed = random_range(0.8, 2);
				
				// Random Spawn offset
				var _offset = random_range(-2, 2);
				
                // Random spawn position
                var _px = x + _side_x * _offset;
                var _py = y + 5 + _side_y * _offset;
						
                // Create Particle
                var _particle = instance_create_layer(_px, _py, "Particles", Obj_Particle);

                // Particle type
                _particle.particle_type = 1;

                // Move opposite to dash
                _particle.hsp = (_dx + _side_x * _spread) * _speed;
                _particle.vsp = (_dy + _side_y * _spread) * _speed;

                // Lifetime
                _particle.life = irandom_range(75, 110);
                _particle.max_life = _particle.life;

                // Appareance
                _particle.particle_color = make_colour_rgb(176, 0, 255 );
                _particle.particle_alpha = 1;

                // Slow down
                _particle.friction_amount = 0.95;
            }

            audio_play_sound(Snd_dash, 0, false, 0.3, 0, random_range(0.7, 2));
            instance_create_layer(x, y, "Entitys", Obj_shake);
        }

        core_last_event = core_player.last_event;
    }

    // * Create Dash Trail *
    if (core_player.state == "dash" && !core_player.dash_pending)
    {	
		// Increase trail counter
        core_dash_trail_counter += 1;
		
		// Create one trail every three frames, starting at frame one
        if ((core_dash_trail_counter - 1) mod 3 == 0)
        {
            var _rast = instance_create_layer(x, y, "Effects", Obj_rastro);

            _rast.image_xscale = image_xscale;
            _rast.sprite_index = sprite_index;
            _rast.image_index = image_index;
            _rast.image_speed = 0;
        }
    }
	
    else
    {
        core_dash_trail_counter = 0;
    }

// ** 6. Independent Game Systems **

    // Keep Non-Physics Gameplay Logic Here
    // Checkpoints, Interactions, Death Triggers And Victory Conditions
	
	// ** Movement Debug **

    // * Toggle Movement Debug *
    if (keyboard_check_pressed(vk_f3))
    {
        debug_movement = !debug_movement;
        debug_frame = 0;
    }

    // * Record Movement Data *
    if (debug_movement)
    {
        debug_frame++;

        var _actual_movement = x - debug_last_x;

        show_debug_message(
            "FRAME: " + string(debug_frame)
            + " | INPUT: " + string(_input.mx)
            + " | VX: " + string(core_player.vx)
            + " | X: " + string(x)
            + " | DX: " + string(_actual_movement)
            + " | STATE: " + string(state)
            + " | CORE STATE: " + string(core_player.state)
            + " | GROUNDED: " + string(core_player.grounded)
        );
    }

    // * Remember Previous Position *
    debug_last_x = x;
	
	if (win)
	{
		state = PlayerState.WIN;	
		
		sprite_index = Spr_Player_win

	}
