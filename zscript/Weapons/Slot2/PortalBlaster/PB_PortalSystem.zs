// Invisible centered portal placers (Damage 0) + barrel-offset colored damage blasts.
// Placement ACS runs only from placers; blasts never call InitPortal.

class PB_PortalBoltBase : FastProjectile
{
	int portalType; // 0 = A (red / right), 1 = B (blue / left)

	override void BeginPlay()
	{
		Super.BeginPlay();
		if (!master)
			master = target;
		if (!tracer)
			tracer = target;
		if (!target && master)
			target = master;
	}

	Default
	{
		Speed 256;
		Radius 8;
		Height 16;
		Damage 0;
		DamageType "Normal";
		+CANNOTPUSH
		+NODAMAGETHRUST
		+SPAWNSOUNDSOURCE
		+NOBLOOD
		+FORCEXYBILLBOARD
		+THRUACTORS
		-DONTSPLASH
		RenderStyle "None";
		Alpha 0;
		Scale 0.1;
	}

	States
	{
	Death:
		TNT1 A 0
		{
			ACS_NamedExecuteAlways("PB_Portal_InitPortal", 0, portalType);
		}
		Stop;
	}
}

// Right / Fire — invisible placer
class PB_PortalBoltA : PB_PortalBoltBase
{
	override void BeginPlay()
	{
		Super.BeginPlay();
		portalType = 0;
	}

	States
	{
	Spawn:
		TNT1 A 1;
		Loop;
	Death:
		TNT1 A 0
		{
			ACS_NamedExecuteAlways("PB_Portal_InitPortal", 0, 0);
		}
		TNT1 A 0 A_SpawnItemEx("RedFlare", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION | SXF_CLIENTSIDE);
		TNT1 A 1;
		Stop;
	}
}

// Left / AltFire — invisible placer
class PB_PortalBoltB : PB_PortalBoltBase
{
	override void BeginPlay()
	{
		Super.BeginPlay();
		portalType = 1;
	}

	States
	{
	Spawn:
		TNT1 A 1;
		Loop;
	Death:
		TNT1 A 0
		{
			ACS_NamedExecuteAlways("PB_Portal_InitPortal", 0, 1);
		}
		TNT1 A 0 A_SpawnItemEx("BlueFlareSmall", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION | SXF_CLIENTSIDE);
		TNT1 A 1;
		Stop;
	}
}

// Visible red damage blast from right barrel — never places portals
class PB_PortalBlastA : FastProjectile
{
	Default
	{
		Speed 256;
		Radius 6;
		Height 8;
		Damage 2;
		DamageType "Stun";
		+CANNOTPUSH
		+NODAMAGETHRUST
		+SPAWNSOUNDSOURCE
		+BLOODSPLATTER
		+FORCEXYBILLBOARD
		-DONTSPLASH
		RenderStyle "Add";
		Alpha 0.85;
		Scale 0.3;
	}

	States
	{
	Spawn:
		TNT1 A 1 Bright
		{
			PB_PortalFX.SpawnRedTrail(pos);
		}
		Loop;
	Death:
		TNT1 A 0 A_SpawnItemEx("RedFlare", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION | SXF_CLIENTSIDE);
		TNT1 AAA 0 A_SpawnItemEx("ObeliskTrailSpark", frandom(-8, 8), frandom(-8, 8), frandom(-2, 2), 0, 0, 0, 0, SXF_NOCHECKPOSITION | SXF_CLIENTSIDE);
		TNT1 A 1;
		Stop;
	}
}

// Visible blue damage blast from left barrel — never places portals
class PB_PortalBlastB : FastProjectile
{
	Default
	{
		Speed 256;
		Radius 6;
		Height 8;
		Damage 2;
		DamageType "Stun";
		+CANNOTPUSH
		+NODAMAGETHRUST
		+SPAWNSOUNDSOURCE
		+BLOODSPLATTER
		+FORCEXYBILLBOARD
		-DONTSPLASH
		Decal "BulletChip";
		RenderStyle "Add";
		Alpha 0.35;
		Scale 0.3;
	}

