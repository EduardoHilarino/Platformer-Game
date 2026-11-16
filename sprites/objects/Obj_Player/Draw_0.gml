	// ** Player Rendering **
	
	// * Get Sprite Foot Position *
	var _foot_offset = sprite_get_bbox_bottom(sprite_index) - sprite_get_yoffset(sprite_index);
	
	// * Compensate Vertical Scaling *
	var _draw_y = y + _foot_offset * (1 - image_yscale);
	
	// * Draw Player With Grounded Feet *
	draw_sprite_ext(sprite_index, image_index, x, _draw_y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);