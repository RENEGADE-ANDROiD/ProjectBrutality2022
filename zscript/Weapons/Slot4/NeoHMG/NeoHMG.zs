const neohmgFullAmmo = 80;
const neohmgShieldAmmo = 100;
// World shield uses sector floor + lift; PSprite HMGShield is unrelated (not weapon/HUD offsets).
const neohmgShieldFloorLift = 36;
// PSHL WALLSPRITE art sits left of the actor origin; nudge render only (+hitbox unchanged).
const neohmgShieldRenderSideNudge = 24.;

class HMGShield : Inventory
{
	Default
	{
		Inventory.MaxAmount neohmgShieldAmmo;
	}
}

class NeoHMGDeployedShield : Actor
{
	// Armed after DeployHeldShield sets lifetime; <0 avoids a first-tic Death if Tick runs before setup.
	int lifeTics;
	bool expiring;
	double lockYaw;
	Actor damageCredit;

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		lifeTics = -1;
		Pitch = 0;
		Roll = 0;
		bFlatSprite = false;
	}

	void SpawnFrontEnergy(int count, double speed)
	{
		Vector3 forward = (cos(angle), sin(angle), 0);
		Vector3 right = (cos(angle + 90), sin(angle + 90), 0);
		for (int i = 0; i < count; i++)
		{
			Vector3 sparkPos = pos + forward * frandom(14, 24) + right * frandom(-15, 15) + (0, 0, frandom(8, 48));
			Actor spark = Actor.Spawn("GreenTrailSparks", sparkPos, NO_REPLACE);
			if (spark)
			{
				spark.vel = forward * frandom(speed * 0.55, speed) + right * frandom(-1.8, 1.8) + (0, 0, frandom(-0.2, 2.6));
			}
		}
		if (random(0, 2) == 0)
		{
			Actor flare = Actor.Spawn("GreenFlareSmall", pos + forward * 20 + right * frandom(-10, 10) + (0, 0, frandom(15, 42)), NO_REPLACE);
			if (flare)
			{
				flare.vel = forward * frandom(speed * 0.25, speed * 0.55) + right * frandom(-0.7, 0.7) + (0, 0, frandom(0.2, 1.4));
			}
		}
	}

	Default
	{
		Radius 40;
		Height 88;
		Health neohmgShieldAmmo;
		Mass 999999;
		XScale 0.38;
		YScale 0.48;
		RenderStyle "Add";
		Alpha 0.62;
		// 90° with +WALLSPRITE lays the wall in the floor plane (rug); 0 keeps a vertical barrier.
		SpriteRotation 0;
		+SOLID;
		+SHOOTABLE;
		+WALLSPRITE;
		+NOTARGET;
		+NOBLOOD;
		+DONTGIB;
		+NOTELEPORT;
		+NOGRAVITY;
		+NODAMAGETHRUST;
	}

	void SpawnDetachBurst()
	{
		for (int i = 0; i < 42; i++)
		{
			double burstAngle = angle + frandom(-70, 70);
			Vector3 dir = (cos(burstAngle), sin(burstAngle), 0);
			Actor spark = Actor.Spawn("GreenTrailSparks", pos + dir * frandom(8, 21) + (0, 0, frandom(7, 52)), NO_REPLACE);
			if (spark)
			{
				spark.vel = dir * frandom(2.5, 8.0) + (0, 0, frandom(0.4, 5.8));
			}
		}

		for (int j = 0; j < 10; j++)
		{
			double flareAngle = angle + frandom(-85, 85);
			Vector3 flareDir = (cos(flareAngle), sin(flareAngle), 0);
			Actor flare = Actor.Spawn("GreenFlareSmall", pos + flareDir * frandom(7, 18) + (0, 0, frandom(15, 48)), NO_REPLACE);
			if (flare)
			{
				flare.vel = flareDir * frandom(1.6, 4.5) + (0, 0, frandom(0.5, 3.0));
			}
		}
	}

	void DamageEnergyBurst()
	{
		double radius = 144;
		Actor dmgSource = self;
		if (damageCredit)
			dmgSource = damageCredit;
		array<Actor> damaged;
		let it = BlockThingsIterator.Create(self, radius);
		while (it.Next())
		{
			Actor mon = it.thing;
			if (!mon || !mon.bIsMonster || mon.bKilled || !mon.bShootable || damaged.Find(mon) >= 0) continue;
			if (Distance3D(mon) > radius || !CheckSight(mon)) continue;
			damaged.Push(mon);
			int dmg = int(max(20, 70 - (Distance3D(mon) * 0.28)));
			mon.DamageMobj(self, dmgSource, dmg, 'Plasma', 0, AngleTo(mon));
			mon.vel += (cos(AngleTo(mon)), sin(AngleTo(mon)), 0.25) * 6;
			for (int i = 0; i < 5; i++)
			{
				Actor spark = Actor.Spawn("GreenTrailSparks", mon.pos + (frandom(-6, 6), frandom(-6, 6), frandom(8, max(12, mon.height * 0.7))), NO_REPLACE);
				if (spark) spark.vel = (frandom(-2.5, 2.5), frandom(-2.5, 2.5), frandom(0.5, 4.0));
			}
		}
	}

	override void Tick()
	{
		Super.Tick();
		if (expiring) return;
		if (lifeTics < 0) return;

		Angle = lockYaw;
		Pitch = 0;
		Roll = 0;
		double cr = cos(Angle - 90);
		double sr = sin(Angle - 90);
		WorldOffset = (cr, sr, 0) * neohmgShieldRenderSideNudge;

		vel = (0, 0, 0);
		FindFloorCeiling();
		double standZ = floorz + neohmgShieldFloorLift;
		if (pos.Z < standZ - 1 || pos.Z > standZ + 24)
			SetOrigin((pos.X, pos.Y, standZ), false);
		// Every other game tic + smaller bursts — constant per-tic spawns can choke FPS.
		if ((level.maptime & 1) == 0)
		{
			SpawnFrontEnergy(3, 4.5);
			if (lifeTics > 0 && (lifeTics % 12) == 0)
				SpawnFrontEnergy(5, 5.8);
		}

		if (lifeTics > 0)
			lifeTics--;
		else
		{
			expiring = true;
			SetStateLabel("Death");
		}
	}

	States
	{
	Spawn:
		PSHL H 2 Bright;
		Loop;
	Death:
		TNT1 A 0
		{
			expiring = true;
			bSHOOTABLE = false;
			bSOLID = false;
			DamageEnergyBurst();
			SpawnDetachBurst();
			A_StartSound("HMGSHLD4", CHAN_BODY, CHANF_OVERLAP, 0.55);
		}
		PSHL HHHHHH 2 Bright A_FadeOut(0.12);
		Stop;
	}
}

