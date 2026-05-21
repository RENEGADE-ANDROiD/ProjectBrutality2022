// PB_Autoshotgun - ZScript port (DECORATE PB_Weapon retired).

class PB_Autoshotgun : PB_WeaponBase
{
	default
	{
		//Title Autoshotgun
		//Category Weapons
		//Sprite AUSCA0
	Weapon.BobRangeX 0.3;
	Weapon.BobRangeY 0.5;
		Weapon.BobStyle "InverseSmooth";
	Weapon.BobSpeed 2.4;
		// Game Doom (DECORATE only)
	Weapon.SelectionOrder 1300;
	Weapon.AmmoUse1 0;
	Weapon.AmmoUse2 0;
	Weapon.AmmoGive1 5;
	Weapon.AmmoGive2 0;
	+FLOORCLIP;
	+DONTGIB;
	Scale 0.52;
	Weapon.AmmoType1 "NewShell";
	Weapon.AmmoType2 "AutoShotgunAmmo";
	Inventory.PickupMessage "$You've found the Auto Shotgun! (Slot 3)";
	Inventory.PickupSound "weapons/sgpump";
	Inventory.Amount 1;
	Inventory.MaxAmount 3;
	Obituary "$OB_MPSHOTGUN";
	AttackSound "";
	Tag "Auto-Shotgun";
	+WEAPON.NOALERT;
	+WEAPON.NOAUTOAIM;
	+WEAPON.NOAUTOFIRE;
	PB_WeaponBase.UnloaderToken "PBAutoShotgunHasUnloaded";
	Inventory.Icon "AUSCA0";
	Inventory.AltHUDIcon "AUSCA0";
	PB_WeaponBase.respectItem "RespectAutoShotgun";
	FloatBobStrength 0.5;
	Weapon.SlotNumber 3;
	Weapon.SlotPriority 0.2;
	}
	states
	{
		Steady:
			TNT1 A 1;
			Goto Ready;
			
		Ready:
			"AU10" ABCDEFGH 0;
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			TNT1 A 0 PB_RespectIfNeeded;
		WeaponRespect:
			TNT1 A 0 {
				A_SetCrosshair(5);
				A_Giveinventory("PB_LockScreenTilt",1);
				A_PlaySoundEx("weapons/autoshotgun/respect1", "Auto");
			}
			AG10 ABC 1 {
				A_SetRoll(roll-1.5,SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
			}
			AG10 DEF 1 {
				A_SetRoll(roll+1.5,SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
			}
			"AG10" F 1 A_PlaySoundEx("Ironsights", "Auto");
			AG00 ABCDEFGHIJKL 1 {
				A_SetRoll(roll-0.5,SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
			}
			AG00 LLL 1 {
				A_SetRoll(roll+2.0,SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
			}
			"AG00" LLLL 1 A_DoPBWeaponAction;
			"AG00" MNOPQ 1;
			TNT1 A 0 A_PlaySoundEx("insertshell", "Auto");
			AG00 R 1{
				A_SetRoll(roll-1.0,SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
			}
			AG00 STT 1{
				A_SetRoll(roll+2.0,SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
			}
			AG00 UUUU 1 {
				A_SetRoll(roll+0.5,SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
			}
			"AG00" UUUU 1 A_DoPBWeaponAction;
			TNT1 A 0 A_PlaySoundEx("H4SGCOCK", "Auto");
			AG00 V 1 {
				A_SetRoll(roll-2.0,SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
			}
			AG00 VWXYZZ 1 {
				A_SetRoll(roll-2.0,SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
			}
			"AG00" ZZZZ 1 A_DoPBWeaponAction;
			AG01 ABCDE 1 {
				A_SetRoll(roll+1.0,SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
			}

			TNT1 A 0 {
					if(CountInv("AutoshotgunDrumMag")>=1){
					A_SetRoll(0);
					PB_HandleCrosshair(70);
					A_TakeInventory("PB_LockScreenTilt",1);
					return ResolveState("ASGDrumRespect");
					}
					return ResolveState(null);}
			AG01 FGHIJ 1 {
			A_SetRoll(roll+1.0,SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
			}
			AG01 KL 1{
				A_SetRoll(roll+1.0,SPF_INTERPOLATE);
				return A_DoPBWeaponAction();
			}
			"AG01" MN 1;
			Goto Ready3;
		DrumMagInspectCheck:
			TNT1 A 0 A_ClearOverlays(10,11);
			TNT1 A 0 A_TakeInventory("DrumMagNotInserted",1);
			TNT1 A 0 A_JumpIfInventory("DualWieldingAutoshotguns", 1, "DrumMagInspectGoBackToSingle");
			Goto BeginNormalDrumReload;
		DrumMagInspectGoBackToSingle:
			"AG60" NMLKJI 1 A_Setroll(roll-1.0, SPF_INTERPOLATE);
			"AG60" HGF 1 A_Setroll(roll+2.0, SPF_INTERPOLATE);
			"AG60" EDCB 1;
			"AG60" A 1 A_Setroll(0, SPF_INTERPOLATE);
			Goto BeginNormalDrumReload;
		SelectAnimationDrum:
			"AU24" EFG 0;
			"AU23" EFG 0;
			"AU02" EFG 0;
			"AU01" EFG 0;
			AU10 ABCD 1; //{if (CountInv("AutoshotgunDrumMag") == 1 ) { A_SetWeaponSprite("AU10");}}
			AU2M EFGH 1 {
				if (CountInv("AutoShotgunAmmo") == 24 ) { A_SetWeaponSprite("AU24");}
				if (CountInv("AutoShotgunAmmo") == 23 ) { A_SetWeaponSprite("AU23");}
				if (CountInv("AutoShotgunAmmo") == 2 )  { A_SetWeaponSprite("AU02");}
				if (CountInv("AutoShotgunAmmo") == 1 )  { A_SetWeaponSprite("AU01");}
				if (CountInv("AutoShotgunAmmo") == 0 )  { A_SetWeaponSprite("AU01");}
				}
			Goto ReadyToFireDrum;
		SelectAnimation:
			TNT1 A 0 A_JumpIfInventory("DualWieldingAutoshotguns", 1, "SelectAnimationDualWield");
			TNT1 A 0 A_PlaySoundEx("weapons/autoshotgun/respect1", "Auto");

			TNT1 A 0 A_JumpIfInventory("AutoshotgunDrumMag", 1, "SelectAnimationDrum") ;//Is this even a thing anymore?  Let's make it a thing;
			AG10 ABCDEFG 1; //{if (CountInv("AutoshotgunDrumMag") == 1 ) { A_SetWeaponSprite("AU10");}}

		Ready3:
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "ReadyDualWield");
			TNT1 A 0 {
				A_ClearOverlays(10,11);
				A_SetRoll(0);
				PB_HandleCrosshair(70);
				A_TakeInventory("PB_LockScreenTilt",1);
			}
			TNT1 A 0 {
				if (CountInv("AutoshotgunDrumMag") == 1 && CountInv("PBAutoShotgunHasUnloaded") != 1) {return ResolveState("ReadyToFireDrum"); }
				return ResolveState(null);
			}
			TNT1 A 0;
			Goto ReadyToFire;

		ReadyToFire:
			
			AG10 H 1 {
					if (CountInv("JustFiredAutoshotgun") >= 60) { A_Gunflash("BarrelSmoke1");}
					if (CountInv("PumpAutoShotgun") == 1 && CountInv("AutoShotgunAmmo") >= 1) {return ResolveState("Pump");}
					if (CountInv("DrumMagNotInserted") >= 1 ) { return ResolveState("DrumMagInspectCheck"); }
					return A_DoPBWeaponAction(WRF_ALLOWRELOAD, CheckUnloaded("PBAutoShotgunHasUnloaded"));
			}
			Loop;
		ReadyToFireDrum:
			"AU01" H 0;
			"AU02" H 0;
			"AU03" H 0;
			"AU22" H 0;
			"AU23" H 0;
			"AU24" H 0;
			AU2M H 1 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AU24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AU23");}
					if (CountInv("AutoShotgunAmmo") == 22 ) {A_SetWeaponSprite("AU22");}
					if (CountInv("AutoShotgunAmmo") == 3 )  {A_SetWeaponSprite("AU03");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AU02");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AU01");}
					if (CountInv("AutoShotgunAmmo") == 0 )  {A_SetWeaponSprite("AU01");}
					if (CountInv("JustFiredAutoshotgun") >= 60) {A_Gunflash("BarrelSmoke1");}
					if (CountInv("PumpAutoShotgun") == 1 && CountInv("AutoShotgunAmmo") >= 1) {return ResolveState("Pump");}
					return A_DoPBWeaponAction(WRF_ALLOWRELOAD, CheckUnloaded("PBAutoShotgunHasUnloaded"));
			}
			Loop;
		
		
		
		BarrelSmoke1:
			TNT1 A 1 {
				A_FireCustomMissile("GunBarrelSmoke", 0, 0, 0, 0, 0, 0);
				A_Takeinventory("JustFiredAutoshotgun",1);
			}
			Stop;
			
		SelectAnimationDualWield:
			TNT1 A 0 A_PlaySoundEx("weapons/autoshotgun/respect1", "Auto");
			"AG60" IJKLMN 1;
			TNT1 A 0 A_PlaySoundEx("weapons/autoshotgun/respect1", "Auto");
		ReadyDualWield:
			TNT1 A 0 {
				A_SetRoll(0);
				PB_HandleCrosshair(70);
				A_TakeInventory("PB_LockScreenTilt",1);
				A_SetFiringRightWeapon(False);
				A_SetFiringLeftWeapon(False);
				A_TakeInventory("DualFiring",1);
				if(CountInv("LeftASGAmmo") < CountInv("AutoShotgunAmmo")){
					A_GiveInventory("DualFiring",1);
				}
				if(CountInv("NewShell")>0){
					if(CountInv("LeftASGAmmo")<=0){
						A_GiveInventory("DualFireReload",1);
					}
					if(CountInv("AutoShotgunAmmo")<=0){
						A_GiveInventory("DualFireReload",1);
					}
				}
				A_Overlay(10, "IdleLeft_Overlay", false);
				A_Overlay(11, "IdleRight_Overlay", false);
				if (CountInv("DrumMagNotInserted") >= 1 ) { return ResolveState("DrumMagInspectCheck"); }
				return ResolveState(null);
			}
		ReadyToFireDualWield:
			TNT1 A 1 {
				if (CountInv("DrumMagNotInserted") >= 1 ) { return ResolveState("DrumMagInspectCheck"); }
				return ResolveState(null);
			}
			TNT1 A 0 A_DoPBWeaponAction(WRF_ALLOWRELOAD | WRF_NOFIRE);
			Loop;
		IdleLeft_Overlay:
			AG61 J 1 {
				if(CountInv("LeftASGAmmo")<=0 && CountInv("AutoShotgunAmmo")>0){
					A_GiveInventory("DualFiring",1);
				}
				if(CountInv("DualFiring")==0 || (CountInv("DualFiring")==0 && CountInv("AutoShotgunAmmo")<=0) || GetCvar("SingleDualFire")==1){
					if((PressingFire() || JustPressed(BT_ATTACK)) && !A_IsFiringLeftWeapon()){
						if(CountInv("LeftASGAmmo") > 0){
							return ResolveState("FireLeft_Overlay");
						}
						else {
							A_PlaySoundEx("weapons/empty", "Auto");
							return ResolveState(null);
						}
					}
				}
				return ResolveState(null);
			}
			Loop;
		IdleRight_Overlay:
			AG61 I 1 {
				if(CountInv("LeftASGAmmo")>0 && CountInv("AutoShotgunAmmo")<=0){
					A_TakeInventory("DualFiring",1);
				}
				if(CountInv("DualFiring")==1 || (CountInv("DualFiring")==1 && CountInv("LeftASGAmmo")<=0)){
					if((PressingFire() || JustPressed(BT_ATTACK)) && !A_IsFiringLeftWeapon() && GetCvar("SingleDualFire")==0){
						if(CountInv("AutoShotgunAmmo") > 0){
							return ResolveState("FireRight_Overlay");
						}
						else {
							A_PlaySoundEx("weapons/empty", "Auto");
							return ResolveState(null);
						}
					}
				}
				if((PressingAltfire() || JustPressed(BT_ALTATTACK)) && !A_IsFiringRightWeapon()){
					if(CountInv("AutoShotgunAmmo")>0 && GetCvar("SingleDualFire")==1){
						return ResolveState("FireRight_Overlay");
					}
					if(CountInv("AutoShotgunAmmo")>0 && CountInv("LeftASGAmmo")>0 && GetCvar("SingleDualFire")==0){
						A_Overlay(10, "FireLeft_Overlay", false);
						return ResolveState("FireRight_Overlay");
					}
					else {
						A_PlaySoundEx("weapons/empty", "Auto");
						return ResolveState(null);
					}
				}
				return ResolveState(null);
			}
			Loop;
			
		FireLeft_Overlay:
				TNT1 A 0 A_FireBullets (frandom(5.84,6.45), frandom(5.2,6.75), 4, 11, "ShotgunPuff");
				AG62 A 1 BRIGHT {
					A_Overlay(8, "LeftMuzzleFlash", true);
					A_FireBullets (frandom(5.85,6.65), frandom(5.32,6.75), 4, 9, "MachineGunBulletPuff");
					A_AlertMonsters();
					A_Takeinventory("LeftASGAmmo",1);
					A_PlaySoundeX("Weapons/AutoShotgun", "Weapon");
					A_PB_ThrottledGunSmoke(-2, 1, 0);
					A_FireCustomMissile("YellowFlareSpawn",0,0,-3,0);
					A_FireCustomMissile("ShakeYourAssDouble", 0, 0, 0, 0);
					A_Giveinventory("JustFiredAutoshotgun",20);
					A_GunFlash();
					A_ZoomFactor(0.98);
					PB_WeaponRecoil(-2.30,+1.88);
				}
				AG62 B 1 BRIGHT {
					A_ZoomFactor(0.99);
					PB_WeaponRecoil(-2.30,+1.88);
					A_FireProjectile("ShotgunWad",random(-2,2),0,random(-13,-12),-2,FPF_NOAUTOAIM,random(-2,2));
				}
				AG62 C 1 {
					A_ZoomFactor(1.0);
					A_FireCustomMissile("ShotCaseSpawn",0,0,-8,-8);
				}
				AG62 D 1 {
					if(CountInv("LeftASGAmmo")<=0 || CountInv("AutoShotgunAmmo")>0 ){
						A_GiveInventory("DualFiring",1);
					}
				}
				"AG62" EFGHH 1;
				TNT1 A 0 {
					if(CountInv("LeftASGAmmo")<=0){
						A_GiveInventory("DualFireReload",1);
					}
				}
				Goto IdleLeft_Overlay;
			
		FireRight_Overlay:
				TNT1 A 0 A_FireBullets (frandom(5.84,6.45), frandom(5.2,6.75), 4, 11, "ShotgunPuff");
				AG61 A 1 BRIGHT {
					A_Overlay(9, "RightMuzzleFlash", true);
					A_FireBullets (frandom(5.85,6.65), frandom(5.32,6.75), 4, 9, "MachineGunBulletPuff");
					A_Takeinventory("AutoShotgunAmmo",1);
					A_AlertMonsters();
					A_PlaySoundeX("Weapons/AutoShotgun", "Weapon");
					A_PB_ThrottledGunSmoke(2, 1, 0);
					A_FireCustomMissile("YellowFlareSpawn",0,0,3,0);
					A_FireCustomMissile("ShakeYourAssDouble", 0, 0, 0, 0);
					A_Giveinventory("JustFiredAutoshotgun",20);
					A_GunFlash();
					A_ZoomFactor(0.98);
					PB_WeaponRecoil(-2.30,-1.88);
				}
				AG61 B 1 BRIGHT {
					A_FireProjectile("ShotgunWad",random(-2,2),0,random(12,13),-2,FPF_NOAUTOAIM,random(-2,2));
					A_ZoomFactor(0.99);
					PB_WeaponRecoil(-2.30,-1.88);
				}
				AG61 C 1 {
					A_ZoomFactor(1.0);
					A_FireCustomMissile("ShotCaseSpawn",0,0,8,-8);
				}
				AG61 D 1 {
					if(CountInv("LeftASGAmmo")>0 || CountInv("AutoShotgunAmmo")<=0 ){
						A_TakeInventory("DualFiring",1);
					}
				}
				"AG61" EFGHH 1;
				TNT1 A 0 {
					if(CountInv("AutoShotgunAmmo")<=0){
						A_GiveInventory("DualFireReload",1);
					}
				}
				Goto IdleRight_Overlay;
	
		RightMuzzleFlash:
			TNT1 A 0 A_Jump(256, "RightMuzzle1", "RightMuzzle2");
		RightMuzzle1:
			"AG64" A 1 BRIGHT;
			TNT1 A 0 A_Jump(256, "RightMuzzle3", "RightMuzzle4", "RightMuzzle5");
			Stop;
		RightMuzzle2:
			"AG64" B 1 BRIGHT;
			TNT1 A 0 A_Jump(256, "RightMuzzle3", "RightMuzzle4", "RightMuzzle5");
			Stop;
		RightMuzzle3:
			"AG64" C 1 BRIGHT;
			Stop;
		RightMuzzle4:
			"AG64" D 1 BRIGHT;
			STOP;
		RightMuzzle5:
			"AG64" E 1 BRIGHT;
			STOP;
		LeftMuzzleFlash:
			TNT1 A 0 A_Jump(256, "LeftMuzzle1", "LeftMuzzle2");
		LeftMuzzle1:
			"AG65" A 1 BRIGHT;
			TNT1 A 0 A_Jump(256, "LeftMuzzle3", "LeftMuzzle4", "LeftMuzzle5");
			Stop;
		LeftMuzzle2:
			"AG65" B 1 BRIGHT;
			TNT1 A 0 A_Jump(256, "LeftMuzzle3", "LeftMuzzle4", "LeftMuzzle5");
			Stop;
		LeftMuzzle3:
			"AG65" C 1 BRIGHT;
			Stop;
		LeftMuzzle4:
			"AG65" D 1 BRIGHT;
			STOP;
		LeftMuzzle5:
			"AG65" E 1 BRIGHT;
			STOP;
			
		WeaponSpecial:
			TNT1 A 0 {
				A_Takeinventory("GoWeaponSpecialAbility",1);
				A_GiveInventory("PB_LockScreenTilt",1);
				PB_HandleCrosshair(70);
			A_ClearOverlays(10,11);
			}
			TNT1 A 0 A_JumpIfInventory("PB_Autoshotgun", 2,"SwitchToDualWield");
			TNT1 A 0 A_Print("\ckNeed two \ctautoshotguns \c-to dual-wield");
			Goto Ready3;
				
		SwitchToDualWield:
			TNT1 A 0 {
				A_PlaySoundEx("weapons/autoshotgun/respect1", "Auto");
				if (A_CheckAkimbo()) {
					A_TakeInventory("DualWieldingAutoshotguns", 1);
					A_SetAkimbo(False);
					return ResolveState("SwitchFromDualWield");
				}
				else {
					A_GiveInventory("DualWieldingAutoshotguns", 1);
					A_SetAkimbo(True);
					return ResolveState(null);
				}
				
				}
			"AG60" ABCDEFGH 1 A_Setroll(roll-0.5, SPF_INTERPOLATE);
			"AG60" IJK 1 A_Setroll(roll+2.0, SPF_INTERPOLATE);
			"AG60" LM 1 A_Setroll(roll+1.0, SPF_INTERPOLATE);
			"AG60" N 1 A_Setroll(0, SPF_INTERPOLATE);
			Goto ReadyDualWield;
		SwitchFromDualWield:
			"AG60" NMLKJI 1 A_Setroll(roll-1.0, SPF_INTERPOLATE);
			"AG60" HGF 1 A_Setroll(roll+2.0, SPF_INTERPOLATE);
			"AG60" EDCB 1;
			"AG60" A 1 A_Setroll(0, SPF_INTERPOLATE);
			Goto Ready3;
		
		Deselect:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleCrosshair(70);
				A_ClearOverlays(10,11);
				A_TakeInventory("PB_LockScreenTilt",1);
			}
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "DualWieldDeselect");
			TNT1 A 0 A_Takeinventory("Unloading",1);
			TNT1 A 0 A_Takeinventory("RandomHeadExploder",1);
			TNT1 A 0 A_JumpIfInventory("GotMeatShield", 1, "GrabEnemy");
			"AG10" FEDCBA 1;
			TNT1 AAAAAAAAAAAAAAAAAA 0 A_Lower;
			Wait;

		DrumDeselect:
			TNT1 A 0 A_Takeinventory("Unloading",1);
			TNT1 A 0 A_Takeinventory("RandomHeadExploder",1);
			TNT1 A 0 A_JumpIfInventory("GotMeatShield", 1, "GrabEnemy");
			"AU24" EFG 0;
			"AU23" EFG 0;
			"AU02" EFG 0;
			"AU01" EFG 0;
			AU2M HGFE 1 {
				if (CountInv("AutoShotgunAmmo") == 24 ) { A_SetWeaponSprite("AU24");}
				if (CountInv("AutoShotgunAmmo") == 23 ) { A_SetWeaponSprite("AU23");}
				if (CountInv("AutoShotgunAmmo") == 2 )  { A_SetWeaponSprite("AU02");}
				if (CountInv("AutoShotgunAmmo") == 1 )  { A_SetWeaponSprite("AU01");}
				if (CountInv("AutoShotgunAmmo") == 0 )  { A_SetWeaponSprite("AU01");}
				}
			AU10 DCBA 1; //{if (CountInv("AutoshotgunDrumMag") == 1 ) { A_SetWeaponSprite("AU10");}}
			TNT1 AAAAAAAAAAAAAAAAAA 0 A_Lower;
			Wait;

		DualWieldDeselect:
			TNT1 A 0 A_Takeinventory("Unloading",1);
			TNT1 A 0 A_Takeinventory("RandomHeadExploder",1);
			TNT1 A 0 A_JumpIfInventory("GotMeatShield", 1, "GrabEnemy");
			"AG60" NMLKJI 1;
			TNT1 AAAAAAAAAAAAAAAAAA 0 A_Lower;
			Wait;

		Select:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleCrosshair(70);
				A_TakeInventory("PB_LockScreenTilt",1);
				A_ClearOverlays(10,11);
			}
			Goto SelectFirstPersonLegs;
		SelectContinue:
			TNT1 A 0 A_Takeinventory("Unloading",1);
			TNT1 A 0 A_Giveinventory("RandomHeadExploder",1);
			TNT1 A 0 PB_WeapTokenSwitch("ASGSelected");
			TNT1 A 0 ACS_NamedExecuteAlways("ToggleShotgunUpgraded",0) ;//For people who want this weapon to replace another;
			TNT1 AAAAAAAAAAAAAAAAAA 0 A_Raise;
			TNT1 AAAAAAAA 1 A_Raise;
			Wait;
		
		Fire:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleCrosshair(70);
				A_TakeInventory("PB_LockScreenTilt",1);
				A_ClearOverlays(10,11);
			}
			TNT1 A 0 A_JumpIfInventory("AutoShotgunAmmo",1,1);
			Goto Reload;
			TNT1 A 0 A_JumpIfInventory("DualWieldingAutoshotguns", 1, "FireDualWield");
			TNT1 A 0 A_JumpIfInventory("AutoshotgunDrumMag", 1, "DrumFire");
			TNT1 A 0 A_JumpIfInventory("PBAutoShotgunWasEmpty", 1, "Pump");
			TNT1 A 0 A_FireBullets (frandom(5.84,6.45), frandom(5.2,6.75), 4, 11, "ShotgunPuff");
			AG20 A 1 BRIGHT {
				A_FireBullets (frandom(5.85,6.65), frandom(5.32,6.75), 4, 9, "MachineGunBulletPuff");
				A_FireProjectile("ShotgunWad",random(-1,1),0,random(-1,1),-1,FPF_NOAUTOAIM,random(-1,1)); //Keeping the shotgun wad projectile;
				A_Takeinventory("AutoShotgunAmmo",1);
				A_AlertMonsters();
				A_PlaySoundeX("Weapons/AutoShotgun", "Weapon");
				A_PB_ThrottledGunSmoke(0, 1, 0);
				A_FireCustomMissile("ShakeYourAssDouble", 0, 0, 0, 0);
				A_FireCustomMissile("YellowFlareSpawn",0,0,0,0);
				A_Giveinventory("JustFiredAutoshotgun",20);
				A_GunFlash();
				A_ZoomFactor(0.98);
				PB_WeaponRecoil(-1.64,+0.88);
			}
			AG20 B 1 BRIGHT {
				
				A_ZoomFactor(0.99);
				PB_WeaponRecoil(-1.64,+0.88);
			}
			AG20 C 1 {
				A_ZoomFactor(1.0);
				A_FireCustomMissile("ShotCaseSpawn",0,0,4,-8);
			}
			"AG20" DEFGH 1 A_DoPBWeaponAction(WRF_NOPRIMARY|WRF_NOSECONDARY|WRF_NOBOB);
			"AG20" I 1;
			TNT1 A 0 A_Refire();
			Goto Ready3;
		
		DrumFire:
				"AU24" ABCD 0;
				"AU23" ABC 0;
				"AU02" ABC 0;
				"AU01" ABCD 0;
				"AF24" EFGHI 0;
				"AF23" EFGHI 0;
				"AF22" G 0;
				"AF03" GHI 0;
				"AF02" EFGHI 0;
				"AF01" EFGHI 0;
				TNT1 A 0 A_JumpIfInventory("PBAutoShotgunWasEmpty", 1, "Pump");
				TNT1 A 0 A_FireBullets (frandom(5.84,6.45), frandom(5.2,6.75), 4, 11, "ShotgunPuff");
				AUMD A 1 BRIGHT {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AU24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AU23");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AU02");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AU01");}
					A_FireProjectile("ShotgunWad",random(-1,1),0,random(-1,1),-1,FPF_NOAUTOAIM,random(-1,1)); //Keeping the shotgun wad projectile;
					A_FireBullets (frandom(5.85,6.65), frandom(5.32,6.75), 4, 9, "MachineGunBulletPuff");
					A_AlertMonsters();
					A_PlaySoundeX("Weapons/AutoShotgun", "Weapon");
					A_PB_ThrottledGunSmoke(0, 1, 0);
					A_FireCustomMissile("ShakeYourAssDouble", 0, 0, 0, 0);
					A_FireCustomMissile("YellowFlareSpawn",0,0,0,0);
					A_Giveinventory("JustFiredAutoshotgun",20);
					A_ZoomFactor(0.98);
					PB_WeaponRecoil(-1.64,+0.88);
				}
				AUMD B 1 BRIGHT {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AU24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AU23");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AU02");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AU01");}
					A_GunFlash();
					A_ZoomFactor(0.99);
					PB_WeaponRecoil(-1.64,+0.88);
				}
				AUMD C 1 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AU24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AU23");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AU02");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AU01");}
					A_ZoomFactor(1.0);
					A_FireCustomMissile("ShotCaseSpawn",0,0,4,-8);
					}
				AUMD D 1 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AU24");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AU01");}
					return A_DoPBWeaponAction(WRF_NOPRIMARY|WRF_NOSECONDARY|WRF_NOBOB);
					}
				AUMD EF 1 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AF24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AF23");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AF02");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AF01");}
					return A_DoPBWeaponAction(WRF_NOPRIMARY|WRF_NOSECONDARY|WRF_NOBOB);
					}
				AUMD G 1 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AF24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AF23");}
					if (CountInv("AutoShotgunAmmo") == 22 ) {A_SetWeaponSprite("AF22");}
					if (CountInv("AutoShotgunAmmo") == 3 )  {A_SetWeaponSprite("AF03");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AF02");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AF01");}
					return A_DoPBWeaponAction(WRF_NOPRIMARY|WRF_NOSECONDARY|WRF_NOBOB);
					}
				AUMD H 1 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AF24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AF23");}
					if (CountInv("AutoShotgunAmmo") == 3 )  {A_SetWeaponSprite("AF03");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AF02");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AF01");}
					return A_DoPBWeaponAction(WRF_NOPRIMARY|WRF_NOSECONDARY|WRF_NOBOB);
					}
				AUMD I 1 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AF24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AF23");}
					if (CountInv("AutoShotgunAmmo") == 3 )  {A_SetWeaponSprite("AF03");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AF02");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AF01");}
					return A_DoPBWeaponAction(WRF_NOPRIMARY|WRF_NOSECONDARY|WRF_NOBOB);
					}
				TNT1 A 0 A_Takeinventory("AutoShotgunAmmo",1);
				TNT1 A 0 A_Refire();
				Goto Ready3;
		
		AltFire:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleCrosshair(70);
				A_TakeInventory("PB_LockScreenTilt",1);
				A_ClearOverlays(10,11);
			}
			TNT1 A 0 A_JumpIfInventory("AutoShotgunAmmo",2,1);
			Goto Reload;
			TNT1 A 0 A_JumpIfInventory("DualWieldingAutoshotguns", 1, "FireDualWield");
			TNT1 A 0 A_JumpIfInventory("AutoshotgunDrumMag", 1, "DrumAltFire");
			TNT1 A 0 A_JumpIfInventory("PBAutoShotgunWasEmpty", 1, "Pump");
			TNT1 A 0 A_JumpIfInventory("PumpAutoShotgun", 1, "Pump");
			AG20 A 1 BRIGHT {
				A_FireCustomMissile("Chunk2",random(-2,2),0,18,13);
				A_FireCustomMissile("Chunk1",random(-2,2),0,15,-18);
				A_FireCustomMissile("Chunk3",random(-2,2),0,13,5);
				A_FireCustomMissile("Chunk3",random(-2,2),0,0,-15);
				A_FireCustomMissile("Chunk4",random(-2,2),0,0,-15);
				A_FireCustomMissile("Chunk1",random(-2,2),0,-13,8);
				A_FireCustomMissile("Chunk2",random(-2,2),0,-18,12);
				A_FireCustomMissile("YellowFlareSpawn",0,0,0,0);
				A_PlaySoundEx("FLAKFIRE", "Weapon");
				A_AlertMonsters();
				A_ZoomFactor(0.98);
				A_PB_ThrottledGunSmoke(0, 1, 0);
				A_FireCustomMissile("ShakeYourAssDouble", 0, 0, 0, 0);
				A_Takeinventory("AutoShotgunAmmo",2);
				A_GiveInventory("PumpAutoShotgun", 1);
				A_Giveinventory("JustFiredAutoshotgun",140);
				A_GunFlash();
				PB_WeaponRecoil(-2.04,+1.1);
			}
			TNT1 AAAAAAAA 0 BRIGHT A_FireCustomMissile("ShotgunParticles", random(-17,17), 0, -1, random(-17,17));
			AG20 B 1 BRIGHT { 
				A_ZoomFactor(0.99);
				PB_WeaponRecoil(-2.04,+1.1);
			}
			AG20 C 1 {
				A_ZoomFactor(1.0);
				A_FireCustomMissile("ShotCaseSpawn",0,0,4,-8);
				A_FireCustomMissile("ShotCaseSpawn",0,0,-4,-8);
			}
			TNT1 AA 0 A_FireProjectile("ShotgunWad",random(-1,1),0,random(-1,1),-1,FPF_NOAUTOAIM,random(-1,1)) ;//Keeping the shotgun wad projectile;
			"AG20" DEFGHI 1 A_DoPBWeaponAction(WRF_NOPRIMARY|WRF_NOSECONDARY|WRF_NOBOB);
			TNT1 A 0 A_JumpIfInventory("AutoShotgunAmmo",1,"Pump");
			Goto Ready3;
			
			
		BarrelSmoke2:
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, 0, 0, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -1, 0, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -2, 0, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -3, 2, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -4, 5, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -5, 6, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -6, 8, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -8, 10, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -9, 8, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -10, 7, 0, 0) ;//I;
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -10, 6, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -10, 5, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -10, 4, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -10, 5, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -9, 8, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -8, 10, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -6, 8, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -5, 6, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -4, 5, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -3, 2, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -2, 0, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -1, 0, 0, 0);
			Stop;
			
		Pump:
			TNT1 A 0 A_JumpIfInventory("AutoshotgunDrumMag", 1, "DrumPump");
			TNT1 A 0 {
				A_Giveinventory("PB_LockScreenTilt",1);
				A_WeaponOffset(0,32);
				A_PlaysoundEx("Ironsights", "Auto");
				
				if (CountInv("JustFiredAutoshotgun") >= 60) {
						A_Gunflash("BarrelSmoke2");
				}
			}
			AG40 ABCDEFGH 1 {
				A_SetRoll(roll-0.1,SPF_INTERPOLATE);
				A_DoPBWeaponAction(WRF_NOFIRE);
			}
			TNT1 A 0 {
				A_PlaysoundEx("H4SGCOCK", "Auto");
				A_TakeInventory("PumpAutoShotgun", 1);
			}
			AG40 IJKL 1 {
				A_SetRoll(roll-0.3,SPF_INTERPOLATE);
				A_DoPBWeaponAction(WRF_NOFIRE);
			}
			
			AG40 MNI 1{
				A_SetRoll(roll+0.4,SPF_INTERPOLATE);
				A_DoPBWeaponAction(WRF_NOFIRE);
			}
			
			AG40 HGFEDCBA 1 {
				A_SetRoll(roll+0.1,SPF_INTERPOLATE);
				A_DoPBWeaponAction(WRF_NOFIRE);
			}
			TNT1 A 0 A_Refire();
			Goto Ready3;
			
		DrumPump:
			"AS24" DEFG 0;
			"AS23" DEFG 0;
			"AS22" G 0;
			"AS03" FG 0;
			"AS02" DEFG 0;
			"AS01" DEFG 0;
			TNT1 A 0 {
				A_Giveinventory("PB_LockScreenTilt",1);
				A_WeaponOffset(0,32);
				A_PlaysoundEx("Ironsights", "Auto");
				
				if (CountInv("JustFiredAutoshotgun") >= 60) {
						A_Gunflash("BarrelSmoke2");
				}
			}
			ASMD G 1 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AS24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AS23");}
					if (CountInv("AutoShotgunAmmo") == 22 ) {A_SetWeaponSprite("AS22");}
					if (CountInv("AutoShotgunAmmo") == 3 )  {A_SetWeaponSprite("AS03");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AS02");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AS01");}
					if (CountInv("AutoShotgunAmmo") == 0 )  {A_SetWeaponSprite("AS01");}
					return A_DoPBWeaponAction(WRF_NOFIRE);
					}
			ASMD F 1 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AS24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AS23");}
					if (CountInv("AutoShotgunAmmo") == 3 )  {A_SetWeaponSprite("AS03");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AS02");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AS01");}
					if (CountInv("AutoShotgunAmmo") == 0 )  {A_SetWeaponSprite("AS01");}
					return A_DoPBWeaponAction(WRF_NOFIRE);
					}
			ASMD ED 1 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AS24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AS23");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AS02");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AS01");}
					if (CountInv("AutoShotgunAmmo") == 0 )  {A_SetWeaponSprite("AS01");}
					return A_DoPBWeaponAction(WRF_NOFIRE);
					}
			
			"AU33" CBA 1 A_DoPBWeaponAction(WRF_NOFIRE);
			"AU35" GFE 1 A_DoPBWeaponAction(WRF_NOFIRE);
			TNT1 A 0 {
				A_PlaysoundEx("H4SGCOCK", "Auto");
				A_TakeInventory("PumpAutoShotgun", 1);
			}
			"AU35" DCBBCDEFG 1 A_DoPBWeaponAction(WRF_NOFIRE);
			"AU33" ABC 1 A_DoPBWeaponAction(WRF_NOFIRE);
			ASMD DE 1 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AS24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AS23");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AS02");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AS01");}
					if (CountInv("AutoShotgunAmmo") == 0 )  {A_SetWeaponSprite("AS01");}
					return A_DoPBWeaponAction(WRF_NOFIRE);
					}
			ASMD F 1 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AS24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AS23");}
					if (CountInv("AutoShotgunAmmo") == 3 )  {A_SetWeaponSprite("AS03");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AS02");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AS01");}
					if (CountInv("AutoShotgunAmmo") == 0 )  {A_SetWeaponSprite("AS01");}
					return A_DoPBWeaponAction(WRF_NOFIRE);
					}
			ASMD G 1 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AS24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AS23");}
					if (CountInv("AutoShotgunAmmo") == 22 ) {A_SetWeaponSprite("AS22");}
					if (CountInv("AutoShotgunAmmo") == 3 )  {A_SetWeaponSprite("AS03");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AS02");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AS01");}
					if (CountInv("AutoShotgunAmmo") == 0 )  {A_SetWeaponSprite("AS01");}
					return A_DoPBWeaponAction(WRF_NOFIRE);
					}		
			TNT1 A 0 A_Refire();
			Goto Ready3;
			
		
		DrumAltFire:
				"AU24" ABCD 0;
				"AU23" ABC 0;
				"AU02" ABC 0;
				"AU01" ABCD 0;
				"AF24" EFGHI 0;
				"AF23" EFGHI 0;
				"AF22" G 0;
				"AF03" GHI 0;
				"AF02" EFGHI 0;
				"AF01" EFGHI 0;
				TNT1 A 0 A_JumpIfInventory("PumpAutoShotgun", 1, "Pump");
				AUMD A 1 BRIGHT {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AU24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AU23");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AU02");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AU01");}
					A_FireCustomMissile("Chunk2",random(-2,2),0,18,13);
					A_FireCustomMissile("Chunk1",random(-2,2),0,15,-18);
					A_FireCustomMissile("Chunk3",random(-2,2),0,13,5);
					A_FireCustomMissile("Chunk3",random(-2,2),0,0,-15);
					A_FireCustomMissile("Chunk4",random(-2,2),0,0,-15);
					A_FireCustomMissile("Chunk1",random(-2,2),0,-13,8);
					A_FireCustomMissile("Chunk2",random(-2,2),0,-18,12);
					A_FireCustomMissile("YellowFlareSpawn",0,0,0,0);
					A_PlaySoundEx("FLAKFIRE", "Weapon");
					A_AlertMonsters();
					A_ZoomFactor(0.98);
					A_PB_ThrottledGunSmoke(0, 1, 0);
					A_PB_ThrottledGunSmoke(0, 1, 0);
					A_FireCustomMissile("ShakeYourAssDouble", 0, 0, 0, 0);
					A_GiveInventory("PumpAutoShotgun", 1);
					A_Giveinventory("JustFiredAutoshotgun",140);
					A_GunFlash();
					PB_WeaponRecoil(-2.04,+1.1);
				}
				TNT1 A 0 A_Takeinventory("AutoShotgunAmmo",2);
				TNT1 AAAAAAAA 0 BRIGHT A_FireCustomMissile("ShotgunParticles", random(-17,17), 0, -1, random(-17,17));
				AUMD B 1 BRIGHT { 
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AU24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AU23");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AU02");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AU01");}
					A_ZoomFactor(0.99);
					PB_WeaponRecoil(-2.04,+1.1);
				}
				AUMD C 1 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AU24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AU23");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AU02");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AU01");}
					A_ZoomFactor(1.0);
					A_FireCustomMissile("ShotCaseSpawn",0,0,4,-8);
					A_FireCustomMissile("ShotCaseSpawn",0,0,-4,-8);
				}
				TNT1 AA 0 A_FireProjectile("ShotgunWad",random(-1,1),0,random(-1,1),-1,FPF_NOAUTOAIM,random(-1,1)) ;//Keeping the shotgun wad projectile;
				AUMD D 1 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AU24");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AU01");}
					return A_DoPBWeaponAction(WRF_NOFIRE|WRF_NOBOB);
					}
				AUMD EF 1 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AF24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AF23");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AF02");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AF01");}
					return A_DoPBWeaponAction(WRF_NOFIRE|WRF_NOBOB);
					}
				AUMD G 1 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AF24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AF23");}
					if (CountInv("AutoShotgunAmmo") == 22 ) {A_SetWeaponSprite("AF22");}
					if (CountInv("AutoShotgunAmmo") == 3 )  {A_SetWeaponSprite("AF03");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AF02");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AF01");}
					return A_DoPBWeaponAction(WRF_NOFIRE|WRF_NOBOB);
					}
				AUMD H 1 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AF24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AF23");}
					if (CountInv("AutoShotgunAmmo") == 3 )  {A_SetWeaponSprite("AF03");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AF02");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AF01");}
					return A_DoPBWeaponAction(WRF_NOFIRE|WRF_NOBOB);
					}
				AUMD I 1 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AF24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AF23");}
					if (CountInv("AutoShotgunAmmo") == 3 )  {A_SetWeaponSprite("AF03");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AF02");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AF01");}
					return A_DoPBWeaponAction(WRF_NOFIRE|WRF_NOBOB);
					}
				AUMD G 1 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AF24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AF23");}
					if (CountInv("AutoShotgunAmmo") == 22 ) {A_SetWeaponSprite("AF22");}
					if (CountInv("AutoShotgunAmmo") == 3 )  {A_SetWeaponSprite("AF03");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AF02");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AF01");}
					return A_DoPBWeaponAction(WRF_NOFIRE|WRF_NOBOB);
					}
				AUMD H 1 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AF24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AF23");}
					if (CountInv("AutoShotgunAmmo") == 3 )  {A_SetWeaponSprite("AF03");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AF02");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AF01");}
					return A_DoPBWeaponAction(WRF_NOFIRE|WRF_NOBOB);
					}
				AUMD I 1 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AF24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AF23");}
					if (CountInv("AutoShotgunAmmo") == 3 )  {A_SetWeaponSprite("AF03");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AF02");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AF01");}
					return A_DoPBWeaponAction(WRF_NOFIRE|WRF_NOBOB);
					}
				TNT1 A 0 A_JumpIfInventory("AutoShotgunAmmo",1,"Pump");
				Goto Ready3;
		
		
		BarrelSmoke3:
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, 0, 0, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -1, 0, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -2, 0, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -3, 2, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -4, 5, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -5, 6, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -7, 8, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -9, 10, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -10, 12, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -12, 13, 0, 0) ;//I;
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -14, 14, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -16, 15, 0, 0);
			Stop;
		BarrelSmoke4:
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -14, 11, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -14, 10, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -15, 9, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -15, 9, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -14, 10, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -14, 11, 0, 0);
			Stop;
		
		// Let's get complicated...
		
		ReloadDualWieldStart:
			TNT1 A 0 {
				A_Giveinventory("PB_LockScreenTilt",1);
				A_ClearOverlays(10,11);
				A_WeaponOffset(0,32);
			}
			TNT1 A 0 A_JumpIfInventory("NewShell",1,1);
			Goto Ready3;
			TNT1 A 0 {
				if(CountInv("AutoshotgunAmmo") == 24 && CountInv("LeftASGAmmo") == 24 && CountInv("AutoshotgunDrumMag") ==1) {
					return ResolveState("Ready3");
				}
				else if(CountInv("AutoshotgunAmmo") == 12 && CountInv("LeftASGAmmo") == 12 && CountInv("AutoshotgunDrumMag") !=1) {
					return ResolveState("Ready3");
				}
				return ResolveState(null);
			}
			TNT1 A 0 A_PlaysoundEx("Ironsights", "Auto");
			"AG60" NMLKJI 1 A_Setroll(roll-1.0, SPF_INTERPOLATE);
			"AG60" HGF 1 A_Setroll(roll+2.0, SPF_INTERPOLATE);
			"AG60" EDCB 1;
			"AG60" A 1 A_Setroll(0, SPF_INTERPOLATE);
			TNT1 A 0 A_JumpIfInventory("AutoshotgunDrumMag", 1, "RightDrumReload");
			TNT1 A 0 A_JumpIfInventory("NewShell", 1, "RightReloadStart");
			TNT1 A 0 A_PlaySoundEx("weapons/empty", "Weapon");
			Goto ReadyDualWield;
		
		RightReloadStart:
			TNT1 A 0 {
				if (CountInv("AutoShotgunAmmo") < 1) {
					return ResolveState("RightEmptyReload");
				}
				if (CountInv("AutoShotgunAmmo") == 12) {
					return ResolveState("LeftReloadStart");
				}
				return ResolveState(null);
			}
			Goto RightBeginNormalReload;
		RightEmptyReload:
			TNT1 A 0 {
				if (CountInv("JustFiredAutoshotgun") >= 60) {
						A_Gunflash("BarrelSmoke3");
				}
			}
			AG31 ABCD 1 {
				
				A_SetRoll(roll+1.0,SPF_INTERPOLATE);
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
				
			}
			TNT1 A 0 A_PlaySoundEx("weapons/sgmvpump","Auto");
			AG31 EF 1 {
				A_SetRoll(roll-2.0,SPF_INTERPOLATE);
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			}
			AG31 GHIJKL 1 {
				A_SetRoll(roll-1.0,SPF_INTERPOLATE);
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			}
			AG31 M 1 {
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			}
			AG31 N 1 {
				A_PlaySoundEx("insertshell","Auto");
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			}
			AG31 OP 1 {
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			}
			AG31 Q 1 {
				A_PlaySoundEx("weapons/sgpump","Auto");
				A_Giveinventory("AutoShotgunAmmo",1);
				A_Takeinventory("PBAutoShotgunWasEmpty", 1);
				A_Takeinventory("PBAutoShotgunHasUnloaded",1);
				A_Takeinventory("NewShell",1);
				A_TakeInventory("PumpAutoShotgun", 1);
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			}
			AG31 RSTUV 1 {
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			}
			Goto RightNormalReload;
		RightBeginNormalReload:
			TNT1 A 0 {
				A_Giveinventory("PB_LockScreenTilt",1);
				A_WeaponOffset(0,32);
				A_PlaysoundEx("Ironsights", "Auto");
				if (CountInv("JustFiredAutoshotgun") >= 60) {
						A_Gunflash("BarrelSmoke3");
				}
			}
			AG30 ABCD 1 {
				A_SetRoll(roll+1.0,SPF_INTERPOLATE);
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			}
			AG30 EF 1 {
				A_SetRoll(roll-2.0,SPF_INTERPOLATE);
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			}
			AG30 GHIJKL 1 {
				A_SetRoll(roll-1.0,SPF_INTERPOLATE);
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			}
		RightNormalReload:
			TNT1 A 0 A_JumpIf(CountInv("NewShell") == 0,"RightReloadFinished");
			TNT1 A 0 A_JumpIfInventory("AutoShotgunAmmo",12,"RightReloadFinished");
			TNT1 A 0 {
				if (CountInv("JustFiredAutoshotgun") >= 60) {
						A_Gunflash("BarrelSmoke4");
				}
			}
			"AG30" LMN 1;
			AG30 O 1 { 
				A_PlaySoundEx("insertshell","Auto");
				A_Giveinventory("AutoShotgunAmmo",1);
				A_Takeinventory("NewShell",1);
				A_Takeinventory("PBAutoShotgunWasEmpty", 1);
				A_SetPitch(pitch-0.2,SPF_INTERPOLATE);
				A_SetAngle(angle+0.2, SPF_INTERPOLATE);
				A_SetRoll(roll-0.4,SPF_INTERPOLATE);
			}
			AG30 PQ 1 {
				A_SetPitch(pitch+0.1,SPF_INTERPOLATE);
				A_SetAngle(angle-0.1, SPF_INTERPOLATE);
				A_SetRoll(roll+0.2,SPF_INTERPOLATE);
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
				if (PressingFire() || PressingAltFire()) {
					return ResolveState("RightReloadFinished");
				}
				return ResolveState(null);
				
			}
			Loop;
		RightReloadFinished:
			TNT1 A 0 {
				A_Takeinventory("PB_LockScreenTilt",1);
				A_WeaponOffset(0,32);
				A_PlaysoundEx("Ironsights", "Auto");
				if (CountInv("JustFiredAutoshotgun") >= 60) {
						A_Gunflash("BarrelSmoke5");
				}
			}
			AG30 LKJIHG 1 {
				A_SetRoll(roll+1.0,SPF_INTERPOLATE);
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			}
			AG30 FEDCBA 1 {
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			}
			TNT1 A 0 {
				if (PressingFire() || PressingAltFire()) {
					return ResolveState("ReloadDualWieldEnd");
				}
				if (CountInv("LeftASGAmmo") < 12 && CountInv("NewShell") >= 1) {
					return ResolveState("LeftReloadSwitch");
				}
				return ResolveState(null);
			}
			Goto ReloadDualWieldEnd;
			
		LeftReloadSwitch:
			"AG10" FEDCBA 1;
			TNT1 A 5;
			"AG10" ABCDEF 1;
		LeftReloadStart:
			TNT1 A 0 {
				if (CountInv("LeftASGAmmo") < 1) {
					return ResolveState("LeftEmptyReload");
				}
				return ResolveState(null);
			}
			Goto LeftBeginNormalReload;
		LeftEmptyReload:
			TNT1 A 0 {
				if (CountInv("JustFiredAutoshotgun") >= 60) {
						A_Gunflash("BarrelSmoke3");
				}
			}
			AG31 ABCD 1 {
				A_SetRoll(roll+1.0,SPF_INTERPOLATE);
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			}
			TNT1 A 0 A_PlaySoundEx("weapons/sgmvpump","Auto");
			AG31 EF 1 {
				A_SetRoll(roll-2.0,SPF_INTERPOLATE);
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			}
			AG31 GHIJKL 1 {
				A_SetRoll(roll-1.0,SPF_INTERPOLATE);
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			}
			AG31 M 1 {
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			}
			AG31 N 1 {
				A_PlaySoundEx("insertshell","Auto");
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			}
			AG31 OP 1 {
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			}
			AG31 Q 1 {
				A_PlaySoundEx("weapons/sgpump","Auto");
				A_Giveinventory("LeftASGAmmo",1);
				A_Takeinventory("PBAutoShotgunWasEmpty", 1);
				A_Takeinventory("PBAutoShotgunHasUnloaded",1);
				A_Takeinventory("NewShell",1);
				A_TakeInventory("PumpAutoShotgun", 1);
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			}
			AG31 RSTUV 1 {
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			}
			Goto LeftNormalReload;
			
		LeftBeginNormalReload:
			AG30 ABCD 1 {
				A_SetRoll(roll+1.0,SPF_INTERPOLATE);
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			}
			AG30 EF 1 {
				A_SetRoll(roll-2.0,SPF_INTERPOLATE);
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			}
			AG30 GHIJKL 1 {
				A_SetRoll(roll-1.0,SPF_INTERPOLATE);
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			}
		LeftNormalReload:
			TNT1 A 0 A_JumpIf(CountInv("NewShell") == 0,"LeftReloadFinished");
			TNT1 A 0 A_JumpIfInventory("LeftASGAmmo",12,"LeftReloadFinished");
			TNT1 A 0 {
				if (CountInv("JustFiredAutoshotgun") >= 60) {
						A_Gunflash("BarrelSmoke4");
				}
			}
			AG30 LMN 1 {
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			}
			AG30 O 1 { 
				A_PlaySoundEx("insertshell","Auto");
				A_Giveinventory("LeftASGAmmo",1);
				A_Takeinventory("NewShell",1);
				A_Takeinventory("LeftPBAutoShotgunWasEmpty", 1);
				A_SetPitch(pitch-0.2,SPF_INTERPOLATE);
				A_SetAngle(angle+0.2, SPF_INTERPOLATE);
				A_SetRoll(roll-0.4,SPF_INTERPOLATE);
			}
			AG30 PQ 1 {
				A_SetPitch(pitch+0.1,SPF_INTERPOLATE);
				A_SetAngle(angle-0.1, SPF_INTERPOLATE);
				A_SetRoll(roll+0.2,SPF_INTERPOLATE);
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
				if (PressingFire() || PressingAltFire()) {
					return ResolveState("LeftReloadFinished");
				}
				return ResolveState(null);
			}
			Loop;
		LeftReloadFinished:
			TNT1 A 0 {
				A_Takeinventory("PB_LockScreenTilt",1);
				A_WeaponOffset(0,32);
				A_PlaysoundEx("Ironsights", "Auto");
				if (CountInv("JustFiredAutoshotgun") >= 60) {
						A_Gunflash("BarrelSmoke5");
				}
			}
			AG30 LKJIHG 1 {
				A_SetRoll(roll+1.0,SPF_INTERPOLATE);
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			}
			AG30 FEDCBA 1 {
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			}
			TNT1 A 0 {
				if (PressingFire() || PressingAltFire()) {
					return ResolveState("ReloadDualWieldEnd");
				}
				return ResolveState(null);
			}
		ReloadDualWieldEnd:
			"AG60" ABCDEFGH 1 A_Setroll(roll-0.5, SPF_INTERPOLATE);
			"AG60" IJK 1 A_Setroll(roll+2.0, SPF_INTERPOLATE);
			"AG60" LM 1 A_Setroll(roll+1.0, SPF_INTERPOLATE);
			"AG60" N 1 A_Setroll(0, SPF_INTERPOLATE);
			Goto ReadyDualWield;
		
		// Dual Drum Reload
		RightEmptyDrumReload:
			TNT1 A 0 A_PlaysoundEx("Ironsights", "Auto");
			"AU34" ABCD 1;
			TNT1 A 0 A_PlaySoundEx("weapons/sgmvpump","Auto");
			"AU34" EFGHIJKLMNO 1;
			TNT1 A 0 A_PlaysoundEx("weapons/shotgun/detach", "Auto");
			"AU34" PQRSTUV 1;
			TNT1 A 0 A_PlaysoundEx("weapons/riflemagslap", "Auto");
			"AU34" WXYZ 1;
			"AU35" ABCD 1;
			TNT1 A 0 A_PlaySoundEx("weapons/sgpump","Auto");
			"AU35" EFG 1;
			Goto RightDrumReloadEnd;
		RightDrumReload:
			TNT1 A 0 A_JumpIfInventory("AutoShotgunAmmo",24,"LeftDrumReload");
			TNT1 A 0 A_JumpIfInventory("NewShell",1,2);
			TNT1 A 0 A_PlaySoundEx("weapons/empty", "Weapon");
			Goto Ready3;
		RightDrumReloadAnimation:
			TNT1 A 0 A_JumpIfInventory("PBAutoShotgunHasUnloaded",1,"RightBeginNormalDrumReload");
			TNT1 A 0 A_PlaysoundEx("weapons/autoshotgun/drumreload1", "Auto");
			"AU30" ABCDEFGHIJKLM 1;
			TNT1 A 0 A_PlaysoundEx("weapons/autoshotgun/drumreload2", "Auto");
			"AU30" NO 1;
			TNT1 A 0 {
				A_FireCustomMissile("EmptyASGDrum",-5,0,0,-4);
				if (CountInv("AutoShotgunAmmo") < 1) {
					return ResolveState("RightEmptyDrumReload");
				}
				return ResolveState(null);
			}
		RightBeginNormalDrumReload:
			TNT1 A 0 A_PlaysoundEx("Ironsights", "Auto");
			"AU31" ABCDEFGHIJKLMNOP 1;
			TNT1 A 0 A_PlaysoundEx("weapons/shotgun/detach", "Auto");
			"AU31" QRSTUVWXY 1;
			TNT1 A 0 A_PlaysoundEx("weapons/riflemagslap", "Auto");
			"AU31" Z 1;
			"AU32" ABCDEFGH 1;
		RightDrumReloadEnd:
			"AU33" ABCDEFG 1;
		RightDrumInsertBullets:
			TNT1 A 0 A_JumpIfInventory("AutoShotgunAmmo",24,"LeftReloadSwitch_Dual");
			TNT1 A 0 A_JumpIfInventory("NewShell",1,1);
			Goto ReloadDualWieldEnd;
			TNT1 A 0 {
				A_Giveinventory("AutoShotgunAmmo",1);
				A_Takeinventory("NewShell",1);
				A_Takeinventory("PBAutoShotgunWasEmpty", 1);
				A_TakeInventory("PumpAutoShotgun", 1);
				A_Takeinventory("PBAutoShotgunHasUnloaded",1);
			}
			Loop;
		
		
		LeftReloadSwitch_Dual:
			"AU10" HGFE 1;
			TNT1 A 5;
			TNT1 A 0 A_JumpIfInventory("LeftPBAutoshotgunHasUnloaded",1,"LeftReloadSwitch_DualUnload");
			"AU10" EFGH 1;
			Goto LeftDrumReload;
		LeftReloadSwitch_DualUnload:
			"AG10" ABCDEFFFF 1;
			Goto LeftDrumReload;
			
		LeftEmptyDrumReload:
			TNT1 A 0 A_PlaysoundEx("Ironsights", "Auto");
			"AU34" ABCD 1;
			TNT1 A 0 A_PlaySoundEx("weapons/sgmvpump","Auto");
			"AU34" EFGHIJKLMNO 1;
			TNT1 A 0 A_PlaysoundEx("weapons/shotgun/detach", "Auto");
			"AU34" PQRSTUV 1;
			TNT1 A 0 A_PlaysoundEx("weapons/riflemagslap", "Auto");
			"AU34" WXYZ 1;
			"AU35" ABCD 1;
			TNT1 A 0 A_PlaySoundEx("weapons/sgpump","Auto");
			"AU35" EFG 1;
			Goto LeftDrumReloadEnd;
		LeftDrumReload:
			TNT1 A 0 A_JumpIfInventory("LeftASGAmmo",24,"Ready3");
			TNT1 A 0 A_JumpIfInventory("NewShell",1,2);
			TNT1 A 0 A_PlaySoundEx("weapons/empty", "Weapon");
			Goto Ready3;
		LeftDrumReloadAnimation:
			TNT1 A 0 A_JumpIfInventory("LeftPBAutoShotgunHasUnloaded",1,"LeftBeginNormalDrumReload");
			TNT1 A 0 A_PlaysoundEx("weapons/autoshotgun/drumreload1", "Auto");
			"AU30" ABCDEFGHIJKLM 1;
			TNT1 A 0 A_PlaysoundEx("weapons/autoshotgun/drumreload2", "Auto");
			"AU30" NO 1;
			TNT1 A 0 {
				A_FireCustomMissile("EmptyASGDrum",-5,0,0,-4);
				if (CountInv("LeftASGAmmo") < 1) {
					return ResolveState("LeftEmptyDrumReload");
				}
				return ResolveState(null);
			}
		LeftBeginNormalDrumReload:
			TNT1 A 0 A_Takeinventory("LeftPBAutoShotgunHasUnloaded",1);
			TNT1 A 0 A_PlaysoundEx("Ironsights", "Auto");
			"AU31" ABCDEFGHIJKLMNOP 1;
			TNT1 A 0 A_PlaysoundEx("weapons/shotgun/detach", "Auto");
			"AU31" QRSTUVWXY 1;
			TNT1 A 0 A_PlaysoundEx("weapons/riflemagslap", "Auto");
			"AU31" Z 1;
			"AU32" ABCDEFGH 1;
		LeftDrumReloadEnd:
			"AU33" ABCDEFG 1;
		LeftDrumInsertBullets:
			TNT1 A 0 A_JumpIfInventory("LeftASGAmmo",24,"ReloadDualWieldEnd");
			TNT1 A 0 A_JumpIfInventory("NewShell",1,1);
			Goto ReloadDualWieldEnd;
			TNT1 A 0 {
				A_Giveinventory("LeftASGAmmo",1);
				A_Takeinventory("NewShell",1);
				A_Takeinventory("PBAutoShotgunWasEmpty", 1);
				A_TakeInventory("PumpAutoShotgun", 1);
				A_Takeinventory("PBAutoShotgunHasUnloaded",1);
			}
			Loop;
			
			
		
		// End of Dual Wield
			
		Reload:
			TNT1 A 0 A_JumpIfInventory("DualWieldingAutoshotguns", 1, "ReloadDualWieldStart");
			TNT1 A 0 A_JumpIfInventory("AutoshotgunDrumMag", 1, "DrumReload");
			TNT1 A 0 A_JumpIfInventory("AutoShotgunAmmo", 12, "Ready3");
			TNT1 A 0 A_JumpIfInventory("NewShell", 1, 2);
			TNT1 A 0 A_PlaySoundEx("weapons/empty", "Weapon");
			Goto Ready3;
		ReloadAnimation:
			TNT1 A 0 {
				if (CountInv("AutoShotgunAmmo") < 1) {
					return ResolveState("EmptyReload");
				}
				return ResolveState(null);
			}
			Goto BeginNormalReload;
		EmptyReload:
			TNT1 A 0 {
				A_Giveinventory("PB_LockScreenTilt",1);
				A_WeaponOffset(0,32);
				A_PlaysoundEx("Ironsights", "Auto");
				if (CountInv("JustFiredAutoshotgun") >= 60) {
						A_Gunflash("BarrelSmoke3");
				}
			}
			AG31 ABCD 1 {
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
				A_SetRoll(roll+1.0,SPF_INTERPOLATE);
			}
			TNT1 A 0 A_PlaySoundEx("weapons/sgmvpump","Auto");
			AG31 EF 1 {
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
				A_SetRoll(roll-2.0,SPF_INTERPOLATE);
			}
			AG31 GHIJKL 1 {
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
				A_SetRoll(roll-1.0,SPF_INTERPOLATE);
			}
			"AG31" M 1 A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			AG31 N 1 {
				A_PlaySoundEx("insertshell","Auto");
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			}
			"AG31" OP 1 A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			AG31 Q 1 {
				A_PlaySoundEx("weapons/sgpump","Auto");
				A_Giveinventory("AutoShotgunAmmo",1);
				A_Takeinventory("PBAutoShotgunWasEmpty", 1);
				A_Takeinventory("PBAutoShotgunHasUnloaded",1);
				A_Takeinventory("NewShell",1);
				A_TakeInventory("PumpAutoShotgun", 1);
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			}
			"AG31" RSTUV 1 A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			Goto NormalReload;
		BeginNormalReload:
			TNT1 A 0 {
				A_Giveinventory("PB_LockScreenTilt",1);
				A_WeaponOffset(0,32);
				A_PlaysoundEx("Ironsights", "Auto");
				if (CountInv("JustFiredAutoshotgun") >= 60) {
						A_Gunflash("BarrelSmoke3");
				}
			}
			AG30 ABCD 1 {
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
				A_SetRoll(roll+1.0,SPF_INTERPOLATE);
			}
			AG30 EF 1 {
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
				A_SetRoll(roll-2.0,SPF_INTERPOLATE);
			}
			AG30 GHIJKL 1 {
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
				A_SetRoll(roll-1.0,SPF_INTERPOLATE);
			}
		NormalReload:
			TNT1 A 0 A_JumpIf(CountInv("NewShell") == 0,"ReloadFinished");
			TNT1 A 0 A_JumpIfInventory("AutoShotgunAmmo",12,"ReloadFinished");
			TNT1 A 0 {
				if (CountInv("JustFiredAutoshotgun") >= 60) {
						A_Gunflash("BarrelSmoke4");
				}
			}
			"AG30" L 1 A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			"AG30" MN 1 A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			AG30 O 1 { 
				A_PlaySoundEx("insertshell","Auto");
				A_Giveinventory("AutoShotgunAmmo",1);
				A_Takeinventory("NewShell",1);
				A_Takeinventory("PBAutoShotgunWasEmpty", 1);
				A_SetPitch(pitch-0.2,SPF_INTERPOLATE);
				A_SetAngle(angle+0.2, SPF_INTERPOLATE);
				A_SetRoll(roll-0.4,SPF_INTERPOLATE);
			}
			AG30 PQ 1 {
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
				A_SetPitch(pitch+0.1,SPF_INTERPOLATE);
				A_SetAngle(angle-0.1, SPF_INTERPOLATE);
				A_SetRoll(roll+0.2,SPF_INTERPOLATE);
				if (PressingFire() || PressingAltFire()) {
					return ResolveState("ReloadFinished");
				}
				return ResolveState(null);
			}
			Loop;
		ReloadFinished:
			TNT1 A 0 {
				A_Takeinventory("PB_LockScreenTilt",1);
				A_WeaponOffset(0,32);
				A_PlaysoundEx("Ironsights", "Auto");
				if (CountInv("JustFiredAutoshotgun") >= 60) {
						A_Gunflash("BarrelSmoke5");
				}
			}
			AG30 LKJIHG 1 {
				A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
				A_SetRoll(roll+1.0,SPF_INTERPOLATE);
			}
			"AG30" FEDCBA 1 A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			TNT1 A 0 A_JumpIfInventory("DualWieldingAutoshotguns", 1, "ReloadDualWieldEnd");
			Goto Ready3;
			
			
		
		BarrelSmoke5:
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -11, 10, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -10, 10, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -10, 10, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -10, 12, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -9, 8, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -8, 10, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -6, 8, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -5, 6, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -4, 5, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -3, 2, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -2, 0, 0, 0);
			TNT1 A 1 A_FireCustomMissile("GunBarrelSmoke", 0, 0, -1, 0, 0, 0);
			Stop;

		// Drum Reload
		EmptyDrumReload:
			"AV24" LMN 0;
			"AV01" LMN 0;
			"AV02" N 0;
			TNT1 A 0 A_PlaysoundEx("Ironsights", "Auto");
			"AU34" ABCD 1;
			TNT1 A 0 A_PlaySoundEx("weapons/sgmvpump","Auto");
			"AU34" EFGHIJK 1;
			AVMD LM 1 {
					if (CountInv("NewShell") >= 24 ) {A_SetWeaponSprite("AV24");}
					if (CountInv("NewShell") <= 1 )  {A_SetWeaponSprite("AV01");}	
					}
			AVMD N 1 {
					if (CountInv("NewShell") >= 24 ) {A_SetWeaponSprite("AV24");}
					if (CountInv("NewShell") == 2 )  {A_SetWeaponSprite("AV02");}	
					if (CountInv("NewShell") <= 1 )  {A_SetWeaponSprite("AV01");}	
					}
			"AU34" O 1;
			TNT1 A 0 A_PlaysoundEx("weapons/shotgun/detach", "Auto");
			"AU34" PQRSTUV 1;
			TNT1 A 0 A_PlaysoundEx("weapons/riflemagslap", "Auto");
			"AU34" WXYZ 1;
			"AU35" ABCD 1;
			TNT1 A 0 A_PlaySoundEx("weapons/sgpump","Auto");
			"AU35" EFG 1;
			Goto DrumReloadEnd;
		DrumReload:
			TNT1 A 0 A_JumpIfInventory("AutoShotgunAmmo",24,"Ready3");
			TNT1 A 0 A_JumpIfInventory("NewShell",1,2);
			TNT1 A 0 A_PlaySoundEx("weapons/empty", "Weapon");
			Goto Ready3;
		DrumReloadAnimation:
			"AR24" ABCDEFGHIJ 0;
			"AR23" ABCDEFGHIJ 0;
			"AR22" ABCDEFGHIJ 0;
			"AR03" ABCDEFGHIJ 0;
			"AR02" ABCDEFGHIJ 0;
			"AR01" ABCDEFGHIJ 0;
			TNT1 A 0 A_JumpIfInventory("PBAutoShotgunHasUnloaded",1,"BeginNormalDrumReload");
			TNT1 A 0 A_PlaysoundEx("weapons/autoshotgun/drumreload1", "Auto");
			ARMD ABCDEFGHIJ 1 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AR24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AR23");}
					if (CountInv("AutoShotgunAmmo") == 22 ) {A_SetWeaponSprite("AR22");}
					if (CountInv("AutoShotgunAmmo") == 3 )  {A_SetWeaponSprite("AR03");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AR02");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AR01");}
					if (CountInv("AutoShotgunAmmo") == 0 )  {A_SetWeaponSprite("AR01");}
					} 
			ARMD K 1 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AR24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AR23");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AR01");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AR01");}
					if (CountInv("AutoShotgunAmmo") == 0 )  {A_SetWeaponSprite("AR01");}
					}
			ARMD L 1 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AR24");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AR01");}
					if (CountInv("AutoShotgunAmmo") == 0 )  {A_SetWeaponSprite("AR01");}
					}
			ARMD M 1 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AR24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AR23");}
					}
			TNT1 A 0 A_PlaysoundEx("weapons/autoshotgun/drumreload2", "Auto");
			"AU30" NO 1;
			TNT1 A 0 {
				A_FireCustomMissile("EmptyASGDrum",-5,0,0,-4);
				if (CountInv("AutoShotgunAmmo") < 1) {
					return ResolveState("EmptyDrumReload");
				}
				return ResolveState(null);
			}
		BeginNormalDrumReload:
			TNT1 A 0 A_PlaysoundEx("Ironsights", "Auto");
			"AU31" ABCDEFGHI 1;
		ASGDrumRespect:
			"AT24" MNO 0;
			"AT01" MNO 0;
			"AT02" NO 0;
			"AU31" JKL 1;
			ATMD M 1 {
					if (CountInv("AutoShotgunAmmo") + CountInv("NewShell") >= 24 ) {A_SetWeaponSprite("AT24");}
					if (CountInv("AutoShotgunAmmo") + CountInv("NewShell") <= 1 )  {A_SetWeaponSprite("AT01");}	
					}
			ATMD NO 1 {
					if (CountInv("AutoShotgunAmmo") + CountInv("NewShell") >= 24 ) {A_SetWeaponSprite("AT24");}
					if (CountInv("AutoShotgunAmmo") + CountInv("NewShell") == 2 )  {A_SetWeaponSprite("AT02");}	
					if (CountInv("AutoShotgunAmmo") + CountInv("NewShell") <= 1 )  {A_SetWeaponSprite("AT01");}	
					}
			"AU31" P 1;
			TNT1 A 0 A_PlaysoundEx("weapons/shotgun/detach", "Auto");
			"AU31" QRSTUVWXY 1;
			TNT1 A 0 A_PlaysoundEx("weapons/riflemagslap", "Auto");
			"AU31" Z 1;
			"AU32" ABCDEFGH 1;
		DrumReloadEnd:
			"AU33" ABC 1;
		DrumInsertBullets:
			TNT1 A 0 A_JumpIfInventory("AutoShotgunAmmo",24,"FinishDrumReload");
			TNT1 A 0 A_JumpIfInventory("NewShell",1,1);
			Goto FinishDrumReload;
			TNT1 A 0 {
				A_Giveinventory("AutoShotgunAmmo",1);
				A_Takeinventory("NewShell",1);
				A_Takeinventory("PBAutoShotgunWasEmpty", 1);
				A_TakeInventory("PumpAutoShotgun", 1);
				A_Takeinventory("PBAutoShotgunHasUnloaded",1);
			}
			Loop;
		FinishDrumReload:
			"AS24" DEFG 0;
			"AS23" DEFG 0;
			"AS22" G 0;
			"AS03" FG 0;
			"AS02" DEFG 0;
			"AS01" DEFG 0;
			ASMD DE 1 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AS24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AS23");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AS02");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AS01");}
					if (CountInv("AutoShotgunAmmo") == 0 )  {A_SetWeaponSprite("AS01");}
					}
			ASMD F 1 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AS24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AS23");}
					if (CountInv("AutoShotgunAmmo") == 3 )  {A_SetWeaponSprite("AS03");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AS02");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AS01");}
					if (CountInv("AutoShotgunAmmo") == 0 )  {A_SetWeaponSprite("AS01");}
					}
			ASMD G 1 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AS24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AS23");}
					if (CountInv("AutoShotgunAmmo") == 22 ) {A_SetWeaponSprite("AS22");}
					if (CountInv("AutoShotgunAmmo") == 3 )  {A_SetWeaponSprite("AS03");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AS02");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AS01");}
					if (CountInv("AutoShotgunAmmo") == 0 )  {A_SetWeaponSprite("AS01");}
					}
			TNT1 A 0 A_JumpIfInventory("DualWieldingAutoshotguns", 1, "ReloadDualWieldEnd");
			Goto Ready3;
		
		UnloadDualWield:
			TNT1 A 0 {
				A_Giveinventory("PB_LockScreenTilt",1);
				A_ClearOverlays(10,11);
				A_WeaponOffset(0,32);
			}
			TNT1 A 0 A_JumpIfInventory("AutoShotgunAmmo",1,1);
			Goto UnloadLeftOnly;
			TNT1 A 0 A_JumpIfInventory("AutoshotgunDrumMag", 1, "UnloadDualDrum");
			"AG60" NMLKJI 1 A_Setroll(roll-1.0, SPF_INTERPOLATE);
			"AG60" HGF 1 A_Setroll(roll+2.0, SPF_INTERPOLATE);
			"AG60" EDCB 1;
			"AG60" A 3 A_Setroll(0, SPF_INTERPOLATE);
			Goto StartUnloadAnim;
			
		Unload:
			TNT1 A 0 {
				A_Giveinventory("PB_LockScreenTilt",1);
				A_WeaponOffset(0,32);
				A_PlaysoundEx("Ironsights", "Auto");
				A_GiveInventory("PBAutoShotgunWasEmpty", 1);
				A_Takeinventory("Unloading",1);
				A_ClearOverlays(10,11);
			}
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "UnloadDualWield");
			TNT1 A 0 A_JumpIfInventory("AutoshotgunDrumMag", 1, "DrumUnload");
			TNT1 A 0 A_JumpIfInventory("AutoShotgunAmmo",1,1);
			Goto Ready3;
		StartUnloadAnim:
			"AG40" ABCDEFGH 1 A_DoPBWeaponAction;
		RemoveBullets:
			TNT1 A 0 A_JumpIfInventory("AutoShotgunAmmo",1,1);
			Goto FinishUnload;
			TNT1 A 0 {
				A_Takeinventory("AutoShotgunAmmo",1);
				A_Giveinventory("NewShell",1);
				A_PlaysoundEx("H4SGCOCK", "Weapon");
			}
			"AG40" IJKLL 1 A_DoPBWeaponAction;
			"AG40" MN 1 A_DoPBWeaponAction;
			Goto RemoveBullets;
		FInishUnload:
			"AG40" IHGFEDCBA 1 A_DoPBWeaponAction;
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "UnloadNextGun");
			TNT1 A 0 A_Giveinventory("PBAutoShotgunWasEmpty",1);
			TNT1 A 0 A_Takeinventory("Unloading",1);
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "FinishUnloadDualWield");
			Goto Ready3;
		
		UnloadLeftOnly:
			TNT1 A 0 {
				if(CountInv("AutoshotgunAmmo") < 1 && CountInv("LeftASGAmmo") < 1) {
					return ResolveState("Ready3");
				}
				return ResolveState(null);
			}
			"AG60" NMLKJI 1;
			Goto StartUnloadLeftGun;
		UnloadNextGun:
			"AG10" FEDCBA 1;
			TNT1 A 0 A_Giveinventory("LeftPBAutoShotgunWasEmpty",1);
			TNT1 A 0 A_JumpIfInventory("LeftASGAmmo",1,1);
			Goto FinishUnloadDualWield;
		StartUnloadLeftGun:
			TNT1 A 5;
			TNT1 A 0 A_JumpIfInventory("AutoshotgunDrumMag", 1, "BeginLeftDrumUnload");
		UnloadLeftGun:
			"AG10" ABCDEFGGG 1;
			"AG40" ABCDEFGH 1 A_DoPBWeaponAction;
		RemoveBullets_Left:
			TNT1 A 0 A_JumpIfInventory("LeftASGAmmo",1,1);
			Goto FInishUnloadLeft;
			TNT1 A 0 {
				A_Takeinventory("LeftASGAmmo",1);
				A_Giveinventory("NewShell",1);
				A_PlaysoundEx("H4SGCOCK", "Weapon");
			}
			"AG40" IJKLL 1 A_DoPBWeaponAction;
			"AG40" MN 1 A_DoPBWeaponAction;
			Goto RemoveBullets_Left;
		FInishUnloadLeft:
		"AG40" IHGFEDCBA 1 A_DoPBWeaponAction;
		TNT1 A 0 A_GiveInventory("LeftPBAutoShotgunWasEmpty");
		FinishUnloadDualWield:
		"AG60" ABCDEFGH 1 A_Setroll(roll-0.5, SPF_INTERPOLATE);
			"AG60" IJK 1 A_Setroll(roll+2.0, SPF_INTERPOLATE);
			"AG60" LM 1 A_Setroll(roll+1.0, SPF_INTERPOLATE);
			"AG60" N 1 A_Setroll(0, SPF_INTERPOLATE);
			Goto ReadyDualWield;
		
		UnloadDualDrum:
			TNT1 A 0 {
				if(CountInv("PBAutoshotgunHasUnloaded") == 1 && CountInv("LeftPBAutoshotgunHasUnloaded") == 1) {
					return ResolveState("Ready3");
				}
				return ResolveState(null);
			}
			"AG60" NMLKJI 1 A_Setroll(roll-1.0, SPF_INTERPOLATE);
			"AG60" HGF 1 A_Setroll(roll+2.0, SPF_INTERPOLATE);
			"AG60" EDCB 1;
			TNT1 A 0 A_Setroll(0, SPF_INTERPOLATE);
			AU2M H 3 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AU24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AU23");}
					if (CountInv("AutoShotgunAmmo") == 22 ) {A_SetWeaponSprite("AU22");}
					if (CountInv("AutoShotgunAmmo") == 3 )  {A_SetWeaponSprite("AU03");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AU02");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AU01");}
					if (CountInv("AutoShotgunAmmo") == 0 )  {A_SetWeaponSprite("AU01");}
				}
		DrumUnload:
			"AS24" DEFG 0;
			"AS23" DEFG 0;
			"AS22" G 0;
			"AS03" FG 0;
			"AS02" DEFG 0;
			"AS01" DEFG 0;
			TNT1 A 0 A_GiveInventory("PBAutoShotgunWasEmpty", 1);
			TNT1 A 0 A_Giveinventory("PBAutoShotgunHasUnloaded",1);
			TNT1 A 0 A_JumpIfInventory("AutoShotgunAmmo",1,1);
			Goto Ready3;
		StartUnloadingDrum:
			TNT1 A 0 A_PlaySound("Ironsights", 3);
			ASMD G 1 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AS24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AS23");}
					if (CountInv("AutoShotgunAmmo") == 22 ) {A_SetWeaponSprite("AS22");}
					if (CountInv("AutoShotgunAmmo") == 3 )  {A_SetWeaponSprite("AS03");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AS02");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AS01");}
					if (CountInv("AutoShotgunAmmo") == 0 )  {A_SetWeaponSprite("AS01");}
					}
			ASMD F 1 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AS24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AS23");}
					if (CountInv("AutoShotgunAmmo") == 3 )  {A_SetWeaponSprite("AS03");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AS02");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AS01");}
					if (CountInv("AutoShotgunAmmo") == 0 )  {A_SetWeaponSprite("AS01");}
					}
			ASMD ED 1 {
					if (CountInv("AutoShotgunAmmo") == 24 ) {A_SetWeaponSprite("AS24");}
					if (CountInv("AutoShotgunAmmo") == 23 ) {A_SetWeaponSprite("AS23");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AS02");}
					if (CountInv("AutoShotgunAmmo") == 1 )  {A_SetWeaponSprite("AS01");}
					if (CountInv("AutoShotgunAmmo") == 0 )  {A_SetWeaponSprite("AS01");}
					}
			"AU33" CBA 1;
			"AU32" HGFEDCBA 1;
			"AU31" SR 1;
			TNT1 A 0 A_PlaySound("ASGOUT", 2);
			"AU31" QP 1;
			ATMD ON 1 {
					if (CountInv("AutoShotgunAmmo") >= 24 ) {A_SetWeaponSprite("AT24");}
					if (CountInv("AutoShotgunAmmo") == 2 )  {A_SetWeaponSprite("AT02");}	
					if (CountInv("AutoShotgunAmmo") <= 1 )  {A_SetWeaponSprite("AT01");}	
					}
			ATMD M 1 {
					if (CountInv("AutoShotgunAmmo") >= 24 ) {A_SetWeaponSprite("AT24");}
					if (CountInv("AutoShotgunAmmo") <= 1 )  {A_SetWeaponSprite("AT01");}	
					}
			"AU31" LKJIHGFEDC 1;
			Goto DrumRemoveBullets;
			
		DrumRemoveBullets:
			TNT1 A 0 A_JumpIfInventory("AutoShotgunAmmo",1,1);
			Goto FinishDrumUnload;
			TNT1 A 0 {
				A_Takeinventory("AutoShotgunAmmo",1);
				A_Giveinventory("NewShell",1);
			}
			Goto DrumRemoveBullets;
			
		FinishDrumUnload:
			TNT1 A 0 A_Giveinventory("PBAutoShotgunWasEmpty",1);
			TNT1 A 0 A_Takeinventory("Unloading",1);
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "StartUnloadLeftGunDrum");
			Goto Ready3;
			
		StartUnloadLeftGunDrum:
			TNT1 A 0 A_JumpIfInventory("LeftASGAmmo",1,1);
			Goto FinishUnloadDualWield;
			"AG10" FEDCBA 1;
			TNT1 A 5;
		BeginLeftDrumUnload:
			TNT1 A 0 A_Giveinventory("LeftPBAutoShotgunHasUnloaded",1);
			TNT1 A 0 A_GiveInventory("LeftPBAutoShotgunWasEmpty");
			AU10 ABCD 1; //{if (CountInv("AutoshotgunDrumMag") == 1 ) { A_SetWeaponSprite("AU10");}}
			AU2M EFGHHHHH 1 {
				if (CountInv("LeftASGAmmo") == 24 ) { A_SetWeaponSprite("AU24");}
				if (CountInv("LeftASGAmmo") == 23 ) { A_SetWeaponSprite("AU23");}
				if (CountInv("LeftASGAmmo") == 2 )  { A_SetWeaponSprite("AU02");}
				if (CountInv("LeftASGAmmo") == 1 )  { A_SetWeaponSprite("AU01");}
				if (CountInv("LeftASGAmmo") == 0 )  { A_SetWeaponSprite("AU01");}
				}
			Goto StartUnloadingLeftDrum;
		
		StartUnloadingLeftDrum:
			TNT1 A 0 A_PlaySound("Ironsights", 3);
			ASMD G 1 {
					if (CountInv("LeftASGAmmo") == 24 ) {A_SetWeaponSprite("AS24");}
					if (CountInv("LeftASGAmmo") == 23 ) {A_SetWeaponSprite("AS23");}
					if (CountInv("LeftASGAmmo") == 22 ) {A_SetWeaponSprite("AS22");}
					if (CountInv("LeftASGAmmo") == 3 )  {A_SetWeaponSprite("AS03");}
					if (CountInv("LeftASGAmmo") == 2 )  {A_SetWeaponSprite("AS02");}
					if (CountInv("LeftASGAmmo") == 1 )  {A_SetWeaponSprite("AS01");}
					if (CountInv("LeftASGAmmo") == 0 )  {A_SetWeaponSprite("AS01");}
					}
			ASMD F 1 {
					if (CountInv("LeftASGAmmo") == 24 ) {A_SetWeaponSprite("AS24");}
					if (CountInv("LeftASGAmmo") == 23 ) {A_SetWeaponSprite("AS23");}
					if (CountInv("LeftASGAmmo") == 3 )  {A_SetWeaponSprite("AS03");}
					if (CountInv("LeftASGAmmo") == 2 )  {A_SetWeaponSprite("AS02");}
					if (CountInv("LeftASGAmmo") == 1 )  {A_SetWeaponSprite("AS01");}
					if (CountInv("LeftASGAmmo") == 0 )  {A_SetWeaponSprite("AS01");}
					}
			ASMD ED 1 {
					if (CountInv("LeftASGAmmo") == 24 ) {A_SetWeaponSprite("AS24");}
					if (CountInv("LeftASGAmmo") == 23 ) {A_SetWeaponSprite("AS23");}
					if (CountInv("LeftASGAmmo") == 2 )  {A_SetWeaponSprite("AS02");}
					if (CountInv("LeftASGAmmo") == 1 )  {A_SetWeaponSprite("AS01");}
					if (CountInv("LeftASGAmmo") == 0 )  {A_SetWeaponSprite("AS01");}
					}
			"AU33" CBA 1;
			"AU32" HGFEDCBA 1;
			"AU31" SR 1;
			TNT1 A 0 A_PlaySound("ASGOUT", 2);
			"AU31" QP 1;
			ATMD ON 1 {
					if (CountInv("LeftASGAmmo") >= 24 ) {A_SetWeaponSprite("AT24");}
					if (CountInv("LeftASGAmmo") == 2 )  {A_SetWeaponSprite("AT02");}	
					if (CountInv("LeftASGAmmo") <= 1 )  {A_SetWeaponSprite("AT01");}	
					}
			ATMD M 1 {
					if (CountInv("LeftASGAmmo") >= 24 ) {A_SetWeaponSprite("AT24");}
					if (CountInv("LeftASGAmmo") <= 1 )  {A_SetWeaponSprite("AT01");}	
					}
			"AU31" LKJIHGFEDC 1;
		LeftDrumRemoveBullets:
			TNT1 A 0;
			TNT1 A 0 A_JumpIfInventory("LeftASGAmmo",1,1);
			Goto FinishUnloadDualWield;
			TNT1 A 0 {
				A_Takeinventory("LeftASGAmmo",1);
				A_Giveinventory("NewShell",1);
			}
			Goto LeftDrumRemoveBullets;
			
		Spawn:
		"VUSC" A 0 NoDelay;
		"AUSC" A 10 A_PbvpFramework("VUSC");
		"####" A 0 A_PbvpInterpolate();
		LOOP;
			
		FlashPunching:
			TNT1 A 0 A_ClearOverlays(10,11);
			TNT1 A 0 A_JumpIfInventory("DualWieldingAutoshotguns", 1, "DualFlashPunching");
			TNT1 A 0 A_JumpIf(CountInv("AutoshotgunDrumMag") >=1 && CountInv("PBAutoShotgunHasUnloaded") != 1, "FlashPunchingDrumMag");
			"AG51" ABCDEFG 1;
			"AG51" GFEDCBA 1;
			TNT1 A 0 A_ClearOverlays(PSP_FLASH, PSP_FLASH, false);
			Goto Ready3;
		FlashPunchingDrumMag:
			"AU51" ABCDEFG 1;
			"AU51" GFEDCBA 1;
			TNT1 A 0 A_ClearOverlays(PSP_FLASH, PSP_FLASH, false);
			Goto Ready3;
		DualFlashPunching:
			TNT1 A 15;
			TNT1 A 0 A_ClearOverlays(PSP_FLASH, PSP_FLASH, false);
			Goto Ready3;
		FlashKicking:
			TNT1 A 0 A_ClearOverlays(10,11);
			TNT1 A 0 A_JumpIfInventory("DualWieldingAutoshotguns", 1, "DualFlashKicking");
			TNT1 A 0 A_JumpIf(CountInv("AutoshotgunDrumMag") >=1 && CountInv("PBAutoShotgunHasUnloaded") != 1, "FlashKickingDrumMag");
			"AG50" ABCDEF 1;
			"AG50" G 2;
			"AG50" FEDCBA 1;
			"AG10" G 1;
			Goto Ready3;
		FlashKickingDrumMag:
			"AU50" ABC 1;
			"AG50" DEF 1;
			"AG50" G 2;
			"AG50" FED 1;
			"AU50" CBA 1;
			"AU10" H 1;
			Goto Ready3;
		DualFlashKicking:
			"AG63" ABCDEF 1;
			"AG63" G 2;
			"AG63" FEDCBA 1;
			"AG60" N 1;
			Goto Ready3;
		FlashAirKicking:
			TNT1 A 0 A_ClearOverlays(10,11);
			TNT1 A 0 A_JumpIfInventory("DualWieldingAutoshotguns", 1, "DualAirFlashKicking");
			TNT1 A 0 A_JumpIf(CountInv("AutoshotgunDrumMag") >=1 && CountInv("PBAutoShotgunHasUnloaded") != 1, "FlashAirKickingDrumMag");
			"AG50" ABCDEF 1;
			"AG50" G 3;
			"AG50" FEDCBA 1;
			"AG10" G 1;
			Goto Ready3;
		FlashAirKickingDrumMag:
			"AU50" ABC 1;
			"AG50" DEF 1;
			"AG50" G 3;
			"AG50" FED 1;
			"AU50" CBA 1;
			"AU10" H 1;
			Goto Ready3;
		DualAirFlashKicking:
			"AG63" ABCDEF 1;
			"AG63" G 3;
			"AG63" FEDCBA 1;
			"AG60" N 1;
			Goto Ready3;
			
		FlashSlideKicking:
			TNT1 A 0 A_ClearOverlays(10,11);
			TNT1 A 0 A_JumpIfInventory("DualWieldingAutoshotguns", 1, "DualFlashSlideKicking");
			TNT1 A 0 A_JumpIf(CountInv("AutoshotgunDrumMag") >=1 && CountInv("PBAutoShotgunHasUnloaded") != 1, "FlashSlideKickingDrumMag");
			"AG50" ABCDEF 1;
			"AG50" G 14;
			"AG50" FEDCBA 1;
			"AG10" G 1;
			Goto Ready3;
		FlashSlideKickingDrumMag:
			"AU50" ABC 1;
			"AG50" DEF 1;
			"AG50" G 14;
			"AG50" FED 1;
			"AU50" CBA 1;
			"AU10" H 1;
			Goto Ready3;
		DualFlashSlideKicking:
			"AG63" ABCDEF 1;
			"AG63" G 14;
			"AG63" FEDCBA 1;
			"AG60" N 1;
			Goto Ready3;
			
		FlashSlideKickingStop:
			TNT1 A 0 A_ClearOverlays(10,11);
			TNT1 A 0 A_JumpIfInventory("DualWieldingAutoshotguns", 1, "DualFlashSlideKickingStop");
			TNT1 A 0 A_JumpIf(CountInv("AutoshotgunDrumMag") >=1 && CountInv("PBAutoShotgunHasUnloaded") != 1, "FlashSlideKickingStopDrumMag");
			"AG50" FEDCBA 1;
			"AG10" G 1;
			Goto Ready3;
		FlashSlideKickingStopDrumMag:
			"AG50" FED 1;
			"AU50" CBA 1;
			"AU10" H 1;
			Goto Ready3;
		DualFlashSlideKickingStop:
			"AG63" FEDCBA 1;
			"AG60" N 1;
			Goto Ready3;

		PDA_Preview_Fire:
			"AG20" A 1 Bright;
			"AG20" B 1 Bright;
			"AG20" C 1;
			"AG20" D 1;
			"AG20" E 1;
			"AG20" F 1;
			"AG20" G 1;
			"AG20" H 1;
			Stop;
		PDA_Preview_AltFire:
			"AG20" A 1 Bright;
			"AG20" B 1 Bright;
			"AG20" C 1;
			"AG20" D 1;
			"AG20" E 1;
			"AG20" F 1;
			Stop;
		PDA_Preview_Pump:
			"AG40" A 1;
			"AG40" B 1;
			"AG40" C 1;
			"AG40" D 1;
			"AG40" E 1;
			"AG40" F 1;
			"AG40" G 1;
			"AG40" H 1;
			"AG40" I 1;
			"AG40" J 1;
			"AG40" K 1;
			"AG40" L 1;
			"AG40" M 1;
			"AG40" N 1;
			"AG40" I 1;
			"AG40" H 1;
			"AG40" G 1;
			"AG40" F 1;
			"AG40" E 1;
			"AG40" D 1;
			"AG40" C 1;
			"AG40" B 1;
			"AG40" A 1;
			Stop;
		PDA_Preview_Reload:
			"AG30" A 1;
			"AG30" B 1;
			"AG30" C 1;
			"AG30" D 1;
			"AG30" E 1;
			"AG30" F 1;
			"AG30" G 1;
			"AG30" H 1;
			"AG30" I 1;
			"AG30" J 1;
			"AG30" K 1;
			"AG30" L 1;
			"AG30" M 1;
			"AG30" N 1;
			Stop;

	}
}
