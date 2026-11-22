// ** Main Menu Drawing **

	// * GUI Dimensions *
	var _gui_w = display_get_gui_width();
	var _gui_h = display_get_gui_height();

	var _cx = _gui_w * 0.5;

// ** Menu Background **

	// * GUI Dimensions *
	var _gw = display_get_gui_width();
	var _gh = display_get_gui_height();
	
	// * Pixel Art Scale *
	var _scale = max(1, floor(_gh / 240));
	
	// * Reset Draw	Settings *
	draw_set_color(c_white);
	draw_set_alpha(1);
			
// ** Sky Background **
	
	// * Draw Sky *
	draw_sprite_stretched(Spr_Menu_background, 0, 0, 0, _gw, _gh);
	
	// ** Montain Layers **
	
	// * Draw Each Layer *
	for (var i = 0; i < array_length(menu_bg_layers); i++)
	{
		// * Get Layer Sprite *
		var _spr = menu_bg_layers[i];
		
		// * Sprite	Dimensions *
		var _tile_width = sprite_get_width(_spr) * _scale;
		var _tile_height = sprite_get_height(_spr) * _scale;
		
		// * Layer Position *
		var _y = _gh - _tile_height;
		
		// * Horizontal Movement *
		var _scroll = (menu_bg_time * menu_bg_speeds[i] * _scale) mod _tile_width;	
		
		// * Draw Repeating Sprites *
		for (var _x = -_scroll; _x < _gw; _x += _tile_width)
		{	
			draw_sprite_ext(_spr, 0, round(_x), round(_y), _scale, _scale, 0, c_white, 1);
		}	
	}
	
	// * Reset Draw	Settings *
	draw_set_color(c_white);
	draw_set_alpha(1);
	
// ** Animated Menu Title **

	// * Title Position *
	var _title_y = round(menu_title_y + sin(menu_anim) * 2);
	
	// * Text Alignment *
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	
	// * Title Shadow *
	draw_set_colour(make_colour_rgb(88, 60, 135));
	
	draw_text_transformed(_cx + 2, _title_y + 2, "MAIN MENU", title_scale, title_scale, 0);
	
	// * Main Title *
	draw_set_color(c_white);
	
	draw_text_transformed(_cx, _title_y, "MAIN MENU", title_scale, title_scale, 0);

// ** Menu Selection Visuals **

	// * Panel Dimensions *
	var _panel_half = min(180, max(90, display_get_gui_width() * 0.3));
	
	var _panel_x1 = round(_cx - _panel_half);
	var _panel_x2 = round(_cx + _panel_half);
	
	var _panel_y1 = round(menu_indicator_y - menu_spacing * 0.45);
	var _panel_y2 = round(menu_indicator_y + menu_spacing * 0.45);
	
	// * Panel Shadow *
	draw_set_color(c_black);
	draw_set_alpha(0.45);
	
	draw_rectangle(_panel_x1, _panel_y1, _panel_x2, _panel_y2, false);
	
	// * Panel Outline *
	draw_set_color(make_colour_rgb(175, 145, 255));
	
	draw_rectangle(_panel_x1, _panel_y1, _panel_x2, _panel_y2, true);
	
	// * Reset Draw Settings *
	draw_set_alpha(1);
	draw_set_color(c_white);
	
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

// * Reset Draw Settings *
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// ** Animated Controls Hint **
	
	// * Hint Position *
	var _hint_x = display_get_gui_width() * 0.5;
	var _hint_y = display_get_gui_height() - 18;
	
	// * Pulsing Animation *
	var _hint_alpha = 0.65 + sin(menu_bg_time * 2.5) * 0.25;
	
	// * Text Settings *
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);

	// * Hint Shadow *
	draw_set_alpha(_hint_alpha * 0.5);
	draw_set_color(c_black);

	draw_text_transformed(_hint_x + 1, _hint_y + 1,"W/S - ENTER - MOUSE", 1, 1, 0);

	// * Hint Text *
	draw_set_alpha(_hint_alpha);
	draw_set_color(make_color_rgb(200, 185, 255));

	draw_text_transformed(_hint_x, _hint_y, "W/S - ENTER - MOUSE", 1, 1, 0);

	// * Reset Draw Settings *
	draw_set_alpha(1);
	draw_set_color(c_white);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);

// ** Menu Intro Animation **

	// * Intro Progress *
	var _intro_progress = clamp(menu_intro_time / menu_intro_duration, 0, 1);
	
	// * Smoothness Easing *
	var _intro_ease = _intro_progress *	(3 - 2 * _intro_progress);
	
	// * Intro Fade *
	var _intro_alpha = 1 - _intro_ease;
	
	// * Draw Fade Overlay *
	if (_intro_alpha > 0)
	{
		draw_set_alpha(_intro_alpha)
		draw_set_colour(c_black);
		
		draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
	}
	
	// * Reset Draw Settings *
	draw_set_alpha(1);
	draw_set_color(c_white);