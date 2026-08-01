// PB_SPAS12 — Brutal Doom Plus SPAS-12 fold.
// Weapon Special: Combat Pump (default) / Riot Sweep (wide-spread buckshot).
// AltFire: ADS zoom on both modes.

class PB_SPAS12 : PB_WeaponBase
{
	Default
	{
		Weapon.BobRangeX 0.3;
		Weapon.BobRangeY 0.5;
		Weapon.BobStyle "InverseSmooth";
		Weapon.BobSpeed 2.4;
		Weapon.SelectionOrder 1250;
		Weapon.AmmoUse1 0;
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive1 8;
		Weapon.AmmoGive2 0;
		Weapon.AmmoType1 "NewShell";
		Weapon.AmmoType2 "PB_SPAS12Mag";
		+FLOORCLIP;
		+DONTGIB;
		Scale 0.5;
		Inventory.PickupMessage "$PB_PICKUP_PB_SPAS12";
		Inventory.PickupSound "weapons/spas12/raise";
		Inventory.Icon "M4SHA0";
		Inventory.AltHUDIcon "M4SHA0";
		Inventory.Amount 1;
		Inventory.MaxAmount 1;
		Obituary "$OB_PB_SPAS12";
		Weapon.SlotNumber 3;
		Weapon.SlotPriority 2.4;
		Tag "SPAS-12";
		+WEAPON.NOAUTOAIM;
		+WEAPON.NOAUTOFIRE;
		+WEAPON.NOALERT;
		PB_WeaponBase.RespectItem "RespectSPAS12";
	}

	override void AttachToOwner(Actor other)
	{
		Super.AttachToOwner(other);
		if (other)
		{
			other.A_GiveInventory("PB_SPAS12Mag", 9);
			other.A_GiveInventory("ShotgunSelected", 1);
			other.A_TakeInventory("SSGSelected", 1);
		}
	}

