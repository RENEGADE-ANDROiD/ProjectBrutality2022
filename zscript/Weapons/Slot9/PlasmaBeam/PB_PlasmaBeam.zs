// Reilsss Plasma Beam fold as PB_PlasmaBeam (UAC Plasma Beam Rifle).

class PB_PlasmaBeam : PB_WeaponBase
{
	const PLASMA_BEAM_MAG = 100;

	Default
	{
		Weapon.BobRangeX 0.3;
		Weapon.BobRangeY 0.5;
		Weapon.BobStyle "InverseSmooth";
		Weapon.BobSpeed 2.4;
		Weapon.SelectionOrder 2800;
		Weapon.AmmoUse1 0;
		Weapon.AmmoGive1 40;
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 0;
		Weapon.AmmoType1 "Cell";
		Weapon.AmmoType2 "PlasmaBeamAmmo";
		Weapon.SlotNumber 7;
		Weapon.SlotPriority 0.23;
		+WEAPON.NOAUTOAIM;
		+FLOORCLIP;
		+DONTGIB;
		Inventory.PickupSound "weapons/PlasmaBeam/Select";
		Inventory.PickupMessage "$PB_PICKUP_PB_PLASMABEAM";
		Inventory.Icon "PLBMA0";
		Inventory.AltHUDIcon "PLBMA0";
		Obituary "%o was carved apart by %k's UAC Plasma Beam.";
		Tag "UAC Plasma Beam Rifle";
		Scale 0.45;
	}

	override void AttachToOwner(Actor other)
	{
		if (other && other.player)
		{
			if (other.CountInv("PlasmaBeamAmmo") < 1)
				other.A_GiveInventory("PlasmaBeamAmmo", PLASMA_BEAM_MAG);
		}
		Super.AttachToOwner(other);
	}

	States
	{
	Steady:
		Goto PB_FinisherCleanup;



	Spawn:
		PLBM A -1;
		Stop;

	Ready:
		TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
		Goto Ready3;

	Ready3:
		TNT1 A 0
		{
			A_TakeInventory("PB_LockScreenTilt", 1);
			PB_HandleCrosshair(46);
		}
		TNT1 A 0 A_StartSound("weapons/PlasmaBeam/Idle_Loop", 6, CHANF_LOOPING, 1.0);
		PLBG A 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
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
			A_StopSound(4);
			A_StopSound(5);
			A_StopSound(6);
			A_StopSound(CHAN_WEAPON);
		}
		PLBG EFG 1;
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
		TNT1 A 0 PB_WeapTokenSwitch("PlasmaGunSelected");
		TNT1 A 0 PB_RespectIfNeeded;
		Goto SelectAnimation;
	SelectAnimation:
		TNT1 A 0 A_StartSound("weapons/PlasmaBeam/Select", CHAN_AUTO);
		PLBG HGFEDCBA 1;
		TNT1 A 0 A_JumpIfInventory("PlasmaBeamAmmo", 1, "Ready3");
		Goto Reload;

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
		TNT1 A 0 { return PB_BailIfCannotFire("PlasmaBeamAmmo", 2, "Cell"); }
		TNT1 A 0 A_StopSound(6);
		TNT1 A 0 A_StartSound("weapons/PlasmaBeam/Fire_Start", 3);
		PLBG AB 1;
		PLBF ABC 1 Bright;
		TNT1 A 0 A_FireCustomMissile("GreenFlareSpawn", 0, 0, 7, 0);
		TNT1 A 0 A_FireCustomMissile("GunFireSmoke", 0, 0, 7, 0);
		TNT1 A 0 A_Quake(2, 6, 0, 16);
		TNT1 A 0 A_StartSound("weapons/PlasmaBeam/Fire_Loop", 4, CHANF_LOOPING, 1.0);
		TNT1 A 0 A_StartSound("weapons/PlasmaBeam/Fire_Add_Loop", 5, CHANF_LOOPING, 1.0);
		Goto Hold;

	Hold:
		TNT1 A 0 A_JumpIfInventory("PlasmaBeamAmmo", 2, 1);
		Goto BeamRelease;
		PLBS ABCD 1 Bright
		{
			A_RailAttack(random(12, 18), 7, 0, "", "00 FF 66", RGF_NOPIERCING | RGF_SILENT | RGF_FULLBRIGHT, 0, "hitpuff", 0, 0, 8192, 1);
			A_AlertMonsters();
			PB_WeaponRecoil(-0.3, frandom(-0.2, 0.2));
		}
		TNT1 A 0 A_TakeInventory("PlasmaBeamAmmo", 2);
		TNT1 A 0 A_FireCustomMissile("GreenFlareSpawn", 0, 0, 7, 0);
		TNT1 A 0 A_FireCustomMissile("GunFireSmoke", 0, 0, 7, 0);
		PLBS EFGH 1 Bright
		{
			A_RailAttack(random(12, 18), 7, 0, "", "00 FF 66", RGF_NOPIERCING | RGF_SILENT | RGF_FULLBRIGHT, 0, "hitpuff", 0, 0, 8192, 1);
			PB_WeaponRecoil(-0.3, frandom(-0.2, 0.2));
		}
		TNT1 A 0 A_FireCustomMissile("GreenFlareSpawn", 0, 0, 7, 0);
		TNT1 A 0 A_FireCustomMissile("GunFireSmoke", 0, 0, 7, 0);
		TNT1 A 0 A_ReFire;
	BeamRelease:
		TNT1 A 0 A_StopSound(4);
		TNT1 A 0 A_StopSound(5);
		TNT1 A 0 A_StartSound("weapons/PlasmaBeam/Fire_Stop", CHAN_AUTO);
		Goto Cooldown;

