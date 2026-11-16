// ** Run Manager Settings **

// * Timer *
run_time = 0;
run_active = true;
run_finished = false;

// * Death Counter *
run_deaths = 0;

display_set_gui_size(320, 240);

// ** Victory Screen Settings **
victory_screen = false;

// ** Personal Records Settings **

// * Record Variables *
best_time = -1;
best_deaths = -1;

// * Load Records *
ini_open("records.ini");

best_time = ini_read_real("Records", "BestTime", -1);
best_deaths = ini_read_real("Records", "BestDeaths", -1);

ini_close();

// * Record Control *
records_saved = false;

// * New Records *
new_best_time = false;
new_best_deaths = false;

