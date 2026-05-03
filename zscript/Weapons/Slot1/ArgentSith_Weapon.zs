// : PB_WeaponBase: SelectFirstPersonLegs inlined (BaseWeapon.dec)
class PB_ArgentSith : PB_WeaponBase
{
	Default
	{
		Weapon.BobRangeX 0.3;
		Weapon.BobRangeY 0.5;
		Weapon.BobStyle "InverseSmooth";
		Weapon.BobSpeed 2.0;
		Weapon.Kickback 100;
		Weapon.AmmoType1 "PB_DTech";
		Weapon.AmmoGive 20;
		+WEAPON.NOALERT;
		+WEAPON.NOAUTOAIM;
		+WEAPON.MELEEWEAPON;
		+INVENTORY.ALWAYSPICKUP;
		+FORCEXYBILLBOARD;
		+DONTGIB;
		Inventory.PickupSound "ArgKatana/Activate";
		Inventory.Pickupmessage "You got the Argent Sith Energy Beam Katana. (Slot 1)";
		Inventory.Icon "BVATK0";
		Obituary  "Feels Familiar?, Join The Darksiiide!";
		Weapon.SlotNumber 1;
		Scale 0.6;
		Tag "Argent Sith Beam Katana";
		Inventory.AltHudIcon "BVATK0";
		PB_WeaponBase.RespectItem "RespectEnergy-Katana";
		FloatBobStrength 0.5;
	}

