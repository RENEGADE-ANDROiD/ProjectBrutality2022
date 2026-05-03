// M41A pulse rifle (folded from PB_M41A add-on + legacy PB underbarrel).
// Primary: 7.62 + muzzle overlay / flash helpers. Alt: 30mm grenade or 12ga (wheel).
// : PB_WeaponBase — ZScript cannot inherit DECORATE PB_Weapon (UZDoom); Select matches Battle Rifle pattern.

const m41a_ammoFull = 95;

class M41AChamberAmmo : Ammo
{
	Default
	{
		Inventory.MaxAmount m41a_ammoFull;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount m41a_ammoFull;
	}
}

class M41ARespect : Inventory
{
	Default { Inventory.MaxAmount 1; }
}

class M41AUnloaded : Inventory
{
	Default { Inventory.MaxAmount 1; }
}

class M41AChamberAmmoLeft : Ammo
{
	Default
	{
		Inventory.MaxAmount m41a_ammoFull;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount m41a_ammoFull;
	}
}

class DualWieldingM41A : Inventory
{
	Default { Inventory.MaxAmount 1; }
}

class PB_M41A : PB_WeaponBase
{
	Default
	{
		//$Category Weapons
		//$Title M41A Pulse Rifle
		//$Sprite PMAWA0
		Weapon.SlotNumber 4;
		Weapon.SlotPriority 0.08;
		Weapon.AmmoType1 "NewClip";
		Weapon.AmmoType2 "M41AChamberAmmo";
		Weapon.AmmoGive1 30;
		Weapon.AmmoUse1 0;
		Weapon.AmmoUse2 0;
		Inventory.MaxAmount 2;
		Scale 0.7;
		+WEAPON.NOAUTOAIM;
		+WEAPON.NOALERT;
		+WEAPON.NOAUTOFIRE;
		Inventory.AltHUDIcon "PMAWA0";
		Inventory.PickupMessage "M41A Pulse Rifle (Slot 4)";
		Inventory.PickupSound "M41A/PickUp";
		Obituary "%o was ventilated by %k's M41A";
		Tag "M41A";
		PB_WeaponBase.UnloaderToken "M41AUnloaded";
		PB_WeaponBase.respectItem "M41ARespect";
		PB_WeaponBase.AmmoTypeLeft "M41AChamberAmmoLeft";
	}

	override void AttachToOwner(Actor other)
	{
		if (other && other.player)
		{
			if (other.CountInv("M41AChamberAmmo") < 1 && other.CountInv("M41ARespect") < 1)
				other.A_GiveInventory("M41AChamberAmmo", m41a_ammoFull);
			if (other.CountInv("M41AChamberAmmoLeft") < 1 && other.CountInv("M41ARespect") < 1)
				other.A_GiveInventory("M41AChamberAmmoLeft", m41a_ammoFull);
		}
		Super.AttachToOwner(other);
	}

	action void M41A_FirePrimary()
	{
		if (CountInv("M41AChamberAmmo") < 1)
			return;
		PB_FireBullets("PB_762x51mm", 1, 3, 0, 0, 2.5);
		PB_FireOffset();
		PB_LowAmmoSoundWarning("hdmr");
		A_ZoomFactor(0.99);
		A_Overlay(-7, "MuzzleFlash");
		PB_IncrementHeat(2);
		PB_WeaponRecoil(-0.75, frandom(-0.3, 0.3));
		A_StartSound("M41A/Fire", CHAN_WEAPON, CHANF_OVERLAP, 1.0, 0, frandom(0.98, 1.02));
		PB_DynamicTail("smg", "smg");
		PB_GunSmoke(0, 0, 0);
		PB_MuzzleFlashEffects(0, 0, 0);
		A_FireCustomMissile("YellowFlareSpawn", 0, 0, 0, 0);
		A_FireCustomMissile("ShakeYourAssMinor", 0, 0, 0, 0);
		PB_SpawnCasing("PB_EmptyBrass", 22, 2, 26, frandom(-4, 1), frandom(6, 9), frandom(0, 2));
		A_TakeInventory("M41AChamberAmmo", 1);
	}

	action void M41A_ClearDualOverlays()
	{
		A_ClearOverlays(10, 11);
		A_ClearOverlays(-8, -7);
	}

	action void M41A_ExitDualIfNeeded()
	{
		if (!A_CheckAkimbo())
			return;
		A_SetAkimbo(false);
		A_SetInventory("DualWieldingM41A", 0);
		M41A_ClearDualOverlays();
	}

	action void M41A_SetSpriteIfDual(string spt)
	{
		if (!A_CheckAkimbo() || !player)
			return;
		let psp = player.GetPSprite(OverlayID());
		if (psp)
			psp.Sprite = GetSpriteIndex(spt);
	}

