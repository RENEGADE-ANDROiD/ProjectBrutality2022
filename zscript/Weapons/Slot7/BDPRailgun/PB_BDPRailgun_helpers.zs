// PB_BDPRailgun support actors — folded from PBX-Weapons Slot-7/BDP_RAILGUN.

class BDPRailgunAmmo : Ammo
{
	Default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount BDPRailgunFullAmmo;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount BDPRailgunFullAmmo;
		Inventory.Icon "XBDRA0";
		+INVENTORY.IGNORESKILL;
	}
}

class BDP_GunLight : DynamicLight
{
	Default
	{
		DynamicLight.Type "Point";
		+DYNAMICLIGHT.ATTENUATE;
		+DYNAMICLIGHT.SPOT;
	}

	int alivetime;
	property alivetime : alivetime;

	override void Tick()
	{
		Super.Tick();
		alivetime--;
		if (alivetime <= 0)
			Destroy();
	}
}

class BluePlasmaParticleWeapon : Actor
{
	Default
	{
		Height 0;
		Radius 0;
		Mass 0;
		+Missile;
		+NoBlockMap;
		-NoGravity;
		+DontSplash;
		+DoomBounce;
		+FORCEXYBILLBOARD;
		RenderStyle "Add";
		BounceFactor 0.2;
		Gravity 0.8;
		Scale 0.02;
		Speed 9;
	}

	States
	{
	Spawn:
	Death:
		SPKB A 2 Bright A_FadeOut(0.04);
		Loop;
	}
}

class RailCaseSpawn : Actor
{
	Default
	{
		Speed 20;
		PROJECTILE;
		+NOCLIP;
		+CLIENTSIDEONLY;
	}

	States
	{
	Spawn:
		TNT1 A 0;
		TNT1 A 1 A_CustomMissile("RailCasing", -9, 20, random(-38, -48), 2, random(10, 20));
		Stop;
	}
}

class RailCasing : Actor
{
	Default
	{
		Speed 7;
		BounceFactor 0.7;
		Scale 0.3;
		+ROLLSPRITE;
		+ROLLCENTER;
	}

	States
	{
	Spawn:
		ECLI H 4;
	Spawn2:
		ECLI HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH 4 A_SetRoll(roll - 45);
		Loop;

	Death:
		"####" "#" 0;
		"####" "#" 0 A_Jump(128, "Die2");
		"####" "#" 0 A_SetRoll(-90);
		"####" "#" 0;
	StayDead:
		"####" "#" 350;
		Stop;

	Die2:
		"####" "#" 0 A_SetRoll(90);
		"####" "#" 0 A_ChangeFlag("XFLIP", 1);
		Goto StayDead;
	}
}

class RailgunTrail : VisualThinker
{
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		texture = TexMan.CheckForTexture('RAILA0');
		scale = (0.3, 0.3);
		alpha = 1.0;
		flags = SPF_FULLBRIGHT;
		SetRenderStyle(STYLE_Add);
	}

	override void Tick()
	{
		scale -= (0.01, 0.01);
		Super.Tick();
		if (scale.x <= 0)
			Destroy();
	}
}

class RailgunRail : Actor
{
	Default
	{
		Radius 1;
		Height 1;
		+nogravity;
		+noclip;
	}

