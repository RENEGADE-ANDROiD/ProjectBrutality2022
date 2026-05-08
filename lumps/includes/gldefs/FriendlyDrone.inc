// Friendly Drone summon (kill-streak Familiar reskin) lights.
// See actors/Items/PBKillstreak/PB_UnlessYouHavePowah.dec for the actor flow:
//   - Familiar / FamiliarSummonThrown / FriendlyDroneShot get the Drone /
//     DroneShot lights via the existing Realm667 Drone GLDEFS block (HDRN/DRON/
//     DROS frames) so the friendly helper visually matches the hostile drone.
//   - DroneFlashlightBeam + DroneFlashlightLens are separate forward-projected
//     dynamic lights spawned each chase pass when cl_drone_flashlight is on.
// Lights renamed with the PB-style "DroneFlashLight*" prefix so they don't
// collide with the upstream "DroneFire*" / "DroneDeath*" / "DroneShotLight*"
// names already used by the hostile drone.

// Drone "flashlight" pool. The Familiar Chase loop spawns one helper actor
// (DroneFlashlightBeam) AT the drone (offset 0, 0, 6) every chase pass when
// `cl_drone_flashlight` is on, and that helper carries this dynamic light.
//
// History note (2026-05): two earlier shapes failed --
//   1. `Pointlight` spawned 192 mu in front of the drone. Read as a "cone"
//      via the spherical falloff, but in tight rooms the spawn position
//      ended up inside / behind the wall the drone was facing and produced
//      no visible illumination at all (user repro: "With the Drone
//      lightbeam toggled on, it doesn't project any light").
//   2. `Spotlight` top-level type. UZDoom 4.14.3's GLDEFS parser rejects
//      the `Spotlight` tag with `Unknown tag: Spotlight.` (the engine only
//      first-classes PointLight / PulseLight / FlickerLight / FlickerLight2
//      / SectorLight; spotlight support, where present, is via a `spot`
//      modifier inside a Pointlight block which isn't guaranteed in this
//      engine line).
//
// Working shape: plain `Pointlight` with a generous radius (size 192) so
// the spherical falloff illuminates the drone's surroundings clearly --
// effectively a "lantern" the drone carries rather than a directional
// flashlight cone. If a true forward-cast cone is wanted later, the
// cleanest path is `Actor.A_AttachLight(... DynamicLight.SpotLight ...)`
// from the FamiliarBase ZScript (which is already wired in), gated on
// the same `cl_drone_flashlight` cvar via Tick().
Pointlight DroneFlashLightCone
{
    color 0.85 0.92 1.0
    size 192
}

// Eye-glow lens at the drone's forward sprite position. Small + dim so it
// reads as "the drone has a flashlight" without competing with the Drone's
// own missile-state DroneFire1 / DroneFire2 lights when it's shooting.
Pointlight DroneFlashLightLens
{
    color 0.7 0.85 1.0
    size 14
}
