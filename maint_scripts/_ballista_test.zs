// ProSurv_Ballista - ZScript port (DECORATE PB_Weapon retired).

class ProSurv_Ballista : PB_WeaponBase
{
	default
	{
		// Game Doom (DECORATE only)
	Weapon.AmmoUse1 0;
	Weapon.AmmoGive1 15;
	Weapon.AmmoUse2 0;
	Weapon.AmmoGive2 1;
	Weapon.AmmoType1 "PB_HighCalMag";
	Weapon.AmmoType2 "BallistaAmmo";
	Weapon.SlotNumber 4;
	Weapon.SlotPriority 0.15;
	Weapon.SelectionOrder 300;
	PB_WeaponBase.respectItem "RespectBallista";
	PB_WeaponBase.UnloaderToken "BallistaUnloaded";
	Inventory.PickupMessage "Pro-Surv Ballista (Slot 4)";
	Inventory.PickupSound "weapons/ballista/drawstring";
	Inventory.AltHUDIcon "CBOWS0"
	Obituary "%k speared %o with a Pro-Surv Ballista";
	AttackSound "None";
		Weapon.BobStyle "InverseSmooth";
	+WEAPON.NOALERT;
	+WEAPON.NOAUTOAIM;
	+WEAPON.NOAUTOFIRE;
	+FORCEXYBILLBOARD;
	Scale 0.7;
	Tag "Pro-Surv Ballista";
	}
	states
	{
		FlashPunching:
				TNT1 A 0 A_JumpIfInventory("BallistaAmmo",1,1);
				Goto FlashPunchingUnloaded;
				TNT1 A 0 A_JumpIfInventory("BallistaDemonicMode", 1, "FlashPunchingUpgraded");
				CBOW ABCDEEEEEEDCBA 1;
				TNT1 A 0 A_ClearOverlays(PSP_FLASH, PSP_FLASH, false);
				Goto Ready3;
		FlashPunchingUpgraded:
				CBOW KLMNOOOOOONMLK 1;
				TNT1 A 0 A_ClearOverlays(PSP_FLASH, PSP_FLASH, false);
				Goto Ready3;
		FlashPunchingUnloaded:
				CBOW FGHIJJJJJJIHGF 1;
				TNT1 A 0 A_ClearOverlays(PSP_FLASH, PSP_FLASH, false);
				Goto Ready3;
		FlashKicking:
				TNT1 A 0 A_JumpIfInventory("BallistaAmmo",1,1);
				Goto FlashKickingUnloaded;
				TNT1 A 0 A_JumpIfInventory("BallistaDemonicMode", 1, "FlashKickingUpgraded");
				CRBW LMNOPPPPPPONML 1;
				Goto Ready3;
		FlashKickingUpgraded:
				CRBW VWXYZZZZZZYXWV 1;
				Goto Ready3;
		FlashKickingUnloaded:
				CRBW QRSTUUUUUUTSRQ 1;
				Goto Ready3;
		FlashAirKicking:
				TNT1 A 0 A_JumpIfInventory("BallistaAmmo",1,1);
				Goto FlashAirKickingUnloaded;
				TNT1 A 0 A_JumpIfInventory("BallistaDemonicMode", 1, "FlashAirKickingUpgraded");
				CRBW LMNOPPPPPPONML 1;
				Goto Ready3;
		FlashAirKickingUpgraded:
				CRBW VWXYZZZZZZYXWV 1;
				Goto Ready3;
		FlashAirKickingUnloaded:
				CRBW QRSTUUUUUUTSRQ 1;
				Goto Ready3;
		FlashSlideKicking:
				TNT1 A 0 A_JumpIfInventory("BallistaAmmo",1,1);
				Goto FlashSlideKickingUnloaded;
				TNT1 A 0 A_JumpIfInventory("BallistaDemonicMode", 1, "FlashSlideKickingUpgraded");
				CRBW LMNO 1;
				CRBW P 21;
				Goto Ready3;
		FlashSlideKickingStop:
				TNT1 A 0 A_JumpIfInventory("BallistaAmmo",1,1);
				Goto FlashSlideKickingStopUnloaded;
				TNT1 A 0 A_JumpIfInventory("BallistaDemonicMode", 1, "FlashSlideKickingStopUpgraded");
				CRBW PPPONML 1;
				Goto Ready3;
		FlashSlideKickingUpgraded:
				CRBW VWXY 1;
				CRBW Z 21;
				Goto Ready3;
		FlashSlideKickingStopUpgraded:
				CRBW ZZZYXWV 1;
				Goto Ready3;
		FlashSlideKickingUnloaded:
				CRBW QRST 1;
				CRBW U 21;
				Goto Ready3;
		FlashSlideKickingStopUnloaded:
				CRBW UUUTSRQ 1;
				Goto Ready3;
		Spawn:
				CBOW S -1;
				Stop;
		Select:
				TNT1 A 0 PB_HandleCrosshair(29);
				TNT1 A 0 {
					A_WeaponOffset(0,32);
					A_SetRoll(0);
					A_SetInventory("PB_LockScreenTilt",0);
				TNT1 A 0 A_TakeInventory("HasBarrel",1);
				TNT1 A 0 A_TakeInventory("HasIceBarrel",1);
				TNT1 A 0 A_TakeInventory("HasBurningBarrel",1);
				TNT1 A 0 A_TakeInventory("GrabbedBarrel",1);
				TNT1 A 0 A_TakeInventory("GrabbedIceBarrel",1);
				TNT1 A 0 A_TakeInventory("GrabbedBurningBarrel",1);
				Goto SelectFirstPersonLegs;
		SelectContinue:
				TNT1 A 0 A_SetInventory("Unloading",0);
				TNT1 A 0 A_SetInventory( "RandomHeadExploder", 1 );
		SelectAnimation:
				TNT1 A 0 A_JumpIfInventory("BallistaUnloaded", 1, "SelectAnimationUnloaded");
				TNT1 A 0 A_JumpIfInventory("BallistaDemonicMode", 1, "SelectAnimationUpgraded");
				CBOW P 1 A_PlaySoundEx("weapons/ballista/raise","Auto");
				CRBW ONML 1 A_DoPBWeaponAction;
				Goto Ready3;
		SelectAnimationUpgraded:
				CBOW R 1;
				CRBW YXWV 1;
				Goto Ready3;
		SelectAnimationUnloaded:
				CBOW Q 1;
				CRBW TSRQ 1;
				Goto Ready3;
		Ready:
				TNT1 A 0;
				{
					if (CountInv("ProSurv_Ballista") >= 1);
					{
						return state("");
					return state("");
				TNT1 A 0 A_JumpIfInventory("RespectBallista", 1, "SelectAnimation");
		WeaponRespect:
				TNT1 A 0 A_GiveInventory("RespectBallista",1);
				TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
				CBOW Q 1 A_DoPBWeaponAction;
				CRBW TSRQ 1 A_DoPBWeaponAction;
				CRBW A 5 A_DoPBWeaponAction;
				TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
				CBWR ABCDEF 1 {
					A_SetRoll(roll-.4, SPF_INTERPOLATE);
					A_DoPBWeaponAction;
				CBWR GGGGGGGGG 1 A_DoPBWeaponAction;
				TNT1 A 0 A_PlaySoundEx("Ironsights","Auto");
				CBWR HIJKKKKKKK 1 A_DoPBWeaponAction;
				TNT1 A 0 A_PlaySoundEx("weapons/ballista/drawstring","Auto");
				CBWR LMNOP 1 A_DoPBWeaponAction;
				TNT1 A 0 {
					A_SetInventory("BallistaDemonicMode",0);
					A_PlaySoundEx("Ironsights","Auto");
				CBOR AB 1 A_DoPBWeaponAction;
				TNT1 A 0 A_PlaySoundEx("weapons/ballista/boltin","Auto");
				CBOR CDE 1 A_DoPBWeaponAction;
				CBOR FG 1 {
					A_SetRoll(roll-.3, SPF_INTERPOLATE);
					A_DoPBWeaponAction;
				CBOR H 1 {
					A_SetRoll(roll+.3, SPF_INTERPOLATE);
					A_DoPBWeaponAction;
				CBOR IJ 1 {
					A_SetRoll(roll+.4, SPF_INTERPOLATE);
					A_DoPBWeaponAction;
				TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
				CBOR KLMN 1 {
					A_SetRoll(roll+.4, SPF_INTERPOLATE);
					A_DoPBWeaponAction;
				Goto Ready3;
		Ready3:
				TNT1 A 0 PB_CheckBarrelIdle1();
				TNT1 A 0 PB_HandleCrosshair(29);
				TNT1 A 0 {
					A_SetRoll(0);
					A_SetInventory("PB_LockScreenTilt",0);
				TNT1 A 0;
				Goto ReadyToFire;
		ChooseUpgradePath:
				TNT1 A 0 A_PrintBold("\cfChoose your path:\n\caFIRE = PROSURV BALLISTA\n\ciALTFIRE = RAILBALLISTA");
				TNT1 A 1;
				TNT1 A 1;
		ChooseUpgradePathDebounce:
				TNT1 A 2;
		ChooseUpgradePathLoop:
				TNT1 A 0 A_JumpIf(JustPressed(BT_ATTACK), "KeepProSurvBallistaPath");
				TNT1 A 0 A_JumpIf(JustPressed(BT_ALTATTACK), "KeepBallistaPath");
				TNT1 A 1;
				TNT1 A 1;
		KeepProSurvBallistaPath:
				TNT1 A 0 A_TakeInventory("ProSurv_Ballista", 1);
				TNT1 A 0 A_PrintBold("\caPath selected: PROSURV BALLISTA");
				Goto ReadyToFire;
		KeepBallistaPath:
				TNT1 A 0 A_TakeInventory("ProSurv_Ballista", 1);
				TNT1 A 0 A_PrintBold("\ciPath selected: RAILBALLISTA");
				TNT1 A 0 A_SelectWeapon("ProSurv_Ballista");
				Stop;
		ReadyToFire:
				TNT1 A 0 PB_CheckBarrelIdle1();
				TNT1 A 0 A_JumpIfInventory("SwapToDemonicMode",1,"WeaponSpecial");
				TNT1 A 0 A_JumpIfInventory("BallistaAmmo",1,1);
				Goto ReadyEmpty;
				TNT1 A 0 A_JumpIfInventory("BallistaDemonicMode", 1, "ReadyToFireDemonic");
				CRBW B 1 A_DoPBWeaponAction;
				Goto ReadyToFire;
		ReadyToFireDemonic:
				TNT1 A 0 PB_CheckBarrelIdle1();
				CRBW CDED 3 A_DoPBWeaponAction;
				Goto ReadyToFire;
		ReadyEmpty:
				TNT1 A 0 PB_CheckBarrelIdle1();
				TNT1 A 0 A_JumpIfInventory("PB_HighCalMag",1,"Reload");
				TNT1 A 0 { 
					if (CountInv("PB_DTech") >= 5 && CountInv("BallistaUpgraded") == 1){ return state("ReloadStartDemonic");}
					return state ("");
				CRBW A 1 A_DoPBWeaponAction;
				Goto ReadyEmpty;
		Deselect:
				TNT1 A 0 PB_CheckBarrelIdle1();
				TNT1 A 0 A_SetCrosshair(5);
				TNT1 A 0 {
					A_WeaponOffset(0,32);
					A_SetRoll(0);
					A_SetInventory("PB_LockScreenTilt",0);
					A_TakeInventory("Reloading",1);
					A_ClearOverlays(10,11);
					A_ZoomFactor(1.0); 
				CRBW LMNO 1;
				CBOW P 1;
		FinishDeselect:
				TNT1 AAAAAAAAAAAAAAAAAA 0 A_Lower;
				Wait;
		PDA_Preview_BallistaFire:
				CRBW F 1;
				CRBW G 1;
				CRBW H 1;
				CRBW I 1;
				CRBW J 1;
				CRBW JJ 1;
				CRBW J 1;
				CRBW J 2;
				Stop;
		PDA_Preview_BallistaFireDemonic:
				CRBW K 1 BRIGHT;
				CRBW G 1 BRIGHT;
				CRBW H 1;
				CRBW I 1;
				CRBW J 1;
				CRBW JJ 1;
				CRBW J 1;
				CRBW J 2;
				Stop;
		PDA_Preview_BallistaAlt:
				CRBW F 1;
				CRBW G 1;
				CRBW H 1;
				CRBW I 1;
				CRBW J 1;
				CRBW JJ 1;
				CRBW J 1;
				CRBW J 2;
				Stop;
		PDA_Preview_BallistaAltDemonic:
				CBOW U 1 BRIGHT;
				CRBW G 1 BRIGHT;
				CRBW H 1;
				CRBW I 1;
				CRBW J 1;
				CRBW JJ 1;
				CRBW J 1;
				CRBW J 2;
				Stop;
		Fire:
				TNT1 A 0 A_JumpIfInventory ("GrabbedBarrel", 1, "ThrowBarrel");
				TNT1 A 0 A_JumpIfInventory ("GrabbedBurningBarrel", 1, "ThrowFlameBarrel");
				TNT1 A 0 A_JumpIfInventory ("GrabbedIceBarrel", 1, "ThrowIceBarrel");
				TNT1 A 0 {
					A_WeaponOffset(0,32);
					A_SetRoll(0);
					A_TakeInventory("PB_LockScreenTilt",1);
				TNT1 A 0 {
					if(CountInv("GoFatality") >= 1) { SetPlayerProperty(0,1,0); }
					else { SetPlayerProperty(0,0,0); SetPlayerProperty(0,0,PROP_TOTALLYFROZEN); }
				TNT1 A 0 A_JumpIfInventory("GoFatality",1,"Steady");
				TNT1 A 0 A_JumpIfInventory("BallistaAmmo",1,1);
				Goto ReadyEmpty;
				TNT1 A 0;
				TNT1 A 0 {
					if(CountInv("NoFatality") == 0 && GetCVar ("pb_auto_fatality_fire") == 1) {
						return PB_Execute();
					return state("");
				TNT1 A 0 A_ZoomFactor(0.98);
				TNT1 A 0 A_JumpIfInventory("BallistaDemonicMode",1,"FireDemonic");
				TNT1 A 0 A_PlaySoundEx("weapons/ballista/firebolt","Auto");
				TNT1 A 0 A_TakeInventory("BallistaAmmo",1);
				TNT1 A 0 A_FireCustomMissile("BallistaBolt", 0, 0, 0, -1, 0, 0);
				CRBW F 1;
				CRBW G 1;
				CRBW H 0 A_SetPitch(-1.5 + pitch);
				CRBW I 0 A_ZoomFactor(1.00);
				CRBW J 1 A_SetPitch(+1.0 + pitch);
				CRBW JJ 1 A_SetPitch(+1.0 + pitch);
				CRBW J 1 A_SetPitch(+0.5 + pitch);
				CRBW J 2 A_WeaponReady(WRF_NOFIRE| WRF_NOBOB)//Allows quick switch;
				Goto ReadyEmpty;
		FireDemonic:
				TNT1 A 0 A_TakeInventory("BallistaAmmo",1);
				TNT1 A 0 A_FireCustomMissile("DemonicBolt", 0, 0, 0, -1, 0, 0);
				CRBW K 1 BRIGHT A_PlaySoundEx("weapons/ballista/firedemonic","Auto");
				CRBW G 1 BRIGHT;
				CRBW H 0 A_SetPitch(-3.5 + pitch);
				CRBW I 0 A_ZoomFactor(1.00);
				CRBW J 1 A_SetPitch(+1.0 + pitch);
				CRBW JJ 1 A_SetPitch(+1.0 + pitch);
				CRBW J 1 A_SetPitch(+0.5 + pitch);
				CRBW J 2 A_WeaponReady(WRF_NOFIRE| WRF_NOBOB)//Allows quick switch;
				Goto ReadyEmpty;
		WeaponSpecial:
				TNT1 A 0 PB_CheckBarrelIdle1();
				TNT1 A 0 {
					A_GiveInventory("PB_LockScreenTilt",1);
					A_Takeinventory("GoWeaponSpecialAbility",1);
					A_Takeinventory("SwapToDemonicMode",1);
					A_ZoomFactor(1.0);
					A_ClearOverlays(10,11);
				TNT1 A 0 A_JumpIfInventory ("BallistaUpgraded",1,2);
				TNT1 A 0 A_Print("\coNeed \c-the \ctballista \c-module");
				Goto Ready3;
				TNT1 A 0 A_JumpIfInventory ("BallistaDemonicMode",1,"WeaponSpecialDemonic");
				TNT1 A 0 A_JumpIfInventory ("PB_DTech",3,1);
				Goto Ready3;
				TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
				CBOR NMLKJI 1 A_SetRoll(roll-.4, SPF_INTERPOLATE);
				TNT1 A 0 A_PlaySoundEx("weapons/ballista/boltout","Auto");
				TNT1 A 0 A_GiveInventory("PB_HighCalMag",1);
				CBOR H 1 A_SetRoll(roll+.3, SPF_INTERPOLATE);
				CBOR GF 1 A_SetRoll(roll-.3, SPF_INTERPOLATE);
				TNT1 A 0 A_PlaySoundEx("Ironsights","Auto");
				CBOR EDCBA 1;
				CBWR P 5 A_SetInventory("BallistaDemonicMode",1);
				TNT1 A 0 A_PlaySoundEx("weapons/ballista/boltinoutdemonic","Auto");
				TNT1 A 0 A_TakeInventory("PB_DTech",3);
				CBOR OPQ 1 A_SetRoll(roll+.3, SPF_INTERPOLATE);
				CBOR RST 1 A_SetRoll(roll-.3, SPF_INTERPOLATE);
				CBOR UU 1;
				CBOR UU 1 A_SetRoll(roll+.4, SPF_INTERPOLATE);
				TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
				CBOR VWXY 1 A_SetRoll(roll+.4, SPF_INTERPOLATE);
				Goto Ready3;
		WeaponSpecialDemonic:
				TNT1 A 0 A_JumpIfInventory ("PB_HighCalMag",1,1);
				Goto Ready3;
				TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
				CBOR YXWVU 1 A_SetRoll(roll-.4, SPF_INTERPOLATE);
				TNT1 A 0 A_PlaySoundEx("weapons/ballista/boltinoutdemonic","Auto");
				TNT1 A 0 A_GiveInventory("PB_DTech",3);
				CBOR T 1 A_SetRoll(roll-.4, SPF_INTERPOLATE);
				CBOR SRQPO 1;
				CBWR P 5 A_SetInventory("BallistaDemonicMode",0);
				CBOR AB 1;
				TNT1 A 0 A_PlaySoundEx("weapons/ballista/boltin","Auto");
				TNT1 A 0 A_TakeInventory("PB_HighCalMag",1);
				CBOR CDE 1;
				CBOR FG 1 A_SetRoll(roll-.3, SPF_INTERPOLATE);
				CBOR H 1 A_SetRoll(roll+.3, SPF_INTERPOLATE);
				CBOR IJ 1 A_SetRoll(roll+.4, SPF_INTERPOLATE);
				TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
				CBOR KLMN 1 A_SetRoll(roll+.4, SPF_INTERPOLATE);
				Goto Ready3;


		AltFire:
				TNT1 A 0 A_JumpIfInventory ("GrabbedBarrel", 1, "PlaceBarrel");
				TNT1 A 0 A_JumpIfInventory ("GrabbedBurningBarrel", 1, "PlaceFlameBarrel");
				TNT1 A 0 A_JumpIfInventory ("GrabbedIceBarrel", 1, "PlaceIceBarrel");
				TNT1 A 0 {
					A_WeaponOffset(0,32);
					A_SetRoll(0);
					A_TakeInventory("PB_LockScreenTilt",1);
				TNT1 A 0 {
					if(CountInv("GoFatality") >= 1) { SetPlayerProperty(0,1,0); }
					else { SetPlayerProperty(0,0,0); SetPlayerProperty(0,0,PROP_TOTALLYFROZEN); }
				TNT1 A 0 A_JumpIfInventory("GoFatality",1,"Steady");
				TNT1 A 0 A_JumpIfInventory("BallistaAmmo",1,1);
				Goto ReadyEmpty;
				TNT1 A 0;
				TNT1 A 0 {
					if(CountInv("NoFatality") == 0 && GetCVar ("pb_auto_fatality_fire") == 1) {
						return PB_Execute();
					return state("");
				TNT1 A 0 A_JumpIfInventory("BallistaDemonicMode",1,"AltFireDemonic");
				TNT1 A 0 A_JumpIfInventory ("PB_RocketAmmo",1,2);
				TNT1 A 0 A_Print("\cgNeed \ciexplosive \c-rounds");
				Goto Ready3;
				TNT1 A 0 A_ZoomFactor(0.98);
				TNT1 A 0 A_PlaySoundEx("weapons/ballista/firebolt","Auto");
				TNT1 A 0 A_TakeInventory("BallistaAmmo",1);
				TNT1 A 0 A_FireCustomMissile("ExplosiveBolt", 0, 0, 0, -1, 0, 0);
				TNT1 A 0 A_TakeInventory("PB_RocketAmmo",1);
				CRBW F 1;
				CRBW G 1;
				CRBW H 0 A_SetPitch(-1.5 + pitch);
				CRBW I 0 A_ZoomFactor(1.00);
				CRBW J 1 A_SetPitch(+1.0 + pitch);
				CRBW JJ 1 A_SetPitch(+1.0 + pitch);
				CRBW J 1 A_SetPitch(+0.5 + pitch);
				CRBW J 2 A_WeaponReady(WRF_NOFIRE| WRF_NOBOB)//Allows quick switch;
				Goto ReadyEmpty;
		AltFireDemonic:
				TNT1 A 0 A_JumpIfInventory ("PB_Fuel",5,2);
				TNT1 A 0 A_Print("\cgNeed \cyfuel \c-ammo");
				Goto Ready3;
				TNT1 A 0 A_ZoomFactor(0.98);
				TNT1 A 0 A_TakeInventory("BallistaAmmo",1);
				TNT1 A 0 A_FireCustomMissile("ProSurvRazorBlade", 0, 0, 0, -1, 0, 0);
				TNT1 A 0 A_TakeInventory("PB_Fuel",5);
				CBOW U 1 BRIGHT A_PlaySoundEx("weapons/ballista/firerazor","Auto");
				CRBW G 1 BRIGHT;
				CRBW H 0 A_SetPitch(-3.5 + pitch);
				CRBW I 0 A_ZoomFactor(1.00);
				CRBW J 1 A_SetPitch(+1.0 + pitch);
				CRBW JJ 1 A_SetPitch(+1.0 + pitch);
				CRBW J 1 A_SetPitch(+0.5 + pitch);
				CRBW J 2 A_WeaponReady(WRF_NOFIRE| WRF_NOBOB)//Allows quick switch;
				Goto ReadyEmpty;
		Reload:
			TNT1 A 0 PB_CheckBarrelIdle1();
			TNT1 A 0 A_JumpIfInventory ("BallistaAmmo", 1, "Ready3");
				TNT1 A 0 {
					A_SetCrosshair(5);
					A_ZoomFactor(1.0);
					A_Giveinventory("PB_LockScreenTilt",1);
				TNT1 A 0 A_JumpIfInventory("BallistaDemonicMode",1,"ReloadStartDemonic");
		ReloadStart:
				TNT1 A 0 A_JumpIfInventory("PB_HighCalMag",1,1);
				Goto SwapCheckerDemonic;
				TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
				CBWR ABCDEF 1 A_SetRoll(roll-.4, SPF_INTERPOLATE);
				CBWR GGGGGGGGG 1;
				TNT1 A 0 A_PlaySoundEx("Ironsights","Auto");
				CBWR HIJKKKKKKK 1;
				TNT1 A 0 A_PlaySoundEx("weapons/ballista/drawstring","Auto");
				CBWR LMNOPPPPP 1;
				TNT1 A 0;
				TNT1 A 0 {
					A_SetInventory("BallistaAmmo",1);
					A_SetInventory("BallistaDemonicMode",0);
					A_TakeInventory("PB_HighCalMag",1);
					A_PlaySoundEx("Ironsights","Auto");
				CBOR AB 1;
				TNT1 A 0 A_PlaySoundEx("weapons/ballista/boltin","Auto");
				CBOR CDE 1;
				CBOR FG 1 A_SetRoll(roll-.3, SPF_INTERPOLATE);
				CBOR H 1 A_SetRoll(roll+.3, SPF_INTERPOLATE);
				CBOR IJ 1 A_SetRoll(roll+.4, SPF_INTERPOLATE);
				TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
				CBOR KLMN 1 A_SetRoll(roll+.4, SPF_INTERPOLATE);
				Goto Ready3;
		ReloadStartDemonic:
				TNT1 A 0 A_JumpIfInventory("PB_DTech",3,1);
				Goto SwapChecker;
				TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
				CBWR ABCDEF 1 A_SetRoll(roll-.4, SPF_INTERPOLATE);
				CBWR GGGGGGGGG 1;
				TNT1 A 0 A_PlaySoundEx("Ironsights","Auto");
				CBWR HIJKKKKKKKKKK 1;
				TNT1 A 0 A_PlaySoundEx("weapons/ballista/drawstring","Auto");
				CBWR LMNOPPPPP 1;
				TNT1 A 0;
				TNT1 A 0 {
					A_SetInventory("BallistaAmmo",1);
					A_SetInventory("BallistaDemonicMode",1);
					A_TakeInventory("PB_DTech",3);
					A_PlaySoundEx("weapons/ballista/boltinoutdemonic","Auto");
				CBOR OPQ 1 A_SetRoll(roll+.3, SPF_INTERPOLATE);
				CBOR RST 1 A_SetRoll(roll-.3, SPF_INTERPOLATE);
				CBOR UU 1;
				CBOR UU 1 A_SetRoll(roll+.4, SPF_INTERPOLATE);
				TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
				CBOR VWXY 1 A_SetRoll(roll+.4, SPF_INTERPOLATE);
				Goto Ready3;
		SwapChecker:
				TNT1 A 0 A_JumpIfInventory("PB_HighCalMag",1,"ReloadStart");
				Goto Ready3;
		SwapCheckerDemonic:
				TNT1 A 0 { 
					if (CountInv("PB_DTech") >= 5 && CountInv("BallistaUpgraded") == 1){ return state("ReloadStartDemonic");}
					return state ("");
				Goto ReadyEmpty;
		Steady:
				TNT1 A 1;
				TNT1 A 0 A_JumpIfInventory("GoFatality",1,"Steady");
				TNT1 A 0 SetPlayerProperty(0,0,0);
				TNT1 A 0 SetPlayerProperty(0,0,PROP_TOTALLYFROZEN);
				Goto Ready3;
		Unload:
				TNT1 A 0 A_TakeInventory("Unloading", 1);
	}
}
