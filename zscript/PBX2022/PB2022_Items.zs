// PBX-Items enhanced powerups — PB2022-native (HyperExia / Unless You Got Powah lineage).

enum PB2022_ItemsTipFlags
{
	PB2022_Tip_BlackBlur       = 1 << 0,
	PB2022_Tip_DeflectSphere   = 1 << 1,
	PB2022_Tip_ElectricAura    = 1 << 2,
	PB2022_Tip_GoldInvul       = 1 << 3,
	PB2022_Tip_LegendSphere    = 1 << 4,
	PB2022_Tip_LifestealOrb    = 1 << 5,
	PB2022_Tip_TerrorSphere    = 1 << 6,
	PB2022_Tip_AmmoSphere      = 1 << 7,
	PB2022_Tip_GuardSphere     = 1 << 8,
	PB2022_Tip_RegenSphere     = 1 << 9,
	PB2022_Tip_RedSoul         = 1 << 10,
	PB2022_Tip_DarkMega        = 1 << 11,
	PB2022_Tip_Adrenaline      = 1 << 12
}

enum PB2022_ItemsValues
{
	MEGABERSERK_HP   = 200,
	MEGABERSERK_MAX  = 200,

	SUPERSPHERE_HP   = 100,
	SUPERSPHERE_MAX  = 200,

	SUPERARMOR_SV    = 70,
	SUPERARMOR_AMT   = 100,

	HYPERSPHERE_HP   = 300,
	HYPERSPHERE_MAX  = 300,
	HYPERARMOR_SV    = 70,
	HYPERARMOR_AMT   = 300,

	MINISPHERE_HP    = 50,
	MINISPHERE_MAX   = 200,
	MINIARMOR_SV     = 60,
	MINIARMOR_AMT    = 50,

	REDSOUL_HP       = 150,
	REDSOUL_MAX      = 200,

	DARKMEGA_HP      = 200,
	DARKMEGA_MAX     = 200,

	ADRENAL_DURATION = -15
}

class PB2022_ItemsUtil
{
	static void TryMugshot(Actor who, Name mugState)
	{
		let cv = CVar.FindCVar("pb_newmugshot");
		if (!cv || !cv.GetBool() || !who)
			return;
		// PB2022 HUD reads pb_newmugshot; no A_SetMugshotState hook in this tree.
	}
}

class PB2022_HealthPickup : CustomInventory
{
	int ownrhp;

	Default
	{
		+COUNTITEM;
		+INVENTORY.ALWAYSPICKUP;
		+DONTGIB;
		+FLOATBOB;
	}

	override bool TryPickup(in out Actor toucher)
	{
		ownrhp = toucher ? toucher.health : 0;
		return Super.TryPickup(toucher);
	}

	protected void GiveBody(int amount, int maxCap)
	{
		if (!owner)
			return;
		owner.GiveInventory("SoulSphereHealth", 1);
		owner.A_SetHealth(min(owner.health + amount, maxCap));
	}
}

class PB2022_BerserkPickup : PB2022_HealthPickup
{
	Default
	{
		+FLOORCLIP;
		Inventory.PickupSound "BERSPKUP";
	}
}

class PB2022_SoulspherePickup : PB2022_HealthPickup
{
	Default
	{
		Inventory.PickupSound "SSPH";
	}
}

class PB2022_MegaspherePickup : PB2022_HealthPickup
{
	Default
	{
		Inventory.PickupSound "MEGASPH";
	}
}

class PB2022_MegaBerserk : PB2022_BerserkPickup
{
	Default
	{
		Tag "Mega Berserk Pack";
	}

	override bool TryPickup(in out Actor toucher)
	{
		ownrhp = toucher ? toucher.health : 0;
		bool ok = Super.TryPickup(toucher);
		if (ok && toucher)
		{
			int gained = max(0, MEGABERSERK_HP - ownrhp);
			if (ownrhp < 25)
				toucher.A_Print(String.Format("Mega Berserk Pack (+%d much needed HP)", gained));
			else
				toucher.A_Print(String.Format("Mega Berserk Pack (+%d HP)", gained));
		}
		return ok;
	}

