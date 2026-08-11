// Shared PBWP integration helpers for Cyberaugumented weapon fold.
// PBWP cannot extend PB_WeaponBase in this TU (UZDoom 4.14) — use a shared subclass.

class PBWP_CA_WeaponBase : PB_WeaponBase
{
	action void PBWP_CA_ReadyTick(int crosshair = 0)
	{
		PB_HandleCrosshair(crosshair);
		A_TakeInventory("PB_LockScreenTilt", 1);
		A_ClearOverlays(10, 11);
	}

	action void PBWP_CA_ReadyPose(int crosshair = 0)
	{
		A_WeaponOffset(0, 32);
		A_OverlayScale(PSP_WEAPON, 1.0, 1.0);
		PBWP_CA_ReadyTick(crosshair);
	}

	action void PBWP_CA_SelectPose()
	{
		A_WeaponOffset(2, 34, WOF_INTERPOLATE);
		A_OverlayScale(PSP_WEAPON, 1.0, 1.0);
		A_SetRoll(0);
	}

	action void PBWP_CA_LockTilt()
	{
		A_GiveInventory("PB_LockScreenTilt", 1);
	}

	action void PBWP_CA_UnlockTilt()
	{
		A_TakeInventory("PB_LockScreenTilt", 1);
	}

	action state PBWP_CA_FatalityGate()
	{
		if (CountInv("GoFatality") >= 1)
		{
			SetPlayerProperty(0, 1, 0);
			return ResolveState("PB_FinisherCleanup");
		}
		SetPlayerProperty(0, 0, 0);
		SetPlayerProperty(0, 0, PROP_TOTALLYFROZEN);
		return ResolveState(null);
	}

	action void PBWP_CA_DeselectCleanup()
	{
		A_WeaponOffset(0, 32);
		A_OverlayScale(PSP_WEAPON, 1.0, 1.0);
		A_SetRoll(0);
		A_TakeInventory("PB_LockScreenTilt", 1);
		A_TakeInventory("Unloading", 1);
		A_TakeInventory("Reloading", 1);
		A_TakeInventory("Zoomed", 1);
		A_ZoomFactor(1.0);
	}

	action void PBWP_CA_ReloadPreamble()
	{
		PBWP_OffsetReloadSetReturn('Ready3');
		A_WeaponOffset(0, 32);
		A_SetRoll(0);
		A_TakeInventory("PB_LockScreenTilt", 1);
		A_TakeInventory("Reloading", 1);
		A_TakeInventory("Zoomed", 1);
		A_ZoomFactor(1.0);
	}

	action void PBWP_CA_DeferredRailHit(int damage, Name dmgType = 'Hitscan')
	{
		let ply = player;
		if (!ply || !ply.mo)
			return;

		let mo = ply.mo;
		FLineTraceData lt;
		double aimz = ply.viewheight;
		mo.LineTrace(mo.angle, 8192, mo.pitch, 0, aimz, data: lt);
		if (PBWP_CombatDamageHandler.IsCombatTarget(lt.hitActor, mo))
			PBWP_CombatDamageHandler.Schedule(lt.hitActor, mo, mo, damage, dmgType);
	}

	// Visual rail + deferred damage (damage 0 on A_RailAttack avoids double-hit with CombatDamageHandler).
	action void PBWP_CA_FireAurumRail(int damage, int sparsity = 64)
	{
		A_RailAttack(0, 0, 0, "", "", RGF_SILENT | RGF_FULLBRIGHT,
			pufftype: "PBWP_CA_AurumPuff", sparsity: sparsity, spawnclass: "PBWP_CA_AurumRailTrail");
		PBWP_CA_DeferredRailHit(damage, 'BFG');
	}

	action void PBWP_CA_FireBfgGreenRail(int damage, int sparsity = 64)
	{
		A_RailAttack(0, 0, 0, "", "", RGF_SILENT | RGF_FULLBRIGHT,
			pufftype: "PBWP_CA_BfgGreenPuff", sparsity: sparsity, spawnclass: "PBWP_CA_BfgGreenRailTrail");
		PBWP_CA_DeferredRailHit(damage, 'BFG');
	}

