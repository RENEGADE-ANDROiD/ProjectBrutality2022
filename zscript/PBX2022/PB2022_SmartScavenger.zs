enum PB2022_SmartScavResult
{
	PB2022_SCAV_DO_NOTHING = 0,
	PB2022_SCAV_SPAWN_PARTIAL = 1,
	PB2022_SCAV_SPAWN_FULL = 2
}

class PB2022_SmartScavBase : CustomInventory
{
	int IsAmmoFull(Actor toucher, Name ammoClass, int amount)
	{
		if (!toucher || ammoClass == 'None')
			return PB2022_SCAV_DO_NOTHING;

		let type = (class<Ammo>)(ammoClass);
		if (!type)
			return PB2022_SCAV_DO_NOTHING;

		readonly<Ammo> ammoDefault = GetDefaultByType(type);
		if (!ammoDefault)
			return PB2022_SCAV_DO_NOTHING;

		let inv = Ammo(toucher.FindInventory(type));
		int current = inv ? inv.Amount : 0;
		int maxCap = ammoDefault.MaxAmount;

		if (inv)
			maxCap = inv.MaxAmount;
		else if (toucher.FindInventory("PB_Backpack"))
			maxCap = ammoDefault.BackpackMaxAmount;

		if (current >= maxCap)
			return PB2022_SCAV_DO_NOTHING;
		if (current + amount > maxCap)
			return PB2022_SCAV_SPAWN_PARTIAL;
		return PB2022_SCAV_SPAWN_FULL;
	}

	void HandleAmmoTouch(Actor toucher, Name ammoClass, int amount)
	{
		if (!toucher || !toucher.player || toucher.health <= 0)
			return;

		int result = IsAmmoFull(toucher, ammoClass, amount);
		if (result == PB2022_SCAV_DO_NOTHING)
		{
			SetStateLabel("DoNothing");
			return;
		}

		bNoInteraction = true;
		if (result == PB2022_SCAV_SPAWN_PARTIAL)
			SetStateLabel("SpawnPartial");
		else
			SetStateLabel("PickupFull");
	}

	States
	{
	DoNothing:
		"####" "#" 1;
		Fail;
	}
}

class PB2022_SmartScav_Cells : PB2022_SmartScavBase
{
	Default { Radius 1; +DONTGIB; }

	override void Touch(Actor toucher)
	{
		HandleAmmoTouch(toucher, 'PB_Cell', 100);
	}

	States
	{
	Spawn:
		YELP ABCDEFGHIJ 2;
		Loop;
	PickupFull:
		TNT1 A 0 A_SpawnItemEx("PB2022_SmartScav_CellPack");
		Stop;
	SpawnPartial:
		YELP F 15;
		YELP F 10
		{
			A_SpawnItemEx("PB_Cell", 0, 0, 0, frandom(2, 4), 0, frandom(2, 4), random(1, 360));
			A_SpawnItemEx("PB_Cell", 0, 0, 0, frandom(2, 4), 0, frandom(2, 4), random(1, 360));
			A_SpawnItemEx("PB_Cell", 0, 0, 0, frandom(2, 4), 0, frandom(2, 4), random(1, 360));
		}
		YELP F 8
		{
			A_SpawnItemEx("PB_Cell", 0, 0, 0, frandom(2, 4), 0, frandom(2, 4), random(1, 360));
			A_SpawnItemEx("PB_Cell", 0, 0, 0, frandom(2, 4), 0, frandom(2, 4), random(1, 360));
		}
		YELP F 70;
		YELP F 5 A_FadeOut(0.1);
		Stop;
	}
}

class PB2022_SmartScav_CellPack : CustomInventory
{
	Default
	{
		Inventory.PickupSound "misc/bulkcell_PickUp";
		+INVENTORY.ALWAYSPICKUP;
	}

	States
	{
		Pickup:
			TNT1 A 0 A_GiveInventory("PB_Cell", 100);
			Stop;
	}
}

class PB2022_SmartScav_Shells : PB2022_SmartScavBase
{
	Default
	{
		Radius 1;
		+DONTGIB;
		Scale 0.25; // match NewShellBox
	}

	override void Touch(Actor toucher)
	{
		HandleAmmoTouch(toucher, 'PB_Shell', 12);
	}

	States
	{
	Spawn:
		SBOX A -1;
		Stop;
	PickupFull:
		TNT1 A 0 A_SpawnItemEx("PB2022_SmartScav_ShellBox");
		Stop;
	SpawnPartial:
		SBOX A 15;
		SBOX A 10
		{
			A_SpawnItemEx("PB_Shell", 0, 0, 0, frandom(2, 4), 0, frandom(2, 4), random(1, 360));
			A_SpawnItemEx("PB_Shell", 0, 0, 0, frandom(2, 4), 0, frandom(2, 4), random(1, 360));
		}
		SBOX A 8 A_SpawnItemEx("PB_Shell", 0, 0, 0, frandom(2, 4), 0, frandom(2, 4), random(1, 360));
		SBOX A 70;
		SBOX A 5 A_FadeOut(0.1);
		Stop;
	}
}

class PB2022_SmartScav_ShellBox : CustomInventory
{
	Default
	{
		Inventory.PickupSound "misc/shellbox_PickUp";
		+INVENTORY.ALWAYSPICKUP;
	}

