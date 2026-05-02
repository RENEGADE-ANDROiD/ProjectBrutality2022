# Changelog

All notable changes for this working tree are documented here. Earlier history lives in `git log`; this file tracks the consolidated **2026-04-21 → 2026-04-30** session (and follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) style).

## [Unreleased]

### Removed

- Tracked **`tools/`** directory (smoke tests, ACC wrappers, zip sync helpers); keep any local build scripts **outside** the tree or in an untracked **`tools/`** folder — see **`.gitignore`**.

### Added

- Peacekeeper / Marauder **SSG** fold-in from PB3.0 (`d6bbe88db`).
- Refreshed **SSG** sprite sets (kick, reload, fire, respect, select) including follow-up missed lumps (`e0076241d`, `f5eba713f`).
- **Shield Saw** and **Mastermind Chaingun** integration with spawner and HUD wiring (`b5c61d297`, related `7003ef7b3`, `bb1099367`).
- Large **MP execution** surface: `actors/Execution/*.dec`, `BaseWeapon_MPExecutionHelpers.zsc` / `BaseWeapon_MPExecutions.zsc`, matching **`SPRITES/Execution/**`** art (`0b3ae6a04`).
- **Metal Sniper** ZScript implementation and helpers (`0b3ae6a04`, fixes in `c70971995`, `4d8c11fd0`).
- **M41A** ZScript port and related DECORATE support (`0b3ae6a04`, `c70971995`).
- **LooseRounds** and related weapon plumbing (`0b3ae6a04`).
- **Explosive movement** (`pb_rocketjump` / `pb_plasma_wallclimb` patterns) and **WolvusMutator** fold (`ed7f66dd2`, `910d1d46e`, `0b8eef3c4`).
- **Pump shotgun** / **auto shotty** pickup sprites **SHTCA0** / **AUSCA0** (PB Staging) under **PumpShotgun** / **AUTOSHOTTY** asset paths.

### Changed

- **Stormcast** re-enabled (slot 9): folded melee-pack ZScript + DECORATE are loaded again; BFG spawner can pick **Stormcast**; HUD + **Weapon Spawns** menu use **`pb_NoStormcastWeapon`**. Alt-fire spell branches match **Project-Brutality-Weapons-Pack** behavior (hold **Fire** while charging for orbs, **User1**/equipment for stunwalls, **Weapon Special** held for Arc of Death tiers, **Reload** tap during charge for warper, **Alt-Fire** while airborne for air lightning)—not weapon-special **wheel** `Select_SC_*` / `SCMode_*` tokens (those actors were removed).

- **PB_SSG** / **PB_QuadSG** (dual SSG + quad respect): sprites synced from **`PB Old SSG Skin But Better`** (`Downloads\PB_Old SSG Skin But Better\SPRITES\WEAPONS\Slot 3`) into **`SPRITES/WEAPONS/Slot 3/SSG`** and **`SPRITES/WEAPONS/Slot 3/Quad-Shotgun`**.

- **Metal Sniper** / **MarauderSSG**: louder primary-fire audio (**MetalSniper** `MS_FireActual` **1.44**; **MarauderSSG** `MSSFR` **`A_PlaySoundEx`** **1.5**).
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
- **Explosive movement:** **`pb_rocketjump`** now gates player **grenade** family explosions the same way as **PB_PlayerRocketExplosion** (no self-splash + **`PBBlastMomentum`** thrust when **On**; **`XF_HURTSOURCE`** self-splash when **Off**): hand **frag** (`ThrownGrenade1` + **`PB_PlayerHandGrenadeExplosion`**), **Super GL** impact / sticky / incendiary / cryo / acid fog, **M41A** grenade, **Ballista** sticky, **Excavator**, equipment **Molotov**, and **Paingiver** seeker (**`PB_PlayerRocketExplosion`**).

### Fixed