	override bool Use(bool pickup)
	{
		owner.A_GiveInventory("PowerStrength", 1);
		GiveBody(MEGABERSERK_HP, MEGABERSERK_MAX);
		owner.A_SetBlend("Red", 0.75, 16);
		PB2022_ItemsUtil.TryMugshot(owner, 'BerserkGrin');
		return true;
	}

	States
	{
		Spawn:
			PSTR C -1;
			Stop;
	}
}

class PB2022_SuperSphere : PB2022_SoulspherePickup
{
	Default
	{
		Tag "SuperSphere";
	}

	override bool TryPickup(in out Actor toucher)
	{
		ownrhp = toucher ? toucher.health : 0;
		bool ok = Super.TryPickup(toucher);
		if (ok && toucher)
		{
			int gain = clamp(min(SUPERSPHERE_HP, SUPERSPHERE_MAX - ownrhp), 0, SUPERSPHERE_HP);
			if (ownrhp < 25)
				toucher.A_Print(String.Format("SuperSphere (+%d much needed HP)", gain));
			else
				toucher.A_Print(String.Format("SuperSphere (+%d HP)", gain));
		}
		return ok;
	}

	override bool Use(bool pickup)
	{
		owner.A_SetBlend("Blue", 0.75, 16);
		GiveBody(SUPERSPHERE_HP, SUPERSPHERE_MAX);
		PB2022_ItemsUtil.TryMugshot(owner, 'SoulsphereGrin');
		return true;
	}

	States
	{
		Spawn:
			SPRS ABCDEFGHIJ 3;
			Loop;
	}
}

class PB2022_SuperArmor : BasicArmorPickup
{
	Default
	{
		Armor.SavePercent SUPERARMOR_SV;
		Armor.SaveAmount SUPERARMOR_AMT;
		Inventory.PickupMessage "Super armor!";
		Inventory.AltHudIcon "ULTRA0";
		Tag "Super Armor";
		+INVENTORY.ALWAYSPICKUP;
	}
}

class PB2022_UltraSphere : PB2022_MegaspherePickup
{
	Default
	{
		Inventory.PickupMessage "Ultrasphere!";
		Tag "Ultrasphere";
	}

	override bool Use(bool pickup)
	{
		owner.A_SetBlend("White", 0.75, 16);
		owner.A_GiveInventory("PB2022_SuperArmor", 1);
		GiveBody(SUPERSPHERE_HP, SUPERSPHERE_MAX);
		PB2022_ItemsUtil.TryMugshot(owner, 'MegasphereGrin');
		return true;
	}

	States
	{
		Spawn:
			ULTR ABCD 3;
			Loop;
	}
}

class PB2022_HyperArmor : BasicArmorPickup
{
	Default
	{
		Armor.SavePercent HYPERARMOR_SV;
		Armor.SaveAmount HYPERARMOR_AMT;
		Inventory.PickupMessage "Hyper armor!";
		Inventory.AltHudIcon "DDMGA0";
		Tag "Hyper Armor";
		+INVENTORY.ALWAYSPICKUP;
	}
}

class PB2022_HyperSphere : PB2022_MegaspherePickup
{
	Default
	{
		Inventory.PickupMessage "Hypersphere!";
		Tag "Hypersphere";
	}

	override bool Use(bool pickup)
	{
		owner.A_SetBlend("White", 0.75, 16);
		owner.A_GiveInventory("PB2022_HyperArmor", 1);
		GiveBody(HYPERSPHERE_HP, HYPERSPHERE_MAX);
		PB2022_ItemsUtil.TryMugshot(owner, 'MegasphereGrin');
		return true;
	}

	States
	{
		Spawn:
			DDMG AAABBBCCCDDD 2 Bright;
			Loop;
	}
}

class PB2022_MiniArmor : BasicArmorPickup
{
	Default
	{
		Armor.SavePercent MINIARMOR_SV;
		Armor.SaveAmount MINIARMOR_AMT;
		Inventory.PickupMessage "Mini armor!";
		Inventory.AltHudIcon "ARM5A0";
		Tag "Mini Armor";
		+INVENTORY.ALWAYSPICKUP;
	}
}

