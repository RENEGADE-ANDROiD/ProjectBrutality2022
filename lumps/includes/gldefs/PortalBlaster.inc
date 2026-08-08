// UAC Portal Blasters brightmaps (decibel / XV117)
Brightmap Sprite D4UPA0 { Map "brightmaps/WEAPONS/PortalBlaster/D4UPA0.png" DisableFullBright }
Brightmap Sprite D4UPB0 { Map "brightmaps/WEAPONS/PortalBlaster/D4UPA0.png" DisableFullBright }
Brightmap Sprite D4UPC0 { Map "brightmaps/WEAPONS/PortalBlaster/D4UPC0.png" DisableFullBright }
Brightmap Sprite D4UPD0 { Map "brightmaps/WEAPONS/PortalBlaster/D4UPC0.png" DisableFullBright }
Brightmap Sprite D4URA0 { Map "brightmaps/WEAPONS/PortalBlaster/D4URA0.png" DisableFullBright }
Brightmap Sprite D4URB0 { Map "brightmaps/WEAPONS/PortalBlaster/D4URA0.png" DisableFullBright }
Brightmap Sprite D4URC0 { Map "brightmaps/WEAPONS/PortalBlaster/D4URC0.png" DisableFullBright }
Brightmap Sprite D4URD0 { Map "brightmaps/WEAPONS/PortalBlaster/D4URC0.png" DisableFullBright }
Brightmap Sprite PLAGA0 { Map "brightmaps/WEAPONS/PortalBlaster/PLAGA0.png" DisableFullBright }
Brightmap Sprite PLAFA0 { Map "brightmaps/WEAPONS/PortalBlaster/PLAFA0.png" DisableFullBright }
Brightmap Sprite PLAFB0 { Map "brightmaps/WEAPONS/PortalBlaster/PLAFB0.png" DisableFullBright }
Brightmap Sprite PLAFC0 { Map "brightmaps/WEAPONS/PortalBlaster/PLAFC0.png" DisableFullBright }
Brightmap Sprite PLAFD0 { Map "brightmaps/WEAPONS/PortalBlaster/PLAFD0.png" DisableFullBright }
Brightmap Sprite PLAFE0 { Map "brightmaps/WEAPONS/PortalBlaster/PLAFE0.png" DisableFullBright }
Brightmap Sprite PLAFF0 { Map "brightmaps/WEAPONS/PortalBlaster/PLAFF0.png" DisableFullBright }
Brightmap Sprite PI2GA0 { Map "brightmaps/WEAPONS/PortalBlaster/DualWield/PI2GA0.png" DisableFullBright }
Brightmap Sprite PI2FA0 { Map "brightmaps/WEAPONS/PortalBlaster/DualWield/PI2FA0.png" DisableFullBright }
Brightmap Sprite PI2FB0 { Map "brightmaps/WEAPONS/PortalBlaster/DualWield/PI2FB0.png" DisableFullBright }
Brightmap Sprite PI2FC0 { Map "brightmaps/WEAPONS/PortalBlaster/DualWield/PI2FC0.png" DisableFullBright }
Brightmap Sprite PI2FD0 { Map "brightmaps/WEAPONS/PortalBlaster/DualWield/PI2FD0.png" DisableFullBright }
Brightmap Sprite PI2FE0 { Map "brightmaps/WEAPONS/PortalBlaster/DualWield/PI2GA0.png" DisableFullBright }
Brightmap Sprite PI2FF0 { Map "brightmaps/WEAPONS/PortalBlaster/DualWield/PI2GA0.png" DisableFullBright }
Brightmap Sprite PI3GA0 { Map "brightmaps/WEAPONS/PortalBlaster/DualWield/PI3GA0.png" DisableFullBright }
Brightmap Sprite PI3FA0 { Map "brightmaps/WEAPONS/PortalBlaster/DualWield/PI3FA0.png" DisableFullBright }
Brightmap Sprite PI3FB0 { Map "brightmaps/WEAPONS/PortalBlaster/DualWield/PI3FB0.png" DisableFullBright }
Brightmap Sprite PI3FC0 { Map "brightmaps/WEAPONS/PortalBlaster/DualWield/PI3FC0.png" DisableFullBright }
Brightmap Sprite PI3FD0 { Map "brightmaps/WEAPONS/PortalBlaster/DualWield/PI3FD0.png" DisableFullBright }
Brightmap Sprite PI3FE0 { Map "brightmaps/WEAPONS/PortalBlaster/DualWield/PI3GA0.png" DisableFullBright }
Brightmap Sprite PI3FF0 { Map "brightmaps/WEAPONS/PortalBlaster/DualWield/PI3GA0.png" DisableFullBright }
Brightmap Sprite D4DSA0 { Map "brightmaps/WEAPONS/PortalBlaster/DualWield/Select/D4DSA0.png" DisableFullBright }
Brightmap Sprite D4DSB0 { Map "brightmaps/WEAPONS/PortalBlaster/DualWield/Select/D4DSB0.png" DisableFullBright }
Brightmap Sprite D4DSC0 { Map "brightmaps/WEAPONS/PortalBlaster/DualWield/Select/D4DSC0.png" DisableFullBright }
Brightmap Sprite D4DSD0 { Map "brightmaps/WEAPONS/PortalBlaster/DualWield/Select/D4DSD0.png" DisableFullBright }
Brightmap Sprite D4DSE0 { Map "brightmaps/WEAPONS/PortalBlaster/DualWield/Select/D4DSE0.png" DisableFullBright }
Brightmap Sprite PI2KA0 { Map "brightmaps/WEAPONS/PortalBlaster/DualWield/PI2KA0.png" DisableFullBright }
Brightmap Sprite PI2KB0 { Map "brightmaps/WEAPONS/PortalBlaster/DualWield/PI2KB0.png" DisableFullBright }
Brightmap Sprite PI2KC0 { Map "brightmaps/WEAPONS/PortalBlaster/DualWield/PI2KC0.png" DisableFullBright }
Brightmap Sprite PI2KD0 { Map "brightmaps/WEAPONS/PortalBlaster/DualWield/PI2KD0.png" DisableFullBright }
Brightmap Sprite PI2KE0 { Map "brightmaps/WEAPONS/PortalBlaster/DualWield/PI2KE0.png" DisableFullBright }
Brightmap Sprite D4BPA0 { Map "brightmaps/WEAPONS/PortalBlaster/D4BPA0.png" DisableFullBright }

// Subtle portal particle / pad dynamic lights (SpawnParticle cannot bind GLDEFS).
pulselight PortalPadGlowRed
{
	color 1.0 0.28 0.08
	size 36
	secondarySize 52
	interval 0.35
	offset 0 4 0
	attenuate 1
}

pulselight PortalPadGlowBlue
{
	color 0.15 0.35 1.0
	size 36
	secondarySize 52
	interval 0.35
	offset 0 4 0
	attenuate 1
}

pulselight PortalWallGlowRed
{
	color 1.0 0.28 0.08
	size 40
	secondarySize 56
	interval 0.35
	offset 0 32 0
	attenuate 1
}

pulselight PortalWallGlowBlue
{
	color 0.15 0.35 1.0
	size 40
	secondarySize 56
	interval 0.35
	offset 0 32 0
	attenuate 1
}

object PB_PortalPadGlowA
{
	frame TNT1A { light PortalPadGlowRed }
}

object PB_PortalPadGlowB
{
	frame TNT1A { light PortalPadGlowBlue }
}

object PB_PortalCameraA
{
	frame TNT1A { light PortalWallGlowRed }
}

object PB_PortalCameraB
{
	frame TNT1A { light PortalWallGlowBlue }
}
