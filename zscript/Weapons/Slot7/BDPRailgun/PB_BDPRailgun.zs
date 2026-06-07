// PB_BDPRailgun — Platinum Railgun folded from PBX-Weapons Slot-7/BDP_RAILGUN.

#include "zscript/Weapons/Slot7/BDPRailgun/PB_BDPRailgun_helpers.zs"
#include "zscript/Weapons/Slot7/BDPRailgun/PB_BDPRailgun_Functions.zs"

const BDPRailgunFullAmmo = 5;

class PB_BDPRailgun : PB_WeaponBase
{
	default
	{
		Weapon.AmmoGive1 40;
		Weapon.AmmoType2 "BDPRailgunAmmo";
		Weapon.AmmoType1 "Cell";
		PB_WeaponBase.ReserveToMagAmmoFactor 10;
		Obituary "%o was pierced by %k's Platinum Railgun.";
		Inventory.PickupSound "PLSDRAW";
		Inventory.Pickupmessage "Platinum Railgun (Slot 7)";
		DamageType "Railgun";
		Weapon.SlotNumber 7;
		Weapon.SlotPriority 2;
		Weapon.SelectionOrder 1550;
		Inventory.AltHUDIcon "XBDRA0";
		Inventory.Icon "XBDRA0";
		Tag "UAC MK-1 'Platinum' Railgun";
	}

	// bool steam;
	bool scopeZoom; // this is for the variable scope
    const bdpraildamage = 500;
    const highfactor = 9.0;
    const lowfactor = 3.0;
    const HANDLE_LAYER = -5;
    const MUZZLE_LAYER = -2;

    States
    {
	Spawn:
		XBDR A -1;
		Stop;

	Steady:
		TNT1 A 1;
		TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
		TNT1 A 0 SetPlayerProperty(0, 0, 0);
		TNT1 A 0 SetPlayerProperty(0, 0, PROP_TOTALLYFROZEN);
		Goto Ready3;

	Ready:
		TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
		TNT1 A 0 PB_RespectIfNeeded();

	WeaponRespect:
            RAIS DDDCCCBBBA 1 A_DoPBWeaponAction();
            RAIL A 10 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySoundEx("IronSights", "Auto");
            // Raise
			TNT1 A 0 A_overlay(HANDLE_LAYER,"pumpinghandlol");
			RAIL FGHI 1 A_DoPBWeaponAction();
			RAIL JKLMNNOOO 1 A_DoPBWeaponAction();
			TNT1 A 0 A_overlay(HANDLE_LAYER,"pumpinghandlol2");
			RAIL OOOO 1 A_DoPBWeaponAction();
			TNT1 A 0 A_StartSound("weapons/bdprailgun/mag2", 5);
            // Rechamber
			RAIL PR 1 A_DoPBWeaponAction();
			RAIL TWWVUUUUUU 1 A_DoPBWeaponAction();
            // Put Shells In
            TNT1 A 0 A_PlaySoundEx("IronSights", "Auto");
			RAIL X 7 {
                A_overlay(HANDLE_LAYER,"ReloadingHand2");
                return A_DoPBWeaponAction();
            }
			RAIR AB 1 A_DoPBWeaponAction();
			RAIR BA 1 A_DoPBWeaponAction();
			RAIL X 4 A_DoPBWeaponAction();
            RAIL WWVV 1 A_DoPBWeaponAction();
            TNT1 A 0 A_StartSound("weapons/bdprailgun/insert", 5);
			RAIL UUUTTSRQP 1 A_DoPBWeaponAction();
			TNT1 A 0 A_overlay(HANDLE_LAYER,"pumpinghandlol2reverse");
			RAIL OOOOONMLKJ 1 A_DoPBWeaponAction();
			TNT1 A 0 A_overlay(HANDLE_LAYER,"pumpinghandlolreverse");
			RAIL IHGF 1 A_DoPBWeaponAction();
            Goto Ready3;

        Deselect:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleCrosshair(97);
				A_TakeInventory("PB_LockScreenTilt",1);
                A_ClearOverlays(HANDLE_LAYER);
			}
			TNT1 A 0 A_StopSound(1);
			TNT1 A 0 A_StopSOund(2);
			TNT1 A 0 A_StopSOund(6);
			RAIS EFGH 1;
			TNT1 A 0 A_Lower();
			Wait;

