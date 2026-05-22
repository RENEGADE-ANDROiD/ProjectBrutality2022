const BDP_BR_MAG = 15;

// : PB_WeaponBase: was PB_Weapon (ZScript only sees ZScript types in UZDoom; SelectFirstPersonLegs inlined from BaseWeapon.dec)
class BDPBattleRifle : PB_WeaponBase
{
	bool isADS;
	int burstCount;

	default
	{
		//$Title Battle Rifle
		//$Category Weapons
		//$Sprite BR45A0
		Weapon.SlotNumber 4;
		Weapon.SlotPriority 2;
		Weapon.SelectionOrder 1550;
		Weapon.AmmoType1 "NewClip";
		Weapon.AmmoType2 "BR_Ammo";
		Weapon.AmmoGive1 30;
		Weapon.AmmoUse1 0;
		Weapon.AmmoUse2 0;
		Scale 1.0;
		+WEAPON.NOALERT;
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.NOAUTOFIRE;
		Inventory.AltHUDIcon "BR45A0";
		Obituary "%o was pierced by %k's Battle Rifle.";
		Inventory.PickupMessage "Battle Rifle (Slot 4)";
		Inventory.PickupSound "weapons/battlerifle/up";
		Tag "Battle Rifle";
		PB_WeaponBase.respectItem "BattleRifleRespect";
	}

	override void PostBeginPlay()
	{
		isADS = false;
		burstCount = 0;
		Super.PostBeginPlay();
	}

	action int getBRMag() { return CountInv(invoker.ammotype2); }
	action void setADS(bool s) { invoker.isADS = s; }
	action bool getADS() { return invoker.isADS; }

	action void BDP_ShotHip()
	{
		if (getBRMag() < 1) return;
		PB_FireBullets("PB_762x51mm", 1, frandom(-0.1, 0.1), 0, 0, frandom(-0.1, 0.1));
		PB_SpawnCasing("PB_EmptyBrass", 22, 2, 28, frandom(-2, -1), frandom(5, 8), frandom(3, 4));
		A_TakeInventory(invoker.ammotype2, 1);
		PB_IncrementHeat(4);
		A_StartSound("weapons/battlerifle/fire", CHAN_WEAPON, CHANF_OVERLAP, 1.0, 0, 1.12);
		PB_WeaponRecoil(-1.8, frandom(-0.3, 0.3));
		PB_GunSmoke(0, 0, 0);
		invoker.burstCount++;
	}

	action void BDP_ShotADS()
	{
		if (getBRMag() < 1) return;
		PB_FireBullets("PB_762x51mm", 1, frandom(-0.04, 0.04), 0, 0, frandom(-0.04, 0.04));
		PB_SpawnCasing("PB_EmptyBrass", 22, 2, 28, frandom(-2, -1), frandom(5, 8), frandom(3, 4));
		A_TakeInventory(invoker.ammotype2, 1);
		PB_IncrementHeat(4);
		A_StartSound("weapons/battlerifle/fire", CHAN_WEAPON, CHANF_OVERLAP, 1.0, 0, 1.12);
		PB_WeaponRecoil(-1.1, frandom(-0.2, 0.2));
		PB_GunSmoke(0, 0, -1);
		invoker.burstCount++;
	}

	action state BDP_CheckReload(
		int min = 1,
		statelabel noammolabel = null,
		statelabel emptylabel = null,
		statelabel fullabel = null,
		int alrfull = 1)
	{
		let a1 = invoker.ammotype1;
		let a2 = invoker.ammotype2;
		if (!a1 || !a2)
			return resolvestate(null);
		int r = countinv(a1);
		int m = countinv(a2);
		if (m >= alrfull) return resolvestate(fullabel);
		if (r < min) return resolvestate(noammolabel);
		if (m < 1) return resolvestate(emptylabel);
		return resolvestate(null);
	}

