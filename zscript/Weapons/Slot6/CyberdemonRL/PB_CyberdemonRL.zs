// Cyberdemon Missile Launcher — ZScript (folded from PBX-Weapons Slot-6/CyberdemonRL).
// Pickup source: dead Cyberdemons — the DECORATE XDeathCyberdemonGun hand-gib is
// replaced with a PB_CyberdemonRL weapon drop (with cvar gate) rather than via a
// separate PBX-style EventHandler. See actors/Gore/GORE!!!.dec for the replacement.
//
// PB2022 parity notes vs PBX:
//   * Uses PB_RocketAmmo (compat alias for RocketAmmo, see actors/Items/Compat/WarningStubs.dec)
//     so the weapon consumes the existing rocket pool.
//   * PB_Math.LinearMap -> PB_HitFeedback_Math.LinearMap (equivalent utility in PB2022).
//   * PBX's PB_CoolDownBarrel / DisablePBX_Smoke cooldown hook doesn't exist in PB2022,
//     so it isn't called — PB2022 has no barrel-heat cooldown effect on this gun.
//   * PBX's PB_LowAmmoSoundWarning helper is dropped (PB2022 doesn't ship it and the
//     warning isn't essential for the fold).
//   * Duplicate pickup: PBX only refilled wear in AttachToOwner; the engine merges a
//     second copy via Weapon.HandlePickup (PickupForAmmo) without AttachToOwner — PB2022
//     overrides HandlePickup to refill CyberRLDurability (same idea as PB_WeaponBase
//     PB_RefillMonsterSourcedWeaponWear for DECORATE boss-tech guns).
//     is inlined here (ZScript weapons don't auto-inherit the DECORATE chain) so legs /
//     kick / melee / equipment overlays come up correctly.
//   * FlashPunching / FlashKicking end with "goto Ready3" per the PSP_FLASH-based
//     flash system documented in docs/punch_flash_psp_flash.md.

class PB_CyberdemonRL : PB_WeaponBase
{
	default
	{
		//$Title Cyberdemon Missile Launcher
		//$Category Weapons
		//$Sprite CYBFA0
		Weapon.SlotNumber 6;
		Weapon.SlotPriority 0.22;
		Weapon.SelectionOrder 3800;
		Inventory.AltHudIcon "HND7E0";

		Weapon.AmmoType1 "PB_RocketAmmo";
		Weapon.AmmoGive1 30;

		Obituary "%o was blown up by %k's Cyberdemon missile launcher. Ouch!";
		Inventory.PickupMessage "$PB_PICKUP_PB_CyberdemonRL";
		Inventory.PickupSound "BFGREADY";
		Tag "$PB_TAG_PB_CyberdemonRL";

		+WEAPON.NOAUTOAIM
		+WEAPON.EXPLOSIVE
		+WEAPON.NOAUTOFIRE
		+FORCEXYBILLBOARD
		+FLOORCLIP
		+DONTGIB
	}

	void CyberRL_RefillWear(PlayerPawn p)
	{
		if (!p || !p.player)
			return;
		let inv = p.FindInventory("CyberRLDurability");
		if (!inv || inv.Amount < 25)
			p.GiveInventory("CyberRLDurability", 25);
	}

	override void AttachToOwner(Actor other)
	{
		let p = PlayerPawn(other);
		CyberRL_RefillWear(p);
		Super.AttachToOwner(other);
	}

	override bool HandlePickup(Inventory item)
	{
		let p = PlayerPawn(owner);
		if (p && p.player && item && item.GetClass() == GetClass())
			CyberRL_RefillWear(p);
		return Super.HandlePickup(item);
	}

	action void CyberRL_FireWeapon(int weaponSide, int ticCount)
	{
		switch (ticCount)
		{
			default:
			case 1:
				A_AlertMonsters();
				switch (weaponSide)
				{
					default:
					case 0:
						A_StartSound("DSCANFIR", CHAN_WEAPON, CHANF_OVERLAP, 1.0, pitch: 0.6);
						A_ZoomFactor(0.98, SPF_INTERPOLATE);
						A_TakeInventory(invoker.AmmoType1, 2, TIF_NOTAKEINFINITE);
						A_TakeInventory("CyberRLDurability", 1, TIF_NOTAKEINFINITE);
						A_FireProjectile(
							"CyberBallsPlayer",
							PB_HitFeedback_Math.LinearMap(pb_weapon_recoil_mod_horizontal, 0.0, 1.0, 1.0, 0.2),
							0, 0, 0,
							FPF_NOAUTOAIM,
							PB_HitFeedback_Math.LinearMap(pb_weapon_recoil_mod_vertical,   0.0, 1.0, 1.0, 0.2));
						PB_IncrementHeat(4);
						break;
				}
				break;
			case 2:
				A_ZoomFactor(1.0, SPF_INTERPOLATE);
				PB_WeaponRecoil(-2, frandom(-2, 2));
				break;
		}
	}

