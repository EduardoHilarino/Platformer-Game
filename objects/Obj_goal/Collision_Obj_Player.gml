<<<<<<< Updated upstream
other.win = true;

sprite_index = Spr_goal_win
other.state = PlayerState.WIN;
=======
other.win = true;

sprite_index = Spr_goal_win
other.state = PlayerState.WIN;

with (Obj_Run_Manager)
{
	run_active = false;
	run_finished = true;
	victory_screen = true;
	
	// * Save Personal Records *
	Scr_Save_Records();
	
	// * Records Debug *
	show_debug_message("Deaths: " + string(run_deaths));
	show_debug_message("Best Deaths: " + string(best_deaths));
	show_debug_message("New Best Deaths: " + string(new_best_deaths));
}
>>>>>>> Stashed changes
