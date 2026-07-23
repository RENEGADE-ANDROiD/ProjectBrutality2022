// PBX Staging addon ports — shared flags / helpers (PB 2022 native; no PBX-Core dependency).

enum PB2022_AddonsSettingsFlags
{
	PB2022_DisableSmartScav      = 1 << 0,
	PB2022_DisableDamageIndicators = 1 << 2,
	PB2022_DisableBackpackReload = 1 << 4,
	PB2022_DisableWeaponUpgrades = 1 << 5
}

enum PB2022_SmartScavFlags
{
	PB2022_DisableSmartScavCellPack   = 1 << 0,
	PB2022_DisableSmartScavShellBox    = 1 << 1,
	PB2022_DisableSmartScavRocketBox   = 1 << 2,
	PB2022_DisableSmartScavHighCalBox  = 1 << 3,
	PB2022_DisableSmartScavLowCalBox   = 1 << 4,
	PB2022_DisableSmartScavMedikit     = 1 << 5
}

enum PB2022_WeaponUpgradeFlags
{
	PB2022_DisableSGLUpgrade = 1 << 0,
	PB2022_DisableLMGUpgrade = 1 << 1
}

enum PB2022_ItemsSpawnFlags
{
	PB2022_DisableMegaBerserk   = 1 << 0,
	PB2022_DisableSuperSphere   = 1 << 1,
	PB2022_DisableUltraSphere   = 1 << 2,
	PB2022_DisableHyperSphere   = 1 << 3,
	PB2022_DisableMiniSphere    = 1 << 4,
	PB2022_DisableBlackBlur     = 1 << 5,
	PB2022_DisableRedSoul       = 1 << 16,
	PB2022_DisableDarkMega      = 1 << 17,
	PB2022_DisableAdrenaline     = 1 << 18
}

enum PB2022_ArmorSpawnFlags
{
	PB2022_DisableRedArmor        = 1 << 0,
	PB2022_DisablePurpleArmor     = 1 << 1,
	PB2022_DisableWhiteArmor      = 1 << 2,
	PB2022_DisableOrangeArmor     = 1 << 3,
	PB2022_DisableYellowArmor     = 1 << 4,
	PB2022_DisableBlackArmor      = 1 << 5,
	PB2022_DisableDemonArmor      = 1 << 6,
	PB2022_DisableCyanArmor       = 1 << 7,
	PB2022_DisableDarkPurpleArmor = 1 << 8,
	PB2022_DisableDarkRedArmor    = 1 << 9,
	PB2022_DisableGoldArmor       = 1 << 10,
	PB2022_DisableGrayArmor       = 1 << 11,
	PB2022_DisableLightBlueArmor  = 1 << 12,
	PB2022_DisableLightGreenArmor = 1 << 13,
	PB2022_DisablePinkArmor       = 1 << 14
}

class PB2022_AddonsUtil
{
	static bool FeatureOn(Name boolCvar, int disableBit)
	{
		let cv = CVar.FindCVar(boolCvar);
		if (cv && !cv.GetBool())
			return false;
		return !AddonDisabled(disableBit);
	}

	static bool AddonDisabled(int flagBit)
	{
		let cv = CVar.FindCVar("pb_pbx_addons_flags");
		if (!cv) return false;
		return (cv.GetInt() & flagBit) != 0;
	}

	static bool SmartScavDisabled(int flagBit)
	{
		if (!FeatureOn("pb_pbx_smartscav", PB2022_DisableSmartScav))
			return true;
		let cv = CVar.FindCVar("pb_pbx_smartscav_flags");
		if (!cv) return false;
		return (cv.GetInt() & flagBit) != 0;
	}

	static bool WeaponUpgradeDisabled(int flagBit)
	{
		if (!FeatureOn("pb_pbx_weapon_upgrades", PB2022_DisableWeaponUpgrades))
			return true;
		let cv = CVar.FindCVar("pb_pbx_weapon_upgrade_flags");
		if (!cv) return false;
		return (cv.GetInt() & flagBit) != 0;
	}

	static bool ItemSpawnDisabled(int flagBit)
	{
		let cv = CVar.FindCVar("pb_pbx_items_flags");
		if (!cv) return false;
		return (cv.GetInt() & flagBit) != 0;
	}

	static bool ArmorSpawnDisabled(int flagBit)
	{
		let cv = CVar.FindCVar("pb_pbx_armors_flags");
		if (!cv) return false;
		return (cv.GetInt() & flagBit) != 0;
	}
}
