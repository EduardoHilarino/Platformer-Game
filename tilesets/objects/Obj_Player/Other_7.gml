// ** Death Transition Animation **

// * Wait for Transition Controller *
if (state == PlayerState.DEATH && death_transition)
{
    exit;
}

// ** Turn Animation **
	if (state == PlayerState.TURN && sprite_index == Spr_Player_turn)
	{
	    // * Finish Turn Animation *
	    core_turning = false;
	}


// ** Death Transition Animation **
	// * Wait for Transition Controller *
		if (state == PlayerState.DEATH && death_transition)
		{
			exit;	
		}

// ** Victory Animation **
	if (state == PlayerState.WIN && sprite_index == Spr_Player_win)
	{
	    // * Stop Victory Animation *
	    image_speed = 0;
	    image_index = min(5, image_number - 1);

	    // * Stop Player Movement *
	    core_player.vx = 0;
	    core_player.vy = 0;

	    // * Play Victory Sounds *
	    audio_play_sound(Snd_Victory_dingle, 0, false, 0.2, 0);
	    audio_play_sound(Snd_Victory_voice, 0, false, 0.2, 0);
	}
