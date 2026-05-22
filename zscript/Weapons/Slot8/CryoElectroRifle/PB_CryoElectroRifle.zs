// PB_CryoElectroRifle - ZScript port (DECORATE PB_Weapon retired).

class PB_CryoElectroRifle : PB_WeaponBase
{
	default
	{
		//Category Weapons
		//Title Cryo / Electro Rifle
	Weapon.SelectionOrder 7200;
	Weapon.SlotNumber 8;
	Weapon.SlotPriority 0.09;
	Weapon.AmmoType1 "PB_CryoCells";
	Weapon.AmmoGive1 40;
	Weapon.AmmoUse1 1;
	Weapon.BobRangeX 0.22;
	Weapon.BobRangeY 0.38;
	+WEAPON.NOAUTOAIM;
	+WEAPON.NOALERT;
	Inventory.PickupMessage "$PB_PICKUP_PB_CRYOELECTRORIFLE";
	Inventory.PickupSound "weapons/CryoRifle/up";
	Obituary "%o was iced by %k's cryo rifle.";
	Tag "Cryo Electro Rifle";
	Inventory.Icon "CRYRA0";
	}
	states
	{
		Spawn:
		"CRYR" A -1;
		Stop;

		Select:
		TNT1 A 0 {
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
		TNT1 A 0 PB_WeapTokenSwitch("PlasmaGunSelected");
		TNT1 A 0 PB_RespectIfNeeded;
		Goto SelectAnimation;

		SelectAnimation:
		"CYGS" "ABCD" 1 A_WeaponReady(WRF_NOFIRE);
		Goto Ready3;

		NoAmmo:
		TNT1 A 0;
		Goto ReadyLoop;

		Fire:
		TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "ThrowBarrel");
		TNT1 A 0 A_JumpIfInventory("GrabbedBurningBarrel", 1, "ThrowFlameBarrel");
		TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "ThrowIceBarrel");
		TNT1 A 0 {
			A_WeaponOffset(0, 32);
			A_SetRoll(0);
			A_SetCrosshair(39);
			if (CountInv("NoFatality") == 0 && GetCVAR("pb_auto_fatality_fire") == 1) {
				return PB_Execute();
			}
			return ResolveState(null);
		}
		TNT1 A 0 A_JumpIfInventory("PB_CryoElectroRifle_ElectricMode", 1, "FireElectric");
		TNT1 A 0 A_JumpIfInventory("PB_CryoCells", 1, "FireCryoShot");
		Goto Reload;
		FireCryoShot:
		TNT1 A 0 A_TakeInventory("PB_CryoCells", 1);
		TNT1 A 0 A_PlaySound("weapons/CryoRifle/missile", CHAN_WEAPON);
		"CYGW" B 1 Bright A_FireCustomMissile("PBCF_IceOrbCryo", 0, 1, 0, -3);
		"CYGW" A 3;
		Goto ReadyLoop;

		FireElectric:
		TNT1 A 0 A_JumpIfInventory("PB_CryoCells", 1, "FireElectricShot");
		Goto Reload;
		FireElectricShot:
		TNT1 A 0 A_TakeInventory("PB_CryoCells", 1);
		TNT1 A 0 A_PlaySound("weapon/HMG/Fire", CHAN_WEAPON);
		"CYGW" B 1 Bright A_FireCustomMissile("LightningMissile2", 0, 1, 0, -5);
		"CYGW" A 3;
		Goto ReadyLoop;