	action void M41A_FireDual(bool left = false)
	{
		if (left)
		{
			if (CountInv("M41AChamberAmmoLeft") < 1)
				return;
			PB_FireBullets("PB_762x51mm", 1, 3, -3, 0, 2.5);
			PB_FireOffset();
			PB_IncrementHeat(2, true);
			PB_WeaponRecoil(-0.85, frandom(0.3, 0.8));
			A_StartSound("M41A/Fire", 99, CHANF_OVERLAP, 1.0, 0, frandom(0.98, 1.02));
			A_Overlay(-8, "MuzzleDualL");
			PB_SpawnCasing("PB_EmptyBrass", 22, -16, 35, frandom(-4, 1), frandom(5, 8), frandom(1, 2));
			PB_GunSmoke(4, 0, 0);
			PB_MuzzleFlashEffects(4, 0, 0);
			PB_DynamicTail("smg", "smg");
			A_FireCustomMissile("YellowFlareSpawn", 0, 0, 0, 0);
			PB_LowAmmoSoundWarning("hdmr", "M41AChamberAmmoLeft");
			A_TakeInventory("M41AChamberAmmoLeft", 1);
		}
		else
		{
			if (CountInv("M41AChamberAmmo") < 1)
				return;
			PB_FireBullets("PB_762x51mm", 1, 3, 3, 0, 2.5);
			PB_FireOffset();
			PB_IncrementHeat(2);
			PB_WeaponRecoil(-0.85, frandom(-0.8, -0.3));
			A_StartSound("M41A/Fire", 100, CHANF_OVERLAP, 1.0, 0, frandom(0.98, 1.02));
			A_Overlay(-9, "MuzzleDualR");
			PB_SpawnCasing("PB_EmptyBrass", 22, 16, 35, frandom(-4, 1), frandom(5, 8), frandom(1, 2));
			PB_GunSmoke(-4, 0, 0);
			PB_MuzzleFlashEffects(-4, 0, 0);
			PB_DynamicTail("smg", "smg");
			A_FireCustomMissile("YellowFlareSpawn", 0, 0, 0, 0);
			PB_LowAmmoSoundWarning("hdmr");
			A_TakeInventory("M41AChamberAmmo", 1);
		}
	}

	states
	{
		Spawn:
			PMAW A -1;
			Stop;
		Steady:
			TNT1 A 1;
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			TNT1 A 0 SetPlayerProperty(0, 0, 0);
			Goto Ready3;

		Select:
			TNT1 A 0
			{
				A_WeaponOffset(0, 32);
				A_SetRoll(0);
				PB_HandleCrosshair(42);
			}
			TNT1 A 0 A_TakeInventory("PB_LockScreenTilt", 1);
			TNT1 A 0 A_TakeInventory("HasBarrel", 1);
			TNT1 A 0 A_TakeInventory("HasIceBarrel", 1);
			TNT1 A 0 A_TakeInventory("HasFlameBarrel", 1);
			TNT1 A 0 A_TakeInventory("GrabbedBarrel", 1);
			TNT1 A 0 A_TakeInventory("GrabbedIceBarrel", 1);
			TNT1 A 0 A_TakeInventory("GrabbedFlameBarrel", 1);
			TNT1 A 0 A_StopSound(1);
			TNT1 A 0 A_StopSound(5);
			TNT1 A 0 A_StopSound(6);
			TNT1 A 0 A_TakeInventory("Spin", 1);
			TNT1 A 0 A_TakeInventory("CantWeaponSpecial", 1);
			TNT1 A 0 A_TakeInventory("MG42Selected", 1);
			TNT1 A 0 A_SetInventory("Grabbing_A_Ledge", 0);
			TNT1 A 0 A_TakeInventory("RandomHeadExploder", 1);
			TNT1 A 0 A_TakeInventory("DualFireReload", 2);
			TNT1 A 0 A_Overlay(-777, "Melee_Equipment_Handler_Overlay");
			TNT1 A 0 A_Overlay(-778, "KickHandler_Overlay");
			TNT1 A 0 A_Overlay(-779, "Equipment_Toggle_Handler_Overlay");
			TNT1 A 0 A_Overlay(-10, "FirstPersonLegsStand");
			TNT1 A 0 A_Jump(255, "SelectContinue");

		SelectContinue:
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			TNT1 A 0 PB_WeaponRaise("M41A/PickUp");
			TNT1 A 0 PB_WeapTokenSwitch("RifleSelected");
			TNT1 A 0
			{
				if (CountInv("M41AChamberAmmo") < 1 && CountInv("M41ARespect") < 1)
					A_GiveInventory("M41AChamberAmmo", m41a_ammoFull);
				if (CountInv("M41AChamberAmmoLeft") < 1 && CountInv("M41ARespect") < 1)
					A_GiveInventory("M41AChamberAmmoLeft", m41a_ammoFull);
			}
			TNT1 A 0 PB_RespectIfNeeded();
		SelectAnimation:
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "SelectAnimationDualWield");
			TNT1 A 0 PB_HandleCrosshair(42);
			PMAU ABCD 1;
			Goto Ready3;

		WeaponRespect:
			TNT1 A 0 A_GiveInventory("M41ARespect", 1);
			PMAU ABCD 1 A_DoPBWeaponAction();
			Goto Ready3;

