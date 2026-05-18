/* Each array contains a damagetype or classname that is checked at the time of victim's death 
to determine AccuDeathEffects. Adding your own terms will include them in checks when something
dies in game. You can uncomment unused arrays for adding your own damagetypes or classnames
to enable their use in death handler checks as well. */

Class AccuDeathArrays : Object
{
/////Damagetype Arrays-----------------------------------------------------------------------

/* Adding a damagetype to the associated damage array will apply that effect to all deaths
caused by that attack. */
	
	static const string PlasmaDamageArray[] =
	{
		"Plasma",
		"PlasmaDamage",
		"BFG",
		"Photon",
		"Ion",
		"Laser",
		"Beam",
		"Fusion",
		"Radiant",
		"Disintegrate",
		"AlienEnergy",
		"Neutron",
		"Spiritual",
		"Purifying",
		"Pulse",
		"XSpark",
		"EnergyExplosive",
		"Energy",
		"BFGDamage",
		"BFGSplash",
		"YellowElectricity"
	};
	
	static const string FireDamageArray[] =
	{
		"Fire",
		"FireDamage",
		"Flame",
		"Hellfire",
		"Burn",
		"Heat",
		"Blaze",
		"Inferno",
		"Pyro",
		"Thermal",
		"Balefire",
		"Matriarch",
		"MeteorFist",
		"Spirytus",
		"FireMonsterDamage",
		"Vassago",
		"wepfire",
		"FireKorax",
		"Blast",
		"PlayerFire",
		"FirePlasma",
		"Coilgun",
		"Nuke",
		"PlayerGrenade",
		"PlayerMissile"
	};
	
	static const string GreenFireDamageArray[] =
	{
		"GreenFire",
		"GreenFireDamage",
		"GreenFlame",
		"Nuclear",
		"Nukage",
		"Acid",
		"AcidDemon",
		"Chaos",
		"Magic",
		"Tiberium",
		"AlienExplosion",
		"Radiation",
		"RadiationGas",
		"Radioactive",
		"Quietus"
	};
	
	static const string PurpleFireDamageArray[] =
	{
		"PurpleFire",
		"PurpleFireDamage",
		"PurpleFlame",
		"Purple",
		"Demonic",
		"DemonMagic",
		"Dark",
		"Darkness",
		"Evil",
		"Tachyon",
		"Unholy"
	};
	
	static const string BlueFireDamageArray[] =
	{
		"BlueFire",
		"BlueFireDamage",
		"BlueFlame",
		"BlueImpBall",
		"Abyss",
		"AbyssFire",
		"BlueTiberium"
	};
	
	static const string ElectricDamageArray[] =
	{
		"Electric",
		"ElectricDamage",
		"BlueElectric",
		"Electro",
		"Lightning",
		"LightningDamage",
		"BlueLightning",
		"LightningBlue",
		"Annihilation",
		"Bolt",
		"BlueBolt",
		"Spark",
		"BlueSpark",
		"Shock",
		"BlueShock",
		"BlueLaser"
	};
	
	static const string GreenElectricDamageArray[] =
	{
		"GreenElectric",
		"GreenLightning",
		"GreenBolt",
		"GreenSpark",
		"GreenShock"
	};
	
	static const string RedElectricDamageArray[] =
	{
		"RedElectric",
		"RedLightning",
		"RedBolt",
		"RedSpark",
		"Breath",
		"Myrkura",
		"Maser",
		"RedShock",
		"RedLaser"
	};
	
	static const string BloodDamageArray[] =
	{
		"Blood",
		"BloodDamage",
		"Flesh",
		"wepBlood"
	};
	
	static const string PoisonDamageArray[] =
	{
		"Poison",
		"PoisonDamage",
		"PoisonCloud",
		"Gas",
		"Toxic",
		"Bio",
		"Plague",
		"Rot",
		"Venom"
	};
	
	static const string HolyDamageArray[] =
	{
		"Holy",
		"HolyDamage",
		"HolyShock",
		"Astral",
		"UndeadGoHome",
		"Sacred",
		"Divine",
		"Blessed",
		"Light"
	};
	
/////Projectile Class Arrays-----------------------------------------------------------------

/* If a projectile does not have a damagetype, or has a damagetype that does not match the 
resulting death effects, adding its classname will override those effects and use the associated 
class array instead to determine effects. This is also where you place Archvile variants to get
the correct death effects. */

	static const string PlasmaClassArray[] =
	{
		"UnmakerLaser",
		"D64UE_BFGBall",
		"D64UE_PlasmaBall",
		"D64UE_Weapon_Unmaker",
		"NewSoulScreamer",
		"RLRailPuff",
		"RLAbominantGravityPulse",
		"EnergyBolt",
		"EnergyBolt2",
		"EnergyBolt3",
		"HeavyEnergyBolt",
		"ArachPlasma",
		"AltPlasmaRay",
		"AltPlasmaBall",
		"BFGprojectile",
		"newBFGExtra",
		"SpiderShot",
		"SpiderShotSl",
		"SpiderRadial",
		"HolyRocket",
		"HolyShockPuff",
		"BD_ArachnotronPlasma",
		"BD_ModernArachnotronPlasma",
		"SDBFGBall",
		"SDBFGExtra",
		"TerminatorLaser",
		"Plasma_Ball",
		"SuperBFGBall",
		"PB_DMR_PulseBall"
	};
	
	static const string FireClassArray[] =
	{
		"64MotherBall",
		"64MotherFire",
		"D64UE_CacodemonBall",
		"D64UE_DoomImpBall",
		"D64UE_MancubusProjectile",
		"JGP_HeatWaveRipper",
		"JGP_IncineratorFlame",
		"CalamitySlice",
		"IncineratorFire",
		"IncineratorFire2",
		"IncineratorFire3",
		"GhoulFireball",
		"VassagoFireball",
		"FireShotFire1",
		"FireBomb1",
		"FatShotFireBoss",
		"FatShotFireBossEasy",
		"FatShotFireBossMedium",
		"ImpShotFireBoss",
		"ImpShotFireBossEasy",
		"ImpShotFireBossMedium",
		"HieroBall1",
		"HieroBall2",
		"BasiliskFire",
		"VeilimpFireball",
		"VeilimpFlame",
		"AstralBabyFireball",
		"ZBlaster",
		"ZDirectBlaster",
		"FatsoFireBall",
		"FatWaves",
		"SuperImpBall",
		"ComicRocket",
		"ComicGuided",
		"CyberDemonRocket",
		"BD_Rocket",
		"BD_HomingRocket",
		"BD_ModernRocket",
		"BD_ModernGrenade",
		"CyberRail",
		"AM_Doom_Imp_Ball",
		"WarDoomImpBall",
		"Cyber_Tracer",
		"ThrownGrenadeEnemy",
		"DroppedGrenade",
		"SmoothRocket",
		"SDRocket",
		"Archvile",
		"Delta_Archvile",
		"NewArchvile",
		"RLArchvile",
		"GuncastArchvile",
		"FlameBoi",
		"D64UE_Archvile",
		"BD_ArchVile",
		"AM_Archvile",
		"PB_DoomImpBall",
		"FireBall_",
		"BigFireBall",
		"RevenantBalls"
	};
	
	static const string GreenFireClassArray[] =
	{
		"QuietusTorpedo", 
		"QuietusTorpedoUpgraded",
		"BaronMeteor",
		"RumblerMarquis",
		"MarquisFlames",
		"ChevalierShot",
		"FlameThrCacoLich",
		"BishopFXWalp",
		"ZCounter",
		"NACCFireball", 
		"HecteBall",
		"HecteBallEasy",
		"HecteBallMedium",
		"BlobBall",
		"BlobBallEasy",
		"BlobBallMedium",
		"DarkMiniBlast",
		"BaronBall2",
		"AM_Default_Baron_Ball",
		"Darkvile",
		"GreenPlasmaBall"
	};

// Adding a custom barrel classname to this list will include it when checking "Doom barrel damagetype" CVar.

	static const string BarrelClassArray[] =
	{
		"ExplosiveBarrel",
		"SexyBarrel",
		"PandExplosiveBarrel",
		"NewExplosiveBarrel",
		"SDExplosiveBarrel",
		"AM_Explosive_Barrel"
	};
	
	static const string PurpleFireClassArray[] =
	{
		"NightmareImpBall",
		"64NightmareImpBall",
		"D64UE_NightmareImpBall",
		"DarkSeeker",
		"DarkNormal",
		"DarkStrong",
		"Seekersaw",
		"MirvBombsAgnus",
		"WizardDeathFlower",
		"UfetubusGas",
		"NACFireball",
		"AstralCacoCFireball"
	};
	
	static const string BlueFireClassArray[] =
	{
		"OriasFireBall",
		"GDukeFireball",
		"GDukeBoltA",
		"GDukeBoltB",
		"GDukeBoltC",
		"GDukeBoltD",
		"ZBolt2A",
		"ZBolt2B",
		"ZBolt2C",
		"ZBolt2D",
		"ZTracer"
	};
	
	static const string ElectricClassArray[] =
	{
		"StaffPuff2",
		"CentaurFXWalp",
		"ZBolt",
		"FAxePuffGlow",
		"FAxePuffGlowSide",
		"BD_CacodemonBall",
		"TankLaser",
		"CacodemonBall_",
		"LightningMissile2"
	};
	
	static const string GreenElectricClassArray[] =
	{
		"GauntletPuff1",
		"JaegarShot",
		"DarkvileLightningBall",
		"DroidLaser"
	};
	
	static const string RedElectricClassArray[] =
	{
		"GauntletPuff2",
		"BladePuff2",
		"BladePuff3",
		"BladeSlash1",
		"MonsterVorpalSlash",
		"CyberGunnerLaser",
		"ArachLaser",
		"JaegarShotHoming",
		"OrkFXWalp",
		"MyrkuraBall",
		"MyrkuraEvocationBolt",
		"ImpLaser",
		"HunterLaser",
		"HunterMissile",
		"GenieLaser"
	};
	
	static const string BloodClassArray[] =
	{
		"BloodShot",
		"BloodFiendBile",
		"DespicableBile",
		"WalpKnightAxeRed",
		"MineHead",
		"RedAxe"
	};
	
	static const string PoisonClassArray[] =
	{
		"Rot",
		"RotToxicZone",
		"NecroFireball",
		"Pod",
		"SerpentMissile",
		"SerpentPuff"
	};
	
	static const string HolyClassArray[] =
	{
		""
	};
	
/////Weapon Class Arrays---------------------------------------------------------------------

/* BFG-style screen clearing weapons must be checked specifically to apply effects to all
victims of weapon damage. Add weapon classnames below to correctly apply intended effects for 
these weapons. */

	static const string PlasmaWeaponArray[] =
	{
		"BFG9000",
		"D64UE_Weapon_Unmaker",
		"D64UE_Weapon_BFG9000",
		"64BFG9000",
		"Z86BFG9000",
		"RLBFG9000",
		"RLNuclearBFG9000",
		"RLBFGInfinity",
		"RLHighPowerNuclearBFG9000",
		"RLVBFG9000",
		"RLNuclearVBFG9000",
		"FDPlutBFG9000",
		"FDTNTBFG9000",
		"FDDoom2BFG9000",
		"FDJPCPBFG9000",
		"LDBFG9000",
		"DustBFG9000",
		"BD_BFG9000",
		"SDBFG9000",
		"newBFG9000"
	};
	
	static const string FireWeaponArray[] =
	{
		"FDHellboundBFG9000"
	};
	
	/*static const string GreenFireWeaponArray[] =
	{
	};*/
	
	static const string PurpleFireWeaponArray[] =
	{
		"Agnus"
	};
	
	/*static const string BlueFireWeaponArray[] =
	{
	};*/
	
	static const string ElectricWeaponArray[] =
	{
		"SapphireWand",
		"ArcOfDeath",
		"Terrortron"
	};
	
	/*static const string GreenElectricWeaponArray[] =
	{
	};*/
	
	/*static const string RedElectricWeaponArray[] =
	{
	};*/
	
	/*static const string BloodWeaponArray[] =
	{
	};*/
	
	/*static const string PoisonWeaponArray[] =
	{
	};*/
	
	/*static const string HolyWeaponArray[] =
	{
	};*/
	
/////Damaging Floor Arrays-------------------------------------------------------------------
	
/* Each flat name is checked to apply correct effects on player death resulting from
damaging floors. */
	
	/*static const string PlasmaFloorArray[] =
	{
	};*/
	
	static const string FireFloorArray[] =
	{
		"Lava1",
		"Lava2",
		"Lava3",
		"Lava4",
		"RRock01",
		"RRock02",
		"RRock04",
		"RRock05",
		"RRock06",
		"RRock07",
		"RRock08",
		"Slime09",
		"Slime10",
		"Slime11",
		"Slime12"
	};
	
	static const string GreenFireFloorArray[] =
	{
		"Nukage1",
		"Nukage2",
		"Nukage3"
	};
	
	/*static const string PurpleFireFloorArray[] =
	{
	};*/
	
	/*static const string BlueFireFloorArray[] =
	{
	};*/
	
	/*static const string ElectricFloorArray[] =
	{
	};*/
	
	/*static const string GreenElectricFloorArray[] =
	{
	};*/
	
	/*static const string RedElectricFloorArray[] =
	{
	};*/
	
	static const string BloodFloorArray[] =
	{
		"Blood1",
		"Blood2",
		"Blood3"
	};
	
	static const string PoisonFloorArray[] =
	{
		"FLTSLUD1"
	};
	
	/*static const string HolyFloorArray[] =
	{
	};*/
	
	static const string GoreArray[] =
	{
		"NashgoreGib"
	};

}
