// PBX colored armors — PB2022-native (no PBX-Core dependency).

enum PB2022_ArmorValues : int
{
	RED_PERCENT             = 90,
	RED_AMOUNT              = 160,

	PURPLE_PERCENT          = 90,
	PURPLE_AMOUNT           = 140,

	WHITE_PERCENT           = 100,
	WHITE_AMOUNT            = 200,
	REGEN_DURATION          = -60,
	REGEN_STRENGTH          = 8,

	ORANGE_PERCENT          = 70,
	ORANGE_AMOUNT           = 160,

	YELLOW_PERCENT          = 50,
	YELLOW_AMOUNT           = 130,

	BLACK_PERCENT           = 70,
	BLACK_AMOUNT            = 160,

	DEMON_PERCENT           = 100,
	DEMON_AMOUNT            = 300,
	FRIGHTENER_DURATION     = -60,

	CYAN_PERCENT            = 100,
	CYAN_AMOUNT             = 40,
	TIMEFREEZE_DURATION     = -12,
	DOUBLESPEED_DURATION    = -12,

	DPURPLE_PERCENT         = 20,
	DPURPLE_AMOUNT          = 100,
	INFAMMO_DURATION        = -12,

	DRED_PERCENT            = 100,
	DRED_AMOUNT             = 200,

	GOLD_PERCENT            = 100,
	GOLD_AMOUNT             = 70,

	GRAY_AMOUNT             = 150,

	LBLUE_PERCENT           = 20,
	LBLUE_AMOUNT            = 200,

	LGREEN_PERCENT          = 10,
	LGREEN_AMOUNT           = 10,
	LGREEN_THRESHOLD        = 10,
	GUARDIAN_HP             = 200,
	GUARDIAN_PERCENT        = 100,
	GUARDIAN_AMOUNT         = 200,

	PINK_PERCENT            = 100,
	PINK_AMOUNT             = 200,
	STUN_MAXDURATION        = 140,
	STUN_FREQ               = 15
}

class PB2022_ColoredArmorBase : BasicArmorPickup
{
	Name armortoken;

	Default
	{
		// PBX ARM*/BRM* world art is ~170–195px; stock PB 4RM* is ~31px at Scale 1.30.
		// Without this, floor pickups tower over the player (e.g. purple ARM6).
		Scale 0.28;
		Radius 20;
		Height 20;
		+FLOORCLIP;
	}

	static bool GiveInvIfExists(Actor who, Name className, int amount = 1)
	{
		Class<Inventory> cls = (class<Inventory>)(className);
		if (!cls)
			return false;
		who.GiveInventory(cls, amount);
		return true;
	}

	virtual Name GetPickupAuraClass()
	{
		return 'None';
	}

	void EnsurePickupAura()
	{
		Name ac = GetPickupAuraClass();
		if (ac == 'None')
			return;
		if (CountInv("PB_PickupAuraSpawned") > 0)
			return;
		Class<Actor> cls = (class<Actor>)(ac);
		if (!cls)
			return;
		A_SpawnItemEx(cls, 0, 0, 0, 0, 0, 0, 0, SXF_SETMASTER | SXF_NOCHECKPOSITION);
		GiveInventory("PB_PickupAuraSpawned", 1);
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		EnsurePickupAura();
	}

	override bool TryPickup(in out Actor toucher)
	{
		bool pickup = Super.TryPickup(toucher);
		if (pickup && armortoken != 'None')
			GiveInvIfExists(toucher, armortoken, 1);
		if (pickup)
			PB_ArmorRockOn.TryPlay(toucher);
		return pickup;
	}
}

// ZScript-visible powerup types for PowerupGiver (DECORATE-only types fail compile-time lookup).
class PB2022_RegenerationPower : PowerRegeneration
{
}

class PB2022_DoubleDamagePower : PowerDamage
{
	Default
	{
		DamageFactor "Normal", 4;
	}
}

// --- Powerup token givers (granted on armor pickup) ---

class PB2022_RegenerationToken : PowerupGiver
{
	Default
	{
		Inventory.MaxAmount 0;
		Powerup.Type "PB2022_RegenerationPower";
		Powerup.Duration REGEN_DURATION;
		Powerup.Strength REGEN_STRENGTH;
		+INVENTORY.AUTOACTIVATE;
		+INVENTORY.ALWAYSPICKUP;
	}
}

