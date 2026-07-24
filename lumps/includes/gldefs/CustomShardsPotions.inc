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

pulselight GRAYITEM
{
	color 0.55 0.55 0.55
	size 12
	secondarySize 14
	interval 0.6
	offset 0 5 0
	dontlightself 1
}

pulselight ARMORPURPLE
{
	color 0.85 0.15 1.0
	size 44
	secondarySize 56
	interval 0.6
	offset 0 18 0
}

pulselight ARMORWHITE
{
	color 1.0 1.0 1.0
	size 44
	secondarySize 56
	interval 0.6
	offset 0 18 0
}

pulselight ARMORGOLD
{
	color 1.0 0.9 0.15
	size 44
	secondarySize 56
	interval 0.6
	offset 0 18 0
}

pulselight ARMORORANGE
{
	color 1.0 0.55 0.1
	size 44
	secondarySize 56
	interval 0.6
	offset 0 18 0
}

pulselight ARMORCYAN
{
	color 0.15 1.0 1.0
	size 44
	secondarySize 56
	interval 0.6
	offset 0 18 0
}

pulselight ARMORPINK
{
	color 1.0 0.55 0.75
	size 44
	secondarySize 56
	interval 0.6
	offset 0 18 0
}

pulselight ARMORGRAY
{
	color 0.55 0.55 0.55
	size 44
	secondarySize 56
	interval 0.6
	offset 0 18 0
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

object PB2022_RedArmor
{
	frame ARM3 { light ARMORRED }
}

object PB2022_PurpleArmor
{
	frame ARM6 { light ARMORPURPLE }
}

object PB2022_WhiteArmor
{
	frame ARM4 { light ARMORWHITE }
}

object PB2022_OrangeArmor
{
	frame ARM7 { light ARMORORANGE }
}

object PB2022_YellowArmor
{
	frame ARM5 { light ARMORGOLD }
}

object PB2022_BlackArmor
{
	frame ARM8 { light ARMORGRAY }
}

object PB2022_DemonArmor
{
	frame ARM9 { light ARMORRED }
}

object PB2022_CyanArmor
{
	frame BRM1 { light ARMORCYAN }
}

object PB2022_DarkPurpleArmor
{
	frame BRM4 { light ARMORPURPLE }
}

object PB2022_DarkRedArmor
{
	frame BRM7 { light ARMORRED }
}

object PB2022_GoldArmor
{
	frame BRM2 { light ARMORGOLD }
}

object PB2022_GrayArmor
{
	frame DUMY { light ARMORGRAY }
}

object PB2022_LightBlueArmor
{
	frame BRM3 { light ARMORBLUE }
}

object PB2022_LightGreenArmor
{
	frame BRM6 { light ARMORGREEN }
}

object PB2022_PinkArmor
{
	frame BRM5 { light ARMORPINK }
}