class PB2022_MiniSphere : PB2022_MegaspherePickup
{
	Default
	{
		Inventory.PickupMessage "Mini sphere!";
		Inventory.PickupSound "SSPH";
		Tag "Mini Sphere";
		Scale 0.28; // ARM5 hi-res armor art (~169px); match ColoredArmorBase
	}

	override bool Use(bool pickup)
	{
		owner.A_SetBlend("White", 0.75, 16);
		owner.A_GiveInventory("PB2022_MiniArmor", 1);
		GiveBody(MINISPHERE_HP, MINISPHERE_MAX);
		PB2022_ItemsUtil.TryMugshot(owner, 'MegasphereGrin');
		return true;
	}

	States
	{
		Spawn:
			ARM5 A 2 Bright;
			Loop;
	}
}

class PB2022_CorpseDrained : Inventory
{
	Default
	{
		Inventory.MaxAmount 1;
		+INVENTORY.UNDROPPABLE;
	}
}

class PB2022_RedSoulSphere : PB2022_HealthPickup
{
	int damageTimer;
	int corpseTimer;

	Default
	{
		Inventory.PickupMessage "Red Soulsphere!";
		Inventory.PickupSound "SSPH";
		Tag "Red Soulsphere";
		floatbobstrength 0.4;
	}

	override bool Use(bool pickup)
	{
		owner.A_SetBlend("Red", 0.75, 16);
		GiveBody(REDSOUL_HP, REDSOUL_MAX);
		return true;
	}

	override void Tick()
	{
		Super.Tick();

		if (level.isFrozen())
			return;

		damageTimer++;
		corpseTimer++;

		if (GetAge() % Random(17, 28) == 0)
			SpawnParticle();

		if (damageTimer >= 35)
		{
			damageTimer = 0;
			DamageNearbyPlayers();
		}

		if (corpseTimer >= 175)
		{
			corpseTimer = 0;
			SpawnSoulsFromCorpses();
		}
	}

	void SpawnParticle()
	{
		A_SpawnParticleEx(
			"FF0000",
			TexMan.CheckForTexture("DROPA0"),
			style: STYLE_Add,
			flags: SPF_FULLBRIGHT|SPF_RELATIVE,
			lifetime: 15,
			size: 2.0,
			angle: 0,
			xoff: FRandom(-3, 3),
			yoff: FRandom(-3, 3),
			zoff: 15,
			velz: -0.01,
			accelz: -0.4,
			startalphaf: 1.0,
			fadestepf: -0.2,
			sizestep: 0,
			startroll: 0
		);
	}

	void DamageNearbyPlayers()
	{
		BlockThingsIterator it = BlockThingsIterator.Create(self, 256);
		while (it.Next())
		{
			let obj = it.thing;
			if (obj.player && obj.health > 0 && Distance3D(obj) <= 256)
				obj.DamageMobj(self, self, 1, "Normal");
		}
	}

	void SpawnSoulsFromCorpses()
	{
		BlockThingsIterator it = BlockThingsIterator.Create(self, 256);
		while (it.Next())
		{
			let obj = it.thing;
			if (obj is "PB_CurbstompedMarine"
				&& obj.GetClassName() != 'PB_LostSoul'
				&& obj.GetClassName() != 'PB_PainElemental'
				&& Distance3D(obj) <= 256
				&& !obj.CheckInventory("PB2022_CorpseDrained", 1))
			{
				obj.Spawn("PB_LostSoul", obj.Vec3Offset(0, 0, 20), NO_REPLACE);
				obj.Spawn("TeleportFog", obj.Vec3Offset(0, 0, 20), NO_REPLACE);
				obj.GiveInventory("PB2022_CorpseDrained", 1);
				obj.A_SetRenderStyle(0.4, STYLE_Translucent);
			}
		}
	}

	States
	{
		Spawn:
			TSOU ABCDCB 6 Bright;
			Loop;
	}
}

class PB2022_TaintedRegenGiver : PowerupGiver
{
	Default
	{
		Inventory.MaxAmount 0;
		+INVENTORY.AUTOACTIVATE;
		+INVENTORY.ALWAYSPICKUP;
		Powerup.Type "PB2022_RegenerationPower";
	}
}

