// Metal Sniper scope analysis HUD + laser dot + ADS scope modes (PBX-Weapons port).

class PB2022_RedDot : Actor
{
	default
	{
		+NOBLOCKMAP;
		+NOGRAVITY;
		+FORCEXYBILLBOARD;
		+NOTIMEFREEZE;
		RenderStyle "Add";
		Alpha 0.85;
		Scale 0.10;
		Mass 0;
		Radius 1;
		Height 2;
	}

	states
	{
	Spawn:
		LEYS R 1 Bright;
		Stop;
	}
}

class PB2022_MS_Infrared : PowerLightAmp
{
	Default { Powerup.Duration -1800; }
}

class PB2022_GreenDot : PB2022_RedDot
{
	States
	{
	Spawn:
		LEYS RR 0 Bright;
		LEYS G 1 Bright;
		Stop;
	}
}

class PB2022_ScopeHandler : StaticEventHandler
{
	play bool CanDraw;
	play int MaxHealth, Health, ZoomScale, PainChance;
	play string ActorName;
	play double Distance;

	override void WorldTick()
	{
		CanDraw = false;
	}

	override void RenderUnderlay(RenderEvent e)
	{
		if (!CanDraw)
			return;

		int color = Font.CR_GREEN;
		Screen.DrawText(SmallFont, color, 190, 74,
			String.Format("Distance: %.1f m.", Distance), DTA_Clean, true);
		if (ActorName.Length() > 0)
			Screen.DrawText(BigFont, color, 190, 86, ActorName, DTA_Clean, true);
		string stats = String.Format("Max. HP: %u\nHP: %u\nPain chance: %u%%", MaxHealth, Health, PainChance);
		Screen.DrawText(SmallFont, color, 190, 104, stats, DTA_Clean, true);
	}
}

