// ** Dust Particles Effects **
	
	// Spawns Dust Particles Around The Player's Feet
	function Scr_Spawn_Dust(_x, _y, _count, _force)
	{
		// * Spawn Particles *
		repeat (_count)
		{
			var _dust = instance_create_layer(_x + irandom_range(-4, 4), _y - 1, "Particles", Obj_Particle);
			
			// Particle Properties
			_dust.particle_type = 1;
			
			_dust.hsp = random_range(-1, 1) * _force;
			_dust.vsp = random_range(-1.2, -0.3) * _force;
			
			_dust.life = irandom_range(10, 18);
			_dust.max_life = _dust.life;
			
			_dust.particle_color = make_color_rgb(200, 200, 200);
			_dust.particle_alpha = 1;
			
			_dust.friction_amount = 0.85;
		}
	}