class PB2022_DarkMegaSphere : PB2022_HealthPickup
{
	Default
	{
		Inventory.PickupMessage "Dark Megasphere!";
		Inventory.PickupSound "MEGASPH";
		+VISIBILITYPULSE;
		Tag "Dark Megasphere";
		floatbobstrength 0.4;
	}

	override bool Use(bool pickup)
	{
		owner.A_SetBlend("DarkOrange", 0.75, 16);
		GiveBody(DARKMEGA_HP, DARKMEGA_MAX);
		owner.A_GiveInventory("PB2022_SuperArmor", 1);
		owner.A_GiveInventory("PB2022_TaintedRegenGiver", 1);
		PB2022_ItemsUtil.TryMugshot(owner, 'MegasphereGrin');
		return true;
	}

	override void Tick()
	{
		Super.Tick();

		double a = FRandom(1, 360);
		double b = FRandom(-20, 20) + FRandom(-20, 20);

		A_SpawnParticleEx(
			"BB0055",
			TexMan.CheckForTexture("STARA0"),
			style: STYLE_Add,
			flags: SPF_FULLBRIGHT,
			lifetime: 35,
			size: 3.0,
			angle: a,
			xoff: cos(a) * cos(b) * 20,
			yoff: sin(a) * cos(b) * 20,
			zoff: sin(b) * 20 + 26,
			velx: cos(a) * cos(b) * 0.2,
			vely: sin(a) * cos(b) * 0.2,
			velz: sin(b) * 0.2,
			startalphaf: 1.0,
			fadestepf: -0.1,
			sizestep: -0.1,
			startroll: 0
		);

		BlockThingsIterator it = BlockThingsIterator.Create(self, 256);
		while (it.Next())
		{
			let obj = it.thing;
			if (obj && obj is "PB_Monster" && obj.bISMONSTER && Distance3D(obj) <= 256
				&& !obj.bCORPSE && obj.health < obj.SpawnHealth())
			{
				obj.A_SpawnParticleEx(
					"BB0055",
					TexMan.CheckForTexture("STARA0"),
					style: STYLE_Add,
					flags: SPF_FULLBRIGHT|SPF_RELATIVE|SPF_ROLL,
					lifetime: 50,
					size: 0.5,
					angle: 0,
					xoff: FRandom(obj.radius, -obj.radius),
					yoff: FRandom(obj.radius, -obj.radius),
					zoff: 0,
					velx: FRandom(0.5, -0.5),
					vely: FRandom(0.5, -0.5),
					velz: FRandom(0.4, 3.0),
					accelz: -0.001,
					startalphaf: 1.25,
					fadestepf: -0.002,
					sizestep: 0.15,
					startroll: 90,
					rollvel: 0,
					rollacc: 0
				);
				obj.health++;
			}
		}
	}

	States
	{
		Spawn:
			TMEG ABCDCB 6 Bright;
			Loop;
	}
}

class PB2022_AdreSpdGiver : PowerupGiver
{
	Default
	{
		Inventory.MaxAmount 0;
		+INVENTORY.AUTOACTIVATE;
		+INVENTORY.ALWAYSPICKUP;
		Powerup.Type "PowerSpeed";
		Powerup.Duration ADRENAL_DURATION;
	}
}

class PB2022_AdrePowGiver : PowerupGiver
{
	Default
	{
		Inventory.MaxAmount 0;
		+INVENTORY.AUTOACTIVATE;
		+INVENTORY.ALWAYSPICKUP;
		Powerup.Type "PowerDamage";
		Powerup.Duration ADRENAL_DURATION;
	}
}

class PB2022_Adrenaline : CustomInventory
{
	Default
	{
		Inventory.PickupMessage "Adrenaline!";
		Inventory.PickupSound "misc/p_pkup";
		Tag "Adrenaline";
		+INVENTORY.ALWAYSPICKUP;
		+COUNTITEM;
		+DONTGIB;
	}

	override bool Use(bool pickup)
	{
		owner.A_SetBlend("Red", 0.75, 16);
		owner.A_GiveInventory("PB2022_AdreSpdGiver", 1);
		owner.A_GiveInventory("PB2022_AdrePowGiver", 1);
		return true;
	}

	States
	{
		Spawn:
			ADRN A -1;
			Stop;
	}
}
