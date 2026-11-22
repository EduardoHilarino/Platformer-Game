function Scr_Save_Records()
{
	// ** Save Personal Records **
	
	// * Get Run Manager *
	var _manager = instance_find(Obj_Run_Manager, 0);
	
	if (_manager == noone)
	{
		return;	
	}
	
	// * Prevent Duplicate Saves *
	if (_manager.records_saved)
	{
		return;	
	}
	
	_manager.records_saved = true;
	
	// * Reset New Records Flags *
	_manager.new_best_time = false;
	_manager.new_best_deaths = false;
	
	// * Best Time Debug *
	show_debug_message("RUN TIME: " + string(_manager.run_time));
	show_debug_message("BEST TIME BEFORE: " + string(_manager.best_time));
	
	// * Check Best Time *
	if (_manager.best_time < 0 || _manager.run_time < _manager.best_time)
	{
		_manager.best_time = _manager.run_time;
		_manager.new_best_time = true;	
	}
	
	// * Check Fewest Deaths *
	if (_manager.best_deaths < 0 || _manager.run_deaths < _manager.best_deaths)
	{
		_manager.best_deaths = _manager.run_deaths;
		_manager.new_best_deaths = true;
	}
	
	// * Save Records *
	if (_manager.new_best_deaths || _manager.new_best_time)
	{
		ini_open("records.ini");
		
		ini_write_real("Records", "BestTime", _manager.best_time);
		ini_write_real("Records", "BestDeaths", _manager.best_deaths);
		
		ini_close();	
	}
}