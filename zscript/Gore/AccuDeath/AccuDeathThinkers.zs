//AccuDeath3.2 Thinkers by Airehnr66

Class AccuDeathEffectsBase : Thinker //Creates appropriate effects based on thinker class spawned.
{
	Actor victim;
	int ticAge;
	
	static AccuDeathEffectsBase Create(Actor victim)
	{
		let t = New('AccuDeathEffectsBase');
		
		if(t)
		{
			t.victim = victim;
		}
		return t;
	}
	
	static void EndEffects(Actor victim) //Removes any created dynamic lights or BRIGHT flags and assigns "Burnt" translation.
	{
		if(victim)
		{
			victim.A_RemoveLight("OrangeFireLight");
			victim.A_RemoveLight("GreenFireLight");
			victim.A_RemoveLight("PurpleFireLight");
			victim.A_RemoveLight("BlueFireLight");
			victim.A_RemoveLight("HolyLight");
			victim.A_RemoveLight("GreenElectricLight");
			victim.A_RemoveLight("RedElectricLight");
			victim.A_RemoveLight("BlueElectricLight");
			victim.bBRIGHT = false;
			victim.translation = "Burnt";
		}
	}
	
	static void makeSmoke(Actor victim)
	{
		if(victim)
		{
			if(random(1,4) > 3)
			{
				victim.Spawn("RocketSmokeTrail", victim.Vec3Offset(frandom(-victim.radius,victim.radius),frandom(-victim.radius,victim.radius),frandom(0,victim.height)));
			}
		}
	}

	static void CreatePoisonParticles(Actor victim, String particleColor = "004400")
	{
		if(victim)
		{
			FSpawnParticleParams p;

			p.color1 = particleColor;
			if(random(1, 2) == 2)
			{
				p.lifetime = random(20,30);
				p.size = random(6, 7);
				p.accel = (0, 0, 0);
				p.startalpha = 1.0;
				p.sizestep = frandom(-1, 0.1);
				p.pos = victim.pos + (frandom(-victim.radius, victim.radius), frandom(-victim.radius, victim.radius), frandom(0, victim.height));
				p.vel = (frandom(-0.5, 0.5),frandom(-0.5, 0.5),frandom(0.5, 1.5));
				Level.SpawnParticle(p);
			}
		}
		else
		{
			return;
		}
	}
	
	static void CreateFireParticles(Actor victim, String particleColor = "Orange")
	{
		if(victim)
		{
			FSpawnParticleParams p;

			p.color1 = particleColor;
			p.flags = SPF_FULLBRIGHT;
			p.lifetime = random(20,25);
			p.size = 6;
			p.accel = (0,0,0);
			p.startalpha = 1.0;
			p.fadestep = frandom(-1,-0.5);
			p.sizestep = frandom(-1,-0.2);
			p.pos = victim.pos + (frandom(-victim.radius,victim.radius),frandom(-victim.radius,victim.radius),frandom(0,victim.height));
			p.vel = (frandom(-0.5,0.5),frandom(-0.5,0.5),frandom(0.5,2));
			Level.SpawnParticle(p);
		}
		else
		{
			return;
		}
	}
	
	static void CreateHolyParticles(Actor victim, String particleColor = "Goldenrod")
	{
		if(victim)
		{
			FSpawnParticleParams p;

			p.color1 = particleColor;
			p.flags = SPF_FULLBRIGHT;
			if(random(1, 6) > 5)
			{
				p.lifetime = random(20,25);
				p.size = 6;
				p.accel = (0,0,0);
				p.startalpha = 1.0;
				p.fadestep = frandom(-1,-0.5);
				p.pos = victim.pos + (frandom(-victim.radius,victim.radius),frandom(-victim.radius,victim.radius),frandom(0,victim.height));
				p.vel = (frandom(-0.5,0.5),frandom(-0.5,0.5),frandom(0.5,2));
				Level.SpawnParticle(p);
			}
		}
		else
		{
			return;
		}
	}
	
	override void tick() //If victim disappears or is still alive, abort spawning death effects. Otherwise add to ticAge counter.
	{
		if(!victim)
		{
			Destroy();
			return;
		}
		if(victim.health > 0)
		{
			return;
		}	
		ticAge++;
	}
}

Class AccuDeathPlasmaEffects : AccuDeathEffectsBase
{
	static AccuDeathPlasmaEffects Create(Actor victim)
	{
		let adpe = New('AccuDeathPlasmaEffects');
		
		if(adpe)
		{
			adpe.victim = victim;
		}
		return adpe;
	}

	override void tick()
	{
		Super.tick();
		makeSmoke(victim);
		if(ticAge > random(35, 45))
		{
			EndEffects(victim);
			Destroy();
			return;
		}
	}
}

