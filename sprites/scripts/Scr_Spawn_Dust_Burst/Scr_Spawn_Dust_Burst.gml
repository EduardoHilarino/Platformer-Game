	// ** Compact Dust Particle Burst **
	
	// * Spawn A Small Group Of Particles In One Direction *
	function Scr_Spawn_Dust_Burst(_x, _y, _nx, _ny, _count , _force)
	{
		// * Surface Tangent *
		var _tx = -_ny;
		var _ty = _nx
		
		// * Shared Burst Speed *
		var _base_speed = random_range(0.35, 0.55) * _force;
		
		// * Spawn Grouped Particles *
		repeat (_count)
		{
			// Small Spawn Area	
			var _offset = random_range(-2, 2);
			var _depth = random_range(-0.8, 0.8);
			
			var _px = _x + _tx * _offset + _nx * _depth;
			var _py = _y + _ty * _offset + _ny * _depth;
			
			// Create Particle 
			var _particle = instance_create_layer( _px, _py, "Particles", Obj_Particle);
			
			_particle.particle_type = 2;
			
			// Shared Direction With Small Random Variation
			var _speed = _base_speed + random_range(-0.06, 0.06);
			var _spread = random_range(-0.10, 0.10);
			
			_particle.hsp = _nx * _speed + _tx * _spread;
			_particle.vsp = _ny * _speed + _ty * _spread;
			
			// Short Lifetime
			_particle.life = irandom_range(14, 20);
			_particle.max_life = _particle.life;
			
			// Appareance 
			_particle.particle_color = make_colour_rgb(238, 236, 230);
			_particle.particle_alpha = 1;
			
			// Slow Down
			_particle.friction_amount = 0.94;
		}
	}