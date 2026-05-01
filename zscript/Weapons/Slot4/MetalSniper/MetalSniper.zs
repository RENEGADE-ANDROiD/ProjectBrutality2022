const MetalSniperFullAmmo          = 12;
const MetalSniperFullAmmoResonance  = 4;

class PB_MetalSniper : PB_WeaponBase
{
    default
    {
        weapon.slotnumber 4;
        weapon.slotpriority 0.06;
        Tag "$PB_MSNI_TAG";
        inventory.pickupsound "CLIPIN";
        inventory.pickupmessage "$PB_MSNI_PICKUP";
        Inventory.AltHudIcon "MSNWA0";
        weapon.ammotype1 "NewClip";
        weapon.ammogive1 10;
        weapon.ammotype2 "SniperAmmo";
        PB_WeaponBase.UnloaderToken "SniperUnloaded";
        PB_WeaponBase.respectItem "MetalSniperRespect";
        Obituary "%o was sniped by %k's Metal Sniper";
        scale 0.62;
        +weapon.noalert;
        +weapon.noautofire;
    }

    // ── Constants ────────────────────────────────────────────────────────────
    const SniperMode  = 0;
    const GrenadeMode = 1;
    const muzzlelayer = -52;

    // ── State ─────────────────────────────────────────────────────────────────
    bool resonanceAmmoLoaded;
    bool grenadeloaded;
    bool AltMode;
    bool isZooming;
    int  currentMaxAmmo;
    int  usedAmmo;

