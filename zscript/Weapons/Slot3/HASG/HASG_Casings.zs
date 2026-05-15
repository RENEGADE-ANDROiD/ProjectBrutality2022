// Lady Golide drum ejecta — PB Weapons Pack `HASGCasings.zc` (CAS8 / WCS1 / DC0S).
// Sprites: `SPRITES/WEAPONS/Slot3/HASG/Casings/ShotgunShell/`. Rest6 uses `Rest6Dead` (pack typo: duplicate `Rest2Dead`).

class ShotgunCasing5HASG : Actor
{
	override void BeginPlay()
	{
		ChangeStatNum(STAT_PB_BULLETS);
		NashGoreStatics.QueueCasings();
		Super.BeginPlay();
	}

	Default
	{
		Height 12;
		Radius 9;
		Speed 6;
		Scale 0.15;
		BounceType "Doom";
		-NOGRAVITY;
		+WINDTHRUST;
		+CLIENTSIDEONLY;
		+MOVEWITHSECTOR;
		+MISSILE;
		+NOBLOCKMAP;
		-DROPOFF;
		+NOTELEPORT;
		+FORCEXYBILLBOARD;
		+NOTDMATCH;
		+GHOST;
		+ROLLSPRITE;
		Mass 1;
		SeeSound "weapons/shell";
	}

	States
	{
	Spawn:
		TNT1 A 0;
	Exist:
		TNT1 A 0 A_JumpIfInventory("Zoomed", 1, "ShellSpin");
		TNT1 A 0 A_SetRoll(roll + (20), SPF_INTERPOLATE);
		CAS8 G 1;
	ShellSpin:
		CAS8 G 1
		{
			A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
		}
		TNT1 A 0 A_SetRoll(roll - (10), SPF_INTERPOLATE);
		TNT1 A 0 A_JumpIf(waterlevel > 1, "Disappear");
		Goto ShellSpin;
	Death:
		TNT1 A 0 A_SetRoll(0, SPF_INTERPOLATE);
		LCPJ A 0 A_Jump(256, "Rest1", "Rest2", "Rest3", "Rest4", "Rest5", "Rest6", "Rest7", "Rest8");
		Goto Rest1;
	Rest1:
		CAS8 IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII 2 A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
	Rest1Dead:
		CAS8 I 900;
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("ToggleBulletJanitor") == 1, "Disappear");
		Loop;
	Rest2:
		CAS8 JJJJJJJJJJJJJJJJJJJJJJJJJJJ 2 A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
	Rest2Dead:
		CAS8 J 900;
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("ToggleBulletJanitor") == 1, "Disappear");
		Loop;
	Rest3:
		CAS8 KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK 2 A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
	Rest3Dead:
		CAS8 K 900;
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("ToggleBulletJanitor") == 1, "Disappear");
		Loop;
	Rest4:
		CAS8 LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL 2 A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
	Rest4Dead:
		CAS8 L 900;
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("ToggleBulletJanitor") == 1, "Disappear");
		Loop;
	Rest5:
		CAS8 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM 2 A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
	Rest5Dead:
		CAS8 M 900;
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("ToggleBulletJanitor") == 1, "Disappear");
		Loop;
	Rest6:
		CAS8 IIIIIIIIIIIIIIIIIIIIIIIIIII 2 A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
	Rest6Dead:
		CAS8 I 900;
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("ToggleBulletJanitor") == 1, "Disappear");
		Loop;
	Rest7:
		CAS8 JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ 2 A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
	Rest7Dead:
		CAS8 J 900;
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("ToggleBulletJanitor") == 1, "Disappear");
		Loop;
	Rest8:
		CAS8 KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK 2 A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
	Rest8Dead:
		CAS8 K 900;
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("ToggleBulletJanitor") == 1, "Disappear");
		Loop;
	Disappear:
		TNT1 A 1;
		Stop;
	}
}

class ExplosiveCasingHASG : Actor
{
	override void BeginPlay()
	{
		ChangeStatNum(STAT_PB_BULLETS);
		NashGoreStatics.QueueCasings();
		Super.BeginPlay();
	}