		AltFire:
		TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "PlaceBarrel");
		TNT1 A 0 A_JumpIfInventory("GrabbedBurningBarrel", 1, "PlaceFlameBarrel");
		TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "PlaceIceBarrel");
		Goto ReadyLoop;

		Reload:
		TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "IdleBarrel");
		TNT1 A 0 A_JumpIfInventory("GrabbedBurningBarrel", 1, "IdleFlameBarrel");
		TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "IdleIceBarrel");
		TNT1 A 0 A_TakeInventory("Reloading", 1);
		TNT1 A 0 A_JumpIfInventory("PB_CryoCells", 300, "Ready3");
		TNT1 A 0 A_JumpIfInventory("PB_Cell", 1, "ReloadFromCell");
		TNT1 A 0 A_TakeInventory("Reloading", 1);
		Goto Ready3;

		ReloadFromCell:
		TNT1 A 0 A_PlaySound("CELLIN2", CHAN_AUTO);
		TNT1 A 0 A_GiveInventory("PB_CryoCells", 40);
		TNT1 A 0 A_TakeInventory("PB_Cell", 1, TIF_NOTAKEINFINITE);
		TNT1 A 0 A_TakeInventory("Reloading", 1);
		Goto Ready3;

		WeaponSpecial:
		TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "IdleBarrel");
		TNT1 A 0 A_JumpIfInventory("GrabbedBurningBarrel", 1, "IdleFlameBarrel");
		TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "IdleIceBarrel");
		TNT1 A 0 A_TakeInventory("GoWeaponSpecialAbility", 1);
		TNT1 A 0 A_JumpIfInventory("Select_PB_CryoElectro_Cryo", 1, "WSpecCryo");
		TNT1 A 0 A_JumpIfInventory("Select_PB_CryoElectro_Electric", 1, "WSpecElectro");
		Goto Ready3;

		WSpecCryo:
		TNT1 A 0 { A_TakeInventory("Select_PB_CryoElectro_Cryo", 1); A_TakeInventory("Select_PB_CryoElectro_Electric", 1); A_SetInventory("PB_CryoElectroRifle_ElectricMode", 0); A_PlaySound("menu/choose", CHAN_AUTO); }
		Goto Ready3;

		WSpecElectro:
		TNT1 A 0 { A_TakeInventory("Select_PB_CryoElectro_Cryo", 1); A_TakeInventory("Select_PB_CryoElectro_Electric", 1); A_SetInventory("PB_CryoElectroRifle_ElectricMode", 1); A_PlaySound("menu/choose", CHAN_AUTO); }
		Goto Ready3;

		Ready:
		Ready3:
		ReadyLoop:
		TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
		TNT1 A 0 A_JumpIfInventory("GoWeaponSpecialAbility", 1, "WeaponSpecial");
		TNT1 A 0 {
			A_TakeInventory("PB_LockScreenTilt", 1);
			PB_HandleCrosshair(39);
		}
		"CYGW" A 1 A_DoPBWeaponAction();
		Loop;

		ChooseUpgradePath:
		Goto ReadyLoop;

		Deselect:
		TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "PlaceBarrel");
		TNT1 A 0 A_JumpIfInventory("GrabbedBurningBarrel", 1, "PlaceFlameBarrel");
		TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "PlaceIceBarrel");
		TNT1 A 0 {
			A_WeaponOffset(0, 32);
			A_SetRoll(0);
			PB_HandleCrosshair(39);
			A_TakeInventory("PB_LockScreenTilt", 1);
		}
		TNT1 A 0 A_TakeInventory("Spin", 1);
		TNT1 A 0 A_StopSound(1);
		"CYGW" "EDCBA" 1;
		DeselectLower:
		TNT1 A 0 A_Lower;
		Wait;

		Flash:
		TNT1 A 2 A_Light2;
		TNT1 A 1 A_Light1;
		TNT1 A 0 A_Light0;
		Stop;

		FlashKicking:
		TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "FlashBarrelKicking");
		TNT1 A 0 A_JumpIfInventory("GrabbedBurningBarrel", 1, "FlashBarrelKicking");
		TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "FlashBarrelKicking");
		"CYGW" "BCDEFGHIIIIIIIII" 1;
		Goto Ready3;

		FlashAirKicking:
		TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "FlashBarrelAirKicking");
		TNT1 A 0 A_JumpIfInventory("GrabbedBurningBarrel", 1, "FlashBarrelAirKicking");
		TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "FlashBarrelAirKicking");
		"CYGW" "BCDEFGHIIIIIIIIIII" 1;
		Goto Ready3;

		FlashSlideKicking:
		Goto FlashSlideKickingStop;
		FlashSlideKickingStop:
		TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "FlashBarrelSlideKickingStop");
		TNT1 A 0 A_JumpIfInventory("GrabbedBurningBarrel", 1, "FlashBarrelSlideKickingStop");
		TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "FlashBarrelSlideKickingStop");
		"CYGW" "IIIIIHGFEDCB" 1;
		Goto Ready3;

		PDA_Preview_CEReady:
		"CYGW" A 2 A_WeaponReady(WRF_NOFIRE);
		Stop;
		PDA_Preview_CECryo:
		"CYGW" B 2 Bright A_WeaponReady(WRF_NOFIRE);
		"CYGW" C 2 Bright A_WeaponReady(WRF_NOFIRE);
		"CYGW" D 2 A_WeaponReady(WRF_NOFIRE);
		"CYGW" E 2 A_WeaponReady(WRF_NOFIRE);
		"CYGW" A 4 A_WeaponReady(WRF_NOFIRE);
		Stop;
		PDA_Preview_CEElectric:
		"CYGW" B 1 Bright A_WeaponReady(WRF_NOFIRE);
		"CYGW" C 1 Bright A_WeaponReady(WRF_NOFIRE);
		"CYGW" B 1 Bright A_WeaponReady(WRF_NOFIRE);
		"CYGW" C 1 Bright A_WeaponReady(WRF_NOFIRE);
		"CYGW" D 2 A_WeaponReady(WRF_NOFIRE);
		"CYGW" A 4 A_WeaponReady(WRF_NOFIRE);
		Stop;
		PDA_Preview_CEReload:
		"CYGS" D 3 A_WeaponReady(WRF_NOFIRE);
		"CYGS" C 3 A_WeaponReady(WRF_NOFIRE);
		"CYGS" B 3 A_WeaponReady(WRF_NOFIRE);
		"CYGS" A 3 A_WeaponReady(WRF_NOFIRE);
		"CYGW" A 3 A_WeaponReady(WRF_NOFIRE);
		Stop;
	}
}
