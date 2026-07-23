// Directional damage indicators (D4D-style, ported from PBX-Addons).

class PB2022_DamageIndicatorHandler : EventHandler
{
	override void OnRegister()
	{
		SetOrder(666);
		Super.OnRegister();
	}

	override void WorldLoaded(WorldEvent e)
	{
		ArrowManager = PB2022_DamageIndicatorManager.Create();
	}

	override void RenderOverlay(RenderEvent e)
	{
		if (ArrowManager)
			ArrowManager.Render(e);
	}

	override void WorldTick()
	{
		if (ArrowManager)
			ArrowManager.Tick();
	}

	override void WorldThingDamaged(WorldEvent e)
	{
		if (!e.Thing || !e.Thing.player)
			return;
		if (!e.DamageSource && !e.Inflictor)
			return;
		if (ArrowManager)
			ArrowManager.AddIndicator(e.DamageSource, e.Inflictor, e.Thing, e.Damage, e.DamageType);
	}

	PB2022_DamageIndicatorManager ArrowManager;
}

class PB2022_DamageIndicatorManager play
{
	Array<PB2022_DamageIndicator> Arrows;
	int Timer;
	const ClearTimer = 25;
	color defaultColor;

	static PB2022_DamageIndicatorManager Create()
	{
		let vdm = new('PB2022_DamageIndicatorManager');
		vdm.Init();
		return vdm;
	}

	void Init()
	{
		Arrows.Clear();
		defaultColor = "FF0000";
	}

	void AddIndicator(Actor src, Actor inf, Actor plr, int damage = 0, Name dmgtype = 'Normal')
	{
		if ((!src && !inf) || !plr || src == plr)
			return;

		for (int i = 0; i < Arrows.Size(); i++)
		{
			if (Arrows[i] && Arrows[i].src == src)
			{
				Arrows[i].ResetTimer(GetTimerForPlayer(plr));
				if (NoColorForPlayer(plr))
					Arrows[i].col = defaultColor;
				else
					Arrows[i].col = GetArrowColor(dmgtype, plr);
				return;
			}
		}

		let arrow = new('PB2022_DamageIndicator');
		arrow.src = src;
		arrow.inf = inf;
		if (src)
			arrow.srcpos = src.pos;
		else if (inf)
		{
			src = (inf.target) ? inf.target : inf;
			arrow.srcpos = src.pos;
		}
		if (inf)
			arrow.infpos = inf.pos;

		if (NoColorForPlayer(plr))
			arrow.col = defaultColor;
		else
			arrow.col = GetArrowColor(dmgtype, plr);

		arrow.plr = plr;
		arrow.highlightreq = false;
		int indtype = GetIndicatorType(plr);
		switch (indtype)
		{
			case 1:
				arrow.tex = TexMan.CheckForTexture("graphics/hud/pbx_dmgind/hud/DmgDir2.png", TexMan.Type_Any);
				arrow.htex = TexMan.CheckForTexture("graphics/hud/pbx_dmgind/hud/DmgDir2H.png", TexMan.Type_Any);
				arrow.highlightreq = true;
				break;
			case 2:
				arrow.tex = TexMan.CheckForTexture("graphics/hud/pbx_dmgind/hud/DmgDir4.png", TexMan.Type_Any);
				break;
			case 3:
				arrow.tex = TexMan.CheckForTexture("graphics/hud/pbx_dmgind/hud/DmgDir5.png", TexMan.Type_Any);
				break;
			case 0:
			default:
				arrow.tex = TexMan.CheckForTexture("graphics/hud/pbx_dmgind/hud/DmgDir3.png", TexMan.Type_Any);
				break;
		}

		arrow.type = indtype;
		arrow.ResetTimer(GetTimerForPlayer(plr));
		arrow.Init();
		Arrows.Push(arrow);
	}

	int GetIndicatorType(Actor plr)
	{
		if (!plr || !plr.player)
			return 0;
		let cv = CVar.GetCVar("pb_pbx_dmgind_type", plr.player);
		return cv ? cv.GetInt() : 0;
	}

	int GetTimerForPlayer(Actor plr)
	{
		if (!plr || !plr.player)
			return 35;
		let cv = CVar.GetCVar("pb_pbx_dmgind_timer", plr.player);
		return cv ? cv.GetInt() : 35;
	}

	bool NoColorForPlayer(Actor plr)
	{
		if (!plr || !plr.player)
			return false;
		let cv = CVar.GetCVar("pb_pbx_dmgind_nocolor", plr.player);
		return cv ? cv.GetBool() : false;
	}

	void Tick()
	{
		int size = Arrows.Size();
		if (size < 1)
			return;

		for (int i = 0; i < size; i++)
		{
			if (Arrows[i])
				Arrows[i].Tick();
		}

		if (++Timer >= ClearTimer)
		{
			Timer = 0;
			Array<PB2022_DamageIndicator> temp;
			temp.Clear();
			for (int i = 0; i < size; i++)
				if (Arrows[i])
					temp.Push(Arrows[i]);
			Arrows.Move(temp);
		}
	}