		Deselect:
			TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "PlaceBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedFlameBarrel", 1, "PlaceFlameBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "PlaceIceBarrel");
			TNT1 A 0 A_ZoomFactor(1.0);
			TNT1 A 0 A_TakeInventory("Zoomed", 1);
			TNT1 A 0 A_TakeInventory("ADSmode", 1);
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "DeselectAnimationDualWield");
			PMAD ABCD 1;
			TNT1 A 0 A_Lower(120);
			Wait;

		Ready:
		Ready3:
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "ReadyDualWield");
			PMAF A 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
			TNT1 A 0 A_JumpIfInventory("GoWeaponSpecialAbility", 1, "WeaponSpecial");
			Loop;

		NoAmmo:
			PMAF A 1;
			Goto Ready3;

		Fire:
			TNT1 A 0
			{
				if (CountInv("GoFatality") >= 1)
					SetPlayerProperty(0, 1, 0);
				else
					SetPlayerProperty(0, 0, 0);
			}
			TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "ThrowBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedFlameBarrel", 1, "ThrowFlameBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "ThrowIceBarrel");
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "ReadyDualWield");
			TNT1 A 0 A_JumpIfInventory("M41AChamberAmmo", 1, "M41Shot1");
			TNT1 A 0
			{
				A_WeaponOffset(0, 32);
				A_ZoomFactor(1.0);
			}
			Goto Reload;

		M41Shot1:
			TNT1 A 0 A_JumpIfInventory("M41AChamberAmmo", 1, "M41S1Body");
			Goto Ready3;

		M41S1Body:
			PMAF B 1 Bright M41A_FirePrimary();
			PMAF C 1 Bright;
			TNT1 A 0 A_ZoomFactor(1.0);
			PMAF D 1 A_Refire("M41Shot2");
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			Goto Ready3;

		M41Shot2:
			TNT1 A 0 A_JumpIfInventory("M41AChamberAmmo", 1, "M41S2Body");
			Goto Ready3;

		M41S2Body:
			PMAF C 1 Bright M41A_FirePrimary();
			PMAF D 1 Bright;
			PMAF A 1 A_Refire("Fire");
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			Goto Ready3;

		AltFire:
			TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "PlaceBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedFlameBarrel", 1, "PlaceFlameBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "PlaceIceBarrel");
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "ReadyToFireDualWield");
			TNT1 A 0
			{
				A_WeaponOffset(0, 32);
				A_SetRoll(0);
				A_TakeInventory("PB_LockScreenTilt", 1);
			}
			TNT1 A 0 A_JumpIfInventory("M41ChangeCart", 1, "AltShell");
			TNT1 A 0 A_JumpIfInventory("PB_RocketAmmo", 1, "AltGrenadeFire");
			Goto M41NoAmmoJ;

		AltGrenadeFire:
			PMAF A 0 A_PlaySound("RFGLLCH", CHAN_WEAPON);
			PMAF AB 1 Bright
			{
				A_AlertMonsters();
				A_FireCustomMissile("ShakeYourAssMinor", 0, 0, 0, 0);
				A_FireCustomMissile("YellowFlareSpawn", 0, 0, 0, 0);
				A_FireCustomMissile("ShotgunParticles", random(-17, 17), 0, -1, random(-17, 17));
				A_FireCustomMissile("M41AGrenade", 0, 0, 0, 0);
				A_FireCustomMissile("GunFireSmoke", 0, 0, 0, 0, 0, 0);
			}
			TNT1 A 0 A_Recoil(2);
			TNT1 A 0 A_ZoomFactor(0.98);
			PMAF C 1 Bright PB_WeaponRecoil(-1.5, 1.5);
			TNT1 A 0 A_ZoomFactor(1.0);
			PMAF DEF 1;
			PMAF A 1;
			Goto M41AltPumpGrenade;

		AltShell:
			TNT1 A 0 A_JumpIfInventory("NewShell", 1, "AltShellFire");
			Goto M41NoAmmoJ;

		AltShellFire:
			PMAF A 0 A_PlaySound("weapons/sg", CHAN_WEAPON);
			PMAF AB 1 Bright
			{
				A_AlertMonsters();
				A_FireCustomMissile("ShakeYourAssMinor", 0, 0, 0, 0);
				A_FireCustomMissile("YellowFlareSpawn", 0, 0, 0, 0);
				A_FireCustomMissile("ShotgunParticles", random(-17, 17), 0, -1, random(-17, 17));
				PB_FireBullets("PB_12GAPellet", 15, 2, 0, 0, 2);
				A_FireCustomMissile("GunFireSmoke", 0, 0, 0, 0, 0, 0);
			}
			TNT1 A 0 A_Recoil(2);
			TNT1 A 0 A_ZoomFactor(0.98);
			PMAF C 1 Bright PB_WeaponRecoil(-0.90, 0.90);
			TNT1 A 0 A_ZoomFactor(1.0);
			PMAF DEF 1;
			PMAF A 1;
			Goto M41AltPumpShell;

		M41AltPumpGrenade:
			PMAT ABCDEF 1;
			PMAT G 1 Offset(0, 32);
			PMAT G 1 Offset(2, 32);
			PMAT G 1 Offset(4, 34);
			PMAT G 1 Offset(6, 36);
			PMAT G 1 Offset(8, 38);
			PMAT G 1 Offset(10, 40);
			PMAT G 1 Offset(12, 42);
			PMAT G 1 Offset(14, 44);
			TNT1 A 0 A_WeaponReady(WRF_NOFIRE | WRF_NOBOB);
			PMAT H 1 A_PlaySound("weapons/sgpump", CHAN_WEAPON);
			TNT1 A 0 A_FireCustomMissile("EmptyGrenadeBrass", 5, 0, 8, -4);
			TNT1 A 0 A_TakeInventory("PB_RocketAmmo", 1, TIF_NOTAKEINFINITE);
			PMAT IJ 1;
			PMAT IH 1;
			TNT1 A 0 A_StartSound("weapons/sgpump", CHAN_AUTO, CHANF_OVERLAP);
			PMAT G 1 Offset(5, 36);
			PMAT G 1 Offset(3, 34);
			PMAT G 1 Offset(0, 32);
			PMAT GFEDCBA 1;
			Goto Ready3;

		M41AltPumpShell:
			PMAT ABCDEF 1;
			PMAT G 1 Offset(0, 32);
			PMAT G 1 Offset(2, 32);
			PMAT G 1 Offset(4, 34);
			PMAT G 1 Offset(6, 36);
			PMAT G 1 Offset(8, 38);
			PMAT G 1 Offset(10, 40);
			PMAT G 1 Offset(12, 42);
			PMAT G 1 Offset(14, 44);
			TNT1 A 0 A_WeaponReady(WRF_NOFIRE | WRF_NOBOB);
			PMAT H 1 A_PlaySound("weapons/sgpump", CHAN_WEAPON);
			TNT1 A 0 A_FireCustomMissile("ShotCaseSpawn", 5, 0, 8, -4);
			TNT1 A 0 A_TakeInventory("NewShell", 1, TIF_NOTAKEINFINITE);
			PMAT IJ 1;
			PMAT IH 1;
			TNT1 A 0 A_StartSound("weapons/sgpump", CHAN_AUTO, CHANF_OVERLAP);
			PMAT G 1 Offset(5, 36);
			PMAT G 1 Offset(3, 34);
			PMAT G 1 Offset(0, 32);
			PMAT GFEDCBA 1;
			Goto Ready3;

		WeaponSpecial:
			TNT1 A 0 A_TakeInventory("GoWeaponSpecialAbility", 1);
			TNT1 A 0 A_JumpIfInventory("SelectM41A_12Gauge", 1, "M41Wheel12Gauge");
			TNT1 A 0 A_JumpIfInventory("SelectM41A_30mmGrenade", 1, "M41WheelGrenade");
			TNT1 A 0 A_JumpIfInventory("SelectM41A_DualWield", 1, "M41WheelDual");
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "StopDualWieldM41A");
			TNT1 A 0 {
				A_ZoomFactor(1.0);
				A_TakeInventory("ADSmode", 1);
			}
			TNT1 A 0 A_JumpIfInventory("PB_M41A", 2, "SwitchToDualWieldM41A");
			TNT1 A 0 A_Print("\ctM41A\c- wheel: \cg12ga\c-, \ci30mm\c-, or \cddual\c-. Tap Special with two rifles to dual-wield.");
			Goto Ready3;

		M41WheelDual:
			TNT1 A 0 A_TakeInventory("SelectM41A_DualWield", 1);
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "StopDualWieldM41A");
			TNT1 A 0 A_JumpIfInventory("PB_M41A", 2, "SwitchToDualWieldM41A");
			TNT1 A 0 A_Print("\ckPick up a second \ctM41A \c-to dual-wield.");
			Goto Ready3;

		SwitchToDualWieldM41A:
			TNT1 A 0 {
				A_StartSound("IronSights", 15, CHANF_OVERLAP);
				A_SetAkimbo(true);
				A_SetInventory("DualWieldingM41A", 1);
				M41A_ClearDualOverlays();
			}
			PMDT ABCD 1;
			PMDT E 1;
			PMDT FGHI 1;
			Goto ReadyDualWield;

		StopDualWieldM41A:
			TNT1 A 0 {
				A_StartSound("IronSights", 15, CHANF_OVERLAP);
				A_SetAkimbo(false);
				A_SetInventory("DualWieldingM41A", 0);
				M41A_ClearDualOverlays();
			}
			PMDT IHGFEDCBA 1;
			Goto Ready3;

		M41Wheel12Gauge:
			TNT1 A 0 A_TakeInventory("SelectM41A_12Gauge", 1);
			TNT1 A 0 M41A_ExitDualIfNeeded();
			TNT1 A 0 A_GiveInventory("M41ChangeCart", 1);
			TNT1 A 0 A_Print("\ctM41A:\c- \cg12 gauge \c-alt (underbarrel)");
			TNT1 A 0 A_PlaySound("GRSLAP", CHAN_WEAPON);
			Goto Ready3;

		M41WheelGrenade:
			TNT1 A 0 A_TakeInventory("SelectM41A_30mmGrenade", 1);
			TNT1 A 0 M41A_ExitDualIfNeeded();
			TNT1 A 0 A_SetInventory("M41ChangeCart", 0);
			TNT1 A 0 A_Print("\ctM41A:\c- \ci30mm grenade \c-alt (underbarrel)");
			TNT1 A 0 A_PlaySound("GRSLAP", CHAN_WEAPON);
			Goto Ready3;

		Reload:
			TNT1 A 0
			{
				A_ZoomFactor(1.0);
				A_WeaponOffset(0, 32);
			}
			TNT1 A 0 A_TakeInventory("Reloading", 1);
			TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "IdleBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedFlameBarrel", 1, "IdleFlameBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "IdleIceBarrel");
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "ReloadDualWield");
			TNT1 A 0 A_JumpIfInventory("M41AChamberAmmo", m41a_ammoFull, "Ready3");
			TNT1 A 0 A_JumpIfInventory("NewClip", 1, "M41DoReload");
			TNT1 A 0 A_PlaySound("weapons/empty", CHAN_WEAPON);
			Goto M41NoAmmoJ;

		M41NoAmmoJ:
			PMAF A 5 A_DoPBWeaponAction(WRF_ALLOWRELOAD | WRF_NOFIRE);
			TNT1 A 0 A_JumpIfInventory("Reloading", 1, "Reload");
			TNT1 A 0 A_JumpIfInventory("NewClip", 1, "Reload");
			TNT1 A 0 A_JumpIfInventory("FiredPrimary", 1, "M41NoAmmoJ");
			Goto Ready3;

		M41DoReload:
			PMAR ABCD 1;
			PMAR EFGH 1;
			PMAR IJKL 1;
			PMAR MNOP 1;
			PMAR QQRST 1;
			TNT1 A 0 A_StartSound("M41A/MagTake", 33);
			PMAR UVWX 1;
			PMAR YZZZZZZZZ 1;
			TNT1 A 0 A_StartSound("M41A/MagIn", 34);
			PMAT ABCD 1;
			TNT1 A 0 PB_AmmoIntoMag("M41AChamberAmmo", "NewClip", m41a_ammoFull, 1);
			TNT1 A 0 A_TakeInventory("M41AUnloaded", 1);
			PMAT EFGH 1;
			PMAT IJKL 1;
			PMAT MNOP 1;
			TNT1 A 0 A_StartSound("M41A/Bolt", 35);
			PMAT QRRRST 1;
			PMAT UVWX 1;
			PMAT YYYY 1;
			PMAR KJIH 1;
			PMAR GFEDCBA 1;
			Goto Ready3;

		Unload:
			TNT1 A 0 A_TakeInventory("Unloading", 1);
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "UnloadDualWield");
			PMAR ABCD 1;
			PMAR EFGH 1;
			PMAR IJKL 1;
			PMAR MNOP 1;
			PMAR QQRST 1;
			TNT1 A 0 A_StartSound("M41A/MagTake", 33);
			PMAR UVWX 1;
			PMAR YZZZZZZZZ 1;
			TNT1 A 0 A_StartSound("M41A/MagIn", 34);
			PMAT ABCD 1;
			TNT1 A 0 PB_DumpMagToPool("M41AChamberAmmo", "NewClip", 1);
			TNT1 A 0 A_GiveInventory("M41AUnloaded", 1);
			PMAT EFGH 1;
			PMAT IJKL 1;
			PMAT MNOP 1;
			TNT1 A 0 A_StartSound("M41A/Bolt", 35);
			PMAT QRRRST 1;
			PMAT UVWX 1;
			PMAT YYYY 1;
			PMAR KJIH 1;
			PMAR GFEDCBA 1;
			Goto Ready3;

		SelectAnimationDualWield:
			PMDU ABCD 1;
			Goto ReadyDualWield;

		DeselectAnimationDualWield:
			TNT1 A 0 M41A_ClearDualOverlays();
			PMDU DCBA 1;
			TNT1 A 0 A_Lower(120);
			Wait;

		ReadyDualWield:
			TNT1 A 0 {
				A_SetRoll(0);
				PB_HandleCrosshair(42);
				A_SetFiringRightWeapon(false);
				A_SetFiringLeftWeapon(false);
				A_Overlay(10, "IdleLeft_Overlay", false);
				A_Overlay(11, "IdleRight_Overlay", false);
			}
		ReadyToFireDualWield:
			TNT1 A 1 {
				if (invoker.Ammo1 && invoker.Ammo1.Amount > 0)
				{
					if (invoker.AmmoLeft && invoker.Ammo2)
					{
						if (invoker.AmmoLeft.Amount <= 0 || invoker.Ammo2.Amount <= 0)
						{
							if (invoker.AmmoLeft.Amount <= 0 && invoker.Ammo2.Amount <= 0)
								A_SetInventory("DualFireReload", 2);
							else
								A_SetInventory("DualFireReload", 1);
						}
					}
				}
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD | WRF_NOFIRE);
			}
			Loop;

		IdleLeft_Overlay:
			PMLF A 1 {
				PB_CoolDownBarrel(13, 0, -2);
				if (CountInv("M41AChamberAmmoLeft") <= 0 && CountInv("M41AChamberAmmo") > 0)
					A_GiveInventory("DualFiring", 1);
				int firemodecvar = CVar.GetCVar("SingleDualFire", Player).GetInt();
				if ((PressingAltFire() || JustPressed(BT_ALTATTACK)) && !A_IsFiringLeftWeapon() && firemodecvar == 2)
				{
					if (CountInv("M41AChamberAmmoLeft") > 0)
						return ResolveState("FireLeft_Overlay");
					else
					{
						A_StartSound("weapons/empty", 10, CHANF_OVERLAP);
						return ResolveState(null);
					}
				}
				if (CountInv("DualFiring") == 0 || firemodecvar == 1)
				{
					if ((PressingFire() || JustPressed(BT_ATTACK)) && !A_IsFiringLeftWeapon() && firemodecvar < 2)
					{
						if (CountInv("M41AChamberAmmoLeft") > 0)
							return ResolveState("FireLeft_Overlay");
						else
						{
							A_StartSound("weapons/empty", 10, CHANF_OVERLAP);
							return ResolveState(null);
						}
					}
				}
				return ResolveState(null);
			}
			Loop;

		IdleRight_Overlay:
			PMRF A 1 {
				PB_CoolDownBarrel(-13, 0, -2);
				if (CountInv("M41AChamberAmmoLeft") > 0 && CountInv("M41AChamberAmmo") <= 0)
					A_TakeInventory("DualFiring", 1);
				int firemodecvar = CVar.GetCVar("SingleDualFire", Player).GetInt();
				if (CountInv("DualFiring") == 1 || (CountInv("DualFiring") == 1 && CountInv("M41AChamberAmmoLeft") <= 0))
				{
					if ((PressingFire() || JustPressed(BT_ATTACK)) && !A_IsFiringLeftWeapon() && firemodecvar == 0)
					{
						if (CountInv("M41AChamberAmmo") > 0)
							return ResolveState("FireRight_Overlay");
						else
						{
							A_StartSound("weapons/empty", 10, CHANF_OVERLAP);
							return ResolveState(null);
						}
					}
				}
				if ((PressingAltFire() || JustPressed(BT_ALTATTACK)) && !A_IsFiringRightWeapon() && firemodecvar == 1)
				{
					if (CountInv("M41AChamberAmmo") > 0)
						return ResolveState("FireRight_Overlay");
					else
					{
						A_StartSound("weapons/empty", 10, CHANF_OVERLAP);
						return ResolveState(null);
					}
				}
				if ((PressingFire() || JustPressed(BT_ATTACK)) && !A_IsFiringRightWeapon() && firemodecvar == 2)
				{
					if (CountInv("M41AChamberAmmo") > 0)
						return ResolveState("FireRight_Overlay");
					else
					{
						A_StartSound("weapons/empty", 10, CHANF_OVERLAP);
						return ResolveState(null);
					}
				}
				return ResolveState(null);
			}
			Loop;

		FireLeft_Overlay:
			PMLF B 1 Bright {
				M41A_FireDual(true);
				A_SetFiringLeftWeapon(true);
			}
			PMLF C 1 Bright {
				A_SetFiringLeftWeapon(false);
				if (CountInv("M41AChamberAmmoLeft") <= 0 || CountInv("M41AChamberAmmo") > 0)
					A_GiveInventory("DualFiring", 1);
			}
			PMLF D 1 {
				int firemodecvar = CVar.GetCVar("SingleDualFire", Player).GetInt();
				if (JustPressed(BT_ALTATTACK) && !A_IsFiringRightWeapon() && firemodecvar == 2)
				{
					if (CountInv("M41AChamberAmmoLeft") > 0)
						return ResolveState("FireLeft_Overlay");
					else
					{
						A_StartSound("weapons/empty", 10, CHANF_OVERLAP);
						return ResolveState(null);
					}
				}
				if (JustPressed(BT_ATTACK) && !A_IsFiringLeftWeapon())
				{
					if (CountInv("M41AChamberAmmoLeft") > 0)
						return ResolveState("FireLeft_Overlay");
					else
					{
						A_StartSound("weapons/empty", 10, CHANF_OVERLAP);
						return ResolveState(null);
					}
				}
				return ResolveState(null);
			}
			TNT1 A 0 {
				if (CountInv("M41AChamberAmmoLeft") <= 0)
					A_GiveInventory("DualFireReload", 1);
			}
			Goto IdleLeft_Overlay;

		FireRight_Overlay:
			PMRF B 1 Bright {
				M41A_FireDual(false);
				A_SetFiringRightWeapon(true);
			}
			PMRF C 1 Bright {
				A_SetFiringRightWeapon(false);
				if (CountInv("M41AChamberAmmoLeft") > 0 || CountInv("M41AChamberAmmo") <= 0)
					A_TakeInventory("DualFiring", 1);
			}
			PMRF D 1 {
				int firemodecvar = CVar.GetCVar("SingleDualFire", Player).GetInt();
				if (JustPressed(BT_ATTACK) && !A_IsFiringRightWeapon() && firemodecvar == 2)
				{
					if (CountInv("M41AChamberAmmo") > 0)
						return ResolveState("FireRight_Overlay");
					else
					{
						A_StartSound("weapons/empty", 10, CHANF_OVERLAP);
						return ResolveState(null);
					}
				}
				if (JustPressed(BT_ALTATTACK) && !A_IsFiringRightWeapon() && firemodecvar == 1)
				{
					if (CountInv("M41AChamberAmmo") > 0)
						return ResolveState("FireRight_Overlay");
					else
					{
						A_StartSound("weapons/empty", 10, CHANF_OVERLAP);
						return ResolveState(null);
					}
				}
				return ResolveState(null);
			}
			TNT1 A 0 {
				if (CountInv("M41AChamberAmmo") <= 0)
					A_GiveInventory("DualFireReload", 1);
			}
			Goto IdleRight_Overlay;

		NoAmmoDual:
			TNT1 A 1;
			Goto ReadyDualWield;

		ReloadDualWield:
			TNT1 A 0 M41A_ClearDualOverlays();
			TNT1 A 0 {
				int am1 = invoker.Ammo1 ? invoker.Ammo1.Amount : 0;
				int am2 = invoker.Ammo2 ? invoker.Ammo2.Amount : 0;
				int tr = invoker.AmmoLeft ? invoker.AmmoLeft.Amount : 0;
				if (am1 < 1)
					return ResolveState("NoAmmoDual");
				if (tr >= m41a_ammoFull && am2 >= m41a_ammoFull)
					return ResolveState("ReadyDualWield");
				A_SetInventory("DualFireReload", 0);
				return ResolveState(null);
			}
		ReloadRight:
			TNT1 A 0 A_JumpIf(invoker.Ammo2 && invoker.Ammo2.Amount >= m41a_ammoFull, "StartReloadFromLeft");
			TNT1 A 0 A_StartSound("IronSights", 15, CHANF_OVERLAP);
			PMDE ABCD 1;
			PMDE EFGH 1;
			PMAR P 1;
			PMAR QQRST 1;
			TNT1 A 0 A_StartSound("M41A/MagTake", 33);
			PMAR UVWX 1;
			PMAR YZZZZZZZZ 1;
			TNT1 A 0 A_StartSound("M41A/MagIn", 34);
			PMAT ABCD 1;
			TNT1 A 0 PB_AmmoIntoMag("M41AChamberAmmo", "NewClip", m41a_ammoFull, 1);
			TNT1 A 0 A_TakeInventory("M41AUnloaded", 1);
			PMAT EFGH 1;
			PMAT IJKL 1;
			PMAT MNOP 1;
			TNT1 A 0 A_StartSound("M41A/Bolt", 35);
			PMAT QRRRST 1;
			PMAT UVWX 1;
			PMAT YYYY 1;
			TNT1 A 0 A_JumpIf(!invoker.Ammo1 || invoker.Ammo1.Amount < 1 || !invoker.AmmoLeft || invoker.AmmoLeft.Amount >= m41a_ammoFull, "BackToReadyDualFromRight");
			PMDX EEDCBA 1;
			TNT1 A 5;
		ReloadLeft:
			TNT1 A 0 A_JumpIf(invoker.AmmoLeft && invoker.AmmoLeft.Amount >= m41a_ammoFull, "BackToReadyDual");
			TNT1 A 0 A_StartSound("IronSights", 15, CHANF_OVERLAP);
			PMDX ABCDEE 1;
			PMAR P 1;
			PMAR QQRST 1;
			TNT1 A 0 A_StartSound("M41A/MagTake", 33);
			PMAR UVWX 1;
			PMAR YZZZZZZZZ 1;
			TNT1 A 0 A_StartSound("M41A/MagIn", 34);
			PMAT ABCD 1;
			TNT1 A 0 PB_AmmoIntoMag("M41AChamberAmmoLeft", "NewClip", m41a_ammoFull, 1);
			TNT1 A 0 A_TakeInventory("M41AUnloaded", 1);
			PMAT EFGH 1;
			PMAT IJKL 1;
			PMAT MNOP 1;
			TNT1 A 0 A_StartSound("M41A/Bolt", 35);
			PMAT QRRRST 1;
			PMAT UVWX 1;
			PMAT YYYY 1;
		BackToReadyDualFromLeft:
			PMDL ABCDEF 1;
			TNT1 A 0 A_StartSound("IronSights", 15, CHANF_OVERLAP);
			PMDL GHI 1;
			Goto ReadyDualWield;
		BackToReadyDual:
			PMDU ABCD 1;
			Goto ReadyDualWield;
		BackToReadyDualFromRight:
			PMDE HGFE 1;
			TNT1 A 0 A_StartSound("IronSights", 15, CHANF_OVERLAP);
			PMDE DCBA 1;
			Goto ReadyDualWield;
		StartReloadFromLeft:
			TNT1 A 0 A_JumpIf(invoker.AmmoLeft && invoker.AmmoLeft.Amount >= m41a_ammoFull, "BackToReadyDual");
			PMDU DCBA 1;
			TNT1 A 3;
			Goto ReloadLeft;

		UnloadDualWield:
			TNT1 A 0 M41A_ClearDualOverlays();
			PMDU DCBA 1;
			TNT1 A 15;
			TNT1 A 0 A_StartSound("M41A/MagTake", 33);
			TNT1 A 0 PB_UnloadMag("M41AChamberAmmo", "NewClip", 1);
			TNT1 A 0 A_GiveInventory("M41AUnloaded", 1);
			TNT1 A 15;
			TNT1 A 0 A_StartSound("M41A/MagTake", 33);
			TNT1 A 0 PB_UnloadMag("M41AChamberAmmoLeft", "NewClip", 1);
			TNT1 A 0 A_GiveInventory("M41AUnloaded", 1);
			Goto BackToReadyDual;

		MuzzleFlash:
			TNT1 A 0 A_OverlayFlags(overlayID(), PSPF_MIRROR | PSPF_FLIP, random(0, 1));
			PMAF EF 1 Bright;
			Stop;

		MuzzleDualL:
			PMLF EF 1 Bright;
			Stop;
		MuzzleDualR:
			PMRF EF 1 Bright;
			Stop;

		FlashPunching:
			TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "FlashBarrelPunching");
			TNT1 A 0 A_JumpIfInventory("GrabbedFlameBarrel", 1, "FlashBarrelPunching");
			TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "FlashBarrelPunching");
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "FlashPunchingDualM41A");
			TNT1 A 0 A_ClearOverlays(10, 11);
			PMAK ABCDEFGHFEDCBA 1;
			TNT1 A 0 A_ClearOverlays(PSP_FLASH, PSP_FLASH, false);
			Goto Ready3;
		FlashPunchingDualM41A:
			TNT1 A 0 M41A_ClearDualOverlays();
			PMAK ABCDEFGHFEDCBA 1 {
				M41A_SetSpriteIfDual("TNT1");
			}
			TNT1 A 0 A_ClearOverlays(PSP_FLASH, PSP_FLASH, false);
			Goto ReadyDualWield;

		FlashKicking:
			TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "FlashBarrelKicking");
			TNT1 A 0 A_JumpIfInventory("GrabbedFlameBarrel", 1, "FlashBarrelKicking");
			TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "FlashBarrelKicking");
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "FlashKickingDualM41A");
			TNT1 A 0 A_ClearOverlays(10, 11);
			PMAK ABCDEFGHHFEDCBA 1;
			Goto Ready3;
		FlashKickingDualM41A:
			TNT1 A 0 M41A_ClearDualOverlays();
			PMAK ABCDEFGHHFEDCBA 1 {
				M41A_SetSpriteIfDual("PMDK");
			}
			Goto ReadyDualWield;

		FlashAirKicking:
			TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "FlashBarrelAirKicking");
			TNT1 A 0 A_JumpIfInventory("GrabbedFlameBarrel", 1, "FlashBarrelAirKicking");
			TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "FlashBarrelAirKicking");
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "FlashAirKickingDualM41A");
			TNT1 A 0 A_ClearOverlays(10, 11);
			PMAK ABCDEFGHHHFEDCBA 1;
			Goto Ready3;
		FlashAirKickingDualM41A:
			TNT1 A 0 M41A_ClearDualOverlays();
			PMAK ABCDEFGHHHFEDCBA 1 {
				M41A_SetSpriteIfDual("PMDK");
			}
			Goto ReadyDualWield;

		FlashSlideKicking:
			TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "FlashBarrelSlideKicking");
			TNT1 A 0 A_JumpIfInventory("GrabbedFlameBarrel", 1, "FlashBarrelSlideKicking");
			TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "FlashBarrelSlideKicking");
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "FlashSlideKickingDualM41A");
			TNT1 A 0 A_ClearOverlays(10, 11);
			PMAK ABCDEFGHHHHHHHHHHHHHGFEDCBA 1;
			Goto Ready3;
		FlashSlideKickingDualM41A:
			TNT1 A 0 M41A_ClearDualOverlays();
			PMAK ABCDEFGHHHHHHHHHHHHHGFEDCBA 1 {
				M41A_SetSpriteIfDual("PMDK");
			}
			Goto ReadyDualWield;

		FlashSlideKickingStop:
			TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "FlashBarrelSlideKickingStop");
			TNT1 A 0 A_JumpIfInventory("GrabbedFlameBarrel", 1, "FlashBarrelSlideKickingStop");
			TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "FlashBarrelSlideKickingStop");
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "FlashSlideKickingStopDualM41A");
			TNT1 A 0 A_ClearOverlays(10, 11);
			PMAK GFEDCBA 1;
			Goto Ready3;
		FlashSlideKickingStopDualM41A:
			TNT1 A 0 M41A_ClearDualOverlays();
			PMAK GFEDCBA 1 {
				M41A_SetSpriteIfDual("PMDK");
			}
			Goto ReadyDualWield;
	}
}