        Select:
			TNT1 A 0 {
				A_WeaponOffset(0, 32);
				A_SetRoll(0);
				A_ClearOverlays(HANDLE_LAYER);
				PB_HandleCrosshair(97);
				A_SetInventory("PB_LockScreenTilt", 0);
			}
			Goto SelectFirstPersonLegs;
		SelectContinue:
			TNT1 A 0 PB_WeaponRaise("weapons/bdprailgun/insert");
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			TNT1 A 0 PB_WeapTokenSwitch("RailGunSelected");
			TNT1 A 0 PB_RespectIfNeeded();
        SelectAnimation:
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
            RAIS DCBA 1;
        Ready3:
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
            RAIL A 1 {
                PB_CoolDownBarrel();
			    PB_HandleCrosshair(97);
			    return A_DoPBWeaponAction();
            }
            loop;

        Ready2:
            SNIP C 1 Bright {
				PB_CoolDownBarrel();
                A_SetCrosshair(-1);
				return PB_ReadyFire(ads:true);
            }
            loop;

        NoAmmo:
            // TNT1 A 0 A_Dryfire("RAILDRY", 1);
            TNT1 A 0 A_JumpIf(PB_GetZoom(),"Ready2");
            Goto Ready3;

            Goto Ready3;

        Fire:
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
			TNT1 A 0 PB_TryAutoFatalityOnFire();
            TNT1 A 0 {
				A_SetRoll(0);
				PB_HandleCrosshair(97);
				A_TakeInventory("PB_LockScreenTilt",1);
                A_ClearOverlays(HANDLE_LAYER);
			}
            TNT1 A 0 A_JumpIf(PB_GetZoom(),"Fire2");
        Fire1Actual:
			// TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(),"Pumping");
			TNT1 A 0 PB_JumpIfNoAmmo(emptysound:"weapons/bdprailgun/dry");
			RAIF A 1
			{
				for(int i = 0; i < 11; i++)
				{
					A_Fireprojectile ("BluePlasmaParticleWeapon", random(-60,60), 0, -1, -3, 0, random(-6,70));
				}
				A_overlay(HANDLE_LAYER,"DoNothing");
				A_FireNuRailgun();
				A_zoomfactor(0.7);
                A_Overlay(MUZZLE_LAYER,"MuzzleFlash");
                A_OverlayFlags(MUZZLE_LAYER,PSPF_RENDERSTYLE|PSPF_FORCESTYLE,true);
                A_OverlayRenderStyle(MUZZLE_LAYER,STYLE_Add);
				A_GunLight();
			}
			RAIF B 1 {
				A_GunLight();
				A_zoomfactor(1.0);
			}
			RAIF CDEFG 1;
			RAIL BCDEBCDEBCDEBCDE 1 A_DoPBWeaponAction(WRF_NOFIRE| WRF_NOBOB);
			// TNT1 A 0 PB_JumpIfNoAmmo(emptysound:"RAILDRY");
		Pumping:
			TNT1 A 0 A_overlay(HANDLE_LAYER,"pumpinghandlol");
			RAIL FGHI 1;
			RAIL JKLMNNOOO 1;
			TNT1 A 0 A_overlay(HANDLE_LAYER,"pumpinghandlol2");
			RAIL OOOO 1;
			TNT1 A 0 A_StartSound("weapons/bdprailgun/mag2", 5);
			RAIL PR 1;
			TNT1 A 0  {
				If(PB_GetChamberEmpty())
				{
					A_StartSound("weapons/bdprailgun/eject", 2);
					A_FireProjectile("RailCaseSpawn",0,0,0,0,0,0);
				    if(!PB_GetMagEmpty()) PB_SetChamberEmpty(false);
				}
			}
			RAIL TWWVUUUUUUUUUUUUUUU 1 {
				If(PB_GetChamberEmpty()) {
                    PB_GunSmoke_Basic(0, 0, 0);
                    PB_GunSmoke_Basic(0, 0, 0);
                    PB_GunSmoke_Basic(0, 0, 0);
                }
            }
			TNT1 A 0 {
				if(invoker.ammo2.amount < 1) return resolvestate("ReloadFromPump");
				else return resolvestate(null);
			}
			// TNT1 A 0 A_AutoReloadMag(1,"ReloadFromPump");
			TNT1 A 0 {if(invoker.ammo2.amount < BDPRailgunFullAmmo && invoker.ammo1.amount > 9) A_PressingReload();}
			Goto FinishPump2;