	Default
	{
		Height 12;
		Radius 9;
		Speed 6;
		Scale 0.15;
		BounceType "Doom";
		-NOGRAVITY;
		+WINDTHRUST;
		+CLIENTSIDEONLY;
		+MOVEWITHSECTOR;
		+MISSILE;
		+NOBLOCKMAP;
		-DROPOFF;
		+NOTELEPORT;
		+FORCEXYBILLBOARD;
		+NOTDMATCH;
		+GHOST;
		+ROLLSPRITE;
		Mass 1;
		SeeSound "weapons/shell";
	}

	States
	{
	Spawn:
		TNT1 A 0;
	Exist:
		TNT1 A 0 A_JumpIfInventory("Zoomed", 1, "ShellSpin");
		TNT1 A 0 A_SetRoll(roll + (20), SPF_INTERPOLATE);
		WCS1 G 1;
	ShellSpin:
		WCS1 G 1
		{
			A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
		}
		TNT1 A 0 A_SetRoll(roll - (10), SPF_INTERPOLATE);
		TNT1 A 0 A_JumpIf(waterlevel > 1, "Disappear");
		Goto ShellSpin;
	Death:
		TNT1 A 0 A_SetRoll(0, SPF_INTERPOLATE);
		LCPJ A 0 A_Jump(256, "Rest1", "Rest2", "Rest3", "Rest4", "Rest5", "Rest6", "Rest7", "Rest8");
		Goto Rest1;
	Rest1:
		WCS1 IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII 2 A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
	Rest1Dead:
		WCS1 I 900;
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("ToggleBulletJanitor") == 1, "Disappear");
		Loop;
	Rest2:
		WCS1 JJJJJJJJJJJJJJJJJJJJJJJJJJJ 2 A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
	Rest2Dead:
		WCS1 J 900;
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("ToggleBulletJanitor") == 1, "Disappear");
		Loop;
	Rest3:
		WCS1 KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK 2 A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
	Rest3Dead:
		WCS1 K 900;
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("ToggleBulletJanitor") == 1, "Disappear");
		Loop;
	Rest4:
		WCS1 LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL 2 A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
	Rest4Dead:
		WCS1 L 900;
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("ToggleBulletJanitor") == 1, "Disappear");
		Loop;
	Rest5:
		WCS1 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM 2 A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
	Rest5Dead:
		WCS1 M 900;
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("ToggleBulletJanitor") == 1, "Disappear");
		Loop;
	Rest6:
		WCS1 IIIIIIIIIIIIIIIIIIIIIIIIIII 2 A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
	Rest6Dead:
		WCS1 I 900;
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("ToggleBulletJanitor") == 1, "Disappear");
		Loop;
	Rest7:
		WCS1 JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ 2 A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
	Rest7Dead:
		WCS1 J 900;
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("ToggleBulletJanitor") == 1, "Disappear");
		Loop;
	Rest8:
		WCS1 KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK 2 A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
	Rest8Dead:
		WCS1 K 900;
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("ToggleBulletJanitor") == 1, "Disappear");
		Loop;
	Disappear:
		TNT1 A 1;
		Stop;
	}
}

class WPhosphorusCasingHASG : ExplosiveCasingHASG
{
}

class DanmakuCasingHASG : Actor
{
	override void BeginPlay()
	{
		ChangeStatNum(STAT_PB_BULLETS);
		NashGoreStatics.QueueCasings();
		Super.BeginPlay();
	}

	Default
	{
		Height 12;
		Radius 9;
		Speed 6;
		Scale 0.15;
		BounceType "Doom";
		-NOGRAVITY;
		+WINDTHRUST;
		+CLIENTSIDEONLY;
		+MOVEWITHSECTOR;
		+MISSILE;
		+NOBLOCKMAP;
		-DROPOFF;
		+NOTELEPORT;
		+FORCEXYBILLBOARD;
		+NOTDMATCH;
		+GHOST;
		+ROLLSPRITE;
		Mass 1;
		SeeSound "weapons/shell";
	}

