extend class PB_NormalRifle
{
	override void PostBeginPlay()
	{
		doBurst = false;
		laserActive = false;
		burstcount = 0;
		burstcountLeft = 0;
		Super.PostBeginPlay();
	}

	action void PB_SetupDualWield(int crosshair = 55)
	{
		PB_HandleCrosshair(crosshair);
		A_TakeInventory("PB_LockScreenTilt", 1);
		A_SetFiringRightWeapon(false);
		A_SetFiringLeftWeapon(false);
		A_TakeInventory("DualFiring", 1);
		A_SetInventory("DualFireReload", 0);

		let ammoLeftType = invoker.ammotypeleft ? invoker.ammotypeleft : invoker.ammotype2;
		if (CountInv(ammoLeftType) < CountInv(invoker.ammotype2))
			A_GiveInventory("DualFiring", 1);

		if (CountInv(invoker.ammotype1) > 0)
		{
			if (CountInv(ammoLeftType) <= 0)
				A_GiveInventory("DualFireReload", 1);
			if (CountInv(invoker.ammotype2) <= 0)
				A_GiveInventory("DualFireReload", 1);
		}

		A_SetRoll(0);
		A_Overlay(10, "IdleLeft_Overlay", false);
		A_Overlay(11, "IdleRight_Overlay", false);
	}

	action void PB_ClearDualWield()
	{
		A_ClearOverlays(10, 11);
		A_SetFiringRightWeapon(false);
		A_SetFiringLeftWeapon(false);
		A_TakeInventory("DualFiring", 1);
		A_SetInventory("DualFireReload", 0);
		invoker.waitReleaseLeft = false;
		invoker.waitReleaseRight = false;
		invoker.burstcount = 0;
		invoker.burstcountLeft = 0;
	}

	override void DoEffect()
	{
		Super.DoEffect();

		if (level.isFrozen())
			return;

		if (!owner || !owner.player || !owner.player.readyweapon)
			return;

		if (!(owner.player.readyweapon.GetClass() is 'PB_NormalRifle'))
			return;

		let weap = PB_NormalRifle(owner.player.readyweapon);
		if (!weap || !weap.laserActive)
			return;

		let psp = owner.player.FindPSprite(PSP_WEAPON);
		if (!psp)
			return;

		static const StateLabel blockedStates[] =
		{
			"Deselect", "NormalDeselect", "DualWieldDeselect", "FinishDeselect",
			"SelectAnimationDualWield", "SelectAnimation",
			"SwitchToDualWield", "StopDualWield",
			"RaiseFromEmpty", "Reload", "ContinueReload", "FinishReload", "Rechamber",
			"ReloadUnloadRight", "ReloadUnloadLeft", "ReloadDualWield", "ContinueReloadRight",
			"ReloadLeft", "ContinueReloadLeft",
			"Unload", "UnloadChamber", "UnloadDualWield", "UnloadLeft",
			"FlashKickingAkimbo", "FlashAirKickingAkimbo", "FlashSlideKickingAkimbo", "FlashSlideKickingStopAkimbo",
			"WeaponRespect",
			"FlashPunching", "FlashKicking", "FlashAirKicking", "FlashSlideKicking", "FlashSlideKickingStop"
		};

		for (int i = 0; i < blockedStates.Size(); i++)
		{
			if (InStateSequence(psp.curstate, ResolveState(blockedStates[i])) && !InStateSequence(psp.curstate, ResolveState("Ready3")))
				return;
		}

		double pz = owner.height * 0.5 - owner.floorclip + owner.player.mo.AttackZOffset * owner.player.crouchFactor;
		FLineTraceData lasersight;
		owner.LineTrace(owner.angle,
			4096,
			owner.pitch,
			TRF_SOLIDACTORS | TRF_THRUHITSCAN,
			offsetz: pz,
			data: lasersight);

		Spawn("PB2022_RedDot", lasersight.HitLocation);
	}

	action void setBurstCount(int set, bool isLeft = false)
	{
		if (!isLeft)
			invoker.burstcount = set;
		else
			invoker.burstcountLeft = set;
	}

	action int getBurstCount(bool isLeft = false)
	{
		if (!isLeft)
			return invoker.burstcount;
		return invoker.burstcountLeft;
	}

	action bool getBurst()
	{
		return invoker.doBurst;
	}

	action void setBurst(bool set)
	{
		invoker.doBurst = set;
	}

	action void NormalRifle_FireOverlay(int tic, bool isLeft = false)
	{
		bool burst = getBurst();
		int heat = burst ? 3 : 1;
		double recoilX = burst ? -0.6 : -0.24;
		double recoilY = isLeft ? (burst ? +0.8 : +0.6) : (burst ? -0.8 : -0.6);
		double smokeOfs = isLeft ? 6 : -6;
		double vertOfs = isLeft ? -16 : 9;
		Name ammoNm = isLeft ? invoker.ammoleft.GetClassName() : invoker.ammo2.GetClassName();
		string ammoClass = ammoNm;

		switch (tic)
		{
			case 1:
				if (isLeft && invoker.ammo2.amount <= 0)
					A_GiveInventory("DualFireReload", 1);
				else if (!isLeft && invoker.ammoleft.amount <= 0)
					A_GiveInventory("DualFireReload", 1);
				PB_IncrementHeat(heat, isLeft);
				PB_FireBullets("PB_556x45mm", 1, 0.1, 0, 0, 0.1);
				PB_SpawnCasing("PB_EmptyBrass", 26, vertOfs, 38, frandom(-2, 2), -frandom(2, 5), frandom(3, 6));
				A_StartSound("weapons/rifle", CHAN_Weapon, CHANF_DEFAULT, 1.0);
				PB_DynamicTail("lmg", "br");
				A_ZoomFactor(0.98);
				PB_WeaponRecoil(recoilX, recoilY);
				if (isLeft)
				{
					invoker.burstcountLeft++;
					PB_LowAmmoSoundWarning(ammoClass);
					PB_TakeAmmo((class<Inventory>)(ammoNm), 1, dual: true);
					A_SetFiringLeftWeapon(true);
				}
				else
				{
					invoker.burstcount++;
					PB_LowAmmoSoundWarning();
					PB_TakeAmmo((class<Inventory>)(ammoNm), 1);
					A_SetFiringRightWeapon(true);
				}
				A_AlertMonsters();
				PB_GunSmoke(smokeOfs, 0, 1.6);
				PB_MuzzleFlashEffects(smokeOfs, 0, 1.6);
				break;

			case 2:
				if (isLeft)
				{
					if (invoker.ammoleft.amount <= 0 || invoker.ammo2.amount > 0)
						A_GiveInventory("DualFiring", 1);
				}
				else
				{
					if (invoker.ammoleft.amount > 0 || invoker.ammo2.amount <= 0)
						A_TakeInventory("DualFiring", 1);
				}
				break;

			case 3:
				A_ZoomFactor(1.0);
				PB_WeaponRecoil(recoilX, recoilY);
				break;

			case 4:
				setBurstCount(0, isLeft);
				if (burst)
				{
					if (isLeft)
						invoker.waitReleaseLeft = true;
					else
						invoker.waitReleaseRight = true;
				}
				if (isLeft && invoker.ammo2.amount <= 0)
					A_GiveInventory("DualFireReload", 1);
				else if (!isLeft && invoker.ammoleft.amount <= 0)
					A_GiveInventory("DualFireReload", 1);
				if (isLeft)
					A_SetFiringLeftWeapon(false);
				else
					A_SetFiringRightWeapon(false);
				break;
		}
	}

	action state ReadyOverlay(bool isLeft)
	{
		int firemodecvar = CVar.GetCvar("SingleDualFire", player).GetInt();
		bool waiting = isLeft ? invoker.waitReleaseLeft : invoker.waitReleaseRight;
		bool checkDualWieldButton;

		switch (firemodecvar)
		{
			case 0: checkDualWieldButton = !PressingFire(); break;
			case 1: checkDualWieldButton = isLeft ? !PressingFire() : !PressingAltFire(); break;
			case 2: checkDualWieldButton = isLeft ? !PressingAltFire() : !PressingFire(); break;
		}

		if (waiting)
		{
			if (firemodecvar == 0 || checkDualWieldButton)
			{
				if (isLeft)
					invoker.waitReleaseLeft = false;
				else
					invoker.waitReleaseRight = false;
			}
			else
				return ResolveState(null);
		}
		if (isLeft)
			return A_DoPBLeftAction();
		return A_DoPBRightAction();
	}

	action void fireweapon(int tic)
	{
		bool ads = PB_GetZoom();
		double zoomA = ads ? 1.9 : 0.98;
		double zoomB = ads ? 2.0 : 1.0;

		switch (tic)
		{
			case 1:
				A_StartSound("weapons/rifle", CHAN_Weapon, CHANF_DEFAULT, 1.0);
				A_AlertMonsters();
				PB_IncrementHeat(4);
				PB_DynamicTail("lmg", "br");
				PB_LowAmmoSoundWarning();
				PB_GunSmoke(0, 0, 0);
				PB_MuzzleFlashEffects(0, 0, 0);
				A_FireCustomMissile("YellowFlareSpawn", 0, 0, 0, 0);
				PB_TakeAmmo((class<Inventory>)(invoker.ammo2.GetClassName()), 1);
				A_GunFlash();
				PB_WeaponRecoil(-0.5, 0);
				PB_FireOffset();
				if (ads)
				{
					PB_SpawnCasing("PB_EmptyBrass", 28, 0, 30, 3, frandom(5, 8), frandom(3, 4));
					PB_FireBullets("PB_556x45mm", 1, 0.1, 0, 0, 0.1);
				}
				else
				{
					PB_SpawnCasing("PB_EmptyBrass", 22, 2, 28, frandom(-2, -1), frandom(5, 8), frandom(3, 4));
					PB_FireBullets("PB_556x45mm", 1, 1, 0, 0, 1);
				}
				A_ZoomFactor(zoomA);
				break;

			case 2:
				PB_WeaponRecoil(-1.0, 0);
				A_ZoomFactor(zoomB);
				invoker.burstcount++;
				break;

			case 3:
				PB_WeaponRecoil(+1.0, 0);
				break;

			case 4:
				A_WeaponOffset(0, 32);
				break;
		}
	}

	action state NR_ApplyWheelSelection()
	{
		PB_ClearDualWield();

		bool toggleFireMode = CountInv("NR_Select_FireMode") > 0;
		bool toggleDualWield = CountInv("NR_Select_DualWield") > 0;
		bool toggleLaser = CountInv("NR_Select_Laser") > 0;

		if (toggleFireMode)
		{
			invoker.doBurst = !invoker.doBurst;
			A_Print(invoker.doBurst ? "$PB_NORMALRIFLE_BURST" : "$PB_NORMALRIFLE_FULLAUTO");
		}

		if (toggleLaser)
		{
			invoker.laserActive = !invoker.laserActive;
			A_Print(invoker.laserActive ? "$PB_NORMALRIFLE_LASER_ON" : "$PB_NORMALRIFLE_LASER_OFF");
		}

		if (toggleDualWield)
		{
			NR_CleanModeTokens();
			if (A_CheckAkimbo())
				return ResolveState("StopDualWield");
			if (invoker.amount >= 2)
			{
				if (PB_GetZoom())
					return ResolveState("ZoomOut");
				return ResolveState("SwitchToDualWield");
			}
			A_Print("$PB_NORMALRIFLE_NO_AKIMBO");
			return ResolveState("Ready3");
		}

		NR_CleanModeTokens();

		if (PB_GetZoom())
		{
			A_StartSound("MS/Button", 26);
			return ResolveState("Ready2");
		}

		A_StartSound("MS/Button", CHAN_AUTO, CHANF_OVERLAP);
		return ResolveState(null);
	}

	action void NR_CleanModeTokens()
	{
		A_SetInventory("NR_Select_FireMode", 0);
		A_SetInventory("NR_Select_DualWield", 0);
		A_SetInventory("NR_Select_Laser", 0);
	}
}
