const neohmgFullAmmo = 80;
const neohmgShieldAmmo = 100;

class HMGShield : Inventory
{
	Default
	{
		Inventory.MaxAmount neohmgShieldAmmo;
	}
}

// PBX NeoHMG shield break particles (Risdar/PBX-Weapons NeoHMG_helpers.zs).
class NeoHMGShieldParticle : VisualThinker
{
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		texture = TexMan.CheckForTexture('YAE6A0');
		scale = (0.01, 0.01);
		alpha = 1;
		flags = SPF_FULLBRIGHT;
		SetRenderStyle(STYLE_Add);
	}

	override void Tick()
	{
		if (alpha <= 0)
		{
			Destroy();
			return;
		}
		vel.z -= 0.2;
		alpha -= 0.04;
		Super.Tick();
	}
}

// PB 2022 fold: PBX NeoHMG (Risdar/PBX-Weapons Slot-5/NeoHMG).
// Alt-fire shield is personal-only (PSHL overlay + HMGShield drain); release spawns NeoHMGShieldParticle burst — no world deploy.
class PB_NeoHMG : PB_WeaponBase
{
	const SHIELD_LAYER = -567;
	const HMG_SHIELDSOUNDLAYER = 234;
	const HMG_SHIELDSOUNDLAYER2 = 233;

	const shieldProtectionMultiplier = 1;
	const shieldRechargeSpeed = 1;
	const shieldRechargeRate = 5;
	const shieldCooldown = 15;

	enum NeoHMGRounds
	{
		eHeatedRounds = 0,
		eChargedRounds = 1
	}