class PB2022_DoubleDamageToken : PowerupGiver
{
	Default
	{
		Inventory.MaxAmount 0;
		Powerup.Type "PB2022_DoubleDamagePower";
		Powerup.Duration -30;
		+INVENTORY.AUTOACTIVATE;
		+INVENTORY.ALWAYSPICKUP;
	}
}

class PB2022_FrightenerToken : PowerupGiver
{
	Default
	{
		Inventory.MaxAmount 0;
		Powerup.Type "PowerFrightener";
		Powerup.Duration FRIGHTENER_DURATION;
		+INVENTORY.AUTOACTIVATE;
		+INVENTORY.ALWAYSPICKUP;
	}
}

class PB2022_TimeFreezerToken : PowerupGiver
{
	Default
	{
		Inventory.MaxAmount 0;
		Powerup.Type "PB_PowerTimeSlow";
		Powerup.Duration TIMEFREEZE_DURATION;
		Powerup.Color "GoldMap";
		+INVENTORY.AUTOACTIVATE;
		+INVENTORY.ALWAYSPICKUP;
	}
}

class PB2022_SpeedToken : PowerupGiver
{
	Default
	{
		Inventory.MaxAmount 0;
		Powerup.Type "PowerSpeed";
		Powerup.Duration DOUBLESPEED_DURATION;
		+INVENTORY.AUTOACTIVATE;
		+INVENTORY.ALWAYSPICKUP;
	}
}

class PB2022_InfiniteAmmoToken : PowerupGiver
{
	Default
	{
		Inventory.MaxAmount 0;
		Powerup.Type "PowerInfiniteAmmo";
		Powerup.Duration INFAMMO_DURATION;
		+INVENTORY.AUTOACTIVATE;
		+INVENTORY.ALWAYSPICKUP;
	}
}

// --- Passive armor tokens ---

class PB2022_ReactiveArmorToken : Inventory
{
	Default
	{
		Inventory.MaxAmount 1;
	}

	int integrity;
	int cooldown;

	override void DoEffect()
	{
		Super.DoEffect();
		Inventory arm = Owner.FindInventory("BasicArmor");

		if (integrity == 0)
			integrity = 200;

		if (!Owner || !arm || integrity <= 0)
		{
			if (arm)
				arm.Destroy();
			Destroy();
			return;
		}

		if (arm.Amount != integrity)
			arm.Amount = integrity;

		if (cooldown > 0)
		{
			cooldown--;
			return;
		}

		BlockThingsIterator it = BlockThingsIterator.Create(Owner, Owner.Radius + 32);
		while (it.Next())
		{
			Actor t = it.thing;
			if (!t || t == Owner || !t.bSHOOTABLE || t.Health <= 0)
				continue;

			if (Owner.Distance3D(t) <= (Owner.Radius + t.Radius + 8))
			{
				Owner.A_Explode(200, 128, XF_NOTMISSILE, false, 128);
				Owner.A_StartSound("handgrenade/Explosion", CHAN_BODY, 0, 1.0, ATTN_NORM);
				Owner.A_Quake(4, 15, 0, 400, "");

				for (int i = 0; i < 25; i++)
				{
					Owner.A_SpawnItemEx("Spark_BD1",
						0, 0, 35,
						frandom(-8, 8), frandom(-8, 8), frandom(2, 9),
						0, SXF_NOCHECKPOSITION);
				}

				Owner.A_SetBlend("Orange", 0.6, 15);

				Vector3 pushDir = t.Vec3To(Owner);
				double plen = pushDir.Length();
				if (plen > 0.001)
				{
					pushDir /= plen;
					t.Vel += pushDir * -30;
				}
				t.Vel.Z += 8;

				integrity -= 10;
				arm.Amount = integrity;
				cooldown = 20;
				break;
			}
		}
	}
}

class PB2022_MagneticToken : Inventory
{
	Default
	{
		Inventory.MaxAmount 1;
	}

