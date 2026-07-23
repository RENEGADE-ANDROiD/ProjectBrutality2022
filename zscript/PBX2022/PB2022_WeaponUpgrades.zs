class SGLUpgraded : Inventory { Default { Inventory.MaxAmount 1; } }
class LMGUpgraded : Inventory { Default { Inventory.MaxAmount 1; } }
class SelectSGL_No : Inventory { Default { Inventory.MaxAmount 1; } }
class MetalSniperUpgraded : Inventory { Default { Inventory.MaxAmount 1; } }
class BattleRifleUpgraded : Inventory { Default { Inventory.MaxAmount 1; } }

class PB2022_SGL_Upgrade : PB_UpgradeItem
{
	Default
	{
		Height 24;
		-INVENTORY.ALWAYSPICKUP;
		-COUNTITEM;
		Inventory.PickupSound "misc/rockboxa";
		Inventory.PickupMessage "$PB2022_SGLUPGRADE_PICKUP";
		Tag "$PB2022_SGLUPGRADE_TAG";
		Scale 0.52;
		FloatBobStrength 0.5;
	}

	States
	{
	Spawn:
		BSGL A -1;
		Stop;
	Pickup:
		TNT1 A 0 A_JumpIf(FindInventory("PB_SuperGL") && !FindInventory("SGLUpgraded") && CountInv("RocketAmmo") >= GetAmmoCapacity("RocketAmmo"), "DoUpgrade");
		Fail;
	DoUpgrade:
		TNT1 A 0
		{
			A_GiveInventory("SGLUpgraded", 1);
			A_Print("$PB2022_SGLUPGRADE_DONE");
		}
		Stop;
	}
}

class PB2022_LMG_Upgrade : PB_UpgradeItem
{
	Default
	{
		Height 24;
		-INVENTORY.ALWAYSPICKUP;
		-COUNTITEM;
		Inventory.PickupSound "LLIDOP";
		Inventory.PickupMessage "$PB2022_LMGUPGRADE_PICKUP";
		Tag "$PB2022_LMGUPGRADE_TAG";
		Scale 0.52;
		FloatBobStrength 0.5;
	}

	States
	{
	Spawn:
		LMPU A -1;
		Stop;
	Pickup:
		TNT1 A 0 A_JumpIf(FindInventory("PB_LMG") && !FindInventory("LMGUpgraded") && CountInv("PB_HighCalMag") >= GetAmmoCapacity("PB_HighCalMag"), "DoUpgrade");
		Fail;
	DoUpgrade:
		TNT1 A 0
		{
			A_GiveInventory("LMGUpgraded", 1);
			A_Print("$PB2022_LMGUPGRADE_DONE");
		}
		Stop;
	}
}

class PB2022_MetalSniper_Upgrade : PB_UpgradeItem
{
	Default
	{
		Height 24;
		-INVENTORY.ALWAYSPICKUP;
		-COUNTITEM;
		Inventory.PickupSound "MS/Button";
		Inventory.PickupMessage "$PB2022_MSUPGRADE_PICKUP";
		Scale 0.52;
	}

	States
	{
	Spawn:
		MSNU A -1;
		Stop;
	Pickup:
		TNT1 A 0 A_JumpIf(FindInventory("PB_MetalSniper") && !FindInventory("MetalSniperUpgraded"), "DoUpgrade");
		Fail;
	DoUpgrade:
		TNT1 A 0
		{
			A_GiveInventory("MetalSniperUpgraded", 1);
			A_Print("$PB2022_MSUPGRADE_DONE");
		}
		Stop;
	}
}

class PB2022_BattleRifle_Upgrade : PB_UpgradeItem
{
	Default
	{
		Height 24;
		-INVENTORY.ALWAYSPICKUP;
		-COUNTITEM;
		Inventory.PickupSound "weapons/battlerifle/up";
		Inventory.PickupMessage "$PB2022_BRUPGRADE_PICKUP";
		Scale 0.52;
		FloatBobStrength 0.5;
	}

