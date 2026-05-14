// UAC-M2 Excavator Launcher — ZScript (folded from PBX-Weapons; logic adapted for Project Brutality 2022).
// State flow uses PB2022 conventions: Select -> SelectContinue -> SelectAnimation per
// BaseWeapon.dec, A_DoPBWeaponAction() on Ready, PB_WeapTokenSwitch / PB_RespectIfNeeded
// on bring-up, and FlashPunching / FlashKicking end with `goto Ready3` (PSP_FLASH-based
// flash system, see docs/punch_flash_psp_flash.md). Magazine state is derived on demand
// from ExcavatorRounds (no PBX "mag unloaded / chamber empty / reloading" booleans).
const excMagMax = 5;

class PB_Excavator : PB_WeaponBase
{
	default
	{
		Weapon.SlotNumber 6;
		Weapon.SlotPriority 0.18;
		Weapon.SelectionOrder 506;
		Inventory.AltHudIcon "5DUNA0";
		Weapon.AmmoType1 "RocketAmmo";
		Weapon.AmmoType2 "ExcavatorRounds";
		Weapon.AmmoGive2 5;
		Weapon.AmmoGive1 5;
		Weapon.BobRangeX 0.3;
		Weapon.BobRangeY 0.5;
		Weapon.BobStyle "InverseSmooth";
		Weapon.BobSpeed 2.4;
		Scale 0.50;
		FloatBobStrength 0.5;
		Obituary "%o was torn apart by %k's excavator blasts.";
		Inventory.PickupMessage "$PB_EXC_PICKUP";
		Inventory.PickupSound "misc/ROCKBOXA";
		Tag "$PB_EXC_TAG";
		+WEAPON.NOAUTOAIM
		+WEAPON.EXPLOSIVE
		+WEAPON.NOAUTOFIRE
		+FORCEXYBILLBOARD
		+FLOORCLIP
		+DONTGIB
	}

	int excavatorMode;

	enum excMode
	{
		eDrillChargeMode = 0,
		eDropShotMode = 1
	}

	// PB_GetMagUnloaded is now provided by PB_WeaponBase (staging-parity shim)
	// with (bool dual) signature — local override removed to avoid the signature
	// collision. The Unload state inlines the zero-rounds check directly.

	action void pb_takeAmmoMag(int n = 1)
	{
		A_TakeInventory(invoker.ammotype2, n);
	}

	action State PB_Exc_JumpIfNoRounds(StateLabel st)
	{
		if (CountInv(invoker.ammotype2) < 1) return ResolveState(st);
		return null;
	}

	action State PB_JumpIfNoAmmo(statelabel st, int minRounds, bool _unused = false)
	{
		if (CountInv(invoker.ammotype2) < minRounds) return ResolveState(st);
		return null;
	}

	action State PB_Exc_CheckReload()
	{
		int res = CountInv(invoker.ammotype1);
		int mag = CountInv(invoker.ammotype2);
		if (mag >= excMagMax) return ResolveState("ReadyDrillChargaMode");
		if (res < 2) return ResolveState("ReadyDrillChargaMode");
		if (mag < 1) return ResolveState("RaiseFromEmpty");
		return null;
	}

	action State PB_Exc_SelectMagCheck()
	{
		if (CountInv(invoker.ammotype2) < 1) return ResolveState("NoAmmo");
		return ResolveState("SelectAfterMag");
	}

	action State PB_Exc_ReadyDrillCheck()
	{
		if (CountInv(invoker.ammotype2) < 1) return ResolveState("NoAmmo");
		return null;
	}

	action int getExcavatorMode()
	{
		return invoker.excavatorMode;
	}
	action void setExcavatorMode(int mode = 0)
	{
		invoker.excavatorMode = mode;
	}
	action void cleanmodetokens()
	{
		A_TakeInventory("EX_Select_DrillMode", 1);
		A_TakeInventory("EX_Select_DropMode", 1);
	}

	action void fireExcavator()
	{
		switch (getExcavatorMode())
		{
		case eDrillChargeMode:
			PB_HandleCrosshair(78);
			A_StartSound("excavator/firedigger", 18);
			PB_FireBullets("ExcavatorDrill", 1, 0, 0, 0, 3);
			break;
		case eDropShotMode:
			PB_HandleCrosshair(79);
			A_StartSound("excavator/firedropshot", 0);
			PB_FireBullets("ExcavatorDropShot", 1, 0, 0, 0, 0);
			break;
		}
	}

