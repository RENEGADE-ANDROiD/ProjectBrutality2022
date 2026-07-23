// PBX-Weapons Paingiver enrage — adapted to PB2022 (PB_DTech fuel).
// DECORATE Paingiver cannot be reliably `extend`ed on this ZScript pin, so
// enrage runtime lives on a companion inventory (same pattern as wear helpers).

class PaingiverEnrageToken : Inventory
{
	Default
	{
		Inventory.MaxAmount 1;
		+INVENTORY.UNDROPPABLE;
		+INVENTORY.UNTOSSABLE;
	}

	const PAINGIVER_ENRAGE_DRAIN = 3;

	override void DoEffect()
	{
		Super.DoEffect();
		if (!owner || !owner.player)
			return;
		if (!(owner.player.readyweapon is "Paingiver"))
			return;

		if (owner.CountInv("PB_DTech") <= 0)
		{
			owner.A_StartSound("UNMSWT2", CHAN_WEAPON);
			owner.A_StopSound(6);
			owner.A_Print("\cgEnraged Paingiver\c- depleted");
			owner.TakeInventory("PaingiverEnrageToken", 1);
			return;
		}
		owner.TakeInventory("PB_DTech", PAINGIVER_ENRAGE_DRAIN, TIF_NOTAKEINFINITE);
	}

	override void ModifyDamage(int damage, Name damageType, out int newDamage,
		bool passive, Actor inflictor, Actor source, int flags)
	{
		if (passive && damage > 0
			&& owner && owner.player
			&& owner.player.readyweapon is "Paingiver")
		{
			newDamage = damage / 4;
		}
	}
}

extend class PB_WeaponBase
{
	const PAINGIVER_ENRAGE_MIN = 250;

	action void Paingiver_ReadyIdleSound()
	{
		if (!(invoker is "Paingiver"))
			return;
		if (CountInv("PaingiverEnrageToken") > 0)
			A_PlaySound("UNOCIDL", 6, 1, 1);
		else
			A_StopSound(6);
	}

	action void Paingiver_RefundShotIfEnraged()
	{
		if (!(invoker is "Paingiver"))
			return;
		if (CountInv("PaingiverEnrageToken") > 0)
			A_GiveInventory("RocketAmmo", 1);
	}

	action state Paingiver_TryEnrage()
	{
		if (!(invoker is "Paingiver"))
			return ResolveState("Ready3");
		if (CountInv("PaingiverEnrageToken") > 0 || CountInv("PB_DTech") < PAINGIVER_ENRAGE_MIN)
		{
			A_StartSound("UNMWARN", 7);
			if (CountInv("PaingiverEnrageToken") > 0)
				A_Print("\cgAlready enraged\c-");
			else
				A_Print("\cgNot enough Demon Tech\c- (need 250+)");
			return ResolveState("Ready3");
		}
		A_GiveInventory("PaingiverEnrageToken", 1);
		A_FireCustomMissile("MancubusSwitchModeEffect", 0, 0, 0, random(1, 3));
		A_StartSound("unmaker/switch", CHAN_AUTO, CHANF_OVERLAP);
		A_Print("\cgEnraged Paingiver\c- (Demon Tech)");
		return ResolveState(null);
	}
}
