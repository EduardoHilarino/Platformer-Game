// ** Speedrun HUD **

// * Time Conversion *
var _total_cs = floor(run_time * 100);
var _minutes = _total_cs div 6000;
var _seconds = (_total_cs div 100) mod 60;
var _centiseconds = _total_cs mod 100;

// * Format Time *
var _time_text =
    string_pad(_minutes, 2) + ":" +
    string_pad(_seconds, 2) + "." +
    string_pad(_centiseconds, 2);
	
// * HUD Position *
var _hud_x = 2;
var _hud_y = 2;

// * HUD Spacing *
var _icon_size = 6;
var _icon_gap = 2;
var _row_spacing = 8;

// * Draw Settings *
draw_set_font(global.font_main);

draw_set_colour(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);

// * Draw Timer Icon *
draw_sprite_stretched(Spr_Timer, 0, _hud_x, _hud_y, _icon_size, _icon_size);

// * Draw Timer Text *
draw_text_transformed(_hud_x + _icon_size + _icon_gap, _hud_y + _icon_size / 2, _time_text, 0.5, 0.5, 0);

// * Draw Death Icon *
draw_sprite_stretched(Spr_Death_Counter, 0, _hud_x, _hud_y + _row_spacing, _icon_size, _icon_size);

// * Draw Death Counter *
draw_text_transformed(_hud_x + _icon_size + _icon_gap, _hud_y + _row_spacing + _icon_size / 2, string(run_deaths), 0.5, 0.5, 0);

// * Restore Draw Settings *
draw_set_halign(fa_left);
draw_set_valign(fa_top);	
draw_set_colour(c_white);
draw_set_alpha(1);

// ** Best Time Formatting **

// * Default Best Time *
var _best_time_text = "--:--.--";

// * Check Existing Record *
if (best_time >= 0)
{
    // * Time Conversion *
    var _best_cs = floor(best_time * 100);

    var _best_minutes = _best_cs div 6000;
    var _best_seconds = (_best_cs div 100) mod 60;
    var _best_centiseconds = _best_cs mod 100;

    // * Format Best Time *
    _best_time_text =
        string_pad(_best_minutes, 2) + ":" +
        string_pad(_best_seconds, 2) + "." +
        string_pad(_best_centiseconds, 2);
}

// ** Victory Screen **
if (victory_screen)
{
	// * GUI Dimensions *
	var _gui_w = display_get_gui_width();
	var _gui_h = display_get_gui_height();
	
	// * Screen Center *
	var _cx = _gui_w / 2;
	var _cy = _gui_h / 2;
	
	// * Background Overlay *
	draw_set_color(c_black);
	draw_set_alpha(0.6);
	draw_rectangle(0, 0, _gui_w, _gui_h, false);
	
	// * Draw Settings * 
	draw_set_alpha(1);
	draw_set_color(c_white);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	
	// * Victory Title *
	draw_text(_cx, _cy - 45, "LEVEL COMPLETE");
	
	// * Final Statistics *
	draw_text(_cx, _cy - 10, "TIME: " + _time_text);
	draw_text(_cx, _cy + 10, "DEATHS: " + string(run_deaths));
	
	// ** Personal Record Display **
	
	// * Best Time *
	draw_text(_cx, _cy + 30, "BEST TIME: " + _best_time_text);
	
	// * Fewest Deaths *
	var _best_deaths_text = "--";

	if (best_deaths >= 0)
	{
	    _best_deaths_text = string(best_deaths);
	}

	draw_text(_cx, _cy + 45, "FEWEST DEATHS: " + _best_deaths_text);
	
	// * New Record Notification *
	if (new_best_time || new_best_deaths)
	{
		draw_text(_cx, _cy + 65, "NEW PERSONAL RECORD!");
	} 
	
	// * Restore Draw Settings *
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);	
	draw_set_colour(c_white);
	draw_set_alpha(1);
}