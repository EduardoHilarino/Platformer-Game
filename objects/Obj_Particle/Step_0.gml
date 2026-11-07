// ** 1. Moviment **
x += hsp;
y += vsp;

// ** 2. Particle Friction **
hsp *= friction_amount;
vsp *= friction_amount;

// ** 3. Lifetime **
life--;

// ** Destroy Particle **
if (life <= 0)
{
	instance_destroy();
}