 // Setar as variaveis
	
	
	
	// Administra a camera
	cam = view_camera[0];
	follow = Obj_Player;
	view_w_half = camera_get_view_width(cam) / 2;
	view_h_half = camera_get_view_height(cam) / 2;
	global.cur_adjust = noone;
	
	// Coordenadas
	x_to = 0;
	y_to = 0;
	
	// Clamp
	left_clamp = false;
	right_clamp = false;
	down_clamp = false;
	up_clamp = false;
	