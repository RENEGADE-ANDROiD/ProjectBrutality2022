// Minimal projectile base for CSSG add-on (was a separate engine branch's PB_Projectile)
class PB_Projectile : FastProjectile
{
	bool isBloodExplosionGenerator;
}

class CSSGChunk1 : FastProjectile
{
	default
	{
		radius 3;
		height 3;
		speed 450;
		damage 4;
		+NOGRAVITY;
	}
}

class CSSGChunk2 : FastProjectile
{
	default
	{
		radius 3;
		height 3;
		speed 420;
		damage 4;
		+NOGRAVITY;
	}
}

class CSSGChunk4 : FastProjectile
{
	default
	{
		radius 3;
		height 3;
		speed 400;
		damage 5;
		+NOGRAVITY;
	}
}
