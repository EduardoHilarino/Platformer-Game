// ** Death Transition Settings **

	// * Player Reference *
		target_player = noone;
	
	// * Death Particle Position *
		death_fx_x = 0;
		death_fx_y = 0;

	// * Respawn Particle Position *
		respawn_fx_x = 0;
		respawn_fx_y = 0;
		
	// * Respawn Control *
		respawn_done = false;
		sound_played = false;

	// * Transition Timer *
		transition_timer = 0;

	// * Transition Durantions (Seconds) *
		close_duration = 0.17;
		black_duration = 0.34;
		open_duration = 0.17;
		finish_duration = 0.30;

	// * White Flash Timer *
		flash_timer = 0;
		flash_frequency = 12;

	// * Mosaic Settings *
		mosaic_columns = 24; 
		mosaic_delay = 0.65
		
// ** Death Particle Timing **

	// * Particle Animation Duration *
		particle_duration = sprite_get_number(Spr_Player_death_particles) / sprite_get_speed(Spr_Player_death_particles);

		if (sprite_get_speed_type(Spr_Player_death_particles) == spritespeed_framespergameframe)
		{
		    particle_duration /= game_get_speed(gamespeed_fps);
		}

	// * Transition States *
	// -1 = Death Particles
	//  0 = Closing Mosaic
	//  1 = Black Screen
	//  2 = Opening Mosaic
	//  3 = Final Flash
		transition_phase = -1;

