// =============================================================================
// PB_Deagle  —  Desert Eagle .50, full ZScript port from PB Staging.
//
// Source : PB Staging zscript/Weapons/Slot2/Deagle.zs (PBv0.3.X_Final).
// Replaces: actors/Weapons/Slot2/Deagle.dec (DECORATE version retired alongside
//           this drop; see PORTING_ADDONS.md §9.10.6).
//
// Adjustments vs upstream staging:
//   * Pool ammo is PB 2022's PistolBullets (staging used PB_LowCalMag).
//   * Magazine size is 8 rounds (matches staging; PB 2022's old DECORATE was 12).
//   * PB_GunSmoke_Deagle / PB_MuzzleFlashEffects route to PB 2022 fallbacks via
//     zscript/Weapons/BaseWeapon_StagingShim.zsc.
//   * Pickup message / tag are literal English; refresh through language.enu
//     ($PB_PICKUP_PB_Deagle) is left for a follow-up pass.
//   * SBARINFO compatibility: still gives/takes DualWieldingDeagles +
//     DeagleHasUnloaded inventory tokens alongside akimboMode / chamberEmpty
//     state so the existing fullscreen HUD bars keep rendering.
// =============================================================================

class PB_Deagle : PB_WeaponBase
{
	default
	{
		weapon.slotnumber 2;
		weapon.ammotype1 "PistolBullets";
		weapon.ammogive1 20;
		weapon.ammotype2 "DeagleAmmo";
		weapon.slotpriority 1;
		PB_WeaponBase.ReserveToMagAmmoFactor 2;
		PB_WeaponBase.AmmoTypeLeft "LeftDeagleAmmo";
		PB_WeaponBase.UnloaderToken "DeagleHasUnloaded";
		PB_WeaponBase.respectItem "RespectDeagle";
		Inventory.MaxAmount 2;
		Inventory.PickupSound "weapons/deagle/equip";
		Inventory.PickupMessage "$PB_PICKUP_PB_Deagle";
		Obituary "%o was popped by %k's .50 Caliber Hand Cannon.";
		Inventory.AltHUDIcon "D4E0Z0";
		PB_WeaponBase.TailPitch 0.6;
		+WEAPON.CHEATNOTWEAPON;
		+WEAPON.NOALERT;
		+WEAPON.NOAUTOFIRE;
		+WEAPON.NOAUTOAIM;
		+FLOORCLIP;
		+DONTGIB;
		Weapon.BobRangeX 0.3;
		Weapon.BobRangeY 0.5;
		Weapon.BobStyle "InverseSmooth";
		Weapon.BobSpeed 2.4;
		Scale 0.48;
		Tag "Desert Eagle .50";
		FloatBobStrength 0.5;
	}

	states
	{
		Spawn:
			V4E0 Z 0 NoDelay;
			D4E0 Z 10 A_PbvpFramework("V4E0");
			"####" Z 0 A_PbvpInterpolate();
			loop;

		WeaponRespect:
			TNT1 A 0 {
				A_SetInventory("PB_LockScreenTilt",1);
				A_SetCrosshair(-1);
			}
			D4E1 ABCDEEE 1 A_DoPBWeaponAction();
			D4E1 FGHIJK 1 A_DoPBWeaponAction();
			TNT1 A 0 A_StartSound("weapons/smg_magfly1",4,CHANF_OVERLAP);
			TNT1 A 0 A_QuakeEx(0,0,0,12,0,10,"",QF_WAVE|QF_RELATIVE|QF_SCALEDOWN,0.6,0,0.2,0,0,0.3,0.40);
			D4E1 LMNOPQR 1 A_DoPBWeaponAction();
			TNT1 A 0 A_StartSound("weapons/deagle/catchf",4,CHANF_OVERLAP);
			D4E1 ST 1 A_DoPBWeaponAction();
			D4E1 UU 1 A_DoPBWeaponAction();
			D4E1 UUUUU 1 { A_DoPBWeaponAction(); A_WeaponOffset(-0.25,-0.25,WOF_ADD); }
			D4E1 UU 1 A_DoPBWeaponAction();
			D4E1 UUUUU 1 { A_DoPBWeaponAction(); A_WeaponOffset(0.25,0.25,WOF_ADD); }
			D4E1 U 1 A_DoPBWeaponAction();
			D4E1 U 1 { A_DoPBWeaponAction(); A_WeaponOffset(0,32,WOF_INTERPOLATE); }
			TNT1 A 0 A_QuakeEx(0,0,0,10,0,10,"",QF_WAVE|QF_RELATIVE|QF_SCALEDOWN,0.75,0,0.25,0,0,-0.3,0.45);
			TNT1 A 0 A_StartSound("weapons/deagle/RotateFol",4,CHANF_OVERLAP);
			D4E1 VWXYZ 1 A_DoPBWeaponAction();
			D4E2 A 1 A_DoPBWeaponAction();
			D4E2 B 1 A_DoPBWeaponAction();
			D4E2 BBBBBBB 1 { A_DoPBWeaponAction(); A_WeaponOffset(-0.75,-0.4,WOF_ADD); }
			D4E2 BB 1 A_DoPBWeaponAction();
			D4E2 BBBBBBB 1 { A_DoPBWeaponAction(); A_WeaponOffset(0.75,0.4,WOF_ADD); }
			D4E2 B 1 { A_DoPBWeaponAction(); A_WeaponOffset(0,32,WOF_INTERPOLATE); }
			TNT1 A 0 A_StartSound("weapons/deagle/swapfol",4,CHANF_OVERLAP);
			D4E2 CDEFG 1 A_DoPBWeaponAction();
			TNT1 A 0 PB_HandleCrosshair(32);
			goto Ready;

		Select:
			Goto SelectFirstPersonLegs;
		SelectContinue:
			TNT1 A 0 PB_WeaponRaise("weapons/deagle/equip");
			TNT1 A 0 PB_WeapTokenSwitch("DeagleSelected");
			TNT1 A 0 A_SetInventory("RandomHeadExploder",1);
			TNT1 A 0 PB_TakeIfUpgrade("PB_Revolver");
			TNT1 A 0 PB_RespectIfNeeded();
		SelectAnimation:
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "SelectAnimationDualWield");
			D4E0 ABCD 1 PB_SetSpriteIfUnload("D4U0");
			goto Ready;

