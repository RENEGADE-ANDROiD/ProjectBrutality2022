class cl_CaptainController : cl_BaseController
	{
	int minionCount;
	Actor ring;

	override color GetParticleColour()
		{
		static const color Colours[] = { "ffd700", "ffcc00", "ffe066", "ffffff" };
		return Colours[random(0, Colours.Size() - 1)];
		}

	override void cl_GiveToken()
		{
		champion.A_GiveInventory("cl_CaptainToken");
		}

	void cl_EnsureRing()
		{
		if (ring && ring.master == champion)
			return;

		let spawned = cl_CaptainRing(champion.Spawn("cl_CaptainRing", champion.pos));
		if (spawned)
			{
			spawned.master = champion;
			ring = spawned;
			}
		}

	void cl_SyncMinionFlag()
		{
		if (!champion)
			return;
		if (minionCount > 0)
			{
			if (!champion.CountInv("cl_CaptainHasMinions"))
				champion.A_GiveInventory("cl_CaptainHasMinions");
			}
		else
			champion.A_TakeInventory("cl_CaptainHasMinions");
		}

	override void cl_InitEffect()
		{
		eftic = 8;
		champion.Health = int(champion.Health * 1.35);
		champion.A_GiveInventory("cl_CaptainShieldGiver");
		if (traitFX && cl_CosmeticFXVisible())
			cl_EnsureRing();
		}

	override void cl_TickEffect()
		{
		if (!cl_Static.cl_ActorIsUsable(champion))
			return;

		int radius = cl_Static.cl_ReturnCVAR("cl_captain_radius");
		minionCount = 0;

		BlockThingsIterator it = BlockThingsIterator.Create(champion, radius);
		while (it.Next())
			{
			Actor mo = it.thing;
			if (mo == champion)
				continue;
			if (!mo.bISMONSTER)
				continue;
			if (!cl_Static.cl_ActorIsUsable(mo))
				continue;
			if (mo.bBOSS || mo.bSPECIAL)
				continue;
			if (mo.CountInv("cl_CaptainToken") || mo.CountInv("cl_BulwarkToken"))
				continue;
			if (champion.Distance2D(mo) > radius)
				continue;
			if (!champion.CheckSight(mo))
				continue;

			mo.A_GiveInventory("cl_CaptainBuffGiver");
			minionCount++;
			}

		cl_SyncMinionFlag();

		if (traitFX && cl_CosmeticFXVisible())
			cl_EnsureRing();
		}

	override void cl_DeathEffect()
		{
		if (champion)
			champion.A_TakeInventory("cl_CaptainHasMinions");
		if (traitFX && cl_CosmeticFXVisible())
			champion.A_SpawnItemEx("cl_SpawnBurst", flags: SXF_TRANSFERTRANSLATION | SXF_NOCHECKPOSITION);
		}
	}
