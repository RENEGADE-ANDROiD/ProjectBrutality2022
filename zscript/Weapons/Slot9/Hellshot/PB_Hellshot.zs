// Reilsss Hellshot fold as PB_Hellshot (optional Demon Tech sibling).
// Mag fill caps at 50 HellAmmo even though HellAmmo MaxAmount is 60.

class PB_Hellshot : PB_WeaponBase
{
	const HELLSHOT_MAG = 50;

	Default
	{
		Weapon.BobRangeX 0.3;
		Weapon.BobRangeY 0.5;
		Weapon.BobStyle "InverseSmooth";
		Weapon.BobSpeed 2.4;
		Weapon.SelectionOrder 410;
		Weapon.AmmoUse1 0;
		Weapon.AmmoGive1 20;
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 0;
		Weapon.AmmoType1 "Demonpower";
		Weapon.AmmoType2 "HellAmmo";
		Weapon.SlotNumber 4;
		Weapon.SlotPriority 0.55;
		+WEAPON.NOAUTOAIM;
		+FLOORCLIP;
		+DONTGIB;
		Inventory.PickupSound "weapons/Hellshot/Select";
		Inventory.PickupMessage "$PB_PICKUP_PB_HELLSHOT";
		Inventory.Icon "HSPUA0";
		Inventory.AltHUDIcon "HSPUA0";
		Obituary "%o was torn apart by %k's Hellshot.";
		Tag "Hellshot";
		Scale 0.45;
	}

	override void AttachToOwner(Actor other)
	{
		if (other && other.player)
		{
			if (other.CountInv("HellAmmo") < 1)
				other.A_GiveInventory("HellAmmo", HELLSHOT_MAG);
		}
		Super.AttachToOwner(other);
	}

