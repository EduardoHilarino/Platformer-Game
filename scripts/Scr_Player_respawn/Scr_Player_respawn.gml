
function Scr_Player_respawn()
{
    // ** 1. Respawn Position **

        // * Default Spawn Position *
        var _spawn_x = xstart;
        var _spawn_y = ystart;

        // * Check Saved Checkpoint *
        if (variable_instance_exists(id, "respawn_x"))
        {
            _spawn_x = respawn_x;
        }

        if (variable_instance_exists(id, "respawn_y"))
        {
            _spawn_y = respawn_y;
        }

        // * Restore Player Position *
        x = _spawn_x;
        y = _spawn_y;

    // ** 2. Reset Player Physics **

        // * Recreate Core Controller *
        core_player = player_create(x + core_origin_offset_x, y + core_origin_offset_y);

    // ** 3. Reset Player Visuals **

        // * Restore Life State *
        is_dead = false;
        state = PlayerState.IDLE;

        // * Reset Turn Animation *
        core_turning = false;
        core_turn_remaining = 0;

        // * Reset Dash Effects *
        core_last_event = core_player.last_event;
        core_dash_trail_counter = 0;

        // * Restore Sprite Properties *
        image_alpha = 1;
        image_blend = c_white;
        image_angle = 0;
        image_xscale = core_player.facing;

        // * Restore Idle Animation *
        Scr_Player_Animation(state);
}
