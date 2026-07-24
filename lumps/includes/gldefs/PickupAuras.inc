// Missing armor / powerup class bindings (do not re-bind classes that already have lights
// in GLDEFS.txt or WolvusMutator.inc — LifeSphere, EnergySphere, HasteSphere, DoubleSphere,
// TimeSphere, RageSphere, UltraSphere, NewLifeSphere, DemonStrengthRune).

object PB_RedArmor
{
	frame 4RM3 { light ARMORRED }
}

object EliteArmor
{
	frame 4RM4 { light ARMORRED }
}

object PristineArmor
{
	frame 4RM5 { light ARMORGOLD }
}

pulselight PICKUPNIGHTVISION
{
	color 1.0 0.2 0.15
	size 28
	secondarySize 36
	interval 0.6
	offset 0 12 0
}

object InvulnerabilitySphere_
{
	frame PINV { light INVULN }
}

object NightVision
{
	frame PVIS { light PICKUPNIGHTVISION }
}

object KSFreeze
{
	frame HAST { light HasteSphereGlow }
}
