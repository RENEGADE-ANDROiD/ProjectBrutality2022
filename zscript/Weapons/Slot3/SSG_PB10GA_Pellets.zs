class PB_10GAPellet : FastProjectile
{
	Default
	{
		Radius 3;
		Height 3;
		Speed 480;
		Damage 18;
		Projectile;
		+NOGRAVITY;
		DamageType "Shotgun";
		Obituary "%o was turned inside out by %k.";
	}
	States
	{
	Spawn:
		"TRAC" A 1 Bright;
		Loop;
	Death:
		TNT1 A 0;
		Stop;
	}
}

class PB_10GAPellet_LP : PB_10GAPellet
{
	Default
	{
		Damage 35;
		DamageType "Shotgun";
	}
}

// Commander / HASG slug: must not inherit DragonsBreathTracer (fire trail + ignite death).
class PB_12GASlug : PB_10GAPellet
{
	Default
	{
		Damage 24;
		DamageType "Bullet";
		Scale 0.35;
	}
}

class PB_8GAPellet : FastProjectile
{
	Default
	{
		Radius 3;
		Height 3;
		Speed 480;
		Damage 17;
		Projectile;
		+NOGRAVITY;
		DamageType "Shotgun";
		Obituary "%o was turned inside out by %k.";
	}
	States
	{
	Spawn:
		"TRAC" A 1 Bright;
		Loop;
	Death:
		TNT1 A 0;
		Stop;
	}
}

class PB_8GAPellet_LP : PB_8GAPellet
{
	Default
	{
		Damage 50;
		DamageType "Shotgun";
	}
}