	states
	{
		Spawn:
			BR45 A -1;
			Stop;
		Steady:
			TNT1 A 1;
			goto Ready3;

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
			TNT1 A 0 A_TakeInventory("Spin",1);
			TNT1 A 0 A_TakeInventory("CantWeaponSpecial",1);
			TNT1 A 0 A_TakeInventory("MG42Selected",1);
			TNT1 A 0 A_SetInventory("Grabbing_A_Ledge", 0);
			TNT1 A 0 A_TakeInventory("RandomHeadExploder",1);
			TNT1 A 0 A_TakeInventory("DualFireReload",2);
			TNT1 A 0 A_Overlay(-777, "Melee_Equipment_Handler_Overlay");
			TNT1 A 0 A_Overlay(-778, "KickHandler_Overlay");
			TNT1 A 0 A_Overlay(-779, "Equipment_Toggle_Handler_Overlay");
			TNT1 A 0 A_Overlay(-10, "FirstPersonLegsStand");
			TNT1 A 0 A_Jump(255, "SelectContinue");
		SelectContinue:
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			TNT1 A 0 A_StartSound("weapons/battlerifle/up", CHAN_WEAPON);
			TNT1 A 0 PB_WeapTokenSwitch("RifleSelected");
			TNT1 A 0
			{
				if (CountInv("BR_Ammo") < 1 && CountInv("BattleRifleRespect") < 1)
					A_GiveInventory("BR_Ammo", 15);
			}
			TNT1 A 0 PB_RespectIfNeeded();
		SelectAnimation:
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			TNT1 A 0
			{
				invoker.burstCount = 0;
				PB_HandleCrosshair(42);
			}
			BR4S EDCBA 1;
			goto Ready3;

		WeaponRespect:
			BR4S EDCBA 1 A_DoPBWeaponAction();
			BR45 BBB 1 A_DoPBWeaponAction();
			TNT1 A 0 A_StartSound("weapons/battlerifle/magout", 3, CHANF_OVERLAP);
			BR4R ABCDE 1 A_DoPBWeaponAction();
			BR4R FGGGGG 1 A_DoPBWeaponAction();
			BR4R GHIJKLMNOP 1 A_DoPBWeaponAction();
			TNT1 A 0 A_StartSound("weapons/battlerifle/magin", 3);
			BR4R QRSTUVWX 1 A_DoPBWeaponAction();
			goto Ready3;

		Deselect:
			TNT1 A 0 A_TakeInventory("Zoomed", 1);
			TNT1 A 0 setADS(false);
			TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "PlaceBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedFlameBarrel", 1, "PlaceFlameBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "PlaceIceBarrel");
			BR4S ABCDE 1;
			TNT1 A 0 A_StopSound(1);
			TNT1 A 0 A_StopSound(2);
			TNT1 A 0 A_StopSound(6);
			TNT1 A 1;
			TNT1 A 0 A_Lower(120);
			wait;

		Ready:
		Ready3:
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			TNT1 A 0 A_JumpIfInventory("Zoomed", 1, "ReadyADS");
		HipReadyLoop:
			BR45 B 1
			{
				PB_HandleCrosshair(42);
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD);
			}
			loop;

