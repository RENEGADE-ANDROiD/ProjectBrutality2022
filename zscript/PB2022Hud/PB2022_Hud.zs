//Project Brutality FULLSCREEN HUD
//Converted from SBARINFO to ZScript by generic name guy

/*
Credits:

generic name guy
-Code

A_D_M_E_R_A_L
-Slanted Bars
-Mugshot code

Iamcarrotmaster
-Graphics

JMartinez2098
-Fixes

BlueShadow
-Bases for powerup timers and keycards

James Paddock
-Mementwo font

Severin Meyer
-Oxanium font

Lewisk3
-Messages base

nemesisVampy
-2026 HUD touchup code
-Improved equipment wheel
*/

// PB Staging fullscreen HUD (BaseStatusBar). Phase A: visor stays on PB_VisorHandler; bar fonts map to PB2022 CURBAR/BLUEBAR/GRBAR strips.
class PB2022_Hud_ZS : BaseStatusBar
{
	const PB2022_HUD_DRAW_VISOR_IN_STATUSBAR = 0;

	//Oxanium by Severin Meyer
	//https://fonts.google.com/specimen/Oxanium
	HUDFont mDefaultFont;
	HUDFont mBoldFont;
	HUDFont mAmmoFont;
	
	//Mementwo from JimmyFonts
	//https://forum.zdoom.org/viewtopic.php?t=33409
	HUDFont mLowResFont;

    HUDFont mTerminalFont;

	DynamicValueInterpolator mHealthInterpolator;
	DynamicValueInterpolator mArmorInterpolator;
	DynamicValueInterpolator mAmmo1Interpolator;
	DynamicValueInterpolator mAmmo2Interpolator;
	DynamicValueInterpolator mAmmoLeftInterpolator;
	DynamicValueInterpolator mOverheatInterpolator;
	DynamicValueInterpolator mOverheatLeftInterpolator;
	PB_DynamicDoubleInterpolator mSwayInterpolator;
	PB_DynamicDoubleInterpolator mPitchInterpolator;
	PB_DynamicDoubleInterpolator mFOffsetInterpolator;

	InventoryBarState invBar;

	//Sway and intro
	double mSway, mPitch, mOldZVel, mForwardOffset;
	double mOldAngles;
	double mOldPitch;
	double mFallOfs;

    vector2 interpolatedSway;
    vector2 swayOldFrame, swayCurrentFrame;
    double interpolatedOfs;
    double ofsOldFrame, ofsCurrentFrame;

	int8 m32to0, m64to0;
	double m0to1Float;
	bool hasPutOnHelmet, hasCompletedHelmetSequence;
	bool deathFadeDone, playerWasDead, visorOff;
    uint8 helmetKernelPanic;
    bool muteinterference;
	
	vector2 poll1, poll2, resultSway;

	//Hud variables
	string leftAmmoAmount, oldLeftAmmoAmount;
	bool hudDynamics, inPain;
	double dashIndAlpha, flashlightBatteryAlpha;
	int healthFontCol, keyamount, hudState, oldDashCharge, weaponBarAccent;
	double dashScale1, dashScale2;
    float magnificationIndScale;
    float screenWiperPrg;
    float wipePrgOldFrame, wiperWarningIndScale;
    int16 dirtyScreenTimer; 
    int16 screenFXCount;
	DEDashJump Dasher;
	
	Weapon oldWeapon;

    int tickRandSeed;

	//CVars
	int16 hudXMargin, hudYMargin, playerMsgPrint, bottomMiddlePart;
	bool hudDynamicsCvar, showVisor, showVisorGlass, showLevelStats, lowresfont, curmaxammolist, hideunusedtypes, showList, customPBMugshot, showBloodDrops, showGlassCracks, showtutorials, pbHudSlantedBars;
	float playerAlpha, playerBoxAlpha, messageSize, bloodDropsAlpha, glassCracksAlpha, visorScale, visorOffsets;

	bool centerNotify;
  
    //cached stuff and player variables
    int Health, Armor;
    Weapon weap;
    PB_WeaponBase pbWeap;

    color flsectorlightcolor;
    double sectorlightlevel;
    float berserkBeat;

    PlayerPawn plr;

    Ammo Primary, Secondary, Left;

    int intAmmo1, intAmmo2, intAmmoLeft, intHealth, intArmor, maxArmor, maxHealth;

    Array<int> cachedFontColors;
	
    enum ECachedFontColors {
        HUDBLUEBAR,
        HUDGREENBAR2,
        FUELAMMO,
        DTECHAMMO
    };

    String levelStats[4];

	// One inventory walk per few tics (not per HUD row). give all inflates Inv chain length.
	const PB_HUD_INV_CACHE_TICS = 4;
	int pbHudInvCacheGametic;
	int pbHudInvCacheItemCount;
	Array<bool> pbHudAmmoRowVisible;
	Array<Name> pbHudCachedKeyClass;
	Array<Name> pbHudCachedPowerupClass;
	Array<int> pbHudCachedPowerupTics;

	override void Init()
	{
		Super.Init();
		// PB Staging fullscreen HUD virtual canvas (not vanilla 320x200) — layout
		// coordinates in this file were ported from that tree; 200 vertical units
		// scale the whole bar ~2.7x too large on screen.
		SetSize(0, 320, 540);
		
		if (Font.FindFont("PBFONT"))
			mDefaultFont = HUDFont.Create("PBFONT");
		else
			mDefaultFont = HUDFont.Create("SmallFont");
		if (Font.FindFont("PBBOLD"))
			mBoldFont = HUDFont.Create("PBBOLD");
		else
			mBoldFont = HUDFont.Create("BigFont");
		if (Font.FindFont("AANUM3"))
			mAmmoFont = HUDFont.Create("AANUM3");
		else
			mAmmoFont = mDefaultFont;
		mLowResFont = mDefaultFont;
		mTerminalFont = mDefaultFont;

		//invbar = InventoryBarState.CreateNoBox(mBoldFont);
		
		mHealthInterpolator = DynamicValueInterpolator.Create(0, 0.25, 1, 64);
		mArmorInterpolator = DynamicValueInterpolator.Create(0, 0.25, 1, 64);
		
		mAmmo1Interpolator = DynamicValueInterpolator.Create(0, 0.25, 1, 64);
		mAmmo2Interpolator = DynamicValueInterpolator.Create(0, 0.25, 1, 64);
		mAmmoLeftInterpolator = DynamicValueInterpolator.Create(0, 0.25, 1, 64);
		
		mOverheatInterpolator = DynamicValueInterpolator.Create(0, 0.25, 1, 64);
		mOverheatLeftInterpolator = DynamicValueInterpolator.Create(0, 0.25, 1, 64);
		
		mSwayInterpolator = PB_DynamicDoubleInterpolator.Create(0, 0.3, 0, 32);
		mPitchInterpolator = PB_DynamicDoubleInterpolator.Create(0, 0.3, 0, 32);
		mFOffsetInterpolator = PB_DynamicDoubleInterpolator.Create(0, 0.3, 0, 64);

		InvBar = InventoryBarState.Create();

        cachedFontColors.Push(Font.FindFontColor("HUDBLUEBAR"));
        cachedFontColors.Push(Font.FindFontColor("HUDGREENBAR2"));
        cachedFontColors.Push(Font.FindFontColor("PB_Fuel"));
        cachedFontColors.Push(Font.FindFontColor("PB_DTech"));
	}
	
	void GatherCvars()
	{
		let cvHudDyn = CVar.GetCvar("PB_HudDynamics", CPlayer);
		hudDynamicsCvar = cvHudDyn ? cvHudDyn.GetBool() : false;
		hudDynamics = automapactive ? false : hudDynamicsCvar;

		let cvX = CVar.GetCvar("pb_hudxmargin", CPlayer);
		hudXMargin = max(cvX ? cvX.GetInt() : 0, -9);
		let cvY = CVar.GetCvar("pb_hudymargin", CPlayer);
		hudYMargin = max(cvY ? cvY.GetInt() : 0, -9);

		let cvVis = CVar.GetCvar("pb_showhudvisor", CPlayer);
		showVisor = cvVis ? cvVis.GetBool() : true;
		let cvVisG = CVar.GetCvar("pb_showhudvisorglass", CPlayer);
		showVisorGlass = cvVisG ? cvVisG.GetBool() : true;

		let cvLvl = CVar.GetCvar("pb_showlevelstats", CPlayer);
		showLevelStats = cvLvl ? cvLvl.GetBool() : false;

		let cvLo = CVar.GetCvar("pb_uselowreshudfont", CPlayer);
		lowresfont = cvLo ? cvLo.GetBool() : false;

		let cvList = CVar.GetCvar("pb_showammolist", CPlayer);
		showList = cvList ? cvList.GetBool() : true;
		let cvCurMax = CVar.GetCvar("pb_curmaxammolist", CPlayer);
		curmaxammolist = cvCurMax ? cvCurMax.GetBool() : false;
		let cvHide = CVar.GetCvar("pb_hideunusedtypes", CPlayer);
		hideunusedtypes = cvHide ? cvHide.GetBool() : false;

		let cvPA = CVar.GetCvar("pb_hudalpha", CPlayer);
		playerAlpha = cvPA ? cvPA.GetFloat() : 1.0;

		let cvBox = CVar.GetCvar("pb_hudboxalpha", CPlayer);
		playerBoxAlpha = cvBox ? cvBox.GetFloat() : 1.0;

		let cvMug = CVar.GetCvar("pb_newmugshot", CPlayer);
		customPBMugshot = cvMug ? cvMug.GetBool() : false;

		let cvCN = CVar.GetCVar("con_centernotify", CPlayer);
		centerNotify = cvCN ? cvCN.GetBool() : false;
		let cvMsg = CVar.GetCVar("msg");
		playerMsgPrint = cvMsg ? cvMsg.GetInt() : 0;
		let cvMSz = CVar.GetCVar("pb_messagesize", CPlayer);
		messageSize = cvMSz ? cvMSz.GetFloat() : 1.0;

		let cvBD = CVar.GetCVar("pb_showblooddrops", CPlayer);
		showBloodDrops = cvBD ? cvBD.GetBool() : false;
		let cvGC = CVar.GetCVar("pb_showglasscracks", CPlayer);
		showGlassCracks = cvGC ? cvGC.GetBool() : false;

		let cvBDA = CVar.GetCVar("pb_blooddropsalpha", CPlayer);
		bloodDropsAlpha = cvBDA ? cvBDA.GetFloat() : 1.0;
		let cvGCA = CVar.GetCVar("pb_glasscracksalpha", CPlayer);
		glassCracksAlpha = cvGCA ? cvGCA.GetFloat() : 1.0;

		let cvVS = CVar.GetCVar("pb_visorscale", CPlayer);
		visorScale = cvVS ? cvVS.GetFloat() : 1.0;
		let cvVO = CVar.GetCVar("pb_visorofsx", CPlayer);
		visorOffsets = cvVO ? cvVO.GetFloat() : 0.0;

		let cvMid = CVar.GetCVar("pb_visormiddlepartbottom", CPlayer);
		bottomMiddlePart = cvMid ? cvMid.GetInt() : 0;

		let cvTut = CVar.GetCVar("pb_showtutorials", CPlayer);
		showtutorials = cvTut ? cvTut.GetBool() : false;

		let cvSlant = CVar.GetCvar("pb_hud_slanted_bars", CPlayer);
		pbHudSlantedBars = cvSlant ? cvSlant.GetBool() : true;
	}

