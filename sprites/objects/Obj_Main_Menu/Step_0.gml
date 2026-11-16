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