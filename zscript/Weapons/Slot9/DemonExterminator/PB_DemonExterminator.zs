// Demon Exterminator — Weapons Pack DemonicExt alignment (Laser / Incineration / Lightning).
// Mode 2 uses UNMS/UNMD F–J and UNMI I/J/K strips (pack "SelectSoul" labels = lightning body art).

const DEX_MODE_LASER = 0;
const DEX_MODE_INCIN = 1;
const DEX_MODE_LIGHTNING = 2;

class PB_DemonExterminator : PB_WeaponBase
{
	default
	{
		Weapon.SlotNumber 9;
		Weapon.SlotPriority 0.2;
		Weapon.AmmoType1 "PB_DTech";
		Weapon.AmmoUse1 0;
		Weapon.AmmoGive1 200;
		+WEAPON.NOAUTOFIRE;
		Scale 0.8;
		Tag "$PB_TAG_PB_DemonExterminator";
		Inventory.Icon "UNMXA0";
		Inventory.AltHUDIcon "UNMXA0";
		Inventory.PickupMessage "$PB_PICKUP_PB_DemonExterminator";
		Inventory.PickupSound "UNMPCK";
		Obituary "%o was exterminated by %k";
		PB_WeaponBase.RespectItem "DExRespect";
	}

	const chan_unmkidle = 6;
	const primammo_laser = 4;
	const primammo_incin = 6;
	const primammo_lightning = 12;
	const secammo_laser = 12;
	const secammo_incin = 20;
	const secammo_lightning = 30;

	int ExterminatorMode;
	bool ExterminatorWeaponSpecial;