	override void Draw(int state, double TicFrac)
	{
		Super.Draw(state, TicFrac);

		if (CheckInventory("CameraRunner"))
			return;

		if(menuactive || consolestate == c_up) 
			GatherCvars();
		
		hudState = state;
		
		fractic = TicFrac;

        float interpolatedWipe = wipePrgOldFrame * (1. - ticfrac) + screenWiperPrg * ticfrac;
        float wiperScale = (1 - interpolatedWipe * 0.25) ** 5;

        TextureID wiperTexture = TexMan.CheckForTexture("GRAPHICS/HUD/ScreenFX/Screenwiper.png");
        vector2 wiperTextureSize = TexMan.GetScaledSize(wiperTexture);
        wiperTextureSize.x *= wiperScale;

        if(dirtyScreenTimer == -1) // engage the screen wiper
            Screen.SetClipRect(0, 0, Screen.GetWidth() - (Screen.GetWidth() * interpolatedWipe) + (wiperTextureSize.x * (0.5 - interpolatedWipe)) + (wiperTextureSize.x * 0.5), Screen.GetHeight());

        DrawBloodDrops();
        DrawGlassCracks();
        
        if(dirtyScreenTimer == -1)
        {
            Screen.ClearClipRect();
            Screen.DrawTexture(wiperTexture, false, (Screen.GetWidth() - (Screen.GetWidth() * interpolatedWipe)), 0, DTA_DestHeight, Screen.GetHeight(), DTA_LegacyRenderStyle, STYLE_Add, DTA_LeftOffsetF, (-300 * (0.5 - interpolatedWipe)), DTA_ScaleX, wiperScale);
        }

        interpolatedOfs = ofsOldFrame * (1. - ticfrac) + ofsCurrentFrame * ticfrac;
        interpolatedSway = swayOldFrame * (1. - ticfrac) + swayCurrentFrame * ticfrac;
		
		if(hudState != HUD_None)
		{
			BeginHUD();
			DrawFullScreenStuff();
            if(showtutorials) DrawTooltip();
		}
	}

	override void NewGame()
	{
		Super.NewGame();

		m32to0 = 64;
		m64to0 = 64;
		m0to1Float = 0;
		dashIndAlpha = 0;
		flashlightBatteryAlpha = 0;
		dashScale1 = 0;
		dashScale2 = 0;
		
		GatherCvars();
		
		mHealthInterpolator.Reset(0);
		mArmorInterpolator.Reset(0);
		mAmmo1Interpolator.Reset(0);
		mAmmo2Interpolator.Reset(0);
		mAmmoLeftInterpolator.Reset(0);
		mOverheatInterpolator.Reset(0);
		mOverheatLeftInterpolator.Reset(0);
		mSwayInterpolator.Reset(0);
		mPitchInterpolator.Reset(0);
		mFOffsetInterpolator.Reset(0);
		pbHudInvCacheGametic = -1;
		pbHudInvCacheItemCount = -1;
	}

	void PB2022_InvalidateHudInvCache()
	{
		pbHudInvCacheGametic = -1;
	}

	void PB2022_MarkAmmoRowVisibleForAmmoType(class<Ammo> ammoCls)
	{
		if (!ammoCls)
			return;
		for (int t = 0; t < PB_AmmoTypes.Size(); t++)
		{
			Array<String> parts;
			PB_AmmoTypes[t].Split(parts, ", ");
			if (parts.Size() < 4 || parts[3] != "Ammo")
				continue;
			if ((class<Ammo>)(Name(parts[1])) == ammoCls)
				pbHudAmmoRowVisible[t] = true;
		}
	}

	void PB2022_EnsureHudInvCache()
	{
		if (!plr || !CPlayer)
			return;

		int itemCount = CPlayer.itemcount;
		if (pbHudInvCacheGametic >= 0
			&& level.maptime - pbHudInvCacheGametic < PB_HUD_INV_CACHE_TICS
			&& itemCount == pbHudInvCacheItemCount)
			return;

		pbHudInvCacheGametic = level.maptime;
		pbHudInvCacheItemCount = itemCount;

		pbHudCachedKeyClass.Clear();
		pbHudCachedPowerupClass.Clear();
		pbHudCachedPowerupTics.Clear();

		pbHudAmmoRowVisible.Clear();
		pbHudAmmoRowVisible.Resize(PB_AmmoTypes.Size());
		for (int r = 0; r < pbHudAmmoRowVisible.Size(); r++)
			pbHudAmmoRowVisible[r] = !hideunusedtypes;

		for (Inventory ch = plr.Inv; ch != null; ch = ch.Inv)
		{
			if (ch is "Key")
				pbHudCachedKeyClass.Push(ch.GetClassName());

			let pwr = Powerup(ch);
			if (pwr)
			{
				pbHudCachedPowerupClass.Push(ch.GetClassName());
				pbHudCachedPowerupTics.Push(pwr.EffectTics);
			}

			if (!hideunusedtypes || !showList)
				continue;

			let weapItem = Weapon(ch);
			if (weapItem)
			{
				PB2022_MarkAmmoRowVisibleForAmmoType(weapItem.AmmoType1);
				PB2022_MarkAmmoRowVisibleForAmmoType(weapItem.AmmoType2);
			}

			Name chName = ch.GetClassName();
			for (int t = 0; t < PB_AmmoTypes.Size(); t++)
			{
				Array<String> parts;
				PB_AmmoTypes[t].Split(parts, ", ");
				if (parts.Size() >= 4 && parts[3] == "Equipment" && Name(parts[1]) == chName)
					pbHudAmmoRowVisible[t] = true;
			}
		}
	}

	String PB2022_PowerupHudImage(Name powerName)
	{
		switch (powerName)
		{
			case 'PowerInvulnerable':
			case 'PB_PowerInvul':
				return "PWRINVUL";
			case 'PowerIronFeet':
			case 'PB_PowerIronFeet':
				return "PWRRADSU";
			case 'PowerInvisibility':
			case 'PB_PowerInvis':
				return "PWRINVIS";
			case 'PowerLightAmp':
			case 'PB_PowerLightAmp':
				return "PWRINFRA";
			case 'PowerDamage':
			case 'PB_PowerDoomDamage':
				return "PWRQUADD";
			case 'PowerSpeed':
			case 'PB_PowerSpeed':
				return "PWRHASTE";
		}
		return "TNT1A0";
	}

