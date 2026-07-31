// PB_HarvesterOfSouls — Yaelvolador / Carrot.
// Ammo: Demonpower / HellAmmo. Modes: Soul Bolt, Storm, Soul Possess, Doom Seeker. Alt = subtle zoom.

class PB_HarvesterOfSouls : PB_WeaponBase
{
	default
	{
		Weapon.BobRangeX 0.3;
		Weapon.BobRangeY 0.7;
		Weapon.BobStyle "Smooth";
		Weapon.BobSpeed 2.5;
		Weapon.SelectionOrder 405;
		Weapon.AmmoUse1 0;
		Weapon.AmmoGive1 40;
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 40;
		Weapon.AmmoType1 "Demonpower";
		Weapon.AmmoType2 "HellAmmo";
		Weapon.SlotNumber 9;
		Weapon.SlotPriority 10.05;
		+FLOORCLIP;
		+DONTGIB;
		+WEAPON.NOAUTOAIM;
		+WEAPON.NOAUTOFIRE;
		+WEAPON.NOALERT;
		Inventory.PickupSound "HellPickup";
		Inventory.PickupMessage "$PB_PICKUP_PB_HARVESTEROFSOULS";
		Inventory.Icon "PUPUA0";
		Inventory.AltHUDIcon "PUPUA0";
		Obituary "%o was harvested by %k's Harvester of Souls.";
		Tag "Harvester of Souls";
		Scale 0.7;
		PB_WeaponBase.respectItem "RespectHarvesterOfSouls";
		FloatBobStrength 0.5;
	}

	action void PB_Harvester_ClearModeSelectTokens()
	{
		A_TakeInventory("Select_Harvester_SoulBolt", 1);
		A_TakeInventory("Select_Harvester_Storm", 1);
		A_TakeInventory("Select_Harvester_Possess", 1);
		A_TakeInventory("Select_Harvester_Seeker", 1);
	}

	action void PB_Harvester_ClearFireModes()
	{
		A_TakeInventory("HarvesterMode_Storm", 1);
		A_TakeInventory("HarvesterMode_Possess", 1);
		A_TakeInventory("HarvesterMode_Seeker", 1);
	}

	action void PB_Harvester_ClearZoom()
	{
		A_TakeInventory("Zoomed", 1);
		A_TakeInventory("ADSmode", 1);
		A_ZoomFactor(1.0);
		PB_HandleCrosshair(39);
	}

