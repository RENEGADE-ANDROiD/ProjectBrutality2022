// CSSG Sub-Zero shell projectiles (PBX parity).

class SubZ_Puff : FastProjectile
{
	Default
	{
		Projectile;
		+BLOODLESSIMPACT
		Radius 1;
		Height 1;
		Speed 75;
		Damage 0;
		Scale 0.50;
		DamageType "Ice";
		Decal "FreezerBurn";
	}

	States
	{
	Spawn:
		FRPJ ABC 1 Bright
		{
			A_SpawnProjectile("BlueFlareSpawn", 0, 0, 0, 0);
			A_SpawnProjectile("Icetracer", 0, 0, random(0, 360), 2, random(0, 360));
			A_SpawnItemEx("FreezerTrailSparksSmall", random(-5, 5), random(-5, 5), random(-5, 5), 0, 0, 0, 0, 128, 0);
			A_FadeOut(0.1);
		}
		Loop;

	Death:
		TNT1 A 0 A_SpawnItemEx("DetectFloorIce", 0, 0, 1, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
		TNT1 A 0 A_SpawnItemEx("DetectCeilIce", 0, 0, 1, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
		TNT1 AAAAA 0 Bright A_SpawnItemEx("CryoSmoke3", 0, 0, 0, random(10, 30) * 0.04, 0, random(0, 10) * 0.04, random(1, 360), SXF_CLIENTSIDE | SXF_NOCHECKPOSITION, 64);
		TNT1 AAAAAAA 0 Bright A_SpawnItemEx("FreezerTrailSparksSmall", random(-5, 5), random(-5, 5), random(-5, 5), random(10, 30) * 0.04, 0, random(0, 10) * 0.04, random(1, 360), SXF_CLIENTSIDE | SXF_NOCHECKPOSITION, 64);
		TNT1 AAAAAAA 0 Bright A_SpawnItemEx("CryoSmoke2", 0, 0, 0, random(10, 30) * 0.04, 0, random(0, 10) * 0.04, random(1, 360), SXF_CLIENTSIDE | SXF_NOCHECKPOSITION, 64);
		BXPL ABCDEFGH 1 Bright;
		BXPL IJKLLM 1 Bright A_FadeOut(0.1);
		Stop;
	}
}

class SubZeroProjectile : PB_10GAPellet
{
	Default
	{
		PB_Projectile.BaseDamage 35;
		DamageType "Ice";
	}
}

class CSSG_FrozenTracer : FastProjectile
{
	Default
	{
		Projectile;
		RenderStyle "Add";
		Alpha 0.9;
		Scale 0.5;
		DamageType "Ice";
		-DONTSPLASH;
		+RANDOMIZE;
		+FORCEXYBILLBOARD;
		+NOEXTREMEDEATH;
		Damage 0;
		Radius 2;
		Height 2;
		Speed 140;
		Scale 0.15;
	}

	States
	{
	Spawn:
		TRFR A 1 Bright;
		Loop;
	Death:
		FRPF ABCDEF 1;
		Stop;
	XDeath:
		FRPF ABCDEF 1;
		Stop;
	}
}

class FreezerTrailSparksSmall : Actor
{
	Default
	{
		RenderStyle "Add";
		Scale 0.008;
		Alpha 0.95;
		+NOINTERACTION;
		+NOGRAVITY;
		+CLIENTSIDEONLY;
	}

	States
	{
	Spawn:
		YA36 B 0 NoDelay A_JumpIf(Scale.X <= 0, "NULL");
		YA36 B 0 A_SetScale(Scale.X - 0.00075);
		YA36 B 3 Bright A_ChangeVelocity(frandom(-0.8, 0.8), frandom(-0.8, 0.8), frandom(-0.8, 0.8), 0);
		YA36 B 1 Bright A_FadeOut(0.05);
		Loop;
	}
}