	States
	{
	Spawn:
		TNT1 A 1 Bright
		{
			PB_PortalFX.SpawnCombatTrail(pos);
		}
		Loop;
	Death:
		TNT1 A 0 A_SpawnItemEx("DetectFloorBullet", 0, 0, 5, 0, 0, 0, 0, SXF_NOCHECKPOSITION);
		TNT1 A 0 A_SpawnItemEx("DetectCeilBullet", 0, 0, 0, -5, 0, 0, 0, SXF_NOCHECKPOSITION);
		TNT1 AAAAA 0 A_SpawnItemEx("BlueFlareSmall", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION | SXF_CLIENTSIDE);
		TNT1 AAAAA 0 A_SpawnProjectile("BluePlasmaParticle", 0, 0, random(0, 360), CMF_AIMDIRECTION, random(0, 360));
		BL1I ABC 1 Bright A_SpawnItemEx("BlueFlareSmall", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION | SXF_CLIENTSIDE);
		TNT1 AA 3 A_SpawnProjectile("PlasmaSmoke", 1, 0, random(0, 360), CMF_AIMDIRECTION, random(0, 160));
		Stop;
	}
}

class PB_PortalCameraBase : Actor
{
	int portalHue; // 0 red, 1 blue
	int user_portalKind; // 0 wall, 1 floor, 2 ceil — written from ACS
	int user_hasLookPlane; // 1 when floor/ceil LookPlane owns the rim

	Default
	{
		Radius 1;
		Height 2;
		+NOINTERACTION
		+NOBLOCKMAP
		+NOGRAVITY
	}

	override void Tick()
	{
		Super.Tick();
		// Skip GLDEFS PulseLight (TNT1 A) in low graphics; wall rim still gated inside SpawnRim.
		if (PB_PortalFX.LowGfx())
		{
			if (!InStateSequence(CurState, ResolveState("NoGlow")))
				SetStateLabel("NoGlow");
			return;
		}
		if (!InStateSequence(CurState, ResolveState("Spawn")))
			SetStateLabel("Spawn");
		// Wall rim only. Floor/ceil pad is owned by LookPlane.
		if (user_portalKind == 0 && (level.maptime & 1) == 0)
			PB_PortalFX.SpawnRim(Pos, Angle, portalHue, 0);
	}

	States
	{
	Spawn:
		TNT1 A -1;
		Stop;
	NoGlow:
		TNT1 B -1;
		Stop;
	}
}

class PB_PortalCameraA : PB_PortalCameraBase
{
	override void BeginPlay()
	{
		Super.BeginPlay();
		portalHue = 0;
	}
}

class PB_PortalCameraB : PB_PortalCameraBase
{
	override void BeginPlay()
	{
		Super.BeginPlay();
		portalHue = 1;
	}
}

// Invisible floor/ceiling portal marker. Owns the 64x64 particle pad (no PORTX pane).
class PB_PortalLookPlane : Actor
{
	int user_camTexNum; // unused for visuals; kept for ACS compatibility
	int user_portalKind;
	int user_portalHue; // 0 red, 1 blue — set from ACS even when unpaired
	Actor padGlow;
	int padGlowHue;

	Default
	{
		Radius 1;
		Height 1;
		+NOINTERACTION
		+NOBLOCKMAP
		+NOGRAVITY
		+NOCLIP
		RenderStyle "None";
		Alpha 0;
	}

	override void OnDestroy()
	{
		if (padGlow)
		{
			padGlow.Destroy();
			padGlow = null;
		}
		Super.OnDestroy();
	}

