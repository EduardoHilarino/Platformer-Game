// ** Player Collision Debug **

// * Core Physics Hitbox *
draw_set_color(c_red);

draw_rectangle(
    core_player.px - 4,
    core_player.py - height(core_player),
    core_player.px + 3,
    core_player.py - 1,
    true
);

// * GameMaker Sprite Collision Mask *
draw_set_color(c_lime);

draw_rectangle(
    bbox_left,
    bbox_top,
    bbox_right,
    bbox_bottom,
    true
);

// * Restore Draw Color *
draw_set_color(c_white);