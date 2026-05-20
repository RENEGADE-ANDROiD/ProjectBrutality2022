//AccuDeathV3.2.1 by Airehnr66

Class AccuDeathHandler : EventHandler
{
	enum HandlerDeathType
	{
		AD_PLASMADEATH = 0,
		AD_FIREDEATH = 1,
		AD_GREENFIREDEATH = 2,
		AD_PURPLEFIREDEATH = 3,
		AD_BLUEFIREDEATH = 4,
		AD_ELECTRICDEATH = 5,
		AD_GREENELECTRICDEATH = 6,
		AD_REDELECTRICDEATH = 7,
		AD_BLOODDEATH = 8,
		AD_POISONDEATH = 9,
		AD_HOLYDEATH = 10,
	}
	
	static void CreateSparkParticles(Actor victim, String particleColor = "Azure") //Spawns electric death style spark particles on victim.
	{
		FSpawnParticleParams ps;

		ps.color1 = particleColor;
		ps.flags = SPF_FULLBRIGHT;
		ps.style = STYLE_ADD;
		
		for(int i = 0; i < 24; i++)
		{
			ps.lifetime = random(20, 25);
			ps.size = 6;
			ps.accel = (0, 0, frandom(-1, 0));
			ps.startalpha = 1.0;
			ps.fadestep = -1;
			ps.sizestep = frandom(-0.2, -0.1);
			ps.pos = victim.pos + (frandom(-10, 10), frandom(-10, 10),(victim.height)/2 + 20);
			ps.vel = (frandom(-3, 4),frandom(-3, 4),frandom(-2, 1));
		
			Level.SpawnParticle(ps);
			i++;
		}
	}

	static void AccuDeathEffects(Actor whoDied, int HandlerDeathType = 0) //Assigns proper death effects based on HandlerDeathType
	{				
		if(accudeath_stateoverride == false) //Disables overriding custom death states for specific damage types. *Special thanks to inkoalawetrust
		{
			if((whoDied.FindState("Death.Plasma", true) && HandlerDeathType == AD_PLASMADEATH) || //Finds custom death state in actor. If found, cancel death effects.
				(whoDied.FindState("Death.Electric", true) && HandlerDeathType == AD_ELECTRICDEATH) ||
				(whoDied.FindState("Death.Fire", true) && HandlerDeathType == AD_FIREDEATH))
				{
					return;
				}
		}
		if(HandlerDeathType == AD_PLASMADEATH)
		{
			whoDied.Translation = "Burnt";
			AccuDeathPlasmaEffects.Create(whoDied);
		}
		if(HandlerDeathType == AD_FIREDEATH)
		{
			whoDied.bBRIGHT = True;
			whoDied.Translation = "FireDeath";
			if(accudeath_dynamiclights)
			{
				whoDied.A_AttachLight("OrangeFireLight", dynamiclight.randomflickerlight, "Orange", (whoDied.radius*(accudeath_lightsize)), ((whoDied.radius*1.1)*(accudeath_lightsize)), 0, (0,0,whoDied.height/2));
			}
			AccuDeathFireEffectsBase.Create(whoDied);
			return;
		}
		if(HandlerDeathType == AD_GREENFIREDEATH)
		{
			whoDied.bBRIGHT = True;
			whoDied.Translation = "GreenFireDeath";
			if(accudeath_dynamiclights)
			{
				whoDied.A_AttachLight("GreenFireLight", dynamiclight.randomflickerlight, "Green", (whoDied.radius*(accudeath_lightsize)), ((whoDied.radius*1.1)*(accudeath_lightsize)), 0, (0,0,whoDied.height/2));
			}
			AccuDeathGreenFireEffects.Create(whoDied);
			return;
		}
		if(HandlerDeathType == AD_PURPLEFIREDEATH)
		{
			whoDied.bBRIGHT = True;
			whoDied.Translation = "PurpleFireDeath";
			if(accudeath_dynamiclights)
			{
				whoDied.A_AttachLight("PurpleFireLight", dynamiclight.randomflickerlight, "Purple", (whoDied.radius*(accudeath_lightsize)), ((whoDied.radius*1.1)*(accudeath_lightsize)), dynamiclight.LF_SUBTRACTIVE, (0,0,whoDied.height/2));
			}
			AccuDeathPurpleFireEffects.Create(whoDied);
			return;
		}
		if(HandlerDeathType == AD_BLUEFIREDEATH)
		{
			whoDied.bBRIGHT = True;
			whoDied.Translation = "BlueElectricDeath";
			if(accudeath_dynamiclights)
			{
				whoDied.A_AttachLight("BlueFireLight", dynamiclight.randomflickerlight, "CornFlowerBlue", (whoDied.radius*(accudeath_lightsize)), ((whoDied.radius*1.1)*(accudeath_lightsize)), dynamiclight.LF_ADDITIVE, (0,0,whoDied.height/2));
			}
			AccuDeathBlueFireEffects.Create(whoDied);
			return;
		}
		if(HandlerDeathType == AD_ELECTRICDEATH)
		{
			whoDied.bBRIGHT = True;
			whoDied.Translation = "BlueElectricDeath";
			if(accudeath_dynamiclights)
			{
				whoDied.A_AttachLight("BlueElectricLight", dynamiclight.randomflickerlight, "LightSlateBlue", (whoDied.radius*(accudeath_lightsize)), ((whoDied.radius*1.1)*(accudeath_lightsize)), dynamiclight.LF_ADDITIVE, (0,0,whoDied.height/2));
			}
			CreateSparkParticles(whoDied);
			AccuDeathElectricEffectsBase.Create(whoDied);
			return;
		}
		if(HandlerDeathType == AD_GREENELECTRICDEATH)
		{
			whoDied.bBRIGHT = True;
			whoDied.Translation = "GreenElectricDeath";
			if(accudeath_dynamiclights)
			{
				whoDied.A_AttachLight("GreenElectricLight", dynamiclight.randomflickerlight, "Green", (whoDied.radius*(accudeath_lightsize)), ((whoDied.radius*1.1)*(accudeath_lightsize)), dynamiclight.LF_ADDITIVE, (0,0,whoDied.height/2));
			}
			CreateSparkParticles(whoDied, "Honeydew");
			AccuDeathGreenElectricEffects.Create(whoDied);
			return;
		}
		if(HandlerDeathType == AD_REDELECTRICDEATH)
		{
			whoDied.bBRIGHT = True;
			whoDied.Translation = "RedElectricDeath";
			if(accudeath_dynamiclights)
			{
				whoDied.A_AttachLight("RedElectricLight", dynamiclight.randomflickerlight, "Tomato", (whoDied.radius*(accudeath_lightsize)), ((whoDied.radius*1.1)*(accudeath_lightsize)), dynamiclight.LF_ADDITIVE, (0,0,whoDied.height/2));
			}
			CreateSparkParticles(whoDied, "Pink");
			AccuDeathRedElectricEffects.Create(whoDied);
			return;
		}
		if(HandlerDeathType == AD_BLOODDEATH)
		{
			whoDied.Translation = "BloodDeath";
			return;
		}
		if(HandlerDeathType == AD_POISONDEATH)
		{
			whoDied.Translation = "PoisonDeath";
			AccuDeathPoisonEffects.Create(whoDied);
			return;
		}
		if(HandlerDeathType == AD_HOLYDEATH)
		{
			whoDied.Translation = "HolyDeath";
			if(accudeath_dynamiclights)
			{
				whoDied.A_AttachLight("HolyLight", dynamiclight.pulselight, "Goldenrod", (whoDied.radius*(accudeath_lightsize)), ((whoDied.radius*1.1)*(accudeath_lightsize)), dynamiclight.LF_ADDITIVE, (0,0,whoDied.height/2), 0.5);
			}
			for(int i = random(2, 4); i > 0; i--)
			{
				whoDied.Spawn("RocketSmokeTrail", whoDied.Vec3Offset(frandom(-whoDied.radius,whoDied.radius),frandom(-whoDied.radius,whoDied.radius),frandom(0,whoDied.height)));
			}
			AccuDeathHolyEffects.Create(whoDied);
			return;
		}
		else
		{
			return;
		}
	}
	
	override void WorldThingDied(WorldEvent e) //Determines death effects at time of victim's death.
	{
		if (!PB_AccuDeathCompat.IsEnabled())
			return;

		if(e.thing && e.thing.bIsMonster || e.thing.player)
		{
			if(e.inflictor)
			{				
				//Debug stuff:
				//Console.printf(e.inflictor.GetClassName());
				//Console.printf(e.inflictor.damagetype);
				
///////////////////Custom projectiles with no damagetype assigned must be checked by GetClassName() to be supported
				
				/*Additionally, custom projectiles with damagetypes that don't match their death effects must be checked
				by GetClassName() before checking damagetype to set proper effects
				
				Also, some projectiles pass inflictor directly to the player or monster that created it, and therefore
				the creator itself must be checked for specifically.*/
				
				if(e.inflictor.GetClassName() == "BulletPuff" &&
					e.thing.target && e.thing.target.player && e.thing.target.player.readyWeapon && e.thing.target.player.readyWeapon.GetClassName() == "BFG9000") //Prevents Dehacked modified BFG replacements using bulletpuffs from applying plasma death effects.
				{
					return;
				}
				for(int i = 0; i < AccuDeathArrays.PlasmaClassArray.Size(); i++)
				{
					if(e.inflictor.GetClassName() == AccuDeathArrays.PlasmaClassArray[i])
					{
						AccuDeathEffects(e.thing, AD_PLASMADEATH);
						return;
					}
				}
				for(int i = 0; i < AccuDeathArrays.PlasmaWeaponArray.Size(); i++)
				{
					if(e.thing.target && e.thing.target.player && e.thing.target.player.readyWeapon && e.thing.target.player.readyWeapon.GetClassName() == AccuDeathArrays.PlasmaWeaponArray[i])
					{
						AccuDeathEffects(e.thing, AD_PLASMADEATH);
						return;
					}
				}
				for(int i = 0; i < AccuDeathArrays.FireClassArray.Size(); i++)
				{
					if(e.inflictor.GetClassName() == AccuDeathArrays.FireClassArray[i])
					{
						AccuDeathEffects(e.thing, AD_FIREDEATH);
						return;
					}
				}
				for(int i = 0; i < AccuDeathArrays.FireWeaponArray.Size(); i++)
				{
					if(e.thing.target && e.thing.target.player && e.thing.target.player.readyWeapon && e.thing.target.player.readyWeapon.GetClassName() == AccuDeathArrays.FireWeaponArray[i])
					{
						AccuDeathEffects(e.thing, AD_FIREDEATH);
						return;
					}
				}
				for(int i = 0; i < AccuDeathArrays.GreenFireClassArray.Size(); i++)
				{
					if(e.inflictor.GetClassName() == AccuDeathArrays.GreenFireClassArray[i])
					{
						AccuDeathEffects(e.thing, AD_GREENFIREDEATH);
						return;
					}
				}
				for(int i = 0; i < AccuDeathArrays.BarrelClassArray.Size(); i++) //Supports multiple Class Names for Doom Barrel replacements.
				{
					if(e.inflictor.GetClassName() == AccuDeathArrays.BarrelClassArray[i])
					{
						switch(accudeath_barreltype)
						{
							default: AccuDeathEffects(e.thing, AD_GREENFIREDEATH); break;
							case 1: AccuDeathEffects(e.thing, AD_FIREDEATH); break;
							case 2: break;
						}
					}
				}
				for(int i = 0; i < AccuDeathArrays.PurpleFireClassArray.Size(); i++)
				{
					if(e.inflictor.GetClassName() == AccuDeathArrays.PurpleFireClassArray[i])
					{
						AccuDeathEffects(e.thing, AD_PURPLEFIREDEATH);
						return;
					}
				}
				for(int i = 0; i < AccuDeathArrays.PurpleFireWeaponArray.Size(); i++)
				{
					if(e.thing.target && e.thing.target.player && e.thing.target.player.readyWeapon && e.thing.target.player.readyWeapon.GetClassName() == AccuDeathArrays.PurpleFireWeaponArray[i])
					{
						AccuDeathEffects(e.thing, AD_PURPLEFIREDEATH);
						return;
					}
				}
				for(int i = 0; i < AccuDeathArrays.BlueFireClassArray.Size(); i++)
				{
					if(e.inflictor.GetClassName() == AccuDeathArrays.BlueFireClassArray[i])
					{
						AccuDeathEffects(e.thing, AD_BLUEFIREDEATH);
						return;
					}
				}
				for(int i = 0; i < AccuDeathArrays.ElectricClassArray.Size(); i++)
				{
					if(e.inflictor.GetClassName() == AccuDeathArrays.ElectricClassArray[i])
					{
						AccuDeathEffects(e.thing, AD_ELECTRICDEATH);
						return;
					}
				}
				for(int i = 0; i < AccuDeathArrays.ElectricWeaponArray.Size(); i++)
				{
					if(e.thing.target && e.thing.target.player && e.thing.target.player.readyWeapon && e.thing.target.player.readyWeapon.GetClassName() == AccuDeathArrays.ElectricWeaponArray[i])
					{
						AccuDeathEffects(e.thing, AD_ELECTRICDEATH);
						return;
					}
				}
				for(int i = 0; i < AccuDeathArrays.GreenElectricClassArray.Size(); i++)
				{
					if(e.inflictor.GetClassName() == AccuDeathArrays.GreenElectricClassArray[i])
					{
						AccuDeathEffects(e.thing, AD_GREENELECTRICDEATH);
						return;
					}
				}
				for(int i = 0; i < AccuDeathArrays.RedElectricClassArray.Size(); i++)
				{
					if(e.inflictor.GetClassName() == AccuDeathArrays.RedElectricClassArray[i])
					{
						AccuDeathEffects(e.thing, AD_REDELECTRICDEATH);
						return;
					}
				}
				for(int i = 0; i < AccuDeathArrays.BloodClassArray.Size(); i++)
				{
					if(e.inflictor.GetClassName() == AccuDeathArrays.BloodClassArray[i] ||
						e.inflictor.GetClass() is "RedAxe")
					{
						AccuDeathEffects(e.thing, AD_BLOODDEATH);
						return;
					}
				}
				for(int i = 0; i < AccuDeathArrays.PoisonClassArray.Size(); i++)
				{
					if(e.inflictor.GetClassName() == AccuDeathArrays.PoisonClassArray[i])
					{
						AccuDeathEffects(e.thing, AD_POISONDEATH);
						return;
					}
				}
				for(int i = 0; i < AccuDeathArrays.HolyClassArray.Size(); i++)
				{
					if(e.inflictor.GetClassName() == AccuDeathArrays.HolyClassArray[i])
					{
						AccuDeathEffects(e.thing, AD_HOLYDEATH);
						return;
					}
				}
///////////////////Checking multiple potential terms for each damage type to determine death effects
				
				for(int i = 0; i < AccuDeathArrays.PlasmaDamageArray.Size(); i++)
				{
					if(e.inflictor.damageType == AccuDeathArrays.PlasmaDamageArray[i])
					{
						AccuDeathEffects(e.thing, AD_PLASMADEATH);
						return;
					}
				}
				for(int i = 0; i < AccuDeathArrays.FireDamageArray.Size(); i++)
				{
					if(e.inflictor.damageType == AccuDeathArrays.FireDamageArray[i])
					{
						AccuDeathEffects(e.thing, AD_FIREDEATH);
						return;
					}
				}
				for(int i = 0; i < AccuDeathArrays.GreenFireDamageArray.Size(); i++)
				{
					if(e.inflictor.damageType == AccuDeathArrays.GreenFireDamageArray[i])
					{
						AccuDeathEffects(e.thing, AD_GREENFIREDEATH);
						return;
					}
				}
				for(int i = 0; i < AccuDeathArrays.PurpleFireDamageArray.Size(); i++)
				{
					if(e.inflictor.damageType == AccuDeathArrays.PurpleFireDamageArray[i])
					{
						AccuDeathEffects(e.thing, AD_PURPLEFIREDEATH);
						return;
					}
				}
				for(int i = 0; i < AccuDeathArrays.BlueFireDamageArray.Size(); i++)
				{
					if(e.inflictor.damageType == AccuDeathArrays.BlueFireDamageArray[i])
					{
						AccuDeathEffects(e.thing, AD_BLUEFIREDEATH);
						return;
					}
				}
				for(int i = 0; i < AccuDeathArrays.ElectricDamageArray.Size(); i++)
				{
					if(e.inflictor.damageType == AccuDeathArrays.ElectricDamageArray[i])
					{
						AccuDeathEffects(e.thing, AD_ELECTRICDEATH);
						return;
					}
				}
				for(int i = 0; i < AccuDeathArrays.GreenElectricDamageArray.Size(); i++)
				{
					if(e.inflictor.damageType == AccuDeathArrays.GreenElectricDamageArray[i])
					{
						AccuDeathEffects(e.thing, AD_GREENELECTRICDEATH);
						return;
					}
				}
				for(int i = 0; i < AccuDeathArrays.RedElectricDamageArray.Size(); i++)
				{
					if(e.inflictor.damageType == AccuDeathArrays.RedElectricDamageArray[i])
					{
						AccuDeathEffects(e.thing, AD_REDELECTRICDEATH);
						return;
					}
				}
				for(int i = 0; i < AccuDeathArrays.BloodDamageArray.Size(); i++)
				{
					if(e.inflictor.damageType == AccuDeathArrays.BloodDamageArray[i])
					{
						e.thing.translation = "BloodDeath";
						return;
					}
				}
				for(int i = 0; i < AccuDeathArrays.PoisonDamageArray.Size(); i++)
				{
					if(e.inflictor.damageType == AccuDeathArrays.PoisonDamageArray[i])
					{
						AccuDeathEffects(e.thing, AD_POISONDEATH);
						return;
					}
				}
				for(int i = 0; i < AccuDeathArrays.HolyDamageArray.Size(); i++)
				{
					if(e.inflictor.damageType == AccuDeathArrays.HolyDamageArray[i])
					{
						AccuDeathEffects(e.thing, AD_HOLYDEATH);
						return;
					}
				}
			}
//////////////If no inflictor, check for damaging floor
			
			let dmgFloor = e.thing.cursector.damagetype;
			
			if(!e.inflictor && dmgFloor)
			{
				Sector playersector = e.thing.cursector;
				
				//Doom style damaging floors
				//Check which texture the damaging floor is using, and then apply appropriate death effect
				if(dmgFloor == "Slime")
				{	
					for(int i = 0; i < AccuDeathArrays.FireFloorArray.Size(); i++)
					{
						if(playersector.GetTexture(0) == TexMan.CheckForTexture(AccuDeathArrays.FireFloorArray[i]))
						{
							AccuDeathEffects(e.thing, AD_FIREDEATH);
							return;
						}
					}
					for(int i = 0; i < AccuDeathArrays.GreenFireFloorArray.Size(); i++)
					{
						if(playersector.GetTexture(0) == TexMan.CheckForTexture(AccuDeathArrays.GreenFireFloorArray[i]))
						{
							AccuDeathEffects(e.thing, AD_GREENFIREDEATH);
							return;
						}
					}
					for(int i = 0; i < AccuDeathArrays.BloodFloorArray.Size(); i++)
					{
						if(playersector.GetTexture(0) == TexMan.CheckForTexture(AccuDeathArrays.BloodFloorArray[i]))
						{
							e.thing.translation = "BloodDeath";
							return;
						}
					}
					for(int i = 0; i < AccuDeathArrays.PoisonFloorArray.Size(); i++)
					{
						if(playersector.GetTexture(0) == TexMan.CheckForTexture(AccuDeathArrays.PoisonFloorArray[i]))
						{
							AccuDeathEffects(e.thing, AD_POISONDEATH);
							return;
						}
					}
					AccuDeathEffects(e.thing, AD_PLASMADEATH);
					return;
				}
				
				//Heretic style damaging floors
				//Same as Doom, but uses damagetype "Fire" instead of "Slime"
				if(dmgFloor == "Fire")
				{
					AccuDeathEffects(e.thing, AD_FIREDEATH);
					return;
				}
			}
			//Hexen style damaging floors
			//Utilizes Terrain lump which inflicts its own damage
			let floorTerrain = e.thing.cursector.GetFloorTerrain(0);
			
			if(!e.inflictor && floorTerrain)
			{
				if(floorTerrain.damageMOD == "Fire")
				{
					AccuDeathEffects(e.thing, AD_FIREDEATH);
					return;
				}
			}
			else
			{
				return;
			}
		}
	}
}

