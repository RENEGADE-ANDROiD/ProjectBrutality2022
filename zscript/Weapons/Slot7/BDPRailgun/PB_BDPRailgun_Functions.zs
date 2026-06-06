extend class PB_BDPRailgun
{
	override void PostBeginPlay()
	{
		scopeZoom = false;
		Super.PostBeginPlay();
	}

	action void A_GunLight(int intensity = 500, int alivetime = 2, int lightr = 255, int lightg = 237, int lightb = 162)
	{
		let selfLight1 = BDP_GunLight(Spawn("BDP_GunLight", (invoker.owner.pos.x, invoker.owner.pos.y, invoker.owner.pos.z + invoker.owner.player.viewheight), false));
		if (!selfLight1)
			return;
		selfLight1.args[DynamicLight.LIGHT_RED] = lightr;
		selfLight1.args[DynamicLight.LIGHT_GREEN] = lightg;
		selfLight1.args[DynamicLight.LIGHT_BLUE] = lightb;
		selfLight1.args[DynamicLight.LIGHT_INTENSITY] = intensity;
		selfLight1.SpotInnerAngle = 60;
		selfLight1.SpotOuterAngle = 90;
		selfLight1.angle = invoker.owner.angle;
		selfLight1.pitch = invoker.owner.pitch;
		selfLight1.alivetime = alivetime;
	}

	action state A_PressingReload()
	{
		if ((player.cmd.buttons & BT_RELOAD) || (player.oldbuttons & BT_RELOAD))
			return ResolveState("ReloadFromPump");
		return ResolveState(null);
	}

	action void A_Recoil3D(double amt)
	{
		vel += PB_Math.VecFromAngles(angle, pitch, -amt);
	}

	action void A_HandleScope()
	{
		if (!invoker.scopeZoom)
		{
			A_StartSound("BEP");
			invoker.scopeZoom = true;
		}
		else
		{
			A_StartSound("BEPBEP");
			invoker.scopeZoom = false;
		}
		A_ZoomFactor(invoker.scopeZoom ? highfactor : lowfactor);
	}

	action void A_SpawnHologram()
	{
		A_SpawnItemEx("PBCF_CF_HoloDecoyPlacer", 0, 0, 0, 0, 0, 0, 0, SXF_SETMASTER | SXF_NOCHECKPOSITION);
	}

	action void A_FireNuRailgun()
	{
		FLineTraceData railspawn;
		LineTrace(angle, 8192, pitch, TRF_NOSKY | TRF_THRUACTORS, player.viewz - player.mo.pos.z - 5, data: railspawn);
		if (railspawn.HitType != TRACE_HitNone)
		{
			vector3 targetpos = railspawn.HitLocation;
			if (railspawn.HitLine)
			{
				vector2 wallnormal = (-railspawn.HitLine.delta.y, railspawn.HitLine.delta.x).unit();
				if (!railspawn.LineSide)
					wallnormal *= -1;
				targetpos += (wallnormal * 3);
			}

			let beam = Actor(Spawn("RailgunRail", targetpos));
			if (beam)
			{
				beam.angle = angle;
				beam.pitch = pitch;
			}

			for (int i = 0; i < 20; i++)
			{
				let rico = Actor(Spawn("RicoChet", targetpos));
				if (rico)
					rico.angle = angle + 180;
			}
		}

		vector3 trailpos = (pos.x - railspawn.HitLocation.x, pos.y - railspawn.HitLocation.y, pos.z + player.viewz - player.mo.pos.z - 5 - railspawn.HitLocation.z);
		for (int i = int(railspawn.distance); i > 0; i -= 2)
		{
			let trail = Level.SpawnVisualThinker("RailgunTrail");
			if (!trail)
				continue;
			trail.pos = railspawn.HitLocation + trailpos * (i / railspawn.distance);
			trail.pos += (frandom(1, -1), frandom(1, -1), frandom(1, -1));
		}

		PB_SetChamberEmpty(true);
		PB_IncrementHeat(10);
		A_Fireprojectile("RailgunProjectile", 0, 0, 0, 0);
		A_alertmonsters(500);
		A_RailAttack(bdpraildamage, 0, 0, "", "", 0, 0, "RailgunPuff1");
		A_Fireprojectile("PlasmaSmoke", 0, 0, 0, 2);
		A_StartSound("weapons/bdprailgun/fire", 1);
		PB_TakeAmmo(invoker.ammotype2, 1, 0);
		PB_WeaponRecoil(6, 0);
		if (invoker.owner.pos.z <= invoker.owner.floorz)
			A_Recoil3D(3);
		else
			A_Recoil3D(20);
	}
}
