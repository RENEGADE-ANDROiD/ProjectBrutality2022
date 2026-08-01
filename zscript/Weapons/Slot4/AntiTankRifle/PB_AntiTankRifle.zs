// PB_AntiTankRifle — Brutal Doom Plus Machinegun fold (Tesefy sprites).
// Weapon Special: Explosive Bolt (default) / 3-Round Burst / Void Grenade.

class PB_AntiTankRifle : PB_WeaponBase
{
	Default
	{
		Weapon.BobRangeX 0.3;
		Weapon.BobRangeY 0.5;
		Weapon.BobStyle "InverseSmooth";
		Weapon.BobSpeed 2.4;
		Weapon.SelectionOrder 900;
		Weapon.AmmoUse1 0;
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive1 15;
		Weapon.AmmoGive2 5;
		Weapon.AmmoType1 "NewClip";
		Weapon.AmmoType2 "PB_AntiTankMag";
		+FLOORCLIP;
		+DONTGIB;
		Scale 0.9;
		Inventory.PickupMessage "$PB_PICKUP_PB_ANTITANKRIFLE";
		Inventory.PickupSound "weapons/antitank/deploy";
		Inventory.Icon "PAPAA0";
		Inventory.AltHUDIcon "PAPAA0";
		Inventory.Amount 1;
		Inventory.MaxAmount 1;
		Obituary "%o was punched through by %k's Anti-Tank Rifle";
		Weapon.SlotNumber 4;
		Weapon.SlotPriority 0.35;
		Tag "Anti-Tank Rifle";
		+WEAPON.NOAUTOAIM;
		+WEAPON.NOAUTOFIRE;
		PB_WeaponBase.RespectItem "RespectAntiTankRifle";
	}

