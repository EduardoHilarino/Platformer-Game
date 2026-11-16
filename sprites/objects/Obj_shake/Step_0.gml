
	// ** Camera Shake **

	shake = lerp(shake, 0, 0.1);

	var _x = random_range(-shake, shake);
	var _y = random_range(-shake, shake);

	var _cam_x = camera_get_view_x(cam);
	var _cam_y = camera_get_view_y(cam);

	camera_set_view_pos(
	    cam,
	    _cam_x + _x,
	    _cam_y + _y
	);

	if (shake <= 0.1) {
	    instance_destroy();
	}
	 