	void UpdatePadGlow()
	{
		if (PB_PortalFX.LowGfx())
		{
			if (padGlow)
			{
				padGlow.Destroy();
				padGlow = null;
			}
			return;
		}

		if (!padGlow || padGlowHue != user_portalHue)
		{
			if (padGlow)
				padGlow.Destroy();
			padGlow = null;
			if (user_portalHue == 0)
				padGlow = Spawn("PB_PortalPadGlowA", Pos, ALLOW_REPLACE);
			else
				padGlow = Spawn("PB_PortalPadGlowB", Pos, ALLOW_REPLACE);
			padGlowHue = user_portalHue;
		}
		if (padGlow)
			padGlow.SetOrigin(Pos, true);
	}

	override void Tick()
	{
		Super.Tick();
		if ((level.maptime & 1) == 0)
			PB_PortalFX.SpawnPlanePad(Pos, Angle, user_portalHue, user_portalKind);
		UpdatePadGlow();
	}

	States
	{
	Spawn:
		TNT1 A -1;
		Stop;
	}
}

class PB_PortalFX play
{
	static bool LowGfx()
	{
		let cv = CVar.FindCVar("pb_lowgraphicsmode");
		return cv && cv.GetInt();
	}

	// Unit forward (long) + right (short) for horizontal portal plane math.
	static Vector2 PlaneFwd(double ang)
	{
		return (cos(ang), sin(ang));
	}

	static Vector2 PlaneRight(double ang)
	{
		return (-sin(ang), cos(ang));
	}

	static void SpawnCombatTrail(Vector3 p)
	{
		if (LowGfx()) return;
		FSpawnParticleParams sp;
		sp.color1 = "60B0FF";
		sp.lifetime = 6;
		sp.size = 3.2;
		sp.sizeStep = -0.35;
		sp.startAlpha = 0.85;
		sp.fadeStep = 0.12;
		sp.flags = SPF_FULLBRIGHT;
		sp.pos = p;
		Level.SpawnParticle(sp);
	}

	static void SpawnRedTrail(Vector3 p)
	{
		if (LowGfx()) return;
		FSpawnParticleParams sp;
		sp.color1 = "FF4020";
		sp.lifetime = 6;
		sp.size = 3.2;
		sp.sizeStep = -0.35;
		sp.startAlpha = 0.85;
		sp.fadeStep = 0.12;
		sp.flags = SPF_FULLBRIGHT;
		sp.pos = p;
		Level.SpawnParticle(sp);
	}

	static void SpawnRim(Vector3 center, double ang, int hue, int kind = 0)
	{
		SpawnRimPlane(center, ang, hue, kind, 32.0, 64.0);
	}

	// Floor/ceil: 64x64 pad — rim + interior grid with pulsing alpha/size.
	static void SpawnPlanePad(Vector3 center, double ang, int hue, int kind)
	{
		if (LowGfx())
		{
			SpawnRimPlane(center, ang, hue, kind, 32.0, 32.0);
			return;
		}

		double half = 32.0;
		Vector2 fwd = PlaneFwd(ang);
		Vector2 right = PlaneRight(ang);
		double zOff = (kind == 2) ? -2.0 : 2.0;

		FSpawnParticleParams sp;
		if (hue == 0)
			sp.color1 = "FF4020";
		else
			sp.color1 = "3080FF";
		sp.lifetime = 5;
		sp.sizeStep = -0.25;
		sp.fadeStep = 0.18;
		sp.flags = SPF_FULLBRIGHT;

		int i;
		// Rim outline — faster pulse (~2.3x).
		for (i = 0; i <= 8; i++)
		{
			double u = -half + (2.0 * half * i / 8.0);
			double pulse = 0.55 + 0.35 * (0.5 + 0.5 * sin(gametic * 0.32 + i * 0.35));
			sp.size = 2.8 + 1.8 * pulse;
			sp.startAlpha = pulse;
			sp.pos = center + (right.x * u + fwd.x * -half, right.y * u + fwd.y * -half, zOff);
			Level.SpawnParticle(sp);
			sp.pos = center + (right.x * u + fwd.x * half, right.y * u + fwd.y * half, zOff);
			Level.SpawnParticle(sp);
		}
		for (i = 1; i < 8; i++)
		{
			double v = -half + (2.0 * half * i / 8.0);
			double pulse = 0.55 + 0.35 * (0.5 + 0.5 * sin(gametic * 0.32 + i * 0.35 + 1.2));
			sp.size = 2.8 + 1.8 * pulse;
			sp.startAlpha = pulse;
			sp.pos = center + (right.x * -half + fwd.x * v, right.y * -half + fwd.y * v, zOff);
			Level.SpawnParticle(sp);
			sp.pos = center + (right.x * half + fwd.x * v, right.y * half + fwd.y * v, zOff);
			Level.SpawnParticle(sp);
		}

		// Interior fill — 5x5 grid with row-phased pulse.
		int ix, iy;
		for (iy = 1; iy <= 5; iy++)
		{
			for (ix = 1; ix <= 5; ix++)
			{
				double u = -half + (2.0 * half * ix / 6.0);
				double v = -half + (2.0 * half * iy / 6.0);
				double phase = ix * 0.45 + iy * 0.55;
				double pulse = 0.5 + 0.5 * sin(gametic * 0.28 + phase);
				sp.size = 1.6 + 2.4 * pulse;
				sp.startAlpha = 0.18 + 0.55 * pulse;
				sp.pos = center + (right.x * u + fwd.x * v, right.y * u + fwd.y * v, zOff);
				Level.SpawnParticle(sp);
			}
		}
	}

