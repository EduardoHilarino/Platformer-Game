// ** 1. Update Spawn Timer
spawn_timer--;

// ** 2. Create Particle **
if (spawn_timer <= 0)
{
	// Reset Timer
	spawn_timer = irandom_range(spawn_min, spawn_max);
	
	// Limit Particles
	if (instance_number(Obj_Particle) < particle_limit)
	{
		
		// Get camera
		var _camera = view_camera[0];
		
		var _cam_x = camera_get_view_x(_camera);
		var _cam_y = camera_get_view_y(_camera);
		
		var _cam_w = camera_get_view_width(_camera);
		var _cam_h = camera_get_view_height(_camera);
		
		// Random Position
		var _px = _cam_x + random(_cam_w);
		var _py = _cam_y + random(_cam_h);
		
		// Create Particle 
		var _particle = instance_create_layer(_px, _py, "Particles", Obj_Particle);
		
		// Particle Type
		_particle.particle_type = 0;
		
		// Gentle Wind
		_particle.hsp = random_range(0.10, 0.35);
		_particle.vsp = random_range(-0.08, 0.08);
		
		// Lifetime
		_particle.life = irandom_range(120, 240)
		_particle.max_life = _particle.life;
		
		// Appareance
		_particle.particle_color = c_white;
		_particle.particle_alpha = random_range(0.2, 0.5);
		
		// No Friction
		_particle.friction_amount = 1;
	}
}