    // ═════════════════════════════════════════════════════════════════════════
    // STATES
    // ═════════════════════════════════════════════════════════════════════════
    states
    {
        // ── Spawn ─────────────────────────────────────────────────────────
        Spawn:
            MSNW A -1;
            stop;

        // ── Weapon Respect ──────────────────────
        Steady:
            TNT1 A 1;
            goto Ready3;

        WeaponRespect:
            TNT1 A 0 A_GiveInventory("MetalSniperRespect", 1);
            MSNI ABCDEFGHIJKLMNOPQRSSSS 1 A_DoPBWeaponAction();
            MSU0 ABCDEFGHIJKL 1 A_DoPBWeaponAction();
            M3NC ABCDEFGHI 1 A_DoPBWeaponAction();
            TNT1 A 0 A_StartSound("MS/BoltDown", 24);
            M3NC J 15 A_DoPBWeaponAction();
            M3NC K 10 A_DoPBWeaponAction();
            M3NC LL 1 A_DoPBWeaponAction();
            TNT1 A 0 A_StartSound("MS/BoltUp", 25);
            M3NC M 1 A_DoPBWeaponAction();
            MSNR ABCDEFG 1 A_DoPBWeaponAction();
            TNT1 A 0 A_StartSound("MS/InsertMag", 20);
            MSNR HIJKLMNOPQR 1 A_DoPBWeaponAction();
            MSU1 LKJIHGFEDCBA 1 A_DoPBWeaponAction();
            MSNI T 1 A_DoPBWeaponAction();
            MSNI UVWXYZ 1 A_DoPBWeaponAction();
            MSNJ AAB 1 A_DoPBWeaponAction();
            TNT1 A 0 A_StartSound("MS/BoltDown", 24);
            MSNJ BCDEEF 1 A_DoPBWeaponAction();
            TNT1 A 0 A_StartSound("MS/BoltUp", 25);
            MSNJ GHIJKL 1 A_DoPBWeaponAction();
            goto Ready3;

        // ── Select / Deselect ─────────────────────────────────────────────
        Select:
            TNT1 A 0 PB_WeaponRaise("MS/Up");
        SelectContinue:
            TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
            TNT1 A 0 PB_WeapTokenSwitch("RifleSelected");
            TNT1 A 0 A_TakeInventory("SniperUnloaded", 1);
            TNT1 A 0 PB_RespectIfNeeded();
        SelectAnimation:
            TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
            MSNU ABCD 1;
            TNT1 A 0
            {
                invoker.currentMaxAmmo = invoker.resonanceAmmoLoaded ? MetalSniperFullAmmoResonance : MetalSniperFullAmmo;
                MS_SetSniperMagMax(invoker.currentMaxAmmo);
            }
            goto Ready3;

        Deselect:
            TNT1 A 0 A_ZoomFactor(1.0);
            TNT1 A 0 A_TakeInventory("Zoomed", 10);
            TNT1 A 0 setZoom(false);
            MSND ABCD 1;
            TNT1 A 0 A_Lower(120);
            wait;

        // ── Ready (hip-fire) ──────────────────────────────────────────────
        //    Sprite-only states consumed by animation tools — never looped into.
        Ready:
            MST0 ABCDEFGHIJKL 0;        // take mag empty
            MST3 ABCDEFGHIJKL 0;        // take mag resonance
            MST1 ABCDEFGHIJKL 0;        // take mag standard
            MSNC ABCDEFGHIJKLM 0;       // standard chamber
            M3NC ABCDEFGHIJKLM 0;       // empty chamber
            MSN4 ABCDEFGHIJKLM 0;       // resonance chamber
            MSU0 ABCDEFGHIJKL 0;        // raise no mag
            MSU1 ABCDEFGHIJKL 0;        // raise normal
            MSNR ABCDEFGHIJKLMNOPQR 0;  // insert standard mag
            MSR6 ABCDEFGHIJKLMNOPQR 0;  // insert resonance mag 
        Ready3:
            TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
            TNT1 A 0 PB_HandleCrosshair(42);
            TNT1 A 0 A_JumpIf(CountInv("Zoomed") > 0, "Ready_ADS");
            MSNF A 1
            {
                PB_CoolDownBarrel(-4, 0, 6, 0,  1);
                PB_CoolDownBarrel( 4, 0, 6, 0, -1);
                return A_DoPBWeaponAction(WRF_ALLOWRELOAD, CheckUnloaded("SniperUnloaded"));
            }
            loop;

        // ── No Ammo States ─────────────────────────────────────────────
        NoAmmo:
            MSNF A 1 A_StartSound("weapons/empty");
            goto Ready3;

        NoAmmo_Grenade:
            MSNG A 1 A_StartSound("weapons/empty");
            goto AltFire_Grenade;

        // ── Fire ────────────────────────────────────────────────────
        Fire:
            TNT1 A 0
            {
                if (CountInv("GoFatality") >= 1)
                    SetPlayerProperty(0, 1, 0);
                else
                    SetPlayerProperty(0, 0, 0);
            }
            TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
            TNT1 A 0
            {
                A_WeaponOffset(0, 32);
                A_SetRoll(0);
                PB_HandleCrosshair(42);
                A_SetInventory("PB_LockScreenTilt", 0);
            }
            TNT1 A 0 A_JumpIfInventory("Zoomed", 1, "Fire_ADS");
            TNT1 A 0 PB_JumpIfNoAmmo("Reload", 1);
            TNT1 A 0 A_AlertMonsters();
            MSNF B 1 bright MetalSniperFire();
            MSNF C 1 bright;
            MSNF DDDEF 1;
            MSNF GHAAAAAAAAAA 1
            {
                if (PlayerPressedOnce(BT_ATTACK)) return resolvestate("Fire");
                return A_DoPBWeaponAction(WRF_ALLOWRELOAD | WRF_NOFIRE);
            }
            TNT1 A 0 A_Refire("Fire");
            goto Ready3;

        // ── AltFire: zoom or grenade mode ────────────────────────────────
        AltFire:
            TNT1 A 0 A_JumpIf(MS_getmode() == GrenadeMode, "AltFire_Grenade");
        AltFire_Zoom:
            TNT1 A 0 A_JumpIf(CountInv("Zoomed") > 0 && iszoom(), "ZoomOut");
        ZoomIn:
            TNT1 A 0 A_GiveInventory("Zoomed", 1);
            TNT1 A 0 setZoom(true);
            TNT1 A 0 A_StartSound("IronSights", 29);
            MSNA A 1 A_ZoomFactor(1.5);
            MSNA B 1 A_ZoomFactor(2.0);
            MSNA C 1 A_ZoomFactor(2.5);
            MSNA D 1 A_ZoomFactor(3.0);
            MSNA E 1 A_ZoomFactor(3.5);
            MSNA F 1 A_ZoomFactor(4.0);
            goto Ready_ADS;

        ZoomOut:
            TNT1 A 0 A_TakeInventory("Zoomed", 1);
            TNT1 A 0 setZoom(false);
            TNT1 A 0 A_StartSound("IronSights", 29);
            MSNA F 1 A_ZoomFactor(3.5);
            MSNA E 1 A_ZoomFactor(3.0);
            MSNA D 1 A_ZoomFactor(2.5);
            MSNA C 1 A_ZoomFactor(2.0);
            MSNA B 1 A_ZoomFactor(1.5);
            MSNA A 1 A_ZoomFactor(1.0);
            goto Ready3;

        // ── Ready (ADS) ───────────────────────────────────────────────────
        Ready2:
        Ready_ADS:
            TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
            TNT1 A 0;
            MSNS A 1
            {
                A_SetRoll(0);
                PB_HandleCrosshair(-1);
                PB_CoolDownBarrel(-5, 0, 7, 0,  1);
                PB_CoolDownBarrel( 5, 0, 7, 0, -1);
                A_SetInventory("PB_LockScreenTilt", 0);

                bool holdMode = (CVar.GetCVar("pb_toggle_aim_hold", player).GetInt() == 1);

                if (holdMode)
                {
                    if (!PressingAltfire() || JustReleased(BT_ALTATTACK))
                        return resolvestate("ZoomOut");

                    if (PressingFire() && PressingAltfire() && CountInv(invoker.ammotype2) > 0)
                        return resolvestate("Fire_ADS");

                    return A_DoPBWeaponAction(WRF_ALLOWRELOAD | WRF_NOSECONDARY, CheckUnloaded("SniperUnloaded"));
                }
                else
                {
                    if (PressingFire() && CountInv(invoker.ammotype2) > 0)
                        return resolvestate("Fire_ADS");

                    return A_DoPBWeaponAction(WRF_ALLOWRELOAD, CheckUnloaded("SniperUnloaded"));
                }
            }
            loop;

        // ── Fire (ADS) ────────────────────────────────────────────────────
        Fire_ADS:
            TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
            TNT1 A 0 PB_JumpIfNoAmmo("ReloadFromADS", 1);
        ActualFireADS:
            MSNS B 1 bright MetalSniperFireADS();
        FireADSContinue:
            MSNS C 1 bright;
            MSNS DDD 1;
            MSNS EFG 1;
            MSNS HIAAAAAAAAAA 1
            {
                A_SetInventory("CantDoAction", 0);

                bool holdMode = CVar.GetCVar("pb_toggle_aim_hold", player).GetInt();

                if (holdMode)
                {
                    if (JustReleased(BT_ALTATTACK))      return resolvestate("ZoomOut");
                    if (JustPressed(BT_ATTACK) && PressingAltfire()) return resolvestate("Fire_ADS");
                }
                else
                {
                    if (PressingAltfire())  return resolvestate("ZoomOut");
                    if (JustPressed(BT_ATTACK)) return resolvestate("Fire_ADS");
                }
                return A_DoPBWeaponAction(WRF_ALLOWRELOAD | WRF_NOFIRE);
            }
            goto Ready_ADS;

        // ── Grenade mode ──────────────────────────────────────────────────
        AltFire_Grenade:
            MSNG A 1
            {
                PB_CoolDownBarrel(-4, 0, 6,  0,  1);
                PB_CoolDownBarrel( 4, 0, 6,  0, -1); 
                if (PlayerPressedOnce(BT_ATTACK))
                    return (getgrenqtty() > 0) ? resolvestate("FireGrenade") : resolvestate("Reload_Grenade");
                return resolvestate(null);
            }
            TNT1 A 0 A_Refire("AltFire_Grenade");
            goto Ready3;

        FireGrenade:
            TNT1 A 0 A_Overlay(muzzlelayer, "MuzzleFlash_Gren");
            TNT1 A 0 A_AlertMonsters();
            TNT1 A 0 A_StartSound("MS/Grenade", 20);
            MSNG B 1 bright A_FireProjectile("PB_FragGrenade", 0, 0);
            TNT1 A 0 MS_SetGrenadeQ(0);
            TNT1 A 0 PB_FireOffset();
            TNT1 A 0 PB_GunSmoke(0, 0, -2);
            TNT1 A 0 PB_WeaponRecoil(-3, frandom(-1.5, 1.5));
            MSNG C 1 bright;
            MSNG DEFGA 1;
            TNT1 A 0 A_JumpIf(CountInv("RocketAmmo") > 0, "Reload_Grenade");
            goto Ready3;

        Reload_Grenade:
            TNT1 A 0 A_JumpIf(CountInv("RocketAmmo") < 1, "NoAmmo_Grenade");
            MSNL ABCDEFGGG 1;
            TNT1 A 0 A_StartSound("MS/GrenOpen", 21);
            MSNL G 1;
            TNT1 A 0 PB_SpawnCasing("EmptyGrenadeBrass", 30, -2, 34, frandom(1.0, 2.0), frandom(-4.0, -2.0), 1.0);
            MSNL HIJKLMN 1;
            TNT1 A 0
            {
                if (CountInv("RocketAmmo") > 0)
                {
                    MS_SetGrenadeQ(1);
                    A_TakeInventory("RocketAmmo", 1);
                }
                A_StartSound("MS/GrenClose", 22);
            }
            MSNL OPQRSTUGGGTTT 1;   // collapsed GGG + FEDCBA
            MSNL FEDCBA 1;
            TNT1 A 0 A_Refire("AltFire_Grenade");
            goto Ready3;

        // ── Reload ────────────────────────────────────────────────────────
        ReloadFromADS:
        Reload:
            TNT1 A 0
            {
                A_ZoomFactor(1.0);
                A_TakeInventory("Zoomed", 10);
                setZoom(false);
                invoker.usedAmmo = invoker.resonanceAmmoLoaded ? 6 : 2;
            }
            TNT1 A 0 PB_CheckReload("RaiseFromEmpty", null, "Start_Rechamber", "Ready3", "NoAmmo", invoker.currentMaxAmmo, invoker.usedAmmo);
        // ── Raise weapon  ──────────────────
        StandardReload:
            TNT1 A 0 A_StartSound("IronSights", 30);
            MSU1 ABCDEFGHIJKL 1;    // raise
            TNT1 A 0 A_JumpIf(isResonance(), "TakeMagResonance");
        // Take standard mag out
        TakeMagStandard:
            MST1 ABCD 1 { if (PB_GetMagEmpty()) A_SetWeaponSprite("MST0"); }
            TNT1 A 0 A_StartSound("MS/Button", 22);
            MST1 E    1 { if (PB_GetMagEmpty()) A_SetWeaponSprite("MST0"); }
            TNT1 A 0
            {
                A_StartSound("MS/TakeMag", 23);
                PB_SetMagUnloaded(true);
            }
            MST1 FGHIJKL 1 { if (PB_GetMagEmpty()) A_SetWeaponSprite("MST0"); }
            goto InsertMag;

        // Take resonance mag out
        TakeMagResonance:
            MST3 ABCD 1 { if (PB_GetMagEmpty()) A_SetWeaponSprite("MST0"); }
            TNT1 A 0 A_StartSound("MS/Button", 22);
            MST3 E    1 { if (PB_GetMagEmpty()) A_SetWeaponSprite("MST0"); }
            TNT1 A 0
            {
                A_StartSound("MS/TakeMag", 23);
                PB_SetMagUnloaded(true);
            }
            MST3 FGHIJKL 1 { if (PB_GetMagEmpty()) A_SetWeaponSprite("MST0"); }
        // Insert new mag
        InsertMag:
            MSNR ABCDEFG 1 { if (isResonance()) A_SetWeaponSprite("MSR6"); }
            TNT1 A 0 A_StartSound("MS/InsertMag", 20);
            MSNR HIJKL 1 ;
            TNT1 A 0
            {
                MS_ReloadMag();
                PB_SetMagUnloaded(false);
                PB_SetMagEmpty(false);
            }
            MSNR MNOPQR 1 ;
            TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(), "Rechamber");
        FinishReload:
            MSU1 LKJIHGFEDCBA 1;    // lower
            TNT1 A 0 PB_SetReloading(false);
            goto Ready3;