	override void DoEffect()
	{
		Super.DoEffect();
		if (!Owner || Amount <= 0)
			return;

		double pickupRadius = 256.0;

		BlockThingsIterator it = BlockThingsIterator.Create(Owner, pickupRadius);
		while (it.Next())
		{
			Actor obj = it.thing;
			if (!obj || obj == Owner || !obj.bSPECIAL)
				continue;

			bool shouldPickup =
				((obj is "PB_HealthBonus") ||
				(obj is "PB_ArmorBonus") ||
				(obj is "PB_Backpack") ||
				(obj is "PB_WeaponBase") ||
				(obj is "PB_UpgradeItem") ||
				(obj is "Ammo"));

			if (shouldPickup && Owner.Distance3D(obj) <= pickupRadius)
			{
				Vector3 direction = obj.Vec3To(Owner);
				double dlen = direction.Length();
				if (dlen > 0.001)
				{
					direction /= dlen;
					obj.Vel = direction * 10;
				}
				obj.bNoFriction = true;
			}
		}
	}
}

class PB2022_AquaticToken : Inventory
{
	Default
	{
		Inventory.MaxAmount 1;
	}

	override void DoEffect()
	{
		Super.DoEffect();

		let pp = PlayerPawn(Owner);

		if (!pp || !Owner || Owner.CountInv("BasicArmor") <= 0)
		{
			if (Owner)
				Owner.Speed = Owner.Default.Speed;
			Destroy();
			return;
		}

		if (Owner.WaterLevel == 3)
			pp.ResetAirSupply();

		if (Owner.WaterLevel >= 1 && Owner.Speed != 0)
			Owner.Speed = Owner.Default.Speed * 2.5;
		else
			Owner.Speed = Owner.Default.Speed;
	}
}

class PB2022_GuardianEffectArmor : PB2022_ColoredArmorBase
{
	Default
	{
		armor.savepercent GUARDIAN_PERCENT;
		armor.saveamount GUARDIAN_AMOUNT;
	}
}

class PB2022_SecondChanceToken : Inventory
{
	Default
	{
		Inventory.MaxAmount 1;
	}

	override void DoEffect()
	{
		Super.DoEffect();

		if (!Owner)
			return;

		if (Owner.Health <= LGREEN_THRESHOLD)
		{
			Owner.A_SetHealth(GUARDIAN_HP);
			Owner.GiveInventory("PB2022_GuardianEffectArmor", 1);
			Owner.GiveInventory("PowerInvulnerable", 70);
			Owner.A_StartSound("INVUL", CHAN_ITEM, 0, 1.0, ATTN_NONE);
			Destroy();
		}
	}
}

class PB2022_EnemyStunDebuff : Inventory
{
	Default
	{
		Inventory.MaxAmount 1;
	}

	int timer;

	override void DoEffect()
	{
		Super.DoEffect();
		if (!Owner || Owner.Health <= 0)
		{
			Destroy();
			return;
		}

		if (timer == 0)
			timer = STUN_MAXDURATION;

		let pain = Owner.FindState("Pain");
		if (pain && timer % STUN_FREQ == 0)
			Owner.SetState(pain);

		if (Owner.vel.x != 0)
			Owner.Vel.X *= 0.8;

		if (Owner.vel.y != 0)
			Owner.Vel.Y *= 0.8;

		timer--;

		if (timer <= 0)
			Destroy();
	}
}

class PB2022_RepulsorToken : Inventory
{
	Default
	{
		Inventory.MaxAmount 1;
	}

	override void DoEffect()
	{
		Super.DoEffect();
		if (!Owner || Owner.CountInv("BasicArmor") <= 0)
			Destroy();
	}

	override void ModifyDamage(int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags)
	{
		if (passive && source && source != Owner)
		{
			if (damageType == 'Melee' || Owner.Distance3D(source) <= 100)
			{
				Vector3 pDir = Owner.Vec3To(source);
				double plen = pDir.Length();
				if (plen > 0.001)
				{
					pDir /= plen;
					source.Vel += pDir * 25;
				}
				source.Vel.Z += 5;
				source.GiveInventory("PB2022_EnemyStunDebuff", 1);
				newdamage = 0;
				return;
			}
		}
		Super.ModifyDamage(damage, damageType, newdamage, passive, inflictor, source, flags);
	}
}