	States
	{
	Spawn:
		TNT1 AAA 0 A_SpawnItemEX("WhiteShockwave");
		TNT1 AAAA 0 A_spawnprojectile("FireworkSFXType2", 2, 0, random(0, 360), 2, random(-10, -80));
		RAIL A 0 A_SpawnItemEx("DetectFloorCrater", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
		RAIL A 0 A_SpawnItemEx("DetectCeilCrater", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
		TNT1 AAAAAAAAAA 0 A_spawnprojectile("ExplosionParticleVeryFast", 0, 0, random(0, 360), 2, random(0, 360));
		TNT1 AAAAAAAA 0 A_spawnprojectile("ExplosionParticleHeavy", 5, 0, random(0, 360), 2, random(0, -180));
		TNT1 AAAAAAAAAA 0 A_spawnprojectile("ExplosionParticleHeavy", 5, 0, random(0, 360), 2, random(0, 360));
		TNT1 AAAAAAAAA 0 A_spawnprojectile("ExplosionParticleVeryFast", 5, 0, random(0, 360), 2, random(0, 360));
		RAIL A 1 BRIGHT {
			Radius_Quake(3, 8, 0, 15, 0);
			A_startsound("BONECRACK", 1);
			A_startsound("RICMET", 2);
			A_spraydecal("PLASMAScorch", 36);
			Actor core = spawn("RailgunRail2", pos);
			core.angle = angle;
			core.pitch = pitch;
		}
		RAIL A 35 BRIGHT;
	TimeToFade:
		RAIL A 1 BRIGHT {
			A_fadeout(0.01);
		}
		Loop;
	}
}

class RailgunRail2 : Actor
{
	Default
	{
		Radius 1;
		Height 1;
		+nogravity;
		+noclip;
	}

	States
	{
	Spawn:
		RAIL A 225 NODELAY;
	Death:
		TNT1 AAAAAAAA 0 {
			A_startsound("BONECRACK", 1);
		}
		Stop;
	}
}

class RailgunProjectile : Actor
{
	int user_railangle;

	Default
	{
		Radius 2;
		Height 2;
		Speed 80;
		DamageFactor 0;
		DamageType 'Railgun';
		Projectile;
		+RANDOMIZE;
		+MISSILE;
		+FORCERADIUSDMG;
		+THRUACTORS;
		Species "Marines";
		Renderstyle 'ADD';
		alpha 0.90;
		Scale 0.10;
		DeathSound "weapons/plasmax";
		SeeSound "None";
		Obituary "%o was railed by %k.";
		BounceCount 3;
	}

	States
	{
	Spawn:
		TNT1 A 0;
		RAIL A 0 A_FaceTarget;
		RAIL A 0 { user_railangle = angle; }
		RAIL A 0 A_SpawnItem("WhiteShockwave");
		TNT1 C 1 BRIGHT A_SpawnItem("WhiteShockwave");
	Spawn1:
		TNT1 C 1 BRIGHT A_SpawnItem("WhiteShockwave");
		RAIL A 0 A_SpawnItem("WhiteShockwave");
		RAIL A 0 A_CheckFloor("Death");
		RAIL A 0 A_CustomMissile("OldschoolRocketSmokeTrail2", 2, 0, random(160, 210), 2, random(-30, 30));
		Loop;
	Death:
	Melee:
	XDeath:
		TNT1 AAAA 0 A_SpawnItemEx("BluePlasmaParticleSpawner", 0, 0, 0, 0, 0, 0, 0, 128);
		TNT1 AA 0 A_SpawnItem("WhiteShockwave");
		TNT1 AAAAAAAAA 0 A_CustomMissile("ExplosionParticleHeavy", 0, 0, random(0, 360), 2, random(0, 180));
		TNT1 AAAAAAAAAAAAAAAAAA 0 A_CustomMissile("ExplosionParticleHeavy", 0, 0, random(0, 360), 2, random(0, 360));
		TNT1 AAAAAAAAA 0 A_CustomMissile("ExplosionParticleVeryFast", 0, 0, random(0, 360), 2, random(0, 360));
		EXPL AAAAA 0 A_CustomMissile("ExplosionSmokeFast22", 0, 0, random(0, 360), 2, random(0, 360));
		TNT1 AAAA 0 A_CustomMissile("FireworkSFXType2", 2, 0, random(0, 360), 2, random(10, 80));
		RAIL A 0 A_SpawnItemEx("DetectFloorCraterSmall", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
		RAIL A 0 A_SpawnItemEx("DetectCeilCraterSmall", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
		RAIL A 0 A_CustomMissile("BluePlasmaFire", 0, 0, random(0, 360), 2, random(0, 360));
		TNT1 AAAAA 0 A_CustomMissile("BluePlasmaParticle", 0, 0, random(0, 360), 2, random(0, 360));
		TNT1 ABE 0 BRIGHT A_SpawnItem("BlueFlare", 0);
		Stop;
	}
}