	States
   {
   Steady:
	    TNT1 A 1;
	    TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
	    TNT1 A 0 SetPlayerProperty(0, 0, 0);
	    goto Ready;

   Ready:
        TNT1 A 0;
		TNT1 A 0;
   SelectAnimation:
		BVT0 DCBAE 1;
		BVAT A 0 A_StartSound("ArgKatana/Activate");
		TNT1 A 0 A_JumpIfInventory("GoFatality",1,"Steady");
   Ready3:
		TNT1 A 0 {
			A_WeaponOffset(0,32);
			A_SetRoll(0);
			A_TakeInventory("PB_LockScreenTilt",1);
		}
		TNT1 A 0 PB_HandleCrosshair(90);
		TNT1 A 0;
	KatanaReadyToCut:
		TNT1 A 0 {
			if (CountInv("PB_BeamKatana") >= 1) return resolveState("ChooseUpgradePath");
			return resolveState(null);
		}
		BVAT A 1 BRIGHT {
			return A_DoPBWeaponAction();
		}
		BVAT A 0 A_GiveInventory("HasCutingWeapon",1);
		TNT1 A 0 A_JumpIfInventory("GoFatality",1,"Steady");
		Loop;

	ChooseUpgradePath:
		TNT1 A 0 PB_KatanaUpgradeFreeze(true);
		TNT1 A 0 A_PrintBold(
			"\c-You have both the \caSITH LORD\c- and \ciJEDI MASTER\c- in inventory.\n\cdFIRE\ci: Keep \caSITH LORD (current)\ci  |  \chALTFIRE\ci: Equip \ciJEDI MASTER\ci (drop SITH, use pickup as replacement)\c-"
		);
		TNT1 A 1;
		TNT1 A 1;
		ChooseUpgradePathDebounce:
		TNT1 A 2;
		ChooseUpgradePathLoop:
		TNT1 A 0 A_JumpIf(JustPressed(BT_ATTACK), "KeepArgentPath");
		TNT1 A 0 A_JumpIf(JustPressed(BT_ALTATTACK), "KeepBeamPath");
		TNT1 A 1;
		TNT1 A 1;
		TNT1 A 0 A_WeaponReady(WRF_NOFIRE | WRF_NOBOB | WRF_NOSWITCH);
		Goto ChooseUpgradePathLoop;

	KeepArgentPath:
		TNT1 A 0 A_TakeInventory("PB_BeamKatana", 1);
		TNT1 A 0 A_PrintBold("\cdKept: \caSITH LORD");
		Goto ReleaseKatanaButtons;

	KeepBeamPath:
		TNT1 A 0 PB_KatanaUpgradeFreeze(false);
		TNT1 A 0 PB_KatanaUpgradeClearAttackButtons();
		TNT1 A 0 A_PrintBold("\cdSwitched to: \ciJEDI MASTER");
		TNT1 A 0 A_SelectWeapon("PB_BeamKatana");
		TNT1 A 0 A_TakeInventory("PB_ArgentSith", 1);
		Stop;

	ReleaseKatanaButtons:
		TNT1 A 0 PB_KatanaUpgradeFreeze(false);
		TNT1 A 0 PB_KatanaUpgradeClearAttackButtons();
		TNT1 A 0 PB_KatanaUpgradeResolveReadyWhenReleased();
		TNT1 A 1 A_WeaponReady(WRF_NOFIRE | WRF_NOSWITCH | WRF_NOBOB);
		Goto ReleaseKatanaButtons;

	Deselect:
        	TNT1 A 0 A_JumpIfInventory ("GrabbedBarrel", 1, "PlaceBarrel");
	    	TNT1 A 0 A_JumpIfInventory ("GrabbedFlameBarrel", 1, "PlaceFlameBarrel");
	    	TNT1 A 0 A_JumpIfInventory ("GrabbedIceBarrel", 1, "PlaceIceBarrel");
	    	TNT1 A 0 {
			A_WeaponOffset(0,32);
			A_SetRoll(0);
			A_TakeInventory("PB_LockScreenTilt",1);
		}
		BVAT A 0 A_Takeinventory("PowerBloodOnVisor",1);
		BVAT A 0 A_Takeinventory("PowerBlueBloodOnVisor",1);
		BVAT A 0 A_Takeinventory("PowerGreenBloodOnVisor",1);
		BVAT A 0 A_Takeinventory("HasCutingWeapon",1);
		BVAT A 0 A_PlaySound("Katana/DeSelect");
		BVT0 EABCD 1;
		TNT1 A 0 A_Lower;
		Wait;

	Select:
		TNT1 A 0 {
			A_WeaponOffset(0,32);
			A_SetRoll(0);
			A_TakeInventory("PB_LockScreenTilt",1);
		}
		TNT1 A 0 A_TakeInventory("HasBarrel",1);
	    	TNT1 A 0 A_TakeInventory("HasIceBarrel",1);
	    	TNT1 A 0 A_TakeInventory("HasFlameBarrel",1);
	    	TNT1 A 0 A_TakeInventory("GrabbedBarrel",1);
	    	TNT1 A 0 A_TakeInventory("GrabbedIceBarrel",1);
	    TNT1 A 0 A_TakeInventory("GrabbedFlameBarrel",1);
		TNT1 A 0 A_StopSound(1);
		TNT1 A 0 A_StopSound(5);
		TNT1 A 0 A_StopSound(6);
		TNT1 A 0 A_TakeInventory("Spin",1);
		TNT1 A 0 A_TakeInventory("CantWeaponSpecial",1);
		TNT1 A 0 A_TakeInventory("MG42Selected",1);
		TNT1 A 0 A_SetInventory("Grabbing_A_Ledge", 0);
		TNT1 A 0 A_TakeInventory("RandomHeadExploder",1);
		TNT1 A 0 A_TakeInventory("DualFireReload",2);
		TNT1 A 0 A_Overlay(-777, "Melee_Equipment_Handler_Overlay");
		TNT1 A 0 A_Overlay(-778, "KickHandler_Overlay");
		TNT1 A 0 A_Overlay(-779, "Equipment_Toggle_Handler_Overlay");
		TNT1 A 0 A_Overlay(-10, "FirstPersonLegsStand");
		TNT1 A 0 A_Jump(255, "SelectContinue");
	SelectContinue:
		TNT1 A 0 A_Takeinventory("PowerBloodOnVisor",1);
		TNT1 A 0 A_Takeinventory("PowerBlueBloodOnVisor",1);
		TNT1 A 0 A_Takeinventory("PowerGreenBloodOnVisor",1);
		Goto SelectAnimation;

	Reload:
		TNT1 A 0 A_JumpIfInventory ("GrabbedBarrel", 1, "IdleBarrel");
		TNT1 A 0 A_JumpIfInventory ("GrabbedFlameBarrel", 1, "IdleFlameBarrel");
		TNT1 A 0 A_JumpIfInventory ("GrabbedIceBarrel", 1, "IdleIceBarrel");
		Goto KatanaReadyToCut;

	Fire:
		TNT1 A 0 {
			A_WeaponOffset(0, 32);
			A_SetRoll(0);
			A_TakeInventory("PB_LockScreenTilt", 1);
		}
		TNT1 A 0 {
			if (CountInv("GoFatality") >= 1) SetPlayerProperty(0, 1, 0);
			else SetPlayerProperty(0, 0, 0);
		}
		TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
		TNT1 A 0 A_JumpIfInventory ("GrabbedBarrel", 1, "ThrowBarrel");
		TNT1 A 0 A_JumpIfInventory ("GrabbedFlameBarrel", 1, "ThrowFlameBarrel");
		TNT1 A 0 A_JumpIfInventory ("GrabbedIceBarrel", 1, "ThrowIceBarrel");
		TNT1 A 0 PB_CheckBarrelThrow1();
		TNT1 A 0 {
			let po = invoker.Owner;
			if (po == null || !(po is "PlayerPawn"))
				return resolveState(null);
			let pp = PlayerPawn(po);
			if (pp && pp.player && invoker.CountInv("NoFatality") == 0
				&& CVar.GetCVar("pb_auto_fatality_fire", pp.player).GetBool())
			{
				return PB_Execute();
			}
			return resolveState(null);
		}
		BVAT A 0 A_JumpIfInventory("ArgentSithSwitchHands", 1, "NormalCutAlt");
		BVAT A 1 BRIGHT;
		BVAT C 1 BRIGHT;
		BVAT D 1 BRIGHT A_StartSound("ArgKatana/Swing", CHAN_WEAPON);
		BVAT A 0 A_GiveInventory("KatanaSequence1");
		BVAT A 0 A_JumpIfInventory("PowerStrength", 1, "BerserkerCut");
		BVAT E 0 A_CustomPunch(5,true, CPF_STEALARMOR,"ArgSithSawPuff",140,1,150,"ArmorShard","ArgKatana/Hit","ArgKatana/Swing");
		BVAT E 1 BRIGHT A_CustomPunch(40,true,0,"ArgSithSawPuff",180,0,0,"none","ArgKatana/Hit","ArgKatana/Swing");
	    Goto FinishCuttingAnimation;

	BerserkerCut:
		BVAT E 0 A_StartSound("ArgKatana/Swing", CHAN_WEAPON);
		BVAT E 0 A_CustomPunch(5,true, CPF_STEALARMOR,"ArgSithSawPuff",140,1,250,"ArmorShard","ArgKatana/Hit","ArgKatana/Swing");
		BVAT E 1 BRIGHT A_CustomPunch(110,true,0,"ArgSithSawPuff",180,0,0,"none","ArgKatana/Hit","ArgKatana/Swing");
		Goto FinishCuttingAnimation;

	FinishCuttingAnimation:
		BVAT G 1 BRIGHT;
		BVAT H 1 BRIGHT;
		BVAT I 1 BRIGHT;
		BVAT J 1 BRIGHT;
		BVAT Q 1 BRIGHT;
		BVAT P 1 BRIGHT;
		BVAT O 1 BRIGHT;
		BVAT N 1 BRIGHT;
		BVAT M 1 BRIGHT;
		BVAT L 1 BRIGHT A_GiveInventory("ArgentSithSwitchHands", 1);
		Goto KatanaReadyToCut;
	
	NormalCutAlt:
		BVAT A 1 BRIGHT;
		BVT2 A 1 BRIGHT;
		BVT2 B 1 BRIGHT;
		BVT2 C 1 BRIGHT;
		BVT2 D 1 BRIGHT A_StartSound("ArgKatana/Swing", CHAN_WEAPON);
		BVAT A 0 A_GiveInventory("KatanaSequence2");
		BVT2 A 0 A_JumpIfInventory("PowerStrength", 1, "BerserkerCutAlt");
		BVT2 E 0 A_CustomPunch(5,true, CPF_STEALARMOR,"ArgSithSawPuff",140,1,150,"ArmorShard","ArgKatana/Hit","ArgKatana/Swing");
		BVT2 E 1 BRIGHT A_CustomPunch(40,true,0,"ArgSithSawPuff",180,0,0,"none","ArgKatana/Hit","ArgKatana/Swing");
	    Goto FinishCuttingAnimationAlt;

	BerserkerCutAlt:
		BVT2 E 0 A_StartSound("ArgKatana/Swing", CHAN_WEAPON);
		BVT2 E 0 A_CustomPunch(5,true, CPF_STEALARMOR,"ArgSithSawPuff",140,1,250,"ArmorShard","ArgKatana/Hit","ArgKatana/Swing");
		BVT2 E 1 BRIGHT A_CustomPunch(110,true,0,"ArgSithSawPuff",180,0,0,"none","ArgKatana/Hit","ArgKatana/Swing");
		Goto FinishCuttingAnimationAlt;

	FinishCuttingAnimationAlt:
		BVT2 G 1 BRIGHT;
		BVT2 H 1 BRIGHT;
		BVT2 I 1 BRIGHT;
		BVT2 J 1 BRIGHT;
		BVAT Q 1 BRIGHT;
		BVAT P 1 BRIGHT;
		BVAT O 1 BRIGHT;
		BVAT N 1 BRIGHT;
		BVAT M 1 BRIGHT;
		BVAT L 1 BRIGHT A_TakeInventory("ArgentSithSwitchHands", 1);
		BVT2 A 0 A_JumpIfInventory("KatanaSequence2",1,"Stab");
		Goto KatanaReadyToCut;

	Stab:
		KTNR PQRSTU 0;
		KTNB PQRSTU 0;
		KTNG PQRSTU 0;
		TNT1 A 0 {
				A_PlaySound("ArgKatana/Swing");
				A_SetRoll(0);
				A_TakeInventory("KatanaSequence2");
			}
		TNT1 A 0 {
				A_PlaySound("ArgKatana/Thrust");
				A_SetRoll(0);
			}
		KTNA PQR 1
			{
			if (CountInv("PowerGreenBloodOnVisor") >= 1 ) { A_SetWeaponSprite("KTNG"); }
			if (CountInv("PowerBlueBloodOnVisor") >= 1 ) { A_SetWeaponSprite("KTNB"); }
			if (CountInv("PowerBloodOnVisor") >= 1 ) { A_SetWeaponSprite("KTNR"); }
			}
			KTNA S 4
			{
			if (CountInv("PowerGreenBloodOnVisor") >= 1 ) { A_SetWeaponSprite("KTNG"); }
			if (CountInv("PowerBlueBloodOnVisor") >= 1 ) { A_SetWeaponSprite("KTNB"); }
			if (CountInv("PowerBloodOnVisor") >= 1 ) { A_SetWeaponSprite("KTNR"); }
			}
			KTNA T 1
			{
			if (CountInv("PowerGreenBloodOnVisor") >= 1 ) { A_SetWeaponSprite("KTNG"); }
			if (CountInv("PowerBlueBloodOnVisor") >= 1 ) { A_SetWeaponSprite("KTNB"); }
			if (CountInv("PowerBloodOnVisor") >= 1 ) { A_SetWeaponSprite("KTNR"); }
			A_SetPitch(-2.0 + pitch);
			 A_ZoomFactor(0.96);
			}
			KNIF A 0  A_FireCustomMissile("SwordArgentSlash", 0, 1, 0, -5);
			KTNA U 1
			{
			if (CountInv("PowerGreenBloodOnVisor") >= 1 ) { A_SetWeaponSprite("KTNG"); }
			if (CountInv("PowerBlueBloodOnVisor") >= 1 ) { A_SetWeaponSprite("KTNB"); }
			if (CountInv("PowerBloodOnVisor") >= 1 ) { A_SetWeaponSprite("KTNR"); }
			A_SetPitch(+1.0 + pitch);
			 A_ZoomFactor(1.0);
			}
			KTNA U 3
			{
			if (CountInv("PowerGreenBloodOnVisor") >= 1 ) { A_SetWeaponSprite("KTNG"); }
			if (CountInv("PowerBlueBloodOnVisor") >= 1 ) { A_SetWeaponSprite("KTNB"); }
			if (CountInv("PowerBloodOnVisor") >= 1 ) { A_SetWeaponSprite("KTNR"); }
			}
			KTNA TSRQL 1
			{
				if (CountInv("PowerGreenBloodOnVisor") >= 1 ) { A_SetWeaponSprite("KTNG"); }
				if (CountInv("PowerBlueBloodOnVisor") >= 1 ) { A_SetWeaponSprite("KTNB"); }
				if (CountInv("PowerBloodOnVisor") >= 1 ) { A_SetWeaponSprite("KTNR"); }
				return A_DoPBWeaponAction();
			}
			Goto Ready3;

	QuickMelee:
        	"####" A 0 {
				A_StopSound(CHAN_WEAPON);
				A_StopSound(CHAN_VOICE);
				A_StopSound(CHAN_6);
				A_StopSound(CHAN_7);
			}
			TNT1 A 0 A_JumpIfInventory("CantFire", 1, "FailOverlay");
			TNT1 A 0 A_JumpIfHealthLower(0, "FailOverlay");
			TNT1 A 0 {
				A_ClearOverlays(-10,65);
				A_Gunflash("Null");
			}
		"####" AAA 0 PB_Execute();
	GoMeleeInstead:
		TNT1 A 0 {
			A_PB_AirMeleeLunge(10);
			A_Overlay(PSP_FLASH, "FlashPunching");
			A_TakeInventory("Zoomed",1);
			A_ZoomFactor(1.0);
			A_TakeInventory("ADSmode",1);
			A_SetRoll(0);
			A_Overlay(-10, "FirstPersonLegsStand");
		}
		JSML ABCDEF 1;
		PUFF A 0 A_PlaySound("player/cyborg/fist", 3);
		TNT1 A 0 {
		     A_FireCustomMissile("Plasma_Ball", 20, 0);
		     A_FireCustomMissile("Plasma_Ball", -20, 0);
		     A_FireCustomMissile("Plasma_Ball", 10, 0, 0, 10);
		     A_FireCustomMissile("Plasma_Ball", -10, 0, 0, -10);
		     A_FireCustomMissile("Plasma_Ball", -15, 0, 0, -15);
		     A_FireCustomMissile("Plasma_Ball", -8, 0, 0, -8);
		     }
		JSML FGHIJKLMNOP 1;
		TNT1 A 7 {
			 if(JustPressed(BT_USER2)) {return PB_Execute();}
			 return resolveState(null);
		     }
		TNT1 A 0 {
			 PB_SetUsingMelee(false);
		     }
		TNT1 A 0 PB_CheckBarrelIdle1();
		TNT1 A 0 A_ClearOverlays(PSP_FLASH, PSP_FLASH, false);
		Goto Ready;

	AltFire:
		TNT1 A 0 A_JumpIfInventory ("GrabbedBarrel", 1, "PlaceBarrel");
		TNT1 A 0 A_JumpIfInventory ("GrabbedFlameBarrel", 1, "PlaceFlameBarrel");
		TNT1 A 0 A_JumpIfInventory ("GrabbedIceBarrel", 1, "PlaceIceBarrel");
		TNT1 A 0 {
			A_WeaponOffset(0, 32);
			A_SetRoll(0);
			A_TakeInventory("PB_LockScreenTilt", 1);
		}
		TNT1 A 0 A_JumpIfInventory("ArgentSlashModeToken", 1, "CuttingBlade");
		BVAT L 1 Bright;
		BVAT M 1 Bright;
		BVAT N 1 Bright;
		BVAT O 1 Bright;
		BVAT P 1 Bright;
		BVAT Q 1 Bright;
		BVT1 E 0 Bright A_StartSound("ArgentBarrier/On", 7);
		BVT1 E 1 Bright;
		BVT1 D 1 Bright;
		BVT1 C 1 Bright;
		BVT1 B 1 Bright;
		BVT1 A 1 Bright A_ReFire;
		Goto AltEnd;

	AltHold:
		BVT1 A 0 A_JumpIfInventory("PB_DTech", 1, "AltHoldContinue");
		BVT1 AAAA 1 Bright A_Print("\cgNot enough \c-souls");
		Goto AltEnd;

	AltHoldContinue:
		BVT1 A 1 Bright A_StartSound("ArgentBarrier/Loop", 7);
		BVT1 A 1 Bright A_FireCustomMissile("KatanaShieldSpawnerYEET2", 0, 0, 0, -35);
		BVT1 A 1 Bright A_FireCustomMissile("KatanaShieldSpawnerYEET2", 0, 0, 0, -35);
		BVT1 A 1 Bright A_FireCustomMissile("KatanaShieldSpawnerYEET2", 0, 0, 0, -35);
		BVT1 A 1 Bright A_FireCustomMissile("KatanaShieldSpawnerYEET2", 0, 0, 0, -35);
		BVT1 A 1 Bright A_FireCustomMissile("KatanaShieldSpawnerYEET2", 0, 0, 0, -35);
		BVT1 A 0 A_TakeInventory("PB_DTech", 1);
		BVT1 A 1 Bright A_ReFire;
		Goto AltEnd;

	AltEnd:
		BVT1 A 1 Bright A_ReFire;
		BVT1 B 1 Bright A_ReFire;
		BVT1 C 1 Bright A_ReFire;
		BVT1 D 1 Bright A_ReFire;
		BVT1 E 1 Bright A_ReFire;
		BVT1 E 0 Bright A_StartSound("ArgentBarrier/Off", 7);
		BVAT Q 1 Bright A_ReFire;
		BVAT P 1 Bright A_ReFire;
		BVAT O 1 Bright A_ReFire;
		BVAT N 1 Bright A_ReFire;
		BVAT M 1 Bright A_ReFire;
		BVAT L 1 Bright A_ReFire;
		Goto KatanaReadyToCut;

	WeaponSpecial: //THX to Dox778 AKA Donks Seven Seventy Ate//;
	    TNT1 A 0 A_JumpIfInventory ("GrabbedBarrel", 1, "IdleBarrel");
		TNT1 A 0 A_JumpIfInventory ("GrabbedFlameBarrel", 1, "IdleFlameBarrel");
		TNT1 A 0 A_JumpIfInventory ("GrabbedIceBarrel", 1, "IdleIceBarrel");
		TNT1 A 0 A_TakeInventory("GoWeaponSpecialAbility", 1);
		TNT1 A 0 A_JumpIfInventory("ActivateWeaponSpecial", 1, "KatanaReadyToCut");

	ActivateWeaponSpecial:
		TNT1 A 0 A_JumpIfInventory("ArgentSlashModeToken", 1, "DisableSlashMode");
		TNT1 A 0 A_Print("\ctAlt fire:\c- \chSlash \c-mode");
		TNT1 A 0 A_StartSound("CybKatana/SwitchMode",7);
		TNT1 A 0 A_GiveInventory("ArgentSlashModeToken", 1); //include the token give at some point
		Goto KatanaReadyToCut;

	DisableSlashMode:
		TNT1 A 0 A_StartSound("CybKatana/SwitchMode",7);
		TNT1 A 0 A_TakeInventory("ArgentSlashModeToken", 1); //take the token at some point
		TNT1 A 0 A_Print("\ctAlt fire:\c- \cdShield \c-mode");
		Goto KatanaReadyToCut;

	CuttingBlade:
	    BVAT A 0 A_JumpIfInventory("PB_DTech", 5, "SpecialCut");
		BVAT BBBB 1 BRIGHT A_Print("\cgNot enough \c-souls");
		Goto KatanaReadyToCut;

	SpecialCut:
		BVAT A 0 A_JumpIfInventory("ArgentSithSwitchHands", 1, "SpecialCutAlt");
		BVAT A 1 BRIGHT;
		BVAT C 1 BRIGHT;
		BVAT D 1 BRIGHT A_StartSound("ArgKatana/Swing",7);
		BVAT E 1 BRIGHT A_FireCustomMissile("SwordArgentSlash", 0, 1, 0, -5);
		BVAT F 1 BRIGHT A_TakeInventory("PB_DTech",5);
		BVAT G 1 BRIGHT;
		BVAT H 1 BRIGHT;
		BVAT I 1 BRIGHT;
		BVAT J 1 BRIGHT;
		BVAT Q 1 BRIGHT;
		BVAT P 1 BRIGHT;
		BVAT O 1 BRIGHT;
		BVAT N 1 BRIGHT;
		BVAT M 1 BRIGHT;
		BVAT L 1 BRIGHT A_GiveInventory("ArgentSithSwitchHands", 1);
		Goto KatanaReadyToCut;

	SpecialCutAlt:
		BVAT A 1 BRIGHT;
		BVT2 A 1 BRIGHT;
		BVT2 B 1 BRIGHT;
		BVT2 C 1 BRIGHT;
		BVT2 D 1 BRIGHT A_StartSound("ArgKatana/Swing",7);
		BVT2 E 1 BRIGHT A_FireCustomMissile("SwordArgentSlashAlt", 0, 1, 0, -5);
		BVT2 F 1 BRIGHT A_TakeInventory("PB_DTech",5);
		BVT2 G 1 BRIGHT;
		BVT2 H 1 BRIGHT;
		BVT2 I 1 BRIGHT;
		BVT2 J 1 BRIGHT;
		BVAT Q 1 BRIGHT;
		BVAT P 1 BRIGHT;
		BVAT O 1 BRIGHT;
		BVAT N 1 BRIGHT;
		BVAT M 1 BRIGHT;
		BVAT L 1 BRIGHT A_TakeInventory("ArgentSithSwitchHands", 1);
		TNT1 A 0 A_AlertMonsters;
		Goto KatanaReadyToCut;

	Spawn:
		BVAT K 1 BRIGHT;
		BVAT K -1 BRIGHT;
		Stop;

	FlashKicking:
	    TNT1 A 0 A_JumpIfInventory ("GrabbedBarrel", 1, "FlashBarrelPunching");
		TNT1 A 0 A_JumpIfInventory ("GrabbedFlameBarrel", 1, "FlashBarrelPunching");
		TNT1 A 0 A_JumpIfInventory ("GrabbedIceBarrel", 1, "FlashBarrelPunching");
		TNT1 A 0 A_JumpIfInventory("PowerGreenBloodOnVisor",1, 4);
		TNT1 A 0 A_JumpIfInventory("PowerBlueBloodOnVisor",1, 3);
		TNT1 A 0 A_JumpIfInventory("PowerBloodOnVisor",1, 2);
		TNT1 A 0 A_ClearOverlays(10,11);
		BVAT A 1 A_DoPBWeaponAction;
		BVAT LMNOPQQQQQQ 1;
		BVAT PONML 1;
		BVAT A 1;
		Goto KatanaReadyToCut;

	FlashAirKicking:
		TNT1 A 0 A_JumpIfInventory ("GrabbedBarrel", 1, "FlashBarrelPunching");
		TNT1 A 0 A_JumpIfInventory ("GrabbedFlameBarrel", 1, "FlashBarrelPunching");
		TNT1 A 0 A_JumpIfInventory ("GrabbedIceBarrel", 1, "FlashBarrelPunching");
		TNT1 A 0 A_JumpIfInventory("PowerGreenBloodOnVisor",1, 4);
		TNT1 A 0 A_JumpIfInventory("PowerBlueBloodOnVisor",1, 3);
		TNT1 A 0 A_JumpIfInventory("PowerBloodOnVisor",1, 2);
		TNT1 A 0 A_ClearOverlays(10,11);
		BVAT A 1 A_DoPBWeaponAction;
		BVAT LMNOPQQQQQQQ 1;
		BVAT PONML 1;
		BVAT A 1;
		Goto KatanaReadyToCut;

	FlashSlideKicking:
		TNT1 A 0 A_JumpIfInventory ("GrabbedBarrel", 1, "FlashBarrelPunching");
		TNT1 A 0 A_JumpIfInventory ("GrabbedFlameBarrel", 1, "FlashBarrelPunching");
		TNT1 A 0 A_JumpIfInventory ("GrabbedIceBarrel", 1, "FlashBarrelPunching");
		TNT1 A 0 A_JumpIfInventory("PowerGreenBloodOnVisor",1, 4);
		TNT1 A 0 A_JumpIfInventory("PowerBlueBloodOnVisor",1, 3);
		TNT1 A 0 A_JumpIfInventory("PowerBloodOnVisor",1, 2);
		TNT1 A 0 A_ClearOverlays(10,11);
		BVAT A 1 A_DoPBWeaponAction;
		BVAT LMNOPQQQQQQQQQ 1;
		BVAT PONML 1;
		BVAT A 1;
		Goto KatanaReadyToCut;

	FlashSlideKickingStop:
		TNT1 A 0 A_JumpIfInventory ("GrabbedBarrel", 1, "FlashBarrelPunching");
		TNT1 A 0 A_JumpIfInventory ("GrabbedFlameBarrel", 1, "FlashBarrelPunching");
		TNT1 A 0 A_JumpIfInventory ("GrabbedIceBarrel", 1, "FlashBarrelPunching");
		TNT1 A 0 A_JumpIfInventory("PowerGreenBloodOnVisor",1, 4);
		TNT1 A 0 A_JumpIfInventory("PowerBlueBloodOnVisor",1, 3);
		TNT1 A 0 A_JumpIfInventory("PowerBloodOnVisor",1, 2);
		TNT1 A 0 A_ClearOverlays(10,11);
		BVAT A 1 A_DoPBWeaponAction;
		Goto KatanaReadyToCut;

	FlashPunching:
		TNT1 A 0 A_JumpIfInventory ("GrabbedBarrel", 1, "FlashBarrelPunching");
		TNT1 A 0 A_JumpIfInventory ("GrabbedFlameBarrel", 1, "FlashBarrelPunching");
		TNT1 A 0 A_JumpIfInventory ("GrabbedIceBarrel", 1, "FlashBarrelPunching");
		TNT1 A 0 A_ClearOverlays(10,11);
		TNT1 A 15;
		TNT1 A 0 A_ClearOverlays(PSP_FLASH, PSP_FLASH, false);
		Goto Ready3;
	}
}