	override void Tick()
	{
		plr = PlayerPawn(CPlayer.mo);
		Super.Tick();

        if(interference > 0 && gametic % 2) tickRandSeed = crandom(0, 2147483648);

        Health = CPlayer.Health;
		if (plr)
			Armor = GetAmount("BasicArmor");
		else
			Armor = 0;

        if(Health <= 0) 
        {
            DeathSequence(true);
            PlayerWasDead = true;
        }
        
        if(Health >= 1 && PlayerWasDead) 
        {
            DeathSequence(false);
            PlayerWasDead = false;
        }

        screenFXCount = bloodDrops.Size() + bloodSplatters.Size() * 2 + glassCracks.Size();

        if(dirtyScreenTimer == -1)
        {
            if(screenWiperPrg ~== 1.0)
            {
                screenWiperPrg = 0;
                wipePrgOldFrame = 0;
                for(int i = 0; i < bloodDrops.size(); i++)
                {
                    PB_BloodFXStorage bld = bloodDrops[i];
                    bld.Destroy();
                } bloodDrops.Clear();

                for(int i = 0; i < bloodSplatters.size(); i++)
                {
                    PB_BloodSplatterFXStorage bld = bloodSplatters[i];
                    bld.Destroy();
                } bloodSplatters.Clear();

                for(int i = 0; i < glassCracks.size(); i++)
                {
                    PB_CrackFXStorage crck = glassCracks[i];
                    crck.Destroy();
                } glassCracks.Clear();

                dirtyScreenTimer = 0;
                return;
            }
            wipePrgOldFrame = screenWiperPrg;
            screenWiperPrg += 0.025;

        }
        else if(dirtyScreenTimer < PB_SCREENWIPER_DELAY && screenFXCount >= PB_SCREENWIPER_THRESHOLD)
            dirtyScreenTimer++;
        else if(dirtyScreenTimer == PB_SCREENWIPER_DELAY)
        {
            dirtyScreenTimer = -1;
            S_StartSound("visor/screenwipe", CHAN_6, CHANF_OVERLAP);
        }

        /*if((cplayer.DesiredFov / cplayer.fov) >= 1.2 && oldFOV >= cplayer.fov && magnificationIndScale < 1.0)
            magnificationIndScale += 0.25;
        else if((((cplayer.DesiredFov / cplayer.fov) < 1.2) || ((cplayer.fov - oldFOV) > 10)) && magnificationIndScale > 0)
            magnificationIndScale -= 0.25;
        if(cplayer.DesiredFov != cplayer.fov) 
            oldFOV = cplayer.fov;*/

        if(cplayer.DesiredFov > cplayer.fov && magnificationIndScale < 1.0)
            magnificationIndScale += 0.25;
        else if(cplayer.DesiredFov == cplayer.fov && magnificationIndScale > 0)
            magnificationIndScale -= 0.25;

        if(dirtyScreenTimer == -1 && wiperWarningIndScale < 1.0)
            wiperWarningIndScale += 0.25;
        else if(dirtyScreenTimer != -1 && wiperWarningIndScale > 0)
            wiperWarningIndScale -= 0.25;

        if (interference > 0)
        {
            // crandom() is ~[-1,1]; comparing to 100 always passed and spammed SFX every tic.
            if (!muteinterference && (gametic % 8) == 0 && random(0, 255) < 48)
                S_StartSound("visor/interference", CHAN_AUTO, CHANF_OVERLAP, 0.5);
            interference--;
        }
		
		PBHUD_TickMessages();
		TickBloodDrops();
		TickGlassCracks();

		if (!plr)
			return;
		
		if(!CheckInventory("sae_extcam") && !HasCompletedHelmetSequence)
		{
			From32to0Slow();	
		}
		
		if(Dasher)
		{
			//console.printf("%i %i", oldDashCharge, Dasher.DashCharge);
			if(oldDashCharge == 16 && Dasher.DashCharge == 17)
				dashScale1 = 0.2;
			if(oldDashCharge == 34 && Dasher.DashCharge == 35)
				dashScale2 = 0.2;
			
			if(dashScale1 > 0.0)
				dashScale1 -= 0.02;
	
			if(dashScale2 > 0.0)
				dashScale2 -= 0.02;
			oldDashCharge = Dasher.DashCharge;
		}
        else if(plr)
            Dasher = DEDashJump(plr.FindInventory("DEDashJump"));

		if(Health <= 25)
		{
			inPain = true;
			healthFontCol = Font.CR_RED;
		}
		else
		{
			inPain = false;
			healthFontCol = cachedFontColors[HUDBLUEBAR];
		}

        if(showLevelStats)
        {
            levelStats[0] = Level.TimeFormatted();
            levelStats[1] = String.Format("%i / %i", Level.killed_monsters, Level.total_monsters);
            levelStats[2] = String.Format("%i / %i", Level.found_items, Level.total_items);
            levelStats[3] = String.Format("%i / %i", Level.found_secrets, Level.total_secrets);
        }

		dashIndAlpha -= 0.2;
		flashlightBatteryAlpha -= 0.2;

		if(hudDynamics && !automapactive)
			CalculateSway();
		
        weap = CPlayer.ReadyWeapon;
		pbWeap = PB_WeaponBase(weap);

		[Primary, Secondary] = GetCurrentAmmo();
		if(pbWeap && plr) Left = Ammo(plr.FindInventory(pbWeap.AmmoTypeLeft));
	
		//console.printf("%s", weap.GetClassName());

        if(CheckInventory("PowerStrength"))
		{
            double gameTicRadians = gameTic * 11.4592;
			berserkBeat = 0.1 * ((((sin(gameTicRadians) ** 13) * sin((gameTicRadians) + 85.944)) / 0.2096) + (sin(gameTicRadians - 286.48) ** 16) * 0.2);
        }
		
		if(oldweapon && (oldWeapon != weap))
		{
			if(Primary)
				mAmmo1Interpolator.Reset(Primary.Amount); 
			
			if(Secondary) 
				mAmmo2Interpolator.Reset(Secondary.Amount);
			
			if(Left)
				mAmmoLeftInterpolator.Reset(Left.Amount);
			mOverheatInterpolator.Reset(0);
			mOverheatLeftInterpolator.Reset(0);
		}

        if(plr)
        {
            sectorlightlevel = plr.cursector.lightlevel / 255.0;
            color slcol = plr.cursector.colormap.lightcolor;
            
            // [gng] i have heard that the color function is expensive, so i avoid running it if there's no need to.
            if(slcol != 16777215)
                flsectorlightcolor = Color(255, slcol.r, slcol.g, slcol.b);
            else
                flsectorlightcolor = 0xffffffff;
        }

		if(plr && m0to1Float > 0.99) {
			mHealthInterpolator.Update(Health);
			mArmorInterpolator.Update(GetAmount("BasicArmor"));
			mSwayInterpolator.Update(mSway);
			mPitchInterpolator.Update(mPitch);
			mFOffsetInterpolator.Update(mForwardOffset);
			
			if(Primary)
				mAmmo1Interpolator.Update(Primary.Amount); 
			
			if(Secondary)
				mAmmo2Interpolator.Update(Secondary.Amount); 
			
			if(Left)
				mAmmoLeftInterpolator.Update(Left.Amount); 
			
			if(pbWeap && pbWeap.maxOverheat > 0)
			{
				mOverheatInterpolator.Update(pbWeap.overheat);
				mOverheatLeftInterpolator.Update(pbWeap.leftOverheat);
			}
		}

        if(hudDynamics)
		{
			IntMSway = mSwayInterpolator.GetValue();
			IntMPitch = mPitchInterpolator.GetValue();
			IntMOfs = mFOffsetInterpolator.GetValue();

            ofsOldFrame = ofsCurrentFrame;
            swayOldFrame = swayCurrentFrame;
            ofsCurrentFrame = IntMOfs;
            swayCurrentFrame = (IntMSway, IntMPitch);
		}
		
        IntHealth = mHealthInterpolator.GetValue();
        MaxHealth = plr.GetMaxHealth();

        IntArmor = mArmorInterpolator.GetValue();
        MaxArmor = GetMaxAmount("BasicArmor");

        IntAmmo1 = mAmmo1Interpolator.GetValue();
		IntAmmo2 = mAmmo2Interpolator.GetValue();
        IntAmmoLeft = mAmmoLeftInterpolator.GetValue();

		oldWeapon = weap;
	}

	void From32to0Slow() {
		if(m0to1Float < 1.00 && HasPutOnHelmet) {
			m0to1Float += 0.1;
		}
		if(m32to0 > 0) {
			m32to0 -= 4;
		}
		if(m64to0 > 0) {
			m64to0 -= 1;
		}
		if(m32to0 == 0) {
			HasPutOnHelmet = true;
		}
		if(m64to0 == 0) {
			HasCompletedHelmetSequence = true;
		}
	}

    static const String KernelPanicMessages[] =
    {
        "-----BEGIN KERNEL LOGFILE-----",
        "Inventory Management FAIL",
        "Low Blood Volume",
        "Administering Morphine",
        "INSUFFICIENT POWER",
        "INSUFFICIENT POWER",
        "CRITICAL PROCESS hudman(10) DIED",
        "RESTARTING PROCESS hudman",
        "PROCESS hudman STARTED AT PID 100",
        "UACnix kernel message: RAM BANK #0 FAIL - FALLBACK",
        "UACnix kernel message: RAM BANK #1 FAIL - FALLBACK",
        "UACnix kernel message: OVERVOLTAGE DETECTED FROM CPU POWER",
        "UACnix kernel message: RAM_MANAGEMENT: KILLED oskrnlio(2)",
        "helm_mon(4): unexpected response from monitor GPIO pins",
        "Kernel panic - I/O failure: could not establish VITAL_LINK port (#338)",
        "UACnix kernel message: ERROR IN CPU: E10025U @ 20.50GHz - Small Advanced Devices, Inc.",
        "\cfKERNEL DIES HERE -->\c- Kernel panic - not syncing: Unable to recover from unrecoverable error recovery.",
        "-----END KERNEL LOGFILE-----",
        "",
        "-----BEGIN LOME LOGFILE-----",
        "LOME - UAC Microsystems, INC. Lights Out Management Engine v3.666",
        "LOME - System lost power at 00:00:00, Jan 1st, 1970",
        "LOME - Please replace CMOS battery!",
        "LOME - Automatic restart attempt...",
        "LOME - Automatic restart failed: could not establish uplink to MB_MAIN(MarsBase_Server1)",
        "LOME - Initiating diagno$$##@@GaaE",
        "\cfMNGMT ENGINE DIES HERE -->\c- [ FAIL ] WATCHDOG VIOLATION",
        "-----END LOME LOGFILE-----",
        "",
        "\cgTotal system failure: please contact UAC Microsystems for support.\c-"
    };
	
    int diedTic;
	void DeathSequence(bool Death) {
		if(death) {
			if(HasPutOnHelmet)
			{
                SetMusicVolume(0);
                if(diedTic == 0)
                    diedTic = level.MapTime;

                muteinterference = true;
                if(m0to1Float > 0.0 && !DeathFadeDone && helmetKernelPanic >= KernelPanicMessages.Size() - 7)
                {
                    m0to1Float *= (crandompick(50, 100, 150) * 0.01);
                    m0to1Float = clamp(m0to1Float, 0, 1);
                    
                    if(m0to1Float ~== 0.0)
                        DeathFadeDone = true;
                }

                if(!visorOff && helmetKernelPanic >= (KernelPanicMessages.Size()) && (level.MapTime >= (diedTic + (7.5 * TICRATE))))
                {
                    if(level.MapTime < (diedTic + (8 * TICRATE)))
                    {
                        interference += 2;
                        S_StartSound("visor/visorgarbled", CHAN_AUTO, CHANF_OVERLAP, 0.75);
                    }
                    else
                    {
                        S_StartSound("visor/dyingvisor", CHAN_AUTO, CHANF_OVERLAP);
                        visorOff = true;
                    }
                }

                if(helmetKernelPanic < KernelPanicMessages.Size() && (level.MapTime >= diedTic + 35))
                {
                    if(crandom() < 50)
                    {
                        helmetKernelPanic++;
						S_StartSound("visor/interference", CHAN_AUTO, CHANF_OVERLAP, 0.25);
                    }
                }
			}
		}
	  
		if(!death) {
            SetMusicVolume(1);
            muteinterference = false;
            helmetKernelPanic = 0;
			m0to1Float = 1.0;
			visorOff = DeathFadeDone = False;
            interference = diedTic = 0;
		}
	}
	
