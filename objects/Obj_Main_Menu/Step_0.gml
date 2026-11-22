// * Update Animation *
menu_anim += 0.045;

// ** Menu Intro Timer **
if (menu_intro_time < menu_intro_duration)
{
	menu_intro_time += delta_time / 1000000;
	
	menu_intro_time = min(menu_intro_time, menu_intro_duration);
}

// ** Main Menu Controls **

// * Navigation *
var _up = keyboard_check_pressed(ord("W")) || keyboard_check_pressed(vk_up);
var _down = keyboard_check_pressed(ord("S")) || keyboard_check_pressed(vk_down);

var _confirm = keyboard_check_pressed(vk_enter);

// * Move Selection *
if (_up)
{
	menu_index--;
	
	if (menu_index < 0)
	{
		menu_index = array_length(menu_options) - 1;
	}
}

if (_down)
{
	menu_index++;	
	
	if (menu_index > array_length(menu_options))
	{
		menu_index = 0;
	}
}

// * Mouse Navigation *
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

var _cx = display_get_gui_width() * 0.5;
var _half_width = min(180, max(90, display_get_gui_width() * 0.3));

var _mouse_moved = (_mx != menu_last_mouse_x || _my != menu_last_mouse_y);

var _mouse_option = -1;

// * Check Menu Options *
for (var i = 0; i < array_length(menu_options); i++)
{
	var _y = menu_options_y + i * menu_spacing;
	
	if (abs(_mx = _cx) <= _half_width && abs(_my - _y) <= menu_spacing * 0.45)
	{
		_mouse_option = i;
		break;
	}
}

// * Update Selection On hover *
if (_mouse_moved && _mouse_option >= 0)
{
	menu_index = _mouse_option;	
}

// * Mouse Click *
if (mouse_check_button_pressed(mb_left) && _mouse_option >= 0)
{
	menu_index = _mouse_option;
	_confirm = true;
}

// * Save Mouse Position *
menu_last_mouse_x = _mx;
menu_last_mouse_y = _my;

// * Animate Selection Indicator *
var _target_y = menu_options_y + menu_index * menu_spacing;

menu_indicator_y = lerp(menu_indicator_y, _target_y, menu_indicator_speed);

// * Block Confirmation During Intro *
_confirm = _confirm
    && menu_intro_time >= menu_intro_duration;

// * Confirm Selection *
if (_confirm)
{
	switch (menu_index)
	{
		case 0: 
			room_goto(Tutorial);
			break;
			
		case 1: 
			game_end();
			break;
	}
}

// ** Parallax Animation **

// * Update Background Timer *
menu_bg_time += delta_time / 1000000;