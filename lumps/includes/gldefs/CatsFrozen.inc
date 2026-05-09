// Cat's Frozen Addon — lights folded from upstream GLDEFS (class names aligned with PB ZScript).

pointlight PBCF_CryocubusLanzaHieloLite
{
	color 0.1 0.1 0.125
	size 56
	offset 0 0 0
}

object PBCF_CryocubusLanzaHielo
{
	frame HUMO { light PBCF_CryocubusLanzaHieloLite }
}

pointlight PBCF_CRYO_FROSTBALL
{
	color 0.4 0.4 1.0
	size 72
	attenuate 1
}

pointlight PBCF_CRYO_FROSTBALL_X1
{
	color 0.4 0.4 1.0
	size 96
	attenuate 1
}

pointlight PBCF_CRYO_FROSTBALL_X2
{
	color 0.2 0.2 0.7
	size 84
	attenuate 1
}

pointlight PBCF_CRYO_FROSTBALL_X3
{
	color 0.1 0.1 0.4
	size 72
	attenuate 1
}

pointlight PBCF_CRYO_FROSTBALL_X4
{
	color 0.0 0.0 0.2
	size 60
	attenuate 1
}

object PBCF_Cryotron_Ball
{
	frame ICEB { light PBCF_CRYO_FROSTBALL }
}

object PBCF_Cryotron_Big_Ball
{
	frame ICEB { light PBCF_CRYO_FROSTBALL }
}