		Deselect:
			TNT1 A 0 {
				A_ClearOverlays(10,11);
				A_ZoomFactor(1.0);
				A_SetInventory("Zoomed",0);
			}
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "DeselectAnimationDualWield");
			D4E0 DCBA 1 PB_SetSpriteIfUnload("D4U0");
			TNT1 A 0 A_Lower(120);
			wait;

		Ready3:
		Ready:
			TNT1 A 0 A_WeaponOffset(0,32);
			TNT1 A 0 PB_HandleCrosshair(32);
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "ReadyDualWield");
			TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(),"ReadyUnloaded");
			D4E0 E 1 {
				PB_CoolDownBarrel(0, 0, 3);
				return A_DoPBWeaponAction();
			}
			loop;
		ReadyUnloaded:
		Ready4:
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "ReadyDualWield");
			TNT1 A 0 A_JumpIf(!PB_GetChamberEmpty(),"Ready");
			D1E0 A 1 {
				PB_CoolDownBarrel(0, 0, 3);
				return A_DoPBWeaponAction();
			}
			loop;


		MuzzleFlash:
			D2EM AB 1 Bright A_GunFlash();
			Stop;
		Fire:
			TNT1 A 0 A_JumpIfInventory("Zoomed",1,"Fire2");
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleCrosshair(32);
				A_SetInventory("PB_LockScreenTilt",0);
			}
			TNT1 A 0 PB_jumpIfNoAmmo();
			D2E0 A 1 BRIGHT {
				A_StartSound("weapons/deagle/fire", 0, CHANF_OVERLAP, 1.0);
				A_StartSound("weapons/deagle/afire", 0, CHANF_OVERLAP, 0.70);
				A_Overlay(-5, "MuzzleFlash", true);
				A_OverlayFlags(-5,PSPF_RENDERSTYLE,true);
				A_OverlayRenderStyle(-5,STYLE_Add);
				PB_DynamicTail("shotgun", "pistol_mag");
				PB_LowAmmoSoundWarning("pistol");
				A_FireProjectile("PB_50AE", frandom(-0.1,0.1),0,0,0, FPF_NOAUTOAIM, frandom(-0.1,0.1));
				A_AlertMonsters();
				PB_IncrementHeat(2);
				PB_GunSmoke_Deagle(0,5,5);
				PB_MuzzleFlashEffects(0,5,5);
				A_FireProjectile("YellowFlareSpawn",0,0,0,0);
				PB_SpawnCasing("EmptyBrassDeagle",30,0,31,-frandom(1.0, 2.0),frandom(2.0,6.0),frandom(3.0,6.0));
				PB_TakeAmmo("DeagleAmmo",1);
				A_ZoomFactor(0.96);
				PB_WeaponRecoil(-1.15,-0.36);
			}
			D2E0 B 1 BRIGHT PB_WeaponRecoil(-1.15,-0.56);
			D2E0 CD 1 A_ZoomFactor(0.98);
			TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(),"EndFireNoAmmo");
			D2E0 E 1;
			D2E0 FG 1 A_ZoomFactor(1.0);
			D4E0 EEEE 1 {
				if (JustPressed(BT_ATTACK))
					return ResolveState("Fire");
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOPRIMARY);
			}
			TNT1 A 0 PB_ReFire();
			Goto Ready;

		EndFireNoAmmo:
			D2E2 E 1;
			D2E2 FG 1 A_ZoomFactor(1.0);
			D1E0 AAAA 1 {
				if (JustPressed(BT_ATTACK))
					return ResolveState("Fire");
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOPRIMARY);
			}
			TNT1 A 0 PB_ReFire();
			Goto Ready;


		WeaponSpecial:
			TNT1 A 0 A_SetInventory("GoWeaponSpecialAbility",0);
			TNT1 A 0 {
				A_SetInventory("GoWeaponSpecialAbility",0);
				A_SetInventory("Zoomed",0);
				A_SetInventory("ADSmode",0);
				A_SetInventory("PB_LockScreenTilt",1);
				A_WeaponOffset(0,32);
				PB_HandleCrosshair(32);
				A_ZoomFactor(1.0);
				A_ClearOverlays(10,11);
			}
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(),"StopDualWield");
			TNT1 A 0 A_JumpIfInventory(invoker.GetClassName(), 2,"SwitchToDualWield");
			TNT1 A 0 A_Print("\ckNeed two \ctDeagles \c-to dual-wield");
			Goto Ready;
		SwitchToDualWield:
			TNT1 A 0 A_SetInventory("CantDoAction", 1);
			TNT1 A 0 {
				A_SetAkimbo(true);
				A_SetInventory("DualWieldingDeagles", 1);
				A_StartSound("Ironsights",1,CHANF_OVERLAP);
			}
			D6E2 A 1 PB_SetDualSpriteIfUnload("D6E3","D6E4","D6E5");
			D6E2 BCD 1 {
				PB_SetDualSpriteIfUnload("D6E3","D6E4","D6E5");
				A_SetRoll(roll - 0.5, SPF_INTERPOLATE);
			}
			D6E2 EFG 1 {
				PB_SetDualSpriteIfUnload("D6E3","D6E4","D6E5");
				A_SetRoll(roll + 0.5, SPF_INTERPOLATE);
			}
			TNT1 A 0 A_SetInventory("CantDoAction", 0);
			Goto ReadyDualWield;

		StopDualWield:
			TNT1 A 0 A_SetInventory("CantDoAction", 1);
			TNT1 A 0 {
				A_SetAkimbo(false);
				A_SetInventory("DualWieldingDeagles", 0);
				A_StartSound("Ironsights",1,CHANF_OVERLAP);
				A_ClearOverlays(10,11);
			}
			D6E2 GFE 1 {
				PB_SetDualSpriteIfUnload("D6E3","D6E4","D6E5");
				A_SetRoll(roll + 0.5, SPF_INTERPOLATE);
			}
			D6E2 DCB 1 {
				PB_SetDualSpriteIfUnload("D6E3","D6E4","D6E5");
				A_SetRoll(roll - 0.5, SPF_INTERPOLATE);
			}
			D6E2 A 1 PB_SetDualSpriteIfUnload("D6E3","D6E4","D6E5");
			TNT1 A 0 A_SetInventory("CantDoAction", 0);
			Goto Ready;


		NoAmmo:
			TNT1 A 0 A_JumpIf(invoker.ammo2 && invoker.ammo2.amount < 1,"NoAmmoUnloaded");
			D4E0 E 1 A_StartSound("weapons/empty");
			goto Ready;
		NoAmmoUnloaded:
			D1E0 A 1 A_StartSound("weapons/empty");
			goto Ready;
		NoAmmoDual:
			TNT1 A 1;
			goto Ready;

		Reload:
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(),"ReloadDualWield");
			TNT1 A 0 PB_CheckReload(null,"EmptyReload","Rechamber","Ready","Ready",8,2);
			TNT1 A 0 A_StartSound("Ironsights",2,CHANF_OVERLAP);
			D0E0 ABCDEFGHIJKLMN 1;
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(),"ContinueReload");
			D0E0 OPQ 1;
			TNT1 A 0 A_StartSound("weapons/deagle/magrelease",4,CHANF_OVERLAP);
			D0E0 RS 2;
			TNT1 A 0 {
				A_StartSound("weapons/deagle/magout",4,CHANF_OVERLAP);
				A_StartSound("PSRLOUT",3,CHANF_OVERLAP);
				PB_SetMagUnloaded(true);
			}
			D0E0 TUVW 1;
			D0E0 X 1;
			D0E0 XX 1 A_WeaponOffset(-0.95,0.75,WOF_ADD);
			D0E0 X 1 A_WeaponOffset(-0.75,0.75,WOF_ADD);
		ContinueReload:
			D0E0 X 1 A_WeaponOffset(-0.2,0.2,WOF_ADD);
			D0E0 Y 1 A_WeaponOffset(1.525,-1.125,WOF_ADD);
			TNT1 A 0 {
				PB_AmmoIntoMag("DeagleAmmo","PistolBullets",8,2);
				PB_SetMagUnloaded(false);
				PB_SetMagEmpty(false);
			}
			TNT1 A 0 A_StartSound("weapons/deagle/magin",4,CHANF_OVERLAP);
			D0E0 Z 1 A_WeaponOffset(1.725,-1.325,WOF_ADD);
			TNT1 A 0 A_WeaponOffset(0,32,WOF_INTERPOLATE);
			D0E1 AB 1;
			D0E1 CCC 1 A_WeaponOffset(0.2,0.1,WOF_ADD);
			D0E1 CC 1 A_WeaponOffset(-0.3,-0.15,WOF_ADD);
			TNT1 A 0 A_WeaponOffset(0,32,WOF_INTERPOLATE);
			D0E1 DEFG 1;
			TNT1 A 0 A_StartSound("Ironsights",6,CHANF_OVERLAP);
			D0E1 HIJKL 1;
			TNT1 A 0 PB_SetReloading(false);
			goto Ready;
		EmptyReload:
			TNT1 A 0 A_StartSound("Ironsights",2,CHANF_OVERLAP);
			D1E0 ABCDE 1;
			TNT1 A 0 A_StartSound("weapons/smg_magfly1",4,CHANF_OVERLAP);
			D1E0 FGHIJKLM 1;
			TNT1 A 0 A_StartSound("weapons/deagle/CatchF",5,CHANF_OVERLAP);
			D1E0 NOPQ 1;
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(),"ContinueReloadEmpty");
			TNT1 A 0 A_StartSound("weapons/deagle/MagRelease",0,CHANF_OVERLAP);
			D1E0 R 1;
			TNT1 A 0 A_StartSound("weapons/deagle/magout",6,CHANF_OVERLAP);
			TNT1 A 0 A_StartSound("PSRLOUT",3,CHANF_OVERLAP);
			TNT1 A 0 {
				PB_SpawnCasing("EmptyDeagleMag",30,12,16,1,-2,-2);
				PB_SetMagUnloaded(true);
			}
			D1E0 ST 1;
			TNT1 A 0 A_StartSound("weapons/deagle/MagToss",0,CHANF_OVERLAP);
			D1E0 UVWXYZ 1;
			D1E1 ABCD 1;
			TNT1 A 0 A_StartSound("weapons/deagle/CatchF",0,CHANF_OVERLAP,0.5);
		ContinueReloadEmpty:
			D1E1 EFG 1;
			TNT1 A 0 A_StartSound("weapons/deagle/magin",0,CHANF_OVERLAP);
			TNT1 A 0 {
				PB_AmmoIntoMag("DeagleAmmo","PistolBullets",7,2);
				PB_SetMagUnloaded(false);
				PB_SetMagEmpty(false);
			}
			D1E1 HIJKLMNOPQ 1;
			TNT1 A 0 A_StartSound("weapons/deagle/RotateFol",0,CHANF_OVERLAP);
			D1E1 RS 1;
		Rechamber:
			D1E1 TUVWXYZ 1;
			D1E2 A 1;
			TNT1 A 0 A_StartSound("weapons/deagle/click1",0,CHANF_OVERLAP);
			D1E2 BCD 1;
			D1E2 DDD 1 A_WeaponOffset(-0.5,0.2,WOF_ADD);
			D1E2 DD 1 A_WeaponOffset(0.75,-0.3,WOF_ADD);
			D1E2 E 1 A_WeaponOffset(0,32,WOF_INTERPOLATE);
			TNT1 A 0 A_StartSound("weapons/deagle/click2",1,CHANF_OVERLAP);
			D1E2 FFGH 1;
			TNT1 A 0 {
				A_StartSound("Ironsights",0,CHANF_OVERLAP);
				PB_SetChamberEmpty(false);
			}
			D1E2 IJKL 1;
			TNT1 A 0 PB_SetReloading(false);
			goto Ready;


		ReloadDualFromUnload:
			DR42 STUV 1 PB_SetDualSpriteIfUnload("DR14","DR20","DR00");

		ReloadDualWield:
			TNT1 A 0 PB_CheckReload(null,null,"StartRechamberRight","StartReloadLeft","Ready",8,2);
			TNT1 A 0 A_JumpIf(CountInv(invoker.AmmoTypeLeft) == 8 || ((PB_GetMagUnloaded(true) || PB_GetChamberEmpty(true) && !PB_GetMagEmpty(true)) && CountInv(invoker.ammotype2) < 8),"StartReloadRight");
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(),"StartReloadLeft");
			TNT1 A 0 {
				A_Overlay(10,"ReloadLeftDown_Overlay");
				A_Overlay(11,"StartReloadRight_Overlay");
			}
			TNT1 A 5;
			TNT1 A 0 A_StartSound("Ironsights", 2,CHANF_OVERLAP);
			TNT1 A 2;
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded() && PB_GetMagUnloaded(true),"ReloadDualFromUnload");
			TNT1 A 8;
			TNT1 A 0 {
				if(PB_GetMagEmpty())
					PB_SpawnCasing("EmptyDeagleMag",30,12,16,1,-2,-2);
				if(PB_GetMagEmpty(true))
					PB_SpawnCasing("EmptyDeagleMag",30,-12,16,1,2,-2);
				PB_SetMagUnloaded(true);
				PB_SetMagUnloaded(true,true);
				A_StartSound("weapons/deagle/magout",1,CHANF_OVERLAP);
				A_StartSound("PSRLOUT",3,CHANF_OVERLAP);
			}
			TNT1 A 1;
			TNT1 A 0 A_StartSound("weapons/deagle/SwapF",1,CHANF_OVERLAP);
			TNT1 A 2;
			Goto ReloadRightFromUnload;
		StartReloadLeft_Overlay:
			DR30 ABCDE 1 PB_SetSpriteIfUnload("DR10",true);
			DR30 FG 1 PB_SetSpriteIfUnload("DR10",true);
			DR30 HIJ 1 PB_SetSpriteIfUnload("DR10",true);
			DR33 KLMNO 1 PB_SetSpriteIfUnload("DR10",true);
			DR33 P 1 PB_SetSpriteIfUnload("DR10",true);
			DR33 QR 1 PB_SetSpriteIfUnload("DR10",true);
		ReloadLeftFromUnload_Overlay:
			DR33 STUV 1 PB_SetSpriteIfUnload("DR10",true);
			Stop;
		ReloadLeftDown_Overlay:
			DR30 ABCDE 1 PB_SetSpriteIfUnload("DR10",true);
			DR30 FG 1 PB_SetSpriteIfUnload("DR10",true);
			DR30 HIJ 1 PB_SetSpriteIfUnload("DR10",true);
			DR41 KLMNO 1 PB_SetSpriteIfUnload("DR00",true);
			DR41 P 1 PB_SetSpriteIfUnload("DR00",true);
			DR41 QR 1 PB_SetSpriteIfUnload("DR00",true);
			DR41 STU 1 PB_SetSpriteIfUnload("DR00",true);
			Stop;
		StartReloadRight_Overlay:
			DR40 ABCDE 1 PB_SetSpriteIfUnload("DR20");
			DR40 FG 1 PB_SetSpriteIfUnload("DR20");
			DR40 HIJ 1 PB_SetSpriteIfUnload("DR20");
			DR34 KLMNO 1 PB_SetSpriteIfUnload("DR20");
			DR34 P 1 PB_SetSpriteIfUnload("DR20");
			DR34 QR 1 PB_SetSpriteIfUnload("DR20");
		ReloadRightFromUnload_Overlay:
			DR34 STUV 1 PB_SetSpriteIfUnload("DR20");
			Stop;
		ReloadLeftUp_Overlay:
			DR35 ABCD 1 PB_SetSpriteIfUnload("DR24",true);
			Stop;
		ReloadLeftDown2_Overlay:
			DR35 DCBA 1 PB_SetSpriteIfUnload("DR24",true);
			Stop;
		ReloadRightDown2_Overlay:
			DR36 DCBA 1 PB_SetSpriteIfUnload("DR14");
			Stop;
		ReloadRightUp_Overlay:
			DR36 ABCD 1 PB_SetSpriteIfUnload("DR14");
			Stop;
		SelectLeft_Overlay:
			DR37 ABC 1 PB_SetSpriteIfUnload("DR13",true);
			Stop;
		SelectRight_Overlay:
			DR38 ABC 1 PB_SetSpriteIfUnload("DR23");
			Stop;
		DeselectLeft_Overlay:
			DR37 CBA 1 PB_SetSpriteIfUnload("DR13",true);
			Stop;
		DeselectRight_Overlay:
			DR38 CBA 1 PB_SetSpriteIfUnload("DR23");
			Stop;
		ReloadRightFromLeft:
			TNT1 A 0 A_Overlay(10,"ReloadLeftDown2_Overlay");
			TNT1 A 4;
			TNT1 A 2;
			TNT1 A 0 A_Overlay(11,"ReloadRightUp_Overlay");
			Goto ReloadRightFromUnload;
		StartReloadRight:
			TNT1 A 0 {
				A_Overlay(10,"DeselectLeft_Overlay");
				A_Overlay(11,"StartReloadRight_Overlay");
			}
			TNT1 A 5;
			TNT1 A 0 A_StartSound("Ironsights", 2,CHANF_OVERLAP);
			TNT1 A 2;
			TNT1 A 0 {
				if(PB_GetMagUnloaded()) {
					A_Overlay(11,"ReloadRightFromUnload_Overlay");
					return ResolveState("ReloadRightFromUnload");
				}
				return ResolveState(null);
			}
			TNT1 A 8;
			TNT1 A 0 {
				if(PB_GetMagEmpty())
					PB_SpawnCasing("EmptyDeagleMag",30,12,16,1,-2,-2);
				PB_SetMagUnloaded(true);
				A_StartSound("weapons/deagle/magout",1,CHANF_OVERLAP);
				A_StartSound("PSRLOUT",3,CHANF_OVERLAP);
			}
			TNT1 A 1;
			TNT1 A 0 A_StartSound("weapons/deagle/SwapF",1,CHANF_OVERLAP);
			TNT1 A 2;
		ReloadRightFromUnload:
			TNT1 A 4;
			DR32 ABCDE 1 PB_SetDualSpriteIfUnload("DR15","DR21","DR01");
			TNT1 A 0 {
				if(PB_GetChamberEmpty())
					PB_AmmoIntoMag("DeagleAmmo","PistolBullets",7,2);
				else
					PB_AmmoIntoMag("DeagleAmmo","PistolBullets",8,2);
				PB_SetMagUnloaded(false);
				PB_SetMagEmpty(false);
			}
			TNT1 A 0 A_StartSound("weapons/deagle/magin",0,CHANF_OVERLAP);
			DR32 FGHIJ 1 PB_SetDualSpriteIfUnload("DR15","DR21","DR01");
			TNT1 A 0 A_StartSound("weapons/deagle/SwapF",1,CHANF_OVERLAP);
			DR32 KLMNO 1 PB_SetDualSpriteIfUnload("DR15","DR21","DR01");
			TNT1 A 2;
			TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(),"RechamberRight");
			TNT1 A 0 A_JumpIf(CountInv("LeftDeagleAmmo") == 8 || CountInv(invoker.ammotype1) < 2,"FinishDualReload");
			TNT1 A 0 A_JumpIf(!PB_GetMagUnloaded(true) && PB_GetChamberEmpty(true) && !PB_GetMagEmpty(true),"RechamberLeft");
		ReloadLeftFromRight:
			TNT1 A 0 A_Overlay(10,"ReloadLeftUp_Overlay");
			TNT1 A 4;
			Goto ReloadLeft;
		StartReloadLeft:
			TNT1 A 0 PB_CheckReload(null,null,"StartRechamberLeft","Ready","Ready",8,2,true);
			TNT1 A 0 {
				A_Overlay(10,"DeselectRight_Overlay");
				A_Overlay(11,"StartReloadLeft_Overlay");
			}
			TNT1 A 5;
			TNT1 A 0 A_StartSound("Ironsights", 2,CHANF_OVERLAP);
			TNT1 A 2;
			TNT1 A 0 {
				if(PB_GetMagUnloaded(true)) {
					A_ClearOverlays(10,11);
					A_Overlay(10,"ReloadLeftFromUnload_Overlay");
					return ResolveState("ReloadLeftFromUnload");
				}
				return ResolveState(null);
			}
			TNT1 A 8;
			TNT1 A 0 {
				if(PB_GetMagEmpty(true))
					PB_SpawnCasing("EmptyDeagleMag",30,-12,16,1,2,-2);
				PB_SetMagUnloaded(true,true);
				A_StartSound("weapons/deagle/magout",1,CHANF_OVERLAP);
				A_StartSound("PSRLOUT",3,CHANF_OVERLAP);
			}
			TNT1 A 1;
			TNT1 A 0 A_StartSound("weapons/deagle/SwapF",1,CHANF_OVERLAP);
			TNT1 A 2;
		ReloadLeftFromUnload:
			TNT1 A 4;
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(),"ReloadRightFromLeft");
		ReloadLeft:
			DR31 ABCDE 1 PB_SetSpriteIfUnload("DR11",true);
			TNT1 A 0 {
				if(PB_GetChamberEmpty(true))
					PB_AmmoIntoMag("LeftDeagleAmmo","PistolBullets",7,2);
				else
					PB_AmmoIntoMag("LeftDeagleAmmo","PistolBullets",8,2);
				PB_SetMagUnloaded(false,true);
				PB_SetMagEmpty(false,true);
			}
			TNT1 A 0 A_StartSound("weapons/deagle/magin",1,CHANF_OVERLAP);
			DR31 FGHIJ 1 PB_SetSpriteIfUnload("DR11",true);
			TNT1 A 0 A_StartSound("weapons/deagle/SwapF",1,CHANF_OVERLAP);
			DR31 KLMNO 1 PB_SetSpriteIfUnload("DR11",true);
			TNT1 A 2;
			TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(true),"RechamberLeft");
		FinishDualReload:
			TNT1 A 0 {
				A_Overlay(10,"SelectLeft_Overlay");
				A_Overlay(11,"SelectRight_Overlay");
			}
			TNT1 A 3;
			TNT1 A 0 PB_SetReloading(false);
			goto Ready;
		StartRechamberRight:
			TNT1 A 0 {
				A_Overlay(10,"DeselectLeft_Overlay");
				A_Overlay(11,"DeselectRight_Overlay");
			}
			TNT1 A 3;
			TNT1 A 4;
		RechamberRight:
			DR02 ABCDE 1 PB_SetDualSpriteIfUnload("DR02","DR22","DR02");
			TNT1 A 0 A_StartSound("weapons/deagle/click1",4,CHANF_OVERLAP);
			DR02 FGHIJ 1 PB_SetDualSpriteIfUnload("DR02","DR22","DR02");
			TNT1 A 0 A_StartSound("weapons/deagle/click2",3,CHANF_OVERLAP);
			TNT1 A 0 PB_SetChamberEmpty(false);
			DR02 K 1;
			TNT1 A 0 A_StartSound("weapons/deagle/SwapF",1,CHANF_OVERLAP);
			DR02 LMNOP 1 PB_SetDualSpriteIfUnload("DR02","DR22","DR02");
			TNT1 A 2;
			TNT1 A 0 A_JumpIf(CountInv("LeftDeagleAmmo") == 8 || CountInv(invoker.ammotype1) < 2,"FinishDualReload");
			TNT1 A 0 A_JumpIf(!PB_GetMagUnloaded(true) && PB_GetChamberEmpty(true) && !PB_GetMagEmpty(true),"RechamberLeft");
			Goto ReloadLeftFromRight;
		StartRechamberLeft:
			TNT1 A 0 {
				A_Overlay(10,"DeselectLeft_Overlay");
				A_Overlay(11,"DeselectRight_Overlay");
			}
			TNT1 A 3;
		RechamberLeft:
			DR12 ABCDE 1;
			TNT1 A 0 A_StartSound("weapons/deagle/click1",6,CHANF_OVERLAP);
			DR12 FGHIJ 1;
			TNT1 A 0 A_StartSound("weapons/deagle/click2",4,CHANF_OVERLAP);
			TNT1 A 0 PB_SetChamberEmpty(false,true);
			DR12 K 1;
			TNT1 A 0 A_StartSound("weapons/deagle/SwapF",1,CHANF_OVERLAP);
			DR12 LMNOP 1;
			TNT1 A 0 PB_SetChamberEmpty(false,true);
			TNT1 A 2;
			goto FinishDualReload;
		Unload:
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "DualUnload");
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(),"Ready");
			D0E0 ABCDEFGHIJ 1;
			D0E0 KLMM 1;
			D2E1 ABCD 1;
			TNT1 A 0 A_StartSound("weapons/deagle/magout",2,CHANF_OVERLAP);
			TNT1 A 0 A_StartSound("PSRLOUT",3,CHANF_OVERLAP);
			TNT1 A 0 {
				PB_UnloadMag("DeagleAmmo","PistolBullets",2,goal:1);
				PB_UnloadMag("DeagleAmmo","PistolBullets",2,1,2,0,"PB_DeagleRound");
				PB_SetMagEmpty(true); PB_SetMagUnloaded(true); PB_SetChamberEmpty(true);
			}
			D2E1 E 1;
			TNT1 A 0 A_StartSound("weapons/deagle/click2",1,CHANF_OVERLAP);
			D2E1 FGHIJK 1;
			D1E0 HGFEDCBA 1;
			TNT1 A 0 PB_SetReloading(false);
			goto Ready;
		EndUnloadLeft_Overlay:
			DR10 FEDCBA 1;
			Stop;
		EndUnloadRight_Overlay:
			DR20 FEDCBA 1;
			Stop;
		NoUnloadRight_Overlay:
			D6E0 I 21 { if(PB_GetChamberEmpty()) A_SetWeaponFrame(9); }
			Stop;
		NoUnloadLeft_Overlay:
			D6E1 I 21 { if(PB_GetChamberEmpty(true)) A_SetWeaponFrame(9); }
			Stop;
		DualUnload:
			TNT1 A 0 {
				if(PB_GetMagUnloaded()) {
					A_Overlay(10,"StartReloadLeft_Overlay");
					A_Overlay(11,"NoUnloadRight_Overlay");
				}
				else if(PB_GetMagUnloaded(true)) {
					A_Overlay(10,"NoUnloadLeft_Overlay");
					A_Overlay(11,"StartReloadRight_Overlay");
				}
				else {
					A_Overlay(10,"StartReloadLeft_Overlay");
					A_Overlay(11,"StartReloadRight_Overlay");
				}
			}
			TNT1 A 5;
			TNT1 A 0 A_StartSound("Ironsights", 2,CHANF_OVERLAP);
			TNT1 A 2;
			TNT1 A 8;
			TNT1 A 0 {
				if(!PB_GetMagUnloaded(true)) {
					if(PB_GetMagEmpty(true))
						PB_SpawnCasing("EmptyDeagleMag",30,-12,16,1,2,-2);
					PB_UnloadMag("LeftDeagleAmmo","PistolBullets",2,goal:1);
					PB_UnloadMag("LeftDeagleAmmo","PistolBullets",2,1,2,0,"PB_DeagleRound");
					PB_SetMagEmpty(true,true); PB_SetMagUnloaded(true,true); PB_SetChamberEmpty(true,true);
					A_Overlay(10,"EndUnloadLeft_Overlay");
				}
				if(!PB_GetMagUnloaded()) {
					if(PB_GetMagEmpty())
						PB_SpawnCasing("EmptyDeagleMag",30,12,16,1,-2,-2);
					PB_UnloadMag("DeagleAmmo","PistolBullets",2,goal:1);
					PB_UnloadMag("DeagleAmmo","PistolBullets",2,1,2,0,"PB_DeagleRound");
					PB_SetMagEmpty(true); PB_SetMagUnloaded(true); PB_SetChamberEmpty(true);
					A_Overlay(11,"EndUnloadRight_Overlay");
				}
				A_StartSound("weapons/deagle/magout",1,CHANF_OVERLAP);
				A_StartSound("PSRLOUT",3,CHANF_OVERLAP);
			}
			TNT1 A 1;
			TNT1 A 0 A_StartSound("weapons/deagle/click2",1,CHANF_OVERLAP);
			TNT1 A 5;
			TNT1 A 0 PB_SetReloading(false);
			Goto Ready;


		AltFire:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				A_SetInventory("PB_LockScreenTilt",0);
			}
			TNT1 A 0 A_JumpIf(CountInv("Zoomed") > 0,"Zoomout");
			TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(),"Ready");
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_StartSound("IronSights", 6,CHANF_OVERLAP);
				A_SetInventory("Zoomed",1);
				A_ZoomFactor(1.25);
				A_SetCrosshair(-1);
			}
			D3E1 ABCDE 1;
			Goto Ready2;
		Zoomout:
			TNT1 A 0 {
				A_SetInventory("Zoomed",0);
				A_ZoomFactor(1.0);
			}
			D3E1 EDCBA 1;
			TNT1 A 0 PB_HandleCrosshair(32);
			Goto Ready;

		Ready2:
			TNT1 A 0 {
				A_SetRoll(0);
				A_SetInventory("PB_LockScreenTilt",0);
			}
		ReadyToFire2:
			D3E0 A 1
			{
				PB_CoolDownBarrel(0, 0, 4);
				if(CVar.GetCvar("pb_toggle_aim_hold",player).getint() == 1)
				{
					if(!PressingAltfire() || JustReleased(BT_ALTATTACK))
						return ResolveState("Zoomout");

					if (PressingFire() && PressingAltfire() && CountInv(invoker.ammotype2) > 0)
						return ResolveState("Fire2");

					return A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOSECONDARY);
				}
				else
				{
					if (PressingFire() && CountInv(invoker.ammotype2) > 0 )
						return ResolveState("Fire2");

					return A_DoPBWeaponAction(WRF_ALLOWRELOAD);
				}
				return ResolveState(null);
			}
			Loop;

		MuzzleFlash2:
			D3EM AB 1 Bright A_GunFlash();
			Stop;
		Fire2:
			TNT1 A 0 A_WeaponOffset(0,32);
			TNT1 A 0 PB_jumpIfNoAmmo("Reload",1);
			D3E0 B 1 BRIGHT {
				PB_IncrementHeat(2);
				A_StartSound("weapons/deagle/fire", 0, CHANF_OVERLAP, 1.0);
				A_StartSound("weapons/deagle/afire", 0, CHANF_OVERLAP, 0.70);
				PB_DynamicTail("shotgun", "pistol_mag");
				PB_LowAmmoSoundWarning("pistol");
				A_FireProjectile("PB_50AE", frandom(-0.1,0.1),0,0,0, FPF_NOAUTOAIM, frandom(-0.1,0.1));
				A_AlertMonsters();
				PB_GunSmoke_Deagle(0,5,5);
				PB_MuzzleFlashEffects(0,5,5);
				PB_IncrementHeat(2);
				A_FireProjectile("YellowFlareSpawn",0,0,0,0);
				PB_SpawnCasing("EmptyBrassDeagle",26,0,38,-frandom(1.0, 2.0),frandom(2.0,6.0),frandom(3.0,6.0));
				PB_TakeAmmo("DeagleAmmo",1);
				A_ZoomFactor(1.20);
				PB_WeaponRecoil(-0.90,-0.25);
				A_Overlay(-5, "MuzzleFlash2", true);
				A_OverlayFlags(-5,PSPF_RENDERSTYLE,true);
				A_OverlayRenderStyle(-5,STYLE_Add);
			}
			D3E0 C 1 BRIGHT PB_WeaponRecoil(-0.90,-0.25);
			D3E0 D 1 A_ZoomFactor(1.23);
			D3E0 E 1 A_ZoomFactor(1.25);
			D3E0 FGH 1;
			D3E0 AAAAA 1 {
				A_SetInventory("CantDoAction",0);
				if(CVar.GetCvar("pb_toggle_aim_hold",player).getint())
				{
					if(JustReleased(BT_ALTATTACK))
						return ResolveState("Zoomout");
					if (JustPressed(BT_ATTACK) && PressingAltfire())
						return ResolveState("Fire2");
				}
				else
				{
					if(PressingAltfire())
						return ResolveState("Zoomout");
					if (JustPressed(BT_ATTACK))
						return ResolveState("Fire2");
				}
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOFIRE);
			}
			Goto Ready2;


		SelectAnimationDualWield:
			TNT1 A 1;
			TNT1 A 0 {
				A_Overlay(10,"SelectLeft_Overlay");
				A_Overlay(11,"SelectRight_Overlay");
			}
			TNT1 A 3;
			goto ReadyDualWield;

		DeselectAnimationDualWield:
			TNT1 A 0 {
				A_Overlay(10,"DeselectLeft_Overlay");
				A_Overlay(11,"DeselectRight_Overlay");
			}
			TNT1 A 4;
			TNT1 A 0 A_Lower(120);
			wait;

		ReadyDualWield:
			TNT1 A 0 {
				A_SetRoll(0);
				PB_HandleCrosshair(32);
				A_SetInventory("PB_LockScreenTilt",0);
				A_SetFiringRightWeapon(false);
				A_SetFiringLeftWeapon(false);
				A_Overlay(10,"IdleLeft_Overlay",false);
				A_Overlay(11,"IdleRight_Overlay",false);
			}
		ReadyToFireDualWield:
			TNT1 A 1 A_DoPBDualAction(2);
			Loop;

		IdleLeft_Overlay:
			D6E1 I 1 {
				PB_CoolDownBarrel(15, 0, 6);
				if(PB_GetChamberEmpty(true))
					A_SetWeaponFrame(9);
				return A_DoPBLeftAction();
			}
			Loop;

		IdleRight_Overlay:
			D6E0 I 1 {
				PB_CoolDownBarrel(-15, 0, 6);
				if(PB_GetChamberEmpty())
					A_SetWeaponFrame(9);
				return A_DoPBRightAction();
			}
			Loop;

		MuzzleFlashLeft:
			D6EM CD 1 Bright A_GunFlash();
			Stop;
		FireLeft_Overlay:
			D6E1 A 1 BRIGHT {
				PB_IncrementHeat(2, true);
				A_SetFiringLeftWeapon(true);
				A_FireProjectile("PB_50AE", frandom(-0.1,0.1),0,-6,0, FPF_NOAUTOAIM, frandom(-0.1,0.1));
				PB_GunSmoke_Deagle(15,0,6);
				PB_MuzzleFlashEffects(15,0,6);
				PB_SpawnCasing("EmptyBrassDeagle",26,-12,38,-frandom(1.0, 2.0),frandom(2.0,6.0),frandom(3.0,6.0));
				A_StartSound("weapons/deagle/fire", 0, CHANF_OVERLAP, 1.0);
				A_StartSound("weapons/deagle/afire", 0, CHANF_OVERLAP, 0.70);
				PB_DynamicTail("shotgun", "pistol_mag");
				PB_LowAmmoSoundWarning("pistol", "LeftDeagleAmmo");
				PB_TakeAmmo("LeftDeagleAmmo",1,1,0,true);
				A_AlertMonsters();
				A_ZoomFactor(0.985);
				PB_WeaponRecoil(-1.92, 1.8);
				A_Overlay(-5, "MuzzleFlashLeft", true);
				A_OverlayFlags(-5,PSPF_RENDERSTYLE,true);
				A_OverlayRenderStyle(-5,STYLE_Add);
			}
			D6E1 B 1 Bright {
				A_ZoomFactor(1.0);
				PB_WeaponRecoil(-1.92, 2.0);
			}
			D6E1 C 1 {
				A_SetFiringLeftWeapon(false);
				if(CountInv("LeftDeagleAmmo")<=0 || CountInv("DeagleAmmo")>0 ){
					A_GiveInventory("DualFiring",1);
				}
			}
			TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(true),"EndFireNoAmmoLeft");
			D6E1 DEFGH 1;
			D6E1 II 1 {
				int firemodecvar = CVar.GetCvar("SingleDualFire",player).GetInt();
				if(JustPressed(BT_ALTATTACK) && !A_IsFiringRightWeapon() && firemodecvar == 2){
					if(CountInv("LeftDeagleAmmo") > 0)
						return ResolveState("FireLeft_Overlay");
					else
					{
						A_StartSound("weapons/empty", 3,CHANF_OVERLAP);
						return ResolveState(null);
					}
				}
				if(JustPressed(BT_ATTACK) && !A_IsFiringLeftWeapon())
				{
					if(CountInv("LeftDeagleAmmo") > 0)
					{
						return ResolveState("FireLeft_Overlay");
					}
					else
					{
						A_StartSound("weapons/empty", 3,CHANF_OVERLAP);
						return ResolveState(null);
					}
				}
				return ResolveState(null);
			}
			TNT1 A 0 {
				if(CountInv("LeftDeagleAmmo")<=0)
					A_GiveInventory("DualFireReload",1);
			}
			Goto IdleLeft_Overlay;

		EndFireNoAmmoLeft:
			D6E7 ABCDEF 1;
			D6E1 JJ 1 {
				int firemodecvar = CVar.GetCvar("SingleDualFire",player).GetInt();
				if(JustPressed(BT_ALTATTACK) && !A_IsFiringRightWeapon() && firemodecvar == 2){
					if(CountInv("LeftDeagleAmmo") > 0)
						return ResolveState("FireLeft_Overlay");
					else
					{
						A_StartSound("weapons/empty", 3,CHANF_OVERLAP);
						return ResolveState(null);
					}
				}
				if(JustPressed(BT_ATTACK) && !A_IsFiringLeftWeapon())
				{
					if(CountInv("LeftDeagleAmmo") > 0)
						return ResolveState("FireLeft_Overlay");
					else
					{
						A_StartSound("weapons/empty", 3,CHANF_OVERLAP);
						return ResolveState(null);
					}
				}
				return ResolveState(null);
			}
			TNT1 A 0 {
				if(CountInv("LeftDeagleAmmo")<=0)
					A_GiveInventory("DualFireReload",1);
			}
			Goto IdleLeft_Overlay;

		MuzzleFlashRight:
			D6EM AB 1 Bright A_GunFlash();
			Stop;
		FireRight_Overlay:
			D6E0 A 1 BRIGHT {
				PB_IncrementHeat(2);
				A_SetFiringRightWeapon(true);
				A_FireProjectile("PB_50AE", frandom(-0.1,0.1),0,6,0, FPF_NOAUTOAIM, frandom(-0.1,0.1));
				PB_GunSmoke_Deagle(-15,0,6);
				PB_MuzzleFlashEffects(-15,0,6);
				PB_SpawnCasing("EmptyBrassDeagle",26,25,38,-frandom(1.0, 2.0),frandom(2.0,6.0),frandom(3.0,6.0));
				A_StartSound("weapons/deagle/fire", 0, CHANF_OVERLAP, 1.0);
				A_StartSound("weapons/deagle/afire", 0, CHANF_OVERLAP, 0.70);
				PB_DynamicTail("shotgun", "pistol_mag");
				PB_LowAmmoSoundWarning("pistol");
				A_ZoomFactor(0.985);
				PB_TakeAmmo("DeagleAmmo",1);
				A_AlertMonsters();
				A_SetFiringRightWeapon(true);
				PB_WeaponRecoil(-1.92,-1.8);
				A_Overlay(-6, "MuzzleFlashRight", true);
				A_OverlayFlags(-6,PSPF_RENDERSTYLE,true);
				A_OverlayRenderStyle(-6,STYLE_Add);
			}
			D6E0 B 1 BRIGHT {
				A_ZoomFactor(1.0);
				PB_WeaponRecoil(-1.92,-2.0);
			}
			D6E0 C 1 {
				A_SetFiringRightWeapon(false);
				if(CountInv("LeftDeagleAmmo")>0 || CountInv("DeagleAmmo")<=0 ){
					A_TakeInventory("DualFiring",1);
				}
			}
			TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(),"EndFireNoAmmoRight");
			D6E0 DEFGH 1;
			D6E0 II 1 {
				int firemodecvar = CVar.GetCvar("SingleDualFire",player).GetInt();
				if(JustPressed(BT_ATTACK) && !A_IsFiringRightWeapon() && firemodecvar == 2){
					if(CountInv("DeagleAmmo") > 0)
						return ResolveState("FireRight_Overlay");
					else
					{
						A_StartSound("weapons/empty", 3,CHANF_OVERLAP);
						return ResolveState(null);
					}
				}
				if(JustPressed(BT_ALTATTACK) && !A_IsFiringRightWeapon() && firemodecvar > 2){
					if(CountInv("DeagleAmmo") > 0)
						return ResolveState("FireRight_Overlay");
					else
					{
						A_StartSound("weapons/empty", 3,CHANF_OVERLAP);
						return ResolveState(null);
					}
				}
				return ResolveState(null);
			}
			TNT1 A 0 {
				if(CountInv("DeagleAmmo")<=0)
					A_GiveInventory("DualFireReload",1);
			}
			Goto IdleRight_Overlay;

		EndFireNoAmmoRight:
			D6E6 ABCDEF 1;
			D6E0 JJ 1 {
				int firemodecvar = CVar.GetCvar("SingleDualFire",player).GetInt();
				if(JustPressed(BT_ATTACK) && !A_IsFiringRightWeapon() && firemodecvar == 2){
					if(CountInv("DeagleAmmo") > 0)
						return ResolveState("FireRight_Overlay");
					else
					{
						A_StartSound("weapons/empty", 3,CHANF_OVERLAP);
						return ResolveState(null);
					}
				}
				if(JustPressed(BT_ALTATTACK) && !A_IsFiringRightWeapon() && firemodecvar > 2){
					if(CountInv("DeagleAmmo") > 0)
						return ResolveState("FireRight_Overlay");
					else
					{
						A_StartSound("weapons/empty", 3,CHANF_OVERLAP);
						return ResolveState(null);
					}
				}
				return ResolveState(null);
			}
			TNT1 A 0 {
				if(CountInv("DeagleAmmo")<=0)
					A_GiveInventory("DualFireReload",1);
			}
			Goto IdleRight_Overlay;


		LoadSprites:
			D4U0 A 0;
			D5E1 A 0;
			D6E2 A 0;
			D6E3 A 0;
			D6E4 A 0;
			D6E5 A 0;
			D7E1 A 0;
			D7E2 A 0;
			D7E3 A 0;
			D8E1 A 0;
			DR00 A 0;
			DR01 A 0;
			DR03 A 0;
			DR10 A 0;
			DR11 A 0;
			DR13 A 0;
			DR14 A 0;
			DR15 A 0;
			DR20 A 0;
			DR21 A 0;
			DR22 A 0;
			DR23 A 0;
			DR24 A 0;
			Stop;

		FlashPunching:
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(),"FlashPunchingDual");
			D8E0 ABCDEFGGFEDCBA 1 PB_SetSpriteIfUnload("D8E1");
			TNT1 A 0 A_ClearOverlays(PSP_FLASH, PSP_FLASH, false);
			Goto Ready3;
		FlashPunchingDual:
			TNT1 A 0 A_ClearOverlays(10,11);
			TNT1 ABCDEFGGFEDCBA 1;
			TNT1 A 0 A_ClearOverlays(PSP_FLASH, PSP_FLASH, false);
			Goto Ready3;
		FlashKicking:
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(),"FlashKickingDual");
			D5E0 ABCDEFGGGFEDCBA 1 PB_SetSpriteIfUnload("D5E1");
			goto Ready;
		FlashKickingDual:
			TNT1 A 0 A_ClearOverlays(10,11);
			D7E0 ABCDEFGGGFEDCBA 1 PB_SetDualSpriteIfUnload("D7E2","D7E3","D7E1");
			goto Ready;
		FlashAirKicking:
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(),"FlashAirKickingDual");
			D5E0 ABCDEFGGGGFEDCBA 1 PB_SetSpriteIfUnload("D5E1");
			goto Ready;
		FlashAirKickingDual:
			TNT1 A 0 A_ClearOverlays(10,11);
			D7E0 ABCDEFGGGGFEDCBA 1 PB_SetDualSpriteIfUnload("D7E2","D7E3","D7E1");
			goto Ready;
		FlashSlideKicking:
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(),"FlashSlideKickingDual");
			D5E0 ABCDEFGGGGGGGGGGGGGGGFEDCBA 1 PB_SetSpriteIfUnload("D5E1");
			goto Ready;
		FlashSlideKickingDual:
			TNT1 A 0 A_ClearOverlays(10,11);
			D7E0 ABCDEFGGGGGGGGGGGGGGGFEDCBA 1 PB_SetDualSpriteIfUnload("D7E2","D7E3","D7E1");
			goto Ready;
		FlashSlideKickingStop:
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(),"FlashSlideKickingStopDual");
			D5E0 GFEDCBA 1 PB_SetSpriteIfUnload("D5E1");
			goto Ready;
		FlashSlideKickingStopDual:
			TNT1 A 0 A_ClearOverlays(10,11);
			D7E0 GFEDCBA 1 PB_SetDualSpriteIfUnload("D7E2","D7E3","D7E1");
			goto Ready;
	}
}


