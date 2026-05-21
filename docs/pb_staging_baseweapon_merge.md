# PB Staging BaseWeapon merge (PB 2022)

Curated notes for agents/maintainers. Player-facing summary lives in `CHANGELOG.md`.

## Safe to merge (done)

| Piece | Location |
| --- | --- |
| Staging shim (reload, chamber, `PB_WeaponRaise`, smoke, muzzle FX, …) | `zscript/Weapons/BaseWeapon_StagingShim.zsc` |
| `PB_IncrementHeat`, `PB_ReadyFire`, `PB_SetZoom`, `PB_GetZoom` | Staging shim |
| `PB_GunSmoke` → `PB_GunSmoke_Basic` | `zscript/Weapons/BaseWeapon.zc` |
| Barrel carry / throw / place | `zscript/Weapons/BaseWeapon_Barrels.zsc` |
| `HasBarrel` / `HasBurningBarrel` / `HasIceBarrel` → `ReadyBarrel*` | `A_DoPBWeaponAction` in `BaseWeapon.zc` |

## Do not re-merge without a new design

- **`PB_GotoWeaponReadyView` + trailing `Stop` on shared `Fire`/`Ready`** — cleared **PSP_WEAPON** and caused invisible first-person weapons after `give all` / new game.
- **Full tier ZScript weapon ports** (Carbine/Quad/Rail/Pistol as `.zs` replacements) — reverted; adopt per-weapon only with explicit ready-state review.

## `PB_ReadyFire` adoption

Shared ADS / hip-fire input router on `PB_WeaponBase`. Parameters:

- `ammoInv` — when not `'None'`, counts that inventory instead of `ammotype1`/`ammotype2` (pistol `PrimaryPistolAmmo`, shotgun `ShotgunAmmo`, …).
- `adsFireNeedsAlt` — `false` for revolver ADS hold (fire without requiring alt+fire pair).
- `unloaderToken` — passed to `CheckUnloaded` on idle `A_DoPBWeaponAction` (pistol `PB_PistolHasUnloaded`, sniper `SniperUnloaded`).
- `adsHoldWrFlags` — default `WRF_NOSECONDARY`; lever/LMG use `WRF_NOFIRE`.
- `adsTapUsesHipFire` — LMG tap-ADS uses hip `Fire` instead of `Fire2`.

Wired on: `PB_Pistol`, `PB_Deagle` / `PB_Revolver` / `PB_MetalSniper` (ZScript), ZScript pump shotgun, `PB_MP40`, `UACSMG`, DECORATE `SHOTGUN`, `LeverAction`, `PB_LMG`, `PB_Fusil` ADS ready.

**Not converted** (custom fire gating): `PB_Carbine`, scoped `PB_RocketLauncher`, `MG42`, `PBRIFLE`, `RAILGUN`.

Weapons with extra preamble (mag insert, shell sprites, heat) keep that logic and call `PB_ReadyFire` at the end of the state block.

## Barrel helpers

ZScript guns should call `PB_CheckBarrelThrow1()` (and `PB_CheckBarrelPlace1` / `Idle1` where staging did) from **Ready** before the main ready loop — see `CSSG.zs`, `NeoHMG.zs`, `Deagle.zs`.

## Tokens (PB 2022)

Use `HasBurningBarrel` / `GrabbedBurningBarrel` (not `*Flame*`). See `actors/Decorations/Barrels/Core/NukageBarrelTokens.dec`.

## Smoke test

```powershell
maint_scripts/Smoke-GZDoom.ps1 -Norun
```

Interactive: new game → `give all` → slot 2 pistol ADS → grab/throw barrel on Deagle/CSSG.
