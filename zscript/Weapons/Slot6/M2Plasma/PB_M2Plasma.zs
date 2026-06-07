// PB_M2Plasma - ZScript port (DECORATE PB_Weapon retired).

class PB_M2Plasma : PB_WeaponBase
{
	default
	{
		//Title M1 Plasma Rifle
		//Category Weapons
		//Sprite M2PRA0
	Weapon.BobRangeX 0.3;
	Weapon.BobRangeY 0.5;
		Weapon.BobStyle "InverseSmooth";
	Weapon.BobSpeed 2.4;
	Weapon.SlotNumber 8;
	Weapon.SlotPriority 0.12;
	Weapon.SelectionOrder 100;
	Weapon.AmmoUse1 0;
	Weapon.AmmoGive1 50;
	Weapon.AmmoUse2 0;
	Weapon.AmmoGive2 0;
    Inventory.PickupSound "PLSDRAW";
	Weapon.AmmoType1 "Cell";
	Weapon.AmmoType2 "M2PlasmaAmmo";
   	+WEAPON.NOAUTOAIM;
	+WEAPON.NOAUTOFIRE;
	+FLOORCLIP;
	+DONTGIB;
	Inventory.MaxAmount 3;
	Inventory.PickupMessage "You got the UAC-M2 Heavy Plasma Rifle! (Slot 8)";
	Tag "UAC-M2 Plasma Rifle";
	PB_WeaponBase.UnloaderToken "M2PlasmaUnloaded";
	Scale 0.49;
	Inventory.AltHUDIcon "M2PRA0";
	PB_WeaponBase.respectItem "RespectM2PlasmaGun";
	//FloatBobStrength 0.5
	}
	states
	{
		Steady:
		TNT1 A 1;
		Goto Ready;
	
		Ready:
		TNT1 A 0 A_JumpIfInventory("GoFatality",1,"Steady");
		TNT1 A 0 PB_RespectIfNeeded;
		WeaponRespect:
		TNT1 A 0 {
			A_SetCrosshair(5);
			A_GiveInventory("RespectM2PlasmaGun");
			A_Giveinventory("PB_LockScreenTilt",1);
			A_PlaySoundEx("Ironsights", "Auto");
		}
		M200 ABCDEFG 1 {
			A_SetRoll(roll+0.3, SPF_INTERPOLATE);
			return A_DoPBWeaponAction();
		}
		M200 HIJKLMN 1{
			A_SetRoll(roll-0.3, SPF_INTERPOLATE);
			return A_DoPBWeaponAction();
		}
		"M200" "OP" 1 A_DoPBWeaponAction();
		"M200" "QQQQQQ" 1 A_DoPBWeaponAction();
		TNT1 A 0 A_PlaySoundEx("weapons/m2plasma/screenup", "Auto");
		"M200" "RSTU" 2 A_DoPBWeaponAction();
		TNT1 A 0 A_StartSound("weapons/m2plasma/screenon", CHAN_AUTO);
		"M200" "UVVUUVUVUVUUVVUVUVV" 1 A_DoPBWeaponAction();
		TNT1 A 0 A_PlaySoundEx("weapons/carbine/fancybutton", "Auto");
		"M200" "VUVVVVVV" 1 A_DoPBWeaponAction();
		TNT1 A 0 A_PlaySoundEx("weapons/m2plasma/screenup", "Auto");
		"M200" "TSRQ" 2 A_DoPBWeaponAction();
		TNT1 A 0 A_PlaySoundEx("Ironsights", "Auto");
		M200 PONMNLKJI 1 {
			A_SetRoll(roll+0.2, SPF_INTERPOLATE);
			return A_DoPBWeaponAction();
		}
		M200 HHGFEDCBA 1 {
			A_SetRoll(roll-0.4, SPF_INTERPOLATE);
			return A_DoPBWeaponAction();
		}
		M200 WXYZZZZZZ 1{
			A_SetRoll(roll+0.2, SPF_INTERPOLATE);
			return A_DoPBWeaponAction();
		}
		TNT1 A 0 A_PlaySoundEx("weapons/plasma/cellout", "Auto");
		M201 ABCDEF 1 {
			A_SetRoll(roll+0.4, SPF_INTERPOLATE);
			return A_DoPBWeaponAction();
		}
		TNT1 A 0 A_PlaySoundEx("Weapons/CellEject", "Auto");
		TNT1 AAA 0 A_FireCustomMissile("GunFireSmoke", -40, 0, -6, -9, 0, 0);
		"M201" "GHIJKL" 1 A_DoPBWeaponAction();
		M201 MNO 1 {
			A_SetRoll(roll-0.8, SPF_INTERPOLATE);
			return A_DoPBWeaponAction();
		}
		TNT1 A 0 A_PlaySoundEx("weapons/plasma/cellin", "Auto");
		M201 PQRS 1 {
			A_SetRoll(roll+0.2, SPF_INTERPOLATE);
			return A_DoPBWeaponAction();
		}
		M201 TTUVWXYZ 1 {
			A_SetRoll(roll-0.1, SPF_INTERPOLATE);
			return A_DoPBWeaponAction();
		}
		"M200" "ZZZ" 1 A_DoPBWeaponAction();
		TNT1 A 0 A_PlaySoundEx("Ironsights", "Auto");
		M200 YXW 1 {
			A_SetRoll(roll+0.2, SPF_INTERPOLATE);
			return A_DoPBWeaponAction();
		}
		M200 ABCDEFG 1 {
			A_SetRoll(roll+0.2, SPF_INTERPOLATE);
			return A_DoPBWeaponAction();
		}
		M200 HIJKLMNOPP 1 {
			A_SetRoll(roll-0.2, SPF_INTERPOLATE);
			return A_DoPBWeaponAction();
		}
		TNT1 A 0 A_PlaySoundEx("weapons/m2plasma/screenup", "Auto");
		M202 ABC 1 {
			A_SetRoll(roll-0.1, SPF_INTERPOLATE);
			return A_DoPBWeaponAction();
		}
		M202 DEF 1 {
			A_SetRoll(roll+0.1, SPF_INTERPOLATE);
			return A_DoPBWeaponAction();
		}
		TNT1 A 0 A_SetRoll(0, SPF_INTERPOLATE);
		Goto Ready3;
		Ready3:
		TNT1 A 0 {
			A_TakeInventory("PB_LockScreenTilt",1);
			PB_HandleCrosshair(46);
			}
		ReallyReady3:
		TNT1 A 0 A_JumpIfInventory("LightningGunMode", 1,"Ready2");
		TNT1 A 0 A_JumpIfInventory("DualWieldingM2Plasma", 1,"ReadyDualWield");
		TNT1 A 0 A_GiveInventory("PlasmaSoundCounter",2);
		SpriteInit:
		TNT1 A 0 A_JumpIfInventory("HasLightningGunUpgrade",1,1);
		Goto InitNormalSprite;
		InitLightningSprite:
		"PR2G" A 0;
		Goto ActuallyReady3;
		InitNormalSprite:
		"M210" A 0;
		Goto ActuallyReady3;
		ActuallyReady3:
	"####" AABBCCDDEEFFGGHHIIHHGGFFEEDDCCBB 1 {
				A_GiveInventory("PlasmaSoundCounter",1);
				if (CountInv("PlasmaSoundCounter") >= 2) {
					A_PlaySound("PLSM2LP", 6,0.1,1);
					A_TakeInventory("PlasmaSoundCounter",2);
				}
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD, CheckUnloaded("M2PlasmaUnloaded"));
			}
	Goto ReallyReady3;
	
