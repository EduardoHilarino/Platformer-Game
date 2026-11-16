// ** Main Menu Drawing **

// * GUI Dimensions *
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

var _cx = _gui_w * 0.5;

// * Background *
draw_set_color(make_colour_rgb(17, 21, 33));
draw_rectangle(0, 0, _gui_w, _gui_h, false);

// * Draw Title *
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

global.font_main = font_add_sprite_ext(spr_main_font, "!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~çõóôáãé✅✖ ", true, 2);
draw_set_font(global.font_main);

draw_set_colour(c_white);
draw_text_transformed(_cx, menu_title_y, "MAIN MENU", title_scale, title_scale, 0);

// * Draw Menu Options *
for (var i = 0; i < array_length(menu_options); i ++)
{
	var _y = menu_options_y + i * menu_spacing;
	
	if (i == menu_index)
	{
		draw_set_color(menu_selected_color);
		draw_text_transformed(_cx, _y, "> " + menu_options[i] + " <", option_scale, option_scale, 0);
	}
	
	else
	{
		draw_set_color(menu_color);
		draw_text_transformed(_cx, _y, menu_options[i], option_scale, option_scale, 0);
	}
}

// * Draw Controls *
draw_set_colour(c_grey);
draw_text(_cx, _gui_h - 20, "W / S - Enter");

// * Reset Draw Settings *
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);