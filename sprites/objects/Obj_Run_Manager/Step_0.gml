// ** Speedrun Timer **
if (run_active && !run_finished)
{
	// * Delta Time In Seconds *
	var _dt = delta_time / 1000000;
	
	// * Update Timer *
	run_time += _dt;
}