        // ── Raise from fully empty mag ────────────────────────────────────
        RaiseFromEmpty:
            TNT1 A 0 A_StartSound("IronSights", 30);
            MSU0 ABCDEFGHIJKL 1;    // empty-mag raise
            goto InsertMag;

        // ── Rechamber ──────────────────────────
        Start_Rechamber:
            TNT1 A 0 A_StartSound("IronSights", 30);
            MSU1 ABCDEFGHIJKL 1;    // raise
        Rechamber:
            MSNC ABCDEFG 1 ;
            TNT1 A 0 A_StartSound("MS/BoltDown", 24);
            TNT1 A 0 PB_SetChamberEmpty(false);
            MSNC HIJ 1 ;
			MSNC K 1 { if (isResonance()) A_SetWeaponSprite("MSN4"); }
			MSNC L 1 ;
            TNT1 A 0 A_StartSound("MS/BoltUp", 25);
            MSNC M 1 ;
			goto FinishReload;

        // ── Reload from special ─────────────
        ReloadFromSpecial:
            TNT1 A 0
            {
                MS_AmmoCapacity();
                cleanAmmoWheelTokens();
            }
            MSR6 ABCDEFG 1 { if (!isResonance()) A_SetWeaponSprite("MSNR"); }
            TNT1 A 0 A_StartSound("MS/InsertMag", 20);
            MSNR HIJKL 1;
            TNT1 A 0
            {
                MS_ReloadMag();
                PB_SetMagUnloaded(false);
                PB_SetMagEmpty(false);
            }
            MSNR MNOPQR 1;
            goto Rechamber;

