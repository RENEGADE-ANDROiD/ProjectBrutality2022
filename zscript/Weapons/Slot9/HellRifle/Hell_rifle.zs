// Hell_rifle - ZScript port (DECORATE PB_Weapon retired).

class Hell_rifle : PB_WeaponBase
{
	default
	{
	Weapon.BobRangeX 0.3;
	Weapon.BobRangeY 0.5;
		Weapon.BobStyle "InverseSmooth";
	Weapon.BobSpeed 2.4;
	Weapon.SelectionOrder 400;
	Weapon.AmmoUse1 0;
	Weapon.AmmoGive1 20;
	Weapon.AmmoUse2 0;
	Weapon.AmmoGive2 0;
	+FLOORCLIP;
	+DONTGIB;
    Inventory.PickupSound "HRPickup";
	Obituary "%o was set ablaze by %k's hellish rifle.";
	Weapon.AmmoType1 "Demonpower";
	Weapon.AmmoType2 "HellAmmo";
	Tag "Demon-Tech Rifle";
	Weapon.SlotNumber 9;
	Weapon.SlotPriority 10.1;
	Inventory.PickupMessage "You got the Demon Tech Rifle! (Slot 9)";
    +WEAPON.NOAUTOAIM;
	Scale 0.48;
	Inventory.AltHUDIcon "HRPUA0";
	PB_WeaponBase.respectItem "RespectDemonTech";
	FloatBobStrength 0.5;
	}
	states
	{
		Steady:
			TNT1 A 1;
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			TNT1 A 0 SetPlayerProperty(0,0,0);
			TNT1 A 0 SetPlayerProperty(0,0,PROP_TOTALLYFROZEN);
			Goto Ready;
		
		Ready:
			TNT1 A 0 PB_RespectIfNeeded;
		WeaponRespect:
			TNT1 A 0 {
				A_SetCrosshair(5);
				A_GiveInventory("RespectDemonTech");
				A_PlaySoundEx("weapons/carbine/up", "Auto");
			}
			"D0T0" "ABCDEFGHIJKLMNOPQRSSSSS" 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySoundEx("weapons/demontech/respect1", "Auto");
			"D0T1" "ABCDEF" 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySoundEx("weapons/demontech/respect2", "Auto");
			"D0T1" "GHIJKLMNOPQRSTUVWXYZ" 1 A_DoPBWeaponAction();
			"D0T2" "ABCDE" 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySoundEx("weapons/demontech/respect3", "Auto");
			"D0T2" "FGHIJKLMNOPQRSTUVW" 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySoundEx("weapons/riflemagslap", "Auto");
			"D0T2" "XYZ" 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySoundEx("HRSteam", "Auto");
			"D0T3" "ABCDEFGHIJKLMNOPQRSTUVWXYZ" 1 A_DoPBWeaponAction();
			Goto Ready3;
			
		SelectAnimation:
			TNT1 A 0 A_StartSound("HRReady");
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			TNT1 A 0 A_JumpIfInventory("FireModeAcidGun",1,"SelectAnimation2");
			"D2T0" "ABCDE" 1;
		Ready3:
			TNT1 A 0 {
				A_TakeInventory("PB_LockScreenTilt",1);
				PB_HandleCrosshair(39);
				}
		ReadyToFire1:
			TNT1 A 0 A_PlaySound("DTCHHUM", 1, 1,1);
			TNT1 A 0 A_JumpIfInventory("FireModeAcidGun",1,"ReadyToFire2");
			"D5T0" "ABCDEFGHIJKLMAABMBAAABAA" 3 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
			Goto ReadyToFire1+2;
		
		SelectAnimation2:
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			"D2T1" "ABCDE" 1;
		ReadyToFire2:
			TNT1 A 0 A_PlaySound("DTCHGUM", 1, 1,1);
			"D5T1" "ABCDEFGHIJKLMAABMBAAABAA" 3 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
			Goto ReadyToFire2+1;
		
		WeaponSpecial:
			TNT1 A 0 A_StopSound(1);
			TNT1 A 0 A_Takeinventory("GoWeaponSpecialAbility",1);
			TNT1 A 0 A_JumpIfInventory("FireModeAcidGun",1,"SwitchFireMode");
			TNT1 A 0 A_GiveInventory("FireModeAcidGun", 1);
			TNT1 A 0 A_Print("\ctFire mode:\c- \cdCaustic \c-");
			TNT1 A 0 A_PlaySoundEx("weapons/demontech/weaponspecial1", "Auto");
			"D1T0" "ABCD" 1;
			TNT1 A 0 A_PlaySoundEx("weapons/demontech/weaponspecial2", "Auto");
			"D1T0" "EFGHIJKLMN" 2;
			Goto ReadyToFire2;
		SwitchFireMode:
			TNT1 A 0 A_StopSound(1);
			TNT1 A 0 A_TakeInventory("FireModeAcidGun", 1);
			TNT1 A 0 A_Print("\ctFire mode:\c- \cgInferno \c-");
			TNT1 A 0 A_PlaySoundEx("weapons/demontech/weaponspecial1", "Auto");
			"D1T1" "ABCD" 1;
			TNT1 A 0 A_PlaySoundEx("weapons/demontech/weaponspecial2", "Auto");
			"D1T1" "EFGHIJKLMN" 2;
			Goto ReadyToFire1;
			
		Deselect:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleCrosshair(39);
				A_TakeInventory("PB_LockScreenTilt",1);
			}
			TNT1 A 0 A_StopSound(1);
			TNT1 A 0 A_TakeInventory("HasIncendiaryWeapon", 1);
			TNT1 A 0 A_JumpIfInventory("GotMeatShield", 1, "GrabEnemy");
			TNT1 A 0 A_JumpIfInventory("FireModeAcidGun",1,6);
			"D2T0" "DCBA" 1;
			TNT1 A 0 A_Jump(256, 5);
			"D2T1" "DCBA" 1;
			TNT1 AAAAAAAAAAAAAAAAAA 0 A_Lower;
			Wait;
		Select:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleCrosshair(39);
				A_TakeInventory("PB_LockScreenTilt",1);
			}
			Goto SelectFirstPersonLegs;
		SelectContinue:
			TNT1 A 0;
			TNT1 A 0 PB_WeapTokenSwitch("HellRifleSelected");
			TNT1 AAAAAAAAAAAAAAAAAA 0 A_Raise;
			TNT1 AAAAAAAA 1 A_Raise;
			wait;
	
		Fire:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleCrosshair(39);
				A_TakeInventory("PB_LockScreenTilt",1);
			}
			TNT1 A 0 A_JumpIfInventory("FireModeAcidGun",1,"Fire2");
			TNT1 A 0 A_JumpIfInventory("HellAmmo",1,1);
			Goto Reload;
			D3T0 A 1 BRIGHT {
				A_Giveinventory("HasIncendiaryWeapon",1);
				A_FireCustomMissile("Hellbullet", 0, 0, 0, 0, 0, random(-1,1));
				A_FireCustomMissile("GunFireSmoke", 0, 0, 0, 0, 0, 0);
				A_PlaySoundEx("HRFire", "Weapon");
				A_Takeinventory("HellAmmo",1);
				A_AlertMonsters();
				A_ZoomFactor(0.99);
				A_GunFlash();
				A_Overlay(-4, "InfernoFlash", true);
				PB_WeaponRecoil(-0.52,-0.2);
			}
			
			D3T0 B 1 BRIGHT {
				A_ZoomFactor(0.995);
				PB_WeaponRecoil(-0.52,-0.2);
			}
			"D3T0" C 1 A_ZoomFactor(1.0);
			"D3T0" D 1;
			TNT1 A 0 A_ReFire;
			TNT1 A 0 A_PlaySoundEx("HRSteam", "Auto");
			"D3T0" "EFGHIJKLMNOPQRS" 1;
			TNT1 A 0 A_Takeinventory("HasIncendiaryWeapon",1);
			Goto ReadyToFire1;
			
		Fire2:
			TNT1 A 0 A_JumpIfInventory("HellAmmo",1,1);
			Goto Reload;
			D3T1 A 1 BRIGHT {
				A_Takeinventory("HasIncendiaryWeapon",1);
				A_FireCustomMissile("Hellbullet2", 0, 0, 0, 0, 0, random(-1,1));
				A_FireCustomMissile("GunFireSmoke", 0, 0, 0, 0, 0, 0);
				A_PlaySoundEx("8FGGFIRE", "Weapon");
				A_Takeinventory("HellAmmo",1);
				A_AlertMonsters();
				A_ZoomFactor(0.99);
				A_GunFlash();
				A_Overlay(-4, "CausticFlash", true);
				PB_WeaponRecoil(-0.68,-0.36);
			}
			D3T1 B 1 BRIGHT {
				A_ZoomFactor(0.995);
				PB_WeaponRecoil(-0.68,-0.36);
			}
			"D3T1" C 1 A_ZoomFactor(1.0);
			"D3T1" D 1;
			"D2T1" E 0 A_ReFire;
			TNT1 A 0 A_PlaySoundEx("HRSteam", "Auto");
			"D3T1" "EFGHIJKLMNOPQRS" 1;
			Goto ReadyToFire2;
		
		InfernoFlash:
			TNT1 A 0 A_Jump(256, "FMuzzle1", "FMuzzle2", "FMuzzle3");
		FMuzzle1:
			"D3T2" "AB" 1 BRIGHT;
			TNT1 A 0 A_Jump(100, "ThirdFMuzzle1");
			Stop;
		FMuzzle2:
			"D3T2" "DE" 1 BRIGHT;
			TNT1 A 0 A_Jump(100, "ThirdFMuzzle2");
			Stop;
		FMuzzle3:
			"D3T2" "GH" 1 BRIGHT;
			TNT1 A 0 A_Jump(100, "ThirdFMuzzle3");
			STOP;
			
		ThirdFMuzzle1:
			"D3T2" C 1 BRIGHT;
			STOP;
		ThirdFMuzzle2:
			"D3T2" F 1 BRIGHT;
			STOP;
		ThirdFMuzzle3:
			"D3T2" I 1 BRIGHT;
			Stop;
			
		CausticFlash:
			TNT1 A 0 A_Jump(256, "CMuzzle1", "CMuzzle2", "CMuzzle3", "CMuzzle4", "CMuzzle5", "CMuzzle6");
		CMuzzle1:
			"D3T3" "AB" 1 BRIGHT;
			TNT1 A 0 A_Jump(100, "ThirdCMuzzle1");
			Stop;
		CMuzzle2:
			"D3T3" "DE" 1 BRIGHT;
			TNT1 A 0 A_Jump(100, "ThirdCMuzzle2");
			Stop;
		CMuzzle3:
			"D3T3" "GH" 1 BRIGHT;
			TNT1 A 0 A_Jump(100, "ThirdCMuzzle3");
			STOP;
		CMuzzle4:
			"D3T3" "JK" 1 BRIGHT;
			TNT1 A 0 A_Jump(100, "ThirdCMuzzle4");
			STOP;
		CMuzzle5:
			"D3T3" "MN" 1 BRIGHT;
			TNT1 A 0 A_Jump(100, "ThirdCMuzzle5");
			STOP;
		CMuzzle6:
			"D3T3" "PQ" 1 BRIGHT;
			TNT1 A 0 A_Jump(100, "ThirdCMuzzle6");
			STOP;
			
		ThirdCMuzzle1:
			"D3T3" C 1 BRIGHT;
			STOP;
		ThirdCMuzzle2:
			"D3T3" F 1 BRIGHT;
			STOP;
		ThirdCMuzzle3:
			"D3T3" I 1 BRIGHT;
			Stop;
		ThirdCMuzzle4:
			"D3T3" L 1 BRIGHT;
			Stop;
		ThirdCMuzzle5:
			"D3T3" O 1 BRIGHT;
			Stop;
		ThirdCMuzzle6:
			"D3T3" R 1 BRIGHT;
			Stop;
			
		AltFire:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleCrosshair(39);
				A_TakeInventory("PB_LockScreenTilt",1);
			}
			TNT1 A 0 A_JumpIfInventory("FireModeAcidGun",1,"AltFire2");
			TNT1 A 0 A_JumpIfInventory("HellAmmo",1,1);
			Goto Reload;
			TNT1 A 0 A_JumpIfInventory("HellAmmo",20,1);
			Goto Reload;
			TNT1 A 0 A_PlaySound("HRCharge");
			D5T0 ABCDABCDABCDABCD 1 BRIGHT {
				A_WeaponOffset(random(-1,1),random(32,34));
				A_FireCustomMissile("ShakeYourAssMinor", 0, 0, 0, 0);
			}
				
			TNT1 A 0 A_PlaySoundEx("unmbal", "Weapon");
			TNT1 A 0 A_FireCustomMissile("RedFlareSpawn",0,0,0,0);
			TNT1 A 0 A_FireCustomMissile("PossessionGhost");
			TNT1 A 0 A_GunFlash();
			TNT1 A 0 A_Overlay(-4, "InfernoFlash", true);
			"D3T0" "AB" 1 BRIGHT;
			"D3T0" "CD" 1;
			TNT1 A 0 A_Takeinventory("HellAmmo",20);
			TNT1 A 0 A_PlaySoundEx("HRSteam", "Auto");
			"D3T0" "EFGHIJKLNOPQRS" 1;
			Goto ReadyToFire1;
			
		Reload:
			TNT1 A 0 A_JumpIfInventory("FireModeAcidGun",1,"Reload2");
			"D4T0" A 1 A_WeaponReady(WRF_ALLOWRELOAD);
			TNT1 A 0 A_JumpIfInventory("HellAmmo",60,"Ready3");
			TNT1 A 0 A_JumpIfInventory("Demonpower",1,1);
			Goto Ready3;
			TNT1 A 0 A_PlaySoundEx("Ironsights", "Auto");
			"D4T0" "ABCDEFGHIJK" 1;
			TNT1 A 0 A_PlaySoundEx("weapons/riflemagslap", "Auto");
			"D4T0" "LMN" 1;
			TNT1 A 0 A_PlaySoundEx("weapons/demontech/respect1", "Auto");
			"D4T0" "OPQRSTUVWXYZ" 1;
			"D4T1" "ABCDEFGH" 1;
			TNT1 A 0 A_PlaySound("weapons/fistwhoosh2");
			"D4T1" "IJKLM" 1;
			TNT1 A 0 A_PlaySoundEx("weapons/demontech/respect4", "Auto");
			"D4T1" N 1;
			TNT1 A 0 A_PlaySoundEx("weapons/demontech/respect2", "Auto");
			TNT1 A 0 A_PlaySoundEx("HRPickup", "Auto");
			"D4T1" "OPQRSTUVWXYZ" 1;
			"D4T2" "ABCDEFGHIJKLMNOPQRST" 1;
			TNT1 A 0 A_PlaySoundEx("Ironsights", "Auto");
			"D4T2" "UVWXYZ" 1;
			"D4T3" "ABCDEFGH" 1;
			TNT1 A 0 A_PlaySoundEx("weapons/demontech/respect3", "Auto");
			"D4T3" "IJKLMNOPQRSTUV" 1;
			TNT1 A 0 A_PlaySoundEx("weapons/riflemagslap", "Auto");
			"D4T3" "WXYZ" 1;
			TNT1 A 0 A_PlaySoundEx("HRSteam", "Auto");
			"D4T4" "ABCDEFGHIJKLMNOPQRST" 1;
		InsertBullets:
			TNT1 A 0 A_JumpIfInventory("HellAmmo",60,"Ready3");
			TNT1 A 0 A_JumpIfInventory("Demonpower",1,1);
			Goto Ready3;
			TNT1 A 0 {
				A_Giveinventory("HellAmmo",1);
				A_Takeinventory("Demonpower",1);
				}
			Goto InsertBullets;
			
		Reload2:
			"D6T0" A 1 A_WeaponReady(WRF_ALLOWRELOAD);
			TNT1 A 0 A_JumpIfInventory("HellAmmo",60,"Ready3");
			TNT1 A 0 A_JumpIfInventory("Demonpower",1,1);
			Goto Ready3;
			TNT1 A 0 A_PlaySoundEx("Ironsights", "Auto");
			"D6T0" "ABCDEFGHIJK" 1;
			TNT1 A 0 A_PlaySoundEx("weapons/riflemagslap", "Auto");
			"D6T0" "LMN" 1;
			TNT1 A 0 A_PlaySoundEx("weapons/demontech/respect1", "Auto");
			"D6T0" "OPQRSTUVWXYZ" 1;
			"D6T1" "ABCDEFGH" 1;
			TNT1 A 0 A_PlaySound("weapons/fistwhoosh2");
			"D6T1" "IJKLM" 1;
			TNT1 A 0 A_PlaySoundEx("weapons/demontech/respect4", "Auto");
			"D6T1" N 1;
			TNT1 A 0 A_PlaySoundEx("weapons/demontech/respect2", "Auto");
			TNT1 A 0 A_PlaySoundEx("HRPickup", "Auto");
			"D6T1" "OPQRSTUVWXYZ" 1;
			"D6T2" "ABCDEFGHIJKLMNOPQRST" 1;
			TNT1 A 0 A_PlaySoundEx("Ironsights", "Auto");
			"D6T2" "UVWXYZ" 1;
			"D6T3" "ABCDEFGH" 1;
			TNT1 A 0 A_PlaySoundEx("weapons/demontech/respect3", "Auto");
			"D6T3" "IJKLMNOPQRSTUV" 1;
			TNT1 A 0 A_PlaySoundEx("weapons/riflemagslap", "Auto");
			"D6T3" "WXYZ" 1;
			TNT1 A 0 A_PlaySoundEx("HRSteam", "Auto");
			"D6T4" "ABCDEFGHIJKLMNOPQRST" 1;
			Goto InsertBullets;
		
		Altfire2:
			TNT1 A 0 A_JumpIfInventory("HellAmmo",5,1);
			Goto Reload;
		CausticCharging:
			TNT1 A 0 A_PlaySound("CNTCTBM", 6);
			TNT1 A 0 A_PlaySound("Weapons/StachanovCharge",5,1.0,1);
		CausticChargingLoop:
			TNT1 A 0 A_JumpIfInventory("CausticCharge",20,2) ;//Gun has reached Max charge, skip 2 frames;
			TNT1 A 0 A_JumpIfInventory("HellAmmo",5,8);
			TNT1 A 0;
			Goto CausticChargedBlast;
			TNT1 A 0;
			//Determine Sound Level based on charged
			TNT1 A 0 A_JumpIfInventory("CausticCharge",20,"ChargeUp5");
			TNT1 A 0 A_JumpIfInventory("CausticCharge",15,"ChargeUp4");
			TNT1 A 0 A_JumpIfInventory("CausticCharge",10,"ChargeUp3");
			TNT1 A 0 A_JumpIfInventory("CausticCharge",5,"ChargeUp2");
		ChargeUp1:
			TNT1 A 0 A_FireCustomMissile("ShakeYourAss", 0, 0, 0, 0);
			TNT1 A 0 A_PlaySound("HRCharge",3);
			TNT1 A 0 A_SetBlend("Green",0.1,16);
			Goto ChargingContinue;
		ChargeUp2:
			TNT1 A 0 A_FireCustomMissile("ShakeYourAss", 0, 0, 0, 0);
			TNT1 A 0 A_PlaySound("HRCharge",3);
			TNT1 A 0 A_SetBlend("Green",0.15,16);
			Goto ChargingContinue;
		ChargeUp3:
			TNT1 A 0 A_FireCustomMissile("ShakeYourAss", 0, 0, 0, 0);
			TNT1 A 0 A_PlaySound("HRCharge",3);
			TNT1 A 0 A_SetBlend("Green",0.2,16);
			Goto ChargingContinue;
		ChargeUp4:
			TNT1 A 0 A_FireCustomMissile("ShakeYourAss", 0, 0, 0, 0);
			TNT1 A 0 A_PlaySound("HRCharge",3);
			TNT1 A 0 A_SetBlend("Green",0.25,16);
			Goto ChargingContinue;
		ChargeUp5:
			TNT1 A 0 A_FireCustomMissile("ShakeYourAss", 0, 0, 0, 0);
			TNT1 A 0 A_PlaySound("HRCharge",3);
			TNT1 A 0 A_SetBlend("Green",0.3,16);
			Goto ChargingContinue;
			
		ChargingContinue:
			D5T1 ABCD 1 BRIGHT {
					A_GiveInventory("CausticCharge", 1);
					A_Takeinventory("HellAmmo",1);
					A_WeaponOffSet(random(-1,1), random(32,34));
					A_FireCustomMissile("ShakeYourAssMinor", 0, 0, 0, 0);
			}
			D5T1 BCDABCDABCD 1 BRIGHT {
					A_WeaponOffSet(random(-1,1), random(32,34));
					A_FireCustomMissile("ShakeYourAssMinor", 0, 0, 0, 0);
			}
			TNT1 A 0 A_Refire("CausticChargingLoop");
			Goto CausticChargedBlast;
			
		CausticChargedBlast:
			TNT1 A 0 A_StopSound(5);
			TNT1 A 0 A_StopSound(6);
			TNT1 A 0 A_JumpIfInventory("CausticCharge",20,"CausticBlast4");
			TNT1 A 0 A_JumpIfInventory("CausticCharge",15,"CausticBlast3");
			TNT1 A 0 A_JumpIfInventory("CausticCharge",10,"CausticBlast2");
			TNT1 A 0 A_JumpIfInventory("CausticCharge",5,"CausticBlast1");
			goto FireUnCharged;
		
		FireUncharged:
			D3T1 A 1 BRIGHT {
				A_AlertMonsters();
				A_PlaySoundEx("Weapons/StachanovAddFire","Weapon");
				A_FireCustomMissile("GreenFlareSpawn",0,0,0,0);
				A_FireCustomMissile("ShrinkBeam", 0, 1);
				A_FireCustomMissile("GunFireSmoke", 0, 0, 0, 0, 0, 0);
				A_Takeinventory("CausticCharge",20);
				A_Overlay(-4, "CausticFlash", true);
			}
			"D3T1" B 1 BRIGHT A_ZoomFactor(0.96);
			"D3T1" C 1 BRIGHT A_ZoomFactor(0.98);
			"D3T1" D 1 BRIGHT A_ZoomFactor(1.0);
			TNT1 A 0 A_PlaySoundEx("HRSteam", "Auto");
			"D3T1" "EFGHIJKLMNOPQRS" 1;
			goto ReadyToFire2;
			
		CausticBlast1:
		CausticBlast2:
			D3T1 A 1 BRIGHT {
				A_AlertMonsters();
				A_PlaySoundEx("Weapons/StachanovAddFire","Weapon");
				A_FireCustomMissile("GreenFlareSpawn",0,0,0,0);
				A_FireCustomMissile("ShrinkBeam", 0, 1);
				A_FireCustomMissile("GunFireSmoke", 0, 0, 0, 0, 0, 0);
				A_Takeinventory("CausticCharge",20);
				A_GunFlash();
				A_Overlay(-4, "CausticFlash", true);
			}
			"D3T1" B 1 BRIGHT A_ZoomFactor(0.96);
			"D3T1" C 1 BRIGHT A_ZoomFactor(0.98);
			"D3T1" D 1 BRIGHT A_ZoomFactor(1.0);
			TNT1 A 0 A_PlaySoundEx("HRSteam", "Auto");
			"D3T1" "EFGHIJKLMNOPQRS" 1;
			goto ReadyToFire2;
		
			
		CausticBlast3:
		CausticBlast4:
			D3T1 A 1 BRIGHT {
				A_AlertMonsters();
				A_PlaySoundEx("Weapons/StachanovAddFire","Weapon");
				A_FireCustomMissile("GreenFlareSpawn",0,0,0,0);
				A_FireCustomMissile("CausticGreenPlasmaBall", 0, 1);
				A_FireCustomMissile("GunFireSmoke", 0, 0, 0, 0, 0, 0);
				A_Takeinventory("CausticCharge",20);
				A_GunFlash();
				A_Overlay(-4, "CausticFlash", true);
			}
			"D3T1" B 1 BRIGHT A_ZoomFactor(0.96);
			"D3T1" C 1 BRIGHT A_ZoomFactor(0.98);
			"D3T1" D 1 BRIGHT A_ZoomFactor(1.0);
			TNT1 A 0 A_PlaySoundEx("HRSteam", "Auto");
			"D3T1" "EFGHIJKLMNOPQRS" 1;
			goto ReadyToFire2;

		Flash:
		TNT1 A 1;
		Stop;
		Spawn:
		"VRPU" A 0 NoDelay;
		"HRPU" A 10 A_PbvpFramework("VRPU");
		"####" "#" 0 A_PbvpInterpolate();
		LOOP;
		FlashKicking:
		TNT1 A 0 A_ClearOverlays(10,11);
		TNT1 A 0 A_JumpIfInventory("FireModeAcidGun",1,"FlashKickingAcid");
		"D7T0" "ABCDEFFFGHIJKLM" 1;
		Goto Ready3;
		FlashKickingAcid:
		TNT1 A 0 A_ClearOverlays(10,11);
		"D7T1" "ABCDEFFFGHIJKLM" 1;
		Goto Ready3;
		FlashAirKicking:
		TNT1 A 0 A_ClearOverlays(10,11);
		TNT1 A 0 A_JumpIfInventory("FireModeAcidGun",1,"FlashAirKickingAcid");
		"D7T0" "ABCDEFFFFFGHIJKLM" 1;
		Goto Ready3;
		FlashAirKickingAcid:
		TNT1 A 0 A_ClearOverlays(10,11);
		"D7T1" "ABCDEFFFFFGHIJKLM" 1;
		Goto Ready3;
		FlashSlideKicking:
		TNT1 A 0 A_ClearOverlays(10,11);
		TNT1 A 0 A_JumpIfInventory("FireModeAcidGun",1,"FlashSlideKickingAcid");
		"D7T2" "ABCDEFGHIJKLMNOPPPPPQRST" 1;
		"D5T0" "AA" 1;
		Goto Ready3;
		FlashSlideKickingAcid:
		TNT1 A 0 A_ClearOverlays(10,11);
		"D7T3" "ABCDEFGHIJKLMNOPPPPPQRST" 1;
		"D5T1" "AA" 1;
		Goto Ready3;
		FlashSlideKickingStop:
		TNT1 A 0 A_ClearOverlays(10,11);
		TNT1 A 0 A_JumpIfInventory("FireModeAcidGun",1,"FlashSlideKickingStopAcid");
		"D7T2" "QRST" 1;
		"D5T0" "AAA" 1;
		Goto Ready3;
		FlashSlideKickingStopAcid:
		TNT1 A 0 A_ClearOverlays(10,11);
		"D7T3" "QRST" 1;
		"D5T1" "AAA" 1;
		Goto Ready3;
		FlashPunching:
		TNT1 A 0 A_ClearOverlays(10,11);
		TNT1 A 0 A_JumpIfInventory("FireModeAcidGun",1,"FlashPunchingAcid");
		"D7T4" "ABCDEFFFFFGHI" 1;
		"D5T0" "AA" 1;
		TNT1 A 0 A_ClearOverlays(PSP_FLASH, PSP_FLASH, false);
		Goto Ready3;
		FlashPunchingAcid:
		TNT1 A 0 A_ClearOverlays(10,11);
		"D7T5" "ABCDEFFFFFGHI" 1;
		"D5T1" "AA" 1;
		TNT1 A 0 A_ClearOverlays(PSP_FLASH, PSP_FLASH, false);
		Goto Ready3;

		PDA_Preview_HRReady:
		"D5T0" A 3 A_WeaponReady(WRF_NOFIRE);
		"D5T0" B 3 A_WeaponReady(WRF_NOFIRE);
		Stop;
		PDA_Preview_HRFireInferno:
		"D3T0" A 1 BRIGHT A_WeaponReady(WRF_NOFIRE);
		"D3T0" B 1 BRIGHT A_WeaponReady(WRF_NOFIRE);
		"D3T0" C 1 A_WeaponReady(WRF_NOFIRE);
		"D3T0" D 1 A_WeaponReady(WRF_NOFIRE);
		Stop;
		PDA_Preview_HRFireCaustic:
		"D3T1" A 1 BRIGHT A_WeaponReady(WRF_NOFIRE);
		"D3T1" B 1 BRIGHT A_WeaponReady(WRF_NOFIRE);
		"D3T1" C 1 A_WeaponReady(WRF_NOFIRE);
		"D3T1" D 1 A_WeaponReady(WRF_NOFIRE);
		Stop;
		PDA_Preview_HRAltPossess:
		"D5T0" "ABCD" 1 BRIGHT A_WeaponReady(WRF_NOFIRE);
		"D3T0" "AB" 1 BRIGHT A_WeaponReady(WRF_NOFIRE);
		"D3T0" "CD" 1 A_WeaponReady(WRF_NOFIRE);
		Stop;
		PDA_Preview_HRReload:
		"D4T0" "AB" 1 A_WeaponReady(WRF_NOFIRE);
		"D4T0" "CD" 1 A_WeaponReady(WRF_NOFIRE);
		"D4T0" "EF" 1 A_WeaponReady(WRF_NOFIRE);
		Stop;
	}
}
