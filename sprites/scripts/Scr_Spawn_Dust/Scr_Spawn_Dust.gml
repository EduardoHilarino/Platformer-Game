// ** Dust Particles Effects **
	
	// Spawns Dust Particles Around The Player's Feet
	function Scr_Spawn_Dust(_x, _y, _count, _force, _direction = 0)
	{
		// * Spawn Particles *
		repeat (_count)
		{
			var _dust = instance_create_layer(_x + irandom_range(-2, 2), _y - 1, "Particles", Obj_Particle);
			
			// Particle Properties
			_dust.particle_type = 1;
			
			// Directional Movement
			var _trail_dir = (_direction == 0) ? choose(-1, 1) : -sign(_direction);
			
			_dust.hsp = _trail_dir * random_range(1, 1.3) * _force;
			_dust.vsp = random_range(-0.8, -0.35) * _force;
			
			_dust.life = irandom_range(12, 16);
			_dust.max_life = _dust.life;
			
			_dust.particle_color = make_color_rgb(255, 255, 255);
			_dust.particle_alpha = 1;
			
			_dust.friction_amount = 0.9;
		}
	}