		Ready2:
		TNT1 A 0 {
			A_TakeInventory("PB_LockScreenTilt",1);
			PB_HandleCrosshair(46);
			A_PlaySound("PLSMLG2");
			}
		"PR1G" "ABCDEF" 1;
		ReallyReady2:
		TNT1 A 0 A_PlaySound("LGHUM1", 6,1,1);
		ReallyReady2Loop:
		"PR1G" "GHIJIH" 1 A_DoPBWeaponAction();
		Loop;
		
		SelectAnimation:
	TNT1 A 0 A_JumpIfInventory("DualWieldingM2Plasma", 1, "SelectAnimationDualWield");
	TNT1 A 0 A_PlaySoundEx("PLSDRAW", "Auto");
	"M293" "ABCDE" 0;
	M230 ABCDE 1 {
		if (CountInv("HasLightningGunUpgrade") >= 1 ) { A_SetWeaponSprite("M293");}
	}
	Goto ReallyReady3;
	
		SelectAnimationDualWield:
		TNT1 A 0 A_PlaySoundEx("PLSDRAW", "Auto");
		"M231" "DEFG" 1;
		TNT1 A 0 A_PlaySoundEx("PLSDRAW", "Auto");
		ReadyDualWield:
		TNT1 A 0 A_JumpIfInventory("HasLightningGunUpgrade", 1,"SwitchFromDualWield");
		TNT1 A 0 {
			A_SetRoll(0);
			PB_HandleCrosshair(46);
			A_TakeInventory("PB_LockScreenTilt",1);
			A_SetFiringRightWeapon(False);
			A_SetFiringLeftWeapon(False);
			if(CountInv("LeftM2PlasmaAmmo") < CountInv("M2PlasmaAmmo")){
				A_GiveInventory("DualFiring",1);
			}
			if(CountInv("Cell")>0){
				if(CountInv("LeftM2PlasmaAmmo")<=0){
					A_GiveInventory("DualFireReload",1);
				}
				if(CountInv("M2PlasmaAmmo")<=0){
					A_GiveInventory("DualFireReload",1);
				}
			}
			A_Overlay(10, "IdleLeft_Overlay", false);
			A_Overlay(11, "IdleRight_Overlay", false);
			}
		TNT1 A 0 A_PlaySound("PLSM2LP", 6,0.1,1);
		ReadyToFireDualWield:
		TNT1 A 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOFIRE);
		Loop;
		
		IdleLeft_Overlay:
		M242 AABBCCDDEEFFGGHHIIHHGGFFEEDDCCBBAA 1 {
			// Full-Auto
			if(CountInv("LeftM2PlasmaAmmo")<=0 && CountInv("M2PlasmaAmmo")>0){
				A_GiveInventory("DualFiring",1);
			}
			if(CountInv("DualFiring")==0 || (CountInv("DualFiring")==0 && CountInv("M2PlasmaAmmo")<=0) || GetCvar("SingleDualFire")==1){
				if(JustPressed(BT_ATTACK)){
					if(CountInv("LeftM2PlasmaAmmo") > 0){
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
		M232 AABBCCDDEEFFGGHHIIHHGGFFEEDDCCBBAA 1 {
			// Full-Auto
			if(CountInv("LeftM2PlasmaAmmo")>0 && CountInv("M2PlasmaAmmo")<=0){
				A_TakeInventory("DualFiring",1);
			}
			if(CountInv("DualFiring")==1 || (CountInv("DualFiring")==1 && CountInv("LeftM2PlasmaAmmo")<=0)){
				if(JustPressed(BT_ATTACK) && GetCvar("SingleDualFire")==0){
					if(CountInv("M2PlasmaAmmo") > 0){
						return ResolveState("FireRight_Overlay");
					}
					else {
						A_PlaySoundEx("weapons/empty", "Auto");
						return ResolveState(null);
					}
				}
			}
			if(JustPressed(BT_ALTATTACK) && GetCvar("SingleDualFire")==1){
				if(CountInv("M2PlasmaAmmo") > 0){
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
		M234 A 1 BRIGHT {
			A_FireCustomMissile("HeavyPlasmaBall",0,0,-6,-2);
			A_PlaySoundEx("m2plasma", "Weapon");
			A_AlertMonsters();
			A_Zoomfactor(0.98);
			A_FireCustomMissile("GunFireSmoke", 0, 0, -6, -1, 0, 0);
			A_Takeinventory("LeftM2PlasmaAmmo",2);
			A_GunFlash();
            PB_WeaponRecoil(-1.44,-1.04);
		}	
		
		M234 B 1 BRIGHT {
			A_FireCustomMissile("AltHeavyPlasmaBall",0,0,-6, -2);
			A_Zoomfactor(0.99);
			A_FireCustomMissile("GunFireSmoke", 0, 0, -6, -1, 0, 0);
			if(CountInv("LeftM2PlasmaAmmo")<=0 || CountInv("M2PlasmaAmmo")>0 ){
				A_GiveInventory("DualFiring",1);
			}
            PB_WeaponRecoil(-1.44,-1.04);
			}
		M234 C 1 BRIGHT {
			A_FireCustomMissile("ShakeYourAss", 0, 0, 0, 0);
			A_Zoomfactor(1.0);
			PB_WeaponRecoil(-1.44,-1.04);
			}
		"M234" "DE" 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOFIRE);
		TNT1 A 0 {
			if(CountInv("LeftM2PlasmaAmmo")<=0){
				A_GiveInventory("DualFireReload",1);
			}
		}
		Goto IdleLeft_Overlay;
		
	
		FireRight_Overlay:
		M233 A 1 BRIGHT {
			A_FireCustomMissile("HeavyPlasmaBall",0,0,6,-2);
			A_PlaySoundEx("m2plasma", "Weapon");
			A_AlertMonsters();
			A_Zoomfactor(0.98);
			A_FireCustomMissile("GunFireSmoke", 0, 0, 6, -1, 0, 0);
			A_Giveinventory("PB_M2PlasmaFireAnimation1",1);
			A_Takeinventory("M2PlasmaAmmo",2);
			A_GunFlash();
			PB_WeaponRecoil(-1.44,+1.04);
		}	
		
		M233 B 1 BRIGHT {
			A_FireCustomMissile("AltHeavyPlasmaBall",0,0,6, -2);
			A_Zoomfactor(0.99);
			A_FireCustomMissile("GunFireSmoke", 0, 0, 6, -1, 0, 0);
			if(CountInv("LeftM2PlasmaAmmo")>0 || CountInv("M2PlasmaAmmo")<=0 ){
				A_TakeInventory("DualFiring",1);
			}
			PB_WeaponRecoil(-1.44,+1.04);
			}
		M233 C 1 BRIGHT {
			A_FireCustomMissile("ShakeYourAss", 0, 0, 0, 0);
			A_Zoomfactor(1.0);
			PB_WeaponRecoil(-1.44,+1.04);
			}
		"M233" "DE" 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOFIRE);
		TNT1 A 0 {
			if(CountInv("M2PlasmaAmmo")<=0){
				A_GiveInventory("DualFireReload",1);
			}
		}
		Goto IdleRight_Overlay;
		
		WeaponSpecial:
		TNT1 A 0 {
			A_Takeinventory("GoWeaponSpecialAbility",1);
			A_GiveInventory("PB_LockScreenTilt",1);
			PB_HandleCrosshair(46);
			A_ClearOverlays(10,11);
			}
		TNT1 A 0 A_JumpIfInventory("HasLightningGunUpgrade", 1,"SwitchToLightningMode");
		DualWield:
		TNT1 A 0 A_JumpIfInventory("DualWieldingM2Plasma", 1,"SwitchFromDualWield");
		TNT1 A 0 A_JumpIfInventory("PB_M2Plasma", 2,"SwitchToDualWield");
		TNT1 A 0 A_Print("\ckNeed two \ctM2 plasma rifles \c-to dual-wield");
		Goto Ready3;
		SwitchToDualWield:
		TNT1 A 0 {
			A_PlaySoundEx("Ironsights", "Auto");
			A_Giveinventory("DualWieldingM2Plasma",1);
			}
		"M231" "ABCD" 1 A_Setroll(roll-0.2, SPF_INTERPOLATE);
		"M231" "EG" 1 A_Setroll(roll+0.4, SPF_INTERPOLATE);
		Goto ReadyDualWield;
		SwitchFromDualWield:
		TNT1 A 0 {
			A_PlaySoundEx("Ironsights", "Auto");
			A_Takeinventory("DualWieldingM2Plasma",1);
			}
		"M231" "EGDC" 1 A_Setroll(roll-0.2, SPF_INTERPOLATE);
		"M231" "BA" 1 A_Setroll(roll+0.4, SPF_INTERPOLATE);
		Goto Ready3;
		SwitchToLightningMode:
		TNT1 A 0 A_JumpIfInventory("LightningGunMode", 1,"SwitchToRegularMode");
		TNT1 A 0 {
			A_Giveinventory("LightningGunMode",1);
			A_PlaySoundEx("PLSMLG2", "Auto");
			A_Print("\ctM2 mode:\c- \cfChain lightning \c-on", 2);
			}
		"PR1G" "ABCDEF" 1;
		"PR1G" "GHIJ" 1;
		TNT1 A 0 A_PlaySound("LGHUM1", 6,1,1);
		Goto ReallyReady2;
		SwitchToRegularMode:
		TNT1 A 0 {
			A_Takeinventory("LightningGunMode",1);
			A_PlaySoundEx("PLSMLG1", "Auto");
			A_Print("\ctM2 mode:\c- \cdStandard \c-plasma \c-Ã¢â‚¬â€ \cflightning \c-off", 2);
			}
		"PR1G" "GHIJ" 1;
		"PR1G" "FEDCBA" 1;
		Goto Ready3;
		
		Deselect:
		TNT1 A 0 {
			A_WeaponOffset(0,32);
			A_SetRoll(0);
			PB_HandleCrosshair(46);
			A_TakeInventory("PB_LockScreenTilt",1);
			A_ClearOverlays(10,11);
		}
		TNT1 A 0 A_StopSound(6);
		TNT1 A 0 {
			A_Takeinventory("M2PlasmaUnloaded",1);
			A_Takeinventory("Unloading",1);
			A_TakeInventory("M2Selected",1);
			A_TakeInventory("PlasmaGunSelected",1);
			A_TakeInventory("HasPlasmaWeapon",1);
			}
		TNT1 A 0 A_JumpIfInventory("GotMeatShield", 1, "GrabEnemy");
		TNT1 A 0 A_JumpIfInventory("DualWieldingM2Plasma",1,"DeselectDualWield");
		M230 EDCBA 1 {
			if (CountInv("HasLightningGunUpgrade") >= 1 ) { A_SetWeaponSprite("M293");}
		}
		TNT1 AAAAAAAAAAAAAAAAAA 0 A_Lower;
		Wait;
		DeselectDualWield:
		"M231" "GFED" 1;
		TNT1 AAAAAAAAAAAAAAAAAA 0 A_Lower;
		Wait;
		
		Select:
		TNT1 A 0 {
			A_WeaponOffset(0,32);
			A_SetRoll(0);
			PB_HandleCrosshair(46);
			A_TakeInventory("PB_LockScreenTilt",1);
		}
		Goto SelectFirstPersonLegs;
		SelectContinue:
		TNT1 A 0 A_Takeinventory("M2PlasmaUnloaded",1);
		TNT1 A 0 PB_WeapTokenSwitch("M2Selected");
		TNT1 A 0 A_GiveInventory("HasPlasmaWeapon",1);
		TNT1 AAAAAAAAAAAAAAAAAA 0 A_Raise;
		TNT1 AAAAAAAA 1 A_Raise;
		Wait;
		
		Fire:
		TNT1 A 0 {
			A_WeaponOffset(0,32);
			A_SetRoll(0);
			PB_HandleCrosshair(46);
			A_TakeInventory("PB_LockScreenTilt",1);
		}
		TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
		TNT1 A 0 PB_TryAutoFatalityOnFire();
		TNT1 A 0 {
			A_StopSound(6);
			A_WeaponOffset(0,32);
			}
        TNT1 A 0 A_JumpIfInventory("Reloading",1,"Reload");
        TNT1 A 0 A_JumpIfInventory("M2PlasmaAmmo",2,1);
		Goto Reload;
		TNT1 A 0 A_JumpIfInventory("LightningGunMode",1,"FireLightningGun1");
		"PR2F" "ABCDE" 0;
		M211 A 1 BRIGHT {
			if (CountInv("HasLightningGunUpgrade") >= 1 ) { A_SetWeaponSprite("PR2F");}
			A_FireCustomMissile("HeavyPlasmaBall",0,1,0,-1);
			A_PlaySoundEx("m2plasma", "Weapon");
			A_Zoomfactor(0.98);
			A_FireCustomMissile("GunFireSmoke", 0, 0, 0, 0, 0, 0);
			A_FireCustomMissile("BlueFlareSpawn",-5,0,0,0);
			A_Takeinventory("M2PlasmaAmmo",2);
			A_GunFlash();
            PB_WeaponRecoil(-0.84,+0.26);
		}	
		
		M211 B 1 BRIGHT {
			if (CountInv("HasLightningGunUpgrade") >= 1 ) { A_SetWeaponSprite("PR2F");}
			A_FireCustomMissile("AltHeavyPlasmaBall",0,1,0, -1);
			A_Zoomfactor(0.99);
			A_FireCustomMissile("GunFireSmoke", 0, 0, 0, 0, 0, 0);
			A_FireCustomMissile("BlueFlareSpawn",-5,0,0,0);
			PB_WeaponRecoil(-0.84,+0.26);
			}
		M211 C 1 BRIGHT {
			if (CountInv("HasLightningGunUpgrade") >= 1 ) { A_SetWeaponSprite("PR2F");}
			A_FireCustomMissile("ShakeYourAss", 0, 0, 0, 0);
			A_Zoomfactor(1.0);
			PB_WeaponRecoil(-0.84,+0.26);
			}
		M211 DE 1 {
			if (CountInv("HasLightningGunUpgrade") >= 1 ) { A_SetWeaponSprite("PR2F");}
			A_DoPBWeaponAction(WRF_ALLOWRELOAD);
			}
		Goto Ready3;
		
		FireLightningGun1:
		TNT1 A 0 A_PlaySound("LGFire", 1, 1);
		TNT1 A 0 A_PlaySound("LGLoop", 0, 1, 1);
		TNT1 A 0 A_Zoomfactor(0.98);
		TNT1 A 0 A_JumpIfInventory("M2PlasmaAmmo",5,1);
		Goto Reload;
		LightningGunLoop:
		PR1F A 1 BRIGHT {
			A_SetAngle(frandom(0.3, -0.3) + angle);
			A_TakeInventory("M2PlasmaAmmo", 5);
			A_FireProjectile("LightningGunProjectile", frandom(-10,10), 0 , 0 , 0, FPF_NOAUTOAIM, frandom(-1, 2));
			A_FireCustomMissile("ShakeYourAss", 0, 0, 0, 0);
			A_GunFlash();
			}
		PR1F B 1 BRIGHT {
			A_SetAngle(frandom(0.3, -0.3) + angle);
			A_FireCustomMissile("ShakeYourAss", 0, 0, 0, 0);
			A_GunFlash();
			}
		PR1F A 1 BRIGHT {
			A_SetAngle(frandom(0.3, -0.3) + angle);
			A_FireCustomMissile("ShakeYourAss", 0, 0, 0, 0);
			A_GunFlash();
			}
		PR1F C 1 BRIGHT {
			A_SetAngle(frandom(0.3, -0.3) + angle);
			A_FireCustomMissile("ShakeYourAss", 0, 0, 0, 0);
			A_GunFlash();
			}
		PR1F A 1 BRIGHT {
			A_SetAngle(frandom(0.3, -0.3) + angle);
			A_FireCustomMissile("ShakeYourAss", 0, 0, 0, 0);
			A_GunFlash();
			}
        TNT1 A 0 A_JumpIfInventory("M2PlasmaAmmo",1,1);
		Goto Reload;
		PR1G HGFEEEEEEE 1 BRIGHT {
			A_WeaponReady(WRF_ALLOWRELOAD);
			A_WeaponOffset(frandom(-5,5), 32+frandom(0,3));
		}
		"PR1G" E 1 BRIGHT A_ReFire("LightningGunLoop");
		TNT1 A 0 {
			A_StopSound(0);
			A_PlaySound("LGEnd1", 2, 1);
			A_Zoomfactor(1.0);
			}
		PR1G EEEEFGH 1 BRIGHT {
			A_WeaponReady(WRF_ALLOWRELOAD);
			A_WeaponOffset(frandom(-5,5), 32+frandom(0,3));
		}
		TNT1 A 0 {
			A_WeaponReady(WRF_ALLOWRELOAD);
			A_PlaySound("LGEnd2", 1, 1);
			}
		Goto ReallyReady2;
		
		AltFire:
		TNT1 A 0 {
			A_WeaponOffset(0,32);
			A_SetRoll(0);
			PB_HandleCrosshair(46);
			A_TakeInventory("PB_LockScreenTilt",1);
			A_ClearOverlays(10,11);
		}
		TNT1 A 0 A_StopSound(6);
		TNT1 A 0 A_JumpIfInventory("LightningGunMode",1,"FireStunBomb");
		TNT1 A 0 A_JumpIfInventory("DualWieldingM2Plasma", 1, "FireDualWield");
		TNT1 A 0 A_Jump(256, "LeftToRight", "RightToLeft");
		goto LeftToRight;
		FireStunBomb:
		TNT1 A 0 A_JumpIfInventory("StunBombCooldown",1,"NoFireStun");
		TNT1 A 0 A_JumpIfInventory("M2PlasmaAmmo",25,1);
        Goto Reload;
		TNT1 A 0 A_PlaysoundEx("PZPCHR2", "Auto");
		"PR1F" "XYZABACABACABAC" 1 BRIGHT A_FireCustomMissile("ElectroBlastTrail2", 0, 0, 0, 0);
		TNT1 A 0 {
			A_PlaysoundEx("STNBOMB", "Weapon");
			A_TakeInventory("M2PlasmaAmmo", 25);
			A_FireCustomMissile("ShakeYourAssMinor", 0, 0, 0, 0);
			A_FireCustomMissile("StunBomb", 0, 0, 0, 0, 0, 0);
			A_Zoomfactor(0.98);
			A_GunFlash();
			}
		TNT1 A 0 A_GiveInventory("ActivateStunCooldown",1);
		"PR1F" D 1 BRIGHT A_Zoomfactor(0.99);
		"PR1F" D 1 BRIGHT A_Zoomfactor(1.0);
		"PR1F" "EEFF" 1 BRIGHT;
		Goto ReallyReady2;
	
		NoFireStun:
		TNT1 A 0 A_Print("\coStun bomb \c-on cooldown",1);
		Goto ReallyReady2;
		FireDualWield:
		Goto LeftToRight;
		LeftToRight:
		TNT1 A 0 A_JumpIfInventory("M2PlasmaAmmo",10,1);
        Goto Reload;
		"PR4L" A 0 A_JumpIfInventory("HasLightningGunUpgrade", 1,2);
		"PR3L" A 0;
		"####" A 0 A_Giveinventory("PB_LockScreenTilt",1);
		"####" A 1 {
			A_Zoomfactor(.96);
			A_SetRoll(roll+0.2, SPF_INTERPOLATE);
			return A_DoPBWeaponAction();
			}
		"####" A 0 A_PlaySound("plamersh",1, 1, 1);
		"####" A 0 A_PlaySound("PLSTHRW",3);
		"####" B 1 BRIGHT {
			A_FireCustomMissile("HotPlasmaGas",random(27,33),0,8);
			A_FireCustomMissile("ShakeYourAssMinor", 0, 0, 0, 0);
			A_Takeinventory("M2PlasmaAmmo",2);
			A_SetRoll(roll+0.2, SPF_INTERPOLATE);
			A_GunFlash();
		}
		"####" C 1 BRIGHT A_FireCustomMissile("HotPlasmaGas",random(20,27),0,8);
		"####" D 1 A_PlaySound("PLSTHRW",4);
		"####" E 1 BRIGHT {
			A_FireCustomMissile("HotPlasmaGas",random(12,18),0,4);
			A_FireCustomMissile("ShakeYourAssMinor", 0, 0, 0, 0);
			A_Takeinventory("M2PlasmaAmmo",2);
			A_SetRoll(roll+0.2, SPF_INTERPOLATE);
			A_GunFlash();
			}
		"####" F 1 BRIGHT A_FireCustomMissile("HotPlasmaGas",random(5,10),0,4);
		"####" G 1 A_PlaySound("PLSTHRW",5);
		"####" H 1 BRIGHT {
			A_FireCustomMissile("HotPlasmaGas",random(-3,3));
			A_FireCustomMissile("ShakeYourAssMinor", 0, 0, 0, 0);
			A_Takeinventory("M2PlasmaAmmo",2);
			A_SetRoll(roll+0.2, SPF_INTERPOLATE);
			A_GunFlash();
			}
		"####" I 1 A_PlaySound("PLSTHRW",6);
		"####" J 1 BRIGHT {
			A_FireCustomMissile("HotPlasmaGas",random(-12,-18),0,-4);
			A_FireCustomMissile("ShakeYourAssMinor", 0, 0, 0, 0);
			A_Takeinventory("M2PlasmaAmmo",2);
			A_SetRoll(roll+0.2, SPF_INTERPOLATE);
			A_GunFlash();
			}
		"####" K 1 BRIGHT A_FireCustomMissile("HotPlasmaGas",random(-20,-27),0,-4);
		"####" L 1 A_PlaySound("PLSTHRW",0);
		"####" M 1 BRIGHT {
			A_FireCustomMissile("HotPlasmaGas",random(-27,-33),0,-8);
			A_FireCustomMissile("ShakeYourAssMinor", 0, 0, 0, 0);
			A_Takeinventory("M2PlasmaAmmo",2);
			A_SetRoll(roll+0.2, SPF_INTERPOLATE);
			A_GunFlash();
			}
		"####" N 1 BRIGHT	A_StopSound(1);
		"####" A 0 A_PlaySound("plameren",2);
		"####" L 1 {
			A_Zoomfactor(.98);
			A_SetRoll(roll-0.6, SPF_INTERPOLATE);
			return A_DoPBWeaponAction();
			}
		"####" I 1 {
			A_Zoomfactor(1.0);
			A_SetRoll(roll-0.6, SPF_INTERPOLATE);
			return A_DoPBWeaponAction();
			}
		Goto ready3;
		

		RightToLeft:
		TNT1 A 0 A_JumpIfInventory("Reloading",1,"Reload");
		TNT1 A 0 A_JumpIfInventory("M2PlasmaAmmo",10,1);
        Goto Reload;
		"PR4L" A 0 A_JumpIfInventory("HasLightningGunUpgrade", 1,2);
		"PR3L" A 0;
		"####" A 0 A_Giveinventory("PB_LockScreenTilt",1);
		"####" O 1 {
			A_Zoomfactor(.96);
			A_SetRoll(roll-0.2, SPF_INTERPOLATE);
			return A_DoPBWeaponAction();
			}
		"####" A 0 A_PlaySound("plamersh",1, 1, 1);
		"####" A 0 A_PlaySound("PLSTHRW",3);
		"####" N 1 BRIGHT {
			A_FireCustomMissile("HotPlasmaGas",random(-27,-33),0,8);
			A_FireCustomMissile("ShakeYourAssMinor", 0, 0, 0, 0);
			A_Takeinventory("M2PlasmaAmmo",2);
			A_SetRoll(roll-0.2, SPF_INTERPOLATE);
			A_GunFlash();
		}
		"####" M 1 BRIGHT A_FireCustomMissile("HotPlasmaGas",random(-20,-27),0,8);
		"####" L 1 A_PlaySound("PLSTHRW",4);
		"####" K 1 BRIGHT {
			A_FireCustomMissile("HotPlasmaGas",random(-12,-18),0,4);
			A_FireCustomMissile("ShakeYourAssMinor", 0, 0, 0, 0);
			A_Takeinventory("M2PlasmaAmmo",2);
			A_SetRoll(roll-0.2, SPF_INTERPOLATE);
			A_GunFlash();
			}
		"####" J 1 BRIGHT A_FireCustomMissile("HotPlasmaGas",random(-5,-10),0,4);
		"####" I 1 A_PlaySound("PLSTHRW",5);
		"####" H 1 BRIGHT {
			A_FireCustomMissile("HotPlasmaGas",random(-3,3));
			A_FireCustomMissile("ShakeYourAssMinor", 0, 0, 0, 0);
			A_Takeinventory("M2PlasmaAmmo",2);
			A_SetRoll(roll-0.2, SPF_INTERPOLATE);
			A_GunFlash();
			}
		"####" G 1 A_PlaySound("PLSTHRW",6);
		"####" F 1 BRIGHT {
			A_FireCustomMissile("HotPlasmaGas",random(12,18),0,-4);
			A_FireCustomMissile("ShakeYourAssMinor", 0, 0, 0, 0);
			A_Takeinventory("M2PlasmaAmmo",2);
			A_SetRoll(roll-0.2, SPF_INTERPOLATE);
			A_GunFlash();
			}
		"####" E 1 BRIGHT A_FireCustomMissile("HotPlasmaGas",random(20,27),0,-4);
		"####" D 1 A_PlaySound("PLSTHRW",0);
		"####" C 1 BRIGHT {
			A_FireCustomMissile("HotPlasmaGas",random(27,33),0,-8);
			A_FireCustomMissile("ShakeYourAssMinor", 0, 0, 0, 0);
			A_Takeinventory("M2PlasmaAmmo",2);
			A_SetRoll(roll-0.2, SPF_INTERPOLATE);
			A_GunFlash();
			}
		"####" B 1 BRIGHT	A_StopSound(1);
		"####" A 0 A_PlaySound("plameren",2);
		"####" D 1 {
			A_Zoomfactor(.98);
			A_SetRoll(roll-0.6, SPF_INTERPOLATE);
			return A_DoPBWeaponAction();
			}
		"####" G 1 {
			A_Zoomfactor(1.0);
			A_SetRoll(roll-0.6, SPF_INTERPOLATE);
			return A_DoPBWeaponAction();
			}
		Goto ready3;
		
		CheckLightningReload:
		TNT1 A 0 {
			A_SetCrosshair(5);
			A_Giveinventory("PB_LockScreenTilt",1);
			A_StopSound(CHAN_6);
			A_PlaySoundEx("PLSMLG1", "Auto");
		}
		"PR1G" "FEDCBA" 1;
		TNT1 A 0 A_PlaySound("PLSM2LP", 6,0.1,1);
		Goto ResumeUpgradedReloading;
		UpgradedReloading:
		TNT1 A 0 A_JumpIfInventory("LightningGunMode",1,"CheckLightningReload");
		TNT1 A 0 {
			A_SetCrosshair(5);
			A_Giveinventory("PB_LockScreenTilt",1);
			A_PlaySoundEx("Ironsights", "Auto");
		}
		ResumeUpgradedReloading:
		TNT1 A 0 A_PlaySoundEx("PLSM2RL", "Auto");
		"M223" "ABCDEFGHIJKLLLLL" 1;
		TNT1 A 0 A_PlaysoundEx("Weapons/CellEject", "Auto");
		TNT1 A 0 A_FireCustomMissile("GunFireSmoke", -40, 0, -6, -9, 0, 0);
		TNT1 A 0 PB_SpawnCasing("EmptyCell",38,29,12,Frandom(-2,2),Frandom(6,9),Frandom(3,6));
		"M223" "MNOPQRSTUV" 1;
		TNT1 A 0 A_PlaySoundEx("weapons/m2plasma/reload", "Auto");
		"M223" "WXYZ" 1;
		"M224" "ABCDEFGHI" 1;
		Goto InsertBullets;
		
		Reload:
		TNT1 A 0 A_StopSound(0);
		TNT1 A 0 A_JumpIfInventory("DualWieldingM2Plasma", 1, "ReloadDualWield");
		TNT1 A 0 A_JumpIfInventory("M2PlasmaAmmo",50,"Ready3");
 		TNT1 A 0 A_JumpIfInventory("Cell",1,1);
		Goto Ready3;
		TNT1 A 0 A_JumpIfInventory("HasLightningGunUpgrade", 1,"UpgradedReloading");
		ResumeNormalReloading:
		TNT1 A 0 {
			A_SetCrosshair(5);
			A_Giveinventory("PB_LockScreenTilt",1);
			A_PlaySoundEx("Ironsights", "Auto");
			A_PlaySoundEx("PLSM2RL", "Auto");
			A_ClearOverlays(10,11);
		}
		"M220" "ABCDEFG" 1 A_Setroll(roll-0.5);
		TNT1 A 0 A_PlaySoundEx("weapons/m2plasma/screenup", "Auto");
		M220 H 1 {
			A_Setroll(roll-1.5);
			A_FireCustomMissile("GunFireSmoke", -40, 0, -6, -9, 0, 0);
			A_PlaysoundEx("Weapons/CellEject","Auto");
			}
		"M203" I 0 A_JumpIfInventory("M2PlasmaUnloaded",1,2);
		"M220" I 0;
		"####" "IJK" 1;
		"####" A 0 A_JumpIfInventory("M2PlasmaUnloaded",1,2);
		"####" A 0 PB_SpawnCasing("EmptyCell",38,22,38,Frandom(2,5),Frandom(10,15),Frandom(5,8));
		"M220" "LLLLL" 1 A_Setroll(roll+1.0);
		"M220" "MNOPQ" 1 A_Setroll(roll+1.0);
		"M220" "RR" 1;
		"M220" "RRRRRR" 1 A_Setroll(roll-1.0);
		TNT1 A 0 A_PlaySoundEx("weapons/m2plasma/reload", "Auto");
		"M220" "STUV" 1 A_Setroll(roll+0.5);
		"M220" "WXYZ" 1 A_Setroll(roll-0.5);
		"M220" "ZZZ" 1;
		"M221" "ABCD" 1 A_Setroll(roll-1.0);
		"M221" "EFGH" 1 A_Setroll(roll+1.0);
		InsertBullets:
		TNT1 A 0 A_JumpIfInventory("M2PlasmaAmmo",50,"FinishReload");
		TNT1 A 0 A_JumpIfInventory("Cell",1,1);
		Goto FinishReload;
		TNT1 A 0 {
			A_Giveinventory("M2PlasmaAmmo",1);
			A_Takeinventory("Cell",1);
			}
		Goto InsertBullets;
		FinishReload:
		TNT1 A 0 A_Takeinventory("M2PlasmaUnloaded",1);
        Goto ready3;
		
		ReloadDualWield:
		TNT1 A 0 {
			if (CountInv("M2PlasmaAmmo") >= 50 && CountInv("LeftM2PlasmaAmmo") >= 50) {
				return ResolveState("ReadyDualWield");
			}
			return ResolveState(null);
		}
        TNT1 A 0 A_JumpIfInventory("Cell",1,1);
        Goto ReadyDualWield;
		TNT1 A 0 {
			A_SetCrosshair(5);
			A_Giveinventory("PB_LockScreenTilt",1);
			A_PlaySoundEx("Ironsights", "Auto");
			A_PlaySoundEx("PLSM2RL", "Auto");
			A_ClearOverlays(10,11);
		}
		"M231" "GFED" 1;
		TNT1 A 0 A_JumpIf(CountInv("M2PlasmaAmmo") >= 50,"ReloadLeft");
		"M220" "FG" 1 A_Setroll(roll-0.5);
		TNT1 A 0 A_PlaySoundEx("weapons/m2plasma/screenup", "Auto");
		M220 H 1 {
			A_Setroll(roll-1.5);
			A_FireCustomMissile("GunFireSmoke", -40, 0, -6, -9, 0, 0);
			A_PlaysoundEx("Weapons/CellEject","Auto");
			}
		"M203" I 0 A_JumpIfInventory("M2PlasmaUnloaded",1,2);
		"M220" I 0;
		"####" "IJK" 1;
		"####" A 0 A_JumpIfInventory("M2PlasmaUnloaded",1,2);
		"####" A 0 PB_SpawnCasing("EmptyCell",38,22,38,Frandom(2,5),Frandom(10,15),Frandom(5,8));
		"M220" "LLLLL" 1 A_Setroll(roll+1.0);
		"M220" "MNOPQ" 1 A_Setroll(roll+1.0);
		"M220" "RR" 1;
		"M220" "RRRRRR" 1 A_Setroll(roll-1.0);
		TNT1 A 0 A_PlaySoundEx("weapons/m2plasma/reload", "Auto");
		"M220" "STUV" 1 A_Setroll(roll+0.5);
		"M220" "WXYZ" 1 A_Setroll(roll-0.5);
		"M220" "ZZZ" 1;
		"M221" "ABCD" 1 A_Setroll(roll-1.0);
		"M221" E 1 A_Setroll(roll+1.0);
		"M230" "BA" 1 A_Setroll(roll+1.0);
		TNT1 A 1 A_Setroll(roll+1.0);
		TNT1 A 9;
		TNT1 A 0 A_JumpIfInventory("M2PlasmaUnloaded",1,2);
		TNT1 A 0 A_TakeInventory("M2PlasmaUnloaded",1);
		
		TNT1 A 0 A_JumpIf(CountInv("LeftM2PlasmaAmmo") < 50,1);
		Goto InsertBullets4;
		ReloadLeft:
		TNT1 A 0 A_PlaySoundEx("weapons/m2plasma/reload", "Auto");
		"M222" "AAABC" 1;
		"M204" D 0 A_JumpIfInventory("M2PlasmaUnloaded",1,2);
		"M222" D 0;
		"####" D 1 {
			A_FireCustomMissile("GunFireSmoke", 40, 0, 6, -9, 0, 0);
			A_PlaysoundEx("Weapons/CellEject","Auto");
			}
		"####" "EF" 1;
		"####" A 0 A_JumpIfInventory("M2PlasmaUnloaded",1,2);
		"####" A 0 ;//PB_SpawnCasing("EmptyCell",38,-13,38,2,Frandom(-15,-10),Frandom(5,8));
		"####" A 0 PB_SpawnCasing("EmptyCell",38,-22,38,Frandom(2,5),Frandom(-15,-10),Frandom(5,8));
		"M222" GGGGHIJKLMMMMNOPQRSTUUVWXYZ 1;
		"M231" "DEFG" 1;
		TNT1 A 0 A_TakeInventory("M2PlasmaUnloaded",1);
		InsertBullets4:
		TNT1 A 0 A_JumpIfInventory("M2PlasmaAmmo",50,"InsertBullets5");
		TNT1 A 0 A_JumpIfInventory("Cell",1,1);
		Goto InsertBullets5;
		TNT1 A 0 {
			A_Giveinventory("M2PlasmaAmmo",1);
			A_Takeinventory("Cell",1);
		}
		Goto InsertBullets4;
		InsertBullets5:
		TNT1 A 0 A_JumpIfInventory("LeftM2PlasmaAmmo",50,"Ready3");
		TNT1 A 0 A_JumpIfInventory("Cell",1,1);
		Goto Ready3;
		TNT1 A 0 {
			A_Giveinventory("LeftM2PlasmaAmmo",1);
			A_Takeinventory("Cell",1);
		}
		Goto InsertBullets5;
		
		AlreadyUnloaded:
		TNT1 A 0 A_Takeinventory("Unloading",1);
		Goto ready3;
		CheckLightningUnload:
		TNT1 A 0 A_PlaySound("PLSMLG1");
		"PR1G" "FEDCBA" 1;
		Goto ResumeUpgradedUnloading;
		UpgradedUnloading:
		TNT1 A 0 A_JumpIfInventory("LightningGunMode",1,"CheckLightningUnload");
		ResumeUpgradedUnloading:
		"M224" "IHGFEDCBA" 1;
		"M223" "ZYXW" 1;
		TNT1 A 0 A_PlaySound("Weapons/CellKickIn");
		"M223" "VUTSRQPONMLKIHGFEDCB" 1;
		RemoveBullets2:
		TNT1 A 0 A_JumpIfInventory("M2PlasmaAmmo",1,1);
		Goto FinishUnload2;
		TNT1 A 0 {
			A_Takeinventory("M2PlasmaAmmo",1);
			A_Giveinventory("Cell",1);
			}
		Goto RemoveBullets2;
		FInishUnload2:
		TNT1 A 0 A_GiveInventory("M2PlasmaUnloaded", 1);
		TNT1 A 0 A_Takeinventory("Unloading",1);
		Goto ready3;
		Unload:
		TNT1 A 0 A_JumpIfInventory("M2PlasmaUnloaded", 1, "Ready3");
		TNT1 A 0 {
			A_ClearOverlays(10,11);
			A_StopSound(6);
			A_Takeinventory("Unloading",1);
			}
        TNT1 A 0 A_JumpIfInventory("M2PlasmaAmmo",1,1);
        Goto ready3;
		TNT1 A 0 A_JumpIfInventory("HasLightningGunUpgrade", 1,"UpgradedUnloading");
		TNT1 A 0 A_JumpIfInventory("DualWieldingM2Plasma",1, "UnloadDualWield");
		"M221" "HGFEDCBA" 1;
		"M220" "ZYXWVU" 1;
		TNT1 A 0 A_PlaySound("Weapons/CellKickIn");
		"M220" "TSRQPONM" 1;
		"M220" "FED" 1;
		"M220" C 1 Offset(-2, 35);
		"M220" "BA" 1 Offset(-4, 37);
		"M210" A 2 A_WeaponOffset(0,32);
		RemoveBullets:
		TNT1 A 0 A_JumpIfInventory("M2PlasmaAmmo",1,1);
		Goto FinishUnload;
		TNT1 A 0 {
			A_Takeinventory("M2PlasmaAmmo",1);
			A_Giveinventory("Cell",1);
			}
		Goto RemoveBullets;
		FInishUnload:
		TNT1 A 0 A_JumpIfInventory("DualWieldingM2Plasma",1,"UnloadLeft");
		TNT1 A 0 {
			A_GiveInventory("M2PlasmaUnloaded", 1);
			A_Takeinventory("Unloading",1);
			}
		Goto ready3;
	
		UnloadDualWield:
		"M231" "GFED" 1;
		"M220" "PQR" 1;
		"M220" "ZYXWVU" 1;
		TNT1 A 0 A_PlaySound("Weapons/CellKickIn");
		"M220" "TSRQPON" 1;
		"M220" N 1 Offset(-15, 39);
		"M220" N 1 Offset(-30, 46);
		"M220" N 1 Offset(-40, 53);
		TNT1 A 9 A_WeaponOffset(0,32);
		Goto RemoveBullets;
	
		UnloadLeft:
		"M222" "GHIJKLM" 1;
		"M222" "TSRQP" 1;
		TNT1 A 0 A_PlaySound("Weapons/CellKickIn");
		"M222" "ONMLKJI" 1;
		"M222" I 1 Offset(15, 39);
		"M222" I 1 Offset(30, 46);
		"M222" I 1 Offset(40, 53);
		TNT1 A 3 A_WeaponOffset(0,32);
		RemoveBulletsLeft:
		TNT1 A 0 A_JumpIfInventory("LeftM2PlasmaAmmo",1,1);
		Goto FinishUnloadLeft;
		TNT1 A 0 {
			A_Takeinventory("LeftM2PlasmaAmmo",1);
			A_Giveinventory("Cell",1);
			}
		Loop;
		FInishUnloadLeft:
		TNT1 A 0 {
			A_GiveInventory("M2PlasmaUnloaded", 1);
			A_Takeinventory("Unloading",1);
			}
		Goto SelectAnimationDualWield;
	
		Flash:
		TNT1 A 1;
		Stop;
		
		Spawn:
		"M2PR" A -1;
		Stop;
		// Spawn voxel model path not implemented (was DECORATE comment block).
	
		
		
		FlashPunching:
		"PR2K" "ABCDEFG" 0;
		TNT1 A 0 A_ClearOverlays(10,11);
		TNT1 A 0 A_JumpIfInventory("DualWieldingM2Plasma", 1,"FlashPunchingDW");
		M225 ABCDEFGGFEDCBA 1 {
			if(CountInv("HasLightningGunUpgrade") == 1) {A_SetFlashWeaponSprite("PR2K");}
			}
		TNT1 A 0 A_ClearOverlays(PSP_FLASH, PSP_FLASH, false);
		Goto Ready3;
		FlashPunchingDW:
		TNT1 A 15;
		TNT1 A 0 A_ClearOverlays(PSP_FLASH, PSP_FLASH, false);
		Goto Ready3;
	
		FlashKicking:
		"PR2K" "ABCDEFG" 0;
		TNT1 A 0 A_ClearOverlays(10,11);
		TNT1 A 0 A_JumpIfInventory("DualWieldingM2Plasma", 1,"FlashKickingDW");
		M225 ABCDEFGGFEDCBA 1 {
			if(CountInv("HasLightningGunUpgrade") == 1) {A_SetWeaponSprite("PR2K");}
			}
		Goto Ready3;
		FlashKickingDW:
		"P7SS" "EDCBAAAAAABCDE" 1;
		Goto Ready3;
		
		FlashAirKicking:
		TNT1 A 0 A_ClearOverlays(10,11);
		TNT1 A 0 A_JumpIfInventory("DualWieldingM2Plasma", 1,"FlashAirKickingDW");
		M225 ABCDEFGGGGFEDCBA 1 {
			if(CountInv("HasLightningGunUpgrade") == 1) {A_SetWeaponSprite("PR2K");}
			}
		Goto Ready3;
		FlashAirKickingDW:
		"P7SS" "EDCBAAAAAAAABCDE" 1;
		Goto Ready3;
		
		FlashSlideKicking:
		TNT1 A 0 A_ClearOverlays(10,11);
		TNT1 A 0 A_JumpIfInventory("DualWieldingM2Plasma", 1,"FlashSlideKickingDW");
		M225 ABCDEFGGGGGGGGGGGGGFEDCBAA 1 {
			if(CountInv("HasLightningGunUpgrade") == 1) {A_SetWeaponSprite("PR2K");}
			}
		Goto Ready3;

		FlashSlideKickingDW:
		"P7SS" "EDCBAAAAAAAAAAAAAAAAAABCDE" 1;
		Goto Ready3;
		
		
		FlashSlideKickingStop:
		TNT1 A 0 A_JumpIfInventory("DualWieldingM2Plasma", 1,"FlashSlideKickingStopDW");
		M225 GFEDCBA 1 {
			if(CountInv("HasLightningGunUpgrade") == 1) {A_SetWeaponSprite("PR2K");}
			}
		Goto Ready3;
		
		FlashSlideKickingStopDW:
		"P7SS" "ABCDEEE" 1;
		Goto Ready3;

		PDA_Preview_M2Ready:
		"M210" A 2 A_WeaponReady(WRF_NOFIRE);
		Stop;
		PDA_Preview_M2Burst:
		"M211" A 1 BRIGHT A_WeaponReady(WRF_NOFIRE);
		"M211" B 1 BRIGHT A_WeaponReady(WRF_NOFIRE);
		"M211" C 1 BRIGHT A_WeaponReady(WRF_NOFIRE);
		"M211" D 1 A_WeaponReady(WRF_NOFIRE);
		"M211" E 1 A_WeaponReady(WRF_NOFIRE);
		Stop;
		PDA_Preview_M2Lightning:
		"PR1F" A 1 BRIGHT A_WeaponReady(WRF_NOFIRE);
		"PR1F" B 1 BRIGHT A_WeaponReady(WRF_NOFIRE);
		"PR1F" A 1 BRIGHT A_WeaponReady(WRF_NOFIRE);
		"PR1F" C 1 BRIGHT A_WeaponReady(WRF_NOFIRE);
		Stop;
		PDA_Preview_M2Stun:
		"PR1F" D 1 BRIGHT A_WeaponReady(WRF_NOFIRE);
		"PR1F" E 1 BRIGHT A_WeaponReady(WRF_NOFIRE);
		"PR1F" F 1 BRIGHT A_WeaponReady(WRF_NOFIRE);
		Stop;
		PDA_Preview_M2Reload:
		"M220" A 1 A_SetRoll(roll-0.5);
		"M220" B 1 A_SetRoll(roll-0.5);
		"M220" C 1 A_SetRoll(roll-0.5);
		"M220" D 1 A_SetRoll(roll-0.5);
		"M220" E 1 A_SetRoll(roll-0.5);
		"M220" F 1 A_SetRoll(roll-0.5);
		"M220" G 1 A_SetRoll(roll-0.5);
		Stop;
	}
}