	void CalculateSway() {
		//Limit so it only counts when the player strafes.
		vector3 strafedir = (cos(plr.angle + 90), sin(plr.angle + 90), 0);
		double strafeSpeed = plr.vel dot strafedir;
		
		//Calculate offsets.
		double intSway = plr.angle - mOldAngles + Actor.Normalize180((strafeSpeed * 0.35));
		double intPitch = plr.pitch - mOldPitch - (plr.vel.z * 0.35);
		
		//The same concept as the comment above, but forwards.
		vector3 forwarddir = (cos(plr.angle + 180), sin(plr.angle + 180), 0);
		double forwardOffset = plr.vel dot forwarddir;

		//Detect if the player is on the ground and the old Z velocity is 8, if true, play the fall animation.
		bool onGround = plr.pos.Z <= plr.floorz;
		if(mOldZVel < -8 && onGround)
		{
			mFallOfs = clamp((mOldZVel * 0.50), 0, -9);
		}
		
		//Pointer to the PB player class.
		let PB_Player = PlayerPawnBase(plr);

		//Limit and add variables.
		if(PB_Player)
		{
			mSway = clamp(intSway + (PB_Player.XBob * 0.5) - plr.Roll, -8, 8);
			mPitch = clamp(intPitch + mFallOfs - (PB_Player.YBob * 0.5) + plr.Roll, -8, 8);
		}

		//Collect old information.
		mOldAngles = plr.angle;
		mOldPitch = plr.pitch;
		mOldZVel = plr.vel.z;

		//Calculate forward velocity.
		mForwardOffset = clamp((Actor.Normalize180(forwardOffset) * 0.35), -8, 8);
		mForwardOffset += (plr.player.fov - plr.player.DesiredFov) * 0.5;
		
		//Return the falling animation slowly.
		if(mFallOfs < 0.0) {
			mFallOfs += 0.5;
		}
	}

	double IntMSway;
	double IntMPitch;
	double IntMOfs;

	// [gng] pass the x and y parts of the vector to this function individually
	// you can't use the out keyword with vectors, so i had to improvise
	void SetSway(out double posX, out double posY, int flags, double parallax, double parallax2, bool applyDeadZone = true, bool applySpeedShift = true)
	{
		if(applyDeadZone) {
			switch(flags & DI_SCREEN_HMASK) {
				case DI_SCREEN_LEFT:
					posX += hudXMargin; break;
				case DI_SCREEN_RIGHT:
					posX -= hudXMargin; break;
				default: break;
			}
			switch(flags & DI_SCREEN_VMASK) {
				case DI_SCREEN_TOP:
					posY += hudYMargin; break;
				case DI_SCREEN_BOTTOM:
					posY -= hudYMargin; break;
				default: break;
			}
		}
		
		if(hudDynamics) {
			posX += interpolatedSway.x * Parallax;
			posY -= interpolatedSway.y * Parallax;

			if(!applySpeedShift)
				return;

			switch(flags & DI_SCREEN_HMASK) {
				case DI_SCREEN_LEFT:
					posX += (interpolatedOfs * Parallax2); break;
				case DI_SCREEN_RIGHT:
					posX -= (interpolatedOfs * Parallax2); break;
				default: break;
			}

			switch(flags & DI_SCREEN_VMASK) {
				case DI_SCREEN_TOP:
					posY += (interpolatedOfs * Parallax2); break;
				case DI_SCREEN_BOTTOM:
					posY -= (interpolatedOfs * Parallax2); break;
				default: break;
			}
		}
	}

	void PBHud_DrawImage(String texture, Vector2 pos, int flags = 0, double Alpha = 1., Vector2 box = (-1, -1), Vector2 scale = (1, 1), double Parallax = 0.75, double Parallax2 = 0.25, ERenderStyle style = STYLE_Translucent, Color col = 0xffffffff)
	{
		SetSway(pos.x, pos.y, flags, parallax, parallax2);

		DrawImage(texture, pos, flags, clamp(m0to1Float * Alpha, 0.0, Alpha), box, scale, style, col);
	}
	
	void PBHud_DrawImageManualAlpha(String texture, Vector2 pos, int flags = 0, double Alpha = 1., Vector2 box = (-1, -1), Vector2 scale = (1, 1), double Parallax = 0.75, double Parallax2 = 0.25, ERenderStyle style = STYLE_Translucent, Color col = 0xffffffff)
	{
		SetSway(pos.x, pos.y, flags, parallax, parallax2, false);

		DrawImage(texture, pos, flags, Alpha, box, scale, style, col);
	}
	
	bool PBHud_FlagCheck(int flags, int flag)
	{
		return ( flags & flag ) == flag;
	}
	
	void PBHud_DrawString(HUDFont font, String string, Vector2 pos, int flags = 0, int translation = Font.CR_UNTRANSLATED, double Alpha = 1., int wrapwidth = -1, int linespacing = 4, Vector2 scale = (1, 1), double Parallax = 0.75, double Parallax2 = 0.25, bool fuckFading = false) 
	{	   
		int fakeflags; //because my dumb ass didn't add screen alignment flags when i made this
		
		if ( !PBHud_FlagCheck(flags, DI_SCREEN_MANUAL_ALIGN) ) // don't need to do this if there are already alignment flags
		{
			if (pos.x < 0) 
				fakeflags |= DI_SCREEN_RIGHT;
			else 
				fakeflags |= DI_SCREEN_LEFT;

			if (pos.y < 0) 
				fakeflags |= DI_SCREEN_BOTTOM;
			else 
				fakeflags |= DI_SCREEN_TOP;
		}
		else
			fakeflags = flags;

		if(lowresfont && (font != mLowResFont)) {
			font = mLowResFont;
			scale *= 1.8;
			pos += (0, 2);
		}

		SetSway(pos.x, pos.y, fakeflags, parallax, parallax2);

        if(interference > 1)
        {
            string stringBuffer;
            for (uint i = 0; i < string.Length();)
            {
                int chr, next;
                [chr, next] = string.GetNextCodePoint(i);

                if(interference > PB_Math.PB_RandInt(0, 50, tickRandSeed * (chr * (1 + i))))
                    stringBuffer.AppendCharacter(PB_Math.PB_RandIntFromChars("!", "~", tickRandSeed * (chr * (1 + i))));
                else
                    stringBuffer.AppendCharacter(chr);

                i = next;
            }
            string = stringBuffer;
        }

		DrawString(font, string, pos, flags, translation, fuckFading ? Alpha : (m0to1Float * Alpha), wrapwidth, linespacing, scale);
	}

	String PB2022_MapHudBarFont(String name)
	{
		// Flat fallback (pb_hud_slanted_bars 0): map Staging slanted font names to PB2022 CURBAR strips.
		if (pbHudSlantedBars)
		{
			if (name == "ABARX") return "BGBARL";
			return name;
		}
		if (name == "HPBAR") return "BLUEBAR";
		if (name == "HOBAR" || name == "HLBAR") return "BLUEBAR2";
		if (name == "APBAR") return "GRBAR";
		if (name == "AOBAR") return "GRBAR2";
		if (name == "ABARX") return "BGBARL";
		if (name == "ABAR44" || name == "ABAR45" || name == "ABAR1" || name == "ABAR8") return "CURBAR1";
		if (name == "ABAR2") return "CURBAR2";
		if (name == "ABAR3") return "CURBAR3";
		if (name == "ABAR4") return "CURBAR4";
		if (name == "ABAR5") return "CURBAR5";
		if (name == "ABAR6") return "CURBAR6";
		if (name == "ABAR7") return "CURBAR7";
		return name;
	}

	void PBHUD_DrawSlantedBar(String ongfx, String offgfx, double curval, double maxval, vector2 position, int border, int vertical, int flags = 0, double alpha = 1.0)
	{
		for(int i=7;i>0;i--)
		{
			if(position.x < 0)
			{
				DrawBar(ongfx..i, offgfx, curval, maxval, position + (-6, 1), border, vertical, flags, alpha);
				position.x+=1;
			}
			else
			{
				DrawBar(ongfx..i, offgfx, curval, maxval, position + (6, 1), border, vertical, flags, alpha);
				position.x -= 1;
			}
			position.y-=2;
		}
	}
	
	void PBHud_DrawBar(String ongfx, String offgfx, double curval, double maxval, Vector2 pos, int border, int vertical, int flags = 0, double alpha = 1.0, double Parallax = 0.75, double Parallax2 = 0.25, bool slanted = true) 
	{
		ongfx = PB2022_MapHudBarFont(ongfx);
		SetSway(pos.x, pos.y, flags, parallax, parallax2);
		
		if (slanted && pbHudSlantedBars)
			PBHUD_DrawSlantedBar(ongfx, offgfx, curval, maxval, pos, border, vertical, flags, (m0to1Float * Alpha));
		else
			DrawBar(ongfx, offgfx, curval, maxval, pos, border, vertical, flags, (m0to1Float * Alpha));
	}

	void PBHud_DrawTexture(TextureID texture, Vector2 pos, int flags = 0, double Alpha = 1., Vector2 box = (-1, -1), Vector2 scale = (1, 1), double Parallax = 0.75, double Parallax2 = 0.25) 
	{
		SetSway(pos.x, pos.y, flags, parallax, parallax2);

		DrawTexture(texture, pos, flags, (m0to1Float * Alpha), box, scale);
	}
	
	void PBHud_DrawSpecialMugshot()
	{
		int mugflags; 
		string mug;

		if(customPBMugshot)
		{
			mugflags = MugShot.ANIMATEDGODMODE | MugShot.XDEATHFACE | MugShot.CUSTOM;
				
			if(plr.FindInventory("PowerInvisibility",true) || plr.bSHADOW)
				mug = isInvulnerable() ? "SGI" : "SCI";
			else 
				mug = isInvulnerable() ? "SGD" : "SFC";
		}
		else 
		{ 
			mugflags = MugShot.STANDARD; 
			mug = "STF"; 
		}
		if(CVar.GetCVar("hud_aspectscale",cplayer).GetBool() && CVar.GetCVar("hud_oldscale",cplayer).GetBool() && CVar.GetCVar("hud_scale",cplayer).GetInt() > -1 || customPBMugshot)
		{
			PBHud_DrawTexture(GetMugShot(5, mugflags, mug), (28.5, -65.5), DI_ITEM_OFFSETS | DI_SCREEN_LEFT_BOTTOM, scale: (1.25, 1.25));
		}
		else
		{
			PBHud_DrawTexture(GetMugShot(5, mugflags, mug), (27.5, -69.75), DI_ITEM_OFFSETS | DI_SCREEN_LEFT_BOTTOM, scale: (1.25, 1.5));
		}
	}
	