Class AccuDeathElectricEffectsBase : AccuDeathEffectsBase
{	
	static AccuDeathElectricEffectsBase Create(Actor victim)
	{
		let adee = New('AccuDeathElectricEffectsBase');
		
		if(adee)
		{
			adee.victim = victim;
		}
		return adee;
	}

	override void tick()
	{
		Super.tick();
		makeSmoke(victim);
		if(ticAge > random(20, 25))
		{
			EndEffects(victim);
			Destroy();
			return;
		}
	}
}

Class AccuDeathGreenElectricEffects : AccuDeathEffectsBase
{	
	static AccuDeathGreenElectricEffects Create(Actor victim)
	{
		let adge = New('AccuDeathGreenElectricEffects');
		
		if(adge)
		{
			adge.victim = victim;
		}
		return adge;
	}
	
	override void tick()
	{
		Super.tick();
		makeSmoke(victim);
		if(ticAge > random(20, 25))
		{
			EndEffects(victim);
			Destroy();
			return;
		}
	}
}

Class AccuDeathRedElectricEffects : AccuDeathEffectsBase
{	
	static AccuDeathRedElectricEffects Create(Actor victim)
	{
		let adre = New('AccuDeathRedElectricEffects');
		
		if(adre)
		{
			adre.victim = victim;
		}
		return adre;
	}
	
	override void tick()
	{
		Super.tick();

		makeSmoke(victim);
		if(ticAge > random(20, 25))
		{
			EndEffects(victim);
			Destroy();
			return;
		}
	}
}

Class AccuDeathPoisonEffects : AccuDeathEffectsBase
{
	static AccuDeathPoisonEffects Create(Actor victim)
	{
		let adpe = New('AccuDeathPoisonEffects');
		
		if(adpe)
		{
			adpe.victim = victim;
		}
		return adpe;
	}
	
	override void tick()
	{
		Super.tick();	
		CreatePoisonParticles(victim);
		if(ticAge > random(40, 45))
		{
			Destroy();
			return;
		}
	}
}

Class AccuDeathFireEffectsBase : AccuDeathEffectsBase
{
	static AccuDeathFireEffectsBase Create(Actor victim)
	{
		let adfe = New('AccuDeathFireEffectsBase');
		
		if(adfe)
		{
			adfe.victim = victim;
		}
		return adfe;
	}

	override void tick()
	{
		Super.tick();
		CreateFireParticles(victim, "Orange");
		makeSmoke(victim);
		if(ticAge > random(30, 35))
		{
			EndEffects(victim);
			Destroy();
			return;
		}
	}
}

Class AccuDeathGreenFireEffects : AccuDeathEffectsBase
{
	static AccuDeathGreenFireEffects Create(Actor victim)
	{
		let adgf = New('AccuDeathGreenFireEffects');
		
		if(adgf)
		{
			adgf.victim = victim;
		}
		return adgf;
	}
	
	override void tick()
	{
		Super.tick();
		CreateFireParticles(victim, "Green");
		makeSmoke(victim);
		if(ticAge > random(30, 35))
		{
			EndEffects(victim);
			Destroy();
			return;
		}
	}
}

Class AccuDeathPurpleFireEffects : AccuDeathEffectsBase
{
	static AccuDeathPurpleFireEffects Create(Actor victim)
	{
		let adpf = New('AccuDeathPurpleFireEffects');
		
		if(adpf)
		{
			adpf.victim = victim;
		}
		return adpf;
	}
	
	override void tick()
	{
		Super.tick();
		CreateFireParticles(victim, "MediumOrchid");
		makeSmoke(victim);
		if(ticAge > random(30, 35))
		{
			EndEffects(victim);
			Destroy();
			return;
		}
	}
}

Class AccuDeathBlueFireEffects : AccuDeathEffectsBase
{
	static AccuDeathBlueFireEffects Create(Actor victim)
	{
		let adbf = New('AccuDeathBlueFireEffects');
		
		if(adbf)
		{
			adbf.victim = victim;
		}
		return adbf;
	}
	
	override void tick()
	{
		Super.tick();
		CreateFireParticles(victim, "LightSkyBlue");
		makeSmoke(victim);
		if(ticAge > random(30, 35))
		{
			EndEffects(victim);
			Destroy();
			return;
		}
	}
}

Class AccuDeathHolyEffects : AccuDeathEffectsBase
{
	static AccuDeathHolyEffects Create(Actor victim)
	{
		let adhe = New('AccuDeathHolyEffects');
		
		if(adhe)
		{
			adhe.victim = victim;
		}
		return adhe;
	}
	
	override void tick()
	{
		Super.tick();
		CreateHolyParticles(victim);
		if(ticAge > random(30, 35))
		{
			EndEffects(victim);
			Destroy();
			return;
		}
	}
}
