# Changelog

All notable changes for this working tree are documented here. Earlier history lives in `git log`; this file tracks the consolidated **2026-04-21 → 2026-04-30** session (and follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) style).

## [Unreleased]

### Added

- Peacekeeper / Marauder **SSG** fold-in from PB3.0 (`d6bbe88db`).
- Refreshed **SSG** sprite sets (kick, reload, fire, respect, select) including follow-up missed lumps (`e0076241d`, `f5eba713f`).
- **Shield Saw** and **Mastermind Chaingun** integration with spawner and HUD wiring (`b5c61d297`, related `7003ef7b3`, `bb1099367`).
- Large **MP execution** surface: `actors/Execution/*.dec`, `BaseWeapon_MPExecutionHelpers.zsc` / `BaseWeapon_MPExecutions.zsc`, matching **`SPRITES/Execution/**`** art (`0b3ae6a04`).
- **Metal Sniper** ZScript implementation and helpers (`0b3ae6a04`, fixes in `c70971995`, `4d8c11fd0`).
- **M41A** ZScript port and related DECORATE support (`0b3ae6a04`, `c70971995`).
- **LooseRounds** and related weapon plumbing (`0b3ae6a04`).
- Smoke / verification tooling: `tools/smoke_run_gzdoom*.ps1`, `smoke_update_tc_zip.ps1`, `verify_zip_baseweapon.ps1`, `list_baseweapon_zip.ps1` (`0b3ae6a04`).
- **Explosive movement** (`pb_rocketjump` / `pb_plasma_wallclimb` patterns) and **WolvusMutator** fold (`ed7f66dd2`, `910d1d46e`, `0b8eef3c4`).
- **Pump shotgun** / **auto shotty** pickup sprites **SHTCA0** / **AUSCA0** (PB Staging) under **PumpShotgun** / **AUTOSHOTTY** asset paths.

### Changed

- **Carbine**: weapon-select fixes; obsolete Carbine sprite lumps removed (`e0076241d`).
- **NeoHMG** deployed shield: floor sampling / `ZatPoint` `Vector2`, no player tracking, locked deploy yaw, `damageCredit` for shield-death burst, wall-facing presentation and scale (`0b3ae6a04`); follow-up **deployment position** tweak (`fef269dba`).
- **PB_WeaponTacticalFeel**: suppress tactical tilt/roll on NeoHMG fire so state-authored offsets stay stable (`0b3ae6a04`).
- Weapon-special **wheel**: reset freeze state on `WorldLoaded` (`0b3ae6a04`).
- **BDP Battle Rifle**: burst audio pacing and auto-reload on empty mag (`11504c30e`).
- **Hell Pistoler** / **Demon-Tech Minigun** rework tracks in history (`1e46ff7dc`); DTech Minigun later **disabled** as broken (`5be253ff0`).
- Menus, tooltips, **Glory Kills** options, killstreak messaging (`e2687bc02`, `8697c2951`, `10e37b923`).
- Wall-detection lowering and **Tilt++** / tactical motion (`5b67a2849`, `6dc1cd6c1`, `1edce0b20`, `eb942028f`).
- Gore handlers (BDv22 merge, BPv10, Nash, death-boost) and **pb_enhanced_brutality_2022** integration touches (`960e3aa36`, `fc291df83`, `08cde24c6`, `79140dc1c`).
- Branding: killstreak icon **UAC** instead of UT-style (`e0fdfaa8e`); title / logo assets (`4e9f42267`, `2a288a08d`, `4eb7ae9bc`).
- **Weapon slot cycling:** **PlayerPawnBase** overrides **PickNextWeapon** / **PickPrevWeapon** (higher wrap budget; fallback when the ready weapon is missing from the slot table).
- **Pump shotgun:** states use **SH0G** sprite prefix to match shipped **PumpShotgun** lumps; full PB Staging **PumpShotgun** sprite tree synced to the repo.
- **Flamethrower** / **hell rifle:** **Weapon.SlotNumber** and **Player.WeaponSlot** set to slot **9** for consistent next/prev cycling with the updated slot logic.