	States
	{
		Pickup:
			TNT1 A 0 A_GiveInventory("PB_Shell", 12);
			Stop;
	}
}

class PB2022_SmartScav_Rockets : PB2022_SmartScavBase
{
	Default { Radius 1; +DONTGIB; }

	override void Touch(Actor toucher)
	{
		HandleAmmoTouch(toucher, 'RocketAmmo', 6);
	}

	States
	{
	Spawn:
		BROK A -1;
		Stop;
	PickupFull:
		TNT1 A 0 A_SpawnItemEx("PB2022_SmartScav_RocketBox");
		Stop;
	SpawnPartial:
		BROK A 15;
		BROK A 10
		{
			A_SpawnItemEx("RocketAmmo", 0, 0, 0, frandom(2, 4), 0, frandom(2, 4), random(1, 360));
			A_SpawnItemEx("RocketAmmo", 0, 0, 0, frandom(2, 4), 0, frandom(2, 4), random(1, 360));
			A_SpawnItemEx("RocketAmmo", 0, 0, 0, frandom(2, 4), 0, frandom(2, 4), random(1, 360));
		}
		BROK A 8
		{
			A_SpawnItemEx("RocketAmmo", 0, 0, 0, frandom(2, 4), 0, frandom(2, 4), random(1, 360));
			A_SpawnItemEx("RocketAmmo", 0, 0, 0, frandom(2, 4), 0, frandom(2, 4), random(1, 360));
			A_SpawnItemEx("RocketAmmo", 0, 0, 0, frandom(2, 4), 0, frandom(2, 4), random(1, 360));
		}
		BROK A 70;
		BROK A 5 A_FadeOut(0.1);
		Stop;
	}
}

class PB2022_SmartScav_RocketBox : RocketAmmo
{
	Default
	{
		Inventory.Amount 6;
		Inventory.PickupSound "misc/rockboxa";
	}
}

class PB2022_SmartScav_HighCal : PB2022_SmartScavBase
{
	Default
	{
		Radius 1;
		+DONTGIB;
		Scale 0.18; // match NewClipBox
	}

	override void Touch(Actor toucher)
	{
		HandleAmmoTouch(toucher, 'PB_HighCalMag', 60);
	}

	States
	{
	Spawn:
		AMMO A -1;
		Stop;
	PickupFull:
		TNT1 A 0 A_SpawnItemEx("PB2022_SmartScav_HighCalBox");
		Stop;
	SpawnPartial:
		AMMO A 15;
		AMMO A 10
		{
			A_SpawnItemEx("PB_HighCalMag", 0, 0, 0, frandom(2, 4), 0, frandom(2, 4), random(1, 360));
			A_SpawnItemEx("PB_HighCalMag", 0, 0, 0, frandom(2, 4), 0, frandom(2, 4), random(1, 360));
		}
		AMMO A 8
		{
			A_SpawnItemEx("PB_HighCalMag", 0, 0, 0, frandom(2, 4), 0, frandom(2, 4), random(1, 360));
			A_SpawnItemEx("PB_HighCalMag", 0, 0, 0, frandom(2, 4), 0, frandom(2, 4), random(1, 360));
		}
		AMMO A 70;
		AMMO A 5 A_FadeOut(0.1);
		Stop;
	}
}

class PB2022_SmartScav_HighCalBox : CustomInventory
{
	Default
	{
		Inventory.PickupSound "CBOXPKUP";
		+INVENTORY.ALWAYSPICKUP;
	}

	States
	{
		Pickup:
			TNT1 A 0 A_GiveInventory("PB_HighCalMag", 60);
			Stop;
	}
}

class PB2022_SmartScav_Medikit : CustomInventory
{
	Default { Radius 1; +DONTGIB; }

	override void Touch(Actor toucher)
	{
		if (!toucher || !toucher.player || toucher.health <= 0)
			return;

		int maxHP = toucher.GetMaxHealth(true);
		int currentHP = toucher.health;
		if (currentHP >= maxHP)
			return;

		if (currentHP < 75)
			SetStateLabel("SpawnKit");
		else if (currentHP < maxHP)
			SetStateLabel("SpawnStims");
	}

	States
	{
	Spawn:
		MEDI A -1;
		Stop;
	SpawnKit:
		TNT1 A 0 A_SpawnItemEx("PB2022_SmartScav_MediPack");
		Stop;
	SpawnStims:
		MEDI A 10;
		MEDI A 5 A_SpawnItemEx("PB_Stimpack", 0, 0, 0, frandom(2, 4), 0, frandom(2, 4), random(1, 360));
		MEDI A 5 A_SpawnItemEx("PB_Stimpack", 0, 0, 0, frandom(2, 4), 0, frandom(2, 4), random(1, 360));
		MEDI A 70;
		MEDI A 5 A_FadeOut(0.1);
		Stop;
	}
}

class PB2022_SmartScav_MediPack : PB_CelebratoryHealth
{
	Default
	{
		Tag "Medikit";
		Inventory.Amount 25;
		Inventory.PickupSound "misc/L_HP_pickup";
		Inventory.PickupMessage "Medikit (+%a HP)";
		Health.LowMessage 25, "Medikit (+%a much needed HP)";
	}

	States
	{
	Spawn:
		MEDI A -1;
		Stop;
	}
}
