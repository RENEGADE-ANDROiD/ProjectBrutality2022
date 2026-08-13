class PB_ThrownChainsaw : Actor
{
	Vector3 stickOfs;
	double stickAngle;
	int sawtimer;
	bool wantFall;

	Default
	{
		Radius 10;
		Height 4;
		Speed 45;
		Scale 0.8;
		Damage 0;
		DamageType "Saw";
		+MISSILE;
		+FORCEXYBILLBOARD;
		-NOGRAVITY;
		+THRUSPECIES;
		+BLOODSPLATTER;
		Species "Marines";
		+MTHRUSPECIES;
		+SKYEXPLODE;
		Gravity 0.9;
		Obituary "%o was cut up by a Chainsaw";
		Decal "SawVertical";
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		sawtimer = 0;
		wantFall = false;
	}

	override int SpecialMissileHit(Actor victim)
	{
		if (!victim)
			return 0;
		if (victim == target || victim.player)
			return -1;

		if (victim.bShootable && victim.health > 0 && !victim.bInvulnerable)
		{
			tracer = victim;
			stickOfs = victim.Vec3To(self);
			stickAngle = tracer.angle;
			return 1;
		}

		wantFall = true;
		return 1;
	}

	void DropWorldSaw(bool wallStuck)
	{
		A_StopSound(4);
		A_AlertMonsters(200);
		if (target && target.FindInventory("PowerInfiniteAmmo"))
			return;

		Actor thrown = Spawn("PB_Chainsaw", pos);
		if (!thrown)
			return;
		thrown.SetStateLabel("SpawnThrown");
		thrown.angle = angle;
		if (wallStuck)
			thrown.bNoGravity = true;
		let weap = Weapon(thrown);
		if (weap)
			weap.AmmoGive1 = 0;
	}

	void StickFollow()
	{
		if (!tracer || tracer.health < 1 || sawtimer > 150)
		{
			if (tracer && !tracer.bNoBlood)
				A_StartSound("misc/gibbed", 24);
			SetStateLabel("Fall");
			return;
		}
		sawtimer++;
		if (tracer && tracer.health > 0)
		{
			double angDiff = DeltaAngle(stickAngle, tracer.angle);
			if (angDiff)
			{
				stickOfs.xy = RotateVector(stickOfs.xy, angDiff);
				angle += angDiff;
			}
			SetOrigin(tracer.Vec3Offset(stickOfs.x, stickOfs.y, stickOfs.z), true);
			stickAngle = tracer.angle;
		}
	}

	void SawBite()
	{
		A_StartSound("weapons/chainsaw/loop", 4);
		if (!tracer || tracer.health < 1)
			return;
		tracer.DamageMobj(self, target, 8, 'Saw');
		if (tracer.health < 1)
			return;
		State painSaw = tracer.FindState("Pain.Saw");
		if (painSaw)
			tracer.SetState(painSaw);
		else
		{
			State pain = tracer.FindState("Pain");
			if (pain)
				tracer.SetState(pain);
		}
	}

	States
	{
	Spawn:
		CSAW B 4 A_AlertMonsters(200);
		SAWG A 0 A_StartSound("weapons/chainsaw/loop", 4);
		Loop;

	Death:
	XDeath:
		TNT1 A 0
		{
			vel = (0, 0, 0);
			bMissile = false;
			if (wantFall)
			{
				SetStateLabel("Fall");
				return;
			}
			if (!tracer)
				SetStateLabel("Explode");
		}
	Stuck:
		CSAW BBBB 1 StickFollow();
		SAWG A 0 SawBite();
		Loop;

	Explode:
		TNT1 A 0 A_CheckCeiling("Fall");
		AXEG A 0 A_SpawnItemEx("Sparks");
		AXEG A 0 A_StartSound("AXECLN", 6);
		TNT1 A 0 DropWorldSaw(true);
		Stop;

	Fall:
		TNT1 A 0 DropWorldSaw(false);
		Stop;
	}
}
