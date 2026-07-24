// Map light decorations â€” strobe for flames, soft pulse for tech/toxic/ice.

flickerlight2 DECO_CANDLE
{
	color 1.0 0.75 0.2
	size 28
	secondarySize 40
	interval 0.05
	offset 0 18 0
}

flickerlight2 DECO_TORCH_RED
{
	color 1.0 0.45 0.1
	size 48
	secondarySize 64
	interval 0.05
	offset 0 48 0
}

flickerlight2 DECO_TORCH_BLUE
{
	color 0.2 0.35 1.0
	size 48
	secondarySize 64
	interval 0.05
	offset 0 48 0
}

flickerlight2 DECO_TORCH_GREEN
{
	color 0.2 1.0 0.25
	size 48
	secondarySize 64
	interval 0.05
	offset 0 48 0
}

flickerlight2 DECO_SHORT_TORCH_RED
{
	color 1.0 0.45 0.1
	size 32
	secondarySize 44
	interval 0.05
	offset 0 28 0
}

flickerlight2 DECO_SHORT_TORCH_BLUE
{
	color 0.2 0.35 1.0
	size 32
	secondarySize 44
	interval 0.05
	offset 0 28 0
}

flickerlight2 DECO_SHORT_TORCH_GREEN
{
	color 0.2 1.0 0.25
	size 32
	secondarySize 44
	interval 0.05
	offset 0 28 0
}

pulselight DECO_TECHLAMP
{
	color 0.85 0.9 1.0
	size 48
	secondarySize 58
	interval 0.8
	offset 0 44 0
}

pulselight DECO_COLUMN
{
	color 0.9 0.95 1.0
	size 40
	secondarySize 48
	interval 1.0
	offset 0 40 0
}

pulselight DECO_BARREL_NUKAGE
{
	color 0.15 1.0 0.15
	size 36
	secondarySize 44
	interval 0.7
	offset 0 28 0
}

pulselight DECO_BARREL_ICE
{
	color 0.35 0.7 1.0
	size 36
	secondarySize 44
	interval 0.7
	offset 0 28 0
}

flickerlight2 DECO_BARREL_FLAME
{
	color 1.0 0.55 0.1
	size 52
	secondarySize 68
	interval 0.05
	offset 0 34 0
}

object PB_Candle
{
	frame CBR1 { light DECO_CANDLE }
}

object PB_Candlestick
{
	frame CAND { light DECO_CANDLE }
}

object PB_Candelabra
{
	frame CBRA { light DECO_CANDLE }
}

object PB_RedTorch
{
	frame TRED { light DECO_TORCH_RED }
}

object PB_BlueTorch
{
	frame TBLU { light DECO_TORCH_BLUE }
}

object PB_GreenTorch
{
	frame TGRN { light DECO_TORCH_GREEN }
}

object PB_ShortRedTorch
{
	frame SMRT { light DECO_SHORT_TORCH_RED }
}

object PB_ShortBlueTorch
{
	frame SMBT { light DECO_SHORT_TORCH_BLUE }
}

object PB_ShortGreenTorch
{
	frame SMGT { light DECO_SHORT_TORCH_GREEN }
}

object PB_Column
{
	frame COLU { light DECO_COLUMN }
}

object PB_TechLamp
{
	frame TLMP { light DECO_TECHLAMP }
}

object PB_TechLamp2
{
	frame TLP2 { light DECO_TECHLAMP }
}

// Merged onto NukageBarrel (explosion frames stay in GLDEFS.txt).
object NukageBarrel
{
	frame BA11 { light DECO_BARREL_NUKAGE }
	frame BAR1 { light DECO_BARREL_NUKAGE }
	frame BAR2 { light DECO_BARREL_NUKAGE }
	frame BAR3 { light DECO_BARREL_NUKAGE }
	frame BAR4 { light DECO_BARREL_NUKAGE }
	frame BAR5 { light DECO_BARREL_NUKAGE }
	frame BAR6 { light DECO_BARREL_NUKAGE }
	frame BAR7 { light DECO_BARREL_NUKAGE }
	frame BAR8 { light DECO_BARREL_NUKAGE }
	frame BFR1 { light DECO_BARREL_FLAME }
	frame BFR2 { light DECO_BARREL_FLAME }
	frame BFR3 { light DECO_BARREL_FLAME }
	frame BFR4 { light DECO_BARREL_FLAME }
	frame BFR5 { light DECO_BARREL_FLAME }
	frame BFR6 { light DECO_BARREL_FLAME }
	frame BFR7 { light DECO_BARREL_FLAME }
	frame BFR8 { light DECO_BARREL_FLAME }
	frame BIR1 { light DECO_BARREL_ICE }
	frame BIR2 { light DECO_BARREL_ICE }
	frame BIR3 { light DECO_BARREL_ICE }
	frame BIR4 { light DECO_BARREL_ICE }
	frame BIR5 { light DECO_BARREL_ICE }
	frame BIR6 { light DECO_BARREL_ICE }
	frame BIR7 { light DECO_BARREL_ICE }
	frame BIR8 { light DECO_BARREL_ICE }
}

object FlameBarrel
{
	frame BFR1 { light FIREBARREL }
	frame BFR2 { light FIREBARREL }
	frame BFR3 { light FIREBARREL }
	frame BFR4 { light FIREBARREL }
	frame BFR5 { light FIREBARREL }
	frame BFR6 { light FIREBARREL }
	frame BFR7 { light FIREBARREL }
	frame BFR8 { light FIREBARREL }
}

object BarrelFrozen
{
	frame BIR1 { light DECO_BARREL_ICE }
	frame BIR2 { light DECO_BARREL_ICE }
	frame BIR3 { light DECO_BARREL_ICE }
	frame BIR4 { light DECO_BARREL_ICE }
	frame BIR5 { light DECO_BARREL_ICE }
	frame BIR6 { light DECO_BARREL_ICE }
	frame BIR7 { light DECO_BARREL_ICE }
	frame BIR8 { light DECO_BARREL_ICE }
}
