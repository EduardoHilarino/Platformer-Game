if (other.state != PlayerState.DEATH && other.state != PlayerState.WIN && !other.death_transition) {
	
	audio_play_sound(Snd_death, 0, 0, 0.6, 0,random_range(0.5, 1.5))
	
	// ** 1. Player Death **

    // * Stop Player Movement *
    with (other)
    {
        if (state != PlayerState.DEATH
            && state != PlayerState.WIN)
        {	
			// * Lock Player Controls *
			death_transition = true;
			
			// * Create Death Transition *
			var _fx = instance_create_depth(x, y, -100000, Obj_Death_Transition);
			
			// * Save Player Reference
			_fx.target_player = id;
			
			// * Save Particle Spawn Position *
			_fx.death_fx_x = (bbox_left + bbox_right) * 0.5;
			_fx.death_fx_y = (bbox_top + bbox_bottom) * 0.5;
			
            core_player.vx = 0;
            core_player.vy = 0;

            // * Start Death Animation *
            state = PlayerState.DEATH;
            Scr_Player_Animation(state);
        }
    }
}