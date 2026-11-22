// ** Death Particle Animation **

    // * Particle Sprite *
    var _particle_spr = Spr_Player_death_particles;

    // * Total Animation Frames *
    var _particle_frames = max(1, sprite_get_number(_particle_spr));

    // * Animation Progress *
    var _progress = 0;

    // * Particle Position *
    var _px = death_fx_x;
    var _py = death_fx_y;

    // * Draw Particle Animation *
    var _draw_particles = false;


// ** Death Particles **

	if (transition_phase == -1)
	{
	    // * Animation Progress *
	    _progress = clamp(transition_timer / particle_duration, 0, 1);

	    // * Draw Particle Animation *
	    _draw_particles = true;
	}


// ** Reverse Animation **

	if (transition_phase == 2)
	{
	    // * Animation Progress *
	    _progress = 1 - clamp(transition_timer / open_duration, 0, 1);

	    // * Particle Position *
	    _px = respawn_fx_x;
	    _py = respawn_fx_y;

	    // * Draw Particle Animation *
	    _draw_particles = true;
	}


// ** Draw Particles **

	if (_draw_particles)
	{
	    // * Calculate Animation Frame *
	    var _particle_frame = min(_particle_frames - 1, floor(_progress * _particle_frames));

	    // * Center Sprite Regardless of Origin *
	    var _draw_x = _px + sprite_get_xoffset(_particle_spr) - sprite_get_width(_particle_spr) * 0.5;

	    var _draw_y = _py + sprite_get_yoffset(_particle_spr) - sprite_get_height(_particle_spr) * 0.5;

	    // * Draw Animation *
	    draw_sprite_ext(_particle_spr, _particle_frame, _draw_x, _draw_y, 1, 1, 0, c_white, 1);
	}


// ** Mosaic Animation **

	if (transition_phase >= 0 && transition_phase <= 2)
	{
	    // * Sprite Settings *
	    var _spr = Spr_Transition;
	    var _frames = max(1, sprite_get_number(_spr));

	    // * Animation Progress *
	    var _mosaic_progress = 0;

	    // * Closing Animation *
	    if (transition_phase == 0)
	    {
	        _mosaic_progress = clamp(transition_timer / close_duration, 0, 1);
	    }

	    // * Black Screen *
	    if (transition_phase == 1)
	    {
	        _mosaic_progress = 1;
	    }

	    // * Opening Animation *
	    if (transition_phase == 2)
	    {
	        _mosaic_progress = 1 - clamp(transition_timer / open_duration, 0, 1);
	    }

	    // * Calculate Animation Frame *
	    var _frame = min(_frames - 1, floor(_mosaic_progress * _frames));

	    // * Camera Settings *
	    var _cam = view_camera[0];

	    var _cam_x = camera_get_view_x(_cam);
	    var _cam_y = camera_get_view_y(_cam);

	    var _cam_w = camera_get_view_width(_cam);
	    var _cam_h = camera_get_view_height(_cam);

	    // * Sprite Dimensions *
	    var _sw = sprite_get_width(_spr);
	    var _sh = sprite_get_height(_spr);

	    // * Sprite Origin *
	    var _ox = sprite_get_xoffset(_spr);
	    var _oy = sprite_get_yoffset(_spr);

	    // * Draw Mosaic *
	    if (_sw > 0 && _sh > 0)
	    {
	        var _start_x = floor(_cam_x / _sw) * _sw;
	        var _start_y = floor(_cam_y / _sh) * _sh;

	        for (var _x = _start_x; _x < _cam_x + _cam_w; _x += _sw)
	        {
	            for (var _y = _start_y; _y < _cam_y + _cam_h; _y += _sh)
	            {
	                draw_sprite(_spr, _frame, _x + _ox, _y + _oy);
	            }
	        }
	    }

	    // * Ensure Black Screen *
	    if (transition_phase == 1)
	    {
	        draw_set_color(c_black);
	        draw_rectangle(_cam_x, _cam_y, _cam_x + _cam_w, _cam_y + _cam_h, false);
	    }
	}


// ** Reset Draw Settings **

	draw_set_alpha(1);
	draw_set_color(c_white);