	int ammoType;
	int shieldDrain;

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
		Weapon.SlotPriority 0.2;
		Weapon.AmmoType1 "NewClip";
		Weapon.AmmoType2 "HMGChamberAmmo";
		Weapon.AmmoGive1 80;
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
		+FORCEXYBILLBOARD;
		+WEAPON.NOAUTOAIM;
		PB_WeaponBase.UnloaderToken "HMGIsUnloaded";
		PB_WeaponBase.respectItem "HMGJustRespect";
		PB_WeaponBase.MaxOverheat 400;
		PB_WeaponBase.OverheatCoolingRate 4;
	}

	void SyncRoundModeInventory()
	{
		if (!Owner) return;
		Owner.A_SetInventory("HMGModeCharged", ammoType == eChargedRounds ? 1 : 0);
	}

	action void cleanmodetokens()
	{
		A_TakeInventory("HMG_Select_Heated", 1);
		A_TakeInventory("HMG_Select_Charged", 1);
	}

	action void setAmmoType(int set)
	{
		invoker.ammoType = set;
		invoker.SyncRoundModeInventory();
	}

	action int getAmmoType()
	{
		return invoker.ammoType;
	}

	action State HMG_HandleSpecial()
	{
		bool hasTokH = FindInventory("HMG_Select_Heated") != null;
		bool hasTokC = FindInventory("HMG_Select_Charged") != null;

		if (!hasTokH && !hasTokC)
		{
			if (invoker.ammoType == eHeatedRounds)
			{
				setAmmoType(eChargedRounds);
				A_Print("\ctNeo HMG:\c- \cuCharged \c-rounds");
			}
			else
			{
				setAmmoType(eHeatedRounds);
				A_Print("\ctNeo HMG:\c- \cgHeated \c-rounds");
			}
			return ResolveState(null);
		}

		bool alreadyHeated = hasTokH && invoker.ammoType == eHeatedRounds;
		bool alreadyCharged = hasTokC && invoker.ammoType == eChargedRounds;

		if (alreadyHeated || alreadyCharged)
		{
			A_Print("\ctNeo HMG:\c- Already using this round type.");
			cleanmodetokens();
			return ResolveState("Ready3");
		}

		if (hasTokH)
		{
			setAmmoType(eHeatedRounds);
			A_Print("\ctNeo HMG:\c- \cgHeated \c-rounds");
		}
		else if (hasTokC)
		{
			setAmmoType(eChargedRounds);
			A_Print("\ctNeo HMG:\c- \cuCharged \c-rounds");
		}

		cleanmodetokens();
		return ResolveState(null);
	}

	action void HMG_fireBullet()
	{
		name loadedbullets = 'PB_792x57mm';
		sound soundtouse = "weapon/HMG/Fire";

		if (PB_GetOverheat() > 115)
		{
			switch (getAmmoType())
			{
			default:
			case eHeatedRounds:
				loadedbullets = 'PB_792x57mm_Heated';
				soundtouse = "MG42FIR";
				break;
			case eChargedRounds:
				loadedbullets = 'PB_792x57mm_Charged';
				soundtouse = "PLSM9";
				break;
			}
		}

		A_StartSound(soundtouse, CHAN_WEAPON, CHANF_OVERLAP);
		PB_FireBullets(loadedbullets, 1, 3, 0, 0, 2.5);
	}

	action State fireHMG(int weaponSide, int ticCount)
	{
		switch (ticCount)
		{
		default:
		case 1:
			A_AlertMonsters();
			A_WeaponOffset(0, 32);
			A_SetRoll(0);
			A_TakeInventory("PB_LockScreenTilt", 1);
			HMG_fireBullet();
			PB_WeaponRecoil(-1.1, frandom(-0.82, 0.82));
			PB_ModifyOverheat(2);
			invoker.PB_NeoHMG_ApplyFireCosmetics();
			PB_LowAmmoSoundWarning("hdmr");
			PB_FireOffset();
			A_QuakeEx(0, 1, 0, 12, 0, 10, "",
				QF_WAVE | QF_RELATIVE | QF_SCALEDOWN,
				0.6, 0, 0.2, 0, 0, 0.3, 0.40);
			A_ZoomFactor(0.985);
			PB_LowAmmoSoundWarning();
			A_TakeInventory("HMGChamberAmmo", 1);
			break;
		case 2:
			PB_ModifyOverheat(5);
			A_ZoomFactor(1.0, SPF_INTERPOLATE);
			break;
		}
		return ResolveState(null);
	}

	// PBX belt-box visuals: map 80-round chamber to four linked ammo boxes (XH01–XH04 / XHR* / XH*R).
	int GetBeltBoxCount()
	{
		if (!Owner) return 0;
		int chamber = Owner.CountInv("HMGChamberAmmo");
		if (chamber <= 0) return 0;
		return min(4, (chamber + 19) / 20);
	}

	action void NeoHMG_SetFireBeltSprite()
	{
		int box = PB_NeoHMG(invoker).GetBeltBoxCount();
		if (box >= 4) A_SetWeaponSprite("XH04");
		else if (box == 3) A_SetWeaponSprite("XH03");
		else if (box == 2) A_SetWeaponSprite("XH02");
		else A_SetWeaponSprite("XH01");
	}

	action void NeoHMG_SetReloadBeltSprite()
	{
		int box = PB_NeoHMG(invoker).GetBeltBoxCount();
		if (box >= 4) A_SetWeaponSprite("XHR4");
		else if (box == 3) A_SetWeaponSprite("XHR3");
		else if (box == 2) A_SetWeaponSprite("XHR2");
		else A_SetWeaponSprite("XHR1");
	}

	action void NeoHMG_SetInsertBeltSprite()
	{
		int box = PB_NeoHMG(invoker).GetBeltBoxCount();
		if (box >= 4) A_SetWeaponSprite("XH4R");
		else if (box == 3) A_SetWeaponSprite("XH3R");
		else if (box == 2) A_SetWeaponSprite("XH2R");
		else A_SetWeaponSprite("XH1R");
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		ammoType = eHeatedRounds;
		shieldReady = true;
		shieldBroken = false;
		shieldWasActive = false;
		shieldActive = false;
		shieldTimer = 0;
		rechargeTimer = 0;
		shieldFrame = 0;
		SyncRoundModeInventory();
		if (Owner)
		{
			Owner.GiveInventory("HMGShield", neohmgShieldAmmo);
		}
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

	action void A_FireVisualThinker(class<VisualThinker> thinker, int speed = 0, double offsetangle = 0, double offsetpitch = 0, double offsetx = 0, double offsety = 0, double offsetz = 0, bool rvel = true)
	{
		if (!player || !player.mo)
			return;
		let thonk = Level.SpawnVisualThinker(thinker);
		if (!thonk)
			return;

		double a = angle + offsetangle;
		double p = pitch + offsetpitch;
		Vector3 dir;
		dir.x = cos(a) * cos(p);
		dir.y = sin(a) * cos(p);
		dir.z = -sin(p);

		Quat ofsbase = Quat.FromAngles(angle, pitch, roll);
		Vector3 offset = (offsety, -offsetx, offsetz);
		Vector3 ppos = ofsbase * offset;
		Vector3 ofs = level.Vec3Offset(pos, ppos);
		thonk.pos = ofs;
		thonk.pos.z += player.mo.height * 0.5 - player.mo.floorclip + player.mo.AttackZOffset * player.crouchFactor - 4 + offsetz;

		thonk.vel = dir * speed;
		thonk.pos += dir * clamp(speed * 0.5, 0, player.mo.radius);
		if (rvel)
			thonk.vel += player.mo.vel;
	}

	action void A_FireShieldParticles()
	{
		for (int i = 40; i > 0; i--)
		{
			A_FireVisualThinker("NeoHMGShieldParticle", i > 20 ? 2 : 4, random(-4, 4), random(-20, 20), frandom(-20, 20), 10, frandom(0, 6));
		}
	}

	override void ModifyDamage(int damage, Name damageType, out int newDamage, bool passive, Actor inflictor, Actor source, int flags)
	{
		Super.ModifyDamage(damage, damageType, newDamage, passive, inflictor, source, flags);
		if (!passive || newDamage < 1 || !Owner || !Owner.player) return;
		if (Owner.player.ReadyWeapon != self) return;
		if (!shieldWasActive) return;
		if (Owner.CountInv("HMGShield") < 1) return;
		shieldDrain = clamp(int(newDamage * shieldProtectionMultiplier), 1, neohmgShieldAmmo);
		Owner.TakeInventory("HMGShield", shieldDrain);
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
			&& Owner.CountInv("GrabbedBurningBarrel") < 1
			&& Owner.CountInv("GrabbedIceBarrel") < 1;

		if ((pi.cmd.buttons & BT_ALTATTACK) && shieldReady && Owner.CountInv("HMGShield") > 0 && noBarrels)
		{
			pi.SetPSprite(SHIELD_LAYER, FindState("HMGShield"));
			if (!shieldWasActive)
			{
				pi.SetPSprite(SHIELD_LAYER, FindState("HMGShieldBash"));
				Owner.A_StartSound("HMGSHLD3", HMG_SHIELDSOUNDLAYER);
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
				Owner.A_StartSound("HMGSHLD4", HMG_SHIELDSOUNDLAYER);
				Owner.A_StartSound("StickyGrenade/hit", CHAN_BODY, 0, 0.35);
				shieldTimer = shieldCooldown;
				shieldReady = false;
				if (Owner.CountInv("HMGShield") < 1)
				{
					shieldBroken = true;
					Owner.A_StartSound("HMGSHLD1", HMG_SHIELDSOUNDLAYER);
				}
				shieldWasActive = false;
			}
			if (shieldTimer > 0)
				shieldTimer--;
			else if (!shieldBroken && !shieldReady)
			{
				shieldReady = true;
				Owner.A_StartSound("HMGSHLD", CHAN_AUTO, CHANF_OVERLAP, 0.4);
			}
			if (shieldTimer < 1)
			{
				if (rechargeTimer < shieldRechargeSpeed)
					rechargeTimer++;
				else if (Owner.CountInv("HMGShield") < neohmgShieldAmmo)
				{
					rechargeTimer = 0;
					Owner.GiveInventory("HMGShield", shieldRechargeRate);
				}
				else if (shieldBroken)
				{
					shieldBroken = false;
					shieldReady = true;
					Owner.A_StartSound("HMGSHLD", CHAN_AUTO, CHANF_OVERLAP, 0.45);
				}
			}
		}
	}

	States
	{
		Spawn:
			HG0W A -1;
			Stop;
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
			TNT1 A 0 A_TakeInventory("HasBurningBarrel", 1);
			TNT1 A 0 A_TakeInventory("GrabbedBarrel", 1);
			TNT1 A 0 A_TakeInventory("GrabbedIceBarrel", 1);
			TNT1 A 0 A_TakeInventory("GrabbedBurningBarrel", 1);
			Goto SelectFirstPersonLegs;
		SelectContinue:
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			TNT1 A 0 A_StartSound("weapon/HMG/Stop", CHAN_WEAPON);
			TNT1 A 0 PB_WeapTokenSwitch("NewChaingunSelected");
			TNT1 A 0
			{
				let w = PB_NeoHMG(invoker);
				if (w.CountInv("HMGChamberAmmo") < 1 && w.CountInv("HMGJustRespect") < 1)
					w.A_GiveInventory("HMGChamberAmmo", neohmgFullAmmo);
				Actor po = w.Owner;
				if (po && po.CountInv("HMGShield") < 1)
					po.GiveInventory("HMGShield", neohmgShieldAmmo);
			}
			TNT1 A 0 PB_RespectIfNeeded;
		SelectAnimation:
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			TNT1 A 0 { if (PB_GetOverheat() > 1) A_Overlay(3, "Cooling", true); }
			HG0U ABCD 1;
			Goto Ready3;
		WeaponRespect:
			TNT1 A 0 A_GiveInventory("HMGJustRespect", 1);
			HG0U ABCD 1;
			Goto Ready3;
		Deselect:
			TNT1 A 0 { invoker.ClearShieldSideEffects(); }
			TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "PlaceBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedBurningBarrel", 1, "PlaceFlameBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "PlaceIceBarrel");
			HG0D ABCD 1;
			TNT1 A 0 A_Lower(120);
			Wait;
		Ready:
		Ready3:
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			TNT1 A 0
			{
				if (PB_GetOverheat() > 1)
					A_Overlay(3, "Cooling", true);
				PB_HandleCrosshair(69);
			}
			XH01 A 0;
			XH02 A 0;
			XH03 A 0;
			XH04 A 0;
			HG0F A 1
			{
				PB_CoolDownBarrel(0, 0, 3);
				NeoHMG_SetFireBeltSprite();
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD);
			}
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
				else
				{
					SetPlayerProperty(0, 0, 0);
					SetPlayerProperty(0, 0, PROP_TOTALLYFROZEN);
				}
			}
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "ThrowBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedBurningBarrel", 1, "ThrowFlameBarrel");
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
			TNT1 A 0 PB_HandleCrosshair(69);
			TNT1 A 0 PB_jumpIfNoAmmo("Reload", 1, false);
			TNT1 A 0 A_JumpIfInventory("HMGChamberAmmo", 1, "DoFireHMG");
			TNT1 A 0
			{
				A_Weaponoffset(0, 32);
				A_ZoomFactor(1.0);
			}
			Goto Reload;
		DoFireHMG:
			XH01 BCDEF 0;
			XH02 BCDEF 0;
			XH03 BCDEF 0;
			XH04 EF 0;
			HG0F B 1 BRIGHT
			{
				NeoHMG_SetFireBeltSprite();
				return fireHMG(0, 1);
			}
			HG0F C 1 BRIGHT
			{
				NeoHMG_SetFireBeltSprite();
				return fireHMG(0, 2);
			}
			HG0F D 1 { NeoHMG_SetFireBeltSprite(); }
			HG0F E 1 { NeoHMG_SetFireBeltSprite(); }
			TNT1 A 0 A_Weaponoffset(0, 32);
			HG0F F 1
			{
				NeoHMG_SetFireBeltSprite();
				return A_Refire();
			}
			TNT1 A 0 A_StartSound("weapon/HMG/Stop", CHAN_WEAPON);
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			Goto Ready3;
		AltFire:
			TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "PlaceBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedBurningBarrel", 1, "PlaceFlameBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "PlaceIceBarrel");
			Goto Ready3;
		HMGShieldBash:
			PSHL E 0 A_FireProjectile("KickAttack", 0, 0, 0, 0);
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
			PSHL A 0 A_FireShieldParticles();
			Stop;
		WeaponSpecial:
			TNT1 A 0
			{
				A_TakeInventory("GoWeaponSpecialAbility", 1);
				A_ZoomFactor(1.0);
			}
			TNT1 A 0 HMG_HandleSpecial();
			HG0U DDDDCC 1;
			TNT1 A 0 A_StartSound("excavator/switch", CHAN_WEAPON);
			HG0U CCDDDD 1;
			Goto Ready3;
		Cooling:
			TNT1 A 8;
			TNT1 A 4 PB_ModifyOverheat(-5);
			Wait;
		Unload:
			TNT1 A 0 A_TakeInventory("Unloading", 1);
			XHR1 ABCDEFGHI 0;
			XHR2 ABCDEFGHI 0;
			XHR3 ABCDEFGHI 0;
			XHR4 ABCDE 0;
			HG0R ABCD 1 { NeoHMG_SetReloadBeltSprite(); }
			HG0R EFGH 1 { NeoHMG_SetReloadBeltSprite(); }
			TNT1 A 0 A_StartSound("weapons/sgl/detach", 5);
			HG0R IJKL 1 { NeoHMG_SetReloadBeltSprite(); }
			HG0R MNOOPP 1;
			HG0R QQQ 1;
			HG0R QRST 1;
			TNT1 A 0 A_StartSound("weapon/HMG/Reload1", 6);
			TNT1 A 0 { PB_DumpMagToPool("HMGChamberAmmo", "NewClip", 1, "PB_HighCalUnloadProp"); }
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
			TNT1 A 0 A_JumpIfInventory("GrabbedBurningBarrel", 1, "IdleFlameBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "IdleIceBarrel");
			TNT1 A 0 A_JumpIfInventory("HMGChamberAmmo", neohmgFullAmmo, "Ready3");
			TNT1 A 0 A_JumpIfInventory("NewClip", 1, "StartReloadHMG");
			TNT1 A 0 A_PlaySound("weapons/empty", CHAN_WEAPON);
			Goto NoAmmo;
		StartReloadHMG:
			XH1R ABC 0;
			XH2R ABC 0;
			XH3R ABC 0;
			XH4R ABC 0;
			XHR1 ABCDEFGHI 0;
			XHR1 VWXYZ 0;
			XHR2 ABCDEFGHI 0;
			XHR2 VWXYZ 0;
			XHR3 ABCDEFGHI 0;
			XHR3 VWXYZ 0;
			XHR4 ABCDE 0;
			XHR4 VWXYZ 0;
			HG0R ABCD 1 { NeoHMG_SetReloadBeltSprite(); }
			HG0R EFGH 1 { NeoHMG_SetReloadBeltSprite(); }
			TNT1 A 0 A_StartSound("weapons/sgl/detach", 5);
			TNT1 A 0
			{
				if (CountInv("HMGChamberAmmo") < 1 && !CheckInventory("HMGIsUnloaded", 1))
					PB_SpawnCasing("EmptyLMGMag", 12, -2.5, 6.25, frandom(2, 5), frandom(1, 3), frandom(2, 4));
			}
			TNT1 A 0 A_TakeInventory("HMGIsUnloaded", 1);
			HG0R IJKL 1 { NeoHMG_SetReloadBeltSprite(); }
			HG0R MNOOPP 1;
			HG0R QQQ 1;
			HG0R QRST 1;
			TNT1 A 0 A_StartSound("weapon/HMG/Reload1", 6);
			TNT1 A 0 PB_AmmoIntoMag("HMGChamberAmmo", "NewClip", neohmgFullAmmo, 1);
			HG0R UVWXX 1 { NeoHMG_SetReloadBeltSprite(); }
			HG0R YYZ 1 { NeoHMG_SetReloadBeltSprite(); }
			HG1R ABC 1 { NeoHMG_SetInsertBeltSprite(); }
			Goto Ready3;
		PDA_Preview_NeoFire:
			HG0F B 2 Bright;
			HG0F C 2 Bright;
			HG0F D 2;
			HG0F E 2;
			HG0F F 2;
			Stop;
		PDA_Preview_NeoShield:
			PSHL A 2 Bright;
			PSHL B 2 Bright;
			PSHL C 2 Bright;
			PSHL D 2 Bright;
			PSHL E 2 Bright;
			Stop;
		PDA_Preview_NeoMode:
			HG0U DDDDCC 2;
			HG0U CCDDDD 2;
			Stop;
		PDA_Preview_NeoReload:
			HG0R ABCD 2;
			HG0R EFGH 2;
			HG0R IJKL 2;
			HG0R UVWX 2;
			HG1R ABC 2;
			Stop;

		FlashPunching:
			TNT1 A 0 A_Overlay(3, "Cooling", true);
			TNT1 A 0 A_ClearOverlays(10, 11);
			HG0K ABCDEFGHFEDCBA 1;
			TNT1 A 0 A_ClearOverlays(PSP_FLASH, PSP_FLASH, false);
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