	states
	{
		Spawn:
			HND7 E -1;
			Stop;
		Steady:
			TNT1 A 0;
			Goto Ready;

		Deselect:
			TNT1 A 0
			{
				A_WeaponOffset(0, 32);
				A_SetRoll(0);
				PB_HandleCrosshair(-1);
				A_TakeInventory("PB_LockScreenTilt", 1);
			}
			TNT1 A 0 A_StopSound(6);
			TNT1 A 0 A_ZoomFactor(1);
			CYBF LMNO 1 BRIGHT;
			TNT1 A 0 A_Lower;
			Wait;

		Select:
			TNT1 A 0 A_WeaponOffset(0, 32);
			Goto SelectFirstPersonLegs;
		SelectContinue:
			TNT1 A 0 A_StartSound("BFGREADY", CHAN_AUTO);
			TNT1 A 0 PB_RespectIfNeeded();
		SelectAnimation:
			TNT1 A 0 A_StartSound("RLCYCLE", CHAN_AUTO, CHANF_OVERLAP);
			CYBF ONML 1 BRIGHT;

		Ready:
		Ready3:
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			TNT1 A 0 PB_HandleCrosshair(78);
			TNT1 A 0 A_PlaySound("BFGHUM", 6, 1, 1);
			CYBF IJ 1 BRIGHT A_DoPBWeaponAction();
			Loop;

		Fire:
			TNT1 A 0
			{
				A_WeaponOffset(0, 32);
				A_SetRoll(0);
				A_TakeInventory("PB_LockScreenTilt", 1);
			}
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			TNT1 A 0
			{
				if (CountInv("CyberRLDurability") < 1)
					return ResolveState("WeaponBreak");
				if (CountInv("PB_RocketAmmo") < 2)
					return ResolveState("NoAmmo");
				return ResolveState(null);
			}
			CYBF A 1 BRIGHT CyberRL_FireWeapon(0, 1);
			CYBF B 1 BRIGHT CyberRL_FireWeapon(0, 2);
			CYBF C 1 A_SetPitch(pitch - 1, SPF_INTERPOLATE);
			CYBF D 1 BRIGHT;
			CYBF D 1 BRIGHT A_SetPitch(pitch + 0.6, SPF_INTERPOLATE);
			CYBF EFG 1 BRIGHT A_SetPitch(pitch + 0.8, SPF_INTERPOLATE);
			CYBF HJ 1 BRIGHT;
			TNT1 A 0 A_FireCustomMissile("SmokeSpawner11", 0, 0, 0, 7);
			TNT1 A 0 A_ReFire;
			Goto Ready3;

		AltFire:
			TNT1 A 0
			{
				A_WeaponOffset(0, 32);
				A_SetRoll(0);
				A_TakeInventory("PB_LockScreenTilt", 1);
			}
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			TNT1 A 0
			{
				if (CountInv("CyberRLDurability") < 1)
					return ResolveState("WeaponBreak");
				if (CountInv("PB_RocketAmmo") < 2)
					return ResolveState("NoAmmo");
				return ResolveState(null);
			}
			CYBF A 1 BRIGHT CyberRL_FireWeapon(0, 1);
			CYBF B 1 BRIGHT CyberRL_FireWeapon(0, 2);
			CYBF C 1 A_SetPitch(pitch - 1, SPF_INTERPOLATE);
			CYBF D 1 BRIGHT A_SetPitch(pitch + 0.6, SPF_INTERPOLATE);
			CYBF EFG 1 BRIGHT A_SetPitch(pitch + 0.8, SPF_INTERPOLATE);
			TNT1 A 0
			{
				if (CountInv("CyberRLDurability") < 1)
					return ResolveState("WeaponBreak");
				if (CountInv("PB_RocketAmmo") < 2)
					return ResolveState("AltFireDone");
				return ResolveState(null);
			}
			CYBF A 1 BRIGHT CyberRL_FireWeapon(0, 1);
			CYBF B 1 BRIGHT CyberRL_FireWeapon(0, 2);
			CYBF C 1 A_SetPitch(pitch - 1, SPF_INTERPOLATE);
			CYBF D 1 BRIGHT A_SetPitch(pitch + 0.6, SPF_INTERPOLATE);
			CYBF EFG 1 BRIGHT A_SetPitch(pitch + 0.8, SPF_INTERPOLATE);
			TNT1 A 0
			{
				if (CountInv("CyberRLDurability") < 1)
					return ResolveState("WeaponBreak");
				if (CountInv("PB_RocketAmmo") < 2)
					return ResolveState("AltFireDone");
				return ResolveState(null);
			}
			CYBF A 1 BRIGHT CyberRL_FireWeapon(0, 1);
			CYBF B 1 BRIGHT CyberRL_FireWeapon(0, 2);
			CYBF C 1 A_SetPitch(pitch - 1, SPF_INTERPOLATE);
			CYBF D 1 BRIGHT A_SetPitch(pitch + 0.6, SPF_INTERPOLATE);
			CYBF EFG 1 BRIGHT A_SetPitch(pitch + 0.8, SPF_INTERPOLATE);
			TNT1 A 0
			{
				if (CountInv("CyberRLDurability") < 1)
					return ResolveState("WeaponBreak");
				if (CountInv("PB_RocketAmmo") < 2)
					return ResolveState("AltFireDone");
				return ResolveState(null);
			}
			CYBF A 1 BRIGHT CyberRL_FireWeapon(0, 1);
			CYBF B 1 BRIGHT CyberRL_FireWeapon(0, 2);
			CYBF C 1 A_SetPitch(pitch - 1, SPF_INTERPOLATE);
			CYBF D 3 BRIGHT;
			CYBF D 1 BRIGHT A_SetPitch(pitch + 0.6, SPF_INTERPOLATE);
			CYBF EEFFGG 1 BRIGHT A_SetPitch(pitch + 0.4, SPF_INTERPOLATE);
		AltFireDone:
			TNT1 A 0 A_FireCustomMissile("SmokeSpawner11", 0, 0, 0, 7);
			CYBF HHJ 1 BRIGHT;
			CYBF IJIJIJ 1 BRIGHT;
			TNT1 A 0 A_FireCustomMissile("SmokeSpawner11", 0, 0, 0, 7);
			Goto Ready3;

		WeaponBreak:
			TNT1 A 0
			{
				for (int i = 0; i < 5; i++)
				{
					A_CustomMissile("MetalShard1", 5, 0, random(-10, -20), 2, random(0, 30));
					A_CustomMissile("MetalShard2", 5, 0, random(-10, -20), 2, random(0, 30));
					A_CustomMissile("MetalShard3", 5, 0, random(-10, -20), 2, random(0, 30));
				}
				A_TakeInventory("PB_CyberdemonRL", 1);
				A_StartSound("meleeweapon/break", CHAN_AUTO);
				A_AlertMonsters();
			}
			Stop;

		NoAmmo:
			TNT1 A 0 A_PlaySound("weapons/empty", 4);
			CYBF IJIJ 1 BRIGHT A_DoPBWeaponAction(WRF_NOFIRE);
			Goto Ready3;

		PDA_Preview_CYRL_Fire:
			CYBF A 1 BRIGHT;
			CYBF B 1 BRIGHT;
			CYBF C 1;
			CYBF D 1 BRIGHT;
			CYBF EFG 1 BRIGHT;
			CYBF HJ 1 BRIGHT;
			Stop;
		PDA_Preview_CYRL_AltVolley:
			CYBF A 1 BRIGHT;
			CYBF B 1 BRIGHT;
			CYBF C 1;
			CYBF D 1 BRIGHT;
			CYBF EFG 1 BRIGHT;
			CYBF A 1 BRIGHT;
			CYBF B 1 BRIGHT;
			CYBF C 1;
			CYBF D 3 BRIGHT;
			CYBF EEFFGG 1 BRIGHT;
			CYBF HHJ 1 BRIGHT;
			CYBF IJIJIJ 1 BRIGHT;
			Stop;

		Weaponspecial:
			TNT1 A 0 A_TakeInventory("GoWeaponSpecialAbility", 1);
			TNT1 A 0 A_Print("\ctWeapon Special:\c- \cdn/a \c-");
			Goto Ready3;

		FlashPunching:
			CYBF PQRSTTUUUTTSRQP 1;
			TNT1 A 0 A_ClearOverlays(PSP_FLASH, PSP_FLASH, false);
			Goto Ready3;
		FlashKicking:
			CYBF PQRSTTUUUUTTSRQP 1;
			Goto Ready3;
		FlashAirKicking:
			CYBF PQRSTTTUUUTTTSRQP 1;
			Goto Ready3;
		FlashSlideKicking:
			CYBF PQQRRSSTTTTUUUUUTTTTSSRRQQP 1;
			Goto Ready3;
		FlashSlideKickingStop:
			CYBF SRRQQPP 1;
			Goto Ready3;
	}
}
