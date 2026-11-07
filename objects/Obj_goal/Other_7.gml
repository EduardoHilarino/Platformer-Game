if (sprite_index == Spr_goal_win)
{
	image_speed = 0;
	image_index = 15;
	
audio_play_sound(Snd_Victory_dingle, 0, false, 0.3, 0, random_range(0.7, 1));
audio_play_sound(Snd_Victory_voice, 0, false, 0.3, 0, random_range(0.7, 1));
}