Class PB_SuperGL : PB_WeaponBase
{
	default
	{
		//$Title Automatic Grenade Launcher
		//$Category Project Brutality - Weapons
		//$Sprite SGL0Z0
		//SpawnID 9520;
		//Game Doom
		//SpawnID 29;
		weapon.slotnumber 6;
		Speed 20;
		Damage 20;
		Scale 0.48;
		Weapon.SelectionOrder 2500;
		Weapon.AmmoUse1 0;
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 0;
		Weapon.AmmoGive1 2;
		Weapon.AmmoType1 "RocketAmmo";
		Weapon.AmmoType2 "GrenadeRounds";
		Inventory.PickupSound "misc/rockboxa";
		+WEAPON.NOAUTOAIM;
		+WEAPON.EXPLOSIVE;
		+WEAPON.NOALERT;
		+WEAPON.NOAUTOFIRE;
		+FLOORCLIP;
		Inventory.PickupMessage "$PB_SGL_PICKUP";
		Tag "$PB_SGL_TAG";
		Inventory.AltHUDIcon "SGL0Z0";
		PB_WeaponBase.respectItem "RespectSGL";
		PB_WeaponBase.UnloaderToken "SGLUnloaded";
	}
	
	int GrenadeMode;
	const Det_layer = -52;
	enum SGL_Mode {
		SGL_Impact = 0,
		SGL_Sticky = 1,
		SGL_Acid = 2,
		SGL_Fire = 3,
		SGL_Cryo = 4
	}

	// Alt-fire detonator pulse — must not persist on the player while firing.
	// In-flight / stuck grenades check GrenadeDetonator on AAPTR_TARGET (shooter).
	override void DoEffect()
	{
		Super.DoEffect();
		if (!owner || !owner.player)
			return;
		if (owner.player.ReadyWeapon != self)
			return;

		if (owner.player.cmd.buttons & BT_ALTATTACK)
		{
			if (!owner.CountInv("GrenadeDetonator"))
			{
				owner.A_GiveInventory("GrenadeDetonator", 1);
				if (!owner.CountInv("SGLDetonateSoundCooldown"))
				{
					owner.A_StartSound("weapons/pbarm", CHAN_AUTO);
					owner.A_GiveInventory("SGLDetonateSoundCooldown", 22);
				}
			}
		}
		else if (owner.CountInv("GrenadeDetonator"))
		{
			owner.A_TakeInventory("GrenadeDetonator", 1);
		}
	}
	
	states
	{
		Spawn:
			SGL0 Z -1;
			stop;
		
		WeaponRespect:
			TNT1 A 0 {
				A_SetInventory("PB_LockScreenTilt",1);
				A_StartSound("weapons/sgl/inspect1", CHAN_AUTO);
				A_SetCurrentGrenadeType("Impact");
                A_SetCrosshair(-1);
			}
			SL00 ABCDEFGHIJKLMNOP 1 { 
				A_SetRoll(roll+0.8,SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
			}
				
			TNT1 A 0 A_StartSound("weapons/carbine/fancybutton", CHAN_AUTO);
			
			SL00 QRSTUVWV 1 {
				A_SetRoll(roll-1.6,SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
			}
			
			TNT1 A 0 A_StartSound("Ironsights", CHAN_AUTO);
			SL00 XYZ 1 {
				A_SetRoll(roll-0.4,SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
			}
			SL01 ABCD 1 {
				A_SetRoll(roll+0.4,SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
			}
			TNT1 A 0 {
				A_StartSound("LIGHTON", CHAN_AUTO);
				A_SetRoll(roll+0.7,SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
			}
			TNT1 A 0 {
				A_SetPitch(pitch-4.2, SPF_INTERPOLATE);
				A_SetAngle(angle-4.2, SPF_INTERPOLATE);
			}
			SL01 EFGHIJK 1 {
					A_SetRoll(roll-0.1,SPF_INTERPOLATE);
					return A_DoPBWeaponAction();
			}
			TNT1 A 0 A_StartSound("Ironsights", CHAN_AUTO);
			SL01 LMNOPQR 1 {
					A_SetPitch(pitch+0.6, SPF_INTERPOLATE);
					A_SetAngle(angle+0.6, SPF_INTERPOLATE);
					A_SetRoll(roll-0.15,SPF_INTERPOLATE);
					return A_DoPBWeaponAction();		
			}
			SL01 ST 1 {
					A_SetRoll(0,SPF_INTERPOLATE);
					return A_DoPBWeaponAction();
			}
			Goto Ready;
		
		Select:
			TNT1 A 0 PB_WeaponRaise("weapons/sgl/inspect2");	//this replaces the jump to SelectFirstPersonLegs state and a lot of other things
			TNT1 A 0 PB_WeapTokenSwitch("SGLSelected");
			TNT1 A 0 A_SetInventory("HasExplosiveWeapon",1);
			TNT1 A 0 A_SetInventory("CycleAnimation",0);
			TNT1 A 0 A_SetInventory("CantWeaponSpecial",0);
			TNT1 A 0 A_overlay(Det_layer,"DetonatorLayer");
			Goto SelectFirstPersonLegs;
		SelectContinue:
			TNT1 A 0 A_TakeInventory("GrenadeDetonator", 1);
			TNT1 A 0 PB_RespectIfNeeded();
			TNT1 A 0;
		SelectAnimation:
			SL02 ABCD 1 SGL_ChangeModeSprite("SL02","SL12","SL22","SL32","SL42","S001");
			goto ready;
		
		Deselect:
			TNT1 A 0 {
				A_SetInventory("CycleAnimation", 0);
				A_SetInventory("HasExplosiveWeapon", 0);
				A_TakeInventory("GrenadeDetonator", 1);
				A_ClearOverlays(Det_layer,Det_layer);
			}
			SL02 FGHI 1 SGL_ChangeModeSprite("SL02","SL12","SL22","SL32","SL42","S001");
			TNT1 A 0 A_lower(120);
			wait;
		Ready:
			TNT1 A 0 {
				A_overlay(Det_layer,"DetonatorLayer",true);
			}
		Ready3:
			TNT1 A 0 {
				A_SetRoll(0);
				PB_HandleCrosshair(89);
				A_SetInventory("PB_LockScreenTilt",0);
				A_SetInventory("CycleAnimation", 0);
				A_SetInventory("CantWeaponSpecial",0);
			}
		ReadyToFire:
			SL02 E 1 {
				SGL_ChangeModeSprite("SL02","SL12","SL22","SL32","SL42","S001");
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD);
			}
			Loop;
		Fire:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleCrosshair(89);
				A_SetInventory("PB_LockScreenTilt",0);
				A_TakeInventory("GrenadeDetonator", 1);
			}
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			TNT1 A 0 PB_TryAutoFatalityOnFire();
			TNT1 A 0 PB_jumpIfNoAmmo("Reload");
			S002 A 0;
			SL60 A 1 BRIGHT {
				PB_FireSGL();
				SGL_ChangeModeSprite("SL60","SL61","SL62","SL63","SL64");
				if(PB_GetMagUnloaded()) {A_SetWeaponSprite("S002");}
				A_Alertmonsters();
				A_Startsound("weapons/firegrenade", CHAN_WEAPON);
				PB_TakeAmmo("GrenadeRounds",1);
				A_ZoomFactor(0.98);
				A_GunFlash();
				PB_GunSmoke_Launcher(0, 0, 0);
			}
			SL60 B 1 BRIGHT {
				SGL_ChangeModeSprite("SL60","SL61","SL62","SL63","SL64");
				if(PB_GetMagUnloaded()) {A_SetWeaponSprite("S002");}
				//A_Spawnprojectile("ShakeYourAssDouble", 0, 0, 0, 0);
				PB_SpawnCasing("EmptyGrenadeBrass", 30, 0, 34, -frandom(1, 3), -frandom(2, 4), 5);
				A_ZoomFactor(0.99);
				PB_WeaponRecoil(-3.2,+1.61);
				A_GunFlash();
			}
			SL60 C 1 {
				A_Overlay(-6, "MuzzleSparks", true);
				SGL_ChangeModeSprite("SL60","SL61","SL62","SL63","SL64");
				if(PB_GetMagUnloaded()) {A_SetWeaponSprite("S002");}
				A_ZoomFactor(1.0);
				PB_WeaponRecoil(-3.2,+1.61);
				A_GunFlash();
			}
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(),"CycleUnloaded");
			Goto CyclingAnimation;
			
		CyclingAnimation:
			TNT1 A 0 A_SetInventory("CycleAnimation", 1);
			TNT1 A 0 A_StartSound("RLCYCLE2", 13);
			SL60 DEFGHIJKLMNOPQ 1 SGL_ChangeModeSprite("SL60","SL61","SL62","SL63","SL64");
			TNT1 A 0 A_StartSound("weapons/sgl/cycle", 9);
			SL60 RSTUVWX 1 SGL_ChangeModeSprite("SL60","SL61","SL62","SL63","SL64");
			SL02 E 1 SGL_ChangeModeSprite("SL02","SL12","SL22","SL32","SL42");
			SL02 E 1 {
				//A_TakeInventory("SGLDetonateSoundCooldown",22);
				SGL_ChangeModeSprite("SL02","SL12","SL22","SL32","SL42");
				PB_ReFire();
			}
			Goto Ready;
		CycleUnloaded:
			TNT1 A 0 A_SetInventory("CycleAnimation", 1);
			TNT1 A 0 A_StartSound("RLCYCLE2", 13);
			S002 DEFGHIJKLMNO 1;
			S002 VWX 1;
			S001 E 2;
			Goto Ready;
			
			
		
		//
		//	reload
		//
		
		Reload:
			TNT1 A 0 PB_CheckReload("ReloadUnloaded",null,"StartRechamber","Ready","Ready",7,1);
			TNT1 A 0 A_StartSound("Ironsights",15);
			SL03 ABCDEFGHIJ 1 {
				A_SetRoll(roll-0.5,SPF_INTERPOLATE);
				SGL_ChangeModeSprite("SL03","SL14","SL24","SL34","SL44");
			}
			TNT1 A 0 A_StartSound("weapons/sgl/detach", 14);
			SL03 KLMNO 1 {
				A_SetRoll(roll+1.0,SPF_INTERPOLATE);
				SGL_ChangeModeSprite("SL03","SL14","SL24","SL34","SL44");
			}
			
			SL03 PQRSTU 1 SGL_ChangeModeSprite("SL03","SL14","SL24","SL34","SL44");
			TNT1 A 0 {
				PB_SpawnSGLDrum();
				PB_SetMagUnloaded(true);
			}
			SL03 VWXYZ 1 {
				A_SetRoll(roll+1.0,SPF_INTERPOLATE);
				SGL_ChangeModeSprite("SL03","SL14","SL24","SL34","SL44");
			}
			SL04 ABC 1 {
				A_SetRoll(roll+1.0,SPF_INTERPOLATE);
				SGL_ChangeModeSprite("SL04","SL15","SL25","SL35","SL45");
			}
			SL04 DEFG 1 {
				A_SetRoll(roll-2.0,SPF_INTERPOLATE);
				SGL_ChangeModeSprite("SL04","SL15","SL25","SL35","SL45");
			}
			Goto ContinueReload;
		ReloadUnloaded:
			TNT1 A 0 A_StartSound("Ironsights",15);
			S003 ABCD 1;
		ContinueReload:
			TNT1 A 0 A_StartSound("weapons/nailgun/up", 10);
			SL04 HIJKLM 1 SGL_ChangeModeSprite("SL04","SL15","SL25","SL35","SL45");
			TNT1 A 0 A_StartSound("weapons/sgl/inspect1", 16);
			SL04 NOPQRST 1 {
				A_SetRoll(roll-1.0,SPF_INTERPOLATE);
				SGL_ChangeModeSprite("SL04","SL15","SL25","SL35","SL45");
			}
			SL04 UVW 1 {
				A_SetRoll(roll+0.8,SPF_INTERPOLATE);
				SGL_ChangeModeSprite("SL04","SL15","SL25","SL35","SL45");
			}
			
			SL04 XYZ 1 {
				A_SetRoll(roll-1.2,SPF_INTERPOLATE);
				SGL_ChangeModeSprite("SL04","SL15","SL25","SL35","SL45");
			}
			TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(),"Rechamber");
			TNT1 A 0 A_SetRoll(0,SPF_INTERPOLATE);
			TNT1 A 0 A_StartSound("weapons/sgl/slap", 9, CHANF_OVERLAP );
			SL05 A 1 SGL_ChangeModeSprite("SL05","SL16","SL26","SL36","SL46");
			TNT1 A 0 {
				A_StartSound("weapons/nailgun/inspect4", 17, CHANF_OVERLAP);
				PB_AmmoIntoMag("GrenadeRounds","RocketAmmo",7,1);
				PB_SetMagUnloaded(false);
				PB_SetMagEmpty(false);
			}
			SL05 BCDEF 1 SGL_ChangeModeSprite("SL05","SL16","SL26","SL36","SL46");
			TNT1 A 0 A_StartSound("Ironsights", 12);
			SL05 GHIJKL 1 SGL_ChangeModeSprite("SL05","SL16","SL26","SL36","SL46");
			TNT1 A 0 PB_SetReloading(false);
			goto ready;
		//Rechamber Animation
		StartRechamber:
			SL05 LKJIH 1 SGL_ChangeModeSprite("SL05","SL16","SL26","SL36","SL46");
			SL04 WXYZ 1 SGL_ChangeModeSprite("SL04","SL15","SL25","SL35","SL45");
		Rechamber:
			TNT1 A 0 {
				A_StartSound("weapons/nailgun/inspect4", 9, CHANF_OVERLAP);
				PB_AmmoIntoMag("GrenadeRounds","RocketAmmo",6,1);
				PB_SetMagUnloaded(false);
				PB_SetMagEmpty(false);
				A_SetRoll(0,SPF_INTERPOLATE);
				A_StartSound("RLCYCLE2", 13);
			}
			SL72 BCDEFGHIJK 1 SGL_ChangeModeSprite("SL72","S072","S272","S172","S372");
			TNT1 A 0 A_StartSound("weapons/sgl/cycle", 18);
			SL72 LMNO 1 SGL_ChangeModeSprite("SL72","S072","S272","S172","S372");
			TNT1 A 0 A_StartSound("weapons/sgl/cycle", 12);
			SL72 PQRSTUV 1 SGL_ChangeModeSprite("SL72","S072","S272","S172","S372");
			TNT1 A 0 PB_SetChamberEmpty(false);
			SL72 WXYZ 1 SGL_ChangeModeSprite("SL72","S072","S272","S172","S372");
			SL73 ABCDEF 1 SGL_ChangeModeSprite("SL73","S073","S273","S173","S373");
			TNT1 A 0 PB_SetReloading(false);
			goto ready;
		
		//
		//	fking unload
		//
		
		Unload:
			TNT1 A 0 {
				A_SetCrosshair(-1);
				PB_SetReloading(true);
			}
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(),"Ready3");
			TNT1 A 0 A_JumpIf(!PB_GetChamberEmpty(),"UnloadChamber");
		UnloadNormal:
			S402 ABCDEFGHIJKL 1 SGL_ChangeModeSprite("S402","S412","S422","S432","S442");
			TNT1 A 0 A_StartSound("weapons/sgl/detach", 14);
			S402 MNOPQRST 1 SGL_ChangeModeSprite("S402","S412","S422","S432","S442");
			TNT1 A 0 {
				PB_UnloadSGL();
				PB_SetMagUnloaded(true);
				PB_SetMagEmpty(true);
			}
			S402 UVWXYZ 1 SGL_ChangeModeSprite("S402","S412","S422","S432","S442");
			S403 ABCDE 1 SGL_ChangeModeSprite("S403","S413","S423","S433","S443");
			TNT1 A 0 PB_SetReloading(false);
			goto ready;
		UnloadChamber:
			TNT1 A 0 A_StartSound("Weapons/GrenadeLoad", 9);
			S400 ABCD 1 SGL_ChangeModeSprite("S400","S410","S420","S430","S440");
			TNT1 A 0 {
				PB_UnloadSGL(CountInv("GrenadeRounds") - 1);
				PB_SetChamberEmpty(true);
			}
			S400 EFGHIJKL 1 SGL_ChangeModeSprite("S400","S410","S420","S430","S440");
			TNT1 A 0 A_StartSound("weapons/nailgun/inspect4", 10);
			S400 MNOPQRST 1 SGL_ChangeModeSprite("S400","S410","S420","S430","S440");
			TNT1 A 0 A_StartSound("weapons/nailgun/up", 11);
			TNT1 A 0 {
				PB_UnloadSGL();
				PB_SetMagUnloaded(true);
				PB_SetMagEmpty(true);
			}
			S400 UVWXYZ 1 SGL_ChangeModeSprite("S400","S410","S420","S430","S440");
			S401 ABCDE 1 SGL_ChangeModeSprite("S401","S411","S421","S431","S441");
			TNT1 A 0 PB_SetReloading(false);
			Goto ready;
		
		//
		//	weapon special
		//

		WeaponSpecial:
			TNT1 A 0 {
				A_SetInventory("CantWeaponSpecial" ,1 );
				A_SetInventory("GoWeaponSpecialAbility", 0);
			}
			TNT1 A 0 PB_PreHandleSGLWheel();
			//Unload Previous Ammo Type
			TNT1 A 0 PrintSGLMode();
			TNT1 A 0 {
				A_ZoomFactor(1.0);
				A_SetCrosshair(-1);
				PB_SetReloading(true);
			}
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(), "SpecialFromUnloaded");
			TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(), "SpecialFromEmptyChamber");
			TNT1 A 0 A_StartSound("Weapons/GrenadeLoad", 9);
			S400 ABCD 1 SGL_ChangeModeSprite("S400","S410","S420","S430","S440");
			TNT1 A 0 {
				PB_UnloadSGL(CountInv("GrenadeRounds") - 1);
				PB_SetChamberEmpty(true);
			}
			S400 EFGHIJKL 1 SGL_ChangeModeSprite("S400","S410","S420","S430","S440");
			TNT1 A 0 A_StartSound("weapons/nailgun/inspect4", 10);
			S400 MNOPQRST 1 SGL_ChangeModeSprite("S400","S410","S420","S430","S440");
			TNT1 A 0 {
				A_StartSound("weapons/nailgun/up", 11);
				PB_SetMagUnloaded(true);
			}
			S400 UVWXY 1 SGL_ChangeModeSprite("S400","S410","S420","S430","S440");
			SL03 Z 1 SGL_ChangeModeSprite("SL03","SL14","SL24","SL34","SL44");
			Goto LoadNewAmmoType;
		SpecialFromUnloaded:
			TNT1 A 0 A_StartSound("Ironsights",15);
			S003 ABCD 1;
			Goto LoadNewAmmoType;
		SpecialFromEmptyChamber:
			TNT1 A 0 A_StartSound("Ironsights",15);
			SL03 ABCDEFGHIJ 1 {
				A_SetRoll(roll-0.5,SPF_INTERPOLATE);
				SGL_ChangeModeSprite("SL03","SL14","SL24","SL34","SL44");
			}
			TNT1 A 0 A_StartSound("weapons/sgl/detach", 14);
			SL03 KLMNO 1 {
				A_SetRoll(roll+1.0,SPF_INTERPOLATE);
				SGL_ChangeModeSprite("SL03","SL14","SL24","SL34","SL44");
			}
			
			SL03 PQRSTU 1 {
				SGL_ChangeModeSprite("SL03","SL14","SL24","SL34","SL44");
			}
			TNT1 A 0 {
				PB_SpawnSGLDrum();
				PB_SetMagUnloaded(true);
			}
			SL03 VWXYZ 1 {
				A_SetRoll(roll+1.0,SPF_INTERPOLATE);
				SGL_ChangeModeSprite("SL03","SL14","SL24","SL34","SL44");
			}
		LoadNewAmmoType:
			TNT1 A 0 {
				PB_SpawnSGLDrum();
				PB_HandleWheel();	//do the mode change here, so the next animations plays the new ammo type 
				A_SetInventory("CantWeaponSpecial" ,0 );
				A_SetInventory("GrenadeTypeImpact", 0);
				A_SetInventory("GrenadeTypeSticky", 0);
				A_SetInventory("GrenadeTypeIncendiary", 0);
				A_SetInventory("GrenadeTypeCryo", 0);
				A_SetInventory("GrenadeTypeAcid", 0);
			}
			SL04 ABC 1 {
				A_SetRoll(roll+1.0,SPF_INTERPOLATE);
				SGL_ChangeModeSprite("SL04","SL15","SL25","SL35","SL45");
			}
			SL04 DEFG 1 {
				A_SetRoll(roll-2.0,SPF_INTERPOLATE);
				SGL_ChangeModeSprite("SL04","SL15","SL25","SL35","SL45");
			}
			Goto ContinueReload;
		
		//
		//flashes
		//
		
		DetonatorLayer:
			TNT1 A 1;
			loop;
		
		
		MuzzleSparks:
			TNT1 A 0 A_Jump(256, "Spark1", "Spark2");
		Spark1:
			S060 A 1 Bright;
			Stop;
		Spark2:
			S060 B 1 Bright;
			Stop;
		
		FlashKicking:
			S006 ABCDEFGGGHIJKLM 1 SGL_ChangeModeSprite("S006","S007","S019","S008","S009",layer:OverlayID());
			Goto Ready3;
		
		FlashAirKicking:
			S006 ABCDEFGGGGHIJKLM 1 SGL_ChangeModeSprite("S006","S007","S019","S008","S009",layer:OverlayID());
			Goto Ready3;
			
		FlashSlideKicking:
			S020 ABCDEFGHIJKLMNOPQRSSSTUVWX 1 SGL_ChangeModeSprite("S020","S021","S022","S023","S024",layer:OverlayID());
			Goto Ready3;
			
		FlashSlideKickingStop:
			S020 TTTUVWX 1 SGL_ChangeModeSprite("S020","S021","S022","S023","S024",layer:OverlayID());
			Goto Ready3;
	
		FlashPunching:
			S030 ABCDEFGHHIJKLM 1 SGL_ChangeModeSprite("S030","S031","S032","S033","S034",layer:OverlayID());
			TNT1 A 0 A_ClearOverlays(PSP_FLASH, PSP_FLASH, false);
			Goto Ready3;
		
		LoadSprites:
			S001 ABCDEFGHI 0;
			SL02 ABCDEFGHI 0;
			SL12 ABCDEFGHI 0;
			SL22 ABCDEFGHI 0;
			SL32 ABCDEFGHI 0;
			SL42 ABCDEFGHI 0;
			SL03 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			SL04 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0; 
			SL05 ABCDEFGHIJKL 0;
			SL14 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			SL15 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			SL16 ABCDEFGHIJKL 0;
			SL24 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			SL25 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			SL26 ABCDEFGHIJKL 0;
			SL34 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0; 
			SL35 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0; 
			SL36 ABCDEFGHIJKL 0; 
			SL44 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			SL45 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0; 
			SL46 ABCDEFGHIJKL 0;
			SL60 ABCDEFGHIJKLMNOPQRSTUVWX 0;
			SL61 ABCDEFGHIJKLMNOPQRSTUVWX 0;
			SL62 ABCDEFGHIJKLMNOPQRSTUVWX 0;
			SL63 ABCDEFGHIJKLMNOPQRSTUVWX 0;
			SL64 ABCDEFGHIJKLMNOPQRSTUVWX 0;
			SL60 ABCDEFGHIJKLMNOPQRSTUVWX 0;
			SL61 ABCDEFGHIJKLMNOPQRSTUVWX 0;
			SL62 ABCDEFGHIJKLMNOPQRSTUVWX 0;
			SL63 ABCDEFGHIJKLMNOPQRSTUVWX 0;
			SL64 ABCDEFGHIJKLMNOPQRSTUVWX 0;
			SL72 BCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			S072 BCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			S272 BCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			S172 BCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			S372 BCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			SL73 ABCDEF 0;
			S073 ABCDEF 0;
			S273 ABCDEF 0;
			S173 ABCDEF 0;
			S373 ABCDEF 0;
			S030 ABCDEFGHIJKLM 0;
			S031 ABCDEFGHIJKLM 0;
			S032 ABCDEFGHIJKLM 0;
			S033 ABCDEFGHIJKLM 0;
			S034 ABCDEFGHIJKLM 0;
			S020 ABCDEFGHIJKLMNOPQRSSSTUVWX 0;
			S021 ABCDEFGHIJKLMNOPQRSSSTUVWX 0;
			S022 ABCDEFGHIJKLMNOPQRSSSTUVWX 0;
			S023 ABCDEFGHIJKLMNOPQRSSSTUVWX 0;
			S024 ABCDEFGHIJKLMNOPQRSSSTUVWX 0;
			S006 ABCDEFGGGHIJKLM 0;
			S007 ABCDEFGGGHIJKLM 0;
			S019 ABCDEFGGGHIJKLM 0;
			S008 ABCDEFGGGHIJKLM 0;
			S009 ABCDEFGGGHIJKLM 0;
			S402 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			S403 ABCDE 0;
			S412 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			S413 ABCDE 0;
			S422 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			S423 ABCDE 0;
			S432 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			S433 ABCDE 0;
			S442 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			S443 ABCDE 0;
			S400 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			S401 ABCDE 0;
			S410 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			S411 ABCDE 0;
			S420 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			S421 ABCDE 0;
			S430 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			S431 ABCDE 0;
			S440 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0;
			S441 ABCDE 0;
			stop;
	}
	
	action int getSGLMode()
	{
		return invoker.GrenadeMode;
	}
	
	action void SetSGLMode(int mode = SGL_Impact)
	{
		invoker.GrenadeMode = mode;
	}
	
	Action void SGL_ChangeModeSprite(name imp,name stk,name acid, name inc, name cryo, name unloaded = '', name emptychamber = '', int layer = PSP_WEAPON)
	{
		let psp = player.findpsprite(layer);
		
		if(!psp)
			return;
			
		if(PB_GetMagUnloaded() && unloaded != '')
		{
			psp.sprite = getspriteindex(unloaded);
			return;
		}
		
		if(PB_GetMagUnloaded() && emptychamber != '')
		{
			psp.sprite = getspriteindex(emptychamber);
			return;
		}
		
		int mod = getSGLMode();
		
		switch(mod)
		{
			case SGL_Impact: 	psp.sprite = getspriteindex(imp); 	break;
			case SGL_Sticky: 	psp.sprite = getspriteindex(stk); 	break;
			case SGL_Acid: 		psp.sprite = getspriteindex(acid); 	break;
			case SGL_Fire: 		psp.sprite = getspriteindex(inc); 	break;
			case SGL_Cryo: 		psp.sprite = getspriteindex(cryo); 	break;
		}
	}
	
	action void SGL_ChangeModeSpriteNew(name imp,name stk,name acid, name inc, name cryo,int layer = PSP_WEAPON)
	{
		let psp = player.findpsprite(layer);
		
		if(!psp)
			return;
		if(findinventory("GrenadeTypeImpact"))
			psp.sprite = GetspriteIndex(imp);
		else if(findinventory("GrenadeTypeSticky"))
			psp.sprite = GetspriteIndex(stk);
		else if(findinventory("GrenadeTypeAcid"))
			psp.sprite = GetspriteIndex(acid);
		else if(findinventory("GrenadeTypeIncendiary"))
			psp.sprite = GetspriteIndex(inc);
		else if(findinventory("GrenadeTypeCryo"))
			psp.sprite = GetspriteIndex(cryo);
	}
	
	action void PB_FireSGL()
	{
		string msl = "PB_FragGrenade";
					
		switch(getSGLMode())
		{
			case SGL_Impact: 	msl = "PB_FragGrenade";			break;
			case SGL_Sticky: 	msl = "PB_StickyGrenade";		break;
			case SGL_Acid: 		msl = "PB_AcidGrenade";			break;
			case SGL_Fire: 		msl = "PB_IncendiaryGrenade";	break;
			case SGL_Cryo: 		msl = "PB_CryoGrenade";			break;
		}
		A_TakeInventory("GrenadeDetonator", 1);
		A_FireCustomMissile(msl, 0, 0, 0, 0);
	}
	
	action void PB_UnloadSGL(int goal = 0)
	{
		switch(getSGLMode())
		{
		case SGL_Impact:
		case SGL_Sticky:
		case SGL_Acid:
		case SGL_Fire:
		case SGL_Cryo:
			PB_UnloadMag("GrenadeRounds","RocketAmmo",1,1,1,goal,"RocketAmmo");
			break;
		}
	}
	
	action void PB_SpawnSGLDrum()
	{
		if(PB_GetMagEmpty() && !PB_GetMagUnloaded())
		{
			string csng = "SGL_Drum";
			switch(getSGLMode())
			{
				case SGL_Impact: 	csng = "SGL_Drum";				break;
				case SGL_Sticky: 	csng = "SGL_StickyDrum";		break;
				case SGL_Acid: 		csng = "SGL_AcidDrum";			break;
				case SGL_Fire: 		csng = "SGL_IncendiaryDrum";	break;
				case SGL_Cryo: 		csng = "SGL_CryoDrum";			break;
			}
			PB_SpawnCasing(csng,25,0,20,Frandom(3,4),Frandom(3,4),1);
		}
	}
	
	action state PB_PreHandleSGLWheel()
	{
		if(
		findinventory("GrenadeTypeImpact") && getSGLMode() == 			SGL_Impact ||
		findinventory("GrenadeTypeSticky") && getSGLMode() == 			SGL_Sticky ||
		findinventory("GrenadeTypeAcid") && getSGLMode() == 			SGL_Acid ||
		findinventory("GrenadeTypeIncendiary") && getSGLMode() == 		SGL_Fire ||
		findinventory("GrenadeTypeCryo") && getSGLMode() == 			SGL_Cryo)
		{
			A_Print("$PB_ALREADYSELECTED");
			A_SetInventory("CantWeaponSpecial" ,0 );
			A_SetInventory("GrenadeTypeImpact", 0);
			A_SetInventory("GrenadeTypeSticky", 0);
			A_SetInventory("GrenadeTypeIncendiary", 0);
			A_SetInventory("GrenadeTypeCryo", 0);
			A_SetInventory("GrenadeTypeAcid", 0);
			return resolvestate("ready");
		}
		
		return resolvestate(null);
	}
	
	action void PB_HandleWheel()
	{
		if (CountInv("GrenadeTypeImpact") == 1) {SetSGLMode(SGL_Impact);	A_SetCurrentGrenadeType("Impact");}
		if (CountInv("GrenadeTypeSticky") == 1) {SetSGLMode(SGL_Sticky);	A_SetCurrentGrenadeType("Sticky");}
		if (CountInv("GrenadeTypeAcid") == 1) {	SetSGLMode(SGL_Acid);		A_SetCurrentGrenadeType("Acid");}
		if (CountInv("GrenadeTypeIncendiary") == 1) {SetSGLMode(SGL_Fire);	A_SetCurrentGrenadeType("Incendiary");}
		if (CountInv("GrenadeTypeCryo") == 1) {SetSGLMode(SGL_Cryo);	A_SetCurrentGrenadeType("Cryo");}
	}
	
	action void PrintSGLMode()
	{
		if(findinventory("GrenadeTypeImpact")) A_Print("$PB_SGL_IMPACT", 2);
		if(findinventory("GrenadeTypeSticky")) A_Print("$PB_SGL_STICKY", 2);
		if(findinventory("GrenadeTypeIncendiary")) A_Print("$PB_SGL_INCENDIARY", 2);
		if(findinventory("GrenadeTypeCryo")) A_Print("$PB_SGL_CRYO", 2);
		if(findinventory("GrenadeTypeAcid")) A_Print("$PB_SGL_ACID", 2);	
	}
	
}


Class GrenadeRounds : PB_WeaponAmmo
{
	default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 7;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 7;
		+INVENTORY.IGNORESKILL;
		Inventory.Icon "SGL0Z0";
	}
}