	ui void Render(RenderEvent e)
	{
		if (Arrows.Size() < 1)
			return;

		if (!PB2022_AddonsUtil.FeatureOn("pb_pbx_dmgind", PB2022_DisableDamageIndicators))
			return;

		PlayerInfo plr = players[consoleplayer];
		double alpha = 1.0;
		double scale = 0.5;
		int animType = 0;

		let cvA = CVar.GetCVar("pb_pbx_dmgind_alpha", plr);
		let cvS = CVar.GetCVar("pb_pbx_dmgind_scale", plr);
		let cvAnim = CVar.GetCVar("pb_pbx_dmgind_anim", plr);
		let cvCol = CVar.GetCVar("pb_pbx_dmgind_color", plr);
		if (cvA) alpha = cvA.GetFloat();
		if (cvS) scale = cvS.GetFloat();
		if (cvAnim) animType = cvAnim.GetInt();

		for (int i = 0; i < Arrows.Size(); i++)
		{
			let arrow = PB2022_DamageIndicator(Arrows[i]);
			if (arrow && arrow.pinfo == plr)
				arrow.Render(e, alpha, scale, animType);
		}
	}

	color GetArrowColor(Name damagetype, Actor plr)
	{
		if (NoColorForPlayer(plr))
			return defaultColor;

		switch (damagetype)
		{
			case 'ExplosiveImpact':
			case 'Explosive': return color("F2AE24");
			case 'Electric': return color("FFFFFF");
			case 'Disintegrate':
			case 'GreenFire':
			case 'Slime':
			case 'Acid': return color("00FF00");
			case 'incinerate':
			case 'Burn':
			case 'Fire': return color("FF5101");
			case 'Freeze':
			case 'Ice': return color("98F5F9");
			case 'Plasma': return color("0675F5");
			case 'blackhole':
			case 'Void': return color("B732DC");
			default: return defaultColor;
		}
	}
}

class PB2022_DamageIndicator play
{
	Actor inf, src, plr;
	PlayerInfo pinfo;
	Vector3 infpos, srcpos;
	TextureID tex, htex;
	color col;
	int type;
	bool highlightreq;
	double Scale;
	int Timer, origTimer;
	bool hadsrc, hadinf;
	Vector2 siz;
	Shape2D flat;
	Shape2DTransform trans;

	void Init()
	{
		hadsrc = src != null;
		hadinf = inf != null;
		pinfo = plr.player;
		flat = new("Shape2D");
		flat.PushCoord((0, 0));
		flat.PushCoord((1, 0));
		flat.PushCoord((0, 1));
		flat.PushCoord((1, 1));
		flat.PushTriangle(0, 2, 1);
		flat.PushTriangle(2, 3, 1);
		siz = TexMan.GetScaledSize(tex);
		Vector2 vertices[4];
		vertices[0] = (-siz.x, -siz.y);
		vertices[1] = ( siz.x, -siz.y);
		vertices[2] = (-siz.x,  siz.y);
		vertices[3] = ( siz.x,  siz.y);
		flat.Clear(Shape2D.C_Verts);
		for (int i = 0; i < 4; i++)
			flat.PushVertex(vertices[i]);
		trans = new('Shape2DTransform');
	}

	void ResetTimer(int time = -1)
	{
		if (time < 1)
			time = 35;
		Timer = time;
		origTimer = time;
	}

	void Tick()
	{
		if (--Timer < 0 || !plr)
		{
			Destroy();
			return;
		}
		if (!src && inf && inf.bMISSILE)
			src = inf.target;
		if (src)
			srcpos = src.pos;
		if (inf)
			infpos = inf.pos;
	}

	const ThirtyFifth = (1.0 / 35.0);

	ui void Render(RenderEvent e, double _Alpha, double _Scale, int animType = 0)
	{
		double Alpha = (ThirtyFifth * Timer) * _Alpha;
		double maxalpha = clamp(min(_Alpha, 1.0), 0.0, 1.0);
		double Scale = _Scale;
		if (bDESTROYED || Alpha <= 0.0 || !plr || plr.pos == srcpos || !hadsrc)
			return;

		double pers = 0.75;
		double t0 = LinearMap(Timer, 1, origTimer + 1, 0.0, 1.0);
		switch (animType)
		{
			case 0: Scale += Lerp(_Scale * 0.3, -0.01, t0); break;
			case 1:
				Scale += LinearMap(Timer, origTimer, 0, _Scale * 0.3, -_Scale * 2);
				if (Scale < _Scale) Scale = _Scale;
				break;
			case 2:
				Scale += LinearMap(Timer, 0, origTimer, _Scale * 1.5, 0.0);
				if (Scale > (_Scale * 1.2)) Scale = _Scale * 1.2;
				break;
			default: break;
		}

		trans.Clear();
		Vector3 diff = level.Vec3Diff(srcpos, plr.pos);
		double ang = VectorAngle(diff.X, diff.Y);
		ang = -plr.DeltaAngle(plr.angle, ang);
		Vector2 s = (Screen.GetWidth() / 2, Screen.GetHeight() / 2);
		double off = (siz.y + (siz.y * Scale)) * pers;
		Vector2 add = (-sin(ang) * off, cos(ang) * off);
		s += add;
		trans.Scale((1.0, 1.0) * Scale);
		trans.Rotate(ang + 180.0);
		trans.Translate(s);
		flat.SetTransform(trans);
		Screen.DrawShape(tex, false, flat, DTA_Alpha, Clamp(Alpha, 0.0, maxalpha), DTA_ColorOverlay, col | 0xFF000000);
		if (highlightreq)
			Screen.DrawShape(htex, false, flat, DTA_Alpha, Clamp(Alpha, 0.0, maxalpha));
	}

	clearscope double LinearMap(double val, double oMin, double oMax, double nMin, double nMax)
	{
		return (val - oMin) * (nMax - nMin) / (oMax - oMin) + nMin;
	}

	clearscope double Lerp(double v0, double v1, double t)
	{
		return (1 - t) * v0 + t * v1;
	}
}
