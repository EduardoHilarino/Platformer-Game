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

    // * Run The Complete Celeste Movement Controller *
    tick(core_player, core_world, _input, 1 / 60);
		
    // * Synchronize The GameMaker Instance Position *
    x = core_player.px - core_origin_offset_x;
    y = core_player.py - core_origin_offset_y;


 // ** 4. Player Animation **

    // * Detect Horizontal Wall Contact *
    var _pushing_wall = 
	(core_player.grounded && _input.mx != 0 && wall_check(core_player, core_world, _input.mx, 1));

    // * Detect Direction Reversal *
    var _direction_changed = 
	(_input.mx != 0 && core_last_move_input != 0 && _input.mx != core_last_move_input);

    // * Detect Turn Animation *
    var _turn_requested = 
	(core_player.grounded && !core_turning && !_pushing_wall && _direction_changed && abs(_previous_vx) > 20);

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

    // * Update Sprite Only When State Changes *
    if (state != _visual_state)
    {
        state = _visual_state;
        Scr_Player_Animation(state);
    }

	// * Update Facing Direction *
	if (state == PlayerState.TURN)
	{
	    image_xscale = core_turn_facing;
	}
	
	else
	{
	    image_xscale = core_player.facing;
	}

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
                _particle.life = irandom_range(50, 70);
                _particle.max_life = _particle.life;

                // Appareance
                _particle.particle_color = c_white;
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