	// Upstream Nightfall laser mode fires DCY_MechaZombiePlasma2 bolts — visual bolt + deferred hit.
	action void PBWP_CA_FireMinigunLaserBolt(int damage)
	{
		A_FireCustomMissile("PBWP_CA_MinigunLaserBolt", frandom(-1.2, 1.2), 0);
		PBWP_CA_DeferredRailHit(damage, 'Plasma');
	}

	// PB2022 QuickMelee / kick overlays (PSP_FLASH + PSP_WEAPON). Upstream PBWP
	// stubs used empty TNT1 + A_DoPBWeaponAction loops and Flash -> Goto LightDone
	// (missing label). Shared here so every Cyberaugumented gun inherits once.
	states
	{
		Flash:
			TNT1 A 1;
			Stop;

		FlashPunching:
			TNT1 A 0 A_ClearOverlays(10, 11);
			MC3S ABCDEFGGFEDCBA 1;
			TNT1 A 0 A_ClearOverlays(PSP_FLASH, PSP_FLASH, false);
			Stop;

		// Visual-only kick holds (no A_DoPBWeaponAction / Ready* on PSP_FLASH).
		FlashKicking:
			TNT1 A 0 A_ClearOverlays(10, 11);
			"####" AAAAAAAAAAAAAAA 1;
			Stop;

		FlashAirKicking:
			TNT1 A 0 A_ClearOverlays(10, 11);
			"####" AAAAAAAAAAAAAAAA 1;
			Stop;

		FlashSlideKicking:
			TNT1 A 0 A_ClearOverlays(10, 11);
			"####" AAAAAAAAAAAAAAAAAAAAAAAA 1;
			Stop;

		FlashSlideKickingStop:
			TNT1 A 0 A_ClearOverlays(10, 11);
			"####" AAAAAAA 1;
			Stop;

		PBWP_CA_ReloadLower:
			"####" "#" 0 PBWP_OffsetReloadBegin();
			"####" "#" 2
			{
				PBWP_OffsetReloadStep(0);
				A_DoPBWeaponAction(WRF_NOFIRE | WRF_NOBOB | WRF_NOSECONDARY | WRF_NOSWITCH);
			}
			"####" "#" 2
			{
				PBWP_OffsetReloadStep(1);
				A_DoPBWeaponAction(WRF_NOFIRE | WRF_NOBOB | WRF_NOSECONDARY | WRF_NOSWITCH);
			}
			"####" "#" 2
			{
				PBWP_OffsetReloadStep(2);
				A_DoPBWeaponAction(WRF_NOFIRE | WRF_NOBOB | WRF_NOSECONDARY | WRF_NOSWITCH);
			}
			"####" "#" 2
			{
				PBWP_OffsetReloadStep(3);
				A_DoPBWeaponAction(WRF_NOFIRE | WRF_NOBOB | WRF_NOSECONDARY | WRF_NOSWITCH);
			}
			"####" "#" 0 { return ResolveState("DoReload"); }
			Stop;

		PBWP_CA_ReloadRaise:
			"####" "#" 2
			{
				PBWP_OffsetReloadStep(4);
				A_DoPBWeaponAction(WRF_NOFIRE | WRF_NOBOB | WRF_NOSECONDARY | WRF_NOSWITCH);
			}
			"####" "#" 2
			{
				PBWP_OffsetReloadStep(5);
				A_DoPBWeaponAction(WRF_NOFIRE | WRF_NOBOB | WRF_NOSECONDARY | WRF_NOSWITCH);
			}
			"####" "#" 2
			{
				PBWP_OffsetReloadStep(6);
				A_DoPBWeaponAction(WRF_NOFIRE | WRF_NOBOB | WRF_NOSECONDARY | WRF_NOSWITCH);
			}
			"####" "#" 0 { return PBWP_OffsetReloadFinish(); }
			Stop;

		// Empty click — keep current PSP sprite (####), brief dip, allow reload.
		DryFire:
			"####" "#" 2
			{
				A_StartSound("weapons/empty", CHAN_WEAPON);
				A_WeaponOffset(0, 34, WOF_INTERPOLATE);
				A_DoPBWeaponAction(WRF_ALLOWRELOAD | WRF_NOFIRE | WRF_NOSWITCH);
			}
			"####" "#" 6 A_DoPBWeaponAction(WRF_ALLOWRELOAD | WRF_NOFIRE | WRF_NOSWITCH);
			Goto Ready3;
	}
}