	////////////////////////////////////
	//	   RESERVE AMMO HUD		 //
	////////////////////////////////////
	
	static const String PB_AmmoTypes[] =
	{
		"AMMOIC2S, PistolBullets, Tan, Ammo",
		"AMMOIC3S, NewShell, Orange, Ammo",
		"AMMOIC1S, NewClip, Yellow, Ammo",
		"AMMOIC4S, RocketAmmo, Red, Ammo",
		"AMMOIC5S, Cell, Purple, Ammo",
		"AMMOIC6S, Gas, Gas, Ammo",
		"AMMOIC7S, Demonpower, Demonpower, Ammo",
		"HFRAGY, HandGrenadeAmmo, Green, Equipment",
		"HREVCY, MiniHellRocketAmmo, LightBlue, Equipment",
		"HMINEY, MineAmmo, Purple, Equipment",
		"HSTUNY, StunGrenadeAmmo, Cyan, Equipment"
	};
	
	void PB_AmmoListDrawer(vector2 initialpos, int step = 12) 
	{
		PB2022_EnsureHudInvCache();

		for (int i = 0; i < PB_AmmoTypes.Size(); i++)
		{
			if (hideunusedtypes && (i >= pbHudAmmoRowVisible.Size() || !pbHudAmmoRowVisible[i]))
				continue;

			Array<String> ammoTypeArray;
			PB_AmmoTypes[i].Split(ammoTypeArray, ", ");

			PBHud_DrawImage(ammoTypeArray[0], initialpos + (-12, -20), DI_SCREEN_RIGHT_BOTTOM, 1, (17, 13));
			PBHud_DrawString(mBoldFont, curmaxammolist ? FormatNumber(GetAmount(ammoTypeArray[1])).."/"..FormatNumber(GetMaxAmount(ammoTypeArray[1])) : FormatNumber(GetAmount(ammoTypeArray[1])), initialpos + (-25, -33), DI_SCREEN_RIGHT_BOTTOM | DI_TEXT_ALIGN_RIGHT, Font.FindFontColor(ammoTypeArray[2]), scale: (0.8, 0.8));
			initialpos.y -= step;
		}
	}

	////////////////////////////////////
	//		   AMMO HUD			 //
	////////////////////////////////////
	
	void PBHud_DrawAmmoNumber(String text, Vector2 pos, int fontTranslation)
	{
		PBHud_DrawString(mAmmoFont, text, pos, DI_TEXT_ALIGN_RIGHT, fontTranslation);
	}

	// PBX / SBARINFO_LEGACY_FULLSCREEN bottom-right weapon ammo layout (reserve row + magazine row + optional dual row).
	// barBorder (legacy BAMBAR*) is intentionally unused — Staging PB_Hud.DrawAmmoBar never drew it; BARBAC* backs + CURBAR* fills only.
	String PB2022_AmmoBarOffGfx()
	{
		// Slanted HUD: BARBAC* already shows the empty track; skip flat BGBARL under CURBAR layers.
		return pbHudSlantedBars ? "TNT1A0" : "BGBARL";
	}

	void PB2022_GetAmmoBarRowGfx(out string upperBG, out string fillBar)
	{
		upperBG = "BARBACC2";
		fillBar = "ABAR8";
		if (!Primary)
			return;
		switch (Primary.GetClassName())
		{
			case 'PistolBullets':
			case 'PB_LowCalMag':
				upperBG = "BARBACT2"; fillBar = "ABAR2"; break;
			case 'NewClip':
			case 'PB_HighCalMag':
				upperBG = "BARBACY2"; fillBar = "ABAR1"; break;
			case 'NewShell':
			case 'PB_Shell':
				upperBG = "BARBACO2"; fillBar = "ABAR3"; break;
			case 'RocketAmmo':
			case 'PB_RocketAmmo':
				upperBG = "BARBACR2"; fillBar = "ABAR4"; break;
			case 'Cell':
			case 'PB_Cell':
				upperBG = "BARBACP2"; fillBar = "ABAR5"; break;
			case 'Gas':
			case 'PB_Fuel':
				upperBG = "BARBACD2"; fillBar = "ABAR6"; break;
			case 'Demonpower':
			case 'PB_DTech':
				upperBG = "BARBACZ2"; fillBar = "ABAR7"; break;
		}
	}

