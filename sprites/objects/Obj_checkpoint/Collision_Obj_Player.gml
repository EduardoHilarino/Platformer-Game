
 if (!Activated) 
 {
	 // Save the player position on respawn
	 other.respawn_x = spawn_x;
	 other.respawn_y = spawn_y;
	
	 // Marks as activated
	 Activated = true; 
	 
	 show_debug_message("Checkpoint Actived")
	 sprite_index  = Spr_Checkpoint_on;
	 audio_play_sound(Snd_Checkpoint, 0, 0, 0.4, 0,random_range(0.75, 1.25))
 }