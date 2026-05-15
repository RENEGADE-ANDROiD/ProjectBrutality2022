// Custom Shards & Potions (DarkShadow) — pulselights synced to updated addon reference (Downloads “GLDEFS (1)”).
// PB_* object frames use BON1/BON2 (vanilla bonus sprites); upstream file used B0N* which does not match real lumps.

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
	frame BON2 { light GREENITEM }
}

object PB_ArmorBonusBlue
{
	frame BON2 { light BLUEITEM }
}

object PB_ArmorBonusRed
{
	frame BON2 { light REDITEM }
}

object PB_ArmorBonusGold
{
	frame BON2 { light GOLDITEM }
}

object PB_HealthBonus1
{
	frame BON1 { light BLUEITEM }
}

object PB_HealthBonusGreen
{
	frame BON1 { light GREENITEM }
}

object PB_HealthBonusRed
{
	frame BON1 { light REDITEM }
}

object PB_HealthBonusGold
{
	frame BON1 { light GOLDITEM }
}
