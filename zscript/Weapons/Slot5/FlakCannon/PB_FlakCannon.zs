// Reilsss Flak Cannon fold (R_FlakCannon / Excavator.dec) as PB_FlakCannon.

class PB_FlakCannon : PB_WeaponBase
{
	Default
	{
		Weapon.SelectionOrder 1850;
		Weapon.Kickback 100;
		Weapon.AmmoType1 "RocketAmmo";
		Weapon.AmmoGive1 10;
		Weapon.AmmoUse1 0;
		Weapon.AmmoType2 "FlakCannonAmmo";
		Weapon.AmmoGive2 10;
		Weapon.AmmoUse2 0;
		Weapon.SlotNumber 5;
		Weapon.SlotPriority 5.1;
		+WEAPON.NOAUTOAIM;
		+WEAPON.AMMO_OPTIONAL;
		+FLOORCLIP;
		Inventory.PickupSound "weapons/FlakCannon/Select";
		Inventory.PickupMessage "$PB_PICKUP_PB_FLAKCANNON";
		Inventory.Icon "FKCUA0";
		Inventory.AltHUDIcon "FKCUA0";
		Obituary "%o was shredded by %k's Flak Cannon.";
		Tag "Flak Cannon";
		Scale 0.60;
	}

	override void AttachToOwner(Actor other)
	{
		if (other && other.player)
		{
			if (other.CountInv("FlakCannonAmmo") < 1)
				other.A_GiveInventory("FlakCannonAmmo", 10);
		}
		Super.AttachToOwner(other);
	}

	// Full vs Reduced (pb_lowgraphicsmode) muzzle accents — Ironblast baseline always.
	action void PB_FlakFireMuzzleFX()
	{
		A_FireCustomMissile("RedFlareSpawn", -5, 0, 3, 0);
		A_FireCustomMissile("RedFlareSpawn", -5, 0, 8, 0);
		A_FireCustomMissile("GunFireSmoke", 0, 0, 3, 0);
		A_FireCustomMissile("GunFireSmoke", 0, 0, 8, 0);
		A_Quake(4, 10, 0, 24);

		bool reduced = false;
		let cv = CVar.FindCVar("pb_lowgraphicsmode");
		if (cv && cv.GetInt())
			reduced = true;

		if (reduced)
		{
			A_FireCustomMissile("YellowFlareSpawn", -5, 0, 3, 0);
			A_FireCustomMissile("ShotgunParticles", random(-2, 2), 0, 3, 0);
			A_FireCustomMissile("ShotgunParticles", random(-2, 2), 0, 8, 0);
			A_FireCustomMissile("ShrapnelParticle", random(-4, 4), 0, 3, random(-2, 2));
			A_FireCustomMissile("ShrapnelParticle", random(-4, 4), 0, 8, random(-2, 2));
		}
		else
		{
			A_FireCustomMissile("YellowFlareSpawn", -5, 0, 3, 0);
			A_FireCustomMissile("YellowFlareSpawn", -5, 0, 8, 0);
			A_FireCustomMissile("ShotgunParticles", random(-2, 2), 0, 3, 0);
			A_FireCustomMissile("ShotgunParticles", random(-2, 2), 0, 3, 0);
			A_FireCustomMissile("ShotgunParticles", random(-2, 2), 0, 8, 0);
			A_FireCustomMissile("ShotgunParticles", random(-2, 2), 0, 8, 0);
			A_FireCustomMissile("ShrapnelParticle", random(-4, 4), 0, 3, random(-2, 2));
			A_FireCustomMissile("ShrapnelParticle", random(-4, 4), 0, 3, random(-2, 2));
			A_FireCustomMissile("ShrapnelParticle", random(-4, 4), 0, 8, random(-2, 2));
			A_FireCustomMissile("ShrapnelParticle", random(-4, 4), 0, 8, random(-2, 2));
		}
		A_PB_ThrottledMuzzleFXDual(-2, 2, 0, 0, "", 'FlakCannonFXPhase');
	}