	states
	{
		Steady:
			TNT1 A 1;
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			TNT1 A 0 SetPlayerProperty(0, 0, 0);
			TNT1 A 0 SetPlayerProperty(0, 0, PROP_TOTALLYFROZEN);
			Goto Ready;

		Ready:
			TNT1 A 0 PB_RespectIfNeeded;
		WeaponRespect:
			TNT1 A 0
			{
				A_SetCrosshair(5);
				A_GiveInventory("RespectHarvesterOfSouls");
				A_PlaySoundEx("weapons/carbine/up", "Auto");
			}
			Goto Ready3;

		SelectAnimation:
			TNT1 A 0 A_StartSound("HRReady");
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			BANA HHIJKL 1;
		Ready3:
			TNT1 A 0
			{
				A_TakeInventory("PB_LockScreenTilt", 1);
				if (CountInv("Zoomed") < 1)
					PB_HandleCrosshair(39);
			}
		ReadyToFire:
			BANA ABCDEFG 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
			Goto ReadyToFire;

		Deselect:
			TNT1 A 0 PB_Harvester_ClearZoom();
			TNT1 A 0
			{
				A_WeaponOffset(0, 32);
				A_SetRoll(0);
				A_TakeInventory("PB_LockScreenTilt", 1);
			}
			TNT1 A 0 A_JumpIfInventory("GotMeatShield", 1, "GrabEnemy");
			BANA LKJIH 1;
			TNT1 AAAAAAAAAAAAAAAAAA 0 A_Lower;
			Wait;

		Select:
			TNT1 A 0
			{
				A_WeaponOffset(0, 32);
				A_SetRoll(0);
				PB_HandleCrosshair(39);
				A_TakeInventory("PB_LockScreenTilt", 1);
			}
			TNT1 A 0 A_TakeInventory("HasBarrel", 1);
			TNT1 A 0 A_TakeInventory("HasIceBarrel", 1);
			TNT1 A 0 A_TakeInventory("HasBurningBarrel", 1);
			TNT1 A 0 A_TakeInventory("GrabbedBarrel", 1);
			TNT1 A 0 A_TakeInventory("GrabbedIceBarrel", 1);
			TNT1 A 0 A_TakeInventory("GrabbedBurningBarrel", 1);
			Goto SelectFirstPersonLegs;

		SelectContinue:
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			TNT1 A 0 PB_WeapTokenSwitch("HellRifleSelected");
			TNT1 A 0 PB_RespectIfNeeded;
			Goto SelectAnimation;

		WeaponSpecial:
			TNT1 A 0 A_TakeInventory("GoWeaponSpecialAbility", 1);
			TNT1 A 0 A_JumpIfInventory("Select_Harvester_SoulBolt", 1, "WSpec_SoulBolt");
			TNT1 A 0 A_JumpIfInventory("Select_Harvester_Storm", 1, "WSpec_Storm");
			TNT1 A 0 A_JumpIfInventory("Select_Harvester_Possess", 1, "WSpec_Possess");
			TNT1 A 0 A_JumpIfInventory("Select_Harvester_Seeker", 1, "WSpec_Seeker");
			Goto Ready3;

		WSpec_SoulBolt:
			TNT1 A 0
			{
				PB_Harvester_ClearModeSelectTokens();
				PB_Harvester_ClearFireModes();
				A_Print("\ctHarvester:\c- \cgSoul Bolt\c-");
				A_PlaySoundEx("weapons/demontech/weaponspecial1", "Auto");
			}
			Goto Ready3;

		WSpec_Storm:
			TNT1 A 0
			{
				PB_Harvester_ClearModeSelectTokens();
				PB_Harvester_ClearFireModes();
				A_GiveInventory("HarvesterMode_Storm", 1);
				A_Print("\ctHarvester:\c- \ceStorm\c-");
				A_PlaySoundEx("weapons/demontech/weaponspecial1", "Auto");
			}
			Goto Ready3;

		WSpec_Possess:
			TNT1 A 0
			{
				PB_Harvester_ClearModeSelectTokens();
				PB_Harvester_ClearFireModes();
				A_GiveInventory("HarvesterMode_Possess", 1);
				A_Print("\ctHarvester:\c- \cdSoul Possess\c-");
				A_PlaySoundEx("weapons/demontech/weaponspecial1", "Auto");
			}
			Goto Ready3;

		WSpec_Seeker:
			TNT1 A 0
			{
				PB_Harvester_ClearModeSelectTokens();
				PB_Harvester_ClearFireModes();
				A_GiveInventory("HarvesterMode_Seeker", 1);
				A_Print("\ctHarvester:\c- \crDoom Seeker\c-");
				A_PlaySoundEx("weapons/demontech/weaponspecial1", "Auto");
			}
			Goto Ready3;

		Fire:
			TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "ThrowBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedBurningBarrel", 1, "ThrowFlameBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "ThrowIceBarrel");
			TNT1 A 0
			{
				if (CountInv("GoFatality") >= 1) { SetPlayerProperty(0, 1, 0); }
				else { SetPlayerProperty(0, 0, 0); }
			}
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			TNT1 A 0 PB_TryAutoFatalityOnFire();
			TNT1 A 0 A_WeaponOffset(0, 32);
			TNT1 A 0 A_JumpIfInventory("HarvesterMode_Storm", 1, "FireStorm");
			TNT1 A 0 A_JumpIfInventory("HarvesterMode_Possess", 1, "FirePossess");
			TNT1 A 0 A_JumpIfInventory("HarvesterMode_Seeker", 1, "FireSeeker");
			Goto FireSoulBolt;

		FireSoulBolt:
			TNT1 A 0 A_JumpIfInventory("HellAmmo", 1, 1);
			Goto Reload;
			BANA N 1;
			TNT1 A 0 A_PlaySound("HRFire");
			TNT1 A 0 BRIGHT A_FireCustomMissile("PB_HarvesterSoulBolt", random(-3, 3), 0, 0, 0, 0, random(-1, 1));
			BANA OPQ 1;
			BANA RS 1;
			TNT1 A 0 A_PlaySound("HRSteam");
			TNT1 A 0 A_TakeInventory("HellAmmo", 1);
			TNT1 A 0 A_AlertMonsters();
			TNT1 A 0 A_ReFire;
			Goto Ready3;

		FireStorm:
			TNT1 A 0 A_JumpIfInventory("HellAmmo", 10, 1);
			Goto Reload;
			BANA M 2;
			BANA N 2;
			TNT1 A 0 A_PlaySound("HRFire");
			TNT1 A 0 Bright A_PlaySound("weapons/shock");
			TNT1 A 0 BRIGHT A_FireCustomMissile("PB_HarvesterSoulBolt", random(-3, 3), 0, 0, 0, 0, random(-1, 1));
			TNT1 A 0 BRIGHT A_FireCustomMissile("StormShot2", random(-3, 3), 0, 0, 0, 0, random(-1, 1));
			BANA OPQ 2;
			BANA RSTUVWXYZ 1;
			TNT1 A 0 A_PlaySound("HRSteam");
			BANB ABCDEFG 2;
			TNT1 A 0 A_TakeInventory("HellAmmo", 10);
			TNT1 A 0 A_AlertMonsters();
			Goto Ready3;

		FirePossess:
			TNT1 A 0 A_JumpIfInventory("HellAmmo", 20, 1);
			Goto Reload;
			TNT1 A 0 A_PlaySound("HRCharge");
			BANA MNOP 1 BRIGHT
			{
				A_WeaponOffset(random(-1, 1), random(32, 34));
				A_FireCustomMissile("ShakeYourAssMinor", 0, 0, 0, 0);
			}
			BANA QRST 1 BRIGHT
			{
				A_WeaponOffset(random(-1, 1), random(32, 34));
				A_FireCustomMissile("ShakeYourAssMinor", 0, 0, 0, 0);
			}
			TNT1 A 0 A_PlaySoundEx("unmbal", "Weapon");
			TNT1 A 0 A_FireCustomMissile("RedFlareSpawn", 0, 0, 0, 0);
			TNT1 A 0 A_FireCustomMissile("PossessionGhost");
			TNT1 A 0 A_GunFlash();
			BANA UV 1 BRIGHT;
			BANA WXYZ 1;
			TNT1 A 0 A_TakeInventory("HellAmmo", 20);
			TNT1 A 0 A_PlaySoundEx("HRSteam", "Auto");
			BANB ABCDEFG 1;
			TNT1 A 0 A_AlertMonsters();
			Goto Ready3;

		FireSeeker:
			TNT1 A 0 A_JumpIfInventory("HellAmmo", 4, 1);
			Goto Reload;
			BANA MN 1;
			TNT1 A 0 A_PlaySound("HRFire");
			TNT1 A 0 BRIGHT A_FireCustomMissile("UnmakerDoomSeeker", 0, 0, 0, 0, 0, 0);
			BANA OPQRS 1;
			TNT1 A 0 A_PlaySound("HRSteam");
			TNT1 A 0 A_TakeInventory("HellAmmo", 4);
			TNT1 A 0 A_AlertMonsters();
			TNT1 A 0 A_ReFire;
			Goto Ready3;

		AltFire:
			TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "ThrowBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedBurningBarrel", 1, "ThrowFlameBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "ThrowIceBarrel");
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			TNT1 A 0 A_WeaponOffset(0, 32);
			TNT1 A 0 A_JumpIfInventory("Zoomed", 1, "ZoomOut");
			TNT1 A 0
			{
				A_StartSound("IronSights", 10, CHANF_OVERLAP);
				A_GiveInventory("Zoomed", 1);
				A_GiveInventory("ADSmode", 1);
				A_ZoomFactor(1.15);
				A_SetCrosshair(-1);
			}
			BANA HIJK 1;
			Goto Ready3;

		ZoomOut:
			TNT1 A 0
			{
				A_StartSound("IronSights", 10, CHANF_OVERLAP);
				PB_Harvester_ClearZoom();
			}
			BANA KJIH 1;
			Goto Ready3;

		Reload:
			TNT1 A 0 PB_Harvester_ClearZoom();
			TNT1 A 0 A_TakeInventory("Reloading", 1);
			TNT1 A 0 A_JumpIfInventory("HellAmmo", 60, "Ready3");
			TNT1 A 0 A_JumpIfInventory("Demonpower", 1, 1);
			Goto Ready3;
			TNT1 A 0 A_PlaySound("IronSights");
			PAPO ABCDEFGHIJ 1;
			TNT1 A 0 A_PlaySoundEx("Hellclip", "Weapon");
			PAPO KLMNOPQRSTUVWXYZ 1;
			PIPI ABCD 1;
			H4T1 ABCDEFGH 1;
			TNT1 A 0 A_PlaySound("weapons/fistwhoosh2");
			TNT1 A 0 A_PlaySound("HRSteam");
			H4T1 IJKLM 1;
			TNT1 A 0 A_PlaySoundEx("weapons/demontech/respect4", "Auto");
			H4T1 N 1;
			TNT1 A 0 A_PlaySoundEx("weapons/demontech/respect2", "Auto");
			TNT1 A 0 A_PlaySoundEx("HRPickup", "Auto");
			H4T1 OPQRSTUVWXYZ 1;
			H4T2 ABCDEFGHIJKLMNOPQRSTUVWXYZ 1;
			H4T3 ABC 1;
			PIPI CD 1;
			PIPI DEFGHIJKLMNOPQRSTUVWXYZ 1;
			PIPO ABCDD 1;
			TNT1 A 0 A_PlaySound("HRSteam");
			PIPO EEFFGGHHIIJKKLLMN 1;
			TNT1 A 0 A_PlaySound("HRReady");
		InsertBullets:
			TNT1 A 0 A_TakeInventory("Reloading", 1);
			TNT1 A 0 A_JumpIfInventory("HellAmmo", 60, "Ready3");
			TNT1 A 0 A_JumpIfInventory("Demonpower", 1, 1);
			Goto Ready3;
			TNT1 A 0
			{
				A_GiveInventory("HellAmmo", 1);
				A_TakeInventory("Demonpower", 1);
			}
			Goto InsertBullets;

		FlashKicking:
			TNT1 A 0 A_ClearOverlays(10, 11);
			BANA LKJIHHHHHHHHH 1;
			BANA HIJKLLLLLLLLL 1;
			Goto Ready3;
		FlashAirKicking:
			TNT1 A 0 A_ClearOverlays(10, 11);
			BANA LKJIHHHHHHHHH 1;
			BANA HIJKLLLLLLLLL 1;
			Goto Ready3;
		FlashSlideKicking:
			TNT1 A 0 A_ClearOverlays(10, 11);
			BANA LKJIHHHHHHHHH 1;
			Goto Ready3;
		FlashSlideKickingStop:
			TNT1 A 0 A_ClearOverlays(10, 11);
			BANA HIJKLLLLLLLLL 1;
			Goto Ready3;
		FlashPunching:
			TNT1 A 0 A_ClearOverlays(PSP_FLASH, PSP_FLASH, false);
			BANA LKJIHHHHHHHHH 1;
			BANA HIJKLLLLLLLLL 1;
			Goto Ready3;

		Spawn:
			PUPU A 10 A_PbvpFramework("PUPU");
			"####" "#" 0 A_PbvpInterpolate();
			LOOP;
	}
}