	States
	{
	Steady:
		Goto PB_FinisherCleanup;



	Spawn:
		HSPU A -1;
		Stop;

	Ready:
		TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
		Goto Ready3;

	Ready3:
		TNT1 A 0
		{
			A_TakeInventory("PB_LockScreenTilt", 1);
			PB_HandleCrosshair(39);
		}
		TNT1 A 0 A_JumpIfInventory("PB_HellshotAcidMode", 1, "ReadyCaustic");
	ReadyInferno:
		HRID A 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
		HRID B 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
		HRID C 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
		HRID D 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
		HRID E 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
		Loop;

	ReadyCaustic:
		HR1D A 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
		HR1D B 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
		HR1D C 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
		HR1D D 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
		HR1D E 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
		Loop;

	Deselect:
		TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "PlaceBarrel");
		TNT1 A 0 A_JumpIfInventory("GrabbedBurningBarrel", 1, "PlaceFlameBarrel");
		TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "PlaceIceBarrel");
		TNT1 A 0
		{
			A_WeaponOffset(0, 32);
			A_SetRoll(0);
			A_TakeInventory("PB_LockScreenTilt", 1);
			A_StopSound(CHAN_WEAPON);
		}
		HRRA CBA 1;
		TNT1 A 0 A_Lower;
		Wait;

	Select:
		TNT1 A 0
		{
			A_WeaponOffset(0, 32);
			A_SetRoll(0);
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
	SelectAnimation:
		TNT1 A 0 A_StartSound("weapons/Hellshot/Select", CHAN_AUTO);
		HRRA ABC 1;
		TNT1 A 0 A_JumpIfInventory("HellAmmo", 1, "Ready3");
		Goto Reload;

	WeaponSpecial:
		TNT1 A 0 A_TakeInventory("GoWeaponSpecialAbility", 1);
		TNT1 A 0 A_JumpIfInventory("Select_PB_Hellshot_Inferno", 1, "SwitchToInferno");
		TNT1 A 0 A_JumpIfInventory("Select_PB_Hellshot_Caustic", 1, "SwitchToCaustic");
		TNT1 A 0 A_JumpIfInventory("PB_HellshotAcidMode", 1, "SwitchToInferno");
		Goto SwitchToCaustic;

	SwitchToCaustic:
		TNT1 A 0 A_TakeInventory("Select_PB_Hellshot_Inferno", 1);
		TNT1 A 0 A_TakeInventory("Select_PB_Hellshot_Caustic", 1);
		TNT1 A 0 A_GiveInventory("PB_HellshotAcidMode", 1);
		TNT1 A 0 A_Print("Fire mode: Caustic");
		TNT1 A 0 A_StartSound("weapons/Hellshot/Clip_Out_1", CHAN_AUTO);
		HRID A 4;
		TNT1 A 0 A_StartSound("weapons/Hellshot/Clip_In_1", CHAN_AUTO);
		HR2D ABCDE 4;
		TNT1 A 0 A_StartSound("weapons/Hellshot/Change", CHAN_AUTO);
		HR3X ABCDEF 1;
		Goto ReadyCaustic;

	SwitchToInferno:
		TNT1 A 0 A_TakeInventory("Select_PB_Hellshot_Inferno", 1);
		TNT1 A 0 A_TakeInventory("Select_PB_Hellshot_Caustic", 1);
		TNT1 A 0 A_TakeInventory("PB_HellshotAcidMode", 1);
		TNT1 A 0 A_Print("Fire mode: Inferno");
		TNT1 A 0 A_StartSound("weapons/Hellshot/Clip_Out_1", CHAN_AUTO);
		HR1D A 4;
		TNT1 A 0 A_StartSound("weapons/Hellshot/Clip_In_1", CHAN_AUTO);
		HR2D EDCBA 4;
		TNT1 A 0 A_StartSound("weapons/Hellshot/Change", CHAN_AUTO);
		HREX ABCDEF 1;
		Goto ReadyInferno;

	Fire:
		TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "ThrowBarrel");
		TNT1 A 0 A_JumpIfInventory("GrabbedBurningBarrel", 1, "ThrowFlameBarrel");
		TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "ThrowIceBarrel");
		TNT1 A 0
		{
			A_WeaponOffset(0, 32);
			A_SetRoll(0);
			if (CountInv("NoFatality") == 0 && GetCVar("pb_auto_fatality_fire") == 1)
				return PB_TryAutoFatalityOnFire();
			return ResolveState(null);
		}
		TNT1 A 0 A_TakeInventory("Reloading", 1);
		TNT1 A 0 A_JumpIfInventory("PB_HellshotAcidMode", 1, "FireCaustic");
		TNT1 A 0 { return PB_BailIfCannotFire("HellAmmo", 1, "Demonpower"); }
	FireInferno:
		TNT1 A 0 A_StartSound("weapons/Hellshot/Fire", CHAN_WEAPON, CHANF_OVERLAP, 1.0);
		TNT1 A 0 A_FireCustomMissile("YellowFlareSpawn", 0, 0, 4, 0);
		TNT1 A 0 A_FireCustomMissile("GunFireSmoke", 0, 0, 4, 0);
		TNT1 A 0 A_Quake(2, 6, 0, 16);
		HRFI C 2 Bright
		{
			A_FireCustomMissile("Hellbullet", random(-1, 1), 0, 4, 0, 0, random(-1, 1));
			A_AlertMonsters();
			PB_WeaponRecoil(-0.4, -0.15);
		}
		TNT1 A 0 A_TakeInventory("HellAmmo", 1);
		HRFI ABC 1;
		TNT1 A 0 A_ReFire;
		TNT1 A 0 A_StartSound("weapons/Hellshot/Change", CHAN_AUTO);
		HREX ABCDEF 1;
		Goto Ready3;

	FireCaustic:
		TNT1 A 0 { return PB_BailIfCannotFire("HellAmmo", 1, "Demonpower"); }
		TNT1 A 0 A_StartSound("weapons/Hellshot/GFire", CHAN_WEAPON, CHANF_OVERLAP, 1.0);
		TNT1 A 0 A_FireCustomMissile("GreenFlareSpawn", 0, 0, 4, 0);
		TNT1 A 0 A_FireCustomMissile("GunFireSmoke", 0, 0, 4, 0);
		TNT1 A 0 A_Quake(2, 6, 0, 16);
		HRF1 C 2 Bright
		{
			A_FireCustomMissile("Hellbullet2", frandom(-1.5, 1.5), 0, 4, 0, 0, frandom(-1.6, 1.6));
			A_AlertMonsters();
			PB_WeaponRecoil(-0.5, -0.2);
		}
		TNT1 A 0 A_TakeInventory("HellAmmo", 1);
		HRF1 ABC 1;
		TNT1 A 0 A_ReFire;
		TNT1 A 0 A_StartSound("weapons/Hellshot/Change", CHAN_AUTO);
		HR3X ABCDEF 1;
		Goto Ready3;

	AltFire:
		TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "ThrowBarrel");
		TNT1 A 0 A_JumpIfInventory("GrabbedBurningBarrel", 1, "ThrowFlameBarrel");
		TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "ThrowIceBarrel");
		TNT1 A 0 A_WeaponOffset(0, 32);
		TNT1 A 0 A_TakeInventory("Reloading", 1);
		TNT1 A 0 A_JumpIfInventory("PB_HellshotAcidMode", 1, "AltCaustic");
		TNT1 A 0 A_JumpIfInventory("HellAmmo", 12, 1);
		Goto Reload;
	AltInferno:
		TNT1 A 0 A_StartSound("weapons/Hellshot/AltFire", CHAN_WEAPON, CHANF_OVERLAP, 1.0);
		HRFI CBA 4 Bright;
		TNT1 A 0 A_FireCustomMissile("RedFlareSpawn", 0, 0, 4, 0);
		TNT1 A 0 A_FireCustomMissile("GunFireSmoke", 0, 0, 4, 0);
		TNT1 A 0 A_Quake(2, 6, 0, 16);
		HRFI A 2 Bright A_Recoil(3);
		TNT1 A 0 A_FireCustomMissile("PB_Hellshot_BloodBall", 0, 0, 4, 0);
		TNT1 A 0 A_FireCustomMissile("PB_Hellshot_BloodBall", 1, 0, 4, 0);
		TNT1 A 0 A_FireCustomMissile("PB_Hellshot_BloodBall", -1, 0, 4, 0);
		TNT1 A 0 A_TakeInventory("HellAmmo", 12);
		TNT1 A 0 A_StartSound("weapons/Hellshot/Change", CHAN_AUTO);
		HREX ABCDEF 2;
		Goto Ready3;

	AltCaustic:
		TNT1 A 0 A_JumpIfInventory("HellAmmo", 8, 1);
		Goto Reload;
		TNT1 A 0 A_ZoomFactor(0.95);
		HR3X ABCDEF 1 Bright;
		TNT1 A 0 A_ZoomFactor(0.92);
		TNT1 A 0 A_StartSound("weapons/Hellshot/AltFire", CHAN_WEAPON, CHANF_OVERLAP, 1.0);
		TNT1 A 0 A_FireCustomMissile("GreenFlareSpawn", 0, 0, 4, 0);
		TNT1 A 0 A_FireCustomMissile("GunFireSmoke", 0, 0, 4, 0);
		TNT1 A 0 A_Quake(2, 6, 0, 16);
		HRF1 D 1 Bright A_FireCustomMissile("PB_Hellshot_DeathRay", 0, 0, 4, 0);
		HRF1 D 1 Bright A_FireCustomMissile("PB_Hellshot_DeathRay", 1, 0, 4, 0);
		TNT1 A 0 A_ZoomFactor(0.96);
		HRF1 AEB 2;
		TNT1 A 0 A_ZoomFactor(1.0);
		TNT1 A 0 A_TakeInventory("HellAmmo", 8);
		TNT1 A 0 A_StartSound("weapons/Hellshot/Change", CHAN_AUTO);
		HR3X ABCDEF 1;
		Goto Ready3;

	Reload:
		TNT1 A 0 A_JumpIfInventory("PB_HellshotAcidMode", 1, "ReloadCaustic");
		HRRL A 1 A_WeaponReady(WRF_NOFIRE);
		TNT1 A 0 A_TakeInventory("Reloading", 1);
		TNT1 A 0 A_JumpIfInventory("HellAmmo", HELLSHOT_MAG, "Ready3");
		TNT1 A 0 A_JumpIfInventory("Demonpower", 1, "ReloadInfernoAnim");
		Goto NoAmmo;
	NoAmmo:
		TNT1 A 0 A_PlaySound("weapons/empty");
		HRID A 8 A_WeaponReady(WRF_NOFIRE|WRF_NOSWITCH);
		Goto Ready3;
	ReloadInfernoAnim:
		TNT1 A 0 A_StartSound("weapons/Hellshot/Clip_Out_1", CHAN_AUTO);
		HRRL BCDE 2;
		HRRL F 3 A_StartSound("weapons/Hellshot/Change", CHAN_AUTO);
		HRRL GHIJK 3;
		TNT1 A 0 A_StartSound("weapons/Hellshot/Clip_In_1", CHAN_AUTO);
		HRRL JLMN 4;
	InsertBullets:
		TNT1 A 0 A_JumpIfInventory("HellAmmo", HELLSHOT_MAG, "ReloadFinishInferno");
		TNT1 A 0 A_JumpIfInventory("Demonpower", 1, 1);
		Goto ReloadFinishInferno;
		TNT1 A 0
		{
			A_GiveInventory("HellAmmo", 1);
			A_TakeInventory("Demonpower", 1);
		}
		Goto InsertBullets;
	ReloadFinishInferno:
		TNT1 A 0 A_TakeInventory("Reloading", 1);
		HRRL OPQ 3;
		Goto Ready3;

	ReloadCaustic:
		H4RL A 1 A_WeaponReady(WRF_NOFIRE);
		TNT1 A 0 A_TakeInventory("Reloading", 1);
		TNT1 A 0 A_JumpIfInventory("HellAmmo", HELLSHOT_MAG, "Ready3");
		TNT1 A 0 A_JumpIfInventory("Demonpower", 1, "ReloadCausticAnim");
		Goto NoAmmo;
	ReloadCausticAnim:
		TNT1 A 0 A_StartSound("weapons/Hellshot/Clip_Out_1", CHAN_AUTO);
		H4RL BCDE 2;
		H4RL F 3 A_StartSound("weapons/Hellshot/Change", CHAN_AUTO);
		H4RL GHIJK 3;
		TNT1 A 0 A_StartSound("weapons/Hellshot/Clip_In_1", CHAN_AUTO);
		H4RL JLMN 4;
	InsertBulletsCaustic:
		TNT1 A 0 A_JumpIfInventory("HellAmmo", HELLSHOT_MAG, "ReloadFinishCaustic");
		TNT1 A 0 A_JumpIfInventory("Demonpower", 1, 1);
		Goto ReloadFinishCaustic;
		TNT1 A 0
		{
			A_GiveInventory("HellAmmo", 1);
			A_TakeInventory("Demonpower", 1);
		}
		Goto InsertBulletsCaustic;
	ReloadFinishCaustic:
		TNT1 A 0 A_TakeInventory("Reloading", 1);
		H4RL OPQ 3;
		Goto Ready3;

	FlashKicking:
		TNT1 A 0 A_JumpIfInventory("PB_HellshotAcidMode", 1, "FlashKickingCaustic");
		HRID AAAAAAAAAAAAAAA 1;
		Stop;
	FlashKickingCaustic:
		HR1D AAAAAAAAAAAAAAA 1;
		Stop;
	FlashAirKicking:
		TNT1 A 0 A_JumpIfInventory("PB_HellshotAcidMode", 1, "FlashAirKickingCaustic");
		HRID AAAAAAAAAAAAAAAA 1;
		Stop;
	FlashAirKickingCaustic:
		HR1D AAAAAAAAAAAAAAAA 1;
		Stop;
	FlashSlideKicking:
		TNT1 A 0 A_JumpIfInventory("PB_HellshotAcidMode", 1, "FlashSlideKickingCaustic");
		HRID AAAAAAAAAAAAAAAAAAAAAAAA 1;
		Stop;
	FlashSlideKickingCaustic:
		HR1D AAAAAAAAAAAAAAAAAAAAAAAA 1;
		Stop;
	FlashSlideKickingStop:
		TNT1 A 0 A_JumpIfInventory("PB_HellshotAcidMode", 1, "FlashSlideKickingStopCaustic");
		HRID AAAAAAA 1;
		Stop;
	FlashSlideKickingStopCaustic:
		HR1D AAAAAAA 1;
		Stop;
	FlashPunching:
		TNT1 A 0 A_JumpIfInventory("PB_HellshotAcidMode", 1, "FlashPunchingCaustic");
		HRID AAAAAAAAAA 1;
		TNT1 A 0 A_ClearOverlays(PSP_FLASH, PSP_FLASH, false);
		Stop;
	FlashPunchingCaustic:
		HR1D AAAAAAAAAA 1;
		TNT1 A 0 A_ClearOverlays(PSP_FLASH, PSP_FLASH, false);
		Stop;
	}
}