	States
	{
	Steady:
		Goto PB_FinisherCleanup;



	Spawn:
		FKCU A -1;
		Stop;

	Ready:
		TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
		Goto Ready3;

	Ready3:
		TNT1 A 0
		{
			A_TakeInventory("PB_LockScreenTilt", 1);
			PB_HandleCrosshair(5);
		}
		TNT1 A 0 A_JumpIfInventory("PB_FlakLongRangeMode", 1, "ReadyLong");
	ReadyShort:
		FKCG A 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
		Loop;

	ReadyLong:
		FKCM A 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
		Loop;

	Deselect:
		TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "PlaceBarrel");
		TNT1 A 0 A_JumpIfInventory("GrabbedBurningBarrel", 1, "PlaceFlameBarrel");
		TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "PlaceIceBarrel");
		TNT1 A 0
		{
			A_WeaponOffset(0, 32);
			A_SetRoll(0);
			A_TakeInventory("PB_LockScreenTilt", 1);
			A_StopSound(CHAN_WEAPON);
		}
		FKCS ABCD 1;
		TNT1 A 0 A_Lower;
		Wait;

	Select:
		TNT1 A 0
		{
			A_WeaponOffset(0, 32);
			A_SetRoll(0);
			A_TakeInventory("PB_LockScreenTilt", 1);
		}
		TNT1 A 0 A_TakeInventory("HasBarrel", 1);
		TNT1 A 0 A_TakeInventory("HasIceBarrel", 1);
		TNT1 A 0 A_TakeInventory("HasBurningBarrel", 1);
		TNT1 A 0 A_TakeInventory("GrabbedBarrel", 1);
		TNT1 A 0 A_TakeInventory("GrabbedIceBarrel", 1);
		TNT1 A 0 A_TakeInventory("GrabbedBurningBarrel", 1);
		Goto SelectFirstPersonLegs;
	SelectContinue:
		TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
		TNT1 A 0 PB_WeapTokenSwitch("NewChaingunSelected");
		TNT1 A 0 PB_RespectIfNeeded;
		Goto SelectAnimation;
	SelectAnimation:
		TNT1 A 0 A_StartSound("weapons/FlakCannon/Select", CHAN_AUTO);
		FKCS DCBA 1;
		TNT1 A 0 A_JumpIfInventory("FlakCannonAmmo", 1, "Ready3");
		Goto Reload;

	WeaponSpecial:
		TNT1 A 0 A_TakeInventory("GoWeaponSpecialAbility", 1);
		TNT1 A 0 A_JumpIfInventory("Select_PB_FlakCannon_Short", 1, "SwitchToShort");
		TNT1 A 0 A_JumpIfInventory("Select_PB_FlakCannon_Long", 1, "SwitchToLong");
		TNT1 A 0 A_JumpIfInventory("PB_FlakLongRangeMode", 1, "SwitchToShort");
		Goto SwitchToLong;

	SwitchToLong:
		TNT1 A 0 A_TakeInventory("Select_PB_FlakCannon_Short", 1);
		TNT1 A 0 A_TakeInventory("Select_PB_FlakCannon_Long", 1);
		TNT1 A 0 A_GiveInventory("PB_FlakLongRangeMode", 1);
		TNT1 A 0 A_Print("Long Range Mode");
		FKCF D 2;
		FKCS ABC 2;
		TNT1 A 0 A_StartSound("weapons/FlakCannon/Select", CHAN_AUTO);
		FKCS CBA 2;
		FKCL D 2;
		Goto ReadyLong;

	SwitchToShort:
		TNT1 A 0 A_TakeInventory("Select_PB_FlakCannon_Short", 1);
		TNT1 A 0 A_TakeInventory("Select_PB_FlakCannon_Long", 1);
		TNT1 A 0 A_TakeInventory("PB_FlakLongRangeMode", 1);
		TNT1 A 0 A_Print("Short Range Mode");
		FKCL D 2;
		FKCS ABC 2;
		TNT1 A 0 A_StartSound("weapons/FlakCannon/Select", CHAN_AUTO);
		FKCS CBA 2;
		FKCF D 2;
		Goto ReadyShort;

	Fire:
		TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "ThrowBarrel");
		TNT1 A 0 A_JumpIfInventory("GrabbedBurningBarrel", 1, "ThrowFlameBarrel");
		TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "ThrowIceBarrel");
		TNT1 A 0
		{
			A_WeaponOffset(0, 32);
			A_SetRoll(0);
			if (CountInv("NoFatality") == 0 && GetCVar("pb_auto_fatality_fire") == 1)
				return PB_TryAutoFatalityOnFire();
			return ResolveState(null);
		}
		TNT1 A 0 A_TakeInventory("Reloading", 1);
		TNT1 A 0 { return PB_BailIfCannotFire("FlakCannonAmmo", 1, "RocketAmmo"); }
		TNT1 A 0 A_JumpIfInventory("PB_FlakLongRangeMode", 1, "FireLong");
	FireShort:
		TNT1 A 0 PB_FlakFireMuzzleFX();
		TNT1 A 0 A_StartSound("weapons/FlakCannon/Fire", CHAN_WEAPON, CHANF_OVERLAP, 0.7);
		TNT1 A 0 A_StartSound("weapons/FlakCannon/Fire_Add", 5, CHANF_OVERLAP, 0.7);
		TNT1 A 0 A_AlertMonsters;
		TNT1 A 0 A_ZoomFactor(0.96);
		FKCF A 2 Bright;
		TNT1 A 0 A_FireCustomMissile("PB_FlakChunkNB1", random(-6, 6), 0, 3 + random(-2, 2), random(-5, 5));
		TNT1 A 0 A_FireCustomMissile("PB_FlakChunkNB2", random(-6, 6), 0, 3 + random(-2, 2), random(-5, 5));
		TNT1 A 0 A_FireCustomMissile("PB_FlakChunkNB3", random(-6, 6), 0, 3 + random(-2, 2), random(-5, 5));
		TNT1 A 0 A_FireCustomMissile("PB_FlakChunkNB2", random(-6, 6), 0, 3 + random(-2, 2), random(-5, 5));
		TNT1 A 0 A_FireCustomMissile("PB_FlakChunkNB1", random(-6, 6), 0, 8 + random(-2, 2), random(-5, 5));
		TNT1 A 0 A_FireCustomMissile("PB_FlakChunkNB2", random(-6, 6), 0, 8 + random(-2, 2), random(-5, 5));
		TNT1 A 0 A_FireCustomMissile("PB_FlakChunkNB2", random(-6, 6), 0, 3 + random(-2, 2), random(-5, 5));
		TNT1 A 0 A_FireCustomMissile("PB_FlakChunkNB1", random(-6, 6), 0, 8 + random(-2, 2), random(-5, 5));
		TNT1 A 0 A_FireCustomMissile("PB_FlakChunkNB2", random(-6, 6), 0, 8 + random(-2, 2), random(-5, 5));
		TNT1 A 0 A_FireCustomMissile("PB_FlakChunkNB3", random(-6, 6), 0, 8 + random(-2, 2), random(-5, 5));
		TNT1 A 0 A_FireCustomMissile("PB_FlakChunkNB2", random(-6, 6), 0, 8 + random(-2, 2), random(-5, 5));
		TNT1 A 0 A_TakeInventory("FlakCannonAmmo", 1);
		TNT1 A 0 A_FireCustomMissile("ShakeYourAssDouble", 0, 0, 3, 0);
		FKCF B 2 Bright A_ZoomFactor(0.97);
		FKCF C 2 Bright A_ZoomFactor(0.98);
		FKCF D 1 Bright A_ZoomFactor(0.99);
		TNT1 A 0 A_ZoomFactor(1.0);
		FKCG AAAAAAAA 1 A_WeaponReady(WRF_NOPRIMARY | WRF_NOSECONDARY);
		FKCG A 5;
		FKCG A 1 A_ReFire;
		Goto Ready3;

	FireLong:
		TNT1 A 0 PB_FlakFireMuzzleFX();
		TNT1 A 0 A_StartSound("weapons/FlakCannon/Fire", CHAN_WEAPON, CHANF_OVERLAP, 0.7);
		TNT1 A 0 A_StartSound("weapons/FlakCannon/Fire_Add", 5, CHANF_OVERLAP, 0.7);
		TNT1 A 0 A_AlertMonsters;
		TNT1 A 0 A_ZoomFactor(0.96);
		FKCF A 2 Bright;
		TNT1 A 0 A_FireCustomMissile("PB_FlakChunk1", random(-6, 6), 0, 3 + random(-2, 2), random(-5, 5));
		TNT1 A 0 A_FireCustomMissile("PB_FlakChunk2", random(-6, 6), 0, 3 + random(-2, 2), random(-5, 5));
		TNT1 A 0 A_FireCustomMissile("PB_FlakChunk3", random(-6, 6), 0, 3 + random(-2, 2), random(-5, 5));
		TNT1 A 0 A_FireCustomMissile("PB_FlakChunk2", random(-6, 6), 0, 3 + random(-2, 2), random(-5, 5));
		TNT1 A 0 A_FireCustomMissile("PB_FlakChunk1", random(-6, 6), 0, 8 + random(-2, 2), random(-5, 5));
		TNT1 A 0 A_FireCustomMissile("PB_FlakChunk2", random(-6, 6), 0, 8 + random(-2, 2), random(-5, 5));
		TNT1 A 0 A_FireCustomMissile("PB_FlakChunk2", random(-6, 6), 0, 3 + random(-2, 2), random(-5, 5));
		TNT1 A 0 A_FireCustomMissile("PB_FlakChunk1", random(-6, 6), 0, 8 + random(-2, 2), random(-5, 5));
		TNT1 A 0 A_FireCustomMissile("PB_FlakChunk2", random(-6, 6), 0, 8 + random(-2, 2), random(-5, 5));
		TNT1 A 0 A_FireCustomMissile("PB_FlakChunk3", random(-6, 6), 0, 8 + random(-2, 2), random(-5, 5));
		TNT1 A 0 A_FireCustomMissile("PB_FlakChunk2", random(-6, 6), 0, 8 + random(-2, 2), random(-5, 5));
		TNT1 A 0 A_TakeInventory("FlakCannonAmmo", 1);
		TNT1 A 0 A_FireCustomMissile("ShakeYourAssDouble", 0, 0, 3, 0);
		FKCF B 2 Bright A_ZoomFactor(0.97);
		FKCF C 2 Bright A_ZoomFactor(0.98);
		FKCF D 1 Bright A_ZoomFactor(0.99);
		TNT1 A 0 A_ZoomFactor(1.0);
		FKCM AAAAAAAA 1 A_WeaponReady(WRF_NOPRIMARY | WRF_NOSECONDARY);
		FKCM A 5;
		FKCM A 1 A_ReFire;
		Goto Ready3;

	AltFire:
		TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "ThrowBarrel");
		TNT1 A 0 A_JumpIfInventory("GrabbedBurningBarrel", 1, "ThrowFlameBarrel");
		TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "ThrowIceBarrel");
		TNT1 A 0 A_WeaponOffset(0, 32);
		TNT1 A 0 A_TakeInventory("Reloading", 1);
		TNT1 A 0 A_JumpIfInventory("FlakCannonAmmo", 2, 1);
		Goto Reload;
		TNT1 A 0 A_JumpIfInventory("PB_FlakLongRangeMode", 1, "AltLong");
	AltShort:
		TNT1 A 0 PB_FlakFireMuzzleFX();
		TNT1 A 0 A_StartSound("weapons/FlakCannon/Fire", CHAN_WEAPON, CHANF_OVERLAP, 0.7);
		TNT1 A 0 A_StartSound("weapons/FlakCannon/Fire_Add", 5, CHANF_OVERLAP, 0.7);
		TNT1 A 0 A_AlertMonsters;
		TNT1 A 0 A_ZoomFactor(0.96);
		FKCF A 2 Bright;
		TNT1 A 0 A_FireCustomMissile("PB_FlakImpactGrenade", -1.5, 0, 3, -5);
		TNT1 A 0 A_FireCustomMissile("PB_FlakImpactGrenade", 1.5, 0, 8, -5);
		TNT1 A 0 A_TakeInventory("FlakCannonAmmo", 2);
		TNT1 A 0 A_FireCustomMissile("ShakeYourAssDouble", 0, 0, 3, 0);
		FKCF B 2 Bright A_ZoomFactor(0.97);
		FKCF C 2 Bright A_ZoomFactor(0.98);
		FKCF D 1 Bright A_ZoomFactor(0.99);
		TNT1 A 0 A_ZoomFactor(1.0);
		FKCG AAAAAAAA 1 A_WeaponReady(WRF_NOPRIMARY | WRF_NOSECONDARY);
		FKCG A 5;
		FKCG A 1 A_ReFire;
		Goto Ready3;

	AltLong:
		TNT1 A 0 PB_FlakFireMuzzleFX();
		TNT1 A 0 A_StartSound("weapons/FlakCannon/Fire", CHAN_WEAPON, CHANF_OVERLAP, 0.7);
		TNT1 A 0 A_StartSound("weapons/FlakCannon/Fire_Add", 5, CHANF_OVERLAP, 0.7);
		TNT1 A 0 A_AlertMonsters;
		TNT1 A 0 A_ZoomFactor(0.96);
		FKCF A 2 Bright;
		TNT1 A 0 A_FireCustomMissile("PB_FastFlakBounceGrenade", -1.5, 0, 3, -5);
		TNT1 A 0 A_FireCustomMissile("PB_FastFlakBounceGrenade", 1.5, 0, 8, -5);
		TNT1 A 0 A_TakeInventory("FlakCannonAmmo", 2);
		TNT1 A 0 A_FireCustomMissile("ShakeYourAssDouble", 0, 0, 3, 0);
		FKCF B 2 Bright A_ZoomFactor(0.97);
		FKCF C 2 Bright A_ZoomFactor(0.98);
		FKCF D 1 Bright A_ZoomFactor(0.99);
		TNT1 A 0 A_ZoomFactor(1.0);
		FKCM AAAAAAAA 1 A_WeaponReady(WRF_NOPRIMARY | WRF_NOSECONDARY);
		FKCM A 5;
		FKCM A 1 A_ReFire;
		Goto Ready3;

	Reload:
		FKCR A 1 A_WeaponReady(WRF_NOFIRE);
		TNT1 A 0 A_TakeInventory("Reloading", 1);
		TNT1 A 0 A_JumpIfInventory("FlakCannonAmmo", 10, "Ready3");
		TNT1 A 0 A_JumpIfInventory("RocketAmmo", 1, "ReloadAnim");
		Goto NoAmmo;
	NoAmmo:
		TNT1 A 0 A_PlaySound("weapons/empty");
		FKCG A 8 A_WeaponReady(WRF_NOFIRE|WRF_NOSWITCH);
		Goto Ready3;
	ReloadAnim:
		TNT1 A 0 A_StartSound("weapons/FlakCannon/Clip_Out", 3);
		FKCR ABCDE 2;
		FKCR EFJKLMNOP 2;
		TNT1 A 0 A_StartSound("weapons/FlakCannon/Clip_In", 4);
		FKCR QRST 2;
		TNT1 A 0 A_StartSound("weapons/FlakCannon/Reload_Finish", 2);
		FKCR A 3;
	ReloadFill:
		TNT1 A 0 A_JumpIfInventory("FlakCannonAmmo", 10, "Ready3");
		TNT1 A 0 A_JumpIfInventory("RocketAmmo", 1, 1);
		Goto Ready3;
		TNT1 A 0 A_GiveInventory("FlakCannonAmmo", 1);
		TNT1 A 0 A_TakeInventory("RocketAmmo", 1);
		Loop;

	FlashKicking:
		TNT1 A 0 A_JumpIfInventory("PB_FlakLongRangeMode", 1, "FlashKickingLong");
		FKCG AAAAAAAAAAAAAAA 1;
		Stop;
	FlashKickingLong:
		FKCM AAAAAAAAAAAAAAA 1;
		Stop;
	FlashAirKicking:
		TNT1 A 0 A_JumpIfInventory("PB_FlakLongRangeMode", 1, "FlashAirKickingLong");
		FKCG AAAAAAAAAAAAAAAA 1;
		Stop;
	FlashAirKickingLong:
		FKCM AAAAAAAAAAAAAAAA 1;
		Stop;
	FlashSlideKicking:
		TNT1 A 0 A_JumpIfInventory("PB_FlakLongRangeMode", 1, "FlashSlideKickingLong");
		FKCG AAAAAAAAAAAAAAAAAAAAAAAA 1;
		Stop;
	FlashSlideKickingLong:
		FKCM AAAAAAAAAAAAAAAAAAAAAAAA 1;
		Stop;
	FlashSlideKickingStop:
		TNT1 A 0 A_JumpIfInventory("PB_FlakLongRangeMode", 1, "FlashSlideKickingStopLong");
		FKCG AAAAAAA 1;
		Stop;
	FlashSlideKickingStopLong:
		FKCM AAAAAAA 1;
		Stop;
	FlashPunching:
		FKCF ABCD 1 Bright;
		FKCG A 6;
		TNT1 A 0 A_ClearOverlays(PSP_FLASH, PSP_FLASH, false);
		Stop;
	}
}