	States
	{
	Spawn:
		TNT1 A 0;
	Exist:
		TNT1 A 0 A_JumpIfInventory("Zoomed", 1, "ShellSpin");
		TNT1 A 0 A_SetRoll(roll + (20), SPF_INTERPOLATE);
		DC0S G 1;
	ShellSpin:
		DC0S G 1
		{
			A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
		}
		TNT1 A 0 A_SetRoll(roll - (10), SPF_INTERPOLATE);
		TNT1 A 0 A_JumpIf(waterlevel > 1, "Disappear");
		Goto ShellSpin;
	Death:
		TNT1 A 0 A_SetRoll(0, SPF_INTERPOLATE);
		DC0S A 0 A_Jump(256, "Rest1", "Rest2", "Rest3", "Rest4", "Rest5", "Rest6", "Rest7", "Rest8");
		Goto Rest1;
	Rest1:
		DC0S IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII 2 A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
	Rest1Dead:
		DC0S I 900;
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("ToggleBulletJanitor") == 1, "Disappear");
		Loop;
	Rest2:
		DC0S JJJJJJJJJJJJJJJJJJJJJJJJJJJ 2 A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
	Rest2Dead:
		DC0S J 900;
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("ToggleBulletJanitor") == 1, "Disappear");
		Loop;
	Rest3:
		DC0S KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK 2 A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
	Rest3Dead:
		DC0S K 900;
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("ToggleBulletJanitor") == 1, "Disappear");
		Loop;
	Rest4:
		DC0S LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL 2 A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
	Rest4Dead:
		DC0S L 900;
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("ToggleBulletJanitor") == 1, "Disappear");
		Loop;
	Rest5:
		DC0S MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM 2 A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
	Rest5Dead:
		DC0S M 900;
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("ToggleBulletJanitor") == 1, "Disappear");
		Loop;
	Rest6:
		DC0S IIIIIIIIIIIIIIIIIIIIIIIIIII 2 A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
	Rest6Dead:
		DC0S I 900;
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("ToggleBulletJanitor") == 1, "Disappear");
		Loop;
	Rest7:
		DC0S JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ 2 A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
	Rest7Dead:
		DC0S J 900;
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("ToggleBulletJanitor") == 1, "Disappear");
		Loop;
	Rest8:
		DC0S KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK 2 A_SpawnItemEx("CasingSmoke", frandom(0.3, 0.2), random(0, -1.0), 0, 0, 0, frandom(0.5, 0.1), 0, SXF_CLIENTSIDE, 0);
	Rest8Dead:
		DC0S K 900;
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("ToggleBulletJanitor") == 1, "Disappear");
		Loop;
	Disappear:
		TNT1 A 1;
		Stop;
	}
}

class ShotCaseSpawnHASG5 : RifleCaseSpawn
{
	States
	{
	Spawn:
		TNT1 A 0;
		TNT1 A 1 A_SpawnItemEx("ShotgunCasing5HASG", 0, 0, -7, frandom(3, 5), frandom(3, 4), frandom(8, 11));
		Stop;
	}
}

class ShotCaseSpawnHASGEXP : RifleCaseSpawn
{
	States
	{
	Spawn:
		TNT1 A 0;
		TNT1 A 1 A_SpawnItemEx("ExplosiveCasingHASG", 0, 0, -7, frandom(3, 5), frandom(3, 4), frandom(8, 11));
		Stop;
	}
}

class ShotCaseSpawnHASGDAN : RifleCaseSpawn
{
	States
	{
	Spawn:
		TNT1 A 0;
		TNT1 A 1 A_SpawnItemEx("DanmakuCasingHASG", 0, 0, -7, frandom(3, 5), frandom(3, 4), frandom(8, 11));
		Stop;
	}
}

class ShotCaseSpawnHASGWP : RifleCaseSpawn
{
	States
	{
	Spawn:
		TNT1 A 0;
		TNT1 A 1 A_SpawnItemEx("WPhosphorusCasingHASG", 0, 0, -7, frandom(3, 5), frandom(3, 4), frandom(8, 11));
		Stop;
	}
}