Class AccuDeathSpawnHandler : EventHandler //Assigns blood colors and damage types to actors when spawned
{
	transient String pb_ad_dehName;
	transient bool pb_ad_dehLoaded;
	transient Actor pb_ad_dummyBlue;
	transient Actor pb_ad_dummyGreen;
	transient Actor pb_ad_dummyDarkRed;
	transient Actor pb_ad_dummyRed;
	transient Actor pb_ad_dummyYellow;
	transient Actor pb_ad_dummyLimeGreen;

	private void PB_AD_EnsureBloodDummies()
	{
		if (!PB_AccuDeathCompat.IsEnabled())
			return;
		if (pb_ad_dummyRed)
			return;
		PB_AD_InitBloodDummies();
	}

	private void PB_AD_ClearBloodDummies()
	{
		if (pb_ad_dummyBlue) { pb_ad_dummyBlue.Destroy(); pb_ad_dummyBlue = null; }
		if (pb_ad_dummyGreen) { pb_ad_dummyGreen.Destroy(); pb_ad_dummyGreen = null; }
		if (pb_ad_dummyDarkRed) { pb_ad_dummyDarkRed.Destroy(); pb_ad_dummyDarkRed = null; }
		if (pb_ad_dummyRed) { pb_ad_dummyRed.Destroy(); pb_ad_dummyRed = null; }
		if (pb_ad_dummyYellow) { pb_ad_dummyYellow.Destroy(); pb_ad_dummyYellow = null; }
		if (pb_ad_dummyLimeGreen) { pb_ad_dummyLimeGreen.Destroy(); pb_ad_dummyLimeGreen = null; }
	}

	private Actor PB_AD_SpawnBloodDummy(String cls)
	{
		return Actor.Spawn(cls, (0, 0, -32000), NO_REPLACE);
	}

	private void PB_AD_InitBloodDummies()
	{
		pb_ad_dummyBlue = PB_AD_SpawnBloodDummy("AD_BlueBloodDummy");
		pb_ad_dummyGreen = PB_AD_SpawnBloodDummy("AD_GreenBloodDummy");
		pb_ad_dummyDarkRed = PB_AD_SpawnBloodDummy("AD_DarkRedBloodDummy");
		pb_ad_dummyRed = PB_AD_SpawnBloodDummy("AD_RedBloodDummy");
		pb_ad_dummyYellow = PB_AD_SpawnBloodDummy("AD_YellowBloodDummy");
		pb_ad_dummyLimeGreen = PB_AD_SpawnBloodDummy("AD_LimeGreenBloodDummy");
	}

	private void PB_AD_CopyBlood(Actor mo, Actor dummy)
	{
		if (mo && dummy)
			mo.CopyBloodColor(dummy);
	}

	override void WorldLoaded(WorldEvent e)
	{
		PB_AD_ClearBloodDummies();
		int lump = Wads.FindLump("dehacked", 0);
		pb_ad_dehLoaded = lump != -1;
		if (pb_ad_dehLoaded)
			pb_ad_dehName = Wads.GetLumpFullPath(lump);
		else
			pb_ad_dehName = "";
	}

	override void WorldThingSpawned(WorldEvent e)
	{
		if (!PB_AccuDeathCompat.IsEnabled())
			return;
		if (!e || !e.thing)
			return;

		if (PB_AccuDeathCompat.ApplyPBProjectileSpawn(e))
			return;

		Actor t = e.thing;
		if (!t.bIsMonster && !t.bMISSILE)
			return;

		PB_AD_EnsureBloodDummies();

///////////Doom blood color fixes for monsters
		let caco = Cacodemon(t);
		
		if (caco)
			PB_AD_CopyBlood(t, pb_ad_dummyBlue);
		
		let hk = HellKnight(t);
		let boh = BaronOfHell(t);
		
		if (hk || boh)
			PB_AD_CopyBlood(t, pb_ad_dummyGreen);
		
		let rev = Revenant(t);
		
		if (rev)
			PB_AD_CopyBlood(t, pb_ad_dummyDarkRed);
		//Modified LostSoul to remove blood
		let ls = LostSoul(t);
		
		if(ls)
		{
			ls.bNOBLOOD = true;
			ls.bNOBLOODDECALS = true;
			return;
		}

///////////Doom Projectiles
		let d = DoomImpBall(t);
		
		if(d)
		{
			d.damageType = "Fire";
			return;
		}
		
		let a = ArachnotronPlasma(t);
		if (a)
		{
			a.damageType = "Plasma";
			return;
		}

		let b = BaronBall(t);
		if (b)
		{
			b.damageType = "GreenFire";
			return;
		}

		let c = CacodemonBall(t);
		if (c)
		{
			if (accudeath_cacoballtype == 1)
				c.damageType = "Fire";
			else
				c.damageType = "Electric";
			return;
		}

		let f = FatShot(t);
		if (f)
		{
			f.damageType = "Fire";
			return;
		}

		let bfgb = BFGBall(t);
		if (bfgb)
		{
			bfgb.damageType = "Plasma";
			return;
		}

		let p = PlasmaBall(t);
		if (p)
		{
			p.damageType = "Plasma";
			return;
		}

		let r = Rocket(t);
		if (r)
		{
			r.bEXTREMEDEATH = true;
			if (accudeath_rockettype == 1)
				r.damagetype = "Fire";
			return;
		}

		let if24 = ID24IncineratorFlame(t);
		if (if24)
		{
			if24.damageType = "Fire";
			return;
		}

		let ip24 = ID24IncineratorProjectile(t);
		if (ip24)
		{
			ip24.damageType = "Fire";
			return;
		}

//////////DeHackEd Support
		if(pb_ad_dehLoaded) //Checks if a DeHackEd file is loaded, and if so, adds appropriate damagetypes to placeholder actors and flats.
		{
			if(pb_ad_dehName == "id1.wad:DEHACKED") //Legacy of Rust
			{
				let d158 = DEH_Actor_158(e.thing); //Incinerator Flame
		
				if(d158)
				{
					d158.damageType = "Fire";
					return;
				}
				
				let d160 = DEH_Actor_160(e.thing); //Heatwave Ripper
		
				if(d160)
				{
					d160.damageType = "Fire";
					return;
				}
				
				let d164 = DEH_Actor_164(e.thing); //Vassago Flame
		
				if(d164)
				{
					d164.damageType = "Fire";
					return;
				}
				
				let d151 = DEH_Actor_151(e.thing); //Banshee
		
				if(d151)
				{
					d151.bNOBLOOD = true;
					d151.bNOBLOODDECALS = true;
					return;
				}
			}

			if(pb_ad_dehName == "rwdyrudy.wad:DEHACKED") //Rowdy Rudy's Revenge!
			{
				let cd = Cacodemon(e.thing); //Toxicaco
				
				if(cd)
					PB_AD_CopyBlood(e.thing, pb_ad_dummyRed);
				
				let pe = PainElemental(e.thing); //FireCacodemon
				
				if(pe)
					PB_AD_CopyBlood(e.thing, pb_ad_dummyYellow);
			}
			
			if(pb_ad_dehName == "rudy2.wad:DEHACKED") //Rowdy Rudy II: POWERTRIP!
			{
				let cd = Cacodemon(e.thing); //Toxicaco
				
				if(cd)
					PB_AD_CopyBlood(e.thing, pb_ad_dummyRed);
				
				let pe = PainElemental(e.thing); //FireCacodemon
				
				if(pe)
					PB_AD_CopyBlood(e.thing, pb_ad_dummyYellow);
				
				let ar = Arachnotron(e.thing); //PsychImp
				
				if(ar)
					PB_AD_CopyBlood(e.thing, pb_ad_dummyLimeGreen);
			}
			if(pb_ad_dehName == "xa-vesper_1.0.0.wad:DEHACKED") //Vesper
			{
				let d154 = DEH_Actor_154(e.thing); //Blunderbuss Shot 1
				
				if(d154)
				{
					d154.damageType = "Plasma";
					return;
				}
				
				let d155 = DEH_Actor_155(e.thing); //Blunderbuss Shot 2
				
				if(d155)
				{
					d155.damageType = "Plasma";
					return;
				}
				
				let d156 = DEH_Actor_156(e.thing); //Blunderbuss Shot 3
				
				if(d156)
				{
					d156.damageType = "Plasma";
					return;
				}
				
				let d157 = DEH_Actor_157(e.thing); //Ichor Bolt
				
				if(d157)
				{
					d157.damageType = "Blood";
					return;
				}
				
				let d159 = DEH_Actor_159(e.thing); //Hammer Wave
				
				if(d159)
				{
					d159.damageType = "Plasma";
					return;
				}
				
				let d161 = DEH_Actor_161(e.thing); //Vile Bolt
				
				if(d161)
				{
					d161.damageType = "Poison";
					return;
				}
				
				let d162 = DEH_Actor_162(e.thing); //Vile Bolt (Quiet)
				
				if(d162)
				{
					d162.damageType = "Poison";
					return;
				}
				
				let d164 = DEH_Actor_164(e.thing); //Hammer Wave (Invisible)
				
				if(d164)
				{
					d164.damageType = "Plasma";
					return;
				}
				
				let d165 = DEH_Actor_165(e.thing); //Nox Grenade
				
				if(d165)
				{
					d165.damageType = "Poison";
					return;
				}
				
				let d167 = DEH_Actor_167(e.thing); //Nox Explosion 1
				
				if(d167)
				{
					d167.damageType = "Poison";
					return;
				}
				
				let d168 = DEH_Actor_168(e.thing); //Nox Explosion 2
				
				if(d168)
				{
					d168.damageType = "Poison";
					return;
				}
				
				let d169 = DEH_Actor_169(e.thing); //Nox Explosion 3
				
				if(d169)
				{
					d169.damageType = "Poison";
					return;
				}
				
				let d170 = DEH_Actor_170(e.thing); //Nox Cloud
				
				if(d170)
				{
					d170.damageType = "Poison";
					return;
				}
			}
			if(pb_ad_dehName == "Twice a Veteran v1.3 paletted PNG graphics.wad:DEHACKED" ||
				pb_ad_dehName == "Twice a Veteran v1.3 Doom graphics.wad:DEHACKED") //Twice a Veteran
			{
				let d153 = DEH_Actor_153(e.thing); //Bazooka Rocket
				
				if(d153)
				{
					d153.damageType = "Fire";
					return;
				}
				
				let d155 = DEH_Actor_155(e.thing); //FlameShot
				
				if(d155)
				{
					d155.damageType = "Fire";
					return;
				}
				
				let d157 = DEH_Actor_157(e.thing); //FlakBomb
				
				if(d157)
				{
					d157.damageType = "Fire";
					return;
				}
				
				let d158 = DEH_Actor_158(e.thing); //ShrapnelA
				
				if(d158)
				{
					d158.damageType = "Fire";
					return;
				}
				
				let d159 = DEH_Actor_159(e.thing); //ShrapnelB
				
				if(d159)
				{
					d159.damageType = "Fire";
					return;
				}
				
				let d161 = DEH_Actor_161(e.thing); //BiggerExplosion
				
				if(d161)
				{
					d161.damageType = "Fire";
					return;
				}
			}
			if(pb_ad_dehName == "Doomed Marine V2 (Doom GFX).wad:DEHACKED" ||
				pb_ad_dehName == "Doomed Marine V2 (Paletted PNG GFX).wad:DEHACKED") //Doomed Marine
			{
				let d179 = DEH_Actor_179(e.thing); //Rocket
				
				if(d179)
				{
					d179.damageType = "Fire";
					return;
				}
				
				let d181 = DEH_Actor_181(e.thing); //PlasmaBolt
				
				if(d181)
				{
					d181.damageType = "Plasma";
					return;
				}
			}
			if(pb_ad_dehName == "Urban Warfare Doom GFX.wad:DEHACKED" ||
				pb_ad_dehName == "Urban Warfare PNG GFX.wad:DEHACKED") //Urban Warfare
			{
				let d180 = DEH_Actor_180(e.thing); //Grenade
				
				if(d180)
				{
					d180.damageType = "Fire";
					return;
				}
				
				let d181 = DEH_Actor_181(e.thing); //Flame
				
				if(d181)
				{
					d181.damageType = "Fire";
					return;
				}
			}
			if(pb_ad_dehName == "WHDAH.wad:DEHACKED") //We Have Doom At Home
			{
				let d184 = DEH_Actor_184(e.thing); //Grenade
				
				if(d184)
				{
					d184.damageType = "Fire";
					return;
				}
				
				let d185 = DEH_Actor_185(e.thing); //Flame
				
				if(d185)
				{
					d185.damageType = "Fire";
					return;
				}
			}
		}
	}
}
