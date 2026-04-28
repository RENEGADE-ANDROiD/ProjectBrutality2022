class HMGShield : Inventory
{
	Default
	{
		Inventory.MaxAmount 100;
	}
}

// : PB_WeaponBase: SelectFirstPersonLegs inlined (see BaseWeapon.dec) — UZDoom needs a ZScript-resolvable base
class PB_NeoHMG : PB_WeaponBase
{
	const SHIELD_LAYER = -567;

	bool shieldReady;
	bool shieldWasActive;
	bool shieldActive;
	bool shieldBroken;
	int shieldTimer;
	int rechargeTimer;
	int shieldFrame;

	Default
	{
		//$Title Neo HMG
		//$Category Weapons
		//$Sprite HG0WA0
		Weapon.BobRangeX 0.3;
		Weapon.BobRangeY 0.5;
		Weapon.BobStyle "InverseSmooth";
		Weapon.BobSpeed 2.4;
		Weapon.SlotNumber 5;
		Weapon.AmmoType1 "NewClip";
		Weapon.AmmoType2 "HMGChamberAmmo";
		Weapon.AmmoGive1 30;
		Weapon.AmmoUse1 0;
		Weapon.AmmoUse2 0;
		Inventory.PickupSound "LMGPKP";
		Inventory.PickupMessage "Neo HMG (Slot 5)";
		Inventory.AltHUDIcon "HG0WA0";
		Obituary "%o was torn apart by %k's HMG";
		Tag "Neo HMG";
		Scale 0.5;
		+FLOORCLIP;
		+DONTGIB;
		+WEAPON.NOAUTOAIM;
		PB_WeaponBase.UnloaderToken "HMGIsUnloaded";
		PB_WeaponBase.respectItem "HMGJustRespect";
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		shieldReady = true;
		shieldBroken = false;
		shieldWasActive = false;
		shieldActive = false;
		shieldTimer = 0;
		rechargeTimer = 0;
		shieldFrame = 0;
		if (Owner)
			Owner.GiveInventory("HMGShield", 100);
	}

	void ClearShieldSideEffects()
	{
		shieldActive = false;
		shieldWasActive = false;
		if (Owner)
		{
			Owner.bNOBLOOD = false;
			if (Owner.player)
				Owner.player.SetPSprite(SHIELD_LAYER, null);
		}
	}

	override void ModifyDamage(int damage, Name damageType, out int newDamage, bool passive, Actor inflictor, Actor source, int flags)
	{
		Super.ModifyDamage(damage, damageType, newDamage, passive, inflictor, source, flags);
		if (!passive || newDamage < 1 || !Owner || !Owner.player) return;
		if (Owner.player.ReadyWeapon != self) return;
		if (!shieldWasActive) return;
		if (Owner.CountInv("HMGShield") < 1) return;
		Owner.TakeInventory("HMGShield", newDamage);
		Owner.A_StartSound("StickyGrenade/hit", CHAN_BODY, 0, 0.5);
		newDamage = 0;
	}

	override void DoEffect()
	{
		Super.DoEffect();
		if (!Owner || !Owner.player) return;
		let pi = Owner.player;
		if (pi.ReadyWeapon != self)
		{
			ClearShieldSideEffects();
			return;
		}
		if (CountInv("GoFatality") >= 1)
		{
			ClearShieldSideEffects();
			return;
		}

		bool noBarrels = Owner.CountInv("GrabbedBarrel") < 1
			&& Owner.CountInv("GrabbedFlameBarrel") < 1
			&& Owner.CountInv("GrabbedIceBarrel") < 1;

		if ((pi.cmd.buttons & BT_ALTATTACK) && shieldReady && Owner.CountInv("HMGShield") > 0 && noBarrels)
		{
			pi.SetPSprite(SHIELD_LAYER, FindState("HMGShield"));
			if (!shieldWasActive)
			{
				pi.SetPSprite(SHIELD_LAYER, FindState("HMGShieldBash"));
				Owner.A_StartSound("HMGSHLD3", CHAN_WEAPON);
			}
			shieldWasActive = true;
			shieldActive = true;
			Owner.bNOBLOOD = true;
		}
		else
		{
			shieldActive = false;
			Owner.bNOBLOOD = false;
			if (shieldWasActive)
			{
				pi.SetPSprite(SHIELD_LAYER, FindState("HMGShieldBreak"));
				Owner.A_StartSound("HMGSHLD4", CHAN_WEAPON);
				Owner.A_StartSound("StickyGrenade/hit", CHAN_BODY, 0, 0.35);
				shieldTimer = 15;
				shieldReady = false;
				if (Owner.CountInv("HMGShield") < 1)
				{
					shieldBroken = true;
					Owner.A_StartSound("HMGSHLD1", CHAN_WEAPON);
				}
				shieldWasActive = false;
			}
			if (shieldTimer > 0)
				shieldTimer--;
			else if (!shieldBroken && !shieldReady)
			{
				shieldReady = true;
				Owner.A_StartSound("HMGSHLD", CHAN_AUTO, 0, 0.4);
			}
			if (shieldTimer < 1)
			{
				if (rechargeTimer < 1)
					rechargeTimer++;
				else if (Owner.CountInv("HMGShield") < 100)
				{
					rechargeTimer = 0;
					Owner.GiveInventory("HMGShield", 10);
				}
				else if (shieldBroken)
				{
					shieldBroken = false;
					shieldReady = true;
					Owner.A_StartSound("HMGSHLD", CHAN_AUTO, 0, 0.45);
				}
			}
		}
	}