		ReadyADS:
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			BR4Z D 1 BRIGHT
			{
				A_SetRoll(0);
				PB_HandleCrosshair(5);
				A_SetInventory("PB_LockScreenTilt", 0);
				if (CVar.GetCVar("pb_toggle_aim_hold", player).GetInt() == 1)
				{
					if (!PressingAltfire() || JustReleased(BT_ALTATTACK)) return resolvestate("ZoomOut");
					if (PressingFire() && PressingAltfire() && CountInv("BR_Ammo") > 0)
						return resolvestate("FireADS");
					return A_DoPBWeaponAction(WRF_ALLOWRELOAD | WRF_NOSECONDARY);
				}
				if (PressingFire() && CountInv("BR_Ammo") > 0)
					return resolvestate("FireADS");
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD);
			}
			loop;

		Fire:
			TNT1 A 0
			{
				A_WeaponOffset(0, 32);
				A_SetRoll(0);
				PB_HandleCrosshair(42);
				A_TakeInventory("PB_LockScreenTilt", 1);
			}
			TNT1 A 0
			{
				if (CountInv("GoFatality") >= 1) SetPlayerProperty(0, 1, 0);
				else SetPlayerProperty(0, 0, 0);
			}
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			TNT1 A 0 PB_CheckBarrelThrow1();
			TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "ThrowBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedFlameBarrel", 1, "ThrowFlameBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "ThrowIceBarrel");
			TNT1 A 0
			{
				let po = invoker.Owner;
				if (po == null || !(po is "PlayerPawn"))
					return resolveState(null);
				let pp = PlayerPawn(po);
				if (pp && pp.player && invoker.CountInv("NoFatality") == 0
					&& CVar.GetCVar("pb_auto_fatality_fire", pp.player).GetBool())
					return PB_Execute();
				return resolveState(null);
			}
			TNT1 A 0 A_JumpIfInventory("Zoomed", 1, "FireADS");
			TNT1 A 0 A_JumpIfInventory("BR_Ammo", 1, "FireHip");
			TNT1 A 0 A_JumpIf(CountInv(invoker.ammotype1) >= 1, "Reload");
			TNT1 A 0 A_StartSound("weapons/battlerifle/dry", CHAN_WEAPON);
			goto Ready3;
		FireHip:
			TNT1 A 0 { invoker.burstCount = 0; }
			BR4F C 1 BRIGHT { BDP_ShotHip(); }
			BR45 D 1;
			BR4F C 1;
			BR4F C 1 BRIGHT { BDP_ShotHip(); }
			BR45 D 1;
			BR4F C 1;
			BR4F C 1 BRIGHT { BDP_ShotHip(); }
			BR45 D 1
			{
				if (getBRMag() < 1)
					PB_SpawnCasing("EmptyCarbineMag", 5, 0, -14, 0, frandom(2, 4), frandom(2, 4));
			}
			BR45 E 1;
			BR45 F 1;
			BR45 G 1;
			BR45 H 1;
			TNT1 A 0 { invoker.burstCount = 0; }
			TNT1 A 0 A_Refire("Fire");
			goto Ready3;

		FireADS:
			TNT1 A 0 A_JumpIf(CountInv("BR_Ammo") < 1 && CountInv(invoker.ammotype1) >= 1, "ReloadFromADS");
			TNT1 A 0 A_JumpIf(CountInv("BR_Ammo") < 1, "FireADSDry");
			TNT1 A 0 { invoker.burstCount = 0; }
			BR4Z D 1 BRIGHT { BDP_ShotADS(); }
			BR4Z D 2 BRIGHT;
			BR4Z D 1 BRIGHT { BDP_ShotADS(); }
			BR4Z D 2 BRIGHT;
			BR4Z D 1 BRIGHT { BDP_ShotADS(); }
			BR4Z D 1 BRIGHT
			{
				if (getBRMag() < 1)
					PB_SpawnCasing("EmptyCarbineMag", 5, 15, -7, 0, frandom(2, 4), frandom(2, 4));
			}
			BR4Z D 2 BRIGHT;
			TNT1 A 0 { invoker.burstCount = 0; }
			TNT1 A 0 A_Refire("FireADS");
			goto ReadyADS;
		FireADSDry:
			TNT1 A 0 A_StartSound("weapons/battlerifle/dry", CHAN_WEAPON);
			goto ReadyADS;

		AltFire:
			TNT1 A 0 A_JumpIfInventory("Zoomed", 1, "ZoomOut");
		ZoomIn:
			TNT1 A 0 A_GiveInventory("Zoomed", 1);
			TNT1 A 0 setADS(true);
			TNT1 A 0 A_StartSound("weapons/battlerifle/switch", CHAN_AUTO);
			BR4Z A 1 A_ZoomFactor(1.0);
			BR4Z B 1 A_ZoomFactor(2.0);
			BR4Z C 1 A_ZoomFactor(3.0);
			TNT1 A 0
			{
				PB_HandleCrosshair(5);
				A_SetInventory("PB_LockScreenTilt", 0);
			}
			goto ReadyADS;
		ZoomOut:
			TNT1 A 0 A_TakeInventory("Zoomed", 1);
			TNT1 A 0 setADS(false);
			TNT1 A 0 A_StartSound("weapons/battlerifle/switch", CHAN_AUTO);
			BR4Z C 1 A_ZoomFactor(3.0);
			BR4Z B 1;
			BR4Z A 1;
			TNT1 A 0 A_ZoomFactor(1.0);
			TNT1 A 0 PB_HandleCrosshair(42);
			goto Ready3;

		ReloadFromADS:
			TNT1 A 0 A_ZoomFactor(1.0);
			TNT1 A 0 A_TakeInventory("Zoomed", 10);
		Reload:
			TNT1 A 0 A_ZoomFactor(1.0);
			TNT1 A 0 A_TakeInventory("Zoomed", 10);
			TNT1 A 0 setADS(false);
			TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "IdleBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedFlameBarrel", 1, "IdleFlameBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "IdleIceBarrel");
			TNT1 A 0 BDP_CheckReload(1, "NoAmmoH", "RaiseFromEmpty", "Ready3", 15);
			TNT1 A 0 A_StartSound("weapons/battlerifle/magout", 3, CHANF_OVERLAP);
			BR4R ABCDE 1;
			TNT1 A 0
			{
				if (getBRMag() > 0)
					PB_SpawnCasing("EmptyCarbineMag", 0, 0, -14, 0, frandom(1, 3), frandom(1, 3));
			}
			BR4R FGGGGG 1;
		ContinueReload:
			BR4R GHIJKLMNOP 1;
			TNT1 A 0
			{
				A_StartSound("weapons/battlerifle/magin", 3);
				PB_AmmoIntoMag("BR_Ammo", "NewClip", BDP_BR_MAG, 1);
			}
			BR4R QRSTUVWX 1;
			goto Ready3;
		RaiseFromEmpty:
			TNT1 A 0 A_ZoomFactor(1.0);
			TNT1 A 0 A_StartSound("weapons/battlerifle/magout", 3, CHANF_OVERLAP);
			BR4R ABCDEF 1;
			goto ContinueReload;

		NoAmmoH:
			BR45 B 1;
			goto Ready3;

		Unload:
			TNT1 A 0 A_TakeInventory("Unloading", 1);
			TNT1 A 0 A_JumpIf(CountInv("BR_Ammo") < 1, "Ready3");
			TNT1 A 0 A_StartSound("weapons/battlerifle/magout", 3, CHANF_OVERLAP);
			BR4R ABCDE 1;
			TNT1 A 0
			{
				if (getBRMag() > 0)
					PB_SpawnCasing("EmptyCarbineMag", 0, 0, -14, 0, frandom(1, 3), frandom(1, 3));
			}
			TNT1 A 0 PB_DumpMagToPool("BR_Ammo", "NewClip", 1);
			BR4R S 1;
			BR4R R 1;
			BR4R Q 1;
			BR4R M 1;
			goto Ready3;

		WeaponSpecial:
			TNT1 A 0 A_TakeInventory("GoWeaponSpecialAbility", 1);
			TNT1 A 0 A_Print("\ctWeapon Special:\c- \cdutility \c-");
			goto Ready3;

		FlashPunching:
			TNT1 A 0 A_ClearOverlays(10, 11);
			BR4K C 1;
			BR4K D 1;
			BR4K E 1;
			Goto Ready3;
		FlashKicking:
			goto FlashAirKicking;
		FlashAirKicking:
			TNT1 A 0 A_ClearOverlays(10, 11);
			BR4K C 1;
			BR4K D 1;
			BR4K E 1;
			goto Ready3;
		FlashSlideKicking:
			TNT1 A 0 A_ClearOverlays(10, 11);
			BR4K C 1;
			BR4K D 2;
			BR4K E 1;
			goto Ready3;
		FlashSlideKickingStop:
			TNT1 A 0 A_ClearOverlays(10, 11);
			BR4K D 1;
			BR4K C 1;
			goto Ready3;
	}
}