	AltFire:
		TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "ThrowBarrel");
		TNT1 A 0 A_JumpIfInventory("GrabbedBurningBarrel", 1, "ThrowFlameBarrel");
		TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "ThrowIceBarrel");
		TNT1 A 0 A_WeaponOffset(0, 32);
		TNT1 A 0 A_TakeInventory("Reloading", 1);
		TNT1 A 0 { return PB_BailIfCannotFire("PlasmaBeamAmmo", 2, "Cell"); }
		TNT1 A 0 A_StopSound(6);
		TNT1 A 0 A_StartSound("weapons/PlasmaBeam/Fire_Start", 5);
		PLBG AB 1;
		PLBF ABC 1 Bright;
		Goto AltHold;

	AltHold:
		TNT1 A 0 A_JumpIfInventory("PlasmaBeamAmmo", 2, 1);
		Goto AltRelease;
		TNT1 A 0 A_StartSound("weapons/PlasmaBeam/AltFire_1", CHAN_WEAPON, CHANF_OVERLAP, 1.0);
		TNT1 A 0 A_FireCustomMissile("GunFireSmoke", 0, 0, 7, 0);
		TNT1 A 0 A_Quake(2, 6, 0, 16);
		PLBS AB 2 Bright
		{
			A_FireCustomMissile("PB_PlasmaBeam_Sphere", random(-4, 4), 0, 8, 0, 0, random(-1, 1));
			A_AlertMonsters();
			PB_WeaponRecoil(-0.6, frandom(-0.3, 0.3));
		}
		TNT1 A 0 A_TakeInventory("PlasmaBeamAmmo", 2);
		TNT1 A 0 A_FireCustomMissile("GreenFlareSpawn", 0, 0, 7, 0);
		PLBS CD 2 Bright;
		TNT1 A 0 A_StartSound("weapons/PlasmaBeam/AltFire_1", CHAN_WEAPON, CHANF_OVERLAP, 1.0);
		TNT1 A 0 A_FireCustomMissile("GunFireSmoke", 0, 0, 7, 0);
		TNT1 A 0 A_Quake(2, 6, 0, 16);
		PLBS EF 2 Bright
		{
			A_FireCustomMissile("PB_PlasmaBeam_Sphere", random(-5, 5), 0, 8, 0, 0, random(-2, 2));
			PB_WeaponRecoil(-0.6, frandom(-0.3, 0.3));
		}
		TNT1 A 0 A_TakeInventory("PlasmaBeamAmmo", 2);
		TNT1 A 0 A_FireCustomMissile("GreenFlareSpawn", 0, 0, 7, 0);
		PLBS GH 2 Bright;
		TNT1 A 0 A_ReFire;
	AltRelease:
		TNT1 A 0 A_StartSound("weapons/PlasmaBeam/Fire_Stop", CHAN_AUTO);
		Goto Cooldown;

	Cooldown:
		PLBC ABCDE 3;
		PLBC EEEE 2;
		PLBC EDCBA 3;
		Goto Ready3;

	Reload:
		PLBG A 1 A_WeaponReady(WRF_NOFIRE);
		TNT1 A 0 A_StopSound(4);
		TNT1 A 0 A_StopSound(5);
		TNT1 A 0 A_StopSound(6);
		TNT1 A 0 A_TakeInventory("Reloading", 1);
		TNT1 A 0 A_JumpIfInventory("PlasmaBeamAmmo", PLASMA_BEAM_MAG, "Ready3");
		TNT1 A 0 A_JumpIfInventory("Cell", 1, "ReloadAnim");
		Goto NoAmmo;
	NoAmmo:
		TNT1 A 0 A_PlaySound("weapons/empty");
		PLBG A 8 A_WeaponReady(WRF_NOFIRE|WRF_NOSWITCH);
		Goto Ready3;
	ReloadAnim:
		TNT1 A 0 A_StartSound("weapons/PlasmaBeam/Clip_Out", CHAN_AUTO);
		PLBR AB 2;
		PLBR CDE 2;
		PLBR FG 2 A_StartSound("weapons/PlasmaBeam/Clip_In", CHAN_AUTO);
		PLBR HIJKLMN 3;
		PLBR OPQRST 2;
		PLBR UVWXYZ 2;
		PLBG A 1;
	ReloadFill:
		TNT1 A 0 A_JumpIfInventory("PlasmaBeamAmmo", PLASMA_BEAM_MAG, "Ready3");
		TNT1 A 0 A_JumpIfInventory("Cell", 1, 1);
		Goto Ready3;
		TNT1 A 0
		{
			A_GiveInventory("PlasmaBeamAmmo", 1);
			A_TakeInventory("Cell", 1);
		}
		Goto ReloadFill;

	FlashKicking:
		PLBG AAAAAAAAAAAAAAA 1;
		Stop;
	FlashAirKicking:
		PLBG AAAAAAAAAAAAAAAA 1;
		Stop;
	FlashSlideKicking:
		PLBG AAAAAAAAAAAAAAAAAAAAAAAA 1;
		Stop;
	FlashSlideKickingStop:
		PLBG AAAAAAA 1;
		Stop;
	FlashPunching:
		PLBG AAAAAAAAAA 1;
		TNT1 A 0 A_ClearOverlays(PSP_FLASH, PSP_FLASH, false);
		Stop;
	}
}