	States
	{
	Spawn:
		BR45 A -1;
		Stop;
	Pickup:
		TNT1 A 0 A_JumpIf(FindInventory("BDPBattleRifle") && !FindInventory("BattleRifleUpgraded"), "DoUpgrade");
		Fail;
	DoUpgrade:
		TNT1 A 0
		{
			A_GiveInventory("BattleRifleUpgraded", 1);
			A_Print("$PB2022_BRUPGRADE_DONE");
		}
		Stop;
	}
}

class PB2022_SmartScavHandler : EventHandler
{
	override void CheckReplacement(ReplaceEvent e)
	{
		if (PB2022_AddonsUtil.AddonDisabled(PB2022_DisableSmartScav))
			return;

		Name rep = e.Replacee.GetClassName();
		if (rep == 'PB_CellPack' && !PB2022_AddonsUtil.SmartScavDisabled(PB2022_DisableSmartScavCellPack))
			e.Replacement = 'PB2022_SmartScav_Cells';
		else if (rep == 'NewShellBox' && !PB2022_AddonsUtil.SmartScavDisabled(PB2022_DisableSmartScavShellBox))
			e.Replacement = 'PB2022_SmartScav_Shells';
		else if (rep == 'NewRocketBox' && !PB2022_AddonsUtil.SmartScavDisabled(PB2022_DisableSmartScavRocketBox))
			e.Replacement = 'PB2022_SmartScav_Rockets';
		else if (rep == 'NewClipBox' && !PB2022_AddonsUtil.SmartScavDisabled(PB2022_DisableSmartScavHighCalBox))
			e.Replacement = 'PB2022_SmartScav_HighCal';
		else if (rep == 'PB_Medikit' && !PB2022_AddonsUtil.SmartScavDisabled(PB2022_DisableSmartScavMedikit))
			e.Replacement = 'PB2022_SmartScav_Medikit';
	}
}

class PB2022_AddonsHandler : EventHandler
{
	override void PlayerEntered(PlayerEvent e)
	{
		let pm = players[e.PlayerNumber].mo;
		if (!pm || level.MapName == "TITLEMAP")
			return;

		if (!pm.FindInventory("PB2022_BackpackReloadItem"))
			pm.GiveInventory("PB2022_BackpackReloadItem", 1);
	}
}

class PB2022_ItemArmorSpawnHandler : EventHandler
{
	override void CheckReplacement(ReplaceEvent e)
	{
		Name rep = e.Replacee.GetClassName();

		if (rep == 'Soulsphere' && !PB2022_AddonsUtil.ItemSpawnDisabled(PB2022_DisableSuperSphere))
		{
			if (random(0, 255) < 64)
				e.Replacement = 'PB2022_SuperSphere';
		}
		else if (rep == 'Megasphere' && !PB2022_AddonsUtil.ItemSpawnDisabled(PB2022_DisableUltraSphere))
		{
			if (random(0, 255) < 48)
				e.Replacement = 'PB2022_UltraSphere';
		}
		else if (rep == 'Berserk' && !PB2022_AddonsUtil.ItemSpawnDisabled(PB2022_DisableMegaBerserk))
		{
			if (random(0, 255) < 32)
				e.Replacement = 'PB2022_MegaBerserk';
		}
		else if (rep == 'BlueArmor' && !PB2022_AddonsUtil.ArmorSpawnDisabled(PB2022_DisableRedArmor))
		{
			if (random(0, 255) < 40)
				e.Replacement = 'PB2022_RedArmor';
		}
		else if (rep == 'GreenArmor' && !PB2022_AddonsUtil.ArmorSpawnDisabled(PB2022_DisablePurpleArmor))
		{
			if (random(0, 255) < 40)
				e.Replacement = 'PB2022_PurpleArmor';
		}
	}
}
