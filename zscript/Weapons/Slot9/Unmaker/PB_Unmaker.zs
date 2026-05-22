// PB_Unmaker - ZScript port (DECORATE PB_Weapon retired).

class PB_Unmaker : PB_WeaponBase
{
	default
	{
		//Title Unmaker
		//Category Weapons
		//Sprite UNHDA0
	Height 20;
	Weapon.BobRangeX 0.3;
	Weapon.BobRangeY 0.5;
		Weapon.BobStyle "InverseSmooth";
	Weapon.BobSpeed 2.4;
	Weapon.SelectionOrder 1800;
	Weapon.AmmoUse1 0;
	Weapon.AmmoUse2 0;
	Weapon.AmmoGive1 200;
	Weapon.AmmoGive2 200;
	Weapon.AmmoType1 "Gas";
	Weapon.AmmoType2 "Demonpower";
    Inventory.PickupSound "UNMPCK";
	Tag "Unmaker";
	Inventory.Icon "UNHDA0";
	Inventory.AltHUDIcon "UNHDA0";
    +WEAPON.NOAUTOAIM;
	+WEAPON.NOAUTOFIRE;
	//Weapon.SisterWeapon PB_Flamethrower
	Inventory.PickupMessage "You got the sinister Unmaker, the penultimate wrath of Hell itself. (Slot 9)";
	Weapon.SlotNumber 9;
	Weapon.SlotPriority 0.25;
	}
	states
	{
				
		Steady:
	TNT1 A 1;
	Goto Ready;
		
		WeaponSpecial:
		TNT1 A 0 A_Takeinventory("GoWeaponSpecialAbility",1);
		TNT1 A 0 A_Playsound("UNMSWTC");
		TNT1 A 0 A_JumpIfInventory("UnmakerFireSelected",1, "SwitchToNormal");
		TNT1 A 0 A_Print("\ctUnmaker mode:\c- \ciInferno \c-");
		TNT1 A 0 A_GiveInventory("UnmakerFireSelected",1);
		TNT1 A 0 A_TakeInventory("HasIncendiaryWeapon",1);
		"UNHF" "ABCD" 2;
		TNT1 AAAAA 0 A_FireCustomMissile("GunFireSmoke", random(-5,5), 0, random(-3,3),random(1,3));
		TNT1 A 0 A_FireCustomMissile("MancubusSwitchModeEffect", 0, 0, 0, random(1,3));
		TNT1 AAAAA 0 A_FireCustomMissile("ShotgunParticles", random(-5,5), 0, random(-3,3),random(1,3));
		"UNHF" "EE" 1 BRIGHT;
		"UNHF" "DCBA" 2;
		Goto Ready3;
		
		SwitchToNormal:
		TNT1 A 0 A_Print("\ctUnmaker mode:\c- \ckIncineration \c-");
		TNT1 A 0 A_TakeInventory("UnmakerFireSelected",1);
		TNT1 A 0 A_GiveInventory("HasIncendiaryWeapon",1);
		"UNHF" "ABCD" 2;
		"UNHF" E 1 BRIGHT;
		TNT1 A 0 A_FireCustomMissile("UnmakerSwitchModeEffect", 0, 0, 0, random(1,3));
		TNT1 A 0 A_Playsound("UNMSWT2",3);
		"UNHF" "FGHIJKLM" 1 BRIGHT;
		"UNHF" "EDCBA" 1;
		Goto Ready3;
	
		Ready:
		TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
		 TNT1 A 0 A_JumpIfInventory("UnmakerFireSelected",1, 2);
		 TNT1 A 0 A_GiveInventory("HasIncendiaryWeapon", 1);
	 	 TNT1 A 0 A_PlaySound("UNMIDL", 6,1,1);
		Ready3:
		 TNT1 A 0 PB_HandleCrosshair(39);
		 TNT1 A 0;
		 "UNHG" "ABCDE" 4 A_DoPBWeaponAction();
		 Goto Ready;
		
		Deselect:
		TNT1 A 0 A_StopSOund(1);
		TNT1 A 0 A_StopSOund(6);
		TNT1 A 0 A_Takeinventory("HasIncendiaryWeapon",1);
		TNT1 A 0 A_Takeinventory("UnmakerSelected",1);
		TNT1 A 0 A_Takeinventory("Reloading",1);
		TNT1 A 0 A_Takeinventory("Unloading",1);
		TNT1 A 0 A_TakeInventory("DoGrenade", 1);
		"UNHS" "ABCD" 1;
		TNT1 AAAAAAAAAAAAAAAAAA 0 A_Lower;
		Wait;
		
		Select:
		TNT1 A 0;
		Goto SelectFirstPersonLegs;
		SelectContinue:
		TNT1 A 0 A_Takeinventory("HasUnloaded",1);
		TNT1 A 0 PB_WeapTokenSwitch("UnmakerSelected");
		TNT1 A 0 A_Takeinventory("Unloading",1);
		TNT1 A 1 A_Raise;
		TNT1 AAAAAAAAA 0 A_Raise;
		Goto SelectAnimation;
		
		SelectAnimation:
		TNT1 A 0 A_Playsound("UNMUP");
		TNT1 A 0 A_GiveInventory("HasIncendiaryWeapon", 1);
		"UNHS" "DCBA" 1;
		GOto Ready;
		
		Spawn:
        "UNHD" A 10;
        Loop;
		
		Fire:
		TNT1 A 0 A_WeaponOffset(0,32);
		TNT1 A 0 A_JumpIfInventory("UnmakerFireSelected", 1, "FireFlameBall");
        TNT1 A 0 A_JumpIfInventory("Demonpower",4,1);
		Goto Ready;
		"UNHF" "ABCD" 1;
		TNT1 A 0 A_PlaySOund("UNMCHG", 1);
		"UNHF" "EFGHIJKLM" 2 BRIGHT;
		TNT1 A 0 A_ZoomFactor(0.95);
		TNT1 A 0 A_PlaySOund("UNMSTA", 3);
		Hold:
		TNT1 A 0 A_JumpIfInventory("UnmakerFireSelected", 1, "FireFlameBall");
        TNT1 A 0 A_JumpIfInventory("Demonpower",4,1);
		Goto Ready;
		UnmakerBeam:
        TNT1 A 0;
        TNT1 A 0 A_JumpIfInventory("Demonpower",4,1);
		Goto StopPrimary;
		TNT1 A 0;
	    "UNHF" "N" 1 BRIGHT;
		TNT1 A 0 A_PlaySOund("UNMLOP", 6, 1, 1);
		TNT1 A 0 BRIGHT A_FireCustomMissile("UnmakerLaser", 0, 0, 0, 0, 0, 0);
		TNT1 A 0 A_TakeInventory("Demonpower", 1);
		TNT1 A 0 A_RailAttack(1, 0, 0, -1, "red", RGF_NOPIERCING | RGF_SILENT | RGF_CENTERZ | RGF_FULLBRIGHT, 0, "hitpuff", 0, 0, 9999, 1);
		TNT1 A 0 PB_WeaponRecoil(-0.7,random(1, -1));
				
		"UNHF" "O" 1 BRIGHT;
		TNT1 A 0 BRIGHT A_FireCustomMissile("UnmakerLaser", 0, 0, 0, 0, 0, 0);
		TNT1 A 0 A_TakeInventory("Demonpower", 1);
		TNT1 A 0 A_RailAttack(1, 0, 0, -1, "red", RGF_NOPIERCING | RGF_SILENT | RGF_CENTERZ | RGF_FULLBRIGHT, 0, "hitpuff", 0, 0, 9999, 1);
		TNT1 A 0 PB_WeaponRecoil(-0.7,random(1, -1));
				
		"UNHF" "P" 1 BRIGHT;
		TNT1 A 0 BRIGHT A_FireCustomMissile("UnmakerLaser", 0, 0, 0, 0, 0, 0);
		TNT1 A 0 A_TakeInventory("Demonpower", 1);
		TNT1 A 0 A_RailAttack(1, 0, 0, -1, "red", RGF_NOPIERCING | RGF_SILENT | RGF_CENTERZ | RGF_FULLBRIGHT, 0, "hitpuff", 0, 0, 9999, 1);
		TNT1 A 0 PB_WeaponRecoil(-0.7,random(1, -1));
				
		"UNHF" "Q" 1 BRIGHT;
		TNT1 A 0 BRIGHT A_FireCustomMissile("UnmakerLaser", 0, 0, 0, 0, 0, 0);
		TNT1 A 0 A_TakeInventory("Demonpower", 1);
		TNT1 A 0 A_RailAttack(1, 0, 0, -1, "red", RGF_NOPIERCING | RGF_SILENT | RGF_CENTERZ | RGF_FULLBRIGHT, 0, "hitpuff", 0, 0, 9999, 1);
		TNT1 A 0 PB_WeaponRecoil(-0.7,random(1, -1));
		
		TNT1 A 0 A_Refire("UnmakerBeam");
		StopPrimary:
		TNT1 A 0 A_ZoomFactor(1.0);
		TNT1 A 0 A_StopSOund(1);
		TNT1 A 0 A_StopSOund(6);
		TNT1 A 0 A_PlaySOund("UNMRLS", 3);
		"UNHF" J 1 BRIGHT;
		TNT1 A 0 A_PlaySOund("UNMSTO", 1);
		"UNHF" "IHGF" 1 BRIGHT;
		"UNHF" "DCBA" 1;
		Goto Ready;
		
		FireFlameBall:
        TNT1 A 0;
        TNT1 A 0 A_JumpIfInventory("Gas",15,1);
		Goto Ready;
        TNT1 A 0;
		"UNHF" "ABCDE" 1;
		TNT1 A 0 A_ZoomFactor(0.97);
        "UNHF" R 1 BRIGHT A_FireCustomMissile("BigFireBallWithGravity", 0, 0, 0, 0);
		TNT1 A 0 A_TakeInventory("Gas", 15);
	    TNT1 A 0 A_FireCustomMissile("ShakeYourAssDouble", 0, 0, 0, 0);
		TNT1 AAAAA 0 BRIGHT A_FireCustomMissile("ShotgunParticles", random(-17,17), 0, -1, random(-12,12));
        "UNHF" "STUV" 1 BRIGHT;
		TNT1 A 0 A_ZoomFactor(1.0);
		"UNHF" "EBCB" 1;
		"UNHF" A 0 A_Refire("FireFlameBall");
		Goto Ready;
		
		FireFlameThrower:
        TNT1 A 0;
        TNT1 A 0 A_JumpIfInventory("Gas",4,1);
		Goto Ready;
        TNT1 A 0;
		TNT1 A 0 A_Playsound("FlmrStr", 3);
		TNT1 A 0 A_ZoomFactor(0.925);
		"UNHF" "ABCDE" 1 A_FireCustomMissile("MancubusSwitchModeEffect", 0, 0, 0, random(1,3));
		TNT1 A 0 A_Playsound("FLAMER2", 6, 1, 1);
		"UNHF" F 1 BRIGHT;
		FlamethrowerHold:
        TNT1 A 0 A_JumpIfInventory("Gas",4,1);
		Goto StopFlamer2;
		TNT1 A 0 A_AlertMonsters();
        "UNHF" W 1 BRIGHT PB_WeaponRecoil(0, random(1, -1)) ;//A_SetAngle(random(1, -1) + angle);
		TNT1 AAA 0 BRIGHT A_FireCustomMissile("ShotgunParticles", random(-17,17), 0, -1, random(-12,9));
		TNT1 A 0 A_FireCustomMissile("FlamethrowerMissile", 0, 1, 0, -1);
		TNT1 A 0 A_TakeInventory("Gas", 4);
        "UNHF" X 1 BRIGHT PB_WeaponRecoil(random(1, -1),0) ;//A_SetPitch(random(1, -1) + pitch);
		TNT1 AAA 0 BRIGHT A_FireCustomMissile("ShotgunParticles", random(-17,17), 0, -1, random(-12,9));
		TNT1 A 0 A_FireCustomMissile("FlamethrowerMissile", 0, 1, 0, -1);
		TNT1 A 0 A_TakeInventory("Gas", 4);
        "UNHF" W 1 BRIGHT PB_WeaponRecoil(random(1, -1),0) ;//A_SetPitch(random(1, -1) + pitch);
		TNT1 AAA 0 BRIGHT A_FireCustomMissile("ShotgunParticles", random(-17,17), 0, -1, random(-12,9));
		TNT1 A 0 A_FireCustomMissile("FlamethrowerMissile", 0, 1, 0, -1);
		TNT1 A 0 A_TakeInventory("Gas", 4);
		"UNHF" Y 1 BRIGHT;
		TNT1 A 0 A_Refire("FlamethrowerHold");
		StopFlamer:
		TNT1 A 0 A_StopSound(2);
		TNT1 A 0 A_StopSound(6);
		TNT1 A 0 A_PlaySound("flameren", CHAN_WEAPON);
		"UNHF" "EDCBA" 1 A_FireCustomMissile("MancubusSwitchModeEffect", 0, 0, 0, random(1,3));
		Goto Ready;
		
		StopFlamer2:
		TNT1 A 0 A_StopSound(2);
		TNT1 A 0 A_StopSound(6);
		"UNHF" "EDCBA" 1;
		Goto Ready;

		PDA_Preview_UnmakerLaser:
		"UNHF" "N" 1 BRIGHT;
		"UNHF" "O" 1 BRIGHT;
		"UNHF" "P" 1 BRIGHT;
		"UNHF" "Q" 1 BRIGHT;
		Stop;
		PDA_Preview_UnmakerInferno:
		"UNHF" "ABCDE" 1;
		"UNHF" R 1 BRIGHT;
		"UNHF" "STUV" 1 BRIGHT;
		"UNHF" "EBCB" 1;
		Stop;
		PDA_Preview_UnmakerFlamer:
		"UNHF" "ABCDE" 1;
		"UNHF" F 1 BRIGHT;
		"UNHF" W 1 BRIGHT;
		"UNHF" X 1 BRIGHT;
		"UNHF" Y 1 BRIGHT;
		Stop;
		PDA_Preview_UnmakerAltSeeker:
		"UNHF" "N" 1 BRIGHT;
		"UNHF" "Q" 1 BRIGHT;
		"UNHF" "JIHGF" 1 BRIGHT;
		"UNHF" E 1 BRIGHT;
		"UNHF" "DCBA" 1;
		Stop;
		
		Altfire:
		TNT1 A 0 A_WeaponOffset(0,32);
		TNT1 A 0 A_JumpIfInventory("UnmakerFireSelected", 1, "FireFlameThrower");
        TNT1 A 0 A_JumpIfInventory("Demonpower",4,1);
		Goto Ready;
		"UNHF" "ABCD" 1;
		TNT1 A 0 A_PlaySOund("UNMCHG2", 1);
		"UNHF" "EFGHIJKLM" 1 BRIGHT;
		Althold:
		TNT1 A 0 A_JumpIfInventory("UnmakerFireSelected", 1, "FlamethrowerHold");
        TNT1 A 0 A_JumpIfInventory("Demonpower",4,1);
		Goto StopDoomSeeker;
		TNT1 A 0;
		"UNHF" "N" 1 BRIGHT A_FireCustomMissile("UnmakerDoomSeeker", 0, 0, 0, 0, 0, 0);
		TNT1 A 0 A_TakeInventory("Demonpower", 4);
		"UNHF" "Q" 1 BRIGHT;
		TNT1 A 0 PB_WeaponRecoil(-0.5,random(1, -1));
		"UNHF" "JIHGF" 1 BRIGHT;
		TNT1 A 0 A_Refire("Althold");
		StopDoomSeeker:
		"UNHF" E 1 BRIGHT;
		"UNHF" "DCBA" 1;
		Goto Ready;
	
		FlashKicking:
		"UNHS" A 1;
		"UNHS" B 1;
		"UNHS" C 1;
		"UNHS" D 3;
		"UNHS" E 3;
		"UNHS" E 3;
		"UNHS" D 1;
		"UNHS" C 1;
		"UNHS" B 1;
		"UNHG" "AAA" 1;
		Goto Ready3;
		
		FlashAirKicking:
		"UNHS" A 1;
		"UNHS" B 1;
		"UNHS" C 1;
		"UNHS" D 3;
		"UNHS" E 3;
		"UNHS" E 3;
		"UNHS" D 1;
		"UNHS" C 1;
		"UNHS" B 1;
		"UNHG" "AAAA" 1;
		Goto Ready3;
		
		FlashSlideKicking:
		"UNHS" "ABCD" 2;
		"UNHS" "EFFFFFFEE" 2;
		Goto Ready3;
		
		FlashSlideKickingStop:
		"UNHS" "EDCBA" 1;
		"UNHG" A 1;
		Goto Ready3;
		
		FlashPunching:
		"UNHS" A 1;
		"UNHS" B 1;
		"UNHS" C 1;
		"UNHS" D 3;
		"UNHS" E 3;
		"UNHS" E 3;
		"UNHS" D 1;
		"UNHS" C 1;
		"UNHS" B 1;
		"UNHG" "AAA" 1;
		TNT1 A 0 A_ClearOverlays(PSP_FLASH, PSP_FLASH, false);
		Goto Ready3;
	}
}
