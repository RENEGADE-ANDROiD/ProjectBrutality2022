// Orbiting flat electric shield panels for Thunder Crossbow alt-fire hold.

class PB_ThunderCrossbowShieldPanel : Actor
{
	int segIndex;
	int segCount;

	Default
	{
		+NOINTERACTION;
		+NOGRAVITY;
		+FORCEXYBILLBOARD;
		RenderStyle "Add";
		Alpha 0.55;
		Scale 0.22;
	}

	States
	{
	Spawn:
		STFL A 1 Bright A_SetScale(0.22, 0.07);
		Loop;
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		A_SetScale(0.22, 0.07);
	}

	void UpdateOrbit(PB_ThunderCrossbowShieldRing ring)
	{
		if (!ring || !ring.master)
			return;

		let mo = ring.master;
		double step = 360.0 / segCount;
		double a = (ring.orbitAngle + segIndex * step) * 0.017453292519943295;
		double rad = 44.0;
		double z = mo.pos.z + mo.height * 0.42;
		SetOrigin((mo.pos.x + cos(a) * rad, mo.pos.y + sin(a) * rad, z), false);
		Angle = ring.orbitAngle + segIndex * step;
	}
}

class PB_ThunderCrossbowShieldRing : Actor
{
	int orbitAngle;
	int segCount;
	int fxTic;
	Array<Actor> panels;

	Default
	{
		+NOINTERACTION;
		+NOGRAVITY;
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		segCount = 10;
		orbitAngle = random(0, 359);

		for (int i = 0; i < segCount; i++)
		{
			let p = PB_ThunderCrossbowShieldPanel(Actor.Spawn("PB_ThunderCrossbowShieldPanel", Pos, NO_REPLACE));
			if (!p)
				continue;
			p.segIndex = i;
			p.segCount = segCount;
			p.target = self;
			panels.Push(p);
		}
	}

	override void Tick()
	{
		Super.Tick();

		if (!master || master.health < 1 || master.CountInv("PB_ThunderCrossbowShieldActive") < 1)
		{
			CleanupAndDestroy();
			return;
		}

		orbitAngle = (orbitAngle + 4) % 360;
		A_Warp(AAPTR_MASTER, 0, 0, 0, 0, WARPF_NOCHECKPOSITION);

		for (int i = 0; i < panels.Size(); i++)
		{
			let pan = panels[i];
			if (!pan)
				continue;
			let panel = PB_ThunderCrossbowShieldPanel(pan);
			if (panel)
				panel.UpdateOrbit(self);
		}

		if ((fxTic++ & 3) == 0)
		{
			let mo = master;
			double a0 = orbitAngle * 0.017453292519943295;
			double rad = 44.0;
			double z = mo.pos.z + mo.height * 0.42;
			Vector3 sparkPos = (mo.pos.x + cos(a0) * rad, mo.pos.y + sin(a0) * rad, z);
			Actor.Spawn("LightningBeamSpark", sparkPos, NO_REPLACE);
		}
	}

	void CleanupAndDestroy()
	{
		if (master)
			master.A_TakeInventory("PB_ThunderCrossbowShieldRingLive", 1);

		for (int i = 0; i < panels.Size(); i++)
		{
			if (panels[i])
				panels[i].Destroy();
		}
		panels.Clear();
		Destroy();
	}
}
