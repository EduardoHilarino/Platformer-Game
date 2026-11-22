// ** Main Menu Settings **

// * Menu Options *
menu_options = [
	"Start Game",
	"Quit Game"
];

// * Menu Seletion *
menu_index = 0;

// * Menu Appearance *
menu_spacing = 150;
menu_title_y = 65;
menu_options_y = 400;

// * Menu Colors *
menu_color = c_white;
menu_selected_color = make_colour_rgb(180, 150, 255);

// ** Font Settings **
title_scale = 9;
option_scale = 5;

// ** Menu Animation Settings **

// * Selection Indicator *
menu_indicator_y = menu_options_y;
menu_indicator_speed = 0.25;

// * Mouse Tracking *
menu_last_mouse_x = device_mouse_x_to_gui(0);
menu_last_mouse_y = device_mouse_y_to_gui(0);

// * Menu Animation *
menu_anim = 0;


global.font_main = font_add_sprite_ext(spr_main_font, "!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~çõóôáãé✅✖ ", true, 2);
draw_set_font(global.font_main);

// ** Parallax Background Layers **

// * Animation Timer *
menu_bg_time = 0;

// * Background Layers *
menu_bg_layers = [
	Spr_Menu_background_1,
	Spr_Menu_background_2,
	Spr_Menu_background_3
]

// * Layer Speeds *
menu_bg_speeds = [
	3, 7, 12 ];
	
// ** Menu Intro Animation **

// * Intro Settings *
menu_intro_time = 0;
menu_intro_duration = 3;


	

