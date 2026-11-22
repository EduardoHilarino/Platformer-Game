// ** Player Respawn Flash **

// * Draw White Flash *
if (death_flash_active)
{
    shader_set(Shd_Player_White);

    // * Draw Player Silhouette *
    draw_self();

    shader_reset();
}