        // ── Unload ────────────────────────────────────────────────────────
        UnloadFromSpecial:
            TNT1 A 0 A_StartSound("IronSights", 30);
            TNT1 A 0 A_JumpIf(PB_GetMagUnloaded() && !PB_GetChamberEmpty(), "StartUnloadChamber");
            MSU1 ABCDEFGHIJKL 1;
            TNT1 A 0 A_JumpIf(!isResonance(), "UnloadMagResonance");
			goto UnloadMagStandard;

		Unload:
            TNT1 A 0 A_StartSound("IronSights", 30);
            // If mag already unloaded, skip straight to chamber
            TNT1 A 0 A_JumpIf(PB_GetMagUnloaded() && !PB_GetChamberEmpty(), "StartUnloadChamber");
        UnloadRaise:
            MSU1 ABCDEFGHIJKL 1;
            TNT1 A 0 A_JumpIf(PB_GetMagEmpty(), "UnloadMagEmpty");
            TNT1 A 0 A_JumpIf(isResonance(), "UnloadMagResonance");
        // Standard mag unload
        UnloadMagStandard:
            MST1 ABCD 1;
            TNT1 A 0 A_StartSound("MS/Button", 22);
            MST1 E 1;
            TNT1 A 0 A_StartSound("MS/TakeMag", 23);
            MST1 FGH 1;
            TNT1 A 0
            {
                MS_UnloadMag();
                PB_SetMagUnloaded(true);
                PB_SetMagEmpty(true);
            }
            MST1 IJKL 1;
            TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(), "FinishUnload");
            goto UnloadChamber;

        // Empty mag unload
        UnloadMagEmpty:
            MST0 ABCD 1;
            TNT1 A 0 A_StartSound("MS/Button", 22);
            MST0 E 1;
            TNT1 A 0
            {
                MS_UnloadMag();
                PB_SetMagUnloaded(true);
                PB_SetMagEmpty(true);
            }
            TNT1 A 0 A_StartSound("MS/TakeMag", 23);
            MST0 FGHIJKL 1;
            TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(), "FinishUnload");
            goto UnloadChamber;

        // Resonance mag unload
        UnloadMagResonance:
            MST3 ABCD 1;
            TNT1 A 0 A_StartSound("MS/Button", 22);
            MST3 E 1;
            TNT1 A 0
            {
                MS_UnloadMag();
                PB_SetMagUnloaded(true);
                PB_SetMagEmpty(true);
            }
            TNT1 A 0 A_StartSound("MS/TakeMag", 23);
            MST3 FGHIJKL 1;
            TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(), "FinishUnload");
            goto UnloadChamber;

        // Unchamber
        UnloadChamber:
            M3NC ABCDEFGHI 1;
            TNT1 A 0 A_StartSound("MS/BoltDown", 24);
            M3NC JKL 1;
            TNT1 A 0
            {
                MS_UnloadMag(true);     // UnloadChamber = true
                PB_SetChamberEmpty(true);
            }
            TNT1 A 0 A_StartSound("MS/BoltUp", 25);
            M3NC M 1;
        FinishUnload:
            TNT1 A 0 A_JumpIfInventory("MS_PendingSwapReload", 1, "FinishUnloadToReswapReload");
            MSU0 LKJIHGFEDCBA 1;
            goto Ready3;
        FinishUnloadToReswapReload:
            TNT1 A 0 A_TakeInventory("MS_PendingSwapReload", 1);
            goto ReloadFromSpecial;

        // Skip raise — already raised when mag was manually removed
        StartUnloadChamber:
            MSU0 ABCDEFGHIJKL 1;
            goto UnloadChamber;

        // ── Weapon Special ────────────────────
        WeaponSpecial:
            TNT1 A 0
            {
                A_TakeInventory("GoWeaponSpecialAbility", 1);
                A_TakeInventory("Zoomed", 1);
                A_TakeInventory("ADSmode", 1);
                A_ZoomFactor(1.0);
            }
            TNT1 A 0 MS_HandleAmmo();
            TNT1 A 0 MS_HandleSpecial();
            TNT1 A 0 A_JumpIfInventory("MS_Select_AimMode", 1, "ChangeAnim");
            TNT1 A 0 A_JumpIfInventory("MS_Select_GrenMode", 1, "ChangeAnim");
            Goto Ready3;
        ChangeAnim:
            TNT1 A 0 cleanmodetokens();
            TNT1 A 0 A_StartSound("IronSights", 30);
            MSSW ABCDEFF 1;
            TNT1 A 0 A_StartSound("MS/Button", 26);
            MSSW GHIJKLM 1;
            goto Ready3;

        // ── Muzzle flashes ────────────────────────────────────────────────
        MuzzleFlash:
            TNT1 A 0 A_OverlayFlags(overlayID(), PSPF_MIRROR | PSPF_FLIP, random(0, 1));
            TNT1 A 0 A_Jump(128, "MF2");
            MSNM AB 1 bright;
            stop;
        MF2:
            MSNM AC 1 bright;
            stop;

        MuzzleFlash_ADS:
            TNT1 A 0 A_OverlayFlags(overlayID(), PSPF_MIRROR | PSPF_FLIP, random(0, 1));
            TNT1 A 0 A_Jump(128, "MFADS2");
            MSNM DE 1 bright;
            stop;
        MFADS2:
            MSNM DF 1 bright;
            stop;

        MuzzleFlash_Gren:
            TNT1 A 0 A_OverlayFlags(overlayID(), PSPF_MIRROR | PSPF_FLIP, random(0, 1));
            MSNM G 1 bright;
            stop;

        // ── Melee flash overlays ──────────────────────────────────────────
        FlashPunching:
            MSNQ ABCDEFGHFEDCBA 1;      // 14 frames
            TNT1 A 0 A_ClearOverlays(PSP_FLASH, PSP_FLASH, false);
            goto Ready3;

        FlashKicking:
            MSNK ABCDEFGHGFEDCBA 1;     // 15 frames
            goto Ready3;

        FlashAirKicking:
            MSNQ ABCDEFGHHGFEDCBA 1;    // 16 frames
            goto Ready3;

        FlashSlideKicking:
            MSNK ABCDEFGHHHHHHHHHHHHHGFEDCBA 1; // 27 frames
            goto Ready3;

        FlashSlideKickingStop:
            MSNK GFEDCBA 1;             // 7 frames
            goto Ready3;
    }

    // ═════════════════════════════════════════════════════════════════════════
    // ACTION FUNCTIONS
    // ═════════════════════════════════════════════════════════════════════════

    // ── Ammo / magazine helpers ───────────────────────────────────────────────
    action void MS_SetSniperMagMax(int capacity)
    {
        let po = invoker.owner;
        if (!po || !invoker.ammotype2) return;
        let mag = Ammo(po.FindInventory(invoker.ammotype2));
        if (!mag) return;
        mag.MaxAmount = capacity;
        mag.BackpackMaxAmount = capacity;
        if (mag.Amount > capacity)
            mag.Amount = capacity;
    }

    action void MS_ReloadMag()
    {
        int magMax = invoker.currentMaxAmmo;
        if (PB_GetChamberEmpty()) magMax--;
        invoker.usedAmmo = isResonance() ? 6 : 2;
        name mag = invoker.ammotype2 ? invoker.ammotype2.GetClassName() : 'None';
        name pool = invoker.ammotype1 ? invoker.ammotype1.GetClassName() : 'None';
        int chunk = invoker.usedAmmo;

        for (int n = 0; n < 512 && CountInv(mag) < magMax && CountInv(pool) > 0; n++)
        {
            int need = magMax - CountInv(mag);
            int per = min(chunk, need);
            per = min(per, CountInv(pool));
            if (per < 1)
                break;
            A_TakeInventory(pool, per);
            A_GiveInventory(mag, per);
        }
    }

    action void MS_UnloadMag(bool UnloadChamber = false)
    {
        name mag = invoker.ammotype2 ? invoker.ammotype2.GetClassName() : 'None';
        name pool = invoker.ammotype1 ? invoker.ammotype1.GetClassName() : 'None';

        if (UnloadChamber)
        {
            invoker.usedAmmo = isResonance() ? 6 : 2;
            if (CountInv(mag) >= 1)
            {
                A_TakeInventory(mag, 1);
                A_GiveInventory(pool, 1);
                class<Actor> fx = (class<Actor>)(isResonance() ? "PB_HighCalResonanceUnloadProp" : "PB_HighCalHeavyUnloadProp");
                PB_SpawnLooseRounds(fx, 1, 12, 26);
            }
            return;
        }

        int goal = 1;
        invoker.usedAmmo = isResonance() ? 6 : 2;
        int chunk = invoker.usedAmmo;

        for (int n = 0; n < 512 && CountInv(mag) > goal; n++)
        {
            int inMagAboveGoal = CountInv(mag) - goal;
            int per = min(chunk, inMagAboveGoal);
            if (per < 1)
                break;
            A_TakeInventory(mag, per);
            A_GiveInventory(pool, per);
            class<Actor> fx = (class<Actor>)(isResonance() ? "PB_HighCalResonanceUnloadProp" : "PB_HighCalHeavyUnloadProp");
            PB_SpawnLooseRounds(fx, per, 12, 26);
        }
    }

    action void MS_AmmoCapacity()
    {
        bool res = invoker.resonanceAmmoLoaded;
        int capacity = res ? MetalSniperFullAmmoResonance : MetalSniperFullAmmo;
        int cur = CountInv(invoker.ammotype2);
        int newAmt = res ? cur / 3 : cur * 3;
        if (newAmt > capacity) newAmt = capacity;
        if (newAmt < 0) newAmt = 0;
        A_SetInventory(invoker.ammotype2, newAmt);
        invoker.currentMaxAmmo = capacity;
        MS_SetSniperMagMax(capacity);
    }

    action state MS_HandleAmmo()
    {
        if (FindInventory("Select_MS_Standard"))
        {
            A_TakeInventory("Select_MS_Standard", 1);
            if (!isResonance())
            {
                cleanAmmoWheelTokens();
                A_Print("$PB_MSNI_STANDARD");
                return resolvestate("Ready3");
            }
            setResonance(false);
            MS_AmmoCapacity();
            A_Print("$PB_MSNI_STANDARD");
            if (!PB_GetMagUnloaded())
                A_GiveInventory("MS_PendingSwapReload", 1);
            return PB_GetMagUnloaded() ? resolvestate("ReloadFromSpecial") : resolvestate("UnloadFromSpecial");
        }
        if (FindInventory("Select_MS_Resonance"))
        {
            A_TakeInventory("Select_MS_Resonance", 1);
            if (isResonance())
            {
                cleanAmmoWheelTokens();
                A_Print("$PB_MSNI_RESONANCE");
                return resolvestate("Ready3");
            }
            setResonance(true);
            MS_AmmoCapacity();
            A_Print("$PB_MSNI_RESONANCE");
            if (!PB_GetMagUnloaded())
                A_GiveInventory("MS_PendingSwapReload", 1);
            return PB_GetMagUnloaded() ? resolvestate("ReloadFromSpecial") : resolvestate("UnloadFromSpecial");
        }
        return resolvestate(null);
    }

    action state MS_HandleSpecial()
    {
        bool alreadyAim = FindInventory("MS_Select_AimMode") && MS_getmode() == SniperMode;
        bool alreadyGren = FindInventory("MS_Select_GrenMode") && MS_getmode() == GrenadeMode;

        if (alreadyAim || alreadyGren)
        {
            A_Print("$PB_MSNI_ALREADY");
            cleanmodetokens();
            return resolvestate("Ready3");
        }

        if (FindInventory("MS_Select_AimMode"))
        {
            MS_SetMode(SniperMode);
            A_Print("$PB_MSNI_AIMMODE");
        }
        else if (FindInventory("MS_Select_GrenMode"))
        {
            MS_SetMode(GrenadeMode);
            A_Print("$PB_MSNI_GRENMODE");
        }

        return resolvestate(null);
    }

    // ── Fire helpers ──────────────────────────────────────────────────────────
    action void MS_FireActual()
    {
        if (isResonance())
        {
            PB_FireBullets("MS_ResonanceAmmo", 1, frandom(-0.1, 0.1), 0, 0, frandom(-0.1, 0.1));
            A_StartSound("weapons/railgf", 20, CHANF_OVERLAP, 1.2);
        }
        else
        {
            PB_FireBullets("PB_762x51mmAP", 1, frandom(-0.1, 0.1), 0, 0, frandom(-0.1, 0.1));
            A_StartSound("MS/Fire", 20, CHANF_OVERLAP, 1.2);
        }
    }

    action void MetalSniperFireADS()
    {
        A_WeaponOffset(0, 32);
        A_AlertMonsters();
        PB_DynamicTail("lmg", "lmg");
        A_Overlay(muzzlelayer, "MuzzleFlash_ADS");
        MS_FireActual();
        PB_TakeAmmo(invoker.ammotype2, 1);
        A_SetInventory("CantDoAction", 1);
        PB_IncrementHeat(4);
        PB_IncrementHeat(4, true);
        PB_FireOffset();
        PB_GunSmoke(0, 0, -2);
        PB_WeaponRecoil(-5, frandom(-1.5, 1.5));
        PB_SpawnCasing("LMGCasingStandard", 26, 2, 28, 0, frandom(5, 8), frandom(1, 4));
    }

    action void MetalSniperFire()
    {
        A_WeaponOffset(0, 32);
        A_AlertMonsters();
        PB_DynamicTail("lmg", "lmg");
        A_Overlay(muzzlelayer, "MuzzleFlash");
        MS_FireActual();
        // PB_LowAmmoSoundWarning("lmg");
        PB_TakeAmmo(invoker.ammotype2, 1);
        PB_IncrementHeat(4);
        PB_IncrementHeat(4, true);
        PB_FireOffset();
        PB_GunSmoke(0, 0, -1);
        PB_WeaponRecoil(-4, frandom(-1.5, 1.5));
        PB_SpawnCasing("LMGCasingStandard", 26, 2, 28, 0, frandom(5, 8), frandom(1, 4));
        PB_WeaponRecoil(-3, frandom(-0.5, 0.5));
    }

	// ── Resonance helpers ──────────────────────────────────────────────────────────
    action bool isResonance()           { return invoker.resonanceAmmoLoaded; }
    action void setResonance(bool set)  { invoker.resonanceAmmoLoaded = set;  }

    // ── Zoom helpers ──────────────────────────────────────────────────────────
    action bool iszoom()           { return invoker.isZooming; }
    action void setZoom(bool set)  { invoker.isZooming = set;  }

    // ── Grenade helpers ───────────────────────────────────────────────────────
    action void MS_SetGrenadeQ(bool q) { invoker.grenadeloaded = q; }
    action int  getgrenqtty()          { return invoker.grenadeloaded; }

    // ── Mode helpers ──────────────────────────────────────────────────────────
    action bool MS_getmode()            { return invoker.AltMode; }
    action void MS_SetMode(bool set = SniperMode) { invoker.AltMode = set; }

    // ── Token cleanup ─────────────────────────────────────────────────────────
    action void cleanAmmoWheelTokens()
    {
        A_TakeInventory("Select_MS_Standard", 1);
        A_TakeInventory("Select_MS_Resonance", 1);
    }

    action void cleanmodetokens()
    {
        cleanAmmoWheelTokens();
        A_TakeInventory("MS_Select_AimMode",  1);
        A_TakeInventory("MS_Select_GrenMode", 1);
    }

    // ── Input helpers ─────────────────────────────────────────────────────────
    action bool PlayerPressedOnce(int button)
    {
        return (player.cmd.buttons & button) && !(player.oldbuttons & button);
    }

    // ── Init ──────────────────────────────────────────────────────────────────
    override void PostBeginPlay()
    {
        grenadeloaded  = true;
        currentMaxAmmo = MetalSniperFullAmmo;
        usedAmmo       = 2;
        Super.PostBeginPlay();
    }
}