// 8-round magazines (was 12 in PB 2022 DECORATE — staging matches real-world).
class DeagleAmmo : Ammo
{
	default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 8;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 8;
		+INVENTORY.IGNORESKILL;
		Inventory.Icon "D4E0Z0";
	}
}
class LeftDeagleAmmo : Ammo
{
	default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 8;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 8;
		+INVENTORY.IGNORESKILL;
		Inventory.Icon "D4E0Z0";
	}
}

// .50 AE projectile used by the staging port. Modeled as a fast piercing
// projectile — staging's true definition is in their bullet system; we use
// a sane equivalent that matches the gunfeel (single-shot, alerts, gibs).
class PB_50AE : FastProjectile
{
	default
	{
		Radius 5;
		Height 4;
		Speed 100;
		Damage 90;
		PROJECTILE;
		+BLOODSPLATTER;
		+FORCEXYBILLBOARD;
		+THRUGHOST;
		+RIPPER;
		MissileType "BulletPuff";
		DamageType "Tracer";
		DeathSound "";
		Decal "BulletChip";
	}
	states
	{
		Spawn:
			TNT1 A 1 BRIGHT;
			Loop;
		Death:
			TNT1 A 1;
			Stop;
	}
}

// Empty mag drop (used during reload / unload).
class EmptyDeagleMag : Inventory
{
	default
	{
		+NOBLOCKMAP;
		+NOTELEPORT;
		+CLIENTSIDEONLY;
		+THRUACTORS;
		+MOVEWITHSECTOR;
		Radius 1;
		Height 1;
		Mass 1;
		Gravity 0.4;
		BounceType "Doom";
		BounceFactor 0.4;
		WallBounceFactor 0.2;
		Scale 0.4;
	}
	states
	{
		Spawn:
			DMAG ABCDEFGH 3;
			Goto Death;
		Death:
			DMAG H 350;
			Stop;
	}
}

