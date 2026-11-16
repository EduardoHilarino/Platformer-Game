
// Turn Animation
if (state == PlayerState.TURN && sprite_index == Spr_Player_turn)
{
    // * Finish Turn Animation *
    core_turning = false;
}

// Death Animation
if (state == PlayerState.DEATH && sprite_index == Spr_Player_death)
{
    // * Respawn Player *
    Scr_Player_respawn();

    // * Play Revive Sound *
    audio_play_sound(Snd_revive, 0, false, 0.3, 0, random_range(0.7, 2));
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
