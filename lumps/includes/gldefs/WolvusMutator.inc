pulselight GTRZOULSPHERE
{
	color 1.0 0.0 0.0
	size 40
	secondarySize 42
	interval 2.0
	offset 0 16 0
}

pulselight TIMEFREEZESPHERE
{
	color 0.8 0.8 0.8
	size 40
	secondarySize 42
	interval 2.0
	offset 0 16 0
}

pulselight RAGESPHERE_LT
{
	color 0.3 0.3 0.0
	size 32
	secondarySize 48
	interval 3.0
	offset 0 18 0
}

pulselight REDITEM
{
	color 1.0 0.0 0.0
	size 14
	secondarySize 16
	interval 0.1
	offset 0 5 0
}

pulselight YELLOWITEM
{
	color 1.0 1.0 0.0
	size 14
	secondarySize 16
	interval 0.1
	offset 0 5 0
}

pulselight WOLVX_MEGASPHERE
{
	color 0.5 0.5 0.4
	size 40
	secondarySize 42
	interval 2.0
	offset 0 16 0
}

object TimeSphere
{
	frame TIME { light TIMEFREEZESPHERE }
}

object RageSphere
{
	frame RAGE { light RAGESPHERE_LT }
}

object EnergySphere
{
	frame MEGA { light WOLVX_MEGASPHERE }
}

object UltraSphere
{
	frame ULTR { light TIMEFREEZESPHERE }
}

object NewLifeSphere
{
	frame GZUL { light GTRZOULSPHERE }
}

object StrongHealthPlus
{
	frame BON3 { light BLUEITEM }
}

object SuperHealthPlus
{
	frame BON5 { light REDITEM }
}

object PristineHealthPlus
{
	frame BON7 { light YELLOWITEM }
}

object StrongArmorShard
{
	frame BON4 { light BLUEITEM }
}

object SuperArmorShard
{
	frame BON6 { light REDITEM }
}

object PristineArmorShard
{
	frame BON8 { light YELLOWITEM }
}

object DemonStrengthRune
{
	frame DPRF { light GTRZOULSPHERE }
}
