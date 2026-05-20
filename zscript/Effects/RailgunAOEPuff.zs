// AOE puff along railgun laser trace (from BulletPuffs.txt; isolated so RailGunFire.zc can set dmg/rad).
class RailgunAOEPuff : Actor
{
	int dmg, rad;

	Default
	{
		Radius 5;
		Height 5;
		+Nointeraction;
		+Noblockmap;
		+Nodamagethrust;
		DamageType "Incinerate";
		Obituary "%o was besieged by %k.";
	}

	States
	{
	Spawn:
		TNT1 A 0 NoDelay A_Explode(dmg, rad, 0, 0, 96);
		TNT1 A 1;
		Stop;
	}
}