	action void FireWeapon(int weaponSide, int ticCount)
	{
		switch (ticCount)
		{
		case 1:
		default:
			A_AlertMonsters();
			switch (weaponSide)
			{
			case 0:
			default:
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				A_TakeInventory("PB_LockScreenTilt",1);
				A_FireCustomMissile("ShotgunParticles", random(-16,16), 0, -1, random(-9,9));
				A_FireBullets(0, 0, 1, 50, "shotpuff", 0, 130);
				PB_IncrementHeat(4);
				A_FireCustomMissile("RedFlareSpawn",-5,0,0,0);
				A_ZoomFactor(0.96);
				fireExcavator();
				PB_WeaponRecoil(-3.2,+1.61);
				PB_SpawnCasing("EmptyGrenadeBrass", 30, 0, 34, -frandom(1, 3), -frandom(2, 4), 5);
				pb_takeAmmoMag(1);
				break;
			}
		case 2:
			break;
		}
	}

	override void DoEffect()
	{
		if (!owner || !owner.player) return;
		if (owner.player.ReadyWeapon != self) return;
		if ((owner.player.cmd.buttons & BT_ALTATTACK) && !owner.CountInv("GrenadeDetonator"))
		{
			owner.A_GiveInventory("GrenadeDetonator",1);
			owner.A_StartSound("excavator/detonate", CHAN_AUTO);
		}
		if (!(owner.player.cmd.buttons & BT_ALTATTACK) && owner.CountInv("GrenadeDetonator"))
		{
			owner.A_TakeInventory("GrenadeDetonator", 1);
		}
	}

	override void PostBeginPlay()
	{
		excavatorMode = eDrillChargeMode;
		Super.PostBeginPlay();
	}

