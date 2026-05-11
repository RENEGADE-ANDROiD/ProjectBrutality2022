// Realm 667 — Blood Ghost (KILLA DIO) + Blood Skull (Gothic); R667_ light names avoid clashes with PB / BD / MP.

Pointlight R667_BloodGhost
{
    color 1.0 0.0 0.0
    size 30
}
object PB_Realm667_BloodGhost
{
    Frame GHSTE { light R667_BloodGhost }
}
object PB_Realm667_BloodGhostGK
{
    Frame GHSTE { light R667_BloodGhost }
}

Pulselight R667_BloodGhostPickup
{
    color 1.0 0.0 0.0
    size 10
    secondarySize 20
    interval 5
}
object GhostHealthBonus
{
    Frame GHPK { light R667_BloodGhostPickup }
}

Pulselight R667_BloodGhostBall
{
    color 1.0 0.0 0.0
    size 10
    secondarySize 20
    interval 0.5
}
object Realm667_GhostBall
{
    Frame GBOM { light R667_BloodGhostBall }
}

Flickerlight R667_BloodSkull_X1
{
    color 0.8 0.3 0.0
    size 52
    secondarySize 60
    chance 0.25
}
Flickerlight R667_BloodSkull_X2
{
    color 0.8 0.3 0.0
    size 56
    secondarySize 64
    chance 0.25
}
Flickerlight R667_BloodSkull_X3
{
    color 0.6 0.2 0.0
    size 68
    secondarySize 76
    chance 0.25
}
Flickerlight R667_BloodSkull_X4
{
    color 0.4 0.1 0.0
    size 84
    secondarySize 92
    chance 0.25
}
Flickerlight R667_BloodSkull_X5
{
    color 0.2 0.0 0.0
    size 92
    secondarySize 100
    chance 0.25
}
object PB_Realm667_BloodSkull
{
    frame SWBSD { light R667_BloodSkull_X1 }
    frame SWBSE { light R667_BloodSkull_X2 }
    frame SWBSF { light R667_BloodSkull_X3 }
    frame SWBSG { light R667_BloodSkull_X4 }
    frame SWBSH { light R667_BloodSkull_X5 }
}
object PB_Realm667_BloodSkullGK
{
    frame SWBSD { light R667_BloodSkull_X1 }
    frame SWBSE { light R667_BloodSkull_X2 }
    frame SWBSF { light R667_BloodSkull_X3 }
    frame SWBSG { light R667_BloodSkull_X4 }
    frame SWBSH { light R667_BloodSkull_X5 }
}
object PB_Realm667_BloodSkull_Execution
{
    frame SWBSD { light R667_BloodSkull_X1 }
    frame SWBSE { light R667_BloodSkull_X2 }
    frame SWBSF { light R667_BloodSkull_X3 }
    frame SWBSG { light R667_BloodSkull_X4 }
    frame SWBSH { light R667_BloodSkull_X5 }
}
