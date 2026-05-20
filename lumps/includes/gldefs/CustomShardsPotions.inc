// Custom Shards & Potions (DarkShadow) — pulselights + B0N1/B0N2 pickup sprites (sprites.wad fold).

pulselight REDITEM
{
	color 1.0 0.1 0.1
	size 12
	secondarySize 14
	interval 0.6
	offset 0 5 0
	dontlightself 1
}

pulselight WHITEITEM
{
	color 1.0 1.0 1.0
	size 12
	secondarySize 14
	interval 0.6
	offset 0 5 0
	dontlightself 1
}

pulselight GOLDITEM
{
	color 1.0 1.0 0.1
	size 12
	secondarySize 14
	interval 0.6
	offset 0 5 0
	dontlightself 1
}

pulselight PURPLEITEM
{
	color 1.0 0.1 1.0
	size 12
	secondarySize 14
	interval 0.6
	offset 0 5 0
	dontlightself 1
}

pulselight PINKITEM
{
	color 1.0 0.8 0.9
	size 12
	secondarySize 14
	interval 0.6
	offset 0 5 0
	dontlightself 1
}

pulselight CYANITEM
{
	color 0.1 1.0 1.0
	size 12
	secondarySize 14
	interval 0.6
	offset 0 5 0
	dontlightself 1
}

pulselight ORANGEITEM
{
	color 1.0 0.647 0.1
	size 12
	secondarySize 14
	interval 0.6
	offset 0 5 0
	dontlightself 1
}

object PB_ArmorBonus1
{
	frame B0N2 { light GREENITEM }
}

object PB_ArmorBonusBlue
{
	frame B0N2 { light BLUEITEM }
}

object PB_ArmorBonusRed
{
	frame B0N2 { light REDITEM }
}

object PB_ArmorBonusGold
{
	frame B0N2 { light GOLDITEM }
}

object PB_HealthBonus1
{
	frame B0N1 { light BLUEITEM }
}

object PB_HealthBonusGreen
{
	frame B0N1 { light GREENITEM }
}

object PB_HealthBonusRed
{
	frame B0N1 { light REDITEM }
}

object PB_HealthBonusGold
{
	frame B0N1 { light GOLDITEM }
}