// --- Colored armor pickups ---

class PB2022_RedArmor : PB2022_ColoredArmorBase
{
	Default
	{
		armor.savepercent RED_PERCENT;
		armor.saveamount RED_AMOUNT;
		Inventory.PickupMessage "$PBXArmors_Red";
		Inventory.AltHudIcon "ARM3A0";
		Tag "$PBXArmors_Red";
	}

	override Name GetPickupAuraClass() { return 'PB_PickupAuraRed'; }

	States
	{
	Spawn:
		ARM3 A 1 Bright;
		ARM3 A 2 Bright;
		Loop;
	}

	override bool TryPickup(in out Actor toucher)
	{
		bool pickup = Super.TryPickup(toucher);
		if (pickup)
		{
			GiveInvIfExists(toucher, 'PowerStrength');
			GiveInvIfExists(toucher, 'DemonStrengthRune');
		}
		return pickup;
	}
}

class PB2022_PurpleArmor : PB2022_ColoredArmorBase
{
	override void PostBeginPlay()
	{
		armortoken = 'PB2022_DoubleDamageToken';
		Super.PostBeginPlay();
	}

	override Name GetPickupAuraClass() { return 'PB_PickupAuraPurple'; }

	Default
	{
		armor.savepercent PURPLE_PERCENT;
		armor.saveamount PURPLE_AMOUNT;
		Inventory.PickupMessage "$PBXArmors_Purple";
		Inventory.AltHudIcon "ARM6A0";
		Tag "$PBXArmors_Purple_Tag";
	}

	States
	{
	Spawn:
		ARM6 A 1 Bright;
		ARM6 A 1 Bright;
		Loop;
	}
}

class PB2022_WhiteArmor : PB2022_ColoredArmorBase
{
	override void PostBeginPlay()
	{
		armortoken = 'PB2022_RegenerationToken';
		Super.PostBeginPlay();
	}

	override Name GetPickupAuraClass() { return 'PB_PickupAuraWhite'; }

	Default
	{
		armor.savepercent WHITE_PERCENT;
		armor.saveamount WHITE_AMOUNT;
		Inventory.PickupMessage "$PBXArmors_White";
		Inventory.AltHudIcon "ARM4A0";
		Tag "$PBXArmors_White_Tag";
	}

	States
	{
	Spawn:
		ARM4 A 1 Bright;
		ARM4 A 1 Bright;
		Loop;
	}
}

class PB2022_OrangeArmor : PB2022_ColoredArmorBase
{
	Default
	{
		armor.savepercent ORANGE_PERCENT;
		armor.saveamount ORANGE_AMOUNT;
		Inventory.PickupMessage "$PBXArmors_Orange";
		Inventory.AltHudIcon "ARM7A0";
		Tag "$PBXArmors_Orange_Tag";
	}

	override Name GetPickupAuraClass() { return 'PB_PickupAuraOrange'; }

	States
	{
	Spawn:
		ARM7 A 1 Bright;
		ARM7 A 2 Bright;
		Loop;
	}

	override bool TryPickup(in out Actor toucher)
	{
		bool pickup = Super.TryPickup(toucher);
		if (pickup)
		{
			if (!GiveInvIfExists(toucher, 'NightVision'))
				GiveInvIfExists(toucher, 'PowerLightAmp');
		}
		return pickup;
	}
}

class PB2022_YellowArmor : PB2022_ColoredArmorBase
{
	override void PostBeginPlay()
	{
		armortoken = 'PB_Backpack';
		Super.PostBeginPlay();
	}

	override Name GetPickupAuraClass() { return 'PB_PickupAuraYellow'; }

	Default
	{
		armor.savepercent YELLOW_PERCENT;
		armor.saveamount YELLOW_AMOUNT;
		Inventory.PickupMessage "$PBXArmors_Yellow";
		Inventory.AltHudIcon "ARM5A0";
		Tag "$PBXArmors_Yellow_Tag";
	}

	States
	{
	Spawn:
		ARM5 A 1 Bright;
		ARM5 A 2 Bright;
		Loop;
	}
}