extend class PB_MetalSniper
{
	const LOWZOOM = 4.0;
	const HIGHZOOM = 7.0;

	bool laserActive;
	bool nvgActive;
	bool LockedOn;
	bool enableScopeHUD;
	int ScopeMode;
	double zoomstrength;

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		grenadeloaded  = true;
		currentMaxAmmo = MetalSniperFullAmmo;
		usedAmmo       = 2;
		laserActive = false;
		nvgActive = false;
		LockedOn = false;
		ScopeMode = 0;
		enableScopeHUD = false;
		zoomstrength = LOWZOOM;
	}

	override void DoEffect()
	{
		Super.DoEffect();
		if (level.isFrozen() || !owner || !owner.player)
			return;
		if (!(owner.player.ReadyWeapon is "PB_MetalSniper"))
			return;

		let weap = PB_MetalSniper(owner.player.ReadyWeapon);
		if (!weap || !weap.laserActive)
			return;

		let psp = owner.player.FindPSprite(PSP_WEAPON);
		if (!psp)
			return;

		static const StateLabel blockedStates[] =
		{
			"Reload", "Reload_Grenade", "StandardReload", "WeaponRespect",
			"TakeMagStandard", "TakeMagResonance", "InsertMag", "ReloadFromSpecial", "Deselect",
			"FinishReload", "RaiseFromEmpty", "Start_Rechamber", "Rechamber", "ChangeAnim",
			"UnloadFromSpecial", "Unload", "UnloadRaise", "UnloadMagStandard", "UnloadMagEmpty",
			"UnloadMagResonance", "UnloadChamber", "FinishUnload", "StartUnloadChamber", "SelectAnimation",
			"FlashPunching", "FlashKicking", "FlashAirKicking", "FlashSlideKicking", "FlashSlideKickingStop"
		};

		for (int i = 0; i < blockedStates.Size(); i++)
		{
			if (InStateSequence(psp.curstate, ResolveState(blockedStates[i])) && !InStateSequence(psp.curstate, ResolveState("Ready3")))
				return;
		}

		double pz = owner.height * 0.5 - owner.floorclip + owner.player.mo.AttackZOffset * owner.player.crouchFactor;
		FLineTraceData lasersight;
		owner.LineTrace(owner.angle, 4096, owner.pitch, TRF_SOLIDACTORS | TRF_THRUHITSCAN, offsetz: pz, data: lasersight);
		Spawn("PB2022_GreenDot", lasersight.HitLocation);
	}

	action void MS_ResetScopeVars()
	{
		invoker.enableScopeHUD = false;
		A_SetRenderStyle(1.0, STYLE_Normal);
		A_TakeInventory("PB2022_MS_Infrared", 0);
	}

	action double MS_GetZoomStrength() { return invoker.zoomstrength; }
	action void MS_SetZoomStrength(double set) { invoker.zoomstrength = set; }

	action state MS_ReadyZoom()
	{
		A_SetRoll(0);
		A_SetCrosshair(-1);
		PB_CoolDownBarrel(-5, 0, 7, 0,  1);
		PB_CoolDownBarrel( 5, 0, 7, 0, -1);
		A_SetInventory("PB_LockScreenTilt", 0);
		A_ZoomFactor(MS_GetZoomStrength());
		if (invoker.ScopeMode == 1 || invoker.ScopeMode == 2)
		{
			A_SetCrosshair(52);
			MS_ReadyScope();
			A_SetRenderStyle(0.1, STYLE_Translucent);
			invoker.enableScopeHUD = true;
		}
		else
		{
			invoker.enableScopeHUD = false;
			A_SetRenderStyle(1.0, STYLE_Normal);
		}
		return PB_ReadyFire("Fire_ADS", "Fire_ADS", "ZoomOut", true, true, 'SniperAmmo', true, "SniperUnloaded");
	}

	action void MS_ReadyScope()
	{
		FLineTraceData trace;
		bool hit = LineTrace(Angle, 6000, Pitch, 0, player.ViewHeight, 0, 0, trace);
		if (!hit)
			return;

		if (trace.HitActor && trace.HitActor.bISMONSTER && !trace.HitActor.bFRIENDLY && trace.HitActor is "PB_Monster")
		{
			if (!invoker.LockedOn)
			{
				A_SetBlend(0x00a100, 0.2, 3);
				invoker.LockedOn = true;
				A_StartSound("IronSights", CHAN_WEAPON, CHANF_NOSTOP, 1.0, ATTN_NORM, pitch: 1.4);
			}
			if (invoker.ScopeMode == 2)
			{
				let sh = PB2022_ScopeHandler(StaticEventHandler.Find("PB2022_ScopeHandler"));
				if (sh)
				{
					sh.Health = trace.HitActor.health;
					sh.MaxHealth = trace.HitActor.GetSpawnHealth();
					sh.PainChance = int(double(trace.HitActor.PainChance) / 256.0 * 100.0);
					sh.Distance = Distance3D(trace.HitActor) / 32.0;
					sh.ActorName = trace.HitActor.GetTag();
					sh.ZoomScale = int(MS_GetZoomStrength());
					sh.CanDraw = true;
				}
			}
		}
		else if (invoker.LockedOn)
		{
			A_SetBlend(0x00a100, 0.2, 3);
			invoker.LockedOn = false;
			A_StartSound("IronSights", CHAN_WEAPON, CHANF_NOSTOP, 1.0, ATTN_NORM, pitch: 1.3);
			let sh = PB2022_ScopeHandler(StaticEventHandler.Find("PB2022_ScopeHandler"));
			if (sh)
				sh.CanDraw = false;
		}
	}

	action state MS_HandleScopeWheel()
	{
		bool toggleLaser = FindInventory("MS_Select_Laser");
		bool toggleZoom = FindInventory("MS_Select_ToggleZoom");
		bool toggleScope = FindInventory("MS_Select_ToggleScope");
		bool toggleNVG = FindInventory("MS_Select_ToggleNVG");
		bool noRes = FindInventory("MS_Select_NO");

		if (noRes)
		{
			A_Print("$PB_MSNI_RESONANCE_LOCKED");
			MS_CleanScopeTokens();
			return resolvestate("Ready3");
		}

		if (FindInventory("MS_Select_Resonance"))
		{
			MS_CleanScopeTokens();
			if (!CountInv("MetalSniperUpgraded"))
			{
				A_Print("$PB_MSNI_RESONANCE_LOCKED");
				return resolvestate("Ready3");
			}
			return resolvestate(null);
		}

		if (toggleLaser)
		{
			invoker.laserActive = !invoker.laserActive;
			A_StartSound("MS/Button", CHAN_AUTO, CHANF_OVERLAP);
			A_Print(invoker.laserActive ? "$PB2022_LASER_ON" : "$PB2022_LASER_OFF");
		}
		if (toggleScope)
		{
			invoker.ScopeMode = (invoker.ScopeMode + 1) % 3;
			A_StartSound("MS/Button", CHAN_WEAPON);
			A_SetBlend(0x00a100, 0.2, 3);
			switch (invoker.ScopeMode)
			{
				case 0: A_Print("$PB2022_SCOPE_MODE1"); break;
				case 1: A_Print("$PB2022_SCOPE_MODE2"); break;
				case 2: A_Print("$PB2022_SCOPE_MODE3"); break;
			}
		}
		if (toggleZoom)
		{
			if (MS_GetZoomStrength() == HIGHZOOM)
			{
				MS_SetZoomStrength(LOWZOOM);
				A_Print("$PB2022_ZOOM_40");
			}
			else
			{
				MS_SetZoomStrength(HIGHZOOM);
				A_Print("$PB2022_ZOOM_70");
			}
			A_ZoomFactor(MS_GetZoomStrength());
			A_StartSound("MS/Button", CHAN_AUTO, CHANF_OVERLAP);
		}
		if (toggleNVG)
		{
			if (invoker.nvgActive)
			{
				invoker.nvgActive = false;
				A_Print("$PB2022_NVG_OFF");
				A_TakeInventory("PB2022_MS_Infrared", 0);
			}
			else
			{
				invoker.nvgActive = true;
				A_GiveInventory("PB2022_MS_Infrared", 1);
				A_Print("$PB2022_NVG_ON");
				A_StartSound("RA1IF1", CHAN_AUTO, CHANF_OVERLAP);
			}
			A_SetBlend("Black", 0.75, 16);
		}

		MS_CleanScopeTokens();
		if (PB_GetZoom())
			return resolvestate("Ready_ADS");
		return resolvestate("Ready3");
	}

	action void MS_CleanScopeTokens()
	{
		A_TakeInventory("MS_Select_Laser", 1);
		A_TakeInventory("MS_Select_ToggleZoom", 1);
		A_TakeInventory("MS_Select_ToggleScope", 1);
		A_TakeInventory("MS_Select_ToggleNVG", 1);
		A_TakeInventory("MS_Select_Resonance", 1);
		A_TakeInventory("MS_Select_NO", 1);
	}
}
