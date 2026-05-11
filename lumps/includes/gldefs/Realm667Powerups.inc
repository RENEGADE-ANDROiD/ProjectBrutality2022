// Realm667 powerup lights — DeVloek (auras), Captain Toenail (Reflector Sphere / ShieldSphere),
// Ghastly_dragon (Wraith Hand, LichSkull, FlightSphere). Renamed (R667_*, etc.) to avoid clashes with PB stock lights.

flickerlight2 R667_FireAuraSphereLight
{
    color 1.0 0.6 0.3
    size 75
    secondarySize 100
    interval 0.05
    offset 0 16 0
    attenuate 1
}
object FireAuraSphere
{
    frame VFIA { light R667_FireAuraSphereLight }
}

flickerlight R667_FireAuraFireLight1 { color 1.0 0.6 0.3  size 36 secondarySize 48  chance 0.3 offset 0 8 0  attenuate 1 }
flickerlight R667_FireAuraFireLight2 { color 1.0 0.6 0.3  size 60 secondarySize 72  chance 0.3 offset 0 24 0 attenuate 1 }
flickerlight R667_FireAuraFireLight3 { color 1.0 0.5 0.3  size 96 secondarySize 108 chance 0.3 offset 0 32 0 attenuate 1 }
flickerlight R667_FireAuraFireLight4 { color 0.8 0.5 0.2  size 96 secondarySize 108 chance 0.3 offset 0 40 0 attenuate 1 }
flickerlight R667_FireAuraFireLight5 { color 0.8 0.4 0.2  size 96 secondarySize 108 chance 0.3 offset 0 48 0 attenuate 1 }
flickerlight R667_FireAuraFireLight6 { color 0.6 0.3 0.1  size 72 secondarySize 84  chance 0.3 offset 0 64 0 attenuate 1 }
flickerlight R667_FireAuraFireLight7 { color 0.4 0.2 0.1  size 48 secondarySize 60  chance 0.3 offset 0 72 0 attenuate 1 }
flickerlight R667_FireAuraFireLight8 { color 0.2 0.1 0.0  size 24 secondarySize 36  chance 0.3 offset 0 80 0 attenuate 1 }
object FireAuraFire
{
    frame VFIRA { light R667_FireAuraFireLight1 }
    frame VFIRB { light R667_FireAuraFireLight2 }
    frame VFIRC { light R667_FireAuraFireLight3 }
    frame VFIRD { light R667_FireAuraFireLight4 }
    frame VFIRE { light R667_FireAuraFireLight5 }
    frame VFIRF { light R667_FireAuraFireLight6 }
    frame VFIRG { light R667_FireAuraFireLight7 }
    frame VFIRH { light R667_FireAuraFireLight8 }
}

pointlight R667_FrostAuraSphereLight0 { color 0.4 0.4 1.0 size 60 offset 0 16 0 attenuate 1 }
pointlight R667_FrostAuraSphereLight1 { color 0.3 0.6 1.0 size  8 offset 0 16 0 attenuate 1 }
pointlight R667_FrostAuraSphereLight2 { color 0.3 0.6 1.0 size 16 offset 0 16 0 attenuate 1 }
pointlight R667_FrostAuraSphereLight3 { color 0.3 0.6 1.0 size 24 offset 0 16 0 attenuate 1 }
pointlight R667_FrostAuraSphereLight4 { color 0.3 0.6 1.0 size 32 offset 0 16 0 attenuate 1 }
pointlight R667_FrostAuraSphereLight5 { color 0.3 0.6 1.0 size 40 offset 0 16 0 attenuate 1 }
object FrostAuraSphere
{
    frame VFRA  { light R667_FrostAuraSphereLight0 }
    frame VFRAA { light R667_FrostAuraSphereLight1 }
    frame VFRAB { light R667_FrostAuraSphereLight1 }
    frame VFRAC { light R667_FrostAuraSphereLight1 }
    frame VFRAD { light R667_FrostAuraSphereLight1 }
    frame VFRAE { light R667_FrostAuraSphereLight2 }
    frame VFRAF { light R667_FrostAuraSphereLight3 }
    frame VFRAG { light R667_FrostAuraSphereLight4 }
    frame VFRAH { light R667_FrostAuraSphereLight5 }
}

pointlight R667_FrostAuraFreezeLight { color 0.2 0.2 0.4 size 64 offset 0 32 0 attenuate 1 }
object FrostAuraFreeze
{
    frame TNT1 { light R667_FrostAuraFreezeLight }
}

pointlight R667_FrostAuraFrozenLight { color 0.15 0.15 0.3 size 96 offset 0 32 0 attenuate 1 }
object FrostAuraFrozen
{
    frame TNT1 { light R667_FrostAuraFrozenLight }
}

pulselight R667_FlightSphere
{
    color 1.0 0.0 1.0
    size 40
    secondarySize 56
    interval 5.0
}
object FlightSphere
{
    frame FLYT { light R667_FlightSphere }
}

pulselight R667_ReflectorSphere
{
    color 1.0 0.5 0.0
    size 40
    secondarySize 42
    interval 2.0
    offset 0 16 0
}
object ReflectorSphere
{
    frame RFCT { light R667_ReflectorSphere }
}

flickerlight R667_WraithHand
{
    color 1.0 1.0 1.0
    subtractive 1
    size 28
    secondarySize 32
    chance 0.1
    offset 0 32 0
}
object HandOfTheWraith
{
    frame HWTH { light R667_WraithHand }
}

pointlight R667_LichSkull
{
    color 0.7 0.0 0.0
    size 32
    offset 0 30 0
}
object ArtiLichSkull
{
    frame LCHS { light R667_LichSkull }
}
