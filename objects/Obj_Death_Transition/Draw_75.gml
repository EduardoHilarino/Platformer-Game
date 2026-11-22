// ** Mosaic Transition **

    // * Sprite Settings *
    var _spr = Spr_Transition;
    var _frames = max(1, sprite_get_number(_spr));

    // * Transition Progress *
    var _progress = 0;

    switch (transition_phase)
    {
        // * Closing *
        case 0:
            _progress = clamp(transition_timer / close_duration, 0, 1);
            break;

        // * Black Screen *
        case 1:
            _progress = 1;
            break;

        // * Opening *
        case 2:
            _progress = 1 - clamp(transition_timer / open_duration, 0, 1);
            break;
    }

    // * Draw Mosaic *
    if (transition_phase <= 2)
    {
        var _frame = min(_frames - 1, floor(_progress * _frames));

        draw_set_alpha(1);
        draw_set_color(c_white);

        // * GUI Dimensions *
        var _gw = display_get_gui_width();
        var _gh = display_get_gui_height();

        // * Mosaic Sprite Dimensions *
        var _sw = sprite_get_width(_spr);
        var _sh = sprite_get_height(_spr);

        // * Mosaic Scale *
        var _scale = max(1, ceil(_gw / (_sw * 20)));

        // * Tile Dimensions *
        var _tw = _sw * _scale;
        var _th = _sh * _scale;

        // * Sprite Origin *
        var _ox = sprite_get_xoffset(_spr) * _scale;
        var _oy = sprite_get_yoffset(_spr) * _scale;

        // * Draw Tiled Mosaic *
        for (var _x = 0; _x < _gw; _x += _tw)
        {
            for (var _y = 0; _y < _gh; _y += _th)
            {
                draw_sprite_ext(_spr, _frame, _x + _ox, _y + _oy, _scale, _scale, 0, c_white, 1);
            }
        }
    }

    // * Ensure Black Screen *
    if (transition_phase == 1)
    {
        draw_set_color(c_black);
        draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    }

    // * Reset Draw Settings *
    draw_set_alpha(1);
    draw_set_color(c_white);


// ** Reverse Death Particle Animation **

if (transition_phase == 2)
{
    // * Particle Sprite *
    var _particle_spr = Spr_Player_death_particles;

    // * Total Animation Frames *
    var _particle_frames = max(1, sprite_get_number(_particle_spr));

    // * Reverse Animation Progress *
    var _particle_progress = 1 - clamp(transition_timer / open_duration, 0, 1);

    // * Calculate Animation Frame *
    var _particle_frame = min(_particle_frames - 1, floor(_particle_progress * _particle_frames));

    // * Respawn Position *
    var _px = respawn_fx_x;
    var _py = respawn_fx_y;

    // * GUI Scale *
    var _scale_x = 1;
    var _scale_y = 1;

    // * Convert World Position to GUI Position *
    if (view_enabled && view_visible[0])
    {
        var _cam = view_camera[0];

        var _cam_x = camera_get_view_x(_cam);
        var _cam_y = camera_get_view_y(_cam);

        var _cam_w = camera_get_view_width(_cam);
        var _cam_h = camera_get_view_height(_cam);

        _scale_x = display_get_gui_width() / _cam_w;
        _scale_y = display_get_gui_height() / _cam_h;

        _px = (respawn_fx_x - _cam_x) * _scale_x;
        _py = (respawn_fx_y - _cam_y) * _scale_y;
    }

    // * Center Sprite Regardless of Origin *
    var _draw_x = _px
        + (sprite_get_xoffset(_particle_spr)
        - sprite_get_width(_particle_spr) * 0.5) * _scale_x;

    var _draw_y = _py + (sprite_get_yoffset(_particle_spr) - sprite_get_height(_particle_spr) * 0.5) * _scale_y;

    // * Draw Reverse Animation *
    draw_sprite_ext(_particle_spr, _particle_frame, _draw_x, _draw_y, _scale_x, _scale_y, 0, c_white, 1);
}

// ** Transition Debug **

// * Debug Background *
draw_set_alpha(1);
draw_set_color(c_red);
draw_rectangle(0, 0, 50, 50, false);

// * Debug Information *
draw_set_color(c_white);
draw_text(60, 10, "PHASE: " + string(transition_phase));
draw_text(60, 30, "TIMER: " + string(transition_timer));