### Fixed

- **Riot shield**: HUD ammo, duplicate shield sprite, double-fire (`5db3cd00b`).
- **UZDoom startup**: `NoDelay`, `Vel.LengthXY`, `A_RadiusGive` compatibility (`a3a7ede64`).
- **HASG** sound, **Metal Sniper** reload, **M41A** / Battle Rifle damage (`c70971995`).
- **Metal Sniper**: infinite reload loop and **SniperAmmo** backpack overflow (`4d8c11fd0`).
- General error/warning cleanup passes (`4926d43ba`, `79140dc1c`).
- **Carbine** reticle and related issues (`761e502d7`).
- **ShieldSaw.dec** / ACS callback flow maintenance (`07d57f6b7`).
- **First-person legs:** **PB_WeaponRaise** uses legs overlay **-10** (matches **SelectFirstPersonLegs**) instead of **-1000**.
- **SSG / quad shotgun:** removed invalid **PB_WeaponBase.Upgrade** from **SSG.dec**; **PB_jumpIfNoAmmo()** DECORATE empty-paren fixes in **SSG.dec** / **QUADBARREL.dec**; removed dead **HasNotPickedUpSSG** line; quad ammo HUD uses **SGN3A0** when **QSGSA0** is absent; dropped stray **SSG_Staging** paths list lump.
- **PB_Freezer:** **UnloaderToken** handling aligned with unload / slot-cycle behavior.

### Removed

- **Demon-Tech Minigun** as a supported spawn/player weapon (broken); references toggled off per mod policy (`5be253ff0`).

### Documentation

- **`README.md`**, **`AGENTS.md`**, **`CREDITS.txt`**: maintenance across `63cf5d62e`, `5213ff4df`, `27d6d37d6`, `a7483b3f1`, and the large **`0b3ae6a04`** doc pass.

### Pending / follow-up (commit when ready)

- **`Fontdefs.txt`**: Glory Kill HUD entries should use **`graphics/hud/...png`** TexMan paths so font textures resolve when `GRAPHICS/HUD/` is shipped.
- Ensure **PB_Staging** parity for **`GRAPHICS/HUD/glorykills/newhud/`** and **`SPRITES/ShoulderCannon/`** is committed so zips include Eternal HUD + shoulder launcher art.
- **Mastermind Chaingun**: document **`pb_plasma_wallclimb`** / self-splash behavior in a focused commit if implemented locally.

---

## Reference commits (umbrella)

| Topic | Example hashes |
| --- | --- |
| SSG / Peacekeeper | `d6bbe88db`, `e0076241d`, `f5eba713f` |
| NeoHMG shield | `0b3ae6a04`, `fef269dba` |
| Shield Saw / Mastermind CG | `b5c61d297`, `07d57f6b7` |
| UZDoom / weapons | `a3a7ede64`, `c70971995`, `4d8c11fd0`, `11504c30e` |
| Large fold (executions, tools, base weapon) | `0b3ae6a04` |

### One-line summary (merge / tag)

`SSG & addon art; NeoHMG shield deploy + tactical; UZDoom + weapon fixes; execution/GK fold; docs & smoke tools`

### Short multi-line summary

```text
SSG/Marauder: Peacekeeper fold, refreshed sprites, missed-lump pass.
NeoHMG: deployed shield placement, floor sampling, no player tracking,
  lock yaw, death burst credit; tactical feel bypass on fire; wheel freeze reset.
Weapons: Metal Sniper reload/backpack, Battle Rifle burst/reload, M41A/HASG fixes;
  disable broken DTech Minigun; RiotShield HUD/dup/shots fixes.
Engine: UZDoom NoDelay / Vel.LengthXY / A_RadiusGive startup fixes.
Content: large execution + Glory Kill + BaseWeapon MP helper import;
  gore/killstreak/menu/logo/README maintenance; smoke/zip tooling.
```