// PB 2022 fold: PBX NeoHMG behavior (overheat, PB_792x57mm family, shield drain, cooling overlay,
// two-tic fire, muzzle overlay) on NewClip + standard PB select / fatality / barrel hooks.
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
	Actor deployedShield;

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
			PB_GunSmoke(0, 0, 0);
			PB_LowAmmoSoundWarning("hdmr");
			PB_FireOffset();
			A_FireCustomMissile("MinigunTracer", random(-3, 3), 0, -1, random(-3, 3));
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

	void DeployHeldShield()
	{
		if (!Owner || !Owner.player) return;

		int shieldCharge = Owner.CountInv("HMGShield");
		if (shieldCharge < 1) return;

		if (deployedShield)
		{
			deployedShield.Destroy();
			deployedShield = null;
		}

		double dist = Owner.Radius + 48;
		double ca = cos(Owner.Angle);
		double sa = sin(Owner.Angle);
		Vector2 xy = (Owner.Pos.X + ca * dist, Owner.Pos.Y + sa * dist);
		let sec = Owner.Level.PointInSector(xy);
		double fz = Owner.FloorZ;
		if (sec)
			fz = sec.FloorPlane.ZatPoint(xy);
		Vector3 shieldPos = (xy.X, xy.Y, fz + neohmgShieldFloorLift);
		Actor spawned = Actor.Spawn("NeoHMGDeployedShield", shieldPos, NO_REPLACE);
		let shield = NeoHMGDeployedShield(spawned);
		if (!shield) return;
		shield.FindFloorCeiling();
		shield.SetZ(shield.floorz + neohmgShieldFloorLift);

		double deployAng = Owner.Angle;
		shield.lockYaw = deployAng;
		shield.Angle = deployAng;
		shield.damageCredit = Owner;
		shield.target = null;
		shield.Health = max(25, shieldCharge);
		shield.lifeTics = 35 * 8 + shieldCharge;
		shield.SpawnDetachBurst();
		deployedShield = shield;

		Owner.TakeInventory("HMGShield", shieldCharge);
		Owner.A_StartSound("HMGSHLD2", HMG_SHIELDSOUNDLAYER2, CHANF_OVERLAP, 0.8);
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
			&& Owner.CountInv("GrabbedFlameBarrel") < 1
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
				DeployHeldShield();
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
				PB_HandleCrosshair(69);
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
			TNT1 A 0 A_JumpIfInventory("GrabbedFlameBarrel", 1, "PlaceFlameBarrel");
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
			HG0F A 1
			{
				PB_CoolDownBarrel(0, 0, 3);
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
			HG0F B 1 BRIGHT { return fireHMG(0, 1); }
			HG0F C 1 BRIGHT { return fireHMG(0, 2); }
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
			TNT1 A 0 A_Quake(2, 6, 0, 96);
			TNT1 A 0
			{
				for (int i = 0; i < 10; i++)
					A_SpawnItemEx("RedFlareSmall",
						frandom(-10.0, 10.0), frandom(-8.0, 8.0), frandom(8.0, 20.0),
						frandom(-1.0, 1.0), frandom(-1.0, 1.0), frandom(1.0, 3.0),
						random(0, 360), SXF_ABSOLUTEANGLE);
			}
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
			HG0R ABCD 1;
			HG0R EFGH 1;
			TNT1 A 0 A_StartSound("weapons/sgl/detach", 33);
			HG0R IJKL 1;
			HG0R MNOOPP 1;
			HG0R QQQ 1;
			HG0R QRST 1;
			TNT1 A 0 A_StartSound("weapon/HMG/Reload1", 34);
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
			TNT1 A 0 A_JumpIfInventory("GrabbedFlameBarrel", 1, "IdleFlameBarrel");
			TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "IdleIceBarrel");
			TNT1 A 0 A_JumpIfInventory("HMGChamberAmmo", neohmgFullAmmo, "Ready3");
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
			TNT1 A 0 PB_AmmoIntoMag("HMGChamberAmmo", "NewClip", neohmgFullAmmo, 1);
			HG0R UVWXX 1;
			HG0R YYZ 1;
			HG1R ABC 1;
			Goto Ready3;
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
