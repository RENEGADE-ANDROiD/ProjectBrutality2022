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
		// Eternal Dark Lord tracks shield with user_shieldup (energy/Stun disrupt).
		bool hitShield = (victim.GetClassName() == "Shield") || victim.CountInv("ShieldUp") >= 1;
		if (!hitShield)
		{
			let edl = PB_EternalDarkLordBase(victim);
			if (edl && edl.EDL_IsShieldUp())
				hitShield = true;
		}
		if (hitShield)
		{
			A_SpawnItemEx ("StunGrenadeExplosion",0,0,1,0,0,0,0,SXF_NOCHECKPOSITION,0);
			return 0;
		}
		return -1;
	}
   states
	{
		Death:
		TNT1 A 0 {
		A_SpawnItemEx ("StunGrenadeExplosion",0,0,1,0,0,0,0,SXF_NOCHECKPOSITION,0);
		}
		stop;
	}
}
