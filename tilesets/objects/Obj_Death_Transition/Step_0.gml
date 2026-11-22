// ** Death Transition Controller **

	// * Check Player *
	if (!instance_exists(target_player))
	{
			instance_destroy();
			exit;
	}

	// * Delta Time *
	var _dt = delta_time / 1000000;
	
	// * Update Transition Timer *
	transition_timer += _dt;
	
// ** Transition States **

	switch (transition_phase)
	{	
		// * 0. Death Particle Animation *
		case -1:
		{
		    if (transition_timer >= particle_duration)
		    {
		        // Start Closing Mosaic 
		        transition_phase = 0;
		        transition_timer = 0;
		    }

		    break;
		}
		
		// * 1. Closing Mosaic *
		case 0:
		{
		    if (transition_timer >= close_duration)
		    {
		        // Start Black Screen 
		        transition_phase = 1;
		        transition_timer = 0;
		    }

		    break;
		}
		
		// * 2. Black Screen *
		case 1:
		{
		    // Respawn Once 
		    if (!respawn_done)
		    {
		        // Respawn Player Behind Black Screen 
		        with (target_player)
		        {
		            Scr_Player_respawn();
		        }

		        // Save New Particle Position 
		        respawn_fx_x = (target_player.bbox_left + target_player.bbox_right) * 0.5;
		        respawn_fx_y = (target_player.bbox_top + target_player.bbox_bottom) * 0.5;

		        respawn_done = true;
		    }

		    // Wait While Screen Is Black 
		    if (transition_timer >= black_duration)
		    {
		        transition_phase = 2;
		        transition_timer = 0;
		        flash_timer = 0;
		    }

		    break;
		}
		
		// * 3. Opening Mosaic *
		case 2:
		{
			
	        if (transition_timer >= open_duration)
	        {
	            transition_phase = 3;
	            transition_timer = 0;
	        }

	        break;

		}
		
		// * 4. Finish Respawn Animation *
		case 3:
		{	
			if (!sound_played)
			{
				// * Play Revive Sound *
				audio_play_sound(Snd_revive, 0, false, 0.3, 0, random_range(0.7, 2));
				
				sound_played = true;
			}
		
			// Continue Player Flash 
			flash_timer += _dt;

			target_player.death_flash_active = (floor(flash_timer * flash_frequency) mod 2) == 0;
			
			if (transition_timer >= finish_duration)
			{	

				// Restore Player Appereance
				target_player.death_flash_active = false;
				
				// Restore Player Controls
				target_player.death_transition = false;
				
				// Destroy Transition Controller
				instance_destroy();
			}
			
			break;	
		}
	}
		