	// Secondary-row heat meter (BARBAC* chassis + slanted CURBAR fill). useDualRow = true when a magazine row already occupies the secondary slot (Neo HMG, etc.).
	void PB2022_DrawHeatMeterRow(string rowBG, string fillBar, double cur, double max, bool useDualRow, bool drawHeatLabel = false)
	{
		Vector2 bgPos = useDualRow ? (-73, -65) : (-72, -49);
		Vector2 barPos = useDualRow ? (-111, -68) : (-111, -52);
		PBHud_DrawImage(rowBG, bgPos, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
		PBHud_DrawBar(fillBar, PB2022_AmmoBarOffGfx(), cur, max, barPos, 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
		if (drawHeatLabel)
		{
			int labelY = useDualRow ? -73 : -57;
			PBHud_DrawString(mBoldFont, "HEAT", (-145, labelY), DI_SCREEN_RIGHT_BOTTOM | DI_TEXT_ALIGN_LEFT, Font.CR_RED, scale: (0.5, 0.5));
		}
	}

	void PB2022_DrawZScriptOverheatMeters()
	{
		if (!pbWeap || pbWeap.maxOverheat <= 0 || !weap)
			return;
		if (weap.GetClassName() == 'PB_MG42')
			return;

		string rowBG, fillBar;
		PB2022_GetAmmoBarRowGfx(rowBG, fillBar);
		bool useDualRow = Secondary != null;
		int heat = mOverheatInterpolator.GetValue();
		int lheat = mOverheatLeftInterpolator.GetValue();

		PB2022_DrawHeatMeterRow(rowBG, fillBar, heat, pbWeap.maxOverheat, useDualRow, false);
		Vector2 tempPos = useDualRow ? (-118, -81) : (-118, -64);
		PBHud_DrawString(mDefaultFont, String.Format("%u°C", pbWeap.Overheat), tempPos, DI_SCREEN_RIGHT_BOTTOM | DI_TEXT_ALIGN_RIGHT, Font.CR_RED, scale: (0.5, 0.5));

		if (PB2022_WantsDualAmmoRow())
		{
			PB2022_DrawHeatMeterRow(rowBG, fillBar, lheat, pbWeap.maxOverheat, true, false);
			PBHud_DrawString(mDefaultFont, String.Format("%u°C", pbWeap.leftOverheat), (-108, -85.5), DI_SCREEN_RIGHT_BOTTOM | DI_TEXT_ALIGN_RIGHT, Font.CR_RED, scale: (0.5, 0.5));
		}
	}

	void DrawAmmoBar(string lowerBG, string upperBG, string dualBG, string barBorder, string currentBar, string reserveBar, string ammoIcon, int fontTranslation = 0, bool drawNumbers = true, bool drawPrimary = true, bool drawSecondary = true, bool drawDual = true, bool drawIcon = true)
	{
		if (!weap)
			return;

		bool magUnloaded = pbWeap && pbWeap.magUnloaded;
		bool leftMagUnloaded = pbWeap && pbWeap.leftMagUnloaded;
		String barOff = PB2022_AmmoBarOffGfx();

		if (drawPrimary && Primary)
		{
			PBHud_DrawImage(lowerBG, (-73, -17), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
			PBHud_DrawBar(reserveBar, barOff, IntAmmo1, Primary.MaxAmount, (-122, -32), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
			if (drawNumbers)
				PBHud_DrawAmmoNumber(Formatnumber(Primary.Amount), (-216, -49), fontTranslation);
		}
		if (drawSecondary && Secondary)
		{
			PBHud_DrawImage(upperBG, (-72, -49), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
			PBHud_DrawBar(magUnloaded ? "ABARX" : currentBar, barOff, IntAmmo2, Secondary.MaxAmount, (-111, -52), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
			if (drawNumbers)
				PBHud_DrawAmmoNumber(Formatnumber(Secondary.Amount), (-205, -69), magUnloaded ? Font.CR_DARKGRAY : fontTranslation);
		}

		if (drawDual && Left && PB2022_WantsDualAmmoRow())
		{
			PBHud_DrawImage(dualBG, (-73, -65), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
			PBHud_DrawBar(leftMagUnloaded ? "ABARX" : currentBar, barOff, IntAmmoLeft, Left.MaxAmount, (-111, -68), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
			if (drawNumbers)
				PBHud_DrawAmmoNumber(Formatnumber(Left.Amount), (-205, -85), leftMagUnloaded ? Font.CR_DARKGRAY : fontTranslation);
		}

		if (drawIcon)
			PBHud_DrawImage(ammoIcon, (-66, -17), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha, (17, 17));
	}

	////////////////////////////////////
	//			KEY HUD			 //
	////////////////////////////////////
	
	// Whitelist of key item classes that are allowed to draw on the HUD.
	static const String KeyAllowList[] =
	{
		"BlueCard",
		"RedCard",
		"YellowCard",
		"BlueSkull",
		"RedSkull",
		"YellowSkull"
	};
	
	virtual void DrawKeys(vector2 pos, int keycount = 10, int space = 21)
	{
		PB2022_EnsureHudInvCache();

		textureid icon;
		vector2 size;
		bool scaleup;
		keyamount = 0;

		for (int ki = 0; ki < pbHudCachedKeyClass.Size(); ki++)
		{
			if (keyamount >= keycount)
				break;

			Name keyactorname = pbHudCachedKeyClass[ki];
			let keyInv = Inventory(plr.FindInventory(keyactorname));
			if (!keyInv)
				continue;

			icon = keyInv.AltHUDIcon;
			if (!icon.isValid())
			{
				if (keyInv.SpawnState && keyInv.SpawnState.sprite != 0)
					icon = keyInv.SpawnState.GetSpriteTexture(0);
				else
					icon = keyInv.Icon;
				if (!icon.isValid())
					continue;
			}

			// Only draw keys that are on the allow-list; skip others
			bool allowedKey = false;
			for (int ai = 0; ai < KeyAllowList.Size(); ai++)
			{
				if (keyactorname == KeyAllowList[ai])
				{
					allowedKey = true;
					break;
				}
			}
			if (!allowedKey)
				continue;

			size = TexMan.GetScaledSize(icon);
			scaleup = (size.x <= 11 && size.y <= 11);
			// Draw keys anchored to bottom-left (we'll place them above the mugshot)
			PBHud_DrawTexture(icon, pos, DI_SCREEN_LEFT_BOTTOM | DI_ITEM_CENTER, box: (10, 10), scaleup ? (2, 2) : (1, 1));
			pos.x -= space;
			keyamount++;
		}
	}
	
	override void DrawPowerups() {} //blank this out so it doesn't cause issues
	
	string FormatPowerupTime(Powerup item)
	{
		int sec = 1 + Thinker.Tics2Seconds(item.EffectTics);
		return String.Format("%02d:%02d", (sec % 3600) / 60, sec % 60);
	}
	
	void PB_DrawPowerups(vector2 initialpos, int step = 22) 
	{
		PB2022_EnsureHudInvCache();

		for (int pi = 0; pi < pbHudCachedPowerupClass.Size(); pi++)
		{
			Name powerName = pbHudCachedPowerupClass[pi];
			String image = PB2022_PowerupHudImage(powerName);
			if (TexMan.GetName(TexMan.CheckForTexture(image, TexMan.Type_Any)) == "TNT1A0")
				continue;

			int effectTics = pbHudCachedPowerupTics[pi];
			int sec = 1 + Thinker.Tics2Seconds(effectTics);
			String powerTime = String.Format("%02d:%02d", (sec % 3600) / 60, sec % 60);
			int fontCol = Font.FindFontColor(powerName);
			PBHud_DrawImage(image, initialpos, DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, playerBoxAlpha);
			PBHud_DrawString(mBoldFont, powerTime, (initialpos.x + 28, initialpos.y - 20), DI_SCREEN_LEFT_BOTTOM | DI_TEXT_ALIGN_LEFT, fontCol);
			initialpos.y -= step;
		}
	}
	
	////////////////////////////////////
	//		   HUD LOGIC			//
	////////////////////////////////////
	
	void DrawFullScreenStuff()
	{
        plr = PlayerPawn(CPlayer.mo);
		
		if (CheckInventory("CameraRunner"))
			return;

		if (plr)
			PB2022_EnsureHudInvCache();

		if(plr) {
			////////////////////////////////////
			//		  HEALTH HUD			//
			////////////////////////////////////			

			//WARNING: vile
			if (PB2022_HUD_DRAW_VISOR_IN_STATUSBAR && !CheckInventory("sae_extcam") && !automapactive) {
                /*vector2 posbuffer = (Screen.GetWidth() / 2.f, Screen.GetHeight() / 2.f);
                vector2 hudscale = GetHUDScale();
                posbuffer.x /= hudscale.x;
                posbuffer.y /= hudscale.y;
                SetSway(posbuffer.x, posbuffer.y, 0, 0.6, 0.15, false, false);
                posbuffer.x *= hudscale.x;
                posbuffer.y *= hudscale.y;

                // dirt and scratches
                Screen.DrawTexture(TexMan.CheckForTexture("GRAPHICS/LensDirt.png"), false, 
                    posbuffer.x, posbuffer.y, 
                    DTA_DestWidth, Screen.GetWidth(), DTA_DestHeight, Screen.GetHeight(), 
                    DTA_Alpha, 0.5 + (sectorlightlevel * 0.5), 
                    DTA_Color, flsectorlightcolor, 
                    DTA_CenterOffset, true, 
                    DTA_ScaleX, 1.25, DTA_ScaleY, 1.25
                );*/

                int visorFlags;
                for(int i = 0; i < 2; i++)
                {
                    bool left = i == 0;
                    if(left)
                        visorFlags = DI_ITEM_LEFT | DI_SCREEN_LEFT;
                    else
                        visorFlags = DI_ITEM_RIGHT | DI_SCREEN_RIGHT | DI_MIRROR;

                    vector2 topOffsets = ((left ? -24 - visorOffsets : 24 + visorOffsets) + (left ? -m32to0 : m32to0), -24 - visorOffsets - m32to0);
                    vector2 bottomOffsets = ((left ? -24 - visorOffsets : 24 + visorOffsets) + (left ? -m32to0 : m32to0), 24 + visorOffsets + m32to0);

                    vector2 topOffsetsGlass = topOffsets + ((left ? -6 : 6), -6);
                    vector2 bottomOffsetsGlass = bottomOffsets + ((left ? -6 : 6), 6);

					if(CheckInventory("PowerLightAmp"))
						PBHud_DrawImageManualAlpha("NIGHTVIS", (topOffsets.x, 0), visorFlags | DI_ITEM_VCENTER | DI_SCREEN_VCENTER, max(0.5,sin(level.MapTime * 2)), scale: (0.3, 0.3), parallax: 1.5, parallax2: 1.5);
					if(CheckInventory("PowerIronFeet"))
						PBHud_DrawImageManualAlpha("RADSUIT", (topOffsets.x, 0), visorFlags | DI_ITEM_VCENTER | DI_SCREEN_VCENTER, 0.5 + abs(sin(level.MapTime)), scale: (0.3, 0.3), parallax: 1.0, parallax2: 1.0);

                    if(showVisorGlass) {
                        if(m0to1Float < 1.0) {
                            PBHud_DrawImageManualAlpha("HUDTPOF2", topOffsetsGlass, visorFlags | DI_ITEM_TOP | DI_SCREEN_TOP, clamp((1 - m0to1Float) * playerAlpha, 0.0, playerAlpha), scale: (visorScale, visorScale), 0.6, 0.75);  
                            PBHud_DrawImageManualAlpha("HUDBTOF2", bottomOffsetsGlass, visorFlags | DI_ITEM_BOTTOM | DI_SCREEN_BOTTOM, clamp((1 - m0to1Float) * playerAlpha, 0.0, playerAlpha), scale: (visorScale, visorScale), 0.6, 0.75);   
                        }
                    
                        PBHud_DrawImageManualAlpha("HUDTOP2", topOffsetsGlass, visorFlags | DI_ITEM_TOP | DI_SCREEN_TOP, clamp(m0to1Float * playerAlpha, 0.0, playerAlpha), scale: (visorScale, visorScale), 0.6, 0.75);
                        PBHud_DrawImageManualAlpha("HUDBOTO2", bottomOffsetsGlass, visorFlags | DI_ITEM_BOTTOM | DI_SCREEN_BOTTOM, clamp(m0to1Float * playerAlpha, 0.0, playerAlpha), scale: (visorScale, visorScale), 0.6, 0.75);   
                    }
                
                    if(showVisor) {
                        // darkness underlays
                        PBHud_DrawImageManualAlpha("HUDTDARK", topOffsets, visorFlags | DI_ITEM_TOP | DI_SCREEN_TOP, 1, scale: (visorScale, visorScale), col: flsectorlightcolor);  
                        PBHud_DrawImageManualAlpha("HUDBDARK", bottomOffsets, visorFlags | DI_ITEM_BOTTOM | DI_SCREEN_BOTTOM, 1, scale: (visorScale, visorScale), col: flsectorlightcolor);   
                            
                        // visor corners
                        PBHud_DrawImageManualAlpha("HUDTOPOF", topOffsets, visorFlags | DI_ITEM_TOP | DI_SCREEN_TOP, sectorlightlevel, scale: (visorScale, visorScale), col: flsectorlightcolor);  
                        PBHud_DrawImageManualAlpha("HUDBOTOF", bottomOffsets, visorFlags | DI_ITEM_BOTTOM | DI_SCREEN_BOTTOM, sectorlightlevel, scale: (visorScale, visorScale), col: flsectorlightcolor);   
                        
                        // lens flares
                        PBHud_DrawImageManualAlpha("HUDTFLAR", topOffsets, visorFlags | DI_ITEM_TOP | DI_SCREEN_TOP, m0to1float * ( 1.0 - (sectorlightlevel)), scale: (visorScale, visorScale), style: STYLE_Add);  
                        PBHud_DrawImageManualAlpha("HUDBFLAR", bottomOffsets, visorFlags | DI_ITEM_BOTTOM | DI_SCREEN_BOTTOM, m0to1float * ( 1.0 - (sectorlightlevel)), scale: (visorScale, visorScale), style: STYLE_Add);
                        
                        // hologram beam
                        PBHud_DrawImageManualAlpha("HUDTOP", topOffsets, visorFlags | DI_ITEM_TOP | DI_SCREEN_TOP, m0to1Float, scale: (visorScale, visorScale), style: STYLE_Add);  
                        PBHud_DrawImageManualAlpha("HUDBOTOM", bottomOffsets, visorFlags | DI_ITEM_BOTTOM | DI_SCREEN_BOTTOM, m0to1Float, scale: (visorScale, visorScale), style: STYLE_Add);   
                    }
                }

                if(showVisorGlass)
                {
                    if(bottomMiddlePart == 1 || bottomMiddlePart == 2) 
                    {    
                        if(m0to1Float < 1.0)
                            PBHud_DrawImageManualAlpha("HUDMIOF2", (0, 50 + visorOffsets + m32to0), DI_ITEM_BOTTOM | DI_SCREEN_CENTER_BOTTOM | DI_MIRRORY, clamp((1 - m0to1Float) * playerAlpha, 0.0, playerAlpha), scale: (visorScale, visorScale), 0.6, 0.75);  
                        PBHud_DrawImageManualAlpha("HUDMIDD2", (0, 50 + visorOffsets + m32to0), DI_ITEM_BOTTOM | DI_SCREEN_CENTER_BOTTOM | DI_MIRRORY, clamp(m0to1Float * playerAlpha, 0.0, playerAlpha), scale: (visorScale, visorScale), 0.6, 0.75);
                    }
                    if(bottomMiddlePart == 0 || bottomMiddlePart == 2)
                    {
                        if(m0to1Float < 1.0)
                            PBHud_DrawImageManualAlpha("HUDMIOF2", (0, -50 - visorOffsets - m32to0), DI_ITEM_TOP | DI_SCREEN_CENTER_TOP, clamp((1 - m0to1Float) * playerAlpha, 0.0, playerAlpha), scale: (visorScale, visorScale), 0.6, 0.75);  
                        PBHud_DrawImageManualAlpha("HUDMIDD2", (0, -50 - visorOffsets - m32to0), DI_ITEM_TOP | DI_SCREEN_CENTER_TOP, clamp(m0to1Float * playerAlpha, 0.0, playerAlpha), scale: (visorScale, visorScale), 0.6, 0.75);
                    }
                }

                if(showVisor) {     
                    if(bottomMiddlePart == 1 || bottomMiddlePart == 2) 
                    {
                        PBHud_DrawImageManualAlpha("HUDMDARK", (0, 44 + visorOffsets + m32to0), DI_ITEM_BOTTOM | DI_SCREEN_CENTER_BOTTOM | DI_MIRRORY, 1, scale: (visorScale, visorScale), col: flsectorlightcolor); 
                        PBHud_DrawImageManualAlpha("HUDMIDOF", (0, 44 + visorOffsets + m32to0), DI_ITEM_BOTTOM | DI_SCREEN_CENTER_BOTTOM | DI_MIRRORY, sectorlightlevel, scale: (visorScale, visorScale), col: flsectorlightcolor);   
                    }
                    if(bottomMiddlePart == 0 || bottomMiddlePart == 2)
                    {
                        PBHud_DrawImageManualAlpha("HUDMDARK", (0, -44 - visorOffsets - m32to0), DI_ITEM_TOP | DI_SCREEN_CENTER_TOP, 1, scale: (visorScale, visorScale), col: flsectorlightcolor); 
                        PBHud_DrawImageManualAlpha("HUDMIDOF", (0, -44 - visorOffsets - m32to0), DI_ITEM_TOP | DI_SCREEN_CENTER_TOP, sectorlightlevel, scale: (visorScale, visorScale), col: flsectorlightcolor);   
                    }
                }
			}

            if(diedTic > 0 && level.MapTime >= diedTic + 17)
            {
                if(visorOff) 
                    return;

                int onDeathTic = level.MapTime - (diedTic + 18);
                Vector2 hudscale = GetHUDScale();
                PBHud_DrawImageManualAlpha("GRAPHICS/HUD/FULLSCRN/UAC-BIOSLogo.png", (16, 37), DI_ITEM_LEFT_TOP | DI_SCREEN_LEFT_TOP);
                if(onDeathTic >= 1) PBHud_DrawString(mTerminalFont, "OpenBIOS (C) 1989-2054 UAC Microsystems, INC.", (277, 81), DI_TEXT_ALIGN_LEFT | DI_SCREEN_LEFT_TOP, FONT.CR_UNTRANSLATED, fuckFading: true);
                if(onDeathTic >= 3) PBHud_DrawString(mTerminalFont, "UAC Defense Embedded B1050E-A1 Revision 0", (277, 59), DI_TEXT_ALIGN_LEFT | DI_SCREEN_LEFT_TOP, FONT.CR_UNTRANSLATED, fuckFading: true);
                if(onDeathTic >= 4) PBHud_DrawString(mTerminalFont, "SAD(r) Praetorian(tm) E10025U @ 20.50GHz", (277, 37), DI_TEXT_ALIGN_LEFT | DI_SCREEN_LEFT_TOP, FONT.CR_UNTRANSLATED, fuckFading: true);
                SetClipRect(0, 130, Screen.GetWidth() / hudscale.x, Screen.GetHeight() / hudscale.y, DI_SCREEN_LEFT_TOP);
                if(helmetKernelPanic > 0) {
                    int spacing;
                    for(int i = helmetKernelPanic; i > 0; i--)
                    {
                        PBHud_DrawString(mTerminalFont, KernelPanicMessages[i - 1], (16, -37 + spacing), DI_TEXT_ALIGN_LEFT | DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, FONT.CR_UNTRANSLATED, (i - 1 == KernelPanicMessages.Size() - 1) ? round(0.5*(1+sin(2 * M_PI * 1 * gameTic))) : 1.0, fuckFading: true);
                        spacing -= 16;
                    }
                }
                ClearClipRect();

                return;
            }                
            
			PBHUD_DrawMessages();

            if(magnificationIndScale > 0)
                PBHud_DrawString(mBoldFont, String.Format("%.2fx", cplayer.DesiredFov / cplayer.fov), (0, -32), DI_SCREEN_CENTER_BOTTOM | DI_TEXT_ALIGN_CENTER | DI_ITEM_CENTER, alpha: 0.5, scale: (1.25 + (1 - magnificationIndScale), clamp(magnificationIndScale, 0, 1)));

            if(wiperWarningIndScale > 0) 
                PBHud_DrawString(mBoldFont, "AUTOMATIC WIPER ENGAGED", (0, -64), DI_SCREEN_CENTER_BOTTOM | DI_TEXT_ALIGN_CENTER | DI_ITEM_CENTER, alpha: 0.5, scale: ((1.25 + (1 - wiperWarningIndScale)) * 0.75, clamp(wiperWarningIndScale, 0, 1) * 0.75));

			//Armorbar
			PBHud_DrawImage("BARBACK2", (72, -17), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, playerBoxAlpha);
			
			PBHud_DrawBar("APBAR", "BGBARL", IntArmor, min(MaxArmor, 100), (122, -32), 0, 0, DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM);
			
			if(Armor > 100)
				PBHud_DrawBar("AOBAR", "BGBARL", IntArmor - 100, min(MaxArmor, 100), (122, -32), 0, 0, DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM);
			
			PBHud_DrawString(mDefaultFont, FormatNumber(Armor), (214, -48.75), DI_TEXT_ALIGN_LEFT, cachedFontColors[HUDGREENBAR2] );
			
			int svpr = GetArmorSavePercent();

			if(svpr >= 0 && svpr < 32)
				PBHud_DrawImage("ARMRHUD1", (78, -20), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, 1);
			else if(svpr >= 32 && svpr < 39)
				PBHud_DrawImage("ARMRHUD2", (78, -20), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, 1);
			else if(svpr >= 39 && svpr < 70)
				PBHud_DrawImage("ARMRHUD3", (78, -20), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, 1);
			else if(svpr >= 70)
				PBHud_DrawImage("ARMRHUD4", (78, -20), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, 1);
			
			PBHud_DrawString(mBoldFont, Formatnumber(svpr), (89.8, -41), DI_TEXT_ALIGN_CENTER, Font.CR_WHITE, scale: (0.8, 0.8));
			
			//Healthbar
			if(GetAirTime() < 700)
				PBHud_DrawString(mBoldFont, "O²: "..(Formatnumber(((GetAirTime() / 7.0) * 100.0) / 100.0)).."%", (190, -90), DI_TEXT_ALIGN_LEFT, cachedFontColors[HUDBLUEBAR]);

			PBHud_DrawImage(inPain ? "BARBCK1L" : "BARBACK1", (73, -49), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, playerBoxAlpha);
			
			if(dasher) {
				/*PBHud_DrawBar("DASHHUD2", "DASHHUD1", Dasher.DashCharge, 17.5, (252, -51), 0, 0, DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, clamp(dashIndAlpha, 0.0, 1.0), slanted: false);
				PBHud_DrawBar("DASHHUD2", "DASHHUD1", Dasher.DashCharge - 17.5, 17.5, (261, -51), 0, 0, DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, clamp(dashIndAlpha, 0.0, 1.0), slanted: false);*/
				if(CheckInventory("PowerSpeed")) {
					PBHud_DrawImage("DASHHUD3", (251, -60), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_VCENTER | DI_ITEM_LEFT);
					PBHud_DrawImage("DASHHUD3", (275, -60), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_VCENTER | DI_ITEM_RIGHT);
					dashIndAlpha = 5.0;
				}
				else {
					PBHud_DrawImage(Dasher.DashCharge >= 17.5 ? "DASHHUD2" : "DASHHUD1", (251 - 9 * dashScale2, -60), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_VCENTER | DI_ITEM_LEFT, clamp(dashIndAlpha, 0.0, 1.0), scale: (1 + dashScale1, 1 + dashScale1));
					PBHud_DrawImage(Dasher.DashCharge >= 35 ? "DASHHUD2" : "DASHHUD1", (275 + 9 * dashScale1, -60), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_VCENTER | DI_ITEM_RIGHT, clamp(dashIndAlpha, 0.0, 1.0), scale: (1 + dashScale2, 1 + dashScale2));
					
					if(Dasher.DashCharge != 35 && dashIndAlpha < 1) {
						dashIndAlpha = 5.0;
					}
				}
			}
			
			PBHud_DrawBar(inPain ? "HOBAR" : "HPBAR", "BGBARL", IntHealth, min(MaxHealth, 100), (111, -52), 0, 0, DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM);
			
			if(Health > 100)
				PBHud_DrawBar("HLBAR", "BGBARL", IntHealth - 100, min(MaxHealth, 200), (112, -52), 0, 0, DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM);
			
			PBHud_DrawString(mDefaultFont, Formatnumber(Health), (203, -68.75), DI_TEXT_ALIGN_LEFT, healthFontCol);
				
			// health indicator is here because sometimes it overlaps the armor bar
			if(CheckInventory("PowerStrength"))
			{
				// the stupid fucking berserk indicator that i spent too much time on
				PBHud_DrawImage("BZRKHUD",  (93, -60), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_CENTER, scale: (1.0 + berserkBeat, 1.0 + berserkBeat));
			}
			
			if(Health > 100)
				PBHud_DrawImage("OVERHUD", (93, -60), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_CENTER);
			else
				PBHud_DrawImage(inPain ? "LHLTHHUD" : "HLTHHUD", (93, -60), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_CENTER);

			//Mugshot
            if(!multiplayer)
			    PBHud_DrawImage("EQUPBO", (17, -17), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, playerBoxAlpha);
            else
            {
                Color pcol = PB_Math.PB_DesaturateColor(CPlayer.GetDisplayColor());
                PBHud_DrawImage("EQUPBOMP", (17, -17), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, playerBoxAlpha, col: pcol);
            }
			
			PBHud_DrawSpecialMugshot();
            
            if(multiplayer) {
                int plrNum = plr.PlayerNumber();
                PBHud_DrawString(mBoldFont, String.Format("P%i | %s %s", plrnum + 1, CPlayer.GetUserName(), (net_arbitrator == plrnum) ? "(Arbitrator)" : "(Client)"), (16, -95), DI_SCREEN_LEFT_BOTTOM, Font.CR_UNTRANSLATED, alpha: 0.25);

                int ofs;
                for(int i = 0; i < players.Size(); i++)
                {
                    if(i == plrnum) continue;

                    PlayerInfo buddy = players[i];
                    if(!buddy || !buddy.mo) continue;

                    if(deathmatch || (teamplay && buddy.GetTeam() != players[consolePlayer].GetTeam()))
                        continue;

                    Color bcol = PB_Math.PB_DesaturateColor(buddy.GetDisplayColor());
                    string nameString = String.Format("%s\c- - \c%s%iHP\c- / \cd%iAP\c-", buddy.GetUserName(), (buddy.mo.Health < 25) ? "g" : "v", buddy.mo.Health, buddy.mo.CountInv("BasicArmor"));
                    double nameStringLength = mBoldFont.mFont.StringWidth(nameString);
                    PBHud_DrawString(mBoldFont, nameString, (-15, 50 + ofs), DI_SCREEN_RIGHT_TOP | DI_TEXT_ALIGN_RIGHT, Font.CR_UNTRANSLATED);
                    PBHud_DrawImage("GRAPHICS/MPColorDot.png", (-17 - namestringlength, 54 + ofs + (mBoldFont.mFont.GetHeight() / 2.f)), DI_SCREEN_RIGHT_TOP | DI_ITEM_RIGHT, scale: (0.15, 0.15), col: bcol);
                    // PBHud_DrawString(mBoldFont, FormatNumber(i + 1), (-24.8 - namestringlength, 51.5 + ofs), DI_SCREEN_RIGHT_TOP | DI_TEXT_ALIGN_CENTER, Font.CR_UNTRANSLATED, scale: (0.8, 0.8));
                    ofs += 14;
                }
            }
			
			//Powerups
			PB_DrawPowerups((16, -76));
			
			// Keys: draw below the green armor bar, centered in the lower HUD gap
			if (keyamount > 0)
				PBHud_DrawImage("KEYCRBOX", (248, -11), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_CENTER, playerBoxAlpha);
			
			// Draw small 10x10 key icons centered under the end of the armor bar
			DrawKeys((248, -11), 12, 12);
			
			if(showLevelStats) 
			{
				//Level Stats
				PBHud_DrawImage("LEVLSTAT", (15, 17), DI_SCREEN_LEFT_TOP | DI_ITEM_LEFT_TOP, playerBoxAlpha, scale: (1.2, 1.0));

				//time
				PBHud_DrawImage("1TIME", (25, 25), DI_SCREEN_LEFT_TOP | DI_ITEM_LEFT_TOP);
				PBHud_DrawString(mBoldFont, levelStats[0], (37, 27), 0, Font.CR_YELLOW, scale: (0.6, 0.6));
				
				//kills
				PBHud_DrawImage("1KILLS", (25, 36), DI_SCREEN_LEFT_TOP | DI_ITEM_LEFT_TOP);
				PBHud_DrawString(mBoldFont, levelStats[1], (37, 38), 0, Font.CR_WHITE, scale: (0.6, 0.6));
				
				//items
				PBHud_DrawImage("1ITEMS", (25, 47), DI_SCREEN_LEFT_TOP | DI_ITEM_LEFT_TOP);
				PBHud_DrawString(mBoldFont, levelStats[2], (37, 49), 0, Font.CR_GREEN, scale: (0.6, 0.6));
				
				//secrets
				PBHud_DrawImage("1SECRET", (25, 58), DI_SCREEN_LEFT_TOP | DI_ITEM_LEFT_TOP);
				PBHud_DrawString(mBoldFont, levelStats[3], (37, 60), 0, Font.CR_PURPLE, scale: (0.6, 0.6));
			}
			
			//DrawMessagesInArray();

			////////////////////////////////////
			//		 AMMOBAR HUD			//
			////////////////////////////////////
			
			if(weap && !(weap is "LedgeGrabWeapon"))
			{
				//Ammo bars
				if(showList)
					PB_AmmoListDrawer((-10, -60));

				bool weaponAmmoHandled = PB2022_DrawWeaponAmmoSpecial();
				
                if(!weaponAmmoHandled && Primary) 
                {
                    switch(Primary.GetClassName())
                    {
                        case 'PistolBullets':
                        case 'PB_LowCalMag':
                            weaponBarAccent = Font.CR_TAN;
                            DrawAmmoBar("BARBACT1", "BARBACT2", "BARBACT3", "BAMBAR2", "ABAR2", "ABAR2", "AMMOIC2", Font.CR_TAN);
                            break;
                        case 'NewClip':
                        case 'PB_HighCalMag':
                            weaponBarAccent = Font.CR_YELLOW;
                            DrawAmmoBar("BARBACY1", "BARBACY2", "BARBACY3", "BAMBAR1", "ABAR1", "ABAR1", "AMMOIC1", Font.CR_YELLOW);
                            break;
                        case 'NewShell':
                        case 'PB_Shell':
                            weaponBarAccent = Font.CR_ORANGE;
                            DrawAmmoBar("BARBACO1", "BARBACO2", "BARBACO3", "BAMBAR3", "ABAR3", "ABAR3", "AMMOIC3", Font.CR_ORANGE);
                            break;
                        case 'RocketAmmo':
                        case 'PB_RocketAmmo':
                            weaponBarAccent = Font.CR_RED;
                            DrawAmmoBar("BARBACR1", "BARBACR2", "BARBACR3", "BAMBAR4", "ABAR4", "ABAR4", "AMMOIC4", Font.CR_RED);
                            break;
                        case 'Cell':
                        case 'PB_Cell':
                            weaponBarAccent = Font.CR_PURPLE;
                            DrawAmmoBar("BARBACP1", "BARBACP2", "BARBACP3", "BAMBAR5", "ABAR5", "ABAR5", "AMMOIC5", Font.CR_PURPLE);
                            break;
                        case 'Gas':
                        case 'PB_Fuel': 
                            weaponBarAccent = cachedFontColors[FUELAMMO];
                            DrawAmmoBar("BARBACD1", "BARBACD2", "BARBACD3", "BAMBAR6", "ABAR6", "ABAR6", "AMMOIC6", cachedFontColors[FUELAMMO]);
                            break;
                        case 'Demonpower':
                        case 'PB_DTech': 
                            weaponBarAccent = cachedFontColors[DTECHAMMO];
                            DrawAmmoBar("BARBACZ1", "BARBACZ2", "BARBACZ3", "BAMBAR7", "ABAR7", "ABAR7", "AMMOIC7", cachedFontColors[DTECHAMMO]);
                            break;
                        default:
                            weaponBarAccent = cachedFontColors[HUDBLUEBAR];
                            if(PB_WeaponUsesPBAmmoType1()) DrawAmmoBar("BARBACC1", "BARBACC2", "BARBACC3", "BAMBAR8", "ABAR8", "ABAR8", "AMMOIC8", Font.CR_GREY);
                            break;
                    }
                }
                else
                    weaponBarAccent = Font.CR_UNTRANSLATED;
				
				PB2022_DrawZScriptOverheatMeters();
				PB2022_DrawWeaponModeLabel();
				
				PBHud_DrawString(mDefaultFont, weap.GetTag(), (-110, -24), DI_SCREEN_RIGHT_BOTTOM | DI_TEXT_ALIGN_RIGHT, weaponBarAccent, scale: (0.5, 0.5));
				
				PB2022_DrawEquipmentSlot();
			}

			if (Health > 0 && isInventoryBarVisible()) //Placeholder for now, at least it works(?)
			{
				Vector2 invBarPos = (0, 0);
				SetSway(invBarPos.x, invBarPos.y, 0, 0.75, 0.25);
				invBarPos = (invBarPos.X, min(invBarPos.Y, 0));
				DrawInventoryBar(InvBar, invBarPos, 7, DI_SCREEN_CENTER_BOTTOM, HX_SHADOW);
			}

		}
	}

	bool PB_WeaponUsesPBAmmoType()
    {
        return PB_WeaponUsesPBAmmoType1() || PB_WeaponUsesPBAmmoType2();
    }

	bool PB_WeaponUsesPBAmmoType1()
    {
		return weap && weap.AmmoType1;
	}

	bool PB_WeaponUsesPBAmmoType2()
    {
		return weap && weap.AmmoType2;
	}
}

class PB_DynamicDoubleInterpolator : Object
{
	double mCurrentValue;
	double mMinChange;
	double mMaxChange;
	double mChangeFactor;

	static PB_DynamicDoubleInterpolator Create(int startval, double changefactor, double minchange, double maxchange)
	{
		let v = new("PB_DynamicDoubleInterpolator");
		v.mCurrentValue = startval;
		v.mMinChange = minchange;
		v.mMaxChange = maxchange;
		v.mChangeFactor = changefactor;
		return v;
	}

	void Reset(double value)
	{
		mCurrentValue = value;
	}

	// This must be called periodically in the status bar's Tick function.
	// Do not call this in the Draw function because that may skip some frames!
	void Update(double destvalue)
	{
		double diff = clamp(abs(destvalue - mCurrentValue) * mChangeFactor, mMinChange, mMaxChange);
		if (mCurrentValue > destvalue)
		{
			mCurrentValue = max(destvalue, mCurrentValue - diff);
		}
		else
		{
			mCurrentValue = min(destvalue, mCurrentValue + diff);
		}
	}

	// This must be called in the draw function to retrieve the value for output.
	double GetValue()
	{
		return mCurrentValue;
	}
}