	static void SpawnRimPlane(Vector3 center, double ang, int hue, int kind, double halfW, double halfL)
	{
		if (LowGfx()) return;
		double c = cos(ang);
		double s = sin(ang);
		double tx = -s;
		double ty = c;

		FSpawnParticleParams sp;
		if (hue == 0)
			sp.color1 = "FF4020";
		else
			sp.color1 = "3080FF";
		sp.lifetime = 4;
		sp.size = 3.0 + frandom(0, 1.5);
		sp.sizeStep = -0.2;
		sp.startAlpha = 0.55;
		sp.fadeStep = 0.1;
		sp.flags = SPF_FULLBRIGHT;

		int i;
		if (kind == 0)
		{
			for (i = 0; i <= 8; i++)
			{
				double u = -32.0 + (64.0 * i / 8.0);
				sp.pos = center + (tx * u, ty * u, 64.0);
				Level.SpawnParticle(sp);
				sp.pos = center + (tx * u, ty * u, -64.0);
				Level.SpawnParticle(sp);
			}
			for (i = 1; i < 8; i++)
			{
				double v = -64.0 + (128.0 * i / 8.0);
				sp.pos = center + (tx * -32.0, ty * -32.0, v);
				Level.SpawnParticle(sp);
				sp.pos = center + (tx * 32.0, ty * 32.0, v);
				Level.SpawnParticle(sp);
			}
		}
		else
		{
			Vector2 fwd = PlaneFwd(ang);
			Vector2 right = PlaneRight(ang);
			if (halfW <= 0) halfW = 32.0;
			if (halfL <= 0) halfL = 64.0;
			for (i = 0; i <= 8; i++)
			{
				double u = -halfW + (2.0 * halfW * i / 8.0);
				sp.pos = center + (right.x * u + fwd.x * -halfL, right.y * u + fwd.y * -halfL, 0);
				Level.SpawnParticle(sp);
				sp.pos = center + (right.x * u + fwd.x * halfL, right.y * u + fwd.y * halfL, 0);
				Level.SpawnParticle(sp);
			}
			for (i = 1; i < 8; i++)
			{
				double v = -halfL + (2.0 * halfL * i / 8.0);
				sp.pos = center + (right.x * -halfW + fwd.x * v, right.y * -halfW + fwd.y * v, 0);
				Level.SpawnParticle(sp);
				sp.pos = center + (right.x * halfW + fwd.x * v, right.y * halfW + fwd.y * v, 0);
				Level.SpawnParticle(sp);
			}
		}
	}
}
