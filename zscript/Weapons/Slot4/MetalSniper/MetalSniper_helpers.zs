class MS_ResonanceAmmo : FastProjectile
{
	Default
	{
		Radius 2;
		Height 2;
		Speed 200;
		Damage 120;
		DamageType "Stun";
		Projectile;
		+RIPPER;
		+BLOODLESSIMPACT;
		+NOEXTREMEDEATH;
		Decal "BulletChip";
	}

	override int SpecialMissileHit(Actor victim)
	{
		if (!victim)
			return -1;
		// PBX used a "Shield" actor; Marauder uses ShieldUp inventory while blocking.
		bool hitShield = (victim.GetClassName() == "Shield") || victim.CountInv("ShieldUp") >= 1;
		if (hitShield)
		{
			A_SpawnItemEx("StunGrenadeExplosion", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
			return 0;
		}
		return -1;
	}
}
