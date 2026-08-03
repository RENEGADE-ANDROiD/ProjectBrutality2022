Class EternalSoul : Actor 
{
	int attackloop;
	
	Default
	{
		Health 65;
		Radius 16;
		Height 32;
		Mass 50;
		Speed 12;
		DeathHeight 4;
		Damage 15;
		Monster;
		+NOBLOOD;
		renderstyle "Normal";
		PainChance 255;
		PainChance "Kick", 255;
		damagefactor "GibRemoving", 0.0;
		PainChance "Avoid", 255;
		PainChance "Stun", 255;
		PainChance "Siphon", 255;
		damagefactor "Fatality", 5.0;
		damagefactor "TeleportRemover", 0.0;
		damagefactor "Shrapnel", 0.4;
		DamageFactor "CauseObjectsToSplash", 0.0;
		damagefactor "killme", 0.0;
		+FLOAT;
		+NOGRAVITY; 
		+DONTFALL; 
		+NOICEDEATH;
		+FORCEXYBILLBOARD;
		AttackSound "EternalSoul/melee";
		PainSound "skull/pain";
		DeathSound "EternalSoul/Death";
		ActiveSound "EternalSoul/idlescream";
		Obituary "$OB_SKULL";
		BloodType "LostSoulBlood";
		Tag "Eternal Soul";
		Scale .4;
		Alpha 1;
	}
	States
	{
	Pain.Avoid: 
	  TNT1 A 0;
	  TNT1 A 0 A_Jump(255, "AvoidLeft", "AvoidRight");
	  Goto AvoidLeft;
	  AvoidLeft:
	    LOST B 1 A_FaceTarget();
	    TNT1 A 0 ThrustThing(angle*256/360+192, 15, 0, 0);
        LOST B 5 A_FaceTarget();
        Goto Missile;
	AvoidRight:
	    LOST B 1 A_FaceTarget();
	    TNT1 A 0 ThrustThing(angle*256/360+64, 15, 0, 0);
        LOST B 5 A_FaceTarget();
        Goto Missile;
		
	Spawn:
		LOST A 0;
		TNT1 A 0 A_CheckSight("Spawn2");
		LOST A 2 BRIGHT A_Look;
		TNT1 A 0 A_SpawnItem ("RedFlareMedium", 0, 24);
		LOST AA 0 A_CustomMissile ("SoulTrails", 24, 0, random (0, 360), 2, random (0, 160));
		Loop;
		
    Spawn2:
		LOST AAAAAAAA 10 A_Look;
		TNT1 A 0 A_CheckSight("Spawn2");
		Goto Spawn;
	See:
	    TNT1 A 0;
		TNT1 A 0 A_TakeInventory("MaxLostSoulRange", 30);
		LOST A 2 BRIGHT A_Chase();
		TNT1 A 0 A_JumpIfCloser(160, "Retreat");
		TNT1 A 0 A_ChangeFlag("NOPAIN", 0);
		LOST A 2 BRIGHT A_Chase();
		TNT1 A 0 A_JumpIfCloser(160, "Retreat");
	    TNT1 A 0 A_SpawnItem ("RedFlareMedium", 0, 24);
        LOST A 0 A_CustomMissile ("SoulTrails", 24, 0, random (0, 360), 2, random (0, 160));
		Loop;
	Retreat:
		LOST A 1 A_FaceTarget();
		TNT1 A 0 A_Recoil(3);
	    TNT1 A 0 A_SpawnItem ("RedFlareMedium", 0, 24);
        LOST A 0 A_CustomMissile ("SoulTrails", 24, 0, random (0, 360), 2, random (0, 160));
	    Goto See;
		
	Missile:
		SKUL A 0 BRIGHT A_SpawnItem ("RedFlare", 0, 24);
		TNT1 A 0 A_ChangeFlag("NOPAIN", 1);
		LOST B 3 BRIGHT A_FaceTarget();
		SKUL A 0 BRIGHT A_SpawnItem ("RedFlare", 0, 24);
		LOST B 0 BRIGHT A_SkullAttack;
		TNT1 A 0 A_Jump(100, "Flamethrower");
        TNT1 A 0 A_CustomMissile ("SoulTrails", 24, 0, random (0, 360), 2, random (0, 160));
		LOST BB 2 BRIGHT A_SpawnItem ("RedFlareMEdium", 0, 24);
        TNT1 A 0 A_CustomMissile ("SoulTrails", 24, 0, random (0, 360), 2, random (0, 160));
		LOST BB 2 BRIGHT A_SpawnItem ("RedFlareMEdium", 0, 24);
		TNT1 A 0 A_JumpIfInventory("MaxLostSoulRange", 10, "See");
		TNT1 A 0 A_giveInventory("MaxLostSoulRange", 1);
		Goto Missile+6;
	
	Flamethrower:
	LOST B 10 Bright A_FaceTarget();
	TNT1 A 0 A_StartSound("Flamethrower/Attack",1);
	FlamethrowerLoop:
	LOST B 2 Bright Light("ZOMBIEATK")
		{
		A_FaceTarget();
		attackloop++;
		A_CustomMissile("SentryFlame", 12, 0, 0, 0);
		//A_SpawnProjectile("SentryFlame",34,9,frandom(-6,6),CMF_OFFSETPITCH,frandom(-1,1));
		}
	Wait;
	
	Pain:
        TNT1 AAA 0 A_CustomMissile ("SoulTrails", 12, 0, random (0, 360), 2, random (0, 160));
		LOST A 3 BRIGHT;
        TNT1 A 0 A_Jump (128, 3);
        Goto Avoid;
        TNT1 AAA 0;
        TNT1 AAA 0 A_CustomMissile ("SoulTrails", 12, 0, random (0, 360), 2, random (0, 160));
		LOST A 1 BRIGHT A_Pain;
		Goto See;

	Avoid:
        NULL A 0 A_FaceTarget(); 
        LOST B 6 A_FastChase;
        LOST AA 0 A_CustomMissile ("SoulTrails", 24, 0, random (0, 360), 2, random (0, 160));
		SKUL A 0 BRIGHT A_SpawnItem ("RedFlareMedium", 0, 24);
        NULL A 0 A_FaceTarget();
        LOST B 6 BRIGHT A_FastChase;
        LOST AA 0 A_CustomMissile ("SoulTrails", 24, 0, random (0, 360), 2, random (0, 160));
		SKUL A 0 BRIGHT A_SpawnItem ("RedFlareMedium", 0, 24);
        NULL A 0 A_FaceTarget();
        LOST B 6 BRIGHT A_FastChase;
        LOST AA 0 A_CustomMissile ("SoulTrails", 24, 0, random (0, 360), 2, random (0, 160));
		SKUL A 0 BRIGHT A_SpawnItem ("RedFlareMedium", 0, 24);
        NULL A 0 A_FaceTarget();
         LOST B 6 BRIGHT A_FastChase;
       LOST AA 0 A_CustomMissile ("SoulTrails", 24, 0, random (0, 360), 2, random (0, 160));
		SKUL A 0 BRIGHT A_SpawnItem ("RedFlareMedium", 0, 24);
		Goto Missile;

    //Death.Fatality:
	Death.PussyGrab:
	    TNT1 A 0 A_Pain;
	    TNT1 A 0 A_JumpIfIntargetInventory("FistsSelected", 1, 1);
		Goto Death;
        TNT1 A 0 A_GiveToTarget("LostSoulFatality", 1);
        TNT1 A 1;
        TNT1 A 0;
		Stop;
	Death:
		LSOL F 4 BRIGHT A_NoBlocking;
		TNT1 AAAA 0 A_CustomMissile ("SmallLSPart1", 0, 0, random (0, 360), 2, random (0, 360));
		TNT1 AAAA 0 A_CustomMissile ("SmallLSPart3", 0, 0, random (0, 360), 2, random (0, 360));
        TNT1 AAA 0 A_CustomMissile ("CoolAndNewFlameTrailsLong", 12, 0, random (0, 360), 2, random (0, 160));
		LSOL G 0 BRIGHT A_Scream;
	    EXPL AA 0 A_SpawnItem("ExplosionParticleSpawner");
	    TNT1 A 0 A_SpawnItemEx ("ExplosionFlareSpawner",0,0,32,0,0,0,0,SXF_NOCHECKPOSITION,0);
	    EXPL AAAAA 0 A_CustomMissile ("FireBallExplosionFlamesMedium", 32, 0, random (0, 360), 2, random (0, 360));
		TNT1 AAAA 0 A_CustomMissile ("PlasmaSmoke", 32, 0, random (0, 360), 2, random (0, 360));
       TNT1 AAA 0 A_CustomMissile ("LSpart1", 42, 0, random (0, 360), 2, random (0, 160));
       TNT1 A 0 A_CustomMissile ("LSpart3", 42, 0, random (0, 360), 2, random (0, 160));
       TNT1 AA 0 A_CustomMissile ("LSpart2", 42, 0, random (0, 360), 2, random (0, 160));
		TNT1 A 0;
        LSOL HI 0;
		Stop;

    Pain.KillMe:
    Pain.Taunt:
        TNT1 A 0;
		TNT1 A 0 HealThing(1);
        Goto Missile;
    Death.KillMe:
    Death.Taunt:
	    TNT1 A 0 A_ChangeFlag("SOLID", 0);
        TNT1 A 0 A_SpawnItem("LostSoul");
        Stop;
	}
}
// MaxLostSoulRange lives in actors/Items/Compat/WarningStubs.dec — do not redefine here.