class PB2022_BlackArmor : PB2022_ColoredArmorBase
{
	override void PostBeginPlay()
	{
		armortoken = 'PB_Backpack';
		Super.PostBeginPlay();
	}

	override Name GetPickupAuraClass() { return 'PB_PickupAuraGray'; }

	Default
	{
		armor.savepercent BLACK_PERCENT;
		armor.saveamount BLACK_AMOUNT;
		Inventory.PickupMessage "$PBXArmors_Black";
		Inventory.AltHudIcon "ARM8A0";
		Tag "$PBXArmors_Black_Tag";
	}

	States
	{
	Spawn:
		ARM8 A 1 Bright;
		ARM8 A 2 Bright;
		Loop;
	}
}

class PB2022_DemonArmor : PB2022_ColoredArmorBase
{
	Default
	{
		armor.savepercent DEMON_PERCENT;
		armor.saveamount DEMON_AMOUNT;
		Inventory.PickupMessage "$PBXArmors_Demon";
		Inventory.AltHudIcon "ARM9A0";
		Tag "$PBXArmors_Demon_Tag";
	}

	override Name GetPickupAuraClass() { return 'PB_PickupAuraRed'; }

	States
	{
	Spawn:
		ARM9 A 6 Bright;
		ARM9 B 6 Bright;
		ARM9 C 6 Bright;
		ARM9 B 6 Bright;
		Loop;
	}

	override bool TryPickup(in out Actor toucher)
	{
		bool pickup = Super.TryPickup(toucher);
		if (pickup)
		{
			GiveInvIfExists(toucher, 'PB2022_FrightenerToken');
			GiveInvIfExists(toucher, 'PowerStrength');
			GiveInvIfExists(toucher, 'DemonStrengthRune');
			GiveInvIfExists(toucher, 'PB2022_DoubleDamageToken');
		}
		return pickup;
	}
}

class PB2022_CyanArmor : PB2022_ColoredArmorBase
{
	Default
	{
		armor.savepercent CYAN_PERCENT;
		armor.saveamount CYAN_AMOUNT;
		Inventory.PickupMessage "$PBXArmors_Cyan";
		Inventory.AltHudIcon "BRM1A0";
		Tag "$PBXArmors_Cyan_Tag";
	}

	override Name GetPickupAuraClass() { return 'PB_PickupAuraCyan'; }

	States
	{
	Spawn:
		BRM1 ABAA 2 Bright;
		Loop;
	}

	override bool TryPickup(in out Actor toucher)
	{
		bool pickup = Super.TryPickup(toucher);
		if (pickup)
		{
			GiveInvIfExists(toucher, 'PB2022_TimeFreezerToken');
			GiveInvIfExists(toucher, 'PB2022_SpeedToken');
		}
		return pickup;
	}
}

class PB2022_DarkPurpleArmor : PB2022_ColoredArmorBase
{
	override void PostBeginPlay()
	{
		armortoken = 'PB2022_InfiniteAmmoToken';
		Super.PostBeginPlay();
	}

	override Name GetPickupAuraClass() { return 'PB_PickupAuraPurple'; }

	Default
	{
		armor.savepercent DPURPLE_PERCENT;
		armor.saveamount DPURPLE_AMOUNT;
		Inventory.PickupMessage "$PBXArmors_DarkPurple";
		Inventory.AltHudIcon "BRM4A0";
		Tag "$PBXArmors_DrkPurple_Tag";
	}

	States
	{
	Spawn:
		BRM4 A 1;
		BRM4 B 1 Bright;
		Loop;
	}
}

class PB2022_DarkRedArmor : PB2022_ColoredArmorBase
{
	override void PostBeginPlay()
	{
		armortoken = 'PB2022_ReactiveArmorToken';
		Super.PostBeginPlay();
	}

	override Name GetPickupAuraClass() { return 'PB_PickupAuraRed'; }

	Default
	{
		armor.savepercent DRED_PERCENT;
		armor.saveamount DRED_AMOUNT;
		Inventory.PickupMessage "$PBXArmors_DarkRed";
		Inventory.AltHudIcon "BRM7A0";
		Tag "$PBXArmors_DarkRed_Tag";
	}

