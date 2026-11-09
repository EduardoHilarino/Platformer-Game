
function Scr_Player_Animation(_new_state)
{
    // ** 1. Animation Configuration **

        // * Default Animation *
        var _sprite_name = "Spr_Player_Idle";

    // ** 2. Animation State Selection **

        // * Select Sprite By State *
        switch (_new_state)
        {
            case PlayerState.IDLE:
                _sprite_name = "Spr_Player_Idle";
                break;

            case PlayerState.RUN:
                _sprite_name = "Spr_Player_run";
                break;

            case PlayerState.TURN:
                _sprite_name = "Spr_Player_turn";
                break;

            case PlayerState.JUMP:
                _sprite_name = "Spr_Player_Jump";
                break;

            case PlayerState.FALL:
                _sprite_name = "Spr_Player_fall";
                break;

            case PlayerState.DASH:
                _sprite_name = "Spr_Player_Dash";
                break;

            case PlayerState.DEATH:
                _sprite_name = "Spr_Player_death";
                break;

            case PlayerState.WIN:
                _sprite_name = "Spr_Player_win";
                break;
				
			case PlayerState.CLIMB:
                _sprite_name = "Spr_Player_climb";
                break;
        }

    // ** 3. Apply Animation **

        // * Find Sprite Asset *
        var _new_sprite = asset_get_index(_sprite_name);

        // * Verify Sprite Availability *
        if (_new_sprite == -1)
        {
            show_debug_message("Missing Player Sprite: " + _sprite_name);

            return;
        }

        // * Change Sprite *
        if (sprite_index != _new_sprite)
        {
            sprite_index = _new_sprite;
            image_index = 0;
        }
}
