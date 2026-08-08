// Holstered-weapon mag refill from reserve (PBX-Addons BackpackReload, PB2022-native).

class PB2022_BackpackReloadItem : Inventory
{
	Default
	{
		Inventory.MaxAmount 1;
		+INVENTORY.UNDROPPABLE;
		+INVENTORY.UNTOSSABLE;
	}

	static const Name PB_noreloadweapons[] =
	{
		'PB_Unmaker',
		'PB_DemonExterminator'
	};

	override void Tick()
	{
		// Always on (Weapon Settings toggle removed); ignore leftover Off / disable-bit configs.
		let cvTime = CVar.FindCVar("pb_pbx_backpackreload_time");
		int interval = cvTime ? cvTime.GetInt() : 70;
		if (interval < 1) interval = 70;
		if (GetAge() % interval != 0)
			return;

		RefillWeapons();
	}

	void RefillWeapons()
	{
		if (!owner || !owner.player)
			return;

		for (Inventory item = owner.Inv; item != null; item = item.Inv)
		{
			if (!(item is "PB_WeaponBase"))
				continue;

			let wep = PB_WeaponBase(item);
			if (!wep)
				continue;

			if (wep.GetClassName() == owner.player.ReadyWeapon.GetClassName())
				continue;

			if (!IsReloadable(wep))
				continue;

			if (!wep.ammo1 || !wep.ammo2)
				continue;

			if (wep.ammo1.Amount < 1 && !HasInfiniteAmmo(owner))
				continue;

			ReloadWeapon(wep, wep.ammo1, wep.ammo2, false);

			if (wep.akimboMode && wep.Amount > 1 && wep.ammoLeft)
				ReloadWeapon(wep, wep.ammo1, wep.ammoLeft, true);
		}
	}

	void ReloadWeapon(PB_WeaponBase wep, Ammo am1, Ammo am2, bool isLeft = false)
	{
		int cur = am2.Amount;
		int maxm = am2.MaxAmount;
		int res = am1.Amount;
		int eq = wep.ReserveToMagAmmoFactor;
		if (eq < 1) eq = 1;
		if (res < eq)
			return;

		let cvRef = CVar.FindCVar("pb_pbx_backpackreload_refill");
		int refPerTick = cvRef ? cvRef.GetInt() : 5;
		if (refPerTick < 1) refPerTick = 1;

		if (cur < maxm && res >= eq)
		{
			int pending = maxm - cur;
			pending = min(pending, refPerTick);
			int releq = pending * eq;
			int amt = min(releq, res);
			int giveam = amt / eq;
			if (giveam < 1)
				return;

			owner.A_GiveInventory(am2.GetClassName(), giveam);
			owner.A_TakeInventory(am1.GetClassName(), int(giveam * eq), TIF_NOTAKEINFINITE);
			ResetStagedReload(wep, isLeft);

			let cvTell = CVar.FindCVar("pb_pbx_backpackreload_notify");
			if (cvTell && cvTell.GetBool() && am2.Amount >= maxm)
				Console.Printf("%s%s\c- reloaded.", isLeft ? "Left " : "", wep.GetTag());
		}
	}

	void ResetStagedReload(PB_WeaponBase wep, bool isLeft = false)
	{
		if (isLeft)
		{
			wep.leftChamberEmpty = false;
			wep.leftMagEmpty = false;
			wep.leftMagUnloaded = false;
		}
		else
		{
			wep.chamberEmpty = false;
			wep.magEmpty = false;
			wep.magUnloaded = false;
		}
	}

	bool HasInfiniteAmmo(Actor who)
	{
		return sv_infiniteammo || who.FindInventory("PowerInfiniteAmmo", true) != null;
	}

	bool IsReloadable(PB_WeaponBase wep)
	{
		if (!wep.ammo1 || !wep.ammo2)
			return false;

		Name cn = wep.GetClassName();
		for (int i = 0; i < PB_noreloadweapons.Size(); i++)
		{
			if (cn == PB_noreloadweapons[i])
				return false;
		}
		return true;
	}
}
