// Excavator — projectiles & ammo (folded from PBX-Weapons Excavator_helpers; ExcavatorExplosion actor is DECORATE in EXPLOSIVES.dec)
const excavatorFullMag = 5;

class ExcavatorRounds : Ammo
{
	default
	{
		inventory.maxamount excavatorFullMag;
		ammo.backpackamount 0;
		ammo.backpackmaxamount excavatorFullMag;
		+INVENTORY.IGNORESKILL
		Inventory.Icon "5DUNA0";
	}
}

class DiggerTrail : Actor
{
	default
	{
		Scale 1.1;
		+noteleport
		+NOINTERACTION
		+DOOMBOUNCE
		+RANDOMIZE
		height 1;
		radius 1;
	}
	states
	{
		Spawn:
			TNT1 A 0 A_SetScale(Scale.X*frandom(0.85,1.35), Scale.Y*frandom(0.9,1.25));
			SPIK ABBCCBBA 2;
			SPIK A 60;
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			SPIK A 1 A_FadeOut(0.02);
			Stop;
	}
}

class ExcavatorExplode : Actor
{
	default
	{
		Projectile;
		Scale 1.15;
		DamageType "ExplosiveImpact";
		+THRUSPECIES
		+MTHRUSPECIES
		Species "Marines";
	}
	states
	{
		Death:
			TNT1 A 0 A_SpawnItemEx("DetectFloorCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_SpawnItemEx("DetectCeilCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_SpawnItemEx("ExplosionFlareSpawner",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_SpawnItemEx("NewGroundExplosionSmoke",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 AAAA 0 A_CustomMissile("FireworkSFXType2", 0, 0, random(0, 360), 2, random(30, 60));
			TNT1 A 0 A_CustomMissile("ExcavatorExploFX", random(1,5), random(-10,10), random(0, 360), 2, random(0, 360));
			TNT1 A 0 A_SpawnItemEx("LiquidExplosionEffectSpawner",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_Playsound("excavator/explode", 1);
			TNT1 A 0 A_PlaySound("FAREXPL", 3);
			Stop;
	}
}

class DropShotExplode : ExcavatorExplode
{
	default
	{
		Radius 20;
		Height 10;
		Speed 25;
		Damagetype "ExplosiveImpact";
		+MISSILE
		+Ripper
		+NOBOSSRIP
		+SKYEXPLODE
		Damage 20;
	}
	states
	{
		Spawn:
			TNT1 A 0 NODELAY A_ChangeFlag("Thruactors", 1);
			5DKP A 2 A_SpawnItem("YellowFlareSmall",-2,0);
			5DKP B 4 A_Playsound("Weapons/StickyBombTick", 3);
			5DKP C 2 A_SpawnItem("YellowFlareSmall",-2,0);
			5DKP D 4;
			TNT1 A 0 A_ChangeFlag("Thruactors", 0);
			TNT1 A 0 A_SpawnItem("YellowFlareSmall",-2,0);
		Fall:
			5DKP D 1 A_CheckFloor("Boom");
			TNT1 A 0 ThrustThingZ(0, 30, 1, 1);
			Loop;
		Boom:
		Death:
			TNT1 A 0 A_Playsound("superbaron/spike");
			TNT1 AAAAA 0 {A_CustomMissile("MudDust", 0, 0, random(0, 360), 2, random(30, 150));A_CustomMissile("DirtChunk1", 0, 0, random(0, 360), 2, random(30, 150));A_CustomMissile("DirtChunk2", 10, 0, random(0, 360), 2, random(30, 150));A_CustomMissile("BrownCloud", 0, 0, random(0, 90), 2, random(30, 150));}
			XXXX A 0 A_CustomMissile("ExplosionQuake", 1, 0, random(0, 360), 2, random(0, 160));
			TNT1 A 0 {
				A_SpawnItemEx("DiggerTrail",random(-3, 0),random(-3, -1),0,0,0,0,0,SXF_NOCHECKPOSITION,0);
				A_SpawnItemEx("DiggerTrail",random(0, 3),random(1, 3),0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			}
			5DKP DDDDDDDDDDDDDD 1 A_CustomMissile("HeavyExplosionSmoke", 2, 0, random(0, 360), 2, random(0, 360));
			EXPL A 0 Radius_Quake(3, 24, 0, 15, 0);
			TNT1 AAAAAAAAA 0 {
				A_CustomMissile("ExplosionParticleHeavy", 0, 0, random(0, 360), 2, random(0, 180));
				A_CustomMissile("ExplosionParticleVeryFast", 0, 0, random(0, 360), 2, random(0, 360));
			}
			TNT1 AAAAA 0 {
				A_CustomMissile("MediumExplosionFlames", 0, 0, random(0, 360), 2, random(0, 360));
				A_CustomMissile("ExplosionSmokeFast22", 0, 0, random(0, 360), 2, random(0, 360));
			}
			TNT1 A 0 A_SpawnItemEx("ExcavatorExplosion",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			goto Super::Death;
	}
}
class DrillBombExplode : ExcavatorExplode
{
	default
	{
		SeeSound "superbaron/spike";
		Radius 2;
		Height 1;
		Speed 0;
		+NOCLIP
		+Thruactors
	}
	states
	{
		Spawn:
		Death:
			TNT1 AAAAA 0 NODELAY {
				A_CustomMissile("MudDust", 0, 0, random(0, 360), 2, random(30, 150));
				A_CustomMissile("DirtChunk1", 0, 0, random(0, 360), 2, random(30, 150));
				A_CustomMissile("DirtChunk2", 10, 0, random(0, 360), 2, random(30, 150));
				A_CustomMissile("BrownCloud", 0, 0, random(0, 90), 2, random(30, 150));
			}
			XXXX A 0 A_CustomMissile("ExplosionQuake", 1, 0, random(0, 360), 2, random(0, 160));
			TNT1 A 0 A_Explode(15, 32, 0, 12);
			5DKP EFGHIJIKLMNOONNML 1 BRIGHT ;
			EXPL A 0 Radius_Quake(3, 8, 0, 15, 0);
			TNT1 AAAAAAAAA 0 {
				A_CustomMissile("ExplosionParticleHeavy", 12, 0, random(0, 360), 2, random(0, 180));
				A_CustomMissile("ExplosionParticleVeryFast", 12, 0, random(0, 360), 2, random(0, 360));
			}
			TNT1 AAAAA 0 {
				A_CustomMissile("MediumExplosionFlames", 12, 0, random(0, 360), 2, random(0, 360));
				A_CustomMissile("ExplosionSmokeFast22", 12, 0, random(0, 360), 2, random(0, 360));
			}
			TNT1 A 0 A_SpawnItemEx("ExcavatorExplosion",0,0,12,0,0,0,0,SXF_NOCHECKPOSITION,0);
			goto Super::Death;
	}
}
class ExcavatorDrillBomb : Actor
{
	default
	{
		Radius 8;
		Height 4;
		Speed 12;
		Damage 1;
		DamageType "ExplosiveImpact";
		+Ripper
		+FloorHugger
		+BloodlessImpact
		+THRUSPECIES
		+MTHRUSPECIES
		Species "Marines";
		Projectile;
		Missileheight 0;
	}

	override void Tick()
	{
		if (target && target.CountInv("GrenadeDetonator"))
		{
			A_StopSound(5);
			A_SpawnItemEx("DrillBombExplode",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			Destroy();
		}
		Super.Tick();
	}
	override int SpecialMissileHit(Actor victim)
	{
		if (victim && victim is "PB_Monster")
		{
			self.SetStateLabel("Death");
		}
		return Super.SpecialMissileHit(victim);
	}

	states
	{
		Spawn:
			TNT1 A 1 NODELAY A_StartSound("excavator/digloop", 5, CHANF_LOOPING,1.0,0.5);
		Travel:
			TNT1 A 3 ;
			TNT1 A 0 {
				A_SpawnItemEx("DiggerTrail",random(-2, 2),random(-1, 1),0,0,0,0,0,SXF_NOCHECKPOSITION,0);
				A_CustomMissile("MudDust", 0, 0, random(0, 360), 2, random(30, 150));
				Radius_Quake(2, 8, 0, 8, 0);
			}
			TNT1 AA 0 {
				A_CustomMissile("DirtChunk1", 0, 0, random(0, 360), 2, random(30, 150));
				A_CustomMissile("DirtChunk2", 0, 0, random(0, 360), 2, random(30, 150));
			}
			Loop;
		Death:
			TNT1 A 0 {
				A_StopSound(5);
				A_SpawnItemEx("DrillBombExplode",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			}
			Stop;
	}
}
class ExcavatorDrill : PB_Projectile
{
	default
	{
		+MISSILE
		+SOLID
		+BOUNCEONWALLS
		+BOUNCEONFLOORS
		+BOUNCEONCEILINGS
		+CANBOUNCEWATER
		+MOVEWITHSECTOR
		+USEBOUNCESTATE
		+DONTSPLASH
		+SKYEXPLODE
		+THRUSPECIES
		+MTHRUSPECIES
		Species "Marines";
		Scale 1.15;
		Speed 25;
		Radius 6;
		Height 6;
		Gravity 1.25;
		DamageType "ExplosiveImpact";
		Decal "Scorch";
	}

	states
	{
		Spawn:
			TNT1 A 0 NODELAY A_CheckFloor("Dig");
			5DKP A 2 BRIGHT A_SpawnItem("RocketSmokeTrail52");
			TNT1 A 0 A_SpawnItem("RocketFlare",-2,0);
			TNT1 A 0 ThrustThingZ(0, 20, 1, 1);
			Loop;
		Dig:
		Bounce.Floor:
		XDeath:
		Death:
			TNT1 A 0 ;
			TNT1 A 0 A_Playsound("excavator/digging");
			TNT1 A 0 A_CustomMissile("ExcavatorDrillBomb", 1, 0, 180);
			Stop;
		Crash:
		Bounce.Ceiling:
		Bounce.Walls:
			TNT1 A 0 A_StopSound(6);
			EXPL A 0 Radius_Quake(3, 24, 0, 15, 0);
			TNT1 A 0 A_SpawnItemEx("DetectFloorCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_SpawnItemEx("DetectCeilCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_SpawnItemEx("ExplosionFlareSpawner",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_SpawnItemEx("NewGroundExplosionSmoke",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 AAAAAAAAA 0 {
				A_CustomMissile("ExplosionParticleHeavy", 0, 0, random(0, 360), 2, random(0, 180));
				A_CustomMissile("ExplosionParticleVeryFast", 0, 0, random(0, 360), 2, random(0, 360));
			}
			TNT1 AAAAA 0 {
				A_CustomMissile("MediumExplosionFlames", 0, 0, random(0, 360), 2, random(0, 360));
				A_CustomMissile("ExplosionSmokeFast22", 0, 0, random(0, 360), 2, random(0, 360));
			}
			TNT1 A 0 A_CustomMissile("ExcavatorExploFX", random(1,5), random(-10,10), random(0, 360), 2, random(0, 360));
			TNT1 A 0 A_SpawnItemEx("ExcavatorExplosion",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_SpawnItemEx("LiquidExplosionEffectSpawner",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_Playsound("excavator/explode", 1);
			TNT1 A 0 A_PlaySound("FAREXPL", 3);
			Stop;
	}
}
class ExcavatorDropShot : PB_Projectile
{
	default
	{
		Projectile;
		+MISSILE
		+NOGRAVITY
		+MOVEWITHSECTOR
		+EXPLODEONWATER
		+USEBOUNCESTATE
		+DONTSPLASH
		+SKYEXPLODE
		+THRUSPECIES
		+MTHRUSPECIES
		Species "Marines";
		Speed 35;
		Radius 6;
		Height 6;
		Scale 1.15;
		DamageType "ExplosiveImpact";
		Decal "Scorch";
	}
	override void Tick()
	{
		if (target && target.CountInv("GrenadeDetonator")){A_StopSound(5);A_SpawnItemEx("DropShotExplode",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);Destroy();}
		Super.Tick();
	}
	states
	{
		Spawn:
			TNT1 A 1 NODELAY A_StartSound("excavator/digloop", 5, CHANF_LOOPING,1.0,0.5);
		Travel:
			5DKP A 2 BRIGHT A_SpawnItem("RocketSmokeTrail52");
			TNT1 A 0 A_SpawnItem("GreenFlareSmall",-2,0);
			TNT1 A 0 A_CustomMissile("ShotgunParticles", 0, 0, random(0, 360), 2, random(30, 150));
			5DKP A 2 BRIGHT A_SpawnItem("RocketSmokeTrail52");
			Loop;
		XDeath:
		Death:
		Crash:
		Bounce.Ceiling:
		Bounce.Walls:
		Bounce.Floor:
			TNT1 A 0 A_SpawnItemEx("DropShotExplode",0,0,-5,0,0,0,0,SXF_NOCHECKPOSITION,0);
			Stop;
	}
}

class EX_Select_DropMode : Inventory
{
	default
	{
		inventory.maxamount 1;
	}
}

class EX_Select_DrillMode : Inventory
{
	default
	{
		inventory.maxamount 1;
	}
}