	States
	{
	Spawn:
		PAPA A -1;
		Stop;

	Steady:
		TNT1 A 1;
		Goto Ready;

	Ready:
		TNT1 A 0 A_JumpIfInventory("RespectAntiTankRifle", 1, "SelectAnimation");
	WeaponRespect:
		TNT1 A 0
		{
			A_GiveInventory("RespectAntiTankRifle", 1);
			PB_HandleCrosshair(76);
			A_GiveInventory("PB_LockScreenTilt", 1);
			A_PlaySound("weapons/antitank/deploy", CHAN_AUTO);
		}
		FUIL DCBA 1;
		TNT1 A 0 A_TakeInventory("PB_LockScreenTilt", 1);
		Goto Ready3;

	Select:
		TNT1 A 0
		{
			A_WeaponOffset(0, 32);
			A_SetRoll(0);
			A_TakeInventory("PB_LockScreenTilt", 1);
			A_TakeInventory("HasBarrel", 1);
			A_TakeInventory("HasIceBarrel", 1);
			A_TakeInventory("HasBurningBarrel", 1);
			A_TakeInventory("GrabbedBarrel", 1);
			A_TakeInventory("GrabbedIceBarrel", 1);
			A_TakeInventory("GrabbedBurningBarrel", 1);
		}
		Goto SelectFirstPersonLegs;

	SelectContinue:
		TNT1 A 0 A_Raise;
		Goto Ready3;

	SelectAnimation:
		TNT1 A 0 A_PlaySound("weapons/antitank/deploy", CHAN_AUTO);
		FUIL DCBA 1;
		Goto Ready3;

	Deselect:
		TNT1 A 0
		{
			A_WeaponOffset(0, 32);
			A_SetRoll(0);
			A_TakeInventory("PB_LockScreenTilt", 1);
			A_ZoomFactor(1.0);
		}
		FUIL ABCD 1;
		TNT1 AAAAAAAAAAAAAAAAAA 0 A_Lower;
		TNT1 A 1 A_Lower;
		Wait;

	Ready3:
		TNT1 A 0
		{
			A_ClearOverlays(10, 11);
			A_SetRoll(0);
			PB_HandleCrosshair(76);
			A_TakeInventory("PB_LockScreenTilt", 1);
			A_ZoomFactor(1.0);
		}
	ReadyToFire:
		PAPA A 1
		{
			return PB_ReadyFire("Fire", "Fire", "Ready3", false, false, "PB_AntiTankMag", true);
		}
		Loop;

	WeaponSpecial:
		TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "IdleBarrel");
		TNT1 A 0 A_JumpIfInventory("GrabbedBurningBarrel", 1, "IdleFlameBarrel");
		TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "IdleIceBarrel");
		TNT1 A 0
		{
			A_TakeInventory("GoWeaponSpecialAbility", 1);
			A_GiveInventory("PB_LockScreenTilt", 1);
			PB_HandleCrosshair(76);
			A_ClearOverlays(10, 11);
		}
		TNT1 A 0 A_JumpIfInventory("Select_ATR_Single", 1, "ATR_SetSingle");
		TNT1 A 0 A_JumpIfInventory("Select_ATR_Burst", 1, "ATR_SetBurst");
		TNT1 A 0 A_JumpIfInventory("Select_ATR_VoidGrenade", 1, "ATR_SetVoid");
		Goto Ready3;

	ATR_SetSingle:
		TNT1 A 0
		{
			A_TakeInventory("Select_ATR_Single", 1);
			A_TakeInventory("Select_ATR_Burst", 1);
			A_TakeInventory("Select_ATR_VoidGrenade", 1);
			A_TakeInventory("ATR_BurstMode", 1);
			A_TakeInventory("ATR_VoidGrenadeMode", 1);
			A_Print("\cdMode:\c- \cjExplosive Bolt");
			A_TakeInventory("PB_LockScreenTilt", 1);
		}
		Goto Ready3;

	ATR_SetBurst:
		TNT1 A 0
		{
			A_TakeInventory("Select_ATR_Single", 1);
			A_TakeInventory("Select_ATR_Burst", 1);
			A_TakeInventory("Select_ATR_VoidGrenade", 1);
			A_GiveInventory("ATR_BurstMode", 1);
			A_TakeInventory("ATR_VoidGrenadeMode", 1);
			A_Print("\cdMode:\c- \cj3-Round Burst");
			A_TakeInventory("PB_LockScreenTilt", 1);
		}
		Goto Ready3;

	ATR_SetVoid:
		TNT1 A 0
		{
			A_TakeInventory("Select_ATR_Single", 1);
			A_TakeInventory("Select_ATR_Burst", 1);
			A_TakeInventory("Select_ATR_VoidGrenade", 1);
			A_TakeInventory("ATR_BurstMode", 1);
			A_GiveInventory("ATR_VoidGrenadeMode", 1);
			A_Print("\cdMode:\c- \ctVoid Grenade");
			A_TakeInventory("PB_LockScreenTilt", 1);
		}
		Goto Ready3;

	Fire:
		TNT1 A 0 A_JumpIfInventory("GrabbedBarrel", 1, "ThrowBarrel");
		TNT1 A 0 A_JumpIfInventory("GrabbedBurningBarrel", 1, "ThrowFlameBarrel");
		TNT1 A 0 A_JumpIfInventory("GrabbedIceBarrel", 1, "ThrowIceBarrel");
		TNT1 A 0
		{
			A_WeaponOffset(0, 32);
			A_SetRoll(0);
			A_TakeInventory("PB_LockScreenTilt", 1);
			if (CountInv("GoFatality") >= 1) { SetPlayerProperty(0, 1, 0); }
			else { SetPlayerProperty(0, 0, 0); SetPlayerProperty(0, 0, PROP_TOTALLYFROZEN); }
		}
		TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady");
		TNT1 A 0 A_JumpIfInventory("ATR_VoidGrenadeMode", 1, "FireVoid");
		TNT1 A 0 A_JumpIfInventory("ATR_BurstMode", 1, "FireBurst");
		Goto FireSingle;

	FireSingle:
		TNT1 A 0 A_JumpIfInventory("PB_AntiTankMag", 1, 2);
		Goto Reload;
		TNT1 AA 0;
		TNT1 A 0 A_AlertMonsters;
		PAPA A 0 A_PlaySound("weapons/antitank/fire", CHAN_WEAPON);
		PAPA A 1 Bright
		{
			A_FireProjectile("PB_AntiTankExplosiveProjectile", frandom(-0.4, 0.4), 0, 0, 0, FPF_NOAUTOAIM, frandom(-0.4, 0.4));
			A_FireCustomMissile("YellowFlareSpawn", 0, 0, 0, 0);
			A_SpawnItemEx("PlayerMuzzle1", 30, 5, 30);
			A_GunFlash();
			A_TakeInventory("PB_AntiTankMag", 1);
		}
		PAPA BC 1;
		PAPA D 1 A_ZoomFactor(0.97);
		PAPU BBBBAAA 1;
		PAPA E 2 A_ZoomFactor(0.98);
		PAPA F 1 A_ZoomFactor(0.99);
		TNT1 A 0 A_ZoomFactor(1.0);
		TNT1 A 0 A_FireCustomMissile("RifleCaseSpawn", 5, 0, 6, -14);
		PAPA GH 1;
		Goto Pump;

	FireBurst:
		TNT1 A 0 A_JumpIfInventory("PB_AntiTankMag", 3, 2);
		Goto Reload;
		TNT1 AA 0;
		TNT1 A 0 A_AlertMonsters;
		PAPA A 0 A_PlaySound("weapons/antitank/fire", CHAN_WEAPON);
		PAPA A 1 Bright
		{
			A_FireProjectile("PB_AntiTankExplosiveProjectile", frandom(-1.2, 1.2), 0, 0, 0, FPF_NOAUTOAIM, frandom(-1.0, 1.0));
			A_SpawnItemEx("PlayerMuzzle1", 30, 5, 30);
			A_GunFlash();
			A_TakeInventory("PB_AntiTankMag", 1);
		}
		PAPA B 1;
		PAPA A 0 A_PlaySound("weapons/antitank/fire", CHAN_WEAPON);
		PAPA A 1 Bright
		{
			A_FireProjectile("PB_AntiTankExplosiveProjectile", frandom(-1.2, 1.2), 0, 0, 0, FPF_NOAUTOAIM, frandom(-1.0, 1.0));
			A_GunFlash();
			A_TakeInventory("PB_AntiTankMag", 1);
		}
		PAPA B 1;
		PAPA A 0 A_PlaySound("weapons/antitank/fire", CHAN_WEAPON);
		PAPA A 1 Bright
		{
			A_FireProjectile("PB_AntiTankExplosiveProjectile", frandom(-1.2, 1.2), 0, 0, 0, FPF_NOAUTOAIM, frandom(-1.0, 1.0));
			A_GunFlash();
			A_TakeInventory("PB_AntiTankMag", 1);
		}
		PAPA CD 1;
		PAPU BBBAAA 1;
		PAPA EF 1;
		TNT1 A 0 A_FireCustomMissile("RifleCaseSpawn", 5, 0, 6, -14);
		PAPA GH 1;
		Goto Pump;

	FireVoid:
		TNT1 A 0 A_JumpIfInventory("PB_AntiTankMag", 1, 2);
		Goto Reload;
		TNT1 AA 0;
		TNT1 A 0 A_AlertMonsters;
		PAPA A 0 A_PlaySound("weapons/antitank/fire", CHAN_WEAPON);
		PAPA A 1 Bright
		{
			A_FireProjectile("PB_AntiTankVoidGrenade", 0, 0, 0, 0, FPF_NOAUTOAIM, -2);
			A_FireCustomMissile("YellowFlareSpawn", 0, 0, 0, 0);
			A_SpawnItemEx("PlayerMuzzle1", 30, 5, 30);
			A_GunFlash();
			A_TakeInventory("PB_AntiTankMag", 1);
		}
		PAPA BCDEF 1;
		PAPU BBBAAA 1;
		PAPA GH 1;
		Goto Pump;

	Pump:
		TNT1 A 0 A_PlaySound("weapons/antitank/bolt", CHAN_AUTO);
		HIJO CBA 1;
		PAPA J 1;
		PAPA ZZ 1;
		PAPA ZYXW 1;
		PAPA KLM 1;
		TNT1 A 0 A_PlaySound("weapons/antitank/clack", 3);
		TNT1 A 0 A_FireCustomMissile("SmokeSpawner", random(-1, 1), 0, 0, 0, 0, random(-1, 1));
		PAPA NOOPQ 1;
		PAPA RS 1;
		PAPA TTUVWXYZ 1;
		HIJO ABC 1;
		PAPA A 1;
		FUIL ZYX 1;
		TNT1 A 0 A_ReFire;
		Goto Ready3;

	Reload:
		TNT1 A 0 A_JumpIfInventory("PB_AntiTankMag", 5, "Ready3");
		TNT1 A 0 A_JumpIfInventory("NewClip", 1, "ReloadContinue");
		Goto Ready3;
	ReloadContinue:
		TNT1 A 0 A_TakeInventory("Reloading", 1);
		HIJO CBA 1;
		PAPA J 1;
		PAPA ZZ 1;
		PAPA ZY 1;
	ReloadLoop:
		TNT1 A 0 A_JumpIfInventory("PB_AntiTankMag", 5, "ReloadFinish");
		TNT1 A 0 A_JumpIfInventory("NewClip", 2, 2);
		Goto ReloadFinish;
		TNT1 AA 0;
		SILL EEFG 2 A_WeaponReady(WRF_NOFIRE);
		TNT1 A 0 A_PlaySound("weapons/leveraction/loadshell", CHAN_AUTO);
		SILL HIJ 1 A_WeaponReady(WRF_NOFIRE);
		TNT1 A 0
		{
			A_GiveInventory("PB_AntiTankMag", 1);
			A_TakeInventory("NewClip", 2);
		}
		Loop;
	ReloadFinish:
		SILL DCBA 1;
		PAPA ZZ 1;
		PAPA ZYXW 1;
		PAPA KLM 1;
		TNT1 A 0 A_PlaySound("weapons/antitank/clack", 3);
		PAPA NOOPQ 1;
		PAPA RS 1;
		PAPA TTUVWXYZ 1;
		HIJO ABC 1;
		PAPA A 1;
		FUIL ZYX 1;
		TNT1 A 0 A_TakeInventory("Reloading", 1);
		TNT1 A 0 A_ReFire;
		Goto Ready3;

	FlashPunching:
		PAPA A 1;
		Goto Ready3;

	FlashKicking:
		PAPA A 1;
		Goto Ready3;
	}
}
