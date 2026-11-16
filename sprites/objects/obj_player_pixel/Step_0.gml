 	// Segue o player
	x = round(Obj_Player.x);
	y = round(Obj_Player.y);
	
	// Seta o ajuste atual
	
	global.cur_adjust = collision_point(
	    x,
	    y,
	    obj_cam_adjust,
	    false,
	    true
	);
	 