	states
	{
		Spawn:
			5DUN A -1;
			Stop;
		Steady:
			TNT1 A 1;
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			TNT1 A 0 SetPlayerProperty(0, 0, 0);
			TNT1 A 0 SetPlayerProperty(0, 0, PROP_TOTALLYFROZEN);
			goto Ready3;
		Deselect:
			5DKF EFGHI 1;
			TNT1 AAA 0 A_Lower;
			Wait;
		WeaponRespect:
			5DKF IHGF 1 A_DoPBWeaponAction();
			5DKF E 15 A_DoPBWeaponAction();
			6DKF A 1 A_PlaySound("Ironsights", 15);
			TNT1 A 0 A_SetRoll(roll-0.6,SPF_INTERPOLATE);
			6DKF BCDEF 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySound("weapons/sgl/cycle", 14);
			TNT1 A 0 A_SetRoll(roll+0.6,SPF_INTERPOLATE);
			6DKF GHIJK 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySound("RLCYCLE2", 13);
			TNT1 A 0 A_SetRoll(0,SPF_INTERPOLATE);
			6DKF KKKKK 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySound("weapons/minigun/respect1", 13);
			TNT1 A 0 A_SetRoll(roll-0.5,SPF_INTERPOLATE);
			6DKF LMNOPQRS 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySound("weapons/nailgun/up", 10);
			TNT1 A 0 A_SetRoll(roll-0.5,SPF_INTERPOLATE);
			6DKF TUVWWWWW 1 A_DoPBWeaponAction();
			TNT1 A 0 A_SetRoll(0,SPF_INTERPOLATE);
			TNT1 A 0 A_PlaySound("Ironsights", 15);
			TNT1 A 0 A_SetRoll(roll+1.0,SPF_INTERPOLATE);
			6DKF XYZ 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySound("weapons/sgl/inspect1", 15);
			7DKF A 1 A_DoPBWeaponAction();
			TNT1 A 0 A_SetRoll(roll-1.0,SPF_INTERPOLATE);
			7DKF BCD 1 A_DoPBWeaponAction();
			TNT1 A 0 A_SetRoll(0,SPF_INTERPOLATE);
			7DKF EFGHIJK 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySound("excavator/detonate");
			5DKF CCDDCCDDCCDCDCD 1 A_DoPBWeaponAction();
			goto Ready3;
		Select:
			TNT1 A 0 A_WeaponOffset(0,32);
			TNT1 A 0 A_StartSound("RLANDRAW", 7);
			Goto SelectFirstPersonLegs;
		SelectContinue:
			TNT1 A 0 PB_WeapTokenSwitch("ExcavatorSelected");
			TNT1 A 0 PB_RespectIfNeeded();
		SelectAnimation:
			TNT1 A 0 PB_Exc_SelectMagCheck();
		SelectAfterMag:
			5DKF IHGFE 1;
		Ready:
		Ready3:
		ReadyDrillChargaMode:
			TNT1 A 0 PB_HandleCrosshair(78);
			TNT1 A 0 PB_Exc_ReadyDrillCheck();
			TNT1 A 0 A_Jumpif(getExcavatorMode() == eDropShotMode, "ReadyDropShotMode");
			5DKF A 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
			Loop;
		ReadyDropShotMode:
			TNT1 A 0 PB_HandleCrosshair(79);
			TNT1 A 0 A_Jumpif(getExcavatorMode() == eDrillChargeMode, "ReadyDrillChargaMode");
			5DKF B 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
			Loop;

		Fire:
			TNT1 A 0 { A_WeaponOffset(0,32); A_SetRoll(0); A_SetInventory("PB_LockScreenTilt",0); }
			TNT1 A 0 {
				if (CountInv("GoFatality") >= 1) SetPlayerProperty(0, 1, 0);
				else
				{
					SetPlayerProperty(0, 0, 0);
					SetPlayerProperty(0, 0, PROP_TOTALLYFROZEN);
				}
			}
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			TNT1 A 0 PB_CheckBarrelThrow1();
			TNT1 A 0 {
				let po = invoker.Owner;
				if (po == null || !(po is "PlayerPawn"))
					return resolveState(null);
				let pp = PlayerPawn(po);
				if (pp && pp.player && invoker.CountInv("NoFatality") == 0
					&& CVar.GetCVar("pb_auto_fatality_fire", pp.player).GetBool())
					return PB_Execute();
				return resolveState(null);
			}
			TNT1 A 0 PB_Exc_JumpIfNoRounds("Reload");
			6DKF A 1 BRIGHT FireWeapon(0,1);
			6DKF A 1 BRIGHT FireWeapon(0,2);
			5DKF L 1 BRIGHT A_ZoomFactor(0.97);
			5DKF M 1 BRIGHT A_ZoomFactor(0.98);
			5DKF N 1 BRIGHT A_ZoomFactor(0.99);
			TNT1 A 0 A_ZoomFactor(1.0);
			5DKF OPQRDDD 1 A_WeaponReady(WRF_NOPRIMARY);
			TNT1 A 0 A_PlaySound("RLCYCLE2", 5);
			5DKF DDDD 1 A_WeaponReady(WRF_NOPRIMARY);
			5DKF D 0 A_ReFire;
			goto ReadyDrillChargaMode;

		Reload:
			TNT1 A 0 PB_Exc_CheckReload();
			6DKF A 1 A_PlaySound("Ironsights", 15);
			TNT1 A 0 A_SetRoll(roll-0.6,SPF_INTERPOLATE);
			6DKF BCDEF 1;
			TNT1 A 0 A_PlaySound("weapons/sgl/cycle", 14);
			TNT1 A 0 PB_SpawnCasing("SGL_Drum",25,0,20,Frandom(3,4),Frandom(3,4),1);
			TNT1 A 0 A_SetRoll(roll+0.6,SPF_INTERPOLATE);
			6DKF GHIJK 1;
			TNT1 A 0 A_PlaySound("RLCYCLE2", 13);
			TNT1 A 0 A_SetRoll(0,SPF_INTERPOLATE);
			6DKF KKKKK 1;
			TNT1 A 0 A_PlaySound("weapons/minigun/respect1", 13);
			TNT1 A 0 A_SetRoll(roll-0.5,SPF_INTERPOLATE);
		ContinueReload:
			6DKF LMNOPQRS 1;
			TNT1 A 0 A_PlaySound("weapons/nailgun/up", 10);
			TNT1 A 0 A_SetRoll(roll-0.5,SPF_INTERPOLATE);
			6DKF TUVWWWWW 1;
			TNT1 A 0 A_SetRoll(0,SPF_INTERPOLATE);
			TNT1 A 0 A_PlaySound("Ironsights", 15);
			TNT1 A 0 A_SetRoll(roll+1.0,SPF_INTERPOLATE);
			6DKF XYZ 1;
			TNT1 A 0 A_PlaySound("weapons/sgl/inspect1", 15);
			7DKF A 1;
			TNT1 A 0 PB_AmmoIntoMag("ExcavatorRounds", "RocketAmmo", excMagMax, 2);
			TNT1 A 0 A_SetRoll(roll-1.0,SPF_INTERPOLATE);
			7DKF BCD 1;
			TNT1 A 0 A_SetRoll(0,SPF_INTERPOLATE);
			7DKF EFGHIJK 1;
			TNT1 A 0 A_PlaySound("excavator/detonate");
			5DKF CCDDCCDDCCDCDCD 1;
			goto ReadyDrillChargaMode;
		RaiseFromEmpty:
			8DKF DCBA 1;
			goto ContinueReload;

		Unload:
			TNT1 A 0 A_JumpIf(CountInv(invoker.ammotype2) < 1, "NoAmmo");
			6DKF A 1 A_PlaySound("Ironsights", 15);
			TNT1 A 0 A_SetRoll(roll-0.6,SPF_INTERPOLATE);
			6DKF BCDEF 1;
			TNT1 A 0 A_PlaySound("weapons/sgl/cycle", 14);
			TNT1 A 0 A_SetRoll(roll+0.6,SPF_INTERPOLATE);
			6DKF GHI 1;
			6DKF J 1;
			TNT1 A 0 { PB_UnloadMag("ExcavatorRounds", "RocketAmmo", 2, 0, 4, 12, "PB_RocketRoundUnloadProp"); }
			6DKF K 1;
			8DKF ABCD 1;
			goto NoAmmo;

		NoAmmo:
			5DKF S 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
			Loop;

		PDA_Preview_EXC_Fire:
			6DKF A 1 BRIGHT;
			6DKF A 1 BRIGHT;
			5DKF L 1 BRIGHT;
			5DKF M 1 BRIGHT;
			5DKF N 1 BRIGHT;
			5DKF OPQRDDD 1;
			Stop;
		PDA_Preview_EXC_Reload:
			6DKF LMN 1;
			7DKF A 1;
			7DKF BCD 1;
			Stop;
		PDA_Preview_EXC_ModeSwitch:
			7DKF LMNOP 1;
			7DKF PONML 1;
			Stop;

		Weaponspecial:
			TNT1 A 0 {
				A_TakeInventory("GoWeaponSpecialAbility",1);
				A_TakeInventory("Zoomed",1);
				A_TakeInventory("ADSmode",1);
				A_ZoomFactor(1.0);
			}
			TNT1 A 0 {
				if ((CountInv("EX_Select_DropMode") && getExcavatorMode() == eDropShotMode) ||
					(CountInv("EX_Select_DrillMode") && getExcavatorMode() == eDrillChargeMode))
				{
					A_Print("$PB_EXC_ALREADY");
					cleanmodetokens();
					return resolveState("Ready3");
				}
				if (CountInv("EX_Select_DropMode"))
				{
					setExcavatorMode(eDropShotMode);
					A_TakeInventory("EX_Select_DropMode",1);
					A_Print("$PB_EXC_MODE_DROP");
				}
				if (CountInv("EX_Select_DrillMode"))
				{
					setExcavatorMode(eDrillChargeMode);
					A_TakeInventory("EX_Select_DrillMode",1);
					A_Print("$PB_EXC_MODE_DRILL");
				}
				return resolveState(null);
			}
			TNT1 A 0
			{
				if (getExcavatorMode() == eDropShotMode) return resolveState("SwitchToDrill");
				return resolveState("SwitchToDrop");
			}
		SwitchToDrop:
			7DKF LMNOP 1;
			TNT1 A 0 A_PlaySound("excavator/switch");
			7DKF PONML 1;
			goto ReadyDropShotMode;
		SwitchToDrill:
			7DKF LMNOP 1;
			TNT1 A 0 A_PlaySound("excavator/switch");
			7DKF PONML 1;
			goto ReadyDrillChargaMode;

		FlashPunching:
			7DKF L 1;
			7DKF MNOP 1;
			7DKF P 4;
			7DKF PONML 1;
			TNT1 A 0 A_ClearOverlays(PSP_FLASH, PSP_FLASH, false);
			Goto Ready3;
		FlashKicking:
			5DKF E 1;
			5DKF FGHI 1;
			TNT1 A 4;
			5DKF IHGFE 1;
			goto ReadyDrillChargaMode;
		FlashAirKicking:
			5DKF E 1;
			5DKF FGHI 1;
			TNT1 A 8;
			5DKF IHGFE 1;
			goto ReadyDrillChargaMode;
		FlashSlideKicking:
			5DKF E 1;
			5DKF EFGHI 1;
			TNT1 A 16;
			goto ReadyDrillChargaMode;
		FlashSlideKickingStop:
			5DKF I 1;
			5DKF IIHGFE 1;
			goto ReadyDrillChargaMode;
	}
}