		FinishPump:
			RAIL WWVV 1;
		FinishPump2:
			TNT1 A 0 A_StartSound("weapons/bdprailgun/insert", 5);
			RAIL UUUUUTTSRQP 1;
			TNT1 A 0 A_overlay(HANDLE_LAYER,"pumpinghandlol2reverse");
			RAIL OOOOONMLKJ 1;
			TNT1 A 0 A_overlay(HANDLE_LAYER,"pumpinghandlolreverse");
			RAIL IHGF 1;
			TNT1 A 0 PB_ReFire();
			Goto Ready3;

        Fire2:
			TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
            TNT1 A 0 {
				A_SetRoll(0);
				A_SetCrosshair(-1);
				A_TakeInventory("PB_LockScreenTilt",1);
			}
        Fire2Actual:
            TNT1 A 0 PB_JumpIfNoAmmo(emptysound:"weapons/bdprailgun/dry");
            SNIP C 30 Bright {
                A_FireNuRailgun();
                A_GunLight();
            }
        FireAimCont:
            TNT1 A 0 A_StartSound("weapons/bdprailgun/mag2", 5);
            SNIP CC 1 BRIGHT;
            TNT1 A 0 {
                A_StartSound("weapons/bdprailgun/eject", 2); 
                A_FireProjectile("RailCaseSpawn",0,0,0,0,0,0);
				if(!PB_GetMagEmpty()) PB_SetChamberEmpty(false);
            }
            SNIP CCCCCCCCCCCCCCCCCCC 1 BRIGHT PB_GunSmoke(0,0,0);
            SNIP CCCC 1 BRIGHT;
            TNT1 A 0 A_StartSound("weapons/bdprailgun/insert", 5);
            SNIP CCCCCCCCCC 1 BRIGHT;
            TNT1 A 0 PB_ReFire();
            Goto Ready2;

        AltFire:
			TNT1 A 0 A_Jumpif(PB_GetZoom(),"ZoomOut");
        ZoomIn:
            TNT1 A 0 {
                A_overlay(HANDLE_LAYER,"DoNothing");
			    A_startsound("IronSights",29);
                A_zoomfactor(3.0);
                A_SetCrosshair(-1);
                PB_SetZoom(true);
            }
            RAIZ ABCDEF 1;
			Goto Ready2;

        ZoomOut:
            TNT1 A 0 {
                A_StartSound("weapons/railgun/zoomout");
                if(invoker.scopeZoom == true) A_ZoomFactor(3.0,ZOOM_INSTANT);
                A_ZoomFactor(1.0);
                PB_SetZoom(false);
                PB_HandleCrosshair(97);
            }
            // TNT1 A 0 A_SetCrosshairDX("RAILRet", 10000);
            RAIZ FE 1;
            RAIZ DCBA 1;
            Goto Ready3;

        Reload:
			TNT1 A 0 {
                PB_SetZoom(false);
                A_ZoomFactor(1.0);
                A_Giveinventory("PB_LockScreenTilt",1);
                A_SetCrosshair(-1);
			}
            TNT1 A 0 PB_CheckReload(null,null,"Pumping","Ready3","Ready3",BDPRailgunFullAmmo);
			TNT1 A 0 A_PlaySoundEx("IronSights", "Auto");
            TNT1 A 0 A_overlay(HANDLE_LAYER,"pumpinghandlol");
			RAIL FGHIJKLMNNOOO 1;
        ShellChecker:
            // Main reload loop
			TNT1 A 0 A_JumpIf(invoker.ammo1.amount < 1 || invoker.ammo2.amount >= BDPRailgunFullAmmo,"ReloadFinished");
			RAIL O 7 {
                A_overlay(HANDLE_LAYER,"ReloadingHand2");
                return A_DoPBWeaponAction(WRF_NOBOB);
            }
			RAIR CD 1 A_DoPBWeaponAction(WRF_NOBOB);
			TNT1 A 0 {
                A_Giveinventory(invoker.ammo2.getClassName(),1);
				A_Takeinventory(invoker.ammo1.getClassName(),invoker.ReserveToMagAmmoFactor,TIF_NOTAKEINFINITE);
                PB_SetChamberEmpty(false);
				PB_SetMagEmpty(false);
            }
			RAIR DC 1 A_DoPBWeaponAction(WRF_NOBOB);
			RAIL O 4 A_DoPBWeaponAction(WRF_NOBOB);
			Loop;

