// ** 1. Fade Out **
var _alpha = particle_alpha * (life / max_life);

// * Smoke Fade Out *
if (particle_type == 2)
{
	var _remaining = clamp(life / max_life, 0, 1);
	
	// Keep Smoke Opaque Before Dissolving 
	if (_remaining > 0.35)
	{
		_alpha = particle_alpha;
	}
	
	else
	{
		_alpha = particle_alpha * (_remaining / 0.35)
	}	
}

// ** 2. Draw Particles **
draw_set_alpha(_alpha);
draw_set_colour(particle_color);

// ** Particle Size **
var _size = 1;

// ** Draw Particle **
var _px = round(x);
var _py = round(y);

if (particle_type == 2)
{	
	// * Smoke Shrinking *
	var _progress = life / max_life		
	
	if (_progress > 0.55)
	{
		// * Main Smoke Body *
		draw_rectangle(_px - 1, _py - 1, _px + 1, _py, false);
		
		// * Irregular Pixels Shapes *
		switch (smoke_variant)
		{
			case 0:
				draw_rectangle(_px, _py - 2, _px + 1, _py - 2, false);
				break;
			
			case 1:
				draw_rectangle(_px - 2, _py, _px - 1, _py + 1, false);
				break;
			
			case 2:
				draw_rectangle(_px + 1, _py, _px + 2, _py + 1, false);
				break;
				
			case 3:
				draw_rectangle(_px - 1, _py + 1, _px + 1, _py + 1, false);
				break;
		}
	}
	
	else if (_progress > 0.25)
	{
		// * Reduced Smoke Shape *
		draw_rectangle(_px, _py - 1, _px + 1, _py, false);
	}
	
	else
	{
		// * Final Smoke Pixel *
		draw_rectangle(_px, _py, _px, _py, false);
	}
}

else
{
	draw_rectangle( _px, _py, _px + _size - 1, _py + _size - 1, false);
}

// ** 3. Reset Draw Settings **
draw_set_alpha(1);
draw_set_colour(c_white);