- **Stormcast**: ZScript state action blocks used **`return state("")`** (string → state type error); use **`return ResolveState(null)`** for normal fall-through so UZDoom compiles.
- **Stormcast** stunwall (equipment while holding alt-fire charge): removed **`A_SetPitch`** kick frames that never restored view pitch cleanly; after stunwall, **`Goto Ready3`** when alt-fire is released, or **`Goto AltHold`** when still held so charge tier routing matches **`PowerChargeStorm`** instead of **`Ready` → full `AltFire` restart** (fixes missing sprites / stuck feel and post-fx shake).
- **Marauder SSG**: primary **`MSSFR`** uses **`A_StartSound(..., CHAN_WEAPON, CHANF_DEFAULT, 1.5, ATTN_NORM)`** instead of **`A_PlaySoundEx`** (avoids volume truncation warning on `1.5`).
- **Pump shotgun** buckshot: **Fire** / **PumpFromHip2** used **SHTF** for muzzle frames while **PumpShotgun** only ships **SH0FA0–SH0FG0** (not **SHTFA0–SHTFG0**); states and **`BMAP/Shotgun.txt`** now use **SH0F** with matching brightmaps.
- **UZDoom startup**: `NoDelay`, `Vel.LengthXY`, `A_RadiusGive` compatibility (`a3a7ede64`).
- **HASG** sound, **Metal Sniper** reload, **M41A** / Battle Rifle damage (`c70971995`).
- **Metal Sniper**: infinite reload loop and **SniperAmmo** backpack overflow (`4d8c11fd0`).
- General error/warning cleanup passes (`4926d43ba`, `79140dc1c`).
- **Carbine** reticle and related issues (`761e502d7`).
- **ShieldSaw.dec** / ACS callback flow maintenance (`07d57f6b7`).
- **First-person legs:** **PB_WeaponRaise** uses legs overlay **-10** (matches **SelectFirstPersonLegs**) instead of **-1000**.
- **SSG / quad shotgun:** removed invalid **PB_WeaponBase.Upgrade** from **SSG.dec**; **PB_jumpIfNoAmmo()** DECORATE empty-paren fixes in **SSG.dec** / **QUADBARREL.dec**; removed dead **HasNotPickedUpSSG** line; quad ammo HUD uses **SGN3A0** when **QSGSA0** is absent; dropped stray **SSG_Staging** paths list lump.
- **PB_Freezer:** **UnloaderToken** handling aligned with unload / slot-cycle behavior.
- **X12 Shotgun:** Semiauto High-Power ("Senato") mode no longer crashes on fire — the **`Fire2_WaitRelease`** poll used **`return state("Fire2_WaitRelease")`**, which DECORATE processes as a same-tic **`SetState`** self-jump and trips *Infinite State Loop in Weapon State X12Shotgun.139* (also kills the psprite, which is why the weapon disappears). Now uses the canonical PB **`return state("")` + `Loop`** pattern, matching UACSMG / MP40 / AUTOSHOTGUN reload polls and RAILGUN laser stages.

### Removed

