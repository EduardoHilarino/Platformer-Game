// ** 1. Fade Out **
var _alpha = particle_alpha * (life / max_life);

// ** 2. Draw Particles **
draw_set_alpha(_alpha);
draw_set_colour(particle_color);

// ** Particle Size **
var _size = 1;

// ** Draw Particle **
var _px = round(x);
var _py = round(y);

draw_rectangle( _px, _py, _px + _size - 1, _py + _size - 1, false);

// ** 3. Reset Draw Settings **
draw_set_alpha(1);
draw_set_colour(c_white);