	states
	{
	Spawn:
		UNMX A -1 BRIGHT;
		Stop;

	Steady:
		TNT1 A 1;
		TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
		TNT1 A 0 SetPlayerProperty(0, 0, 0);
		TNT1 A 0 SetPlayerProperty(0, 0, PROP_TOTALLYFROZEN);
		Goto Ready;

	Select:
		TNT1 A 0
		{
			A_WeaponOffset(0, 32);
			PB_HandleCrosshair(26);
			if (CountInv("DEx_Cur0") < 1 && CountInv("DEx_Cur1") < 1 && CountInv("DEx_Cur2") < 1)
				A_GiveInventory("DEx_Cur0", 1);
			invoker.DEUM_SyncModeFromInventory();
		}
		TNT1 A 0 A_TakeInventory("PB_LockScreenTilt", 1);
		TNT1 A 0 A_TakeInventory("HasBarrel", 1);
		TNT1 A 0 A_TakeInventory("HasIceBarrel", 1);
		TNT1 A 0 A_TakeInventory("HasBurningBarrel", 1);
		TNT1 A 0 A_TakeInventory("GrabbedBarrel", 1);
		TNT1 A 0 A_TakeInventory("GrabbedIceBarrel", 1);
		TNT1 A 0 A_TakeInventory("GrabbedBurningBarrel", 1);
		Goto SelectFirstPersonLegs;

	SelectContinue:
		TNT1 A 0
		{
			A_WeaponOffset(0, 32);
			PB_WeapTokenSwitch("DemonExSelected");
			invoker.DEUM_SyncModeFromInventory();
		}
	SelectAnimation:
		TNT1 A 0 A_StartSound("UNMAKSEL", CHAN_WEAPON);
		TNT1 A 0 A_JumpIf(invoker.ExterminatorMode == DEX_MODE_LIGHTNING, "SelectLightning");
		UNMS ABCDE 1;
		Goto Ready3;

	SelectLightning:
		UNMS FGHIJ 1;
		Goto Ready3;

	Deselect:
		TNT1 A 0 A_StopSound(chan_unmkidle);
		TNT1 A 0 A_StopSound(CHAN_WEAPON);
		TNT1 A 0 A_TakeInventory("Zoomed", 1);
		TNT1 A 0 PB_CheckBarrelPlace1();
		TNT1 A 0 A_JumpIf(invoker.ExterminatorMode == DEX_MODE_LIGHTNING, "DeselectLightning");
		UNMD ABCDE 1;
		TNT1 A 0 A_StopSound(1);
		TNT1 A 0 A_StopSound(2);
		TNT1 A 0 A_StopSound(3);
		TNT1 A 0 A_Lower(120);
		Wait;

	DeselectLightning:
		UNMD FGHIJ 1;
		TNT1 A 0 A_StopSound(1);
		TNT1 A 0 A_StopSound(2);
		TNT1 A 0 A_StopSound(3);
		TNT1 A 0 A_Lower(120);
		Wait;

	Ready:
		TNT1 A 0 A_JumpIfInventory("MastermindChaingun", 1, "ChooseUpgradePath");
		TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
		TNT1 A 0 PB_RespectIfNeeded;

	WeaponRespect:
		UNMD EDCBA 1;
		UNMI AAAAAAAAAAAAAAA 1;
		TNT1 A 0 A_StartSound("UNOCFIR", 1);
		UNMI AAAA 1;
		TNT1 A 0 A_Overlay(66, "LightningFlash");
		UNMI AAAA 1;
		TNT1 A 0 A_Overlay(67, "LightningFlash");
		UNMI AAAA 1;
		TNT1 A 0 A_Overlay(68, "LightningFlash");
		UNMI AAAA 1;
		TNT1 A 0 A_Overlay(65, "LightningFlash");
		UNMI AAAA 1;
		TNT1 A 0 A_Overlay(66, "LightningFlash");
		UNMI AAAA 1;
		TNT1 A 0 A_Overlay(67, "LightningFlash");
		UNMI AAAA 1;
		TNT1 A 0 A_Overlay(68, "LightningFlash");
		UNMI AAAA 1;
		Goto Ready3;

	Ready3:
		TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
		TNT1 A 0 { invoker.DEUM_SyncModeFromInventory(); }
		TNT1 A 0 A_JumpIfInventory("GoWeaponSpecialAbility", 1, "WeaponSpecial");
		TNT1 A 0 A_JumpIfInventory("PB_DTech", 1, "ReadyHasDtech");
		TNT1 A 0 A_StopSound(chan_unmkidle);
	ReadyNoDtech:
		TNT1 A 0 A_JumpIf(invoker.ExterminatorMode == DEX_MODE_LIGHTNING, "Ready.Lightning");
		UNMI H 1 UNM_WeaponReady();
		Loop;

	ReadyHasDtech:
		TNT1 A 0 A_StartSound("unmaker/hum", chan_unmkidle, CHANF_LOOPING | CHANF_UI);
		UNMI AAAAAAAAAAAAAAABBBCCCDDDEEEFFFFFFFFFFFFFFFFFFEEEDDDCCCBBBAAA 1
		{
			if (invoker.ExterminatorMode == DEX_MODE_LIGHTNING)
				return ResolveState("Ready.Lightning");
			return UNM_WeaponReady();
		}
		Loop;

	Ready.Lightning:
		UNMI IIIIIIJJJJKKKKJJJJIIIIIIIIIIIIJJJJKKKKJJJJIIIIII 1
		{
			if (invoker.ExterminatorMode != DEX_MODE_LIGHTNING)
				return ResolveState("Ready3");
			return UNM_WeaponReady();
		}
		Goto Ready3;

	ChooseUpgradePath:
		TNT1 A 0 A_PrintBold("\cfChoose your path:\n\caFIRE = CACOTROLL 1\n\ciALTFIRE = CACOTROLL 2");
		TNT1 A 1;
		TNT1 A 1;
	ChooseUpgradePathLoop:
		TNT1 A 0 A_JumpIf(JustPressed(BT_ATTACK), "KeepDemonExPath");
		TNT1 A 0 A_JumpIf(JustPressed(BT_ALTATTACK), "KeepMastermindPath");
		TNT1 A 1;
		TNT1 A 0 A_Jump(256, "ChooseUpgradePathLoop");
	KeepDemonExPath:
		TNT1 A 0 A_TakeInventory("MastermindChaingun", 1);
		TNT1 A 0 A_PrintBold("\caPath selected: CACOTROLL 1");
		Goto Ready3;
	KeepMastermindPath:
		TNT1 A 0 A_TakeInventory("PB_DemonExterminator", 1);
		TNT1 A 0 A_PrintBold("\ciPath selected: CACOTROLL 2");
		TNT1 A 0 A_SelectWeapon("MastermindChaingun");
		Stop;

	WeaponSpecial:
		TNT1 A 0 A_JumpIfInventory("Select_PB_DemonEx_Laser", 1, "WSpecLaser");
		TNT1 A 0 A_JumpIfInventory("Select_PB_DemonEx_Incin", 1, "WSpecIncin");
		TNT1 A 0 A_JumpIfInventory("Select_PB_DemonEx_Lightning", 1, "WSpecLightning");
		Goto Ready3;

	WSpecLaser:
		TNT1 A 0
		{
			A_TakeInventory("Select_PB_DemonEx_Laser", 1);
			A_TakeInventory("Select_PB_DemonEx_Incin", 1);
			A_TakeInventory("Select_PB_DemonEx_Lightning", 1);
			invoker.DEUM_SetMode(DEX_MODE_LASER);
			A_StartSound("unmaker/switch", CHAN_WEAPON);
		}
		Goto WeaponSpecialLayer;

	WSpecIncin:
		TNT1 A 0
		{
			A_TakeInventory("Select_PB_DemonEx_Laser", 1);
			A_TakeInventory("Select_PB_DemonEx_Incin", 1);
			A_TakeInventory("Select_PB_DemonEx_Lightning", 1);
			invoker.DEUM_SetMode(DEX_MODE_INCIN);
			A_StartSound("unmaker/switch", CHAN_WEAPON);
		}
		Goto WeaponSpecialLayer;

	WSpecLightning:
		TNT1 A 0
		{
			A_TakeInventory("Select_PB_DemonEx_Laser", 1);
			A_TakeInventory("Select_PB_DemonEx_Incin", 1);
			A_TakeInventory("Select_PB_DemonEx_Lightning", 1);
			invoker.DEUM_SetMode(DEX_MODE_LIGHTNING);
			A_StartSound("unmaker/switch", CHAN_WEAPON);
		}
		Goto WeaponSpecialLayer;

	WeaponSpecialLayer:
		TNT1 A 1
		{
			A_WeaponOffset(0, 32);
			A_StartSound("UNMSWTC", CHAN_UI);
			invoker.ExterminatorWeaponSpecial = true;
		}
		TNT1 AAAAAAAAA 1 A_WeaponOffset(-2, 2, WOF_ADD);
		TNT1 A 3;
		TNT1 AA 1 A_WeaponOffset(-6, 6, WOF_ADD);
		TNT1 A 2;
		TNT1 AAAAAAAAAAAAAAA 1 A_WeaponOffset(2, -2, WOF_ADD);
		TNT1 A 1 A_WeaponOffset(0, 32);
		TNT1 A 0 { invoker.ExterminatorWeaponSpecial = false; }
		Goto ModeSwitchRedraw;

	ModeSwitchRedraw:
		TNT1 A 0 { invoker.DEUM_SyncModeFromInventory(); }
		TNT1 A 0 A_JumpIf(invoker.ExterminatorMode == DEX_MODE_LIGHTNING, "ModeSwitchRedraw.Lightning");
		UNMS ABCDE 1;
		Goto Ready3;
	ModeSwitchRedraw.Lightning:
		UNMS FGHIJ 1;
		Goto Ready3;

	Reload:
		TNT1 A 0;
		Goto Ready3;

	Unload:
		TNT1 A 0;
		Goto Ready3;

		Fire:
		TNT1 A 0
		{
			if (CountInv("GoFatality") >= 1)
				SetPlayerProperty(0, 1, 0);
			else
			{
				SetPlayerProperty(0, 0, 0);
				SetPlayerProperty(0, 0, PROP_TOTALLYFROZEN);
			}
			invoker.DEUM_SyncModeFromInventory();
		}
		TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
		TNT1 A 0 PB_TryAutoFatalityOnFire();
		TNT1 A 0 PB_DemonEx_BarrelThrowGate();
		TNT1 A 0 A_JumpIf(invoker.ExterminatorMode == DEX_MODE_INCIN, "Fire.Incineration");
		TNT1 A 0 A_JumpIf(invoker.ExterminatorMode == DEX_MODE_LIGHTNING, "Fire.Lightning");
	Fire.Laser:
		TNT1 A 0 A_JumpIfInventory("PB_DTech", primammo_laser, "Fire.LaserOK");
		TNT1 A 0 A_PlaySound("weapons/empty", CHAN_WEAPON);
		Goto Ready3;
	Fire.LaserOK:
		TNT1 A 0 A_Overlay(-64, "MuzzleFlash2");
		TNT1 A 0 A_StartSound("unmaker/laser", CHAN_WEAPON);
		TNT1 A 0 A_TakeInventory("PB_DTech", primammo_laser);
		UNMF A 1 BRIGHT
		{
			UNM_FireLasers();
			PB_FireOffset();
			PB_WeaponRecoil(-0.32, frandom(-0.25, 0.25));
		}
		UNMF DE 1 BRIGHT A_WeaponOffset(0, 32);
		TNT1 A 0 A_JumpIf(Player.ReFire % 2 == 1, 4);
		UNMF MO 1 BRIGHT;
		TNT1 A 0 A_Jump(256, 3);
		UNMF LN 1 BRIGHT;
		UNMI AAAAAA 1 BRIGHT
		{
			PB_GunSmoke(random(-1, 1), random(-1, 1), random(1, 5));
		}
		TNT1 A 0 A_Refire("Fire");
		TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
		Goto Ready3;

	Fire.Incineration:
		TNT1 A 0 A_JumpIfInventory("PB_DTech", primammo_incin, "Fire.IncinerationOK");
		TNT1 A 0 A_PlaySound("weapons/empty", CHAN_WEAPON);
		Goto Ready3;
	Fire.IncinerationOK:
		TNT1 A 0 A_Overlay(-64, "MuzzleFlash0");
		TNT1 A 0 A_StartSound("unmaker/fire", CHAN_WEAPON);
		TNT1 A 0 A_TakeInventory("PB_DTech", primammo_incin);
		UNMF A 1 BRIGHT
		{
			UNM_FireBeams();
			UNM_Add_level();
			PB_FireOffset();
			PB_WeaponRecoil(-0.32, frandom(-0.25, 0.25));
		}
		UNMF BC 1 BRIGHT A_WeaponOffset(0, 35);
		UNMF MNO 1 BRIGHT A_WeaponOffset(0, -1, WOF_ADD);
		TNT1 A 0 A_Refire("Fire");
		UNMI AAAAAA 1 BRIGHT
		{
			PB_GunSmoke(random(-1, 1), random(-1, 1), random(1, 5));
		}
		TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
		Goto Ready3;

	Fire.Lightning:
		TNT1 A 0 A_JumpIfInventory("PB_DTech", primammo_lightning, "Fire.LightningOK");
		TNT1 A 0 A_PlaySound("weapons/empty", CHAN_WEAPON);
		Goto Ready3;
	Fire.LightningOK:
		UNMI K 3 BRIGHT
		{
			A_WeaponOffset(0, 32);
			A_Overlay(65, "OverchargeFlash");
		}
		TNT1 AAAA 0 A_PlaySound("DSREAFI1", CHAN_AUTO);
		UNMI K 21 BRIGHT A_WeaponOffset(0, 32);
		UNMI K 1 BRIGHT
		{
			A_FireCustomMissile("UnmakerDoomSeeker", 0, 0, 0, 0, 0, 0);
			PB_FireOffset();
			PB_WeaponRecoil(-4.25, frandom(-1.7, 1.7));
		}
		TNT1 A 0 A_TakeInventory("PB_DTech", primammo_lightning);
		UNMI JI 1 BRIGHT A_WeaponOffset(0, 36);
		UNMI IIII 1 BRIGHT A_WeaponOffset(0, -1, WOF_ADD);
		UNMI IJKJIJKJIJKJIJKJIJKJ 1 PB_GunSmoke(random(-1, 1), random(-1, 1), random(1, 5));
		TNT1 A 0 A_Refire("Fire");
		TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
		Goto Ready3;

	AltFire:
		TNT1 A 0
		{
			if (CountInv("GoFatality") >= 1)
				SetPlayerProperty(0, 1, 0);
			else
			{
				SetPlayerProperty(0, 0, 0);
				SetPlayerProperty(0, 0, PROP_TOTALLYFROZEN);
			}
			invoker.DEUM_SyncModeFromInventory();
		}
		TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
		TNT1 A 0 PB_DemonEx_BarrelPlaceGate();
		TNT1 A 0 A_JumpIf(invoker.ExterminatorMode == DEX_MODE_INCIN, "AltFire.Incineration");
		TNT1 A 0 A_JumpIf(invoker.ExterminatorMode == DEX_MODE_LIGHTNING, "AltFire.Lightning");
	AltFire.Laser:
		TNT1 A 0 A_JumpIfInventory("PB_DTech", secammo_laser, "AltFire.LaserOK");
		TNT1 A 0 A_PlaySound("weapons/empty", CHAN_WEAPON);
		Goto Ready3;
	AltFire.LaserOK:
		TNT1 A 0 { A_WeaponOffset(0, 32); A_PlaySound("RCHARGE", CHAN_ITEM); }
		UNMI "F" 0 BRIGHT;
		UNMI H 1 BRIGHT A_WeaponOffset(0, 33);
		UNMI H 1 BRIGHT A_WeaponOffset(1, 34);
		UNMI H 1 BRIGHT A_WeaponOffset(0, 35);
		UNMF G 1 BRIGHT A_WeaponOffset(-1, 34);
		UNMF A 1 BRIGHT A_WeaponOffset(0, 33);
		UNMF A 1 BRIGHT A_WeaponOffset(1, 34);
		UNMF G 1 BRIGHT A_WeaponOffset(0, 35);
		UNMF G 1 BRIGHT A_WeaponOffset(-1, 34);
		UNMF H 1 BRIGHT A_WeaponOffset(0, 33);
		UNMF I 1 BRIGHT A_WeaponOffset(1, 34);
		UNMF J 1 BRIGHT A_WeaponOffset(0, 35);
		UNMF K 1 BRIGHT A_WeaponOffset(0, 32);
	AltHold.Laser:
		TNT1 A 0 A_JumpIfInventory("PB_DTech", secammo_laser, "AltHold.LaserFire");
		Goto Ready3;
	AltHold.LaserFire:
		UNMF A 2 BRIGHT
		{
			A_Overlay(-64, "MuzzleFlash3");
			A_WeaponOffset(0, 32);
			A_TakeInventory("PB_DTech", secammo_laser);
			A_FireCustomMissile("Plasma_Ball", 0, 0, 0, -3);
			A_AlertMonsters();
			A_PlaySound("RBLAST", CHAN_WEAPON);
			PB_WeaponRecoil(-1.0, frandom(-1.0, 1.0));
		}
		UNMF "BCLMNO" 1 BRIGHT;
		TNT1 A 0 A_Refire("AltHold.Laser");
		UNMI AA 2 PB_GunSmoke(random(-1, 1), random(-1, 1), random(1, 5));
		TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
		Goto Ready3;

	AltFire.Incineration:
		TNT1 A 0 A_JumpIfInventory("PB_DTech", secammo_incin, "AltFire.IncinerationOK");
		TNT1 A 0 A_PlaySound("weapons/empty", CHAN_WEAPON);
		Goto Ready3;
	AltFire.IncinerationOK:
		TNT1 A 0 A_Overlay(65, "LightningFlash");
		TNT1 A 0 A_StartSound("UNOCFIR", 1);
		TNT1 A 0 A_StartSound("UNMSTA", 3);
		UNMI HHHH 1 A_WeaponOffset(0 + random(-1, 1), 32 + random(1, 3));
		TNT1 A 0 A_Overlay(66, "LightningFlash");
		UNMI HHHH 1 A_WeaponOffset(0 + random(-3, 3), 32 + random(1, 4));
		TNT1 A 0 A_Overlay(67, "LightningFlash");
		UNMI HHHH 1 A_WeaponOffset(0 + random(-1, 1), 32 + random(1, 3));
		TNT1 A 0 A_Overlay(68, "LightningFlash");
		UNMI HHHH 1 A_WeaponOffset(0 + random(-3, 3), 32 + random(1, 4));
		TNT1 A 0 A_Overlay(65, "LightningFlash");
		UNMI HHHH 1 A_WeaponOffset(0 + random(-1, 1), 32 + random(1, 3));
		TNT1 A 0 A_Overlay(66, "LightningFlash");
		UNMI HHHH 1 A_WeaponOffset(0 + random(-3, 3), 32 + random(1, 4));
		TNT1 A 0 A_WeaponOffset(0, 32);
		TNT1 A 0 A_Overlay(-64, "MuzzleFlash1");
		TNT1 A 0 A_StartSound("unmaker/fire", CHAN_WEAPON);
		TNT1 A 0 A_TakeInventory("PB_DTech", secammo_incin);
		UNMF A 1 BRIGHT A_FireCustomMissile("BigFireBallWithGravity", 0, 0, 0, 0, 0, 0);
		TNT1 A 0 PB_FireOffset();
		TNT1 A 0 PB_WeaponRecoil(-4.25, frandom(-1.7, 1.7));
		UNMF BC 1 BRIGHT;
		TNT1 A 0 A_WeaponOffset(0, 36);
		UNMF LMNO 1 BRIGHT A_WeaponOffset(0, -1, WOF_ADD);
		UNMI "ABCDEFEDCBAABCDEFEDC" 1 PB_GunSmoke(random(-1, 1), random(-1, 1), random(1, 5));
		TNT1 A 0 A_Refire("AltFire");
		TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
		Goto Ready3;

	AltFire.Lightning:
		TNT1 A 0 A_JumpIfInventory("PB_DTech", secammo_lightning, "AltFire.LightningOK");
		TNT1 A 0 A_PlaySound("weapons/empty", CHAN_WEAPON);
		Goto Ready3;
	AltFire.LightningOK:
		TNT1 A 0 A_WeaponOffset(0, 32);
		UNMI "F" 0 BRIGHT;
		UNMI K 1 BRIGHT
		{
			A_WeaponOffset(0, 33);
			A_Overlay(65, "OverchargeFlash");
		}
		UNMI K 1 BRIGHT A_WeaponOffset(1, 34);
		UNMI K 1 BRIGHT A_WeaponOffset(0, 35);
		TNT1 AAAA 0 A_PlaySound("DSREAFI3", CHAN_AUTO);
		UNMI K 1 BRIGHT A_WeaponOffset(-1, 34);
		UNMI K 1 BRIGHT A_WeaponOffset(0, 33);
		UNMI K 1 BRIGHT A_WeaponOffset(1, 34);
		UNMI K 1 BRIGHT A_WeaponOffset(0, 35);
		UNMI K 1 BRIGHT A_WeaponOffset(-1, 34);
		UNMI K 1 BRIGHT A_WeaponOffset(0, 33);
		UNMI K 1 BRIGHT A_WeaponOffset(1, 34);
		UNMI K 1 BRIGHT A_WeaponOffset(0, 35);
		UNMI K 1 BRIGHT A_WeaponOffset(-1, 34);
		TNT1 A 0 A_Overlay(-64, "MuzzleFlash3");
		TNT1 AAAA 0 A_StartSound("unmaker/thunder", CHAN_AUTO);
		TNT1 A 0 A_SetBlend("FFFFFF", 0.9, 12, "FF0000");
		UNMI K 1 BRIGHT
		{
			UNM_FireStorm();
			PB_FireOffset();
			PB_WeaponRecoil(-4.25, frandom(-1.7, 1.7));
		}
		TNT1 A 0 A_TakeInventory("PB_DTech", secammo_lightning);
		UNMI KK 1 BRIGHT;
		TNT1 A 0 A_WeaponOffset(0, 36);
		UNMI JJII 1 BRIGHT A_WeaponOffset(0, -1, WOF_ADD);
		UNMI IJKJIJKJIJKJIJKJIJKJ 1 PB_GunSmoke(random(-1, 1), random(-1, 1), random(1, 5));
		TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
		Goto Ready3;

	FlashPunching:
		TNT1 A 0 A_StopSound(chan_unmkidle);
		TNT1 A 0 A_ClearOverlays(10, 11);
		UNMD ABCDEEEEEEDCBA 1;
		TNT1 A 0 A_ClearOverlays(PSP_FLASH, PSP_FLASH, false);
		Stop;

	FlashKicking:
		TNT1 A 0 A_ClearOverlays(10, 11);
		UNMD ABCDEEEEEEEDCBA 1;
		Goto Ready3;

	FlashAirKicking:
		TNT1 A 0 A_ClearOverlays(10, 11);
		UNMD ABCDEEEEEEEEDCBA 1;
		Goto Ready3;

	FlashSlideKicking:
		TNT1 A 0 A_ClearOverlays(10, 11);
		UNMD ABCDEEEEEEEEEEEEEEEEEEEDCBA 1;
		Goto Ready3;

	FlashSlideKickingStop:
		TNT1 A 0 A_ClearOverlays(10, 11);
		UNMD EEEDCBA 1;
		Goto Ready3;

		MuzzleFlash0:
		TNT1 A 0
		{
			A_OverlayFlags(overlayid(), PSPF_FLIP | PSPF_MIRROR, random(0, 1));
			A_OverlayPivotAlign(overlayid(), PSPA_CENTER, PSPA_CENTER);
			A_OverlayScale(overlayid(), frandom(1.0, 1.4));
		}
		Goto MuzzleFlash.Incineration;

		MuzzleFlash1:
		TNT1 A 0
		{
			A_OverlayFlags(overlayid(), PSPF_FLIP | PSPF_MIRROR, random(0, 1));
			A_OverlayPivotAlign(overlayid(), PSPA_CENTER, PSPA_CENTER);
			A_OverlayScale(overlayid(), frandom(1.4, 2.25));
		}
		Goto MuzzleFlash.Incineration;

		MuzzleFlash2:
		TNT1 A 0
		{
			A_OverlayFlags(overlayid(), PSPF_FLIP | PSPF_MIRROR, random(0, 1));
			A_OverlayPivotAlign(overlayid(), PSPA_CENTER, PSPA_CENTER);
			A_OverlayScale(overlayid(), frandom(1.0, 1.4));
		}
		TNT1 A 0 A_Jump(256, "CMuzzle1", "CMuzzle2", "CMuzzle3", "CMuzzle4", "CMuzzle5", "CMuzzle6");

		MuzzleFlash3:
		TNT1 A 0
		{
			A_OverlayFlags(overlayid(), PSPF_FLIP | PSPF_MIRROR, random(0, 1));
			A_OverlayPivotAlign(overlayid(), PSPA_CENTER, PSPA_CENTER);
			A_OverlayScale(overlayid(), frandom(1.4, 2.25));
		}
		TNT1 A 0 A_Jump(256, "CMuzzle1", "CMuzzle2", "CMuzzle3", "CMuzzle4", "CMuzzle5", "CMuzzle6");

		MuzzleFlash.Incineration:
		D3T2 A 1 BRIGHT
		{
			int f = randompick(0, 3, 6);
			UNM_ChangePSFrame(f, overlayid());
		}
		D3T2 B 1 BRIGHT
		{
			int fm = randompick(1, 4, 7);
			UNM_ChangePSFrame(fm, overlayid());
		}
		D3T2 C 1 BRIGHT
		{
			int fme = randompick(2, 5, 8);
			UNM_ChangePSFrame(fme, overlayid());
		}
		Stop;

		CMuzzle1:
		UMFL AB 1 BRIGHT;
		TNT1 A 0 A_Jump(100, "ThirdCMuzzle1");
		Stop;
		CMuzzle2:
		UMFL DE 1 BRIGHT;
		TNT1 A 0 A_Jump(100, "ThirdCMuzzle2");
		Stop;
		CMuzzle3:
		UMFL GH 1 BRIGHT;
		TNT1 A 0 A_Jump(100, "ThirdCMuzzle3");
		Stop;
		CMuzzle4:
		UMFL JK 1 BRIGHT;
		TNT1 A 0 A_Jump(100, "ThirdCMuzzle4");
		Stop;
		CMuzzle5:
		UMFL MN 1 BRIGHT;
		TNT1 A 0 A_Jump(100, "ThirdCMuzzle5");
		Stop;
		CMuzzle6:
		UMFL PQ 1 BRIGHT;
		TNT1 A 0 A_Jump(100, "ThirdCMuzzle6");
		Stop;
		ThirdCMuzzle1:
		UMFL C 1 BRIGHT;
		Stop;
		ThirdCMuzzle2:
		UMFL F 1 BRIGHT;
		Stop;
		ThirdCMuzzle3:
		UMFL I 1 BRIGHT;
		Stop;
		ThirdCMuzzle4:
		UMFL L 1 BRIGHT;
		Stop;
		ThirdCMuzzle5:
		UMFL O 1 BRIGHT;
		Stop;
		ThirdCMuzzle6:
		UMFL R 1 BRIGHT;
		Stop;

		LightningFlash:
		TNT1 A 0
		{
			A_OverlayFlags(overlayid(), PSPF_FLIP | PSPF_MIRROR, random(false, true));
			A_OverlayOffset(overlayid(), frandom(-5, 5), frandom(-7, 7));
			A_OverlayPivotAlign(overlayid(), PSPA_CENTER, PSPA_CENTER);
			A_OverlayRotate(overlayid(), frandom(-20, 20));
		}
		TNT1 A 0 A_Jump(256, "FiringLightning1", "FiringLightning2", "FiringLightning3");
	FiringLightning1:
		UNHL ABCCDDDD 1 BRIGHT;
		Stop;
	FiringLightning2:
		UNHL EFGHH 1 BRIGHT;
		Stop;
	FiringLightning3:
		UNHL IJKKLLL 1 BRIGHT;
		Stop;

		OverchargeFlash:
		TNT1 A 0
		{
			A_OverlayFlags(overlayid(), PSPF_FLIP | PSPF_MIRROR, random(false, true));
			A_OverlayPivotAlign(overlayid(), PSPA_CENTER, PSPA_CENTER);
			A_OverlayOffset(overlayid(), 0, -40);
		}
	OverchargeCharge:
		UMTB ABCDEFGHIJKLMNOPQRSTUVW 1 BRIGHT;
		Stop;

		PDA_Preview_DEx_Ready:
			UNMI H 1 A_WeaponReady(WRF_NOFIRE);
			UNMI H 1 A_WeaponReady(WRF_NOFIRE);
			Stop;
		PDA_Preview_DEx_Laser:
			UNMF A 1 Bright A_WeaponReady(WRF_NOFIRE);
			UNMF D 1 Bright A_WeaponReady(WRF_NOFIRE);
			UNMF E 1 Bright A_WeaponReady(WRF_NOFIRE);
			UNMI A 1 Bright A_WeaponReady(WRF_NOFIRE);
			UNMI A 1 Bright A_WeaponReady(WRF_NOFIRE);
			Stop;
		PDA_Preview_DEx_Incineration:
			UNMF A 1 Bright A_WeaponReady(WRF_NOFIRE);
			UNMF B 1 Bright A_WeaponReady(WRF_NOFIRE);
			UNMF C 1 Bright A_WeaponReady(WRF_NOFIRE);
			UNMF M 1 Bright A_WeaponReady(WRF_NOFIRE);
			UNMF N 1 Bright A_WeaponReady(WRF_NOFIRE);
			UNMF O 1 Bright A_WeaponReady(WRF_NOFIRE);
			Stop;
		PDA_Preview_DEx_Lightning:
			UNMI K 1 Bright A_WeaponReady(WRF_NOFIRE);
			UNMI K 1 Bright A_WeaponReady(WRF_NOFIRE);
			UNMI J 1 Bright A_WeaponReady(WRF_NOFIRE);
			UNMI I 1 Bright A_WeaponReady(WRF_NOFIRE);
			Stop;
		PDA_Preview_DEx_ModeSwitch:
			UNMD E 1 A_WeaponReady(WRF_NOFIRE);
			UNMD D 1 A_WeaponReady(WRF_NOFIRE);
			UNMD C 1 A_WeaponReady(WRF_NOFIRE);
			UNMD B 1 A_WeaponReady(WRF_NOFIRE);
			UNMD A 1 A_WeaponReady(WRF_NOFIRE);
			Stop;
	}
}
