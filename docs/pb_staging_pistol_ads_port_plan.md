# Pistol / ADS — `PB_ReadyFire` port plan

## Status

- **Done:** `PB_Pistol` `ReadyToFire` / `ReadyToFire2` call `PB_ReadyFire` with `PrimaryPistolAmmo` and `PB_PistolHasUnloaded` on hip ready.
- **Done:** ZScript slot-2/3/4 ADS guns plus DECORATE **`MP40`**, **`UACSMG`**, **`SHOTGUN`**, **`LeverAction`**, **`LMG`**, **`PB_Fusil`** (see `pb_staging_baseweapon_merge.md`).

## Not planned (unless requested)

- ZScript-only `PB_Pistol` class — stays DECORATE `PB_Weapon`; dual-wield / riot-shield branches unchanged.
- Replacing `ReadyDualWield` with `PB_ReadyFire` — different overlay / ammo model.

## Regression checks

1. Hold ADS (`pb_toggle_aim_hold` on): release alt → `Zoomout`, weapon visible.
2. Tap ADS: fire from `ReadyToFire2` without holding alt+fire together (revolver: only needs fire in ADS).
3. Unloaded pistol: hip ready still respects `PB_PistolHasUnloaded` via `unloaderToken`.
4. `give all` — no invisible weapon after select (no `PB_GotoWeaponReadyView`).