	States
	{
	Spawn:
		M4SH A -1;
		Stop;

	Steady:
		TNT1 A 1;
		Goto Ready;

	Ready:
		TNT1 A 0 A_JumpIfInventory("RespectSPAS12", 1, "SelectAnimation");
	WeaponRespect:
		TNT1 A 0
		{
			A_GiveInventory("RespectSPAS12", 1);
			PB_HandleCrosshair(5);
			A_GiveInventory("PB_LockScreenTilt", 1);
			A_PlaySound("weapons/spas12/raise", CHAN_AUTO);
		}
		S12S EDCBA 1;
		TNT1 A 0 A_TakeInventory("PB_LockScreenTilt", 1);
		Goto Ready3;

	Select:
		TNT1 A 0
		{
			A_WeaponOffset(0, 32);
			A_SetRoll(0);
			A_TakeInventory("PB_LockScreenTilt", 1);
			A_TakeInventory("HasBarrel", 1);
			A_TakeInventory("HasIceBarrel", 1);
			A_TakeInventory("HasBurningBarrel", 1);
			A_TakeInventory("GrabbedBarrel", 1);
			A_TakeInventory("GrabbedIceBarrel", 1);
			A_TakeInventory("GrabbedBurningBarrel", 1);
			A_TakeInventory("Zoomed", 1);
			A_TakeInventory("ADSmode", 1);
			A_ZoomFactor(1.0);
			A_GiveInventory("ShotgunSelected", 1);
			A_TakeInventory("SSGSelected", 1);
		}
		Goto SelectFirstPersonLegs;

	SelectContinue:
		TNT1 A 0 A_Raise;
		Goto Ready3;

	SelectAnimation:
		TNT1 A 0 A_PlaySound("weapons/spas12/raise", CHAN_AUTO);
		S12S EDCBA 1;
		Goto Ready3;

	Deselect:
		TNT1 A 0
		{
			A_WeaponOffset(0, 32);
			A_SetRoll(0);
			A_TakeInventory("PB_LockScreenTilt", 1);
			A_TakeInventory("Zoomed", 1);
			A_TakeInventory("ADSmode", 1);
			A_ZoomFactor(1.0);
		}
		S12S ABCDE 1;
		TNT1 AAAAAAAAAAAAAAAAAA 0 A_Lower;
		TNT1 A 1 A_Lower;
		Wait;

	Ready3:
		TNT1 A 0
		{
			A_ClearOverlays(10, 11);
			A_SetRoll(0);
			A_TakeInventory("PB_LockScreenTilt", 1);
			if (CountInv("Zoomed") >= 1)
			{
				A_ZoomFactor(1.5);
				PB_HandleCrosshair(5);
				return ResolveState("ReadyADS");
			}
			A_ZoomFactor(1.0);
			PB_HandleCrosshair(5);
			return ResolveState(null);
		}
	ReadyToFire:
		TNT1 A 0 A_JumpIfInventory("PB_SPAS12Mag", 1, "ReadyToFireArmed");
		Goto ReadyEmpty;
	ReadyToFireArmed:
		S12G A 1
		{
			return A_DoPBWeaponAction(WRF_ALLOWRELOAD);
		}
		Loop;

	ReadyEmpty:
		S12G A 1
		{
			// Mag empty: allow reload / equipment, but not Fire (AmmoUse is 0 so
			// A_WeaponReady would otherwise re-enter Fire→Reload→Ready forever).
			return A_DoPBWeaponAction(WRF_ALLOWRELOAD | WRF_NOFIRE);
		}
		Loop;

	ReadyADS:
		TNT1 A 0 A_JumpIfInventory("PB_SPAS12Mag", 1, "ReadyADSArmed");
		Goto ReadyADSEmpty;
	ReadyADSArmed:
		S12Z A 1
		{
			return A_DoPBWeaponAction(WRF_ALLOWRELOAD);
		}
		Loop;

	ReadyADSEmpty:
		S12Z A 1
		{
			return A_DoPBWeaponAction(WRF_ALLOWRELOAD | WRF_NOFIRE);
		}
		Loop;

	WeaponSpecial:
		TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "IdleBarrel");
		TNT1 A 0 A_JumpIfInventory("GrabbedBurningBarrel", 1, "IdleFlameBarrel");
		TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "IdleIceBarrel");
		TNT1 A 0
		{
			A_TakeInventory("GoWeaponSpecialAbility", 1);
			A_GiveInventory("PB_LockScreenTilt", 1);
			PB_HandleCrosshair(5);
			A_ClearOverlays(10, 11);
			A_TakeInventory("Zoomed", 1);
			A_TakeInventory("ADSmode", 1);
			A_ZoomFactor(1.0);
		}
		TNT1 A 0 A_JumpIfInventory("Select_SPAS12_Pump", 1, "SPAS_SetPump");
		TNT1 A 0 A_JumpIfInventory("Select_SPAS12_Riot", 1, "SPAS_SetRiot");
		Goto Ready3;

	SPAS_SetPump:
		TNT1 A 0
		{
			A_TakeInventory("Select_SPAS12_Pump", 1);
			A_TakeInventory("Select_SPAS12_Riot", 1);
			A_TakeInventory("SPAS12_RiotMode", 1);
			A_Print("$PB_SPAS12_MODE_PUMP");
			A_TakeInventory("PB_LockScreenTilt", 1);
		}
		Goto Ready3;

	SPAS_SetRiot:
		TNT1 A 0
		{
			A_TakeInventory("Select_SPAS12_Pump", 1);
			A_TakeInventory("Select_SPAS12_Riot", 1);
			A_GiveInventory("SPAS12_RiotMode", 1);
			A_Print("$PB_SPAS12_MODE_RIOT");
			A_TakeInventory("PB_LockScreenTilt", 1);
		}
		Goto Ready3;

	AltFire:
		TNT1 A 0 A_JumpIfInventory("Zoomed", 1, "UnZoom");
		TNT1 A 0
		{
			A_GiveInventory("Zoomed", 1);
			A_GiveInventory("ADSmode", 1);
			A_ZoomFactor(1.5);
		}
		S12X ABCDEF 1;
		Goto ReadyADS;

	UnZoom:
		TNT1 A 0
		{
			A_TakeInventory("Zoomed", 1);
			A_TakeInventory("ADSmode", 1);
			A_ZoomFactor(1.0);
		}
		S12X FEDCBA 1;
		Goto Ready3;

	Fire:
		TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "ThrowBarrel");
		TNT1 A 0 A_JumpIfInventory("GrabbedBurningBarrel", 1, "ThrowFlameBarrel");
		TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "ThrowIceBarrel");
		TNT1 A 0
		{
			A_WeaponOffset(0, 32);
			A_SetRoll(0);
			A_TakeInventory("PB_LockScreenTilt", 1);
			if (CountInv("GoFatality") >= 1) { SetPlayerProperty(0, 1, 0); }
			else { SetPlayerProperty(0, 0, 0); SetPlayerProperty(0, 0, PROP_TOTALLYFROZEN); }
		}
		TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
		TNT1 A 0 A_JumpIfInventory("PB_SPAS12Mag", 1, "FireArmed");
		TNT1 A 0 A_JumpIfInventory("NewShell", 1, "Reload");
		Goto NoAmmo;
	FireArmed:
		TNT1 A 0 A_JumpIfInventory("Zoomed", 1, "FireADS");
		TNT1 A 0 A_JumpIfInventory("SPAS12_RiotMode", 1, "FireRiotHip");
		Goto FirePumpHip;

	FirePumpHip:
		TNT1 A 0 A_PlaySound("weapons/spas12/fire", CHAN_WEAPON);
		S12G B 1 Bright
		{
			A_FireBullets(4.0, 4.0, 10, 12, "ShotgunPuff");
			A_FireCustomMissile("YellowFlareSpawn", 0, 0, 0, 0);
			A_SpawnItemEx("PlayerMuzzle1", 30, 5, 30);
			A_GunFlash();
			A_TakeInventory("PB_SPAS12Mag", 1);
			A_AlertMonsters();
			A_Recoil(3);
			A_SetPitch(pitch - 4.0);
		}
		S12G C 1 { Radius_Quake(3, 3, 0, 1, 0); A_SetPitch(pitch + 1.0); A_ZoomFactor(0.94); }
		S12G D 1 { A_SetPitch(pitch + 1.0); A_ZoomFactor(0.96); }
		S12G E 1 { A_SetPitch(pitch + 2.0); A_ZoomFactor(1.0); }
		Goto PumpingHip;

	FireRiotHip:
		TNT1 A 0 A_PlaySound("weapons/spas12/fire", CHAN_WEAPON);
		S12G B 1 Bright
		{
			A_FireBullets(10.0, 10.0, 16, 10, "ShotgunPuff");
			A_FireCustomMissile("YellowFlareSpawn", 0, 0, 0, 0);
			A_SpawnItemEx("PlayerMuzzle1", 30, 5, 30);
			A_GunFlash();
			A_TakeInventory("PB_SPAS12Mag", 1);
			A_AlertMonsters();
			A_Recoil(4);
			A_SetPitch(pitch - 5.0);
			Radius_Quake(5, 4, 0, 1, 0);
		}
		S12G C 1 { A_SetPitch(pitch + 1.0); A_ZoomFactor(0.92); }
		S12G D 1 { A_SetPitch(pitch + 1.0); A_ZoomFactor(0.94); }
		S12G E 2 { A_SetPitch(pitch + 2.0); A_ZoomFactor(1.0); }
		Goto PumpingHipSlow;

	FireADS:
		TNT1 A 0 A_JumpIfInventory("SPAS12_RiotMode", 1, "FireRiotADS");
		TNT1 A 0 A_PlaySound("weapons/spas12/fire", CHAN_WEAPON);
		S12Z B 1 Bright
		{
			A_FireBullets(2.0, 2.0, 10, 12, "ShotgunPuff");
			A_FireCustomMissile("YellowFlareSpawn", 0, 0, 0, 0);
			A_SpawnItemEx("PlayerMuzzle1", 30, 5, 30);
			A_GunFlash();
			A_TakeInventory("PB_SPAS12Mag", 1);
			A_AlertMonsters();
			A_Recoil(2);
			A_SetPitch(pitch - 2.0);
		}
		S12Z CDEF 1;
		Goto PumpingADS;

	FireRiotADS:
		TNT1 A 0 A_PlaySound("weapons/spas12/fire", CHAN_WEAPON);
		S12Z B 1 Bright
		{
			A_FireBullets(7.0, 7.0, 16, 10, "ShotgunPuff");
			A_FireCustomMissile("YellowFlareSpawn", 0, 0, 0, 0);
			A_SpawnItemEx("PlayerMuzzle1", 30, 5, 30);
			A_GunFlash();
			A_TakeInventory("PB_SPAS12Mag", 1);
			A_AlertMonsters();
			A_Recoil(3);
			A_SetPitch(pitch - 3.0);
			Radius_Quake(4, 4, 0, 1, 0);
		}
		S12Z CDEF 1;
		S12Z F 1;
		Goto PumpingADSSlow;

	PumpingHip:
		S12P ABCDEFGH 1;
		S12P IJKLM 1;
		S12P N 1 A_ZoomFactor(0.98);
		S12P O 1
		{
			A_PlaySound("weapons/spas12/pump", CHAN_AUTO);
			A_FireCustomMissile("ShotCaseSpawn", 0, 0, -4, -4);
			A_ZoomFactor(1.0);
		}
		S12P NMLKJI 1;
		S12P HGFEDCBA 1;
		Goto Ready3;

	PumpingHipSlow:
		S12P ABCDEFGH 1;
		S12P IJKLM 2;
		S12P N 2 A_ZoomFactor(0.98);
		S12P O 2
		{
			A_PlaySound("weapons/spas12/pump", CHAN_AUTO);
			A_FireCustomMissile("ShotCaseSpawn", 0, 0, -4, -4);
			A_ZoomFactor(1.0);
		}
		S12P NMLKJI 1;
		S12P HGFEDCBA 2;
		Goto Ready3;

	PumpingADS:
		S1PZ ABCDEF 1;
		S1PZ G 2;
		S1PZ H 3
		{
			A_PlaySound("weapons/spas12/pump", CHAN_AUTO);
			A_FireCustomMissile("ShotCaseSpawn", 0, 0, -4, -4);
			A_ZoomFactor(1.48);
		}
		S1PZ H 2;
		S1PZ GFEDCBA 1;
		TNT1 A 0 A_ZoomFactor(1.5);
		Goto ReadyADS;

	PumpingADSSlow:
		S1PZ ABCDEF 2;
		S1PZ G 3;
		S1PZ H 4
		{
			A_PlaySound("weapons/spas12/pump", CHAN_AUTO);
			A_FireCustomMissile("ShotCaseSpawn", 0, 0, -4, -4);
			A_ZoomFactor(1.48);
		}
		S1PZ H 2;
		S1PZ GFEDCBA 2;
		TNT1 A 0 A_ZoomFactor(1.5);
		Goto ReadyADS;

	NoAmmo:
		TNT1 A 0
		{
			A_TakeInventory("Reloading", 1);
			A_PlaySound("weapons/empty", CHAN_AUTO);
		}
		S12G A 8 A_WeaponReady(WRF_NOFIRE | WRF_NOSWITCH);
		Goto Ready3;

	Reload:
		TNT1 A 0
		{
			A_TakeInventory("Zoomed", 1);
			A_TakeInventory("ADSmode", 1);
			A_ZoomFactor(1.0);
		}
		TNT1 A 0 A_JumpIfInventory("PB_SPAS12Mag", 9, "Ready3");
		TNT1 A 0 A_JumpIfInventory("NewShell", 1, "ReloadStart");
		Goto NoAmmo;
	ReloadStart:
		S12P ABCDEFGH 1;
		S12R AB 1;
	ReloadLoop:
		TNT1 A 0 A_JumpIfInventory("PB_SPAS12Mag", 9, "FinishReload");
		TNT1 A 0 A_JumpIfInventory("NewShell", 1, 2);
		Goto FinishReload;
		TNT1 AA 0;
		S12R CDE 2
		{
			A_PlaySound("weapons/spas12/insert", CHAN_AUTO);
			return A_DoPBWeaponAction(WRF_NOFIRE | WRF_NOBOB);
		}
		S12R FGH 1;
		S12R A 1
		{
			A_GiveInventory("PB_SPAS12Mag", 1);
			A_TakeInventory("NewShell", 1);
		}
		Goto ReloadLoop;

	FinishReload:
		S12P HIJKLM 1;
		S12P N 1;
		S12P O 2 A_PlaySound("weapons/spas12/pump", CHAN_AUTO);
		S12P NMLKJI 1;
		S12P HGFEDCBA 1;
		Goto Ready3;

	FlashPunching:
	FlashKicking:
	FlashAirKicking:
	FlashSlideKicking:
	FlashSlideKickingStop:
		S12P ABCDEFGHGFEDCBA 1;
		Goto Ready3;

	PDA_Preview_Fire:
		S12G BCDE 2;
		Stop;
	PDA_Preview_AltFire:
		S12X ABCDEF 2;
		Stop;
	PDA_Preview_Reload:
		S12R ABCDEFGH 2;
		Stop;
	}
}