		ReloadFinished:
			RAIL OOOOONMLKJ 1;
			TNT1 A 0 {
				A_Takeinventory("PB_LockScreenTilt",1);
				A_PlaysoundEx("IronSights", "Auto");
                A_overlay(HANDLE_LAYER,"pumpinghandlolreverse");
            }
			RAIL IHGF 1;
			TNT1 A 0 PB_SetReloading(false);
			Goto Ready3;

        ReloadFromPump:
			TNT1 A 0  {
                PB_SetZoom(false);
                A_ZoomFactor(1.0);
                A_Giveinventory("PB_LockScreenTilt",1);
                A_SetCrosshair(-1);
                A_overlay(HANDLE_LAYER,"ReloadingHand1");
			}
            TNT1 A 0 PB_CheckReload(null,null,"Pumping","Ready3","Ready3",BDPRailgunFullAmmo);
			TNT1 A 0 A_PlaySoundEx("IronSights", "Auto");
			RAIL X 4;
		ReloadFromPumpInsertShells:
			TNT1 A 0 A_JumpIf(invoker.ammo1.amount < 1 || invoker.ammo2.amount >= BDPRailgunFullAmmo,"FinishReloadFromPump");
			RAIL X 7 {
                A_overlay(HANDLE_LAYER,"ReloadingHand2");
                return A_DoPBWeaponAction(WRF_NOBOB);
            }
			RAIR AB 1 A_DoPBWeaponAction(WRF_NOBOB);
			TNT1 A 0 {
                A_Giveinventory(invoker.ammo2.getClassName(),1);
				A_Takeinventory(invoker.ammo1.getClassName(),invoker.ReserveToMagAmmoFactor,TIF_NOTAKEINFINITE);
                PB_SetChamberEmpty(false);
				PB_SetMagEmpty(false);
            }
			RAIR BA 1 A_DoPBWeaponAction(WRF_NOBOB);
			RAIL X 4 A_DoPBWeaponAction(WRF_NOBOB);
            Loop;

        FinishReloadFromPump:
			TNT1 A 0 A_overlay(HANDLE_LAYER,"ReloadingHand3");
			RAIL X 4;
			Goto FinishPump;

        WeaponSpecial:
            TNT1 A 0 A_TakeInventory("GoWeaponSpecialAbility", 1);
            TNT1 A 0 A_JumpIfInventory("Select_BDPRailgun_Scope", 1, "WSpecScope");
            TNT1 A 0 A_JumpIfInventory("Select_BDPRailgun_Hologram", 1, "WSpecHologram");
            TNT1 A 0 {
                if (PB_GetZoom()) {
                    A_HandleScope();
                    return ResolveState("Ready2");
                }
                return ResolveState(null);
            }
            TNT1 A 0 {
                A_startsound("bepbep", 4);
                A_SpawnHologram();
            }
            Goto Ready3;

        WSpecScope:
            TNT1 A 0 {
                A_TakeInventory("Select_BDPRailgun_Scope", 1);
                A_TakeInventory("Select_BDPRailgun_Hologram", 1);
                if (PB_GetZoom()) {
                    A_HandleScope();
                    A_PlaySound("menu/choose", CHAN_AUTO);
                    return ResolveState("Ready2");
                }
                A_Print("$PB_BDPRAIL_SCOPE_ADS");
                return ResolveState("Ready3");
            }

        WSpecHologram:
            TNT1 A 0 {
                A_TakeInventory("Select_BDPRailgun_Scope", 1);
                A_TakeInventory("Select_BDPRailgun_Hologram", 1);
                A_startsound("bepbep", 4);
                A_SpawnHologram();
                A_PlaySound("menu/choose", CHAN_AUTO);
            }
            Goto Ready3;
            
