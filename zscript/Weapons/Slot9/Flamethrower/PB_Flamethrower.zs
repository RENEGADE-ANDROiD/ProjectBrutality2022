// PB_Flamethrower - ZScript port (DECORATE PB_Weapon retired).

class PB_Flamethrower : PB_WeaponBase
{
	default
	{
	Weapon.BobRangeX 0.3;
	Weapon.BobRangeY 0.5;
		Weapon.BobStyle "InverseSmooth";
	Weapon.BobSpeed 2.4;
	Height 20;
	Scale 0.45;
	Weapon.SelectionOrder 5550;
	Weapon.AmmoUse1 0;
	Weapon.AmmoGive1 90;
	Weapon.AmmoType1 "Gas";
	Weapon.AmmoType2 "FlamerAmmo";
	PB_WeaponBase.respectItem "RespectFlamerGoon";
    Inventory.PickupSound "weapons/flamethrower/respect1";
     +WEAPON.NOAUTOAIM;
	+FLOORCLIP;
	+DONTGIB;
	Inventory.PickupMessage "You got the UAC-M3 Flamethrower! (Slot 9)";
	Weapon.SlotNumber 9;
	Weapon.SlotPriority 10;
	Tag "UAC-M3 Flamethrower";
	}
	states
	{
		Steady:
	TNT1 A 1;
	TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
	TNT1 A 0 SetPlayerProperty(0,0,0);
	TNT1 A 0 SetPlayerProperty(0,0,PROP_TOTALLYFROZEN);
	Goto Ready;
	
		ReadyUpgraded:
		TNT1 A 0 A_JumpIfInventory("RespectFlamerGoonUpgraded", 1, "SelectAnimation");
		TNT1 A 0 A_GiveInventory("RespectFlamerGoonUpgraded");
		TNT1 A 0 A_StartSound("Ironsights", CHAN_AUTO);
		"FLS1" "ABCD" 1 A_DoPBWeaponAction();
		//respect animation here
		StartUpgradeRespect:
		TNT1 A 0 {
			A_GiveInventory("RespectFlamerGoonUpgraded");
			A_TakeInventory("FlamerTankNotInserted",1);
			}
		"FRL1" "ABCDEFGHIJKLMNOPQRSTUVWXY" 1 A_DoPBWeaponAction();
		TNT1 A 0 A_StartSound("weapons/flamethrower/respect4", CHAN_AUTO);
		"FRL1" Z 1 A_DoPBWeaponAction();
		"FRL2" "ABCDEF" 1 A_DoPBWeaponAction();
		TNT1 A 0 A_StartSound("weapons/flamethrower/respect4", CHAN_AUTO);
		"FRL2" "GHIJKL" 1 A_DoPBWeaponAction();
		TNT1 A 0 A_StopSound(CHAN_BODY);
		TNT1 A 0 A_StartSound("weapons/flamethrower/misc1", CHAN_AUTO);
		"FRL2" "MN" 1 A_DoPBWeaponAction();
		TNT1 A 0 A_StartSound("weapons/flamethrower/hiss1", CHAN_AUTO);
		
		"FRL2" "OPQRSTUVW" 1 A_DoPBWeaponAction();
		TNT1 A 0 A_StartSound("Ironsights", CHAN_AUTO);
		"FRL2" "XYZ" 1 A_DoPBWeaponAction();
		"FRL3" "ABCDEFG" 1 A_DoPBWeaponAction();
		TNT1 A 0 A_StartSound("weapons/flamethrower/respect1", CHAN_AUTO);
	
		"FRL3" "HIJ" 1 A_DoPBWeaponAction();
		TNT1 A 0 A_PlaySound("weapons/flamethrower/respect6");
		"FRL3" "KLMNOPQRST" 1 A_DoPBWeaponAction();
		TNT1 A 0 A_StartSound("weapons/flamethrower/respect3", CHAN_AUTO);
		"FRL3" "UVWXYZ" 1 A_DoPBWeaponAction();
		"FRL4" A 1 A_DoPBWeaponAction();
		TNT1 A 0 A_StartSound("weapons/flamethrower/respect3", CHAN_AUTO);
		"FRL4" "BCDEFG" 1 A_DoPBWeaponAction();
		TNT1 A 0 A_StartSound("weapons/flamethrower/respect3", CHAN_AUTO);
		TNT1 A 0 A_StartSound("weapons/flamethrower/hiss2", CHAN_AUTO);
		"FRL4" "HIJKLMNOPQRS" 1 A_DoPBWeaponAction();
		TNT1 A 0 A_StartSound("weapons/flamethrower/click", CHAN_AUTO);
		"FRL4" "TU" 1 A_DoPBWeaponAction();
		TNT1 A 0 A_StartSound("FLIDLE",CHAN_WEAPON);
		"FRL4" "VWXYZ" 1 A_DoPBWeaponAction();
		"FRL5" "ABCDEFGHIJKLM" 1 A_DoPBWeaponAction();
		Goto Ready3;

		Ready:
		TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
		TNT1 A 0 A_JumpIfInventory("FlamerUpgraded", 1, "ReadyUpgraded");
		TNT1 A 0 PB_RespectIfNeeded;
		Goto SelectAnimation;
		WeaponRespect:
		TNT1 A 0 A_GiveInventory("RespectFlamerGoon");
		TNT1 A 0 A_StartSound("weapons/flamethrower/respect1", CHAN_AUTO);
		"RFF1" "ABCDE" 1 A_DoPBWeaponAction();
		"RFF1" "FGHIJKLMNOPQRSTUVWXYZ" 1 A_DoPBWeaponAction();
		"RFF2" "ABCDEFGHI" 1 A_DoPBWeaponAction();
		TNT1 A 0 A_StartSound("weapons/minigun/respect1", CHAN_AUTO);
		"RFF2" "JKLMNOPQRSTUVWXYZ" 1 A_DoPBWeaponAction();
		"RFF3" "ABCDEFGHIJKLMNOPQRSTUVW" 1 A_DoPBWeaponAction();
		TNT1 A 0 A_StartSound("weapons/flamethrower/respect2", CHAN_AUTO);
		"RFF3" "XYZ" 1 A_DoPBWeaponAction();
		"RFF4" "ABCDEFGHIJ" 1 A_DoPBWeaponAction();
		TNT1 A 0 A_StartSound("weapons/flamethrower/respect3", CHAN_AUTO);
		"RFF4" "JKLMNOPQRST" 1;
		TNT1 A 0 A_StartSound("weapons/flamethrower/respect5", CHAN_AUTO);
		"RFF4" "UVWXYZ" 1 A_DoPBWeaponAction();
		"RFF5" "AB" 1 A_DoPBWeaponAction();
		TNT1 A 0 A_StartSound("weapons/flamethrower/respect6", CHAN_AUTO);
		"RFF5" "CDEFGHIJKLMN" 1 A_DoPBWeaponAction();
		TNT1 A 0 A_StartSound("weapons/flamethrower/respect4", CHAN_AUTO);
		"RFF5" "OPQRSTUVWXYZ" 1 A_DoPBWeaponAction();
		TNT1 A 0 A_StartSound("weapons/flamethrower/respect4", CHAN_AUTO);
		"RFF6" "ABCDEFGHIJKLM" 1 A_DoPBWeaponAction();
		TNT1 A 0 A_StartSound("weapons/flamethrower/respect3", CHAN_AUTO);
		TNT1 A 0 A_StartSound("weapons/flamethrower/hiss2", CHAN_AUTO);
		RFF6 NOPQRSTUVWXYZ 1 {
						A_SpawnItemEx("GunFireSmoke", 6, 1, 30, 2, 2, 8, -2, SXF_NOCHECKPOSITION );
								return A_DoPBWeaponAction();
								}
		"RFF7" "ABCDEFGHIJKLMNOPQRSTUVWXYZ" 1 A_DoPBWeaponAction();
		TNT1 A 0 A_StartSound("weapons/minigun/respect2", CHAN_AUTO);
		"RFF8" "ABCDEFGHIJKLMNOPQRSTUVWXYZ" 1 A_DoPBWeaponAction();
		TNT1 A 0 A_StartSound("weapons/flamethrower/click", CHAN_AUTO);
		TNT1 A 0 A_StartSound("weapons/flamethrower/hiss1", CHAN_AUTO);
		"RFF9" "ABCDEF" 1 A_DoPBWeaponAction();
		RFF9 GHIJKLMNOPQ 1 {
						A_SpawnItemEx("GunFireSmoke", 8, 0, 38, 2, -5, 7, 2, SXF_NOCHECKPOSITION );
								return A_DoPBWeaponAction();
								}
		"RFF9" "RSTYUV" 1 A_DoPBWeaponAction();
		Goto Ready3;
		SelectAnimation:
		TNT1 A 0 A_JumpIfInventory("FlamerUpgraded", 1, "SelectAnimationUpgraded");
		"FLS2" "ABCD" 0;
		"FLS1" "ABCD" 0;
        TNT1 A 0 A_StartSound("weapons/flamethrower/respect1", CHAN_AUTO);
		FLS1 ABCD 1 {
			if(CountInv("FlamerAmmo") == 0) {A_SetWeaponSprite("FLS2");}
			}
		TNT1 A 0 A_JumpIfInventory("FlamerNukageMode", 1, "Ready4");
        Goto Ready3;

		SelectAnimationUpgraded:
		TNT1 A 0 A_StartSound("weapons/flamethrower/respect1", CHAN_AUTO);
		"FLT2" "ABCD" 0;
		"FLT1" A 0;
	    TNT1 A 0;
		FLT1 ABCD 1 {
			if(CountInv("Gas") == 0 || CountInv("FlamerNukageMode") == 1) {A_SetWeaponSprite("FLT2");}
			}
		TNT1 A 0 A_JumpIfInventory("FlamerNukageMode", 1, "Ready5");
		Goto Ready3;
	
		Ready4:
		TNT1 A 0 {
			if (CountInv("FlamerNukageMode") == 1) {
				return ResolveState("Ready3");
			}
			else if (CountInv("FlamerUpgraded") == 1) {
				if (CountInv("Gas") >= 1) {
					A_PlaySound("FLIDLE",CHAN_WEAPON,10,1);
					}
				}
			else if (CountInv("FlamerAmmo") >= 1) {
				A_PlaySound("FLIDLE",CHAN_WEAPON,10,1);
			}
			else {
				return ResolveState(null);
			}
			return ResolveState(null);
		}
		Goto Ready3;

		Ready3:
		TNT1 A 0 PB_HandleCrosshair(39);
		TNT1 A 0 {
			if(CountInv("FlamerNukageMode") == 1) {
				A_GiveInventory("HasAcidWeapon", 1);
				A_TakeInventory("HasFireWeapon", 1);
			}
			else {
				A_TakeInventory("HasAcidWeapon", 1);
				A_GiveInventory("HasFireWeapon", 1);
			}
		}
		TNT1 A 0 A_JumpIfInventory("FlamerTankNotInserted", 1, "StartUpgradeRespect");
		TNT1 A 0 A_JumpIfInventory("FlamerNukageMode", 1, "Ready5");
		TNT1 A 0 A_StartSound("weapons/flamethrower/idle",CHAN_BODY,CHANF_LOOPING,0.8);
		TNT1 A 0 A_JumpIfInventory("FlamerUpgraded", 1, "Ready2");
		TNT1 A 0 A_JumpIfInventory("FlamerAmmo", 1, 1);
		Goto NoAmmo;
		ReallyReady:
	    FRR2 AABBCC 1 {
			if(CountInv("FlamerTankNotInserted") >= 1) {
				return ResolveState("StartUpgradeRespect");
				}
			return A_DoPBWeaponAction();
		}
	    Loop;

		Ready2:
		TNT1 A 0 PB_HandleCrosshair(39);
		TNT1 A 0 A_JumpIfInventory("Gas", 1, 1);
		Goto NoAmmo;
        TNT1 A 0 A_PlaySound("FLMRIDL",6,1,1);
	    "FRR1" "AABBCC" 1 A_DoPBWeaponAction();
	    Loop;

		Ready5:
		TNT1 A 0 PB_HandleCrosshair(39);
		TNT1 A 0 A_JumpIfInventory("FlamerTankNotInserted", 1, "StartUpgradeRespect");
		TNT1 A 0 A_StartSound("weapons/flamethrower/click",CHAN_6,CHANF_LOOPING,0.8);
        "FRR1" A 0 A_JumpIfInventory("FlamerUpgraded", 1, 2);
		"FRR2" A 0;
		"####" A 0;
	    "####" D 1 A_DoPBWeaponAction();
	    Loop;


		WeaponSpecialUpgraded:
		TNT1 A 0 A_ClearOverlays(10,11);
		TNT1 A 0 A_JumpIfInventory("ToggleBlobStream", 1, "ToggleDMRBlobStreamUp");
		TNT1 A 0 A_JumpIfInventory("ToggleNukageBlob", 1, "ToggleNukageBlobModeUp");
		TNT1 A 0 A_JumpIfInventory("ToggleNukage", 1, "ToggleNukageModeUp");
		goto Ready3;
	

		ToggleNukageBlobModeUp:
		TNT1 A 0 {
			A_Takeinventory("ToggleBlobStream",1);
			A_Takeinventory("ToggleNukageBlob",1);
			A_Takeinventory("ToggleNukage",1);
			A_GunFlash();
			A_Overlay(-5, "NoOverlay");
			A_TakeInventory("FlamerNukeDMR");
			A_TakeInventory("FlamerBlobDMR");
		}
		TNT1 A 0 {
				if (CountInv("FlamerBlobStream") != 1) {
					A_GiveInventory("FlamerBlobStream");
					A_Print("\ctPrimary:\c- \cgnukage stream \c- | \ctAlt:\c- \cgnuke blob");
					return ResolveState("Unwield");
				}
				else {
					A_Print("\coFire mode \c-already \cdactive");
					return ResolveState(null);
				}
			}
		Goto Ready3;
		
		ToggleNukageModeUp:
		TNT1 A 0 A_JumpIfInventory("FlamerDMRAkimbo", 1, 2);
		Goto ToggleUpgraded;
		TNT1 A 0;
		"FDS2" A 0 A_JumpIfInventory("DMRUpgraded", 1, 2);
		"FDS1" A 0;
		"####" A 0;
		"####" "HGFEDC" 1;
		TNT1 A 0 A_TakeInventory("FlamerDMRAkimbo");
		"FDS1" "BA" 1;
		Goto ToggleUpgraded;
	
		Unwield:
		"FDS2" A 0 A_JumpIfInventory("DMRUpgraded", 1, 2);
		"FDS1" A 0;
		"####" A 0;
		"####" "HGFEDC" 1;
		TNT1 A 0 A_TakeInventory("FlamerDMRAkimbo");
		"FDS1" "BA" 1;
		Goto Ready3;
		
		WeaponSpecial:
		TNT1 A 0 A_TakeInventory("GoWeaponSpecialAbility", 1);
		TNT1 A 0 {
			A_GiveInventory("PB_LockScreenTilt",1);
			A_ZoomFactor(1.0);
			A_ClearOverlays(10,11);
			A_PlaySoundEx("Ironsights", "Auto");
		}
		TNT1 A 0 A_JumpIfInventory("FlamerUpgraded", 1, "ToggleUpgraded");
		Toggle:
		TNT1 A 0 {
			A_GunFlash();
			A_Overlay(-5, "NoOverlay");
		}
		TNT1 A 0 {
			if (CountInv("FlamerNukageMode") == 1) {
				A_TakeInventory("FlamerNukageMode");
				A_TakeInventory("FlamerBlobStream");
				A_Print("$PB_FLAMER_FLAME");
				return ResolveState("SwitchFromNukage");
			}
			else if (CountInv("FlamerAmmo") < 3) {
				A_GiveInventory("FlamerNukageMode");
				A_GiveInventory("FlamerBlobStream");
				A_Print("$PB_FLAMER_ACID");
				return ResolveState("SwitchEmpty");
			}
			else {
				A_GiveInventory("FlamerNukageMode");
				A_GiveInventory("FlamerBlobStream");
				A_Print("$PB_FLAMER_ACID");
				return ResolveState("SwitchToNukage");
			}
			return ResolveState(null);
		}
		Goto Ready3;

		ToggleUpgraded:
		TNT1 A 0;
		TNT1 A 0 {
			if (CountInv("FlamerNukageMode") == 1) {
				A_TakeInventory("FlamerNukageMode");
				A_TakeInventory("FlamerBlobStream");
				A_Print("$PB_FLAMER_FLAME");
				return ResolveState("SwitchFromNukageTube");
			}
			else if (CountInv("Gas") < 3) {
				A_GiveInventory("FlamerNukageMode");
				A_GiveInventory("FlamerBlobStream");
				A_Print("$PB_FLAMER_ACID");
				return ResolveState("SwitchEmptyTube");
			}
			else {
				A_GiveInventory("FlamerNukageMode");
				A_GiveInventory("FlamerBlobStream");
				A_Print("$PB_FLAMER_ACID");
				return ResolveState("SwitchToNukageTube");
			}
			return ResolveState(null);
		}
		Goto Ready3;
		SwitchEmpty:
		"FMD1" "PQRSTUV" 1;
		TNT1 A 0 A_PlaySound("LIGHTON");
		"FMD1" "MLKJIH" 1;
		"FMD1" "VUTSRQP" 1;
		Goto Ready3;
		SwitchEmptyTube:
		"FMD2" "PQRSTUV" 1;
		TNT1 A 0 A_PlaySound("LIGHTON");
		"FMD2" "MLKJIH" 1;
		"FMD2" "VUTSRQP" 1;
		Goto Ready3;
		SwitchFromNukage:
		"FMD1" "PQRSTUV" 1;
		TNT1 A 0 A_StopSound(CHAN_6);
		TNT1 A 0 A_PlaySound("LIGHTON");
		"FMD1" "MLKJ" 1;
		TNT1 A 0 A_PlaySound("FLIDLE",CHAN_WEAPON,10,1);
		"FMD1" "IHGFEDCBA" 1;
		Goto Ready3;
		SwitchToNukage:
		"FMD1" "ABCDEFGH" 1;
		TNT1 A 0 A_StopSound(1);
		TNT1 A 0 A_PlaySound("LIGHTON");
		"FMD1" "IJKLMNOUTSRQP" 1;
		Goto Ready3;
		SwitchFromNukageTube:
		"FMD2" "PQRSTUV" 1;
		TNT1 A 0 A_PlaySound("LIGHTON");
		"FMD2" "MLKJ" 1;
		TNT1 A 0 A_PlaySound("FLIDLE",CHAN_WEAPON,10,1);
		"FMD2" "IHGFEDCBA" 1;
		Goto Ready3;
		SwitchToNukageTube:
		"FMD2" "ABCDEFGH" 1;
		TNT1 A 0 A_StopSound(1);
		TNT1 A 0 A_PlaySound("LIGHTON");
		"FMD2" "IJKLMNOUTSRQP" 1;
		Goto Ready3;

		FlamerTurn:
		"FLK2" A 0;
		"####" A 0;
		"####" "AC" 1;
		"FLK1" "DE" 1;
		"FLK1" "GGGGGGGGGGGGGGG" 1;
		"FLK1" "ED" 1;
		"FLK2" "CA" 1;
		Stop;
	
		
		FlameReload:
		TNT1 A 0 A_JumpIfInventory("FlamerNukageMode", 1, "NoOverlay");
		TNT1 A 0 A_JumpIfInventory("FlamerAmmo", 1, 2);
		Goto NoOverlay;
		TNT1 A 0;
		"FFF1" ABCDEFGHIJKLMNOOPRSTUUWXYZYXY 1 BRIGHT;
		"FFF2" "ABC" 1 BRIGHT;
		Stop;
	
		GasMeterUnload:
		"FM14" A 0 A_JumpIfInventory("FlamerAmmo", 72, 3);
		"FM13" A 0 A_JumpIfInventory("FlamerAmmo", 54, 2);
		TNT1 A 0 A_JumpIfInventory("FlamerAmmo", 18, "GasMeterUnload32");
		"####" A 0;
		"####" "ABCDEFGHIJKLMNOOOPQRST" 1;
		Stop;
		GasMeterUnload32:
		TNT1 A 1;
		"FM12" A 0 A_JumpIfInventory("FlamerAmmo", 32, 3);
		"FM11" A 0 A_JumpIfInventory("FlamerAmmo", 18, "GasMeterUnload18");
		"####" A 0;
		"####" "ABCDEFGHIJJKLMMMNOPQRSTU" 1;
		Stop;
		GasMeterUnload18:
		"FM11" A 0 A_JumpIfInventory("FlamerAmmo", 18, 2);
		TNT1 A 0;
		"####" A 0;
		"####" "ABCDEFGHIJJLMNOPQRSTU" 1;
		Stop;
	
		Reload:
		TNT1 A 0 A_JumpIfInventory("FlamerUpgraded", 1, "Ready3") ;//no need for thattt;
		TNT1 A 0 A_JumpIfInventory("FlamerAmmo", 90, "Ready3") ;//no need for that too;
		TNT1 A 0 A_JumpIfInventory("Gas", 1, 1);
		Goto Ready3;
		TNT1 A 0 A_JumpIfInventory("FlamerUnloaded", 1, "ReloadInsertFromUnload");
		TNT1 A 0 A_GunFlash("NoOverlay");
		TNT1 A 0 A_Overlay(-3, "FlameReload");
		TNT1 A 0 A_StopSound(CHAN_BODY);
		TNT1 A 0 A_StopSound(CHAN_WEAPON);
		TNT1 A 0 A_StopSound(CHAN_6);
		TNT1 A 0 A_StartSound("IronSights", CHAN_AUTO);
		"FREL" "ABCDE" 1;
		TNT1 A 0 A_Overlay(4, "GasMeterUnload");
		"FREL" "FGHIJK" 1;
		
		TNT1 A 0 A_StartSound("LIGHTON", CHAN_AUTO);
		TNT1 A 0 A_StartSound("weapons/flamethrower/hiss2", CHAN_AUTO);
		"FREL" "LMNOPQRSTUV" 1;
		TNT1 A 0 A_StartSound("weapons/flamethrower/respect6", CHAN_AUTO);
		"FREL" "WXYZ" 1;
		TNT1 A 0 A_StartSound("weapons/flamethrower/lighthiss", CHAN_6);
		TNT1 A 0 A_StartSound("weapons/flamethrower/respect4", CHAN_AUTO);
		"FRE1" "ABCDEFG" 1;
		TNT1 A 0 A_StartSound("weapons/flamethrower/respect3", CHAN_AUTO);
		"FRE1" "HIJKLMNOPQR" 1;
		
		TNT1 A 0 A_StartSound("weapons/flamethrower/misc1", CHAN_5);
		
		FRE1 R 1 {
			if (CountInv("FlamerAmmo") == 0) {
				A_FireCustomMissile("GunFireSmoke",0,0,0,0,0,0);
				PB_SpawnCasing("FlamerEmptyGas", 30, 6, 11,frandom(-2,2),frandom(-4,-2),frandom(3,5));
			}
		}
		"FRE1" "ST" 1;
		TNT1 A 0 A_StartSound("weapons/flamethrower/hiss1", CHAN_6);
		"FRE1" "UVWXYZ" 1 A_SpawnItemEx("GunFireSmoke", 8, 16, 35, 4, -6, 2, -2, SXF_NOCHECKPOSITION );
		"FRE2" "ABCDEF" 1;
		ReloadInsert:
		"FRE2" "GHIJ" 1;
		
		TNT1 A 0 A_StartSound("weapons/flamethrower/respect3", CHAN_AUTO);
		"FRE2" "KL" 1;
		TNT1 A 0;
		"FRE2" "MNOP" 1;
		TNT1 A 0 A_StartSound("weapons/flamethrower/respect4", CHAN_AUTO);
		"FRE2" "QRSTUVWXYZ" 1;
		TNT1 A 0 A_StartSound("weapons/flamethrower/respect4", CHAN_AUTO);
		"FRE3" "AB" 1;
		TNT1 A 0 A_Overlay(4, "GasMeterRecover");
		"FRE3" "CDEFGHIJKLM" 1;
		TNT1 A 0 A_StartSound("weapons/flamethrower/respect2", CHAN_AUTO);
		"FRE3" "NOPQRSTUVWX" 1;
		TNT1 A 0 A_JumpIfInventory("FlamerNukageMode", 1, "NukeEndReload");
		"FRE3" "YZ" 1;
		"FRE4" "ABCDEF" 1;
		TNT1 A 0 A_StartSound("weapons/flamethrower/respect3", CHAN_AUTO);
		TNT1 A 0 A_StartSound("weapons/flamethrower/hiss2", CHAN_AUTO);
		"FRE4" "GHIJKLMNOPQRSTUVWXY" 1 A_SpawnItemEx("GunFireSmoke", 8, 0, 38, 2, -5, 7, 2, SXF_NOCHECKPOSITION );
		Goto ReloadLoop;
	
		ReloadInsertFromUnload:
		TNT1 A 0 A_TakeInventory("FlamerUnloaded");
		"FRE5" "XWVUT" 1;
		"FRE2" F 1 Offset(-15,38);
		"FRE2" F 1 Offset(-7, 35);
		"FRE2" F 1 A_WeaponOffset(0,32);
		Goto ReloadInsert;
		
		NukeEndReload:
		"FRE5" "TUVWX" 1;
		Goto ReloadLoop;

		GasMeterRecover:
		TNT1 A 0 { ;//I know it looks exactly like YandereDev style coding, so what :D (I'm extremely ashamed of it)
				if ( ( CountInv("FlamerAmmo") + CountInv("Gas") ) >= 90) { return ResolveState("GasMeterRecover5"); }
				else if ( ( CountInv("FlamerAmmo") + CountInv("Gas") ) >= 72) { return ResolveState("GasMeterRecover4"); }
				else if ( ( CountInv("FlamerAmmo") + CountInv("Gas") ) >= 54) { return ResolveState("GasMeterRecover3"); }
				else if ( ( CountInv("FlamerAmmo") + CountInv("Gas") ) >= 32) { return ResolveState("GasMeterRecover2"); }
				return ResolveState(null);
			}
		Stop;
		GasMeterRecover5:
		"FM25" "ADGJKLMNOPQRSTUVWXYZ" 1;
		"FM35" "ABCDE" 1;
		Stop;
		GasMeterRecover4:
		"FM24" "ADGJKLMNOPQRSTUVWXYZ" 1;
		"FM34" "ABCDE" 1;
		Stop;
		GasMeterRecover3:
		"FM23" "ADGJKLMNOPQRSTUVWXYZ" 1;
		"FM33" "ABCDE" 1;
		Stop;
		GasMeterRecover2:
		"FM22" "ADGJKLMNOPQRSTUVWXY" 1;
		Stop;
		ReloadLoop:
		TNT1 A 0 A_JumpIfInventory("Gas",1,2);
        Goto Ready3;
		TNT1 A 0;
		TNT1 A 0 A_Giveinventory("FlamerAmmo",1);
		TNT1 A 0 A_Takeinventory("Gas",1);
		TNT1 A 0 A_JumpIfInventory("FlamerAmmo", 90, "Ready3");
		Goto ReloadLoop;
	
		Unload:
		"ATFG" A 0 A_Takeinventory("Unloading",1);
		TNT1 A 0 A_JumpIfInventory("FlamerDMRAkimbo", 1, "Ready3");
		TNT1 A 0 A_JumpIfInventory("FlamerUpgraded", 1, "Ready3");
		TNT1 A 0 A_JumpIfInventory("FlamerUnloaded", 1, "Ready3");
		TNT1 A 0 A_JumpIfInventory("FlamerAmmo", 1, 2);
		Goto Ready3;
		TNT1 A 0;
		TNT1 A 0 A_GiveInventory("FlamerUnloaded");
		TNT1 A 0 {
			if (CountInv("FlamerNukageMode") == 1 || CountInv("FlamerAmmo") == 0) {
					A_StopSound(1);
				}
		}
		TNT1 A 0 A_GunFlash("NoOverlay");
		TNT1 A 0 A_Overlay(-3, "FlameReload");
		TNT1 A 0 A_StartSound("ironsights", CHAN_AUTO);
		"FREL" "ABCDE" 1;
		TNT1 A 0 A_Overlay(4, "GasMeterUnload");
		"FREL" "FGHIJKLMNOPQRSTUVWXYZ" 1;
		TNT1 A 0 A_StartSound("weapons/flamethrower/respect4", CHAN_AUTO);
		"FRE1" "ABCDEFG" 1;
		TNT1 A 0 A_StartSound("weapons/flamethrower/respect4", CHAN_AUTO);
		"FRE1" "HIJKLMNOPQ" 1;
		TNT1 A 0 A_StopSound(CHAN_BODY);
		TNT1 A 0 A_StartSound("weapons/flamethrower/hiss1", CHAN_AUTO);
		TNT1 A 0 A_StartSound("weapons/flamethrower/misc1", CHAN_AUTO);
		"FRE1" "RSTUVWXYZ" 1;
		"FRE2" "ABCDE" 1;
		"FRE5" "TUVWX" 1;
		Goto UnloadLoop;
	
		UnloadLoop:
		TNT1 A 0 A_JumpIfInventory("FlamerAmmo",1,2);
        Goto Ready3;
		TNT1 A 0;
		TNT1 A 0 A_Giveinventory("Gas",1);
		TNT1 A 0 A_Takeinventory("FlamerAmmo",1);
		Goto UnloadLoop;
		DryFire:
		NoAmmo:
		TNT1 A 0 {
			A_StopSound(CHAN_BODY);
			A_ZoomFactor(1.0);
		}
		"FRR1" A 0 A_JumpIfInventory("FlamerUpgraded", 1, 2);
		"FRR2" A 0;
		"####" A 0;
		"####" D 2 A_DoPBWeaponAction();
		"####" A 0 {
				if (CountInv("FlamerUpgraded") == 1 && CountInv("Gas") > 2) {
					 A_PlaySound("FLIDLE",CHAN_WEAPON,10,1);
					}
				else if (CountInv("FlamerAmmo") > 2 && CountInv("FlamerUpgraded") != 0) {
					 A_PlaySound("FLIDLE",CHAN_WEAPON,10,1);
					}
				return ResolveState(null);
			}
		Goto Ready3;
	
		Deselect:
	    TNT1 A 0 {
			A_StopSound(CHAN_WEAPON);
			A_StopSound(CHAN_BODY);
			A_StopSound(CHAN_6);
			A_Takeinventory("HasFireWeapon",1);
			A_Takeinventory("HasAcidWeapon",1);
			
		}
		TNT1 A 0 A_JumpIfInventory("GotMeatShield", 1, "GrabEnemy");
		TNT1 A 0 A_JumpIfInventory("FlamerDMRAkimbo", 1, "DeselectAkimbo");
		FLT2 DCBA 1 {
			if(CountInv("FlamerUpgraded") != 1) {A_SetWeaponSprite("FLS1");}
			}
		TNT1 AAAAAAAAAAAAAAAAAA 0 A_Lower;
		Wait;
		DeselectAkimbo:
		TNT1 A 0 A_ClearOverlays(10, 11);
		"FDS2" A 0 A_JumpIfInventory("DMRUpgraded", 1, 2);
		"FDS1" A 0;
		"####" A 0;
		"####" "HGFEDC" 1;
		"FDS1" "BA" 1;
		"FLT2" "DCBA" 1;
		TNT1 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 0 A_Lower;
		Wait;
		Select:
		TNT1 A 0;
		Goto SelectFirstPersonLegs;
		SelectContinue:
		TNT1 A 0;
		TNT1 A 0 PB_WeapTokenSwitch("FlameCannonSelected");
		TNT1 AAAAAAAAAAAAAAAAAA 0 A_Raise;
		TNT1 AAAAAAAA 1 A_Raise;
	    wait;
		
		Spawn:
        "FSPW" A 1;
        Loop;

		Fire:
		"FLF2" A 0 A_JumpIfInventory("FlamerUpgraded", 1, "FireUpgraded");
		TNT1 A 0 A_JumpIfInventory("FlamerNukageMode", 1, "FireNuke");
        TNT1 A 0 A_JumpIfInventory("FlamerAmmo",5,1);
		Goto Reload;
        TNT1 A 0 {
			A_AlertMonsters();
			A_StartSound("weapons/flamethrower/burst", CHAN_5 );
			}
		FRR2 D 1 {
			A_FireCustomMissile("GunFireSmoke", 0, 0, 0, -3, 0, 0);
			A_FireCustomMissile("GunFireSmoke", 0, 0, 0, -3, 0, 0);
			A_FireCustomMissile("GunFireSmoke", 0, 0, 0, -3, 0, 0);
		}
		F1B1 HGFGH 1 {
			A_FireCustomMissile("GunFireSmoke", 0, 0, 0, -3, 0, 0);
			A_FireCustomMissile("GunFireSmoke", 0, 0, 0, -3, 0, 0);
			A_FireCustomMissile("GunFireSmoke", 0, 0, 0, -3, 0, 0);
		}
		FRR2 D 1 {
			A_FireCustomMissile("GunFireSmoke", 0, 0, 0, -3, 0, 0);
			A_FireCustomMissile("GunFireSmoke", 0, 0, 0, -3, 0, 0);
			A_FireCustomMissile("GunFireSmoke", 0, 0, 0, -3, 0, 0);
		}
		TNT1 A 0 { 
			A_SetBlend("99 67 0", .2, 6);
			A_StartSound("weapons/flamethrower/start", CHAN_6 );
		}
		FireContinue:
		FLF1 ABCDEF 1 BRIGHT {
			if(CountInv("FlamerAmmo") < 1) {return ResolveState("FireStop");}
			A_FireCustomMissile("FlamethrowerMissileNew", 0, 1, 0, -3);
			A_FireCustomMissile("ShotgunParticles", random(-11,11), 0, -1, random(-15,-2));
			A_FireCustomMissile("ShotgunParticles", random(-11,11), 0, -1, random(-15,-2));
			A_FireCustomMissile("ShotgunParticles", random(-11,11), 0, -1, random(-15,-2));
			A_FireCustomMissile("ShotgunParticles", random(-11,11), 0, -1, random(-15,-2));
			return ResolveState(null);
		}
		TNT1 A 0 A_TakeInventory("FlamerAmmo", 5);
		TNT1 A 0 A_StartSound("weapons/flamethrower/loop", CHAN_WEAPON, CHANF_LOOPING);
		TNT1 A 0 A_ReFire("FireContinue");
		FireStop:
		TNT1 A 0 {
			A_StopSound(CHAN_WEAPON);
			A_StopSound(CHAN_5);
			A_StopSound(CHAN_6);
			A_StartSound("weapons/flamethrower/stop", CHAN_AUTO, CHANF_OVERLAP);
		}
		"F1B1" "ABC" 1 BRIGHT;
		"F1B1" "DEFGH" 1 A_FireCustomMissile("GunFireSmoke", 0, 0, 0, 1, 0, 0);
		Goto Ready3;
		
		
        "####" A 0 A_TakeInventory("FlamerAmmo",5);
		"####" A 0 A_AlertMonsters();
        "FLF1" D 1 BRIGHT A_SetAngle(random(1, -1) + angle);
		"####" "AAA" 0 BRIGHT A_FireCustomMissile("ShotgunParticles", random(-17,17), 0, -1, random(-12,9));
		"####" A 0 A_FireCustomMissile("FlamethrowerMissile", 0, 1, 0, -1);
        "FLF1" E 1 BRIGHT A_SetPitch(random(1, -1) + pitch);
		"####" "AAA" 0 BRIGHT A_FireCustomMissile("ShotgunParticles", random(-17,17), 0, -1, random(-12,9));
		"####" A 0 A_FireCustomMissile("FlamethrowerMissile", 0, 1, 0, -1);
        "FLF1" F 1 BRIGHT A_SetPitch(random(1, -1) + pitch);
		"####" A 0 A_PlaySoundEx("FLMRLOP", "Weapon",1);
		"####" A 0 A_ReFire("FireContinue");
		TNT1 A 0 {
			A_StopSoundEx("Weapon");
			A_PlaySoundEx("FLMREND", "Weapon");
			}
        Goto StopRegular;
	
		FireNuke:
		TNT1 A 0 A_JumpIfInventory("FlamerAmmo",2,1);
		Goto Reload;
        TNT1 A 0 {
			A_TakeInventory("FlamerAmmo", 2);
			A_AlertMonsters();
			A_StopSound(CHAN_6);
			A_StartSound("weapons/flamethrower/acidstart", CHAN_WEAPON, CHANF_OVERLAP, 0.65 );
			}
		FireContinueNuke:
		"####" A 0;
		"FLN1" "ABC" 1 BRIGHT A_FireCustomMissile("NukageStreamMissile", 0, 1, 0, -5);
        "####" A 0 A_JumpIfInventory("FlamerAmmo",2,1);
		Goto Reload;
		"####" A 0 A_AlertMonsters();
        FLN1 ABC 1 BRIGHT{
			 A_FireCustomMissile("NukageStreamMissile", 0, 1, 0, -5);
			 A_FireCustomMissile("NukageStreamMissile", 0, 1, 0, -5);
			 A_FireCustomMissile("NukageStreamMissile", 0, 1, 0, -5);
		}
		"####" A 0 {
			A_TakeInventory("FlamerAmmo", 2);
			A_StartSound("weapons/flamethrower/acidloop", CHAN_WEAPON, CHANF_LOOPING, 0.5 );
			A_StartSound("weapons/flamethrower/acidsprayloop", CHAN_5, CHANF_LOOPING , 1.0 );
		}
		"####" A 0 A_ReFire("FireContinueNuke");
		TNT1 A 0 {
			A_StopSound(CHAN_5);
			A_StopSound(CHAN_WEAPON);
			A_StartSound("weapons/flamethrower/acidstop", CHAN_WEAPON );
			}
		Goto Ready3;

		FireUpgraded:
		TNT1 A 0 A_JumpIfInventory("FlamerNukageMode", 1, "FireNukeUpgraded");
        TNT1 A 0 A_JumpIfInventory("Gas",5,1);
		Goto Ready3;
        TNT1 A 0 {
			A_AlertMonsters();
			A_StartSound("weapons/flamethrower/burst", CHAN_5 );
			}
		FRR1 D 1 {
			A_FireCustomMissile("GunFireSmoke", 0, 0, 0, -3, 0, 0);
			A_FireCustomMissile("GunFireSmoke", 0, 0, 0, -3, 0, 0);
			A_FireCustomMissile("GunFireSmoke", 0, 0, 0, -3, 0, 0);
		}
		F1B2 HGFGH 1 {
			A_FireCustomMissile("GunFireSmoke", 0, 0, 0, -3, 0, 0);
			A_FireCustomMissile("GunFireSmoke", 0, 0, 0, -3, 0, 0);
			A_FireCustomMissile("GunFireSmoke", 0, 0, 0, -3, 0, 0);
		}
		FRR1 D 1 {
			A_FireCustomMissile("GunFireSmoke", 0, 0, 0, -3, 0, 0);
			A_FireCustomMissile("GunFireSmoke", 0, 0, 0, -3, 0, 0);
			A_FireCustomMissile("GunFireSmoke", 0, 0, 0, -3, 0, 0);
		}
		TNT1 A 0 { 
			A_SetBlend("99 67 0", .2, 6);
			A_StartSound("weapons/flamethrower/start", CHAN_6 );
		}
		FireUpgradedContinue:
		FLF2 ABCDEF 1 BRIGHT {
			if(CountInv("Gas") < 1) {return ResolveState("FireStop");}
			A_FireCustomMissile("FlamethrowerMissileNew", 0, 1, 0, -3);
			A_FireCustomMissile("ShotgunParticles", random(-11,11), 0, -1, random(-15,-2));
			A_FireCustomMissile("ShotgunParticles", random(-11,11), 0, -1, random(-15,-2));
			A_FireCustomMissile("ShotgunParticles", random(-11,11), 0, -1, random(-15,-2));
			A_FireCustomMissile("ShotgunParticles", random(-11,11), 0, -1, random(-15,-2));
			return ResolveState(null);
		}
		TNT1 A 0 A_TakeInventory("Gas", 5);
		TNT1 A 0 A_StartSound("weapons/flamethrower/loop", CHAN_WEAPON, CHANF_LOOPING);
		TNT1 A 0 A_ReFire("FireUpgradedContinue");
		FireUpgradedStop:
		TNT1 A 0 {
			A_StopSound(CHAN_WEAPON);
			A_StopSound(CHAN_5);
			A_StopSound(CHAN_6);
			A_StartSound("weapons/flamethrower/stop", CHAN_AUTO, CHANF_OVERLAP);
		}
		"F1B2" A 1 BRIGHT A_FireCustomMissile("GunFireSmoke", 0, 0, 0, 1, 0, 0);
		"F1B1" "BC" 1 BRIGHT A_FireCustomMissile("GunFireSmoke", 0, 0, 0, 1, 0, 0);
		"F1B1" "DE" 1 A_FireCustomMissile("GunFireSmoke", 0, 0, 0, 1, 0, 0);
		"F1B2" "FGH" 1 A_FireCustomMissile("GunFireSmoke", 0, 0, 0, 1, 0, 0);
		Goto Ready3;
		
		FireNukeUpgraded:
		TNT1 A 0 A_JumpIfInventory("Gas",2,1);
		Goto Reload;
        TNT1 A 0 {
			A_TakeInventory("Gas", 2);
			A_AlertMonsters();
			A_StopSound(CHAN_BODY);
			A_StopSound(CHAN_6);
			A_StartSound("weapons/flamethrower/acidstart", CHAN_WEAPON, CHANF_OVERLAP, 0.65 );
			}
		FireContinueNukeUpgraded:
		"####" A 0;
		"FLN1" "EFG" 1 BRIGHT A_FireCustomMissile("NukageStreamMissile", 0, 1, 0, -5);
        "####" A 0 A_JumpIfInventory("Gas",2,1);
		Goto Ready3;
		"####" A 0 A_AlertMonsters();
        FLN1 EFG 1 BRIGHT{
			 A_FireCustomMissile("NukageStreamMissile", 0, 1, 0, -5);
			 A_FireCustomMissile("NukageStreamMissile", 0, 1, 0, -5);
			 A_FireCustomMissile("NukageStreamMissile", 0, 1, 0, -5);
		}
		"####" A 0 {
			A_TakeInventory("Gas", 2);
			A_StartSound("weapons/flamethrower/acidloop", CHAN_WEAPON, CHANF_LOOPING, 0.5 );
			A_StartSound("weapons/flamethrower/acidsprayloop", CHAN_5, CHANF_LOOPING , 1.0 );
		}
		"####" A 0 A_ReFire("FireContinueNukeUpgraded");
		FLN1 H 1 BRIGHT {
			A_StopSound(CHAN_5);
			A_StopSound(CHAN_WEAPON);
			A_StartSound("weapons/flamethrower/acidstop", CHAN_WEAPON );
			}
		Goto Ready3;
		
		
		
		
		
		
		
		
		
		
		
		
	
		StopRegular:
		TNT1 A 0 {
				if (CountInv("FlamerUpgraded") == 1 && CountInv("Gas") < 3) {
					return ResolveState("DryFire");
					}
				else if (CountInv("FlamerAmmo") < 3 && CountInv("FlamerUpgraded") != 0) {
					return ResolveState("DryFire");
					}
				return ResolveState(null);
			}
		TNT1 A 0 A_PlaySound("FLIDLE",CHAN_WEAPON,10,1);
		TNT1 AA 0 A_FireCustomMissile("FlamethrowerMissile", 0, 1, 0, 1);
		TNT1 AAAAA 0 A_FireCustomMissile("GunFireSmoke", random(-5,5), 0, random(-3,3),random(-5,-2));
		Goto Ready3;

		PDA_Preview_FlamReady:
		"FRR2" "ABC" 2;
		Stop;
		PDA_Preview_FlamFire:
		"FRR2" D 1;
		"F1B1" "HG" 1 BRIGHT;
		"FLF1" "ABC" 2 BRIGHT;
		Stop;
		PDA_Preview_FlamAltFire:
		"F1B1" A 1 BRIGHT;
		"F1B1" "BC" 1 BRIGHT;
		"F1B1" "DE" 1;
		Stop;
		PDA_Preview_FlamNukeFire:
		"FLN1" "ABC" 2 BRIGHT;
		Stop;
		PDA_Preview_FlamReload:
		"FREL" "ABCDE" 1;
		"FREL" "FG" 1;
		"FRE1" "ABC" 1;
		Stop;

		AltFire:
		TNT1 A 0 A_JumpIfInventory("FlamerUpgraded", 1, "AltFireUpgraded");
		TNT1 A 0 A_JumpIfInventory("FlamerNukageMode", 1, "AltFireNuke");
		TNT1 A 0 A_JumpIfInventory("FlamerAmmo", 9, 1);
		Goto Reload;
		F1B1 A 1 BRIGHT  {
			A_FireCustomMissile("BigFireBallWithGravity", 0, 1, 0, -2);
			A_SetBlend("Orange",0.2,6);
			A_TakeInventory("FlamerAmmo", 9);
			}
		"F1B1" "BC" 1 BRIGHT A_FireCustomMissile("ShakeYourAssDouble", 0, 0, 0, 0);
		"F1B1" "DEFGH" 1;
		Goto Ready3;
		AltFireUpgraded:
		TNT1 A 0 A_JumpIfInventory("FlamerNukageMode", 1, "AltFireNuke");
		TNT1 A 0 A_JumpIfInventory("Gas", 9, 1);
		Goto Ready3;
		F1B2 A 1 BRIGHT  {
			A_FireCustomMissile("BigFireBallWithGravity", 0, 1, 0, -2);
			A_SetBlend("Orange",0.2,6);
			A_TakeInventory("Gas", 9);
			}
		"F1B1" "BC" 1 BRIGHT A_FireCustomMissile("ShakeYourAssDouble", 0, 0, 0, 0);
		"F1B1" "DE" 1;
		"F1B1" "FGH" 1;
		Goto Ready3;

		AltFireNuke:
		// Check if upgraded or not
		// if upgraded, use directly from ammo pool
		TNT1 A 0 {
				if (CountInv("FlamerUpgraded") == 1) {
					If (CountInv("Gas") >= 9) {
						A_TakeInventory("Gas", 9);
						return ResolveState("AltFireNukeDeploy");
					}
				return ResolveState(null);
				}
				else {
					If (CountInv("FlamerAmmo") >= 9) {
						A_TakeInventory("FlamerAmmo", 9);
						return ResolveState("AltFireNukeDeploy");
					}
				return ResolveState(null);
				}
				return ResolveState("DryFire");
				}
			Goto Reload;
		AltFireNukeDeploy:
			// Handle upgraded sprite if possible
			"F2B2" A 0 A_JumpIfInventory("FlamerUpgraded", 1, 2);
			"F2B1" A 0;
			"####" A 1 BRIGHT {
				A_FireCustomMissile("NukageMissile");
				A_FireCustomMissile("ShakeYourAss", 0, 0, 0, 0);
				
				A_StartSound("weapons/flamethrower/acidgelshot");
				PB_WeaponRecoil(-0.6,+0.3);
				A_Zoomfactor(0.97);
				
			}
			"F2B1" "BC" 1 BRIGHT PB_WeaponRecoil(-0.4,+0.3);
			"F1B1" "DE" 1 PB_WeaponRecoil(-0.2,+0.2);
			TNT1 A 0 A_Zoomfactor(1);
			"F1B2" A 0 A_JumpIfInventory("FlamerUpgraded", 1, 2);
			"F1B1" A 0;
			"####" "FGH" 1;
			"FRR1" A 0 A_JumpIfInventory("FlamerUpgraded", 1, 2);
			"FRR2" A 0;
			"####" D 2 A_Refire("AltFireNuke");
			Goto Ready3;
		
		NoOverlay:
		TNT1 A 0;
		Stop;
		FlameKick:
		TNT1 A 0 A_JumpIfInventory("FlamerNukageMode", 1, "NoOverlay");
		TNT1 A 0 {
		if (CountInv("FlamerUpgraded") == 1 && CountInv("Gas") < 3) {
					return ResolveState("NoOverlay");
					}
				else if (CountInv("FlamerAmmo") < 3 && CountInv("FlamerUpgraded") != 0) {
					return ResolveState("NoOverlay");
					}
				return ResolveState(null);
			}
		"FLKF" "ABCDEFGGFEDCBA" 1 BRIGHT;
		Stop;

		FlameAirKick:
		TNT1 A 0 A_JumpIfInventory("FlamerNukageMode", 1, "NoOverlay");
		TNT1 A 0 {
		if (CountInv("FlamerUpgraded") == 1 && CountInv("Gas") < 3) {
					return ResolveState("NoOverlay");
					}
				else if (CountInv("FlamerAmmo") < 3 && CountInv("FlamerUpgraded") != 0) {
					return ResolveState("NoOverlay");
					}
				return ResolveState(null);
			}
		"FLKF" "ABCDEFGGGGFEDCBA" 1 BRIGHT;
		Stop;

		FlameSlideKick:
		TNT1 A 0 A_JumpIfInventory("FlamerNukageMode", 1, "NoOverlay");
		TNT1 A 0 {
		if (CountInv("FlamerUpgraded") == 1 && CountInv("Gas") < 3) {
					return ResolveState("NoOverlay");
					}
				else if (CountInv("FlamerAmmo") < 3 && CountInv("FlamerUpgraded") != 0) {
					return ResolveState("NoOverlay");
					}
				return ResolveState(null);
			}
		"FLKF" "ABCDEFGHIGHIGHIGHIHFEDCBA" 1 BRIGHT;
		Stop;

		FlameEndSlideKick:
		TNT1 A 0 A_JumpIfInventory("FlamerNukageMode", 1, "NoOverlay");
		TNT1 A 0 {
		if (CountInv("FlamerUpgraded") == 1 && CountInv("Gas") < 3) {
					return ResolveState("NoOverlay");
					}
				else if (CountInv("FlamerAmmo") < 3 && CountInv("FlamerUpgraded") != 0) {
					return ResolveState("NoOverlay");
					}
				return ResolveState(null);
			}
		"FLKF" "HFEDCBA" 1 BRIGHT;
		Stop;

		FlashPunching:
		TNT1 A 0 A_Overlay(-5, "FlameKick");
		"FLK1" A 0 A_JumpIfInventory("FlamerUpgraded",1,2);
		"FLK2" A 0;
		"####" A 0;
		"####" "ABC" 1;
		"FLK1" "DEFGG" 1;
		"####" F 1;
		"####" E 1;
		"####" D 1;
		"FLK1" A 0 A_JumpIfInventory("FlamerUpgraded",1,2);
		"FLK2" A 0;
		"####" A 0;
		"####" C 1;
		"####" B 1;
		"####" A 1;
		TNT1 A 0 A_ClearOverlays(PSP_FLASH, PSP_FLASH, false);
		Goto Ready3;
		
	
		FlashKicking:
		TNT1 A 0 A_Overlay(-5, "FlameKick");
		"FLK1" A 0 A_JumpIfInventory("FlamerUpgraded",1,2);
		"FLK2" A 0;
		"####" A 0;
		"####" "ABC" 1;
		"FLK1" "DEFGG" 1;
		"####" F 1;
		"####" E 1;
		"####" D 1;
		"FLK1" A 0 A_JumpIfInventory("FlamerUpgraded",1,2);
		"FLK2" A 0;
		"####" A 0;
		"####" C 1;
		"####" B 1;
		"####" A 1;
		Goto Ready3;

		FlashAirKicking:
		TNT1 A 0 A_Overlay(-5, "FlameAirKick");
		"FLK1" A 0 A_JumpIfInventory("FlamerUpgraded",1,2);
		"FLK2" A 0;
		"####" A 0;
		"####" "ABC" 1;
		"FLK1" "DEFGGGG" 1;
		"####" F 1;
		"####" E 1;
		"####" D 1;
		"FLK1" A 0 A_JumpIfInventory("FlamerUpgraded",1,2);
		"FLK2" A 0;
		"####" A 0;
		"####" C 1;
		"####" B 1;
		"####" A 1;
		Goto Ready3;
		
		FlashSlideKicking:
		TNT1 A 0 A_Overlay(-5, "FlameSlideKick");
		"FLK1" A 0 A_JumpIfInventory("FlamerUpgraded",1,2);
		"FLK2" A 0;
		"####" A 0;
		"####" "ABC" 1;
		"FLK1" "DEFGGGGGGGGGGGGG" 1;
		"####" F 1;
		"####" E 1;
		"####" D 1;
		"FLK1" A 0 A_JumpIfInventory("FlamerUpgraded",1,2);
		"FLK2" A 0;
		"####" A 0;
		"####" C 1;
		"####" B 1;
		"####" A 1;
		Goto Ready3;
		FlashSlideKickingStop:
		TNT1 A 0 A_Overlay(-5, "FlameEndSlideKick");
		"FLK1" G 1;
		"####" F 1;
		"####" E 1;
		"####" D 1;
		"FLK1" A 0 A_JumpIfInventory("FlamerUpgraded",1,2);
		"FLK2" A 0;
		"####" A 0;
		"####" C 1;
		"####" B 1;
		"####" A 1;
		Goto Ready3;
	}
}