// Loose round visual spawned by PB_UnloadMag (one per round transferred).
class PB_DeagleRound : Inventory
{
	default
	{
		+NOBLOCKMAP;
		+NOTELEPORT;
		+CLIENTSIDEONLY;
		+THRUACTORS;
		Radius 1;
		Height 1;
		Mass 1;
		Gravity 0.4;
		BounceType "Doom";
		BounceFactor 0.3;
		WallBounceFactor 0.2;
		Scale 0.35;
	}
	states
	{
		Spawn:
			BRAS ABCDEF 3;
			Goto Death;
		Death:
			BRAS F 175;
			Stop;
	}
}

// State / SBARINFO companion tokens (kept matching the DECORATE retirement).
class DeagleSelected      : Inventory { default { Inventory.MaxAmount 1; +INVENTORY.UNDROPPABLE; +INVENTORY.UNTOSSABLE; } }
class RespectDeagle       : Inventory { default { Inventory.MaxAmount 1; +INVENTORY.UNDROPPABLE; } }
class DeagleHasUnloaded   : Inventory { default { Inventory.MaxAmount 1; +INVENTORY.UNDROPPABLE; } }
class DeagleWasEmpty      : Inventory { default { Inventory.MaxAmount 1; +INVENTORY.UNDROPPABLE; } }
class DualWieldingDeagles : Inventory { default { Inventory.MaxAmount 1; +INVENTORY.UNDROPPABLE; } }

// Staging-style "freeze the player out of overlapping actions" guard. PB 2022
// did not previously ship this token (DECORATE used IsReloading + CantSwitch
// piecewise); the staging Deagle expects a generic CantDoAction so we provide
// one. Other ported staging weapons can reuse it.
class CantDoAction        : Inventory { default { Inventory.MaxAmount 1; +INVENTORY.UNDROPPABLE; } }
