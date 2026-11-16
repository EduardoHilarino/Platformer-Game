if (other.state != PlayerState.DEATH) {
	audio_play_sound(Snd_death, 0, 0, 0.6, 0,random_range(0.5, 1.5))
   // ** 1. Player Death **

    // * Stop Player Movement *
    with (other)
    {
        if (state != PlayerState.DEATH
            && state != PlayerState.WIN)
        {
            core_player.vx = 0;
            core_player.vy = 0;

            // * Start Death Animation *
            state = PlayerState.DEATH;
            Scr_Player_Animation(state);
        }
    }
}