// Phase B: per-weapon fullscreen ammo HUD (ported from SBARINFO_LEGACY_FULLSCREEN.txt / PB Staging PB_Hud.zs).

extend class PB2022_Hud_ZS
{
	bool PB2022_WantsDualAmmoRow()
	{
		if (pbWeap && pbWeap.akimboMode)
			return true;
		if (!weap)
			return false;
		return CheckInventory("DualWieldingDMRs")
			|| CheckInventory("DualWieldingCarbines")
			|| CheckInventory("DualWieldingM41A")
			|| CheckInventory("DualWieldingSSG")
			|| CheckInventory("DualWieldingAutoshotguns")
			|| CheckInventory("QuadAkimboMode")
			|| CheckInventory("DualWieldingPistols")
			|| CheckInventory("DualWieldingRevolver")
			|| CheckInventory("DualWieldingSMGs")
			|| CheckInventory("DualWieldingDeagles")
			|| CheckInventory("DualWieldingMP40")
			|| CheckInventory("DualWieldingPlasma")
			|| CheckInventory("DualWieldingM2Plasma");
	}

	void PB2022_ResolveDualLeftAmmo()
	{
		if (!plr || !weap)
			return;

		Name wn = weap.GetClassName();
		Name leftType;

		if (wn == 'Rifle' || wn == 'PB_DMR')
			leftType = 'LeftRifleAmmo';
		else if (wn == 'PB_Carbine')
			leftType = 'LeftXRifleAmmo';
		else if (wn == 'PB_M41A')
			leftType = 'M41AChamberAmmoLeft';
		else if (wn == 'PB_SSG' || wn == 'PB_CSSG')
			leftType = 'LeftSSGAmmo';
		else if (wn == 'PB_Autoshotgun')
			leftType = 'LeftASGAmmo';
		else if (wn == 'PB_QuadSG')
			leftType = 'LeftQSSGAmmoCounter';
		else if (wn == 'PB_Pistol')
			leftType = 'SecondaryPistolAmmo';
		else if (wn == 'PB_Revolver')
			leftType = 'LeftRevolverAmmo';
		else if (wn == 'PB_SMG')
			leftType = 'LeftSMGAmmo';
		else if (wn == 'PB_Deagle')
			leftType = 'LeftDeagleAmmo';
		else if (wn == 'PB_MP40')
			leftType = 'LeftMP40Ammo';
		else if (wn == 'PB_M1Plasma')
			leftType = 'LeftPlasmaAmmo';
		else if (wn == 'PB_M2Plasma')
			leftType = 'LeftM2PlasmaAmmo';
		else if (pbWeap && pbWeap.AmmoTypeLeft)
		{
			let leftInv = plr.FindInventory(pbWeap.AmmoTypeLeft);
			if (leftInv)
				Left = Ammo(leftInv);
			return;
		}
		else
			return;

		let leftInv = plr.FindInventory(leftType);
		if (leftInv)
			Left = Ammo(leftInv);
	}

	// True = skip the generic Primary.GetClassName() ammo-bar switch (weapon drew its own bars).
	bool PB2022_DrawWeaponAmmoSpecial()
	{
		if (!weap)
			return false;

		if (PB2022_WantsDualAmmoRow())
			PB2022_ResolveDualLeftAmmo();

		Name wn = weap.GetClassName();

		switch (wn)
		{
			case 'Rifle':
			case 'PB_DMR':
				if (CheckInventory("HDMRGrenadeMode") && !PB2022_WantsDualAmmoRow())
				{
					PBHud_DrawImage("BARBACR3", (-92, -69), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
					PBHud_DrawBar("ABAR4", "BGBARL", GetAmount("RocketAmmo"), GetMaxAmount("RocketAmmo"), (-101, -72), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
					PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("RocketAmmo")), (-194, -88.75), DI_TEXT_ALIGN_RIGHT, Font.CR_RED);
				}
				return false;

			case 'PB_M41A':
				if (CheckInventory("DualWieldingM41A"))
				{
					weaponBarAccent = Font.CR_TAN;
					DrawAmmoBar("BARBACT1", "BARBACT2", "BARBACT3", "BAMBAR2", "ABAR2", "ABAR2", "AMMOIC2", Font.CR_TAN, drawDual: Left != null);
					return true;
				}
				return false;

			case 'PB_MG42':
				weaponBarAccent = Font.CR_YELLOW;
				DrawAmmoBar("BARBACY1", "BARBACY2", "BARBACY3", "BAMBAR1", "ABAR1", "ABAR1", "AMMOIC1", Font.CR_YELLOW, drawSecondary: false);
				if (Secondary)
					PB2022_DrawHeatMeterRow("BARBACY2", "ABAR1", IntAmmo2, Secondary.MaxAmount, false, true);
				return true;

			case 'PB_Minigun':
			case 'PB_BFG9000':
			case 'PB_CryoCannon':
			case 'Stormcast':
			case 'BHGen':
				weaponBarAccent = Font.CR_PURPLE;
				DrawAmmoBar("BARBACP1", "BARBACP2", "BARBACP3", "BAMBAR5", "ABAR5", "ABAR5", "AMMOIC5", Font.CR_PURPLE, drawSecondary: false);
				return true;

			case 'PB_CryoElectroRifle':
				weaponBarAccent = CheckInventory("PB_CryoElectroRifle_ElectricMode") ? Font.CR_WHITE : Font.CR_CYAN;
				DrawAmmoBar("BARBACP1", "BARBACP2", "BARBACP3", "BAMBAR5", "ABAR5", "ABAR5", "AMMOIC5", weaponBarAccent);
				return true;

			case 'MarauderSSG':
				weaponBarAccent = Font.CR_ORANGE;
				DrawAmmoBar("BARBACO1", "BARBACO2", "BARBACO3", "BAMBAR3", "ABAR3", "ABAR3", "AMMOIC3", Font.CR_ORANGE, drawDual: PB2022_WantsDualAmmoRow() && Left != null);
				if (CheckInventory("MarauderCryoMode"))
					PBHud_DrawString(mBoldFont, "CRYO", (-145, -64), DI_SCREEN_RIGHT_BOTTOM | DI_TEXT_ALIGN_LEFT, Font.CR_CYAN, scale: (0.5, 0.5));
				return false;

			case 'PB_Unmaker':
				DrawAmmoBar("BARBACD1", "BARBACZ2", "BARBACZ2", "BAMBAR7", "ABAR7", "ABAR6", "AMMOIC6", Font.CR_ORANGE, drawNumbers: false, drawIcon: false);
				PBHud_DrawImage("AMMOIC7", (-66, -37), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha, (17, 17));
				PBHud_DrawImage("AMMOIC6", (-66, -17), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha, (17, 17));
				if (Primary)
					PBHud_DrawAmmoNumber(Formatnumber(Primary.Amount), (-216, -49), Font.CR_ORANGE);
				if (Secondary)
					PBHud_DrawAmmoNumber(String.Format("%u%%", Secondary.Amount / 6), (-205, -69), cachedFontColors[DTECHAMMO]);
				weaponBarAccent = cachedFontColors[DTECHAMMO];
				return true;

			case 'PB_M1Plasma':
				DrawAmmoBar("BARBACP1", "BARBACP2", "BARBACP3", "BAMBAR5", "ABAR5", "ABAR5", "AMMOIC5", Font.CR_PURPLE, drawDual: PB2022_WantsDualAmmoRow());
				weaponBarAccent = Font.CR_PURPLE;
				return true;

			case 'PB_M2Plasma':
				DrawAmmoBar("BARBACP1", "BARBACP2", "BARBACP3", "BAMBAR5", "ABAR5", "ABAR5", "AMMOIC5", Font.CR_PURPLE, drawDual: CheckInventory("DualWieldingM2Plasma"));
				weaponBarAccent = Font.CR_PURPLE;
				return true;

			case 'PB_SMG':
				weaponBarAccent = Font.CR_TAN;
				DrawAmmoBar("BARBACT1", "BARBACT2", "BARBACT3", "BAMBAR2", "ABAR2", "ABAR2", "AMMOIC2", Font.CR_TAN, drawDual: PB2022_WantsDualAmmoRow() && Left != null);
				return true;

			case 'PB_Flamethrower':
				DrawAmmoBar("BARBACD1", "BARBACD2", "BARBACD3", "BAMBAR6", "ABAR6", "ABAR6", "AMMOIC6", cachedFontColors[FUELAMMO], drawSecondary: !CheckInventory("FlamerUpgraded"));
				weaponBarAccent = cachedFontColors[FUELAMMO];
				return true;

			case 'PB_Chainsaw':
				if (CheckInventory("ChainsawResourceGather"))
					PBHud_DrawImage("CHAINHL", (-90, -50), DI_SCREEN_RIGHT_BOTTOM, 1, (32, 32));
				return true;

			case 'PB_Axe':
			{
				int axeCount = plr.CountInv("PB_Axe");
				for (; axeCount > 0; axeCount--)
					PBHud_DrawImage("AXECOUNT", (-80 + (-8 * axeCount), -28), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM | DI_MIRROR, scale: (0.5, 0.5));
				return true;
			}

			case 'BioAcidLauncher':
				weaponBarAccent = Font.CR_PURPLE;
				DrawAmmoBar("BARBACP1", "BARBACP2", "BARBACP3", "BAMBAR5", "ABAR5", "ABAR5", "AMMOIC5", Font.CR_PURPLE, drawSecondary: false, drawDual: false);
				return true;

			case 'PB_Freezer':
				weaponBarAccent = Font.CR_PURPLE;
				DrawAmmoBar("BARBACP1", "BARBACP2", "BARBACP3", "BAMBAR5", "ABAR5", "ABAR5", "AMMOIC5", Font.CR_PURPLE, drawDual: false);
				PBHud_DrawImage("BARBACT2", (-73, -65), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
				PBHud_DrawBar("ABAR2", PB2022_AmmoBarOffGfx(), GetAmount("PrimaryPistolAmmo"), GetMaxAmount("PrimaryPistolAmmo"), (-111, -68), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
				PBHud_DrawAmmoNumber(Formatnumber(GetAmount("PrimaryPistolAmmo")), (-205, -85), Font.CR_TAN);
				PBHud_DrawImage("AMMOIC2", (-66, -55), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha, (17, 17));
				return true;

			case 'Stormcast':
				weaponBarAccent = Font.CR_PURPLE;
				DrawAmmoBar("BARBACP1", "BARBACP2", "BARBACP3", "BAMBAR5", "ABAR5", "ABAR5", "AMMOIC5", Font.CR_PURPLE, drawPrimary: false, drawSecondary: true, drawDual: false);
				if (Secondary)
					PBHud_DrawAmmoNumber(Formatnumber(Secondary.Amount), (-216, -49), Font.CR_PURPLE);
				PBHud_DrawBar("RESBAR5", "BGBARL", IntAmmo2, Secondary ? Secondary.MaxAmount : 0, (-122, -32), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, slanted: false);
				return true;

			case 'Hell_rifle':
				weaponBarAccent = cachedFontColors[DTECHAMMO];
				DrawAmmoBar("BARBACZ1", "BARBACZ2", "BARBACZ3", "BAMBAR7", "ABAR7", "ABAR7", "AMMOIC7", cachedFontColors[DTECHAMMO]);
				return true;
		}

		return false;
	}

	bool PB2022_DrawWeaponModeLabel()
	{
		if (!weap || !plr)
			return false;

		String label;
		int col = Font.CR_UNTRANSLATED;
		Name wn = weap.GetClassName();

		switch (wn)
		{
			case 'PB_Unmaker':
				if (CheckInventory("UnmakerFireSelected"))
				{
					label = StringTable.Localize("$PB_HUD_UNMAKER_INFERNO", false);
					col = Font.CR_ORANGE;
				}
				else
				{
					label = StringTable.Localize("$PB_HUD_UNMAKER_INCIN", false);
					col = cachedFontColors[DTECHAMMO];
				}
				break;
			case 'PB_Flamethrower':
				if (CheckInventory("FlamerNukageMode"))
				{
					label = StringTable.Localize("$PB_HUD_FLAMER_ACID", false);
					col = Font.CR_GREEN;
				}
				else
				{
					label = StringTable.Localize("$PB_HUD_FLAMER_FLAME", false);
					col = Font.CR_ORANGE;
				}
				break;
			case 'PB_CryoElectroRifle':
				if (CheckInventory("PB_CryoElectroRifle_ElectricMode"))
				{
					label = StringTable.Localize("$PB_HUD_CRYO_ELECTRIC", false);
					col = Font.CR_WHITE;
				}
				else
				{
					label = StringTable.Localize("$PB_HUD_CRYO_CRYO", false);
					col = Font.CR_CYAN;
				}
				break;
			case 'PB_SMG':
				if (CheckInventory("DualWieldingSMGs"))
				{
					label = StringTable.Localize("$PB_HUD_SMG_AKIMBO", false);
					col = Font.CR_TAN;
				}
				else if (CheckInventory("LaserSightActivated"))
				{
					label = StringTable.Localize("$PB_HUD_SMG_LASER", false);
					col = Font.CR_LIGHTBLUE;
				}
				else
				{
					label = StringTable.Localize("$PB_HUD_SMG_STD", false);
					col = Font.CR_TAN;
				}
				break;
			case 'BioAcidLauncher':
				label = StringTable.Localize("$PB_HUD_BIOACID_STREAM", false);
				col = Font.CR_PURPLE;
				break;
			case 'BHGen':
				label = StringTable.Localize("$PB_HUD_BHGEN_CHARGE", false);
				col = Font.CR_PURPLE;
				break;
			default:
				return false;
		}

		if (!label.Length())
			return false;

		PBHud_DrawString(mBoldFont, label, (-145, -64), DI_SCREEN_RIGHT_BOTTOM | DI_TEXT_ALIGN_LEFT, col, scale: (0.5, 0.5));
		return true;
	}

	void PB2022_DrawEquipmentSlot()
	{
		PBHud_DrawImage("EQUPBO", (-15, -17), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);

		if (CheckInventory("FragGrenadeSelected"))
		{
			PBHud_DrawImage("HFRAGY", (-46, -45), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_CENTER, scale: (0.8, 0.8));
			PBHud_DrawString(mBoldFont, Formatnumber(GetAmount("HandGrenadeAmmo")), (-47, -33), DI_TEXT_ALIGN_CENTER, Font.CR_GREEN, scale: (0.8, 0.8));
		}
		else if (CheckInventory("ProximityMineSelected"))
		{
			PBHud_DrawImage("HMINEY", (-46, -45), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_CENTER, scale: (0.8, 0.8));
			PBHud_DrawString(mBoldFont, Formatnumber(GetAmount("MineAmmo")), (-47, -33), DI_TEXT_ALIGN_CENTER, Font.CR_PURPLE, scale: (0.8, 0.8));
		}
		else if (CheckInventory("StunGrenadeSelected"))
		{
			PBHud_DrawImage("HSTUNY", (-46, -45), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_CENTER, scale: (0.8, 0.8));
			PBHud_DrawString(mBoldFont, Formatnumber(GetAmount("StunGrenadeAmmo")), (-47, -33), DI_TEXT_ALIGN_CENTER, Font.CR_CYAN, scale: (0.8, 0.8));
		}
		else if (CheckInventory("ShieldGrenadeSelected"))
		{
			PBHud_DrawImage("SGGRA0", (-46, -45), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_CENTER, scale: (0.8, 0.8));
			PBHud_DrawString(mBoldFont, Formatnumber(GetAmount("ShieldGrenadeAmmo")), (-47, -33), DI_TEXT_ALIGN_CENTER, Font.CR_CYAN, scale: (0.8, 0.8));
		}
		else if (CheckInventory("RevGunSelected"))
		{
			PBHud_DrawImage("HREVCY", (-46, -45), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_CENTER, scale: (0.8, 0.8));
			PBHud_DrawString(mBoldFont, Formatnumber(GetAmount("MiniHellRocketAmmo")), (-47, -33), DI_TEXT_ALIGN_CENTER, Font.CR_LIGHTBLUE, scale: (0.8, 0.8));
		}
		else if (CheckInventory("LeechSelected"))
		{
			PBHud_DrawImage("HLECHY", (-46, -45), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_CENTER, scale: (0.8, 0.8));
			PBHud_DrawString(mBoldFont, Formatnumber(GetAmount("Demonpower")), (-47, -33), DI_TEXT_ALIGN_CENTER, cachedFontColors[DTECHAMMO], scale: (0.8, 0.8));
		}
		else if (CheckInventory("FreezenadeSelected"))
		{
			PBHud_DrawImage("FGNDA0", (-46, -45), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_CENTER, scale: (0.8, 0.8));
			PBHud_DrawString(mBoldFont, Formatnumber(GetAmount("FreezenadeAmmo")), (-47, -33), DI_TEXT_ALIGN_CENTER, Font.CR_CYAN, scale: (0.8, 0.8));
		}
		else if (CheckInventory("PB_CF_SnowCasterSelected"))
		{
			PBHud_DrawImage("BXPLA0", (-46, -45), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_CENTER, scale: (0.8, 0.8));
			PBHud_DrawString(mBoldFont, Formatnumber(GetAmount("PB_CF_SnowCasterAmmo")), (-47, -33), DI_TEXT_ALIGN_CENTER, Font.CR_CYAN, scale: (0.8, 0.8));
		}
		else if (CheckInventory("PB_CF_FreezeBotSelected"))
		{
			PBHud_DrawImage("FZBLA0", (-46, -45), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_CENTER, scale: (0.8, 0.8));
			PBHud_DrawString(mBoldFont, Formatnumber(GetAmount("PB_CF_FreezeBotDeployAmmo")), (-47, -33), DI_TEXT_ALIGN_CENTER, Font.CR_CYAN, scale: (0.8, 0.8));
		}
		else if (CheckInventory("PB_CF_IceWallSelected"))
		{
			PBHud_DrawImage("CMSTA0", (-46, -45), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_CENTER, scale: (0.8, 0.8));
			PBHud_DrawString(mBoldFont, Formatnumber(GetAmount("PB_CF_IceWallGenAmmo")), (-47, -33), DI_TEXT_ALIGN_CENTER, Font.CR_CYAN, scale: (0.8, 0.8));
		}
		else if (CheckInventory("PB_CF_HoloDecoySelected"))
		{
			PBHud_DrawImage("PLAYE1", (-46, -45), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_CENTER, scale: (0.8, 0.8));
			PBHud_DrawString(mBoldFont, Formatnumber(GetAmount("PB_CF_HoloDecoyAmmo")), (-47, -33), DI_TEXT_ALIGN_CENTER, Font.CR_CYAN, scale: (0.8, 0.8));
		}
		else if (CheckInventory("PB_CF_TeslaTurretSelected"))
		{
			PBHud_DrawImage("ELPDA0", (-46, -45), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_CENTER, scale: (0.8, 0.8));
			PBHud_DrawString(mBoldFont, Formatnumber(GetAmount("PB_CF_TeslaTurretAmmo")), (-47, -33), DI_TEXT_ALIGN_CENTER, Font.CR_CYAN, scale: (0.8, 0.8));
		}
		else if (CheckInventory("PB_CF_FlameTurretSelected"))
		{
			PBHud_DrawImage("F1REA0", (-46, -45), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_CENTER, scale: (0.8, 0.8));
			PBHud_DrawString(mBoldFont, Formatnumber(GetAmount("PB_CF_FlameTurretAmmo")), (-47, -33), DI_TEXT_ALIGN_CENTER, Font.CR_ORANGE, scale: (0.8, 0.8));
		}
		else if (CheckInventory("PB_CF_FreezeMineSelected"))
		{
			PBHud_DrawImage("FZBLA0", (-46, -45), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_CENTER, scale: (0.8, 0.8));
			PBHud_DrawString(mBoldFont, Formatnumber(GetAmount("PB_CF_FreezeMineAmmo")), (-47, -33), DI_TEXT_ALIGN_CENTER, Font.CR_CYAN, scale: (0.8, 0.8));
		}
	}
}