	States
	{
		Spawn:
			HG0W A -1;
			Stop;
		Steady:
			TNT1 A 1;
			Goto Ready3;
		Select:
			TNT1 A 0
			{
				A_WeaponOffset(0, 32);
				A_SetRoll(0);
				PB_HandleCrosshair(69);
			}
			TNT1 A 0 A_TakeInventory("PB_LockScreenTilt", 1);
			TNT1 A 0 A_TakeInventory("HasBarrel", 1);
			TNT1 A 0 A_TakeInventory("HasIceBarrel", 1);
			TNT1 A 0 A_TakeInventory("HasFlameBarrel", 1);
			TNT1 A 0 A_TakeInventory("GrabbedBarrel", 1);
			TNT1 A 0 A_TakeInventory("GrabbedIceBarrel", 1);
			TNT1 A 0 A_TakeInventory("GrabbedFlameBarrel", 1);
			TNT1 A 0 A_TakeInventory("HMG_Select_Heated", 1);
			TNT1 A 0 A_TakeInventory("HMG_Select_Charged", 1);
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
			TNT1 A 0 A_StartSound("weapon/HMG/Stop", CHAN_WEAPON);
			TNT1 A 0 PB_WeapTokenSwitch("NewChaingunSelected");
			TNT1 A 0
			{
				let w = PB_NeoHMG(invoker);
				if (w.CountInv("HMGChamberAmmo") < 1 && w.CountInv("HMGJustRespect") < 1)
					w.A_GiveInventory("HMGChamberAmmo", 80);
				Actor po = w.Owner;
				if (po && po.CountInv("HMGShield") < 1)
					po.GiveInventory("HMGShield", 100);
			}
			TNT1 A 0 PB_RespectIfNeeded;
		SelectAnimation:
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			HG0U ABCD 1;
			Goto Ready3;
		WeaponRespect:
			TNT1 A 0 A_GiveInventory("HMGJustRespect", 1);
			HG0U ABCD 1;
			Goto Ready3;
		Deselect:
			TNT1 A 0 { invoker.ClearShieldSideEffects(); }
			TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "PlaceBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedFlameBarrel", 1, "PlaceFlameBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "PlaceIceBarrel");
			HG0D ABCD 1;
			TNT1 A 0 A_Lower(120);
			Wait;
		Ready:
		Ready3:
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			HG0F A 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
			Loop;
		NoAmmo:
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			HG0F A 1
			{
				A_DoPBWeaponAction(WRF_ALLOWRELOAD);
			}
			Goto Ready3;
		Fire:
			TNT1 A 0
			{
				if (CountInv("GoFatality") >= 1) SetPlayerProperty(0, 1, 0);
				else SetPlayerProperty(0, 0, 0);
			}
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "ThrowBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedFlameBarrel", 1, "ThrowFlameBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "ThrowIceBarrel");
			TNT1 A 0 PB_CheckBarrelThrow1();
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
			TNT1 A 0 A_JumpIfInventory("HMGChamberAmmo", 1, "DoFireHMG");
			TNT1 A 0
			{
				A_Weaponoffset(0, 32);
				A_ZoomFactor(1.0);
			}
			Goto Reload;
		DoFireHMG:
			HG0F B 1 BRIGHT
			{
				if (CountInv("HMGModeCharged") >= 1)
					A_FireBullets(0.2, 0.2, 1, random(48, 56), "MachineGunBulletPuff", FBF_NORANDOM);
				else
					A_FireBullets(0.3, 0.3, 1, random(38, 45), "MachineGunBulletPuff", FBF_NORANDOM);
				A_TakeInventory("HMGChamberAmmo", 1);
				A_StartSound("weapon/HMG/Fire", CHAN_WEAPON);
				PB_WeaponRecoil(-1.1, frandom(-0.82, 0.82));
				PB_GunSmoke(0, 0, 0);
				A_FireCustomMissile("ShakeYourAss", 0, 0, 0, 0);
				A_ZoomFactor(0.985);
			}
			HG0F C 1 BRIGHT;
			TNT1 A 0 A_ZoomFactor(1.0);
			HG0F D 1;
			HG0F E 1;
			TNT1 A 0 A_Weaponoffset(0, 32);
			HG0F F 1 A_Refire;
			TNT1 A 0 A_StartSound("weapon/HMG/Stop", CHAN_WEAPON);
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			Goto Ready3;
		AltFire:
			TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "PlaceBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedFlameBarrel", 1, "PlaceFlameBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "PlaceIceBarrel");
			goto Ready3;
		HMGShieldBash:
			PSHL E 0 A_FireCustomMissile("KickAttack", 0, 0, 0, 0);
			Stop;
		HMGShield:
			TNT1 A 0
			{
				if (random(0, 1) == 1)
					A_OverlayFlags(SHIELD_LAYER, PSPF_FLIP, true);
				else
					A_OverlayFlags(SHIELD_LAYER, PSPF_FLIP, false);
				A_OverlayFlags(SHIELD_LAYER, PSPF_RENDERSTYLE | PSPF_FORCESTYLE, true);
				A_OverlayRenderStyle(SHIELD_LAYER, STYLE_Add);
			}
			TNT1 A 0 A_JumpIf(invoker.shieldFrame > 0, "HMGShield2");
			PSHL A 1 BRIGHT { invoker.shieldFrame++; }
			Stop;
		HMGShield2:
			TNT1 A 0 A_JumpIf(invoker.shieldFrame > 1, "HMGShield3");
			PSHL B 1 BRIGHT { invoker.shieldFrame++; }
			Stop;
		HMGShield3:
			TNT1 A 0 A_JumpIf(invoker.shieldFrame > 2, "HMGShield4");
			PSHL C 1 BRIGHT { invoker.shieldFrame++; }
			Stop;
		HMGShield4:
			TNT1 A 0 A_JumpIf(invoker.shieldFrame > 3, "HMGShield5");
			PSHL D 1 BRIGHT { invoker.shieldFrame++; }
			Stop;
		HMGShield5:
			TNT1 A 0 A_JumpIf(invoker.shieldFrame > 4, "HMGShield6");
			PSHL E 1 BRIGHT { invoker.shieldFrame++; }
			Stop;
		HMGShield6:
			TNT1 A 0 A_JumpIf(invoker.shieldFrame > 5, "HMGShield7");
			PSHL F 1 BRIGHT { invoker.shieldFrame++; }
			Stop;
		HMGShield7:
			TNT1 A 0 A_JumpIf(invoker.shieldFrame > 6, "HMGShield8");
			PSHL G 1 BRIGHT { invoker.shieldFrame++; }
			Stop;
		HMGShield8:
			PSHL H 1 BRIGHT { invoker.shieldFrame = 0; }
			Stop;
		HMGShieldBreak:
			TNT1 A 0 A_Quake(2, 6, 0, 96);
			Stop;
		WeaponSpecial:
			TNT1 A 0 A_TakeInventory("GoWeaponSpecialAbility", 1);
			TNT1 A 0
			{
				if (CountInv("HMG_Select_Heated") >= 1)
				{
					A_TakeInventory("HMG_Select_Heated", 1);
					A_TakeInventory("HMG_Select_Charged", 1);
					A_TakeInventory("HMGModeCharged", 1);
					A_Print("\ctNeo HMG:\c- \cgHeated \c-rounds");
					return resolvestate("Ready3");
				}
				if (CountInv("HMG_Select_Charged") >= 1)
				{
					A_TakeInventory("HMG_Select_Heated", 1);
					A_TakeInventory("HMG_Select_Charged", 1);
					A_GiveInventory("HMGModeCharged", 1);
					A_Print("\ctNeo HMG:\c- \cuCharged \c-rounds");
					return resolvestate("Ready3");
				}
				return resolvestate(null);
			}
			TNT1 A 0
			{
				if (CountInv("HMGModeCharged") >= 1)
				{
					A_TakeInventory("HMGModeCharged", 1);
					A_Print("\ctNeo HMG:\c- \cgHeated \c-rounds");
				}
				else
				{
					A_GiveInventory("HMGModeCharged", 1);
					A_Print("\ctNeo HMG:\c- \cuCharged \c-rounds");
				}
			}
			Goto Ready3;
		Unload:
			TNT1 A 0 A_TakeInventory("Unloading", 1);
			HG0R ABCD 1;
			HG0R EFGH 1;
			TNT1 A 0 A_StartSound("weapons/sgl/detach", 33);
			HG0R IJKL 1;
			HG0R MNOOPP 1;
			HG0R QQQ 1;
			HG0R QRST 1;
			TNT1 A 0 A_StartSound("weapon/HMG/Reload1", 34);
			TNT1 A 0 PB_DumpMagToPool("HMGChamberAmmo", "NewClip", 1);
			TNT1 A 0 A_GiveInventory("HMGIsUnloaded", 1);
			HG0R UVWXX 1;
			HG0R YYZ 1;
			HG1R ABC 1;
			Goto Ready3;
		Reload:
			TNT1 A 0
			{
				A_ZoomFactor(1.0);
				A_Weaponoffset(0, 32);
			}
			TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "IdleBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedFlameBarrel", 1, "IdleFlameBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "IdleIceBarrel");
			TNT1 A 0 A_JumpIfInventory("HMGChamberAmmo", 80, "Ready3");
			TNT1 A 0 A_JumpIfInventory("NewClip", 1, "StartReloadHMG");
			TNT1 A 0 A_PlaySound("weapons/empty", CHAN_WEAPON);
			Goto NoAmmo;
		StartReloadHMG:
			HG0R ABCD 1;
			HG0R EFGH 1;
			TNT1 A 0 A_StartSound("weapons/sgl/detach", 33);
			TNT1 A 0
			{
				if (CountInv("HMGChamberAmmo") < 1 && !CheckInventory("HMGIsUnloaded", 1))
					PB_SpawnCasing("EmptyLMGMag", 12, -2.5, 6.25, frandom(2, 5), frandom(1, 3), frandom(2, 4));
			}
			TNT1 A 0 A_TakeInventory("HMGIsUnloaded", 1);
			HG0R IJKL 1;
			HG0R MNOOPP 1;
			HG0R QQQ 1;
			HG0R QRST 1;
			TNT1 A 0 A_StartSound("weapon/HMG/Reload1", 34);
			TNT1 A 0 PB_AmmoIntoMag("HMGChamberAmmo", "NewClip", 80, 1);
			HG0R UVWXX 1;
			HG0R YYZ 1;
			HG1R ABC 1;
			Goto Ready3;
		FlashPunching:
			TNT1 A 0 A_ClearOverlays(10, 11);
			HG0K ABCDEFGHFEDCBA 1;
			Goto Ready3;
		FlashKicking:
			TNT1 A 0 A_ClearOverlays(10, 11);
			HG0K ABCDEFGHHFEDCBA 1;
			Goto Ready3;
		FlashAirKicking:
			TNT1 A 0 A_ClearOverlays(10, 11);
			HG0K ABCDEFGHHHFEDCBA 1;
			Goto Ready3;
		FlashSlideKicking:
			TNT1 A 0 A_ClearOverlays(10, 11);
			HG0K ABCDEFGHHHHHHHHHHHHHGFEDCBA 1;
			Goto Ready3;
		FlashSlideKickingStop:
			TNT1 A 0 A_ClearOverlays(10, 11);
			HG0K GFEDCBA 1;
			Goto Ready3;
	}
}