	States
	{
	Spawn:
		BRM7 A 1 Bright;
		BRM7 B 1 Bright;
		Loop;
	}
}

class PB2022_GoldArmor : PB2022_ColoredArmorBase
{
	override void PostBeginPlay()
	{
		armortoken = 'PB2022_MagneticToken';
		Super.PostBeginPlay();
	}

	override Name GetPickupAuraClass() { return 'PB_PickupAuraYellow'; }

	Default
	{
		armor.savepercent GOLD_PERCENT;
		armor.saveamount GOLD_AMOUNT;
		Inventory.PickupMessage "$PBXArmors_Gold";
		Inventory.AltHudIcon "BRM2A0";
		Tag "$PBXArmors_Gold_Tag";
	}

	States
	{
	Spawn:
		BRM2 A 1 Bright;
		BRM2 A 1 Bright;
		Loop;
	}
}

class PB2022_GrayArmor : PB2022_ColoredArmorBase
{
	Default
	{
		Inventory.AltHudIcon "DUMYA0";
		Tag "$PBXArmors_Gray_Tag";
	}

	override Name GetPickupAuraClass() { return 'PB_PickupAuraGray'; }

	States
	{
	Spawn:
		DUMY A 1 Bright;
		DUMY A 1 Bright;
		Loop;
	}

	override bool TryPickup(in out Actor toucher)
	{
		int rPercent = Random(0, 2);
		int rAmount = Random(1, GRAY_AMOUNT);

		switch (rPercent)
		{
		case 0: rPercent = 33; break;
		case 1: rPercent = 50; break;
		case 2: rPercent = 70; break;
		}

		SavePercent = rPercent;
		SaveAmount = rAmount;

		bool pickedUp = Super.TryPickup(toucher);

		if (pickedUp)
			toucher.A_Log(String.Format(StringTable.Localize("$PBXArmors_Gray"), rAmount, rPercent));

		return pickedUp;
	}
}

class PB2022_LightBlueArmor : PB2022_ColoredArmorBase
{
	override void PostBeginPlay()
	{
		armortoken = 'PB2022_AquaticToken';
		Super.PostBeginPlay();
	}

	override Name GetPickupAuraClass() { return 'PB_PickupAuraBlue'; }

	Default
	{
		armor.savepercent LBLUE_PERCENT;
		armor.saveamount LBLUE_AMOUNT;
		Inventory.PickupMessage "$PBXArmors_LightBlue";
		Inventory.AltHudIcon "BRM3A0";
		Tag "$PBXArmors_LightBlue";
	}

	States
	{
	Spawn:
		BRM3 A 1 Bright;
		BRM3 A 1 Bright;
		Loop;
	}
}

class PB2022_LightGreenArmor : PB2022_ColoredArmorBase
{
	override void PostBeginPlay()
	{
		armortoken = 'PB2022_SecondChanceToken';
		Super.PostBeginPlay();
	}

	override Name GetPickupAuraClass() { return 'PB_PickupAuraGreen'; }

	Default
	{
		armor.savepercent LGREEN_PERCENT;
		armor.saveamount LGREEN_AMOUNT;
		Inventory.PickupMessage "$PBXArmors_LightGreen";
		Inventory.AltHudIcon "BRM6A0";
		Tag "$PBXArmors_LGreen_Tag";
	}

	States
	{
	Spawn:
		BRM6 A 1 Bright;
		BRM6 A 1 Bright;
		Loop;
	}
}

class PB2022_PinkArmor : PB2022_ColoredArmorBase
{
	override void PostBeginPlay()
	{
		armortoken = 'PB2022_RepulsorToken';
		Super.PostBeginPlay();
	}

	override Name GetPickupAuraClass() { return 'PB_PickupAuraPink'; }

	Default
	{
		armor.savepercent PINK_PERCENT;
		armor.saveamount PINK_AMOUNT;
		Inventory.PickupMessage "$PBXArmors_Pink";
		Inventory.AltHudIcon "BRM5A0";
		Tag "$PBXArmors_Pink";
	}

	States
	{
	Spawn:
		BRM5 A 1 Bright;
		BRM5 A 1 Bright;
		Loop;
	}
}