- **Demon-Tech Minigun** as a supported spawn/player weapon (broken); references toggled off per mod policy (`5be253ff0`).
- **X12 Shotgun Semi-Auto / "Senato" mode** entirely. The `IsSemi` token, the `Fire2` / `Fire2_WaitRelease` states, the `AltFire` toggle and `FullAgain` swap-back state, and the `X12ReadyToFire` semi-auto branch are all gone. Even after the prior `Fire2_WaitRelease` `Loop` fix, the mode kept producing engine-level state-loop failures, so the X12 is now full-auto only. `WeaponSpecial` reverts to its no-op `"No X12 Special Available"` print + `Goto X12ReadyToFire`. `language.enu` `PB_WPNHINT_X12Shotgun` no longer advertises the semi-auto toggle.
- **`PB_PulseCannon`** and **`PB_DualPulseCannons`** outright (and their entire support surface), closing **Root Cause 2** in **`docs/weapon_cycle_bug_investigation.md`**: both weapons set **`+CHEATNOTWEAPON`** and **`+POWERED_UP`**, which **`idfa`** / `give allweapons` skipped silently — so after IDFA the slot 8 cycle table had a hole that forward-scrolling treated as an end-of-list and refused to advance into slot 9 (`BHGen`). With both classes gone, **`Player.WeaponSlot 8`** is now just **`PB_M1Plasma, PB_M2Plasma`**, both fully cheat-grantable, and slot 8 → 9 cycling works post-IDFA. Touched: deleted **`actors/Weapons/Slot6/PulseCannon.dec`**, **`actors/Weapons/Slot6/DUALPULSECANNON.dec`**, **`actors/Friendly Marines/Marine-PulseCannon.dec`**, **`BMAP/PulseCannon.txt`**, **`SPRITES/WEAPONS/Slot 6/PulseCannon/`** (106 files), **`SPRITES/PLAYER/SKINS/PULSECANNON/`** (102 files), **`brightmaps/WEAPONS/PulseCannon/`** (6 files); stripped includes / actor refs / cvars / menu rows / language strings / `IsSelected` blocks / `DoomEdNum`s 23023+23053 / GLDEFS `pointlight PulseC` + `object PB_PulseCannon` / `doomdefs.bm` include / `BMAP/Weapons.txt` `PLCUA0` line / 4× spawner jumps + state in `PlasmaRifleWeaponSpawners.dec` / upgrade-spawner jump + state in `SpecialPowerups.dec` / `specialWheel_PulseCannon` + dispatcher case in `ev_core_special.zsc` / `NO_TACTICAL_WEAPONS` entries in `PB_WeaponTacticalFeel.zc` / `PBWeapUnloadedToken` + `PBWeapUnloadableClasses` entries in `BaseWeapon.zc` / 3 ACS scripts (`PBUpgradeChecker_PulseCannon`, `TogglePulseCannonUpgrade`, `ToggleWeaponPulseCannon`) plus retargeted `PBUpgradeChecker_DragonsBreath` from `SpawnPulseCannon` to `SpawnRifleUpgrade`, recompiled `ACS/cvars.o` (now 162 scripts) / `SpawnFriends9` ally-summon chain (`SummonPulseCannonGunners`, `RecalculatePulseCannonGunners`) in `PLAYER.dec`, with `RecalculateAutoShotgunners` retargeted to `Goto StandstillLoop` (also incidentally fixing a pre-existing infinite autoshotgun-marine respawn loop). Cross-cutting helpers `PulseCannonBall`, `PulseBeamLaser`, `PulseCannonBeamTrail` were renamed `ChexBall` / `BHBeamLaser` / `BHBeamTrail` and folded into their only surviving consumers (`actors/Weapons/Slot4/ChexRifle.dec` and `actors/Weapons/Slot8/BLACKHOLE.dec`) so no `Pulse*` identifier remains in the project. The five **Purple-Plasma FX actors** that lived inside `PulseCannon.dec` (`PurplePlasmaFlare`, `PurpleFlareSmall`, `PurplePlasmaParticle`, `PurplePlasmaFire`, `PurplePlasmaParticleSpawner`) were also independently consumed by `actors/Equipments/VoidGrenade.dec`, `ChexProjectile`, and `GLDEFS.txt` (a `pulselight` binding for `PurplePlasmaFire`). Smoke testing surfaced the unresolved references; the two flare classes were relocated into `actors/Effects/FLARES.dec` (next to `Flare_General`) and the three particle/spawner classes into `actors/Effects/PARTICLES.dec` (next to `BluePlasmaParticle*`), preserving include order so DECORATE parses cleanly with zero warnings.

### Documentation

- **`README.md`**, **`AGENTS.md`**, **`CREDITS.txt`**: maintenance across `63cf5d62e`, `5213ff4df`, `27d6d37d6`, `a7483b3f1`, and the large **`0b3ae6a04`** doc pass.
- **`docs/weapon_cycle_bug_investigation.md`**: appended a closing **Resolution** section noting both root causes are now resolved and the file is historical (Root Cause 1 fixed 2026-05-01; Root Cause 2 eliminated 2026-05-02 via the Pulse Cannon removal). **`AGENTS.md`** §4 "Other shipped weapon-special wheels" bullet had its **`PB_PulseCannon`** example dropped. **`PORTING_ADDONS.md`** Slot 6 row in the staging-vs-PB-2022 comparison no longer lists **`DUALPULSECANNON.dec`** / **`PulseCannon.dec`** for PB 2022 and the status note now flags that PB 2022 no longer ships a Pulse Cannon at all.

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
