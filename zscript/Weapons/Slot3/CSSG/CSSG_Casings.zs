// CSSG shell casings (parity fold from PBX-Weapons Slot-3/CSSG/Casings.zs).
// PBX's Casings.zs relies on a `PB_CasingBase.CasingSprite 'XXXX'` property that
// doesn't exist in PB2022; the PB2022 casing base `ShotgunCasing` hardcodes its
// spin / rest sprites in the state machine. Rather than port the PBX sprite set
// (CASX / CAS9 / XCS1 / CAF8 / WCS1 / TDS1 / DC0S) as brand-new state machines,
// we alias each PBX shell-casing name to the closest existing PB2022 casing so
// that `PB_SpawnCasing("...ShellCasing", ...)` from `CSSG.zs` actually spawns
// something. ShotgunCasing2 (CAS5) / ShotgunCasing3 (CAS6) pair well with slug
// and dragon shells; the rest fall back to the default ShotgunCasing (CAS1).

class BuckShellCasing      : ShotgunCasing  {}
class SlugShellCasing      : ShotgunCasing2 {}
class DragonShellCasing    : ShotgunCasing3 {}
class ExplosiveShellCasing : ShotgunCasing  {}
class FlakShellCasing      : ShotgunCasing  {}
class FlechetShellCasing   : ShotgunCasing  {}
class WhitePShellCasing    : ShotgunCasing  {}
