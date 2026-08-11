// Ironblast-style Flak Cannon trail/impact composites (PBGuncasterV2).
// Patches: GRAPHICS/Effects/FlakCannon/{FLAKFLAR,SMOKE_01,EMBER_01}.png
// Sprite names FKFR/FKTR/FKEM are Flak-local (not FLFR/FLTR/FLEM).

Sprite FKFRA0B0, 256, 256
{
	Offset 128, 128
	Patch FLAKFLAR, 0, 0
	{
		Style Overlay
	}
}

Sprite FKFRC0D0, 256, 256
{
	Offset 128, 128
	Patch FLAKFLAR, 0, 0
	{
		FlipY
		Style Overlay
	}
}

Sprite FKTRA0B0, 256, 256
{
	Offset 128, 128
	Patch SMOKE_01, 0, 0
	{
		Blend "#E67A33"
		Style Overlay
	}
}

Sprite FKTRC0D0, 256, 256
{
	Offset 128, 128
	Patch SMOKE_01, 0, 0
	{
		FlipY
		Blend "#E67A33"
		Style Overlay
	}
}

Sprite FKTRE0F0, 256, 256
{
	Offset 128, 128
	Patch SMOKE_01, 0, 0
	{
		Blend "#ECAE2D"
		Style Overlay
	}
}

Sprite FKTRG0H0, 256, 256
{
	Offset 128, 128
	Patch SMOKE_01, 0, 0
	{
		FlipY
		Blend "#ECAE2D"
		Style Overlay
	}
}

Sprite FKEMA0B0, 176, 176
{
	Offset 88, 88
	Patch EMBER_01, 0, 0
	{
		Blend "#FD761C"
		Style Overlay
	}
}

Sprite FKEMC0D0, 176, 176
{
	Offset 88, 88
	Patch EMBER_01, 0, 0
	{
		FlipY
		Blend "#FF701A"
		Style Overlay
	}
}

Sprite FKEME0F0, 176, 176
{
	Offset 88, 88
	Patch EMBER_01, 0, 0
	{
		Blend "#FFC61A"
		Style Overlay
	}
}

Sprite FKEMG0H0, 176, 176
{
	Offset 88, 88
	Patch EMBER_01, 0, 0
	{
		FlipY
		Blend "#FFC61A"
		Style Overlay
	}
}

// Soft grey smoke trail (same patch, translucent grey blend)
Sprite FKSME0F0, 256, 256
{
	Offset 128, 128
	Patch SMOKE_01, 0, 0
	{
		Blend "#AAAAAA"
		Style Overlay
	}
}

Sprite FKSMG0H0, 256, 256
{
	Offset 128, 128
	Patch SMOKE_01, 0, 0
	{
		FlipY
		Blend "#CCCCCC"
		Style Overlay
	}
}
