// PB_BFG9000 - ZScript port (DECORATE PB_Weapon retired).

class PB_BFG9000 : PB_WeaponBase
{
	default
	{
	Weapon.BobRangeX 0.3;
	Weapon.BobRangeY 0.5;
		Weapon.BobStyle "InverseSmooth";
	Weapon.BobSpeed 2.4;
		// Game Doom (DECORATE only)
	Height 20;
		// SpawnID (DECORATE editor only)
	Weapon.SlotNumber 9;
	Weapon.SlotPriority 0;
	Weapon.SelectionOrder 2800;
	Weapon.AmmoUse 0;
	Weapon.AmmoGive 50;
	Weapon.AmmoType "Cell";
    Inventory.PickupSound "8FGPICK";
	DamageType "Desintegrate";
    +WEAPON.NOAUTOAIM;
	+FLOORCLIP;
	+DONTGIB;
	Tag "BFG9000 MK IV";
	Inventory.PickupMessage "You got the BFG 9000 Mark IV! (Slot 9)";
	Inventory.Icon "RDABX0";
	}
	states
	{
		Spawn:
		"RDAB" X -1;
		Stop;
	
		Steady:
		TNT1 A 1;
		TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
		TNT1 A 0 SetPlayerProperty(0,0,0);
		TNT1 A 0 SetPlayerProperty(0,0,PROP_TOTALLYFROZEN);
		Goto Ready;

		Ready:
		ClassicReady:
	    TNT1 A 0;
		TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
		SelectAnimation:
		TNT1 A 0 A_PlaySound("BFGRA1S");
		"4DCX" "ABCD" 1;
        TNT1 AA 0;
		Ready3:
		TNT1 A 0 PB_HandleCrosshair(39);
		TNT1 A 0 A_PlaySound("BFGHUM", 6,1,1);
		TNT1 A 0 A_GunFlash("FlashReadyGreen");
		"4DBX" "ZZZZ" 1 {
				if (CountInv("BFGBlackHoleMode") == 1) {
					return ResolveState("BHReady");
				}
				if (CountInv("BFGGuardMode") == 1) {
					return ResolveState("GuardReady");
				}
				return A_DoPBWeaponAction();
			}
		Loop;
		
		BHReady:
	    TNT1 A 0;
		TNT1 A 0 PB_HandleCrosshair(39);
		"RDAG" "EDCBA" 0;
	    TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
        TNT1 A 0 A_PlaySound("BFGRA1S");
       	 TNT1 AA 0;
		TNT1 A 0 A_PlaySound("weapons/bhg_idle", 6,1,1);
		TNT1 A 0 A_GunFlash("FlashReadyOrange");
		"6DBX" "ZZZZ" 1 A_DoPBWeaponAction();
		Goto BHReady+9;
		
		GuardReady:
	    TNT1 A 0;
		TNT1 A 0 PB_HandleCrosshair(39);
		"RDAG" "EDCBA" 0;
	    TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
        TNT1 A 0 A_PlaySound("BFGRA1S");
        TNT1 AA 0;
		TNT1 A 0 A_PlaySound("BFGHUM", 6,1,1);
		TNT1 A 0 A_GunFlash("FlashReadyOrange");
		"6DBX" "ZZZZ" 1 A_DoPBWeaponAction();
		Goto GuardReady+9;
		
		
		LaserReady:
	    TNT1 A 0;
		TNT1 A 0 PB_HandleCrosshair(39);
		"RDAG" "EDCBA" 0;
	    TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
        TNT1 AA 0;
		TNT1 A 0 A_PlaySound("BFGHUM", 6,1,1);
		TNT1 A 0 A_GunFlash("FlashReadyRed");
		"5D5X" "ZZZZ" 1 A_DoPBWeaponAction();
		Goto LaserReady+9;

		
		
		WeaponSpecial:
		TNT1 A 0 A_TakeInventory("GoWeaponSpecialAbility", 1);
		TNT1 A 0 A_JumpIfInventory("BFGClassicMode",1, "SwitchToGuardMode");
		TNT1 A 0 A_JumpIfInventory("BFGGuardMode",1, "SwitchToBlackHoleMode");
		TNT1 A 0 A_JumpIfInventory("BFGBlackHoleMode",1, "SwitchFromBlackHoleMode");
		Goto SwitchToGuardMode;
		
		
		SwitchToGuardMode:
		TNT1 A 0 A_StopSound(6);
		TNT1 A 0 A_Takeinventory("BFGBlackHoleMode", 1);
		TNT1 A 0 A_Takeinventory("BlackHoleDetonator", 1);
		TNT1 A 0 A_ClearOverlays(-52,-52);
		TNT1 A 0 A_Takeinventory("BFGClassicMode" , 1);
		TNT1 A 0 A_GiveInventory("BFGGuardMode" , 1);
		TNT1 A 0 A_Print("\ctWeapon mode:\c- \ciGuard (shield)\c-");
		TNT1 A 0 A_GunFlash("FlashNothing");
		"4DCX" D 1;
		"4DCX" C 1;
		"4DCX" B 1;
		TNT1 A 0 A_PlaySound("BFGRA1S");
		"4DCX" B 1;
		"4DCX" C 1;
		"4DCX" D 1;
		Goto GuardReady+9;
		
		SwitchToClassicMode:
		TNT1 A 0 A_StopSound(6);
		TNT1 A 0 A_Takeinventory("BFGBlackHoleMode", 1);
		TNT1 A 0 A_Takeinventory("BlackHoleDetonator", 1);
		TNT1 A 0 A_ClearOverlays(-52,-52);
		TNT1 A 0 A_Takeinventory("BFGGuardMode" , 1);
		TNT1 A 0 A_GiveInventory("BFGClassicMode",1);
		TNT1 A 0 A_Print("\ctWeapon mode:\c- \cdClassic \c-");
		TNT1 A 0 A_GunFlash("FlashNothing");
		"4DCX" D 1;
		"4DCX" C 1;
		"4DCX" B 1;
		TNT1 A 0 A_PlaySound("BFGRA1S");
		"4DCX" B 1;
		"4DCX" C 1;
		"4DCX" D 1;
		Goto Ready+9;
	
		SwitchToBlackHoleMode:
		TNT1 A 0 A_StopSound(6);
		TNT1 A 0 A_Takeinventory("BFGGuardMode" , 1);
		TNT1 A 0 A_Takeinventory("BFGClassicMode", 1);
		TNT1 A 0 A_GiveInventory("BFGBlackHoleMode", 1);
		TNT1 A 0 A_Print("\ctWeapon mode:\c- \cuBlack Hole\c- \ck(Reload: detonate orb)\c-");
		TNT1 A 0 A_GunFlash("FlashNothing");
		"4DCX" D 1;
		"4DCX" C 1;
		"4DCX" B 1;
		TNT1 A 0 A_PlaySound("BFGRA1S");
		"4DCX" B 1;
		"4DCX" C 1;
		"4DCX" D 1;
		TNT1 A 0 A_Overlay(-52,"DetonatorLayer");
		Goto BHReady+9;
		
		SwitchFromBlackHoleMode:
		TNT1 A 0 A_StopSound(6);
		TNT1 A 0 A_Takeinventory("BFGBlackHoleMode", 1);
		TNT1 A 0 A_Takeinventory("BlackHoleDetonator", 1);
		TNT1 A 0 A_ClearOverlays(-52,-52);
		TNT1 A 0 A_GiveInventory("BFGClassicMode", 1);
		TNT1 A 0 A_Print("\ctWeapon mode:\c- \cdClassic (plasma)\c-");
		TNT1 A 0 A_GunFlash("FlashNothing");
		"4DCX" D 1;
		"4DCX" C 1;
		"4DCX" B 1;
		TNT1 A 0 A_PlaySound("BFGRA1S");
		"4DCX" B 1;
		"4DCX" C 1;
		"4DCX" D 1;
		Goto Ready+9;
		
		SwitchToLaserMode:
		TNT1 A 0 A_StopSound(6);
		TNT1 A 0 A_Takeinventory("BFGBlackHoleMode", 1);
		TNT1 A 0 A_Takeinventory("BlackHoleDetonator", 1);
		TNT1 A 0 A_ClearOverlays(-52,-52);
		TNT1 A 0 A_Takeinventory("BFGGuardMode" , 1);
		TNT1 A 0 A_TakeInventory("BFGClassicMode",1);
		TNT1 A 0 A_Print("\ctWeapon mode:\c- \ctContact \c-laser");
		TNT1 A 0 A_GunFlash("FlashNothing");
		"4DCX" D 1;
		"4DCX" C 1;
		"4DCX" B 1;
		TNT1 A 0 A_PlaySound("BFGRA1S");
		"4DCX" B 1;
		"4DCX" C 1;
		"4DCX" D 1;
		Goto LaserReady+9;
		
		
	
		FlashOff:
		TNT1 A 4;
		Stop;
	
		DetonatorLayer:
		TNT1 A 1 {
			if (JustPressed(BT_RELOAD))
			{
				A_GiveInventory("BlackHoleDetonator", 1);
				A_StartSound("weapons/pbarm", CHAN_AUTO);
			}
		}
		Loop;

		Deselect:
		TNT1 A 0 A_Gunflash("FlashOff");
		TNT1 A 0 A_StopSound(6);
		TNT1 A 0 A_ClearOverlays(-52, -52);
		TNT1 A 0 A_JumpIfInventory("GotMeatShield", 1, "GrabEnemy");
		"4DCX" "DCBA" 1;
		TNT1 AAAAAAAAAAAAAAAAAA 0 A_Lower;
		Wait;

		
		Select:
		TNT1 A 0 A_JumpIfInventory("BFGBlackHoleMode", 1, "SelectWithDetonator");
		Goto SelectFirstPersonLegs;
		SelectWithDetonator:
		TNT1 A 0 A_Overlay(-52,"DetonatorLayer");
		Goto SelectFirstPersonLegs;
		SelectContinue:
		TNT1 A 0 PB_WeapTokenSwitch("BFGSelected");
		TNT1 A 0 A_Gunflash("FlashOff");
		TNT1 AAAAAAAAAAAAAAAAAA 0 A_Raise;
		TNT1 AAAAAAAA 1 A_Raise;
		wait;
		
		
		Fire:
		TNT1 A 0 A_WeaponOffset(0,32);
		TNT1 A 0 A_JumpIfInventory("BFGBlackHoleMode", 1, "FireBlackHole");
		TNT1 A 0 A_JumpIfInventory("BFGGuardMode", 1, "FireGuard");
		TNT1 A 0 A_JumpIfInventory("BFGClassicMode", 1, "FireClassic");
		FireClassic:
		TNT1 A 0 A_StopSound(6);
        TNT1 A 0 A_JumpIfInventory("Cell",40,2);
		TNT1 A 0 A_PlaySound("Seeker", 1);
		Goto Ready+9;
		TNT1 A 0 A_GunFlash("FlashFireGreen");
        TNT1 A 0 A_PlaySound("BFGCHARGE", 0);
		TNT1 A 0 A_AlertMonsters();
		TNT1 A 0 A_SetBlend("Green",0.10,5);
		"4DAX" K 1 BRIGHT Offset(-2,34) A_FireCustomMissile("GreenFlareSpawnEvenSmaller",0,0,0,0);
		"4DAX" L 1 BRIGHT Offset(0, 32) A_FireCustomMissile("BFGLightningTrial_Small_Faster",0,0);
		"4DAX" L 1 BRIGHT Offset(2, 34) A_FireCustomMissile("BFGLightningTrial_Small_Faster",0,0);
		TNT1 A 0 A_FireCustomMissile("ShakeYourAss", 0, 0, 0, 0);
		TNT1 A 0 A_ZoomFactor(.950);
		"4DAX" M 1 BRIGHT Offset(1, 33) A_FireCustomMissile("GreenFlareSpawnSmallClose",0,0,0,0);
		"4DAX" N 1 BRIGHT Offset(-2,34) A_FireCustomMissile("BFGLightningTrial_Small_Faster",0,0);
		TNT1 A 0 A_FireCustomMissile("ShakeYourAss", 0, 0, 0, 0);
		TNT1 A 0 A_ZoomFactor(.925);
		TNT1 A 0 A_SetBlend("Green",0.15,6);
		"4DAX" M 1 BRIGHT Offset(0, 32) A_FireCustomMissile("GreenFlareSpawn",0,0,0,0);
		"4DAX" N 1 BRIGHT Offset(2, 34) A_FireCustomMissile("BFGLightningTrial_Small_Faster",0,0);
		"4DAX" O 1 BRIGHT Offset(1, 33) A_FireCustomMissile("GreenFlareSpawn",0,0,0,0);
		"4DAX" P 1 BRIGHT Offset(-2,34) A_FireCustomMissile("BFGLightningTrial_Small_Faster",0,0);
		"4DAX" O 1 BRIGHT A_FireCustomMissile("BFGLightningTrial_Small_Faster",0,0);
		"4DAX" P 1 BRIGHT A_FireCustomMissile("BFGLightningTrial_Small_Faster",0,0);
		TNT1 A 0 A_FireCustomMissile("ShakeYourAss", 0, 0, 0, 0);
        TNT1 A 0 A_PlaySound("BFGCHAFF", 1);
		TNT1 A 0 A_SetBlend("Green",0.20,8);
		"4DAX" Q 1 BRIGHT Offset(0, 32) A_FireCustomMissile("GreenFlareSpawn",0,0,0,0);
		"4DAX" R 1 BRIGHT Offset(2, 34) A_FireCustomMissile("BFGLightningTrial_Small_Faster",0,0);
		"4DAX" Q 1 BRIGHT Offset(1, 33) A_FireCustomMissile("GreenFlareSpawn",0,0,0,0);
		"4DAX" R 1 BRIGHT Offset(-2,34) A_FireCustomMissile("BFGLightningTrial_Small_Faster",0,0);
		"4DAX" S 1 BRIGHT Offset(0, 32) A_FireCustomMissile("GreenFlareSpawn",0,0,0,0);
		"4DAX" T 1 BRIGHT Offset(2, 34) A_FireCustomMissile("BFGLightningTrial_Small_Faster",0,0);
		"4DAX" S 1 BRIGHT Offset(1, 33) A_FireCustomMissile("GreenFlareSpawn",0,0,0,0);
		"4DAX" T 1 BRIGHT Offset(-2,34) A_FireCustomMissile("BFGLightningTrial_Small_Faster",0,0);
		TNT1 A 0 A_FireCustomMissile("ShakeYourAss", 0, 0, 0, 0);
		TNT1 A 0 A_SetBlend("Green",0.25,5);
		"4DAX" U 1 BRIGHT Offset(0, 32) A_FireCustomMissile("GreenFlareSpawn",0,0,0,0);
		"4DAX" T 1 BRIGHT Offset(2, 34) A_FireCustomMissile("BFGLightningTrial_Small_Faster",0,0);
		"4DAX" S 1 BRIGHT Offset(1, 33) A_FireCustomMissile("GreenFlareSpawn",0,0,0,0);
		"4DAX" T 1 BRIGHT Offset(-2,34) A_FireCustomMissile("BFGLightningTrial_Small_Faster",0,0);
		"4DAX" U 1 BRIGHT Offset(0, 32) A_FireCustomMissile("BFGLightningTrial_Small_Faster",0,0);
		TNT1 A 0 A_FireCustomMissile("ShakeYourAss", 0, 0, 0, 0);
		
		TNT1 A 0 A_SetBlend("Green",0.27,4);
		TNT1 A 0 A_FireCustomMissile("GreenFlareSpawn",0,0,0,0);
		"4DAX" S 1 BRIGHT Offset(0,36);//;
		"4DAX" T 1 BRIGHT Offset(0,37);//;
		"4DAX" U 1 BRIGHT Offset(0,38);
		"4DAX" T 1 BRIGHT Offset(0,39);
		TNT1 A 0 A_ZoomFactor(.9);
        TNT1 A 0 A_PlaySound("BFG_FIRE", 1);
		TNT1 A 0 A_FireCustomMissile("GreenFlareSpawn",0,0,0,0);
		TNT1 AAA 0 A_FireCustomMissile("BFGLightningTrial_Small_Faster",0,0,0,0);
        TNT1 A 0 A_Recoil(6);
        TNT1 A 0 BRIGHT A_FireCustomMissile("Alerter", 0, 0, -1, 0);
        TNT1 A 0 BRIGHT A_FireCustomMissile("PB_SuperBFGBall");
        TNT1 A 0 PB_WeaponRecoil(-11.5 * pb_weapon_recoil_extra_weapons,-4.2 * pb_weapon_recoil_extra_weapons) ;//Add some weapon recoil - sarge945;
		TNT1 A 0 A_Takeinventory("Cell",40);
		TNT1 A 0 A_SetBlend("Green",0.30,5);
		"4DAX" V 1  BRIGHT;
		"4DAX" W 1  BRIGHT;
		"4DAX" X 1  BRIGHT;
		TNT1 A 0 A_FireCustomMissile("ShakeYourAssDouble", 0, 0, 0, 0);
		TNT1 A 0 A_ZoomFactor(.925);
		"4DAX" Y 1 A_FireCustomMissile("GreenFlareSpawn",0,0,0,0);
		TNT1 A 0 A_ZoomFactor(.95);
		"4DAX" Z 1 Offset(0,34) A_FireCustomMissile("GreenFlareSpawn",0,0,0,0);
		TNT1 A 0 A_ZoomFactor(.975);
		"4DBX" Z 2 Offset(0,33)A_FireCustomMissile("GreenFlareSpawn",0,0,0,0);
		TNT1 A 0 A_ZoomFactor(1.0);
		"4DBX" Z 2 Offset(0,32)A_FireCustomMissile("GreenFlareSpawn",0,0,0,0);
		
		"4DBX" Z 2;
		TNT1 A 0 A_ReFire;
		Goto Ready+9;
		
		FireBlackHole:
		TNT1 A 0 A_StopSound(6);
		TNT1 A 0 A_TakeInventory("BlackHoleDetonator", 1);
		TNT1 A 0 A_JumpIfInventory("Cell", 80, 1);
		Goto FailedToFireBlackHole;
		TNT1 A 0 {
			A_StartSound("bh_Charge", CHAN_WEAPON, 1.0, ATTN_NORM, 0);
			A_AlertMonsters();
		}
		TNT1 A 0 A_SetBlend("Purple", 0.12, 10);
		"6DAX" "EFGH" 1 BRIGHT;
		"6DAX" "IJKL" 1 BRIGHT;
		"6DBX" "MNOP" 1 BRIGHT;
		TNT1 A 0 A_FireCustomMissile("ShakeYourAss", 0, 0, 0, 0);
		"6DBX" "QR" 1 BRIGHT;
		TNT1 A 0 {
			A_FireCustomMissile("BFG_Blackhole_Ball", 0, 1, 0, 0);
			A_TakeInventory("Cell", 80);
			A_AlertMonsters();
		}
		"6DBX" "STUV" 1 BRIGHT;
		TNT1 A 0 A_ReFire;
		Goto BHReady+9;
		
		FailedToFireBlackHole:
		TNT1 A 0 A_JumpIfInventory("Cell", 1, 2);
		TNT1 A 0 A_PlaySound("Seeker", 1);
		Goto BHReady+9;
		TNT1 A 0 A_StartSound("weapons/empty", CHAN_AUTO);
		Goto BHReady+9;
		
		FireGuard:
		TNT1 A 0 A_StopSound(6);
		TNT1 A 0 A_JUMPIFINVENTORY("CELL",1, 2);
		TNT1 A 0 A_PlaySound("Seeker", 1);
		Goto GuardReady+9;
        TNT1 A 0 A_PlaySound("SHLDSTT",2);
		FireGuardHold:
		TNT1 A 0 A_PlaySound("SHLDLP", 3,1,1);
		TNT1 A 0 A_GunFlash("FlashFireOrange");
		TNT1 A 0 A_AlertMonsters();
		TNT1 A 0 A_SpawnItemEx ("ShieldSpawner", 0, 68, 0, 0, 0, 0, -270, 32);
		"6DBX" E 1 BRIGHT Offset(-2,34) A_SpawnItemEx ("ShieldSpawner", 0,68, 0, 0, 0, 0, -270, 32);
		TNT1 A 0 A_SpawnItemEx ("ShieldSpawner", 0, 68, 0, 0, 0, 0, -270, 32);
		"6DBX" F 1 BRIGHT Offset(0, 32) A_SpawnItemEx ("ShieldSpawner", 0, 68, 0, 0, 0, 0, -270, 32);
		TNT1 A 0 A_SpawnItemEx ("ShieldSpawner", 0, 68, 0, 0, 0, 0, -270, 32);
		TNT1 A 0 A_FireCustomMissile("HellionTrailSpark_Fast", random(-30,30), 0, random(-3,3), 0);
		"6DBX" G 1 BRIGHT Offset(2, 34) A_SpawnItemEx ("ShieldSpawner", 0, 68, 0, 0, 0, 0, -270, 32);
		TNT1 A 0 A_SpawnItemEx ("ShieldSpawner", 0, 68, 0, 0, 0, 0, -270, 32);
		"6DBX" H 1 BRIGHT Offset(1, 33) A_SpawnItemEx ("ShieldSpawner", 0, 68, 0, 0, 0, 0, -270, 32);
		TNT1 A 0 A_SpawnItemEx ("ShieldSpawner", 0, 68, 0, 0, 0, 0, -270, 32);
		TNT1 A 0 A_FireCustomMissile("HellionTrailSpark_Fast", random(-30,30), 0, random(-3,3), 0);
		TNT1 A 0 A_Takeinventory("Cell",2);
		TNT1 A 0 A_JUMPIFINVENTORY("CELL",1,2);
		TNT1 A 0 A_StopSound(3);
		Goto GuardReady+9;
        TNT1 A 0 A_ReFire("FireGuardHold");
		TNT1 A 0 A_StopSound(3);
		Goto GuardReady+9;
		
		
		FireLaser:
	  TNT1 A 0 A_StopSound(6);
	  TNT1 A 0 A_JumpIfInventory("Cell", 5, 2);
	  TNT1 A 0 A_PlaySound("Seeker", 1);
	  Goto LaserReady+9;
	  TNT1 A 0 A_GunFlash("FlashFireRed");
		"5D5X" A 1 BRIGHT Offset(-2,34);
		"5D5X" B 1 BRIGHT Offset(0, 32);
		"5D5X" C 1 BRIGHT Offset(2, 34);
		"5D5X" D 1 BRIGHT Offset(1, 33);
		"5D5X" E 1 BRIGHT Offset(0, 34);
      TNT1 A 0 A_ReFire("Charge1A");
      TNT1 A 0 A_FireCustomMissile("ObeliskProjectile",0,0,0,-1,0,0);
	  TNT1 A 0 A_Takeinventory("Cell",5);
	  TNT1 A 0 A_FireCustomMissile("RedFlareSpawn",0,0,0,0);
	  TNT1 AAAAAA 0;
      TNT1 A 0 A_SetBlend("Red",0.25,15);
      TNT1 A 0 A_StopSound(5);
	  TNT1 A 0;
	  TNT1 A 0 A_AlertMonsters();
	  TNT1 A 0 A_PlaySound("Weapons/StachanovFire",1);
	  TNT1 A 0 A_PlaySound("Weapons/StachanovAddFire",0);
		"5D5X" K 1 BRIGHT A_ZoomFactor(0.95);
		"5D5X" L 1 BRIGHT A_ZoomFactor(0.96);
		"5D5X" M 1 BRIGHT A_ZoomFactor(0.97);
		"5D5X" N 1 BRIGHT A_ZoomFactor(0.98);
		"5D5X" O 1 BRIGHT A_ZoomFactor(0.99);
		"5D5X" P 1;
		"5D5X" Q 1;
	  
	  TNT1 A 0 A_GunFlash("FlashReadyRed");
		"5D5X" Z 4 A_ZoomFactor(1);
	  TNT1 A 0 A_GunFlash("FlashReadyRed");
		"5D5X" Z 4;
      goto LaserReady+9;
	  
		Charge1A:
	  TNT1 A 0 A_JumpIfInventory("Cell", 15, 2);
	  TNT1 A 0 A_PlaySound("Seeker", 1);
	  Goto FireLaser+10;
	  TNT1 A 0 A_PlaySound("CNTCTBM", 6);
      "OBLG" A 0 A_PlaySound("Weapons/StachanovCharge",5,1.0,1);
	  TNT1 A 0 A_PlaySound("BEPBEP", 2);
      "OBLG" D 0 A_Quake (1, 9, 0, 3, 0);
	  TNT1 A 0 A_GunFlash("FlashFireRedCharge1");
	  TNT1 A 0 A_AlertMonsters();
		"5D5X" B 1 BRIGHT Offset(-2, 34) A_SetBlend("Red",0.1,6);
		"5D5X" C 1 BRIGHT Offset(0, 32) A_SetBlend("Red",0.1,6);
		"5D5X" D 1 BRIGHT Offset(2, 34) A_SetBlend("Red",0.1,6);
		"5D5X" E 1 BRIGHT Offset(1, 33) A_SetBlend("Red",0.1,6);
		"5D5X" F 1 BRIGHT Offset(0, 34) A_SetBlend("Red",0.1,6);
      TNT1 A 0 A_ReFire("Charge1B");
      Goto FireLaser+3;
		Charge1B:
      "OBLG" D 0 A_Quake (1, 9, 0, 3, 0);
	  TNT1 A 0 A_GunFlash("FlashFireRedCharge1");
		"5D5X" G 1 BRIGHT Offset(-2, 34) A_SetBlend("Red",0.1,6);
		"5D5X" H 1 BRIGHT Offset(0, 32) A_SetBlend("Red",0.1,6);
		"5D5X" I 1 BRIGHT Offset(2, 34) A_SetBlend("Red",0.1,6);
		"5D5X" J 1 BRIGHT Offset(1, 33) A_SetBlend("Red",0.1,6);
		"5D5X" A 1 BRIGHT Offset(0, 34) A_SetBlend("Red",0.1,6);
      TNT1 A 0 A_ReFire("Charge1C");
      Goto ChargedFire1;
		Charge1C:
      "OBLG" D 0 A_Quake (1, 9, 0, 3, 0);
	  TNT1 A 0 A_GunFlash("FlashFireRedCharge1");
		"5D5X" B 1 BRIGHT Offset(-2, 34) A_SetBlend("Red",0.1,6);
		"5D5X" C 1 BRIGHT Offset(0, 32) A_SetBlend("Red",0.1,6);
		"5D5X" D 1 BRIGHT Offset(2, 34) A_SetBlend("Red",0.1,6);
		"5D5X" E 1 BRIGHT Offset(1, 33) A_SetBlend("Red",0.1,6);
		"5D5X" F 1 BRIGHT Offset(0, 34) A_SetBlend("Red",0.1,6);
      TNT1 A 0 A_ReFire("Charge2A");
      Goto ChargedFire1;

		Charge2A:
	  TNT1 A 0 A_JumpIfInventory("Cell", 25, 2);
	  TNT1 A 0 A_PlaySound("Seeker", 1);
	  Goto ChargedFire1;
      "OBLG" D 0 A_Quake (2, 6, 0, 3, 0);
	  TNT1 A 0 A_GunFlash("FlashFireRedCharge2");
	  TNT1 A 0 A_AlertMonsters();
	  TNT1 A 0 A_PlaySound("BEPBEP", 1);
		"5D5X" G 1 BRIGHT Offset(-2, 34) A_SetBlend("Red",0.15,6);
		"5D5X" H 1 BRIGHT Offset(0, 32) A_SetBlend("Red",0.15,6);
		"5D5X" I 1 BRIGHT Offset(2, 34) A_SetBlend("Red",0.15,6);
		"5D5X" J 1 BRIGHT Offset(1, 33) A_SetBlend("Red",0.15,6);
		"5D5X" A 1 BRIGHT Offset(0, 34) A_SetBlend("Red",0.15,6);
		"5D5X" B 1 BRIGHT Offset(-2, 34) A_SetBlend("Red",0.15,6);
		"5D5X" C 1 BRIGHT Offset(0, 32) A_SetBlend("Red",0.15,6);
		"5D5X" D 1 BRIGHT Offset(2, 34) A_SetBlend("Red",0.15,6);
		"5D5X" E 1 BRIGHT Offset(1, 33) A_SetBlend("Red",0.15,6);
		"5D5X" F 1 BRIGHT Offset(0, 34) A_SetBlend("Red",0.15,6);
      TNT1 A 0 A_ReFire("Charge2B");
      Goto ChargedFire2;
		Charge2B:
      "OBLG" D 0 A_Quake (2, 6, 0, 3, 0);
	  TNT1 A 0 A_GunFlash("FlashFireRedCharge2");
		"5D5X" G 1 BRIGHT Offset(-2, 34) A_SetBlend("Red",0.15,6);
		"5D5X" H 1 BRIGHT Offset(0, 32) A_SetBlend("Red",0.15,6);
		"5D5X" I 1 BRIGHT Offset(2, 34) A_SetBlend("Red",0.15,6);
		"5D5X" J 1 BRIGHT Offset(1, 33) A_SetBlend("Red",0.15,6);
		"5D5X" A 1 BRIGHT Offset(0, 34) A_SetBlend("Red",0.15,6);
		"5D5X" B 1 BRIGHT Offset(-2, 34) A_SetBlend("Red",0.15,6);
		"5D5X" C 1 BRIGHT Offset(0, 32) A_SetBlend("Red",0.15,6);
		"5D5X" D 1 BRIGHT Offset(2, 34) A_SetBlend("Red",0.15,6);
		"5D5X" E 1 BRIGHT Offset(1, 33) A_SetBlend("Red",0.15,6);
		"5D5X" F 1 BRIGHT Offset(0, 34) A_SetBlend("Red",0.15,6);
      TNT1 A 0 A_ReFire("Charge2C");
      Goto ChargedFire2;
		Charge2C:
      "OBLG" D 0 A_Quake (1, 6, 0, 3, 0);
	  TNT1 A 0 A_GunFlash("FlashFireRedCharge2");
		"5D5X" G 1 BRIGHT Offset(-2, 34) A_SetBlend("Red",0.15,6);
		"5D5X" H 1 BRIGHT Offset(0, 32) A_SetBlend("Red",0.15,6);
		"5D5X" I 1 BRIGHT Offset(2, 34) A_SetBlend("Red",0.15,6);
		"5D5X" J 1 BRIGHT Offset(1, 33) A_SetBlend("Red",0.15,6);
		"5D5X" A 1 BRIGHT Offset(0, 34) A_SetBlend("Red",0.15,6);
		"5D5X" B 1 BRIGHT Offset(-2, 34) A_SetBlend("Red",0.15,6);
		"5D5X" C 1 BRIGHT Offset(0, 32) A_SetBlend("Red",0.15,6);
		"5D5X" D 1 BRIGHT Offset(2, 34) A_SetBlend("Red",0.15,6);
		"5D5X" E 1 BRIGHT Offset(1, 33) A_SetBlend("Red",0.15,6);
		"5D5X" F 1 BRIGHT Offset(0, 34) A_SetBlend("Red",0.15,6);
      TNT1 A 0 A_ReFire("Charge2D");
      Goto ChargedFire2;
		Charge2D:
      "OBLG" D 0 A_Quake (1, 6, 0, 3, 0);
	  TNT1 A 0 A_GunFlash("FlashFireRedCharge2");
		"5D5X" G 1 BRIGHT Offset(-2, 34) A_SetBlend("Red",0.15,6);
		"5D5X" H 1 BRIGHT Offset(0, 32) A_SetBlend("Red",0.15,6);
		"5D5X" I 1 BRIGHT Offset(2, 34) A_SetBlend("Red",0.15,6);
		"5D5X" J 1 BRIGHT Offset(1, 33) A_SetBlend("Red",0.15,6);
		"5D5X" A 1 BRIGHT Offset(0, 34) A_SetBlend("Red",0.15,6);
		"5D5X" B 1 BRIGHT Offset(-2, 34) A_SetBlend("Red",0.15,6);
		"5D5X" C 1 BRIGHT Offset(0, 32) A_SetBlend("Red",0.15,6);
		"5D5X" D 1 BRIGHT Offset(2, 34) A_SetBlend("Red",0.15,6);
		"5D5X" E 1 BRIGHT Offset(1, 33) A_SetBlend("Red",0.15,6);
		"5D5X" F 1 BRIGHT Offset(0, 34) A_SetBlend("Red",0.15,6);
      TNT1 A 0 A_ReFire("Charge3A");
      Goto ChargedFire2;

		Charge3A:
	  TNT1 A 0 A_JumpIfInventory("Cell", 40, 2);
	  TNT1 A 0 A_PlaySound("Seeker", 1);
	  Goto ChargedFire2;
      "OBLG" D 0 A_Quake (1, 6, 0, 3, 0);
	  TNT1 A 0 A_GunFlash("FlashFireRedCharge1");
	  TNT1 A 0 A_AlertMonsters();
	  TNT1 A 0 A_PlaySound("BEPBEP", 0);
		"5D5X" G 1 BRIGHT Offset(-2, 34) A_SetBlend("Red",0.2,1);
		"5D5X" H 1 BRIGHT Offset(0, 32) A_SetBlend("Red",0.2,1);
		"5D5X" I 1 BRIGHT Offset(2, 34) A_SetBlend("Red",0.18,1);
		"5D5X" J 1 BRIGHT Offset(1, 33) A_SetBlend("Red",0.2,1);
		"5D5X" A 1 BRIGHT Offset(0, 34) A_SetBlend("Red",0.18,1);
      TNT1 A 0 A_ReFire("Charge3B");
      Goto ChargedFire3;
		Charge3B:
      "OBLG" D 0 A_Quake (1, 6, 0, 3, 0);
	  TNT1 A 0 A_GunFlash("FlashFireRedCharge1");
		"5D5X" A 1 BRIGHT Offset(-2, 34) A_SetBlend("Red",0.2,1);
		"5D5X" B 1 BRIGHT Offset(0, 32) A_SetBlend("Red",0.2,1);
		"5D5X" C 1 BRIGHT Offset(2, 34) A_SetBlend("Red",0.18,1);
		"5D5X" D 1 BRIGHT Offset(1, 33) A_SetBlend("Red",0.2,1);
		"5D5X" E 1 BRIGHT Offset(0, 34) A_SetBlend("Red",0.18,1);
      TNT1 A 0 A_ReFire("Charge3C");
      Goto ChargedFire3;
		Charge3C:
      "OBLG" D 0 A_Quake (1, 6, 0, 3, 0);
	  TNT1 A 0 A_GunFlash("FlashFireRedCharge1");
		"5D5X" F 1 BRIGHT Offset(-2, 34) A_SetBlend("Red",0.2,1);
		"5D5X" G 1 BRIGHT Offset(0, 32) A_SetBlend("Red",0.2,1);
		"5D5X" H 1 BRIGHT Offset(2, 34) A_SetBlend("Red",0.18,1);
		"5D5X" I 1 BRIGHT Offset(1, 33) A_SetBlend("Red",0.2,1);
		"5D5X" J 1 BRIGHT Offset(0, 34) A_SetBlend("Red",0.18,1);
      TNT1 A 0 A_ReFire("Charge3D");
      Goto ChargedFire3;
		Charge3D:
      "OBLG" D 0 A_Quake (1, 6, 0, 3, 0);
	  TNT1 A 0 A_GunFlash("FlashFireRedCharge1");
		"5D5X" A 1 BRIGHT Offset(-2, 34) A_SetBlend("Red",0.2,1);
		"5D5X" B 1 BRIGHT Offset(0, 32) A_SetBlend("Red",0.2,1);
		"5D5X" C 1 BRIGHT Offset(2, 34) A_SetBlend("Red",0.18,1);
		"5D5X" D 1 BRIGHT Offset(1, 33) A_SetBlend("Red",0.2,1);
		"5D5X" E 1 BRIGHT Offset(0, 34) A_SetBlend("Red",0.18,1);
      Goto ChargedFire3;

		ChargedFire1:
      TNT1 A 0 A_PlaySound("Weapons/StachanovCharged1",6);
      TNT1 A 0 A_SetBlend("Red",0.3,20);
      TNT1 A 0 A_FireCustomMissile("ObeliskProjectile1",0,0,0,-1,0,0.0);
	  TNT1 A 0 A_Takeinventory("Cell", 15);
	  TNT1 A 0 A_FireCustomMissile("RedFlareSpawn",0,0,0,0);
      Goto FireLaser+12;
		ChargedFire2:
      TNT1 A 0 A_PlaySound("Weapons/StachanovCharged2",6);
      TNT1 A 0 A_SetBlend("Red",0.35,25);
      TNT1 A 0 A_FireCustomMissile("ObeliskProjectile2",0,0,0,-1,0,0.0);
	  TNT1 A 0 A_Takeinventory("Cell",25);
	  TNT1 A 0 A_FireCustomMissile("RedFlareSpawn",0,0,0,0);
      Goto FireLaser+12;
		ChargedFire3:
      TNT1 A 0 A_PlaySound("Weapons/StachanovCharged3",6);
      TNT1 A 0 A_SetBlend("Red",0.4,30);
      TNT1 A 0 A_FireCustomMissile("ObeliskProjectile3",0,0,0,-1,0,0.0);
	  TNT1 A 0 A_Takeinventory("Cell",40);
	  TNT1 A 0 A_FireCustomMissile("RedFlareSpawn",0,0,0,0);
      Goto FireLaser+12;
		
		

		AltFire:
		TNT1 A 0 A_WeaponOffset(0,32);
		TNT1 A 0 A_JumpIfInventory("BFGBlackHoleMode", 1, "AltFireBlackHole");
		TNT1 A 0 A_JumpIfInventory("BFGGuardMode", 1, "AltFireGuard");
		TNT1 A 0 A_JumpIfInventory("BFGClassicMode", 1, "AltFireClassic");
		AltFireClassic:
		TNT1 A 0 A_StopSound(6);
		TNT1 A 0 A_JumpIfInventory("Cell", 5, 3);
		TNT1 A 0 A_PlaySound("Seeker", 1);
		Goto Ready+9;
		TNT1 AAAA 0;
		TNT1 A 0 A_GunFlash("FlashNothing");
		TNT1 A 0 A_AlertMonsters();
		TNT1 A 0 A_StartSound("weapons/bfg_beamstart", 5);
		"4DAX" V 1 BRIGHT A_PlaySound("BFGFIRE", CHAN_WEAPON, 1.2);
		TNT1 A 0 A_FireCustomMissile("GreenFlareSpawn", 0, 0, 0, 0);
		"4DAX" "WXYZ" 1 BRIGHT;
		TNT1 A 0 PB_WeaponRecoil(-4.6 * pb_weapon_recoil_extra_weapons, -2.4 * pb_weapon_recoil_extra_weapons);
		TNT1 A 0 A_FireCustomMissile("ShakeYourAssDouble", 0, 0, 0, 0);
		TNT1 A 0 A_FireCustomMissile("GreenFlareSpawn", 0, 0, 0, 0);
		"4DAX" Z 1 A_GunFlash("FlashAltFireGreen");
		TNT1 A 0 A_SetBlend("Green", 0.2, 7);
		TNT1 A 0 A_PlaySound("Weapons/BFSG/Fire", CHAN_AUTO);
		TNT1 A 0 A_ZoomFactor(0.94);
		TNT1 A 0 A_ZoomFactor(1.0);
		BFGBeamLoop:
		"4DBX" Z 1 {
			PB_FireAltBFGRail();
			A_TakeInventory("Cell", 1);
			A_GunFlash("FlashAltFireGreen");
		}
		TNT1 A 0 A_JumpIfInventory("Cell", 1, 2);
		Goto BFGBeamStop;
		TNT1 A 0 A_StartSound("Leech/Fire", CHAN_WEAPON, CHANF_LOOPING);
		TNT1 A 0 PB_ReFire("BFGBeamLoop");
		BFGBeamStop:
		TNT1 A 0 A_StopSound(CHAN_WEAPON);
		TNT1 A 0 A_PlaySound("Weapons/BFGG/Explode", CHAN_AUTO);
		"4DBX" Z 2;
		Goto Ready+9;
		
		AltFireBlackHole:
		TNT1 A 0 A_StopSound(6);
		TNT1 A 0 A_TakeInventory("BlackHoleDetonator", 1);
		TNT1 A 0 A_JumpIfInventory("Cell", 30, 1);
		Goto FailedToFireBlackHole;
		TNT1 A 0 A_StartSound("weapons/bh_sec_charge1", CHAN_AUTO);
		"6DAX" "EFGH" 1 Offset(0, 32);
		TNT1 A 0 A_StartSound("weapons/bh_sec_charge2", CHAN_BODY);
		"6DAX" "IJKLMNOPQRSTUVWXYZ" 1 Offset(0, 32) A_GunFlash("FlashFireOrange");
		"6DBX" "ABCD" 1 Offset(0, 32) A_GunFlash("FlashFireOrange");
		"6DBX" E 1 {
			A_StopSound(CHAN_BODY);
			A_StartSound("weapons/bh_secondary", CHAN_WEAPON);
			A_FireCustomMissile("BFG_BlackHole_GravityBomb", 0, 1, 0, 0);
			A_TakeInventory("Cell", 30);
			A_GunFlash("FlashFireOrange");
		}
		"6DBX" "FGHI" 1 A_GunFlash("FlashFireOrange");
		TNT1 A 0 A_ReFire;
		Goto BHReady+9;
		
		AltFireGuard:
		TNT1 A 0 A_StopSound(6);
		TNT1 A 0 A_JumpIfInventory("Cell", 40, 3);
	    TNT1 A 0 A_PlaySound("Seeker", 1);
		Goto GuardReady+9;
		TNT1 AAAAA 0;
        TNT1 A 0 A_PlaySound("SHLDSTT", 2);
		AltFireGuardHold:
		TNT1 A 0 A_PlaySound("SHLDLP", 3,1,1);
		TNT1 A 0 A_GunFlash("FlashFireOrange");
		TNT1 A 0 A_AlertMonsters();
		TNT1 A 0;
		"6DBX" E 1 BRIGHT Offset(-2,34);
		"6DBX" F 1 BRIGHT Offset(0, 32);
		"6DBX" G 1 BRIGHT Offset(2, 34);
		"6DBX" H 1 BRIGHT Offset(1, 33);
		
		TNT1 A 0;
		TNT1 A 0 A_Takeinventory("Cell",1);
		TNT1 AAAA 0 A_FireCustomMissile("HellionTrailSpark_Fast", random(-30,30), 0, random(-3,3), 0);
		TNT1 A 0 BRIGHT A_SpawnItemEx ("ShieldSpawnerPlacedCover", 0, 68, 0, 0, 0, 0, -270, 32);
		TNT1 A 0 A_Takeinventory("Cell", 40);
		TNT1 A 0 A_GunFlash("FlashReadyOrange");
		"6DBX" Z 4;
		TNT1 A 0 A_GunFlash("FlashReadyOrange");
		"6DBX" Z 4;
        TNT1 A 0;
		TNT1 A 0 A_StopSound(3);
		Goto GuardReady+9;
		
		AltFireLaser:
		TNT1 A 0 A_StopSound(6);
		TNT1 A 0 A_JumpIfInventory("Cell", 20, 3);
	    TNT1 A 0 A_PlaySound("Seeker", 1);
		Goto LaserReady+9;
		TNT1 A 0 A_GunFlash("FlashFireRed");
		  TNT1 A 0 A_FireCustomMissile("ObeliskSeeker",0,0,0,-1,0,0);
		  TNT1 A 0 A_Takeinventory("Cell",20);
		  TNT1 A 0 A_FireCustomMissile("RedFlareSpawn",0,0,0,0);
		  TNT1 AAAAAA 0;
		  TNT1 A 0 A_SetBlend("Red",0.25,15);
		  TNT1 A 0 A_StopSound(5);
		  TNT1 A 0;
		  TNT1 A 0 A_AlertMonsters();
		  TNT1 A 0 A_PlaySound("Weapons/StachanovFire",1);
		  TNT1 A 0 A_PlaySound("Weapons/StachanovAddFire",0);
		"5D5X" K 1 BRIGHT A_ZoomFactor(0.95);
		"5D5X" L 1 BRIGHT A_ZoomFactor(0.96);
		"5D5X" M 1 BRIGHT A_ZoomFactor(0.97);
		"5D5X" N 1 BRIGHT A_ZoomFactor(0.98);
		"5D5X" O 1 BRIGHT A_ZoomFactor(0.99);
		"5D5X" P 1;
		"5D5X" Q 1;
		  
		  TNT1 A 0 A_GunFlash("FlashReadyRed");
		"5D5X" Z 4 A_ZoomFactor(1);
		  TNT1 A 0 A_GunFlash("FlashReadyRed");
		"5D5X" Z 4;
		  TNT1 A 0 A_ClearReFire;
		  goto LaserReady+9;
		
		PDA_Preview_BFG_Fire:
		TNT1 A 0;
		"4DAX" K 1 BRIGHT;
		"4DAX" L 1 BRIGHT;
		"4DAX" M 1 BRIGHT;
		"4DAX" N 1 BRIGHT;
		"4DAX" O 1 BRIGHT;
		"4DAX" P 1 BRIGHT;
		TNT1 A 0;
		"4DAX" Q 1 BRIGHT;
		"4DAX" R 1 BRIGHT;
		"4DAX" S 1 BRIGHT;
		"4DAX" T 1 BRIGHT;
		TNT1 A 0;
		"4DAX" U 1 BRIGHT;
		TNT1 A 0;
		"4DAX" V 1 BRIGHT;
		"4DAX" W 1 BRIGHT;
		"4DAX" X 1 BRIGHT;
		TNT1 A 0;
		"4DAX" Y 1 BRIGHT;
		"4DAX" Z 1 BRIGHT;
		"4DBX" Z 2 BRIGHT;
		"4DBX" Z 2 BRIGHT;
		Stop;

		PDA_Preview_BFG_AltFire:
		TNT1 A 0;
		"4DAX" V 1 BRIGHT;
		"4DAX" W 1 BRIGHT;
		"4DAX" X 1 BRIGHT;
		"4DAX" Y 1 BRIGHT;
		"4DAX" Z 1 BRIGHT;
		"4DBX" Z 1 BRIGHT;
		"4DBX" Z 1 BRIGHT;
		"4DBX" Z 2 BRIGHT;
		Stop;

		PDA_Preview_BFG_Reload:
		TNT1 A 0;
		"6DAX" E 1 Offset(0, 32);
		"6DAX" F 1 Offset(0, 32);
		"6DAX" G 1 Offset(0, 32);
		"6DAX" H 1 Offset(0, 32);
		"6DBX" A 1 Offset(0, 32);
		"6DBX" B 1 Offset(0, 32);
		"6DBX" C 1 Offset(0, 32);
		"6DBX" D 1 Offset(0, 32);
		Stop;
	
		FlashNothing:
		TNT1 A 2;
		Stop;
	
		FlashFireGreen:
		"4DBX" A 2 BRIGHT;
		"4DBX" B 2 BRIGHT;
		"4DBX" C 2 BRIGHT;
		"4DBX" D 2 BRIGHT;
		"4DBX" A 2 BRIGHT;
		"4DBX" B 2 BRIGHT;
		"4DBX" C 2 BRIGHT;
		"4DBX" D 2 BRIGHT;
		"4DBX" A 1 BRIGHT;
		"4DBX" B 1 BRIGHT;
		"4DBX" C 1 BRIGHT;
		"4DBX" D 1 BRIGHT;
		"4DBX" A 1 BRIGHT;
		"4DBX" B 1 BRIGHT;
		"4DBX" C 1 BRIGHT;
		"4DBX" D 1 BRIGHT;
		
		"4DBX" A 1 BRIGHT;
		"4DBX" B 1 BRIGHT;
		"4DBX" C 1 BRIGHT;
		"4DBX" D 1 BRIGHT;
		Stop;
		
		FlashAltFireGreen:
		"4DBX" A 1 BRIGHT;
		"4DBX" B 1 BRIGHT;
		"4DBX" C 1 BRIGHT;
		"4DBX" D 1 BRIGHT;
		"4DAX" E 1 BRIGHT;
		Stop;
		
		FlashReadyGreen:
		"4DAX" A 1 BRIGHT;
		"4DAX" B 1 BRIGHT;
		"4DAX" C 1 BRIGHT;
		"4DAX" D 1 BRIGHT;
		Stop;
		
		
		FlashFireOrange:
		"6DBX" A 1 BRIGHT;
		"6DBX" B 1 BRIGHT;
		"6DBX" C 1 BRIGHT;
		"6DBX" D 1 BRIGHT;
		Stop;
		
		FlashAltFireOrange:
		"6DBX" A 1 BRIGHT;
		"6DBX" B 1 BRIGHT;
		"6DBX" C 1 BRIGHT;
		"6DBX" D 1 BRIGHT;
		Stop;
		
		FlashReadyOrange:
		"RD6X" A 1 BRIGHT;
		"RD6X" B 1 BRIGHT;
		"RD6X" C 1 BRIGHT;
		"RD6X" D 1 BRIGHT;
		Stop;
		
	
		FlashReadyRed:
		"5DAX" "ABCD" 1 BRIGHT;
		Stop;
		
		
		FlashFireRed:
		"5DAX" "EFGHIJ" 1 BRIGHT;
		Stop;
		
		FlashFireRedCharge1:
		"5DAX" "EFGHIJ" 1 BRIGHT;
		Stop;
		
		FlashFireRedCharge2:
		"5DAX" "EFGHIJEFGHIJ" 1 BRIGHT;
		Stop;
	
		
	
	
		FlashReadyBlue:
		"RDAS" P 1 BRIGHT;
		"RDAS" O 1 BRIGHT;
		"RDAS" P 1 BRIGHT;
		"RDAS" N 1 BRIGHT;
		Stop;
		
		FlashFireBlue:
		"RDAS" L 1 BRIGHT;
		"RDAS" M 1 BRIGHT;
		"RDAS" N 1 BRIGHT;
		"RDAS" O 1 BRIGHT;
		Stop;
		
		
		
		FlashKicking:
		"4DCX" D 1;
		"4DCX" C 1;
		"4DCX" C 1;
		"4DCX" B 3;
		"4DCX" A 3;
		"4DCX" B 3;
		"4DCX" C 1;
		"4DCX" C 1;
		"4DCX" D 1;
		"4DBX" "ZZZZ" 1;
		Goto Ready3;
		
		FlashAirKicking:
		"4DCX" D 1;
		"4DCX" C 1;
		"4DCX" C 1;
		"4DCX" B 3;
		"4DCX" A 3;
		"4DCX" B 3;
		"4DCX" C 1;
		"4DCX" C 1;
		"4DCX" D 1;
		"4DBX" "ZZZZ" 1;
		Goto Ready3;
		
		FlashSlideKicking:
		"4DCX" "DC" 2;
		"4DCX" "CBBAAAABBCD" 2;
		Goto Ready3;
		
		FlashSlideKickingStop:
		"4DCX" "BBCCD" 1;
		"4DBX" Z 1;
		Goto Ready3;

		FlashPunching:
		"4DCX" D 1;
		"4DCX" C 1;
		"4DCX" C 1;
		"4DCX" B 3;
		"4DCX" A 3;
		"4DCX" B 3;
		"4DCX" C 1;
		"4DCX" C 1;
		"4DCX" D 1;
		"4DBX" "ZZZZ" 1;
		TNT1 A 0 A_ClearOverlays(PSP_FLASH, PSP_FLASH, false);
		Goto Ready3;
	}
}