        // SlowHologram:
        //     TNT1 A 0 A_startsound("PISTFOL5",10);
        //     RAIZ ABCD 1;
        //     TNT1 A 0 
        //     {
        //         A_startsound("BEP",4);
        //         A_SetCrosshairDX("Null");
        //     }
        // HoldHologram:
        //     RAIZ D 1
        //     {
        //         FLineTraceData lasersight;
        //         LineTrace(angle, 4096, pitch, TRF_SOLIDACTORS|TRF_THRUHITSCAN, offsetz: player.viewz - pos.z, data: lasersight);
        //         vector3 targetpos = lasersight.HitLocation;
        //         if (lasersight.HitLine)
        //         {
        //             vector2 wallnormal = (-lasersight.HitLine.delta.y,lasersight.HitLine.delta.x).unit();
        //             if (!lasersight.LineSide)
        //             wallnormal *= -1;
        //             targetpos += (wallnormal * 18);
        //         }
        //         if (lasersight.hittype == trace_hitceiling)
        //         {
        //             targetpos.z -= 13;
        //         }
        //         if (lasersight.hittype == trace_hitfloor)
        //         {
        //             targetpos.z += 13;
        //         }
        //         Spawn("HoloLaser",targetpos);
        //     }
        //     TNT1 A 0 A_JumpIf(player.cmd.buttons & BT_USER3,"HoldHologram");
        //     TNT1 A 0
        //     {
        //         A_startsound("bepbep",4);
        //         A_SpawnHologram();
        //         A_startsound("PISTFOL5",10);
        //         A_SetCrosshairDX("RAILRet", 10000);
        //     }
        //     RAIZ DCBA 1;
        //     TNT1 A 0 A_takeinventory("startdualwield",1);
        //     Goto Ready;

        // FLASH STATES
		MuzzleFlash:
			RAIM AB 1 Bright;
			Stop;
		DoNothing:
			TNT1 A 1;
			Stop;

        FlashPunching:
            RAIK ABCD 1;
            RAIK E 6;
            RAIK DCBA 1;
            goto Ready3;

		FlashKicking:
			RAIK ABCD 1;
            RAIK E 7;
            RAIK DCBA 1;
			goto Ready3;
			
		FlashAirKicking:
			RAIK ABCD 1;
            RAIK E 8;
            RAIK DCBA 1;
			goto Ready3;
			
		FlashSlideKicking:
			RAIK ABCD 1;
            RAIK E 19;
            RAIK DCBA 1;
			goto Ready3;
			
		FlashSlideKickingStop:
			RAIK ABCDEEE 1; //7 frames 
			goto Ready3;

        Pumpinghandlol:
            TNT1 A 0 A_StartSound("weapons/nailgun/up", 6);
            RAIH ABCD 1;
            Stop;
        Pumpinghandlol2:
            RAIH IHFE 1;
            Stop;
        Pumpinghandlolreverse:
            TNT1 A 0 A_StartSound("weapons/carbine/fancybutton", 6);
            RAIH DCBA 1;
            Stop;
        Pumpinghandlol2reverse:
            RAIH FHI 1;
            Stop;
        ReloadingHand1:
            RAIH JKLM 1;
            Stop;
        ReloadingHand3:
            RAIH MLKJ 1;
            Stop;
        ReloadingHand2:
            TNT1 A 5;
            TNT1 A 0 A_startsound("weapons/bdprailgun/shellinsert", 3, CHANF_OVERLAP);
            RAIH RQPONN 1;
            RAIH STUV 1;
            Stop;

        PDA_Preview_BDPReady:
            RAIL A 1 A_WeaponReady(WRF_NOFIRE);
            RAIS A 1 A_WeaponReady(WRF_NOFIRE);
            Stop;
        PDA_Preview_BDPShot:
            RAIF A 1 Bright A_WeaponReady(WRF_NOFIRE);
            RAIF B 1 Bright A_WeaponReady(WRF_NOFIRE);
            RAIF C 1 A_WeaponReady(WRF_NOFIRE);
            RAIF D 1 A_WeaponReady(WRF_NOFIRE);
            Stop;
        PDA_Preview_BDPScope:
            SNIP C 1 Bright A_WeaponReady(WRF_NOFIRE);
            SNIP C 1 Bright A_WeaponReady(WRF_NOFIRE);
            Stop;
        PDA_Preview_BDPHologram:
            RAIZ A 1 A_WeaponReady(WRF_NOFIRE);
            RAIZ B 1 A_WeaponReady(WRF_NOFIRE);
            RAIZ C 1 A_WeaponReady(WRF_NOFIRE);
            Stop;
        PDA_Preview_BDPPump:
            RAIL P 1 A_WeaponReady(WRF_NOFIRE);
            RAIL R 1 A_WeaponReady(WRF_NOFIRE);
            RAIL T 1 A_WeaponReady(WRF_NOFIRE);
            Stop;

    }
}