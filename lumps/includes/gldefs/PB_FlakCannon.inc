// Flak Cannon Ironblast-style trail/impact lights (PBGuncaster IRONFLIGHT / IRONIMPACT).

PointLight PB_FlakTrailLight
{
	color 1.0 0.7 0.1
	size 24
}

PulseLight PB_FlakImpactLight
{
	color 1.0 0.7 0.1
	size 48
	secondarySize 0
	interval 1.3
}

object PB_FlakImpactGlow
{
	frame TNT1A { light PB_FlakImpactLight }
}
