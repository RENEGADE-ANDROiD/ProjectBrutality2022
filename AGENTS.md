# AGENTS.md — Project Brutality 2022 (main mod)

This file orients coding agents to the Project Brutality add-on that lives in this folder. Read it before editing anything here.

## 1. What this is

- **Project Brutality 2022** — a large gameplay and content overhaul for *Doom* / *Doom II*, built for **GZDoom** (engine line currently tracked by [UZDoom](https://github.com/UZDoom/UZDoom/tree/4.14.3)).
- Loose folder layout, **not** PK3-packed. GZDoom loads the directory directly (drag the folder onto `gzdoom.exe`, or pass it with `-file`).
- ZScript version pin: `version "4.5.0"` at the top of `ZSCRIPT.zc` — minimum GZDoom ~4.5; development generally targets the latest stable GZDoom.
- Custom player class: **`PB_Doomer`** (locked by `NoRandomPlayerClass = True` in `gameinfo.txt`).
- The **Glory Kills** and **Monster Pack** content was previously shipped as sibling add-on folders and has been folded into this mod. There is nothing external to load on top of the main folder anymore — treat the Glory Kill / pinata system and the extra MP monsters (Crackodemon, Hellduke, Hellsmith, Director, Horrorspawn, Hunger, Aracnorb Queen, Helemental, Hierophant, ESoul, ZombieTank/Plasma/Missile/Elite, PB_ZombieFlyer, etc.) as first-class main-mod content.

## 2. Top-level entry-point lumps

These are the first files GZDoom reads when loading the mod. Any new feature usually touches more than one of them.

| File | Role |
| --- | --- |
| `gameinfo.txt` | `STARTUPTITLE`, `STARTUPCOLORS`, locks player class. |
| `zmapinfo.txt` | `TITLEMAP`, skill definitions, `GameInfo { StatusBarClass = "PB_DoomStatusBarWithVisor", AddEventHandlers ... }` (e.g. helmet visor + `PB_WheelBSSBlurHandler` for `shaders/mfx_bss_blur.fp` / `gb_blur` when the special wheel is open), and the `DoomEdNums` table reserving editor numbers **23000–23133**. |
| `KEYCONF.txt` | `addplayerclass PB_Doomer`, custom keybinds, netevent aliases (`PBWeaponSpecialOn/Off`, `PBEquipSpecialOn/Off`, `EV_ClearGore`, etc.). |
| `CVARINFO` | All `pb_*`, `cl_*`, `fs_*`, `py_*`, `be_*`, `sv_*` cvars. Check here before inventing a new one. The `be_*` and `sv_fuelhud_*` / `sv_bonusrange` / `sv_ammorange` block (bottom of file, from `be_ExecutionsON` to `sv_fuelhud_y`) is the Glory Kills settings — read and written by the pinata + stagger system. |
| `MENUDEF.txt` | Options-menu structure for everything declared in `CVARINFO`. Includes the `Glorykill Options` submenu (`OptionMenu "Glorykills"`, reachable from the main options list) plus the shared `OptionValue "MaxStat"` / `"FHudsize"` / `"BackStyle"` definitions used by that submenu. |
| `SBARINFO.txt` | Status bar / HUD (still the main layout; visor is extra draw in `PB_DoomStatusBarWithVisor`). |
| `language.enu` | All localized strings; every menu label and pickup message lives here. |
| `SNDINFO.txt` (merged) | Sound logical names: old per-category `SNDINFO.*` shards are **concatenated in one** `SNDINFO.txt` (section comments mark each group). **Add** new entries in a new section, or in the `SNDINFO.txt` tail. |
| `GLDEFS.txt` + `lumps/includes/gldefs/*.inc` | Dynamic lights, brightmap bindings, postprocess `HardwareShader` (e.g. `MBlur`, `gb_blur`), Glory Kills `glorykill.shader`, etc. Shards (Overlord, `CSSG`, HMG, Molotov, Cruelty bonuses, HelmetDrops, …) are `#include`d as **`.inc`** (not second `GLDEFS` lumps) from `lumps/includes/gldefs/`. **HelmetDrops** / 1BON+3BON: see `HelmetDrops.inc` and `CrueltyPhysicalBonuses.inc` (plus `zscript/Items/HelmetDrops/HelmetDropHandler.zc` + `actors/Items/HelmetDrops/HelmetDrops.dec`). |
| `doomdefs.bm`, `doommonsters.bm` | Brightmap bindings; sprites under `BMAP/` and `brightmaps/`. |
| `ANIMDEFS`, `DECALDEF`, `modeldef.txt` (+ `lumps/includes/bdv22_modeldef.inc` for optional BDv22), `Textures.txt` (which `#include`s `lumps/includes/textures/*.inc` e.g. `FX.inc` for Glory-Kill / FX), `XHAIRS`, `TRNSLATE` / `trnslate.txt`, `Fontdefs.txt`, `TEXTCOLO.txt` | Definitions wired in by the engine; most extra texture / composite defs are in `lumps/includes/textures/` to avoid many root `TEXTURES.*` lumps. |
| `LOADACS.txt` | Lists compiled ACS lumps from `ACS/` to auto-load. Tail of the file is the Glory Kills block: `lowhealth`, `GloryMelee`, `GloryHUD`, `BloodPunch`. |
| `DECORATE` | Master `#include` list for every legacy actor under `actors/`, plus many small inventory-token actors defined inline. |
| `ZSCRIPT.zc` | Master `#include` list for every ZScript file under `zscript/`, plus a handful of inline classes (`Demonpickup`, `CameraRunner`, `MBlurHandler`, `XDeathGibBase`, `SpawnerBase`, `BossBrainBase`, `InvisiblePuff`, `EPBWeaponFlags`). |
| `MBlur.fp` | Fragment shader used by the optional motion blur (`MBlurHandler`). |
| `shaders/mfx_bss_blur.fp` | PB 0.3+ staging MariENB “BlurSharpShift” postprocess; `GLDEFS` registers it as `gb_blur`, driven by `PPShader` in `zscript/PbWheel/wheel_bss_postblur.zsc` when the weapon special wheel is open (`pb_wheelbackgroundblur`). |
| `PDAMONST`, `PDAWEAP`, `PDAWEAPT` | Data tables consumed by the PDA (`zscript/PBPDA.zc`). |
| `titlemap.wad`, `TitleMap` | Title-screen level. |

## 3. Folder map

```
lumps/                     `includes/` only: `gldefs/*.inc`, `textures/*.inc`, `bdv22_modeldef.inc` — files pulled in by `GLDEFS.txt` / `Textures.txt` / `modeldef.txt` (not extra top-level `GLDEFS*`, `TEXTURES*`, or `modeldef.bd*` root lumps)
actors/                    DECORATE actors, organized by domain
  Brutality/               Brutality-style variants of vanilla grunts
  Weapons/
    BaseWeapon.dec         Common PB_Weapon base + shared overlays
    Slot1 .. Slot9/        Player weapons grouped by slot. Slot1 now also holds Crucible.dec + BloodPunch.dec; Slot8 holds SoulCube.dec (Glory Kill pinata pickups, NOT a SoulCube weapon); Slot9 holds ShoulderCannon.dec (Glory Kill shoulder-cannon fire / cryo grenade / floor-ice FX, NOT a standalone weapon).
    Meatshields/           "Grab enemy as a shield" variants per monster
  Monsters/
    T1-Grunts/             Zombiemen, Sergeants, Commandos, Nazis; plus MP additions: Horrorspawn, Hunger, ZombieTank, ZombieTankElite, ZombiePlasmaTank, ZombieMissileTank, PB_ZombieFlyer (+ lasertracer model). `PB_ZombieMan` (`ZombieMan.zc`) can roll `Death.Fatality1`–`8`; `7`+`8` are El Diablo first-person finishers in `NEWPLAYE` (`FatalityZMan7Eld` / `FatalityZMan8Eld`, full `NATT` A–G and `NZ0D` D–J in `SPRITES/MONSTERS/fatalitys/eld_eld_zman/`). `PB_ShotgunGuy` (`ZombieSergeant.zc`) and `PB_ShotgunGuyGK` use `Death.Fatality1`–`8`; `7`+`8` are `FatalitySergeant7Eld` / `FatalitySergeant8Eld` (`ESCR` / `SOBO` in `eld_eld_sarge/`, with extra ACS/blood between frames). `PB_Nazi` / `PB_NaziGK` roll five finishers: `NaziFatality`–`3` (existing NZFT / NF3Y / NFTY-style camera paths) plus `NaziFatality4`+`5` for first-person `FatalityNazi4Eld` / `FatalityNazi5Eld` (reuse `NZ0D` / `NATT` like zombieman Eld, corpses via `FatalizedNazi`). `PB_ZombieManGK`’s `Death.Fatality` matches the zombieman 1–8 pool.
    T1-Imps/               Imp family (incl. DarkImp variants). `PB_ImpGK` rolls `Death.Fatality1`–`7`; 6+7 are `NEWPLAYE` `FatalityImp6Eld` / `FatalityImp7Eld` with sprites `YUTI` / `49AN` in `SPRITES/MONSTERS/fatalitys/eld_eld_extra/` (always in pool, no cvar).
    T2-Pinkies/            Demons, Spectres, MeanDemon, MechDemon; plus MP Crackodemon. `PB_Demon` / `PB_DemonGK` add `DemonFatality4`+`5` in the `Death.Fatality` pool; player states are `FatalityDemon4Eld` / `FatalityDemon5Eld` (sprites `LSLS` in `SPRITES/MONSTERS/fatalitys/eld_eld_demon/`, token actors in `PLAYER.dec`). Legacy execution handoff (`Death.ExeCution` / `Death.ExeCution1` / `SpecialFatality`) is now folded for `PB_Demon`, `PB_VoidSpectre`, `PB_MechDemon`, and `PB_MeanDemon`.
    T3-Arachnos/           Arachnotrons, Aracnorb (+ MP-ported AracnorbPassiveSpawn), Arachnophyte. `PB_Arachnotron` / `PB_ArachnotronGK` roll `ArachnotronFatality` / `ArachnotronFatality2`, and now also a third branch that grants `ArachnotronTurret` + `ArachnoGun` for the drivable arachno finisher path in `NEWPLAYE` (`ArachnoGunner*` states, using existing `ARF2` sprites for asset safety). `ArachnoTurretFrame` also exposes `Death.ExeCution` -> `Death.Fatality` and grants `ArachnotronTurret` + `ArachnoGun`, matching the legacy execution handoff model. `PB_Arachnophyte`, `PB_EliteArachnotron`, and `PB_InfernalArachnotron` now also mirror legacy execution routing by adding `Death.ExeCution` / `Death.ExeCution1` / `SpecialFatality` handoff states (`GoExecution` plus fist-based `Death.Fatality` pivot).
    T3-Fats/               Mancubus + Daedabus / Volcabus. Legacy execution handoff (`Death.ExeCution` / `Death.ExeCution1` / `SpecialFatality`) is folded for `PB_Mancubus`, `PB_Daedabus`, and `PB_Volcabus`, preserving `GoExecution` transitions with fist-based fatality pivots. Legacy sound assets were also folded for these families under `SOUNDS/MONSTERS/{Mancubus,daedabus,Volcabus}`.
    T3-Floaters/           Cacodemon, Lost Soul, Pain, Watcher, Overlord, etc.; plus MP Helemental and ESoul (Etherealsoul.dec). `PB_Cacodemon` / `PB_CacodemonGK` use `CacoF1`–`CacoF4` for `CacoDemonFatality`–`4`; 3+4 are `FatalityCacoDemon3Eld` / `4Eld` (sprites `HUF1` / `HUF2` from El Diablo `Hunger/`, in `SPRITES/MONSTERS/fatalitys/eld_eld_caco/`). Legacy-style execution handoff states (`Death.ExeCution`, `Death.ExeCution1`, `SpecialFatality`) are now folded into core floaters (`PB_Cacodemon`, `PB_PainElemental`, `PB_InfernalCaco`, `PB_SufferingElemental`, `PB_Overlord`, `PB_Phantasm`, `PB_LostSoul`, `PB_Afrit`) to preserve third-person execution triggers (`GoExecution`) and fist-to-fatality pivots. `PB_Watcher` also now has the legacy direct `Death.ExeCution` -> `GoExecution` handoff path. Legacy watcher sound assets were folded under `SOUNDS/MONSTERS/Watcher`.
    T3-Revies/             Revenant, BeamRev, Draugr. `PB_Draugr` and `PB_DraugrGK` roll `DraugrF1`–`F3` to grant `DraugrFatality` / `DraugrFatality2` / `DraugrFatality3`; 2+3 are first-person `FatalityDraugr2Eld` / `FatalityDraugr3Eld` in `NEWPLAYE` (sprites `SAPO` in `SPRITES/MONSTERS/fatalitys/eld_eld_draugr/`; original camera-heavy `FatalityDraugr` stays on token 1). `PB_Revenant` / `PB_RevenantGK` use `RevenF1`–`RevenF4` and `RevenantFatality`–`4`; 3+4 are `FatalityRevenant3Eld` / `4Eld` (`KOKO` in `SPRITES/MONSTERS/fatalitys/eld_eld_reven/` from El Diablo `satyr2/`). `PB_Commando` / `PB_ClassicCommando` and their `*GK` wrappers use `ComandoF1`–`ComandoF4`; 3+4 are `FatalityComando3Eld` / `4Eld` (`HUF3` + `HEDF` in `SPRITES/MONSTERS/fatalitys/eld_eld_comando/`, from El Diablo `Hunger` + `CrackoDemon Fatality/`). Legacy execution handoff (`Death.ExeCution` / `Death.ExeCution1` / `SpecialFatality`) is now folded for `PB_Revenant`, `PB_Draugr`, and `PB_BeamRev`.
    T4-Nobles/             Knight, Baron, Cyber* variants, Belphegor, Infernus. `PB_HellKnight` / `PB_HellKnightGK` now roll `HKFatality` + `3` + `4` + `5` + `6` (`5`/`6` are `FatalityHK5Eld` / `FatalityHK6Eld`, sprites `CPUI` / `BOTU` in `SPRITES/MONSTERS/fatalitys/eld_eld_hk/`). `PB_Baron` / `PB_BaronGK` roll `BaronFatality`–`BaronFatality4`; `3`/`4` are `FatalityBaron3Eld` / `FatalityBaron4Eld` with `PPLJ` / `TOPI` in `SPRITES/MONSTERS/fatalitys/eld_eld_baron/`. Note: El Diablo’s `BHF1A0` (inside `Fatality baron 2/Carpeta/sprites/`) is a single orphan frame and is intentionally left unused. Legacy execution handoff (`Death.ExeCution` / `Death.ExeCution1` / `SpecialFatality`) is now folded for major nobles: `PB_Baron`, `PB_HellKnight`, `PB_Belphegor`, `PB_Infernus`, `PB_CyberBaron`, `PB_CyberKnight`, and `PB_CyberPaladin`.
    T4-Viles/              Archvile, IceVile, FleshWizard, Hellion; plus MP Hierophant. `PB_Archvile` / `PB_ArchvileGK` now roll `ArchvileFatality`, `ArchvileFatality2`, `ArchvileFatality3`; `3` is `FatalityArchVile3Eld` in `NEWPLAYE` using `SATZ` sprites at `SPRITES/MONSTERS/fatalitys/eld_eld_arch/`. Legacy execution handoff (`Death.ExeCution` / `Death.ExeCution1` / `SpecialFatality`) is now folded for `PB_Archvile`, `PB_FleshWizard`, `PB_IceVile`, and `PB_Hellion`; `PB_IceImp` now has a direct `Death.ExeCution` -> `GoExecution` handoff path.
    Tz-Bosses/             Cyberdemon, Mastermind, Annihilator, Demolisher, Juggernaut; plus MP Hellduke, Hellsmith, Director, AracnorbQueen. `Hellduke` now defines `Death.Fatality` and rolls `HelldukeFatality1`–`6`; player states are `FatalityHellduke1Eld`…`FatalityHellduke6Eld` in `NEWPLAYE`, using `HDF1`, `UH0D`, `H0HE`, `HS0D`, `H0PF`, `HDF0` sprites in `SPRITES/MONSTERS/fatalitys/eld_eld_hellduke/`. Legacy execution handoff has also been folded for core bosses (`PB_Cyberdemon`, `PB_Annihilator`, `PB_Juggernaut`, `PB_Demolisher`, `PB_SpiderMasterMind`) via `Death.ExeCution` `GoExecution` routing.
    Tz-Frozen/              Frozen death variants per tier
    Tz-Shrinks/            "Lil Guys" shrunk variants
    <Tier>/GloryKills.dec  Per-tier GK monster wrappers (PB_ImpGK, AracnorbGK, PB_CyberdemonGK, …) that `replaces` the base actor and add stagger / execution states. One file per tier.
  GloryKills/              GloryKill common tokens & pinata/highlight/particle actors (GloryKillCommon.dec)
  Items/{Ammo,Health,Powerups}/   Items/Ammo/ now also holds PinataAmmo.dec; Items/Powerups/ holds Pinata.dec-style pickups
  Decorations/Barrels/     Replacement barrel set
  Effects/                 Puffs, tracers, smoke, sparks, splashes, decals. Also PinataParticles.dec (GK particle effects)
  Gore/                    Blood, gibs, burn, sticky, underwater, black-hole; BDv22Gore/ (Brutal Doom 22 add-on; see §9), BPv10Gore/ (Brutal Pack V10 add-on; see §9.5)
  Hitboxes/                Headshot/leg/boss hitbox spawners
  Friendly Marines/        Captured marines + weapon-variant spawners
  Player/                  PB_Doomer + player-side inventory tokens
  SPAWNERS/{Ammo,Item,Monster,Weapon}Spawners/   MonsterSpawners/ was rewritten during the Monster Pack merge — the vanilla-spawner files now include MP-specific random branches (AracnorbPassiveSpawn from PinkySpawner/SpectreSpawner, Crackodemon from PinkySpawner, etc.).

zscript/                   Modern logic, included via ZSCRIPT.zc
  PlayerPawn.zc            PlayerPawnBase : PlayerPawn (movement, dash, slide, ledge grab, PDA)
  PBHitbox.zc, DeathFader.zc, PBPDA.zc, ZMoveMenu.ZMV
  Monsters/                PBMonster.zc abstract base + ZombieMen/Sergeants/Imps/ZombieScientist ports. ImpGloryKill.zc / SergeantsGloryKill.zc / ZombieMenGloryKill.zc / ZombieScientistGloryKill.zc add the execution overrides.
  Weapons/
    BaseWeapon.zc
    FlamerStuff.zsc
    executionGUI/          pb_viewport / pb_projector / pb_uihack / pb_execution_handler
    Projectiles/
  Gore/
    PBBlood.zc, BDv22GoreHandler.zc, BDv22GoreMergeHandler.zc, BDv22Gore/ (opt-in Brutal Doom 22; see §9), BPv10Gore/BPv10GoreHandler.zc (opt-in Brutal Pack V10; see §9.5)
    PBGore.zc, PBGoreEffects.zc
    NashGore/              Nash Muhandes' gore system + NashGoreHandler
  PbWheel/                 Weapon / equipment selection wheel (note the casing: `PbWheel` with a capital P — the GK add-on shipped `pbWheel` but that was normalized on merge)
  TiltPlus/                Tilt++ screen-tilt system + menu
  Spawner/                 PB_SpawnerBase + weapon spawners (e.g. shotgun)
  LaserAPI/                lewisk3's laser sight API
  PBVP/                    PB Voxel Project hooks (model toggle)
  SpecialShit/             "Hat extravaganza" cosmetic system
  Separated Movement Modes/
  Decorations/, Effects/

ACS/                       Compiled ACS object lumps (LOADACS.txt lists them). Glory Kills additions: `lowhealth.o` (scripts `lowhealth` + `lowarmor` from `SRC/lowhealth.acs`), `EquipCooldown.o` (`script "GKEquipmentLauncher" ENTER` in `SRC/EquipmentCooldown.acs` — shoulder flame/ice ready timers), GloryMelee.o (compiled from `SRC/GloryChain.acs`, script numbers 6000/6001/6003/6004), GloryHUD.o, BloodPunch.o.
SRC/                       ACS source (.acs) matching files in ACS/. GloryChain.acs compiles to GloryMelee.o (not GloryChain.o — filename differs by convention).
shaders/                   `mfx_bss_blur.fp` (postprocess name `gb_blur`, wheel-background blur; see `GLDEFS` + `zmapinfo` `PB_WheelBSSBlurHandler`).  
Shaders/                   GZDoom hardware-shader source. `glorykill.shader` (wired in through the Glory Kills block in GLDEFS).
SPRITES/, GRAPHICS/, HIRES/, PATCHES/, MODELS/, SOUNDS/, BMAP/, brightmaps/   Assets. GK sprite subfolders: Crucible/, CrucibleTrail/, Effect/, FATALITY/, GLORYKILL/, GLORYSAW/, ShoulderCannon/, SOULCUBE/. MP monster sprite subfolders under SPRITES/Monsters/ follow MP's original folder names (Aracnorb/, Crackodemon/, Director/, Etherealsoul/, Helemental/, Hellduke/, Hellsmith/, Hierophant/, Fodder/, Zombie Tank/, Zombie Flyer/, Zombiemissiletank/, Zombieplasmatank/, Zombietankelite/, Lost Spirit/).
titlemap.wad, TitleMap     Title-screen content
```

## 4. Architecture notes that catch agents off guard

- **Mixed DECORATE + ZScript.** Most actors are still DECORATE (`actors/**/*.dec`). Newer systems — event handlers, HUD UI, wheel UI, gore, PlayerPawn movement, execution GUI — are ZScript (`zscript/**/*.zc|.zsc|.txt`). **Do not port DECORATE to ZScript wholesale.** Follow the convention of the file you're editing.
- **Inventory tokens as flags.** A large block at the top of `DECORATE` defines tiny `Inventory` actors (`EvadeCheck`, `ExecutionToken`, `IsDead`, `PlayerWheelOpen`, `CantFire`, `NoZombieGrenade`, `BrutalCounter`, `FallingHeight`, `TargetIsACyberdemon`, etc.) that are used as booleans/counters through `A_GiveInventory` / `CountInv` / `CheckInventory`. Scan these before adding a new one — many already exist.
- **Event handlers are registered via MAPINFO**, not in ZScript. See the `GameInfo { AddEventHandlers = ... }` block in `zmapinfo.txt`. Currently registered:
  `pb_ExecutionHandler`, `PB_EventHandler`, `MBlurHandler`, `NashGoreHandler`, `BDv22GoreHandler`, `BDv22GoreMergeHandler`, `BPv10GoreHandler`, `TiltPlusPlusHandler`, `DeathFadeBootstrap`, `DEDashJumpHandler`, `GrapplingHookHandler`, `SpeedoMeterHandler`, `WallSlideHandler`, `PB_SpecialWheelHandler`, `HatExtravaganza` (see `zmapinfo.txt` for the full, current list).
  Adding a handler requires both a ZScript class **and** a new `AddEventHandlers` line.
- **Editor numbers** come from the reserved **23000–23133** range in the `DoomEdNums` block of `zmapinfo.txt`. Add a new entry there when introducing a placeable actor; do not reuse numbers.
- **ACS workflow.** Edit `.acs` in `SRC/`, recompile to `.o` in `ACS/` with ACC (matching the GZDoom version), and make sure the lump name is listed in `LOADACS.txt`. Never hand-edit `.o` files.
- **Player class is fixed** to `PB_Doomer`. It is defined in `actors/Player/PLAYER.dec` and extended by `PlayerPawnBase : PlayerPawn` in `zscript/PlayerPawn.zc`. `gameinfo.txt` enforces `NoRandomPlayerClass = True`.
- **Custom weapon flags** live in `EPBWeaponFlags` (inside `ZSCRIPT.zc`): `PBWEAP_KEEPYOFFSET`, `PBWEAP_ISPISTOLSILENCERSTATE`, `PBWEAP_UNLOADED`. Weapons extend `PB_Weapon` (DECORATE) on top of `PB_WeaponBase` (ZScript).
- **ZScript-only weapons: inherit `PB_Weapon`, not only `PB_WeaponBase`.** In `actors/Weapons/BaseWeapon.dec`, `Actor PB_Weapon : PB_WeaponBase` owns **`SelectFirstPersonLegs`** (registers `KickHandler_Overlay`, `Melee_Equipment_Handler_Overlay`, `Equipment_Toggle_Handler_Overlay`, first-person legs, `DoKick`, etc.) and then **`A_Jump(255, "SelectContinue")`**. A ZScript `class MyGun : PB_WeaponBase` **does not** run that chain unless you wire it. **Recipe:** (1) `class MyGun : PB_Weapon`. (2) In **`Select`**, after per-weapon setup / barrel clears, **`goto SelectFirstPersonLegs`** (do **not** `goto` straight into a local `SelectPre` / ad-hoc bring-up). (3) Expose a **`SelectContinue:`** state with your fatality check, `PB_WeapTokenSwitch`, `PB_RespectIfNeeded`, and **`goto SelectAnimation`** (or equivalent). If an older file used **`SelectPre`**, rename it to **`SelectContinue`**. (4) **Do not** paste a second copy of **`SelectFirstPersonLegs`** in the same class — it drifts from `BaseWeapon.dec`; drop it and use the parent’s state. (5) **`FlashPunching` / flash-kick states** must return to a ready state (**`goto Ready3`** is typical) — never end with **`stop`**, or the weapon can get stuck and anything that needs **`player.ReadyWeapon == self` + a steady ready loop** (e.g. **`DoEffect()`** for **alt-hold shields / barrier PSprites** on `PB_NeoHMG`, `PB_ArgentSith`, `PB_BeamKatana`, etc.) will fail. *Shipped ZScript examples that follow this pattern:* `BDPBattleRifle`, `PB_CSSG`, `PB_Excavator`, `PB_NeoHMG`, `PB_ArgentSith`, `PB_BeamKatana`.
- **Punch-flash psprite layer (`FlashPunching` dispatch).** `QuickMelee` in both `actors/Weapons/BaseWeapon.dec` (`GoMeleeInstead`) and `zscript/Weapons/BaseWeapon.zc` now dispatches **`FlashPunching`** on **`PSP_FLASH`** (was a generic layer 4 in older PB 2022) to match PB Staging. Entry does `A_ClearOverlays(PSP_FLASH, PSP_FLASH, false)` *before* `A_Overlay(PSP_FLASH, "FlashPunching")`, and the `QuickMelee` exit into `Ready3` does the same clear. The net effect: **`FlashPunching`** may end with **either `Stop` or `Goto Ready3`** without the old duplicate-sprite bug — use `Goto Ready3` for symmetry with **`FlashKicking`** (which already returns to ready). Overrides that launch `FlashPunching` themselves (e.g. `BeamKatana_Weapon.zs`, `ArgentSith_Weapon.zs` `QuickMelee`) must use `PSP_FLASH` too and perform the same exit-time clear before transitioning. Loops like `RiotShield`'s `ReadyShield` are **not** safe targets of a `Goto` from `FlashPunching` because the ready state would loop on `PSP_FLASH` instead of `PSP_WEAPON`; those keep `Stop`. Full writeup of the engine behaviour, why layer 4 produced the duplicate, and how PB Staging's `PSP_FLASH` dispatch sidesteps it, is in `docs/punch_flash_psp_flash.md`.
- **`A_ClearOverlays` has a hidden `safety=true` default that silently SKIPS `PSP_WEAPON` and `PSP_FLASH`.** Native signature is `A_ClearOverlays(int sstart = 0, int sstop = 0, bool safety = true)`. With `safety=true` (the default, which DECORATE and ZScript both inherit), the engine explicitly `continue`s past `id == PSP_STRIFEHANDS || id == PSP_WEAPON || id == PSP_FLASH` — so `A_ClearOverlays(PSP_FLASH, PSP_FLASH)` is a silent no-op, not a clear. To actually destroy PSP_WEAPON/PSP_FLASH via this function you **must** pass `false` as the third argument, e.g. `A_ClearOverlays(PSP_FLASH, PSP_FLASH, false)`. There is no runtime warning and no DECORATE lint for this. Every PSP_FLASH clear in the `FlashPunching` plumbing passes `safety=false`. Regular layer-range clears like `A_ClearOverlays(10, 11)` are unaffected because those layers are not in the safety allow-list. Engine source: UZDoom `src/playsim/p_pspr.cpp` `A_ClearOverlays`. Alternative PSP_FLASH destroyers: `A_GunFlash("Null")`, `player.SetPsprite(PSP_FLASH, null)`, `A_Overlay(PSP_FLASH, "Null")`.
- **Monster base classes.** DECORATE monsters extend `PB_Monster` (or its DECORATE wrappers) and usually declare `Replaces <VanillaActor>`. ZScript monster logic lives in the abstract `PB_Monster` class in `zscript/Monsters/PBMonster.zc` (hitbox handler, `A_SmartChase`, execution handler).
- **Global constants.** Defined in `ZSCRIPT.zc`: `MAXITERATIONS`, `STAT_NashGore_Gore`, `STAT_PB_BULLETS`, `C_TID`, `MAX_R`, `ADJUST_R`, `VIEW_HEIGHT`.
- **PBv0.3+ Staging–style movement / dash HUD (partial fold).** The `DEDashJump` inventory (`zscript/PlayerPawn.zc`) uses **analog** dash direction, **`DashSpeed = 50`** and the same in-dash rules as 0.3’s `PlayerPawn` (`VelFromAngle` only; **no** per-tic `vel.xy *= 0.5`; when remaining `DashTics` hits **3** after decrement, `DashSpeed *= 0.4` and `PlayerDashed` is cleared). The full-screen overlay is in `PB_EventHandler` (`zscript/PBPDA.zc`): `InterfaceProcess("PB_DashWhatchamacallit")` + `RenderOverlay` + `graphics/hud/fullscrn/pb_dashoverlay.png` (cvar `pb_dasheffect`, menu: “Show dash screen effect”). The separate **PlayerPawn** `void Dash()` / `void AirDash()` (Alt movement) is unchanged. Porting an entire 0.3 `SBARINFO` / all HUD art as one shot is *not* done here — the main 2022 fullscreen bar in `SBARINFO.txt` stays as-is; copy extra `graphics/hud` from staging as needed and merge by hand.
- **Many lump names are case-sensitive on Linux GZDoom.** Preserve the exact casing used in `DECORATE` / `ZSCRIPT.zc` include paths (e.g. `Actors/Decorations/Barrels/BarrelEffects.dec` vs `actors/Effects/PARTICLES.dec`). Do not "normalize" capitalization.
- **DECORATE include order — the PBWP ammo-alias trap.** [`actors/Items/Ammo/PBWP_CompatAmmo.dec`](actors/Items/Ammo/PBWP_CompatAmmo.dec) defines four PBWP→PB ammo aliases — `PB_Shell : NewShell`, `PB_HighCalMag : NewClip`, `PB_Cell : NewCell`, `PB_CellPack : NewCellPack` — whose **parent classes** live in `ShellBox.dec` / `Clipbox.dec` / `Cellpack.dec`. Slot 3 shotgun states (`X12Shotgun.dec`, `HASG.dec`) reference `PB_Shell` by **string** in state-action args, which is a deferred runtime lookup that only logs a warning if missing. But the `:` parent-class syntax is **eager** at parse time and produces a *fatal* `Tried to define class 'PB_HighCalMag' without definition of parent class 'NewClip'.` if the parent file isn't included first. The current [`DECORATE`](DECORATE) ordering — `ShellBox.dec` → `Clipbox.dec` → `Cellpack.dec` → `PBWP_CompatAmmo.dec` → `X12Shotgun.dec` → `HASG.dec`, sitting **above** the main `//Ammo Ammo Ammo` block — satisfies both constraints; the in-file comments at lines ~149 and ~195 of [`DECORATE`](DECORATE) explain it. **If you add another `PB_<X> : <ParentAmmo>` alias to `PBWP_CompatAmmo.dec`, or reshuffle the ammo block, keep that grouping intact** (`<ParentAmmo>` defining file before `PBWP_CompatAmmo.dec`, both before any weapon that references the alias). Moving `PBWP_CompatAmmo.dec` alone, or moving the parent-ammo files away from it, will hard-crash startup.
- **Glory Kills system** layers on top of everything else via four parallel surfaces:
  1. Per-tier `actors/Monsters/<Tier>/GloryKills.dec` files define `*GK` wrappers (e.g. `PB_ImpGK`, `AracnorbGK`, `PB_CyberdemonGK`) that `replaces` the underlying monster and add stagger / execution / finisher states.
  2. `actors/GloryKills/GloryKillCommon.dec` plus the pinata items in `actors/Weapons/Slot8/SoulCube.dec` (misleading filename — it's pinata pickups) and `actors/Items/Ammo/PinataAmmo.dec` provide the loot-drop chain.
  3. ZScript overrides in `zscript/Monsters/<Family>/<Family>GloryKill.zc` wire ZScript-native stagger checks onto the DECORATE wrappers above.
  4. ACS scripts (`GloryMelee.o` → 6000/6001/6003/6004/6005; `GloryHUD.o`, `BloodPunch.o`, `lowhealth.o`, `EquipCooldown.o` for `FlameBelchReady`/`IceBombReady` cooldown) driven by the `+glorysaw` / `-glorysaw` / `shouldercannon` / `glorycryo` `alias` + `puke` bindings in `KEYCONF.txt` (recompile `SRC/GloryChain.acs` → `ACS/GloryMelee.o` or the lump your PK3 uses after editing).
  When editing this system, touch all four surfaces that apply, and add any new cvar to the `be_*` block in `CVARINFO` + the `Glorykill Options` submenu in `MENUDEF.txt`.
- **Glory Kills controls.** `KEYCONF.txt` exposes a `Glory kill` keysection with menu-bindable actions:
  `+glorysaw` / `-glorysaw` (Crucible, `puke 6000` / `puke 6001`); `shouldercannon` (`puke 6003`, uses current flame/cryo selection on the normal shoulder bind); and **`glorycryo`** (`puke 6005`, forces cryo/ice-bomb and queues shoulder fire the same way). Use `addmenukey` for any further Glory-kill actions so they land in the same section.
- **Glory kill HUD (Crucible + Blood Punch pips, shoulder background art).** When `be_fuelhud` is enabled, `SRC/GloryHUD.acs` draws layered fonts in the **center of the view** via `HudMessage(s:"A", …)` (one glyph per font, ASCII 65). The script branches on `sv_fuelhud_background` (`OptionValue "BackStyle"` in `MENUDEF.txt`):
  - `0` "Panel" / `1` "Panel + Font" / `2` "None" — legacy compact layouts using the `FUELPA01` / `CRUCPA*` / `CRAMMO*` / `BPAMMO0*` fonts. **`Fontdefs.txt`** aliases those legacy font names to single-character fonts that draw the **NewHud** PNGs in `graphics/hud/glorykills/newhud/*.png`, so the legacy panel layouts already render NewHud art (single icon centered).
  - `3` "Eternal (NewHUD)" — folded from Glory Kills staging (`Graphics/HUD/NewHud/` + staging's `Source/GloryHUD.acs` style 2). Spread layout: 5 elements horizontally (Crucible energy core → Crucible pip count → Blood Punch pips → Flame Belch icon → Ice Bomb icon) at X offsets 0/21/43/83/123. Fonts used directly: `CRUCRY00/01`, `CRUCAM01-03`, `BPAMMO10-14`, `SCFLM00/01`, `SCICB00/01` (all explicit one-glyph fonts in `Fontdefs.txt` mapping ASCII 65 → matching PNG). The Eternal branch reads **`FlameBelchReady` / `IceBombReady`** (cooldown-ready) for icon brightness, while legacy panel branches keep using `FlameBelchSelected` / `IceBombSelected` (current selection). HudMessage IDs (1120-1124) are shared with the legacy branches, so switching styles at runtime overwrites them cleanly.
  This whole HUD is **separate** from `SBARINFO.txt` (the main DOOM bar); the ACS overlay is the intended "Glory kill HUD" art. Overwrite the PNGs to refresh art from upstream, or extend `Fontdefs.txt` if filenames change. After editing `SRC/GloryHUD.acs`, **recompile** to `ACS/GloryHUD.o` with ACC.
- **Weapon-class naming caveats inherited from the Glory Kills merge.** The files at `actors/Weapons/Slot8/SoulCube.dec` and `actors/Weapons/Slot9/ShoulderCannon.dec` **do not** define actors called `SoulCube` or `ShoulderCannon`. They hold Glory-Kill-adjacent support actors (Pinata pickups, `DoShoulderCannon` inventory token, `GloryFireMissile`, `SC_CryoGrenade`, `GKFloorIce`, `FireArmorPinata`, …). The only new top-level weapon from the GK merge is `Crucible` (`CustomInventory`, `actors/Weapons/Slot1/Crucible.dec`), driven by the `+glorysaw` ACS scripts. Don't `summon SoulCube` / `summon ShoulderCannon` expecting a weapon — those class names don't exist.
- **ShieldSaw (folded from GK_ShieldSaw, no injectors).** The weapon class is **ZScript** `TheShieldSaw` in `zscript/Weapons/ShieldSaw.zc` — the throw is **only** in the `Fire` state; `Ready` loops on `A_WeaponReady` so the saw is not re-thrown until the player has `ShieldSaw_token` back (i.e. after the projectile’s `ShieldBack` gives ammo). The flying saw uses `ACS_NamedExecuteAlways("CallBack",…)` on spawn; `script "CallBack"` in `SRC/Shield_saw.acs` loops on the **projectile** until it receives inventory `CallBack` (from the `FastCall` `CustomInventory` `Use`, which `A_RadiusGive`s to `ShieldSawProjectile`). Each map start, `script "ShieldSawMapEnter" ENTER` in the same file **gives** `FastCall` (recall power) and, if the player owns `TheShieldSaw` but has **no** `ShieldSaw_token`, **refunds one** `ShieldSaw_token` so leaving a level with the saw still in flight does not soft-brick the weapon. Ammo for the throw remains `ShieldSaw_token` (not the add-on’s `ShieldsawAmmo`). There is no `PBInjector` / `InjectSpawn` path for 2022 — if you need map drops, add `ShieldSaw_token` to the **DECORATE** saw spawners, not a ZScript injector.
- **DemonTechMinigun N-mode wheel pattern (reference for multi-mode weapons).** `DemonTechMinigun` (`actors/Weapons/Slot9/DTechMinigun.dec`) uses a **3-mode** counter inventory `DemonTechMinigunMode` (`Inventory.MaxAmount 2`; logical modes **0 = Plasma Volley**, **1 = Acid Glob**, **2 = Danmaku Spiral`). **`ShrinkBeam` is not on this weapon** — it lives on **`HellPistoler`** (see below). `Fire` jumps **highest mode first**: `Mode >= 2` → `FireDanmaku`, `Mode >= 1` → `FireAcid`, else plasma `Hold`. Wheel grants use **`Select_DTechMG_Plasma` / `Select_DTechMG_Acid` / `Select_DTechMG_Danmaku`**; `WeaponSpecial` consumes `GoWeaponSpecialAbility`, clears stray tokens, wipes the counter (`TakeInventory` bulk), then **`GiveInventory("DemonTechMinigunMode", 1)`** for acid or **`GiveInventory(..., 2)`** for danmaku so stack counts match the `JumpIfInventory` checks (same pattern as older PB multi-mode counters). **`AltFire`** from acid or danmaku runs **`AltFireSnap`** (silent reset to plasma); mode 0 does nothing extra. Wheel UI: `void specialWheel_DTechMinigun()` in `zscript/PbWheel/ev_core_special.zsc` (icons `graphics/pywheel/Minigun_2.png`, `grenade_acid.png`, `graphics/CSSG/SG_Danmaku.png`) + **`case 'DemonTechMinigun':`** in `NetworkProcess`. Projectiles: **`DTechAcidGlob`** bounces (`+DOOMBOUNCE`, `BounceCount 2`) and spawns **`AcidSpot`** (`actors/Gore/GreenBlood.dec`); **`DTechSpiralBolt`** (`FastProjectile`) picks hue translations per shot. **Recipe for adding modes elsewhere:** (1) counter `Inventory` + one `Select_<Weapon>_<Mode>` token per wheel choice; (2) dispatch **`Fire`** with `JumpIfInventory` **from highest stack/value to lowest**; (3) **`AltFire`** or snap states only where it fits the animations; (4) `void specialWheel_<Weapon>()` + **`case '<ClassName>':`** in `NetworkProcess`.
- **Hell Pistoler wheel + shrink beam.** `HellPistoler` (`actors/Weapons/Slot2/HellPistoler.dec`) uses **`HellPistolerBeamMode`** (`Inventory.MaxAmount 1`): wheel option **Hell Rounds** clears it; **Shrink Beam** sets it so primary **`Fire`** runs **`FireShrink`/`HoldShrink`** firing **`ShrinkBeam`** (actor in `actors/Weapons/Slot9/DemonTech.dec`) at **`HellPistolerAmmo`** cost. The wheel’s third slot **`Select_HP_ToggleROF`** preserves the old **semi ↔ full-auto** messaging (`PistolerMod`) without tying it to weapon-special as a plain toggle anymore — **`WeaponSpecial`** resolves **`Select_HP_Shrink` → `Select_HP_Hellfire` → `Select_HP_ToggleROF`** after **`GoWeaponSpecialAbility`**. **`AltFire`** **`goto ReadyLoop`** while shrink is active so burst/charge paths don’t conflict. Wheel: **`void specialWheel_HellPistoler()`** + **`case 'HellPistoler':`** in `ev_core_special.zsc` `NetworkProcess`. DECORATE include order: **`HellPistoler.dec` is included after `DemonTech.dec`** (`DECORATE` comment) so **`Hellbullet`** / **`ShrinkBeam`** parents resolve.
- **Monster Pack spawners.** The `actors/SPAWNERS/MonsterSpawners/*.dec` files were replaced with MP's versions during the merge; they reference `RailNullPuff`, `OrangeShockwave`, `ZombieTankMissile`, `ZombiePlasmaTankExplosion`, and the brightmap set `brightmaps/monsters/Hellduke/DUKEC7–D7.png`, **none of which are defined/shipped in the mod or in the original Monster Pack add-on**. These produce console warnings at startup but the game boots and runs fine — treat them as pre-existing MP bugs, not regressions. Defining any of these actors (or supplying the missing brightmaps) will silence the warnings. (Note: `ZombieManSpawner.dec`'s `SpawnRifleCommando` state correctly spawns the in-mod `PB_ClassicCommando` actor — the legacy `PB_RifleCommando` class name no longer appears in the spawner code. The "RifleCommando" branding survives in the `NoRifleCommando` CVar, the `IsRifleCommando` token, and the `RifleCommandoPack`/`SpawnRifleCommando` state names, all of which gate or route to `PB_ClassicCommando`.)

## 5. Common-change recipes

**Add a new monster (DECORATE path)**
1. Create `actors/Monsters/<Tier>/<Name>.dec` extending `PB_Monster` (or an appropriate sibling).
2. Add `#include "actors/Monsters/<Tier>/<Name>.dec"` near the other monsters in `DECORATE`.
3. Reserve a `DoomEdNum` in `zmapinfo.txt` (next free in 23000–23133 range).
4. Register sounds in `SNDINFO.txt` (e.g. under a `// --- monsters ---` style section or with a new header comment).
5. Add sprites under `SPRITES/`, brightmaps in `BMAP/` + bindings in `doommonsters.bm`, and any dynamic lights in `GLDEFS`.
6. If the monster should spawn in vanilla levels, either use `Replaces` on the actor or hook into the appropriate spawner under `actors/SPAWNERS/MonsterSpawners/`.

**Add a new weapon**
1. Create `actors/Weapons/Slot<N>/<Name>.dec` extending `PB_Weapon` (from `actors/Weapons/BaseWeapon.dec`).
2. `#include` it under the matching section in `DECORATE`. If the weapon references a PBWP ammo alias (`PB_Shell`, `PB_HighCalMag`, `PB_Cell`, `PB_CellPack`) by name in state-action args, place the `#include` **after** the `PBWP_CompatAmmo.dec` block near line ~157, not in the trailing weapon block — see the **"DECORATE include order"** bullet in §4.
3. Reserve a `DoomEdNum` in `zmapinfo.txt`.
4. Add ammo (if needed) in `actors/Items/Ammo/` and pickup strings to `language.enu`.
5. Register sounds in `SNDINFO.txt` in the `PBWeapons` (or new weapon) section.
6. Add sprites/graphics and any `TEXTURES.*` patches.
7. If the weapon is ZScript-only (`class …` in `zscript/Weapons/`), make it **`class MyGun : PB_Weapon`** and wire **`Select` → `SelectFirstPersonLegs` → `SelectContinue`** (see the **ZScript-only weapons** bullet in §4). For shared helpers only, `PB_WeaponBase` in `zscript/Weapons/BaseWeapon.zc` still applies.
8. If the weapon can spawn from a map spawner, add a `server int pb_No<Weapon>Weapon` (or matching existing `pb_No*` naming) in `CVARINFO`, mirror it in **both** `WeaponSpawns` and `AddOnToggles` in `MENUDEF.txt` with `SpawnOnOff`, and gate every spawn path with `GetCVar` / ACS toggles the way existing weapons do.
9. If the weapon uses one or more ammo types, add an explicit `IsSelected <ClassName>` block in `SBARINFO.txt` (do not rely on the generic fallback for shipped weapons).

**Fold a weapon add-on into this mod (agent checklist)**
1. **Add-on layout:** Prefer an add-on folder that already contains top-level **`Sounds/`** and **`Sprites/`** (or equivalent) so all audio and graphics can be copied without hunting loose lumps. If upstream only ships a PK3, unpack to that shape before porting. Example fold: **XM-21 Sniper** — `actors/Weapons/Slot4/XM21.dec`, `sounds/combat/weapons/XM21/`, `SPRITES/WEAPONS/Slot4/XM21/`, the `SNDINFO.txt` (PBWeapons) block, `pb_NoPB_XM21Weapon` + chaingun spawner `SpawnPB_XM21`, `IsSelected PB_XM21` in `SBARINFO.txt`, `PB_PICKUP_PB_XM21` / `PB_WPNHINT_PB_XM21` in `language.enu`. Newer add-on **`PB_Projectile` / `PB_HighCalMag`** types were mapped to `FastProjectile` + **`NewClip`** (see `PORTING_ADDONS.md`).
2. **Behavior:** Match PB 2022 flow (`PB_Weapon` / `PB_WeaponBase`, tokens, spawner hooks, `KEYCONF` slot defaults) per the **Add a new weapon** recipe above — not bare ZScript ports unless the file you are editing is already ZScript-native.
3. **Spawn toggle:** Every weapon that can appear from a spawner must have an **On/Off** menu toggle (`SpawnOnOff` + `pb_No*` cvar) and all spawn branches must respect it.
4. **HUD:** Any weapon with ammo must have **dedicated** `SBARINFO` `IsSelected` handling for its primary (and secondary, if any) ammo so the fullscreen HUD matches other guns in its family.
5. **Assets:** Copy sounds under `sounds/` (path style used in `SNDINFO.txt` weapon sections) and sprites under `SPRITES/` (preserve lump/sprite names; respect case-sensitive paths on Linux loads).

**Fold equipment (e.g. Molotov cocktail)**  
Follow the same spawn/menu/HUD ideas, but the hook points are: `BaseWeapon.dec` equipment states (`UseEquipment` / `SwitchEquipment` / throw sequence), `zscript/PbWheel/ev_core_special.zsc` `specialWheel_Equipment`, `SBARINFO.txt` `InInventory` (not `IsSelected`), and a `pb_No*` cvar. Shipped assets: OGGs under `sounds/combat/weapons/MolotovCocktail/`, graphics under `SPRITES/weapons/Equipment/MolotovCocktail/`, brightmap PNGs under `Brightmaps/` (MOLO/MOLP) plus `lumps/includes/gldefs/MolotovCocktail.inc` (pulled in by `GLDEFS.txt`), wheel icon `graphics/pywheel/Equip_Molotov.png` (see `SNDINFO.txt` and `zscript/PbWheel/ev_core_special.zsc`).

**Port a newer-PB weapon add-on.** See `PORTING_ADDONS.md` for the compatibility map between 4.11.x-era PB add-ons and this 4.5.0-era codebase, plus the Lever Action port as a worked example.

**Add a CVar / menu option**
1. Declare it in `CVARINFO` (prefer the `pb_`, `cl_`, or `fs_` prefix matching existing conventions).
2. Expose it in `MENUDEF.txt` under the relevant submenu.
3. Add `OPTMNU_*` / menu label strings to `language.enu`.
4. Read it with `CVar.GetCVar("name", plr).GetBool()/GetInt()/GetFloat()` in ZScript, or `GetCVar` in DECORATE/ACS.

**Add a new ZScript event handler**
1. Create the class in `zscript/...` extending `StaticEventHandler` (for cross-level state) or `EventHandler`.
2. `#include` it from `ZSCRIPT.zc`.
3. Add `AddEventHandlers = "ClassName"` inside the `GameInfo { ... }` block in `zmapinfo.txt`.

**Add ACS script**
1. Write/extend in `SRC/<Name>.acs`.
2. Compile with ACC to `ACS/<Name>.o`.
3. Ensure the lump name appears in `LOADACS.txt`.

## 6. Testing / iteration

- Launch: `gzdoom.exe -iwad doom2.wad -file "Project Brutality 2022"` (works with `doom.wad`, `doom2.wad`, `tnt.wad`, `plutonia.wad`, or Freedoom).
- GZDoom logs to its console; **ZScript compile errors are fatal at startup** — fix them before anything else.
- Useful reproduction cvars:
  - `pb_classicmonsters` — swap between Brutality-style and classic monster rosters.
  - `pb_disablenewenemies`, `pb_disablenewguns`, `pb_disabledecorations`, `pb_disablemapenhancements` — gate major feature blocks; toggle when bisecting a bug.
  - `pb_lowgraphicsmode`, `pb_bloodamount`, `zdoombrutalblood`, `zdoombrutaljanitor`, `zdoombrutaljanitorcasings` — performance/visual knobs that significantly change behavior.
- Summoning is the fastest way to test a specific actor: console → `summon <ClassName>`.

## 7. Conventions

- **Casing.** Preserve the exact casing used in existing `#include` paths and lump names. Linux GZDoom treats them as case-sensitive.
- **Indentation.** Match the file you're editing: DECORATE files generally use 4-space indents; ZScript files use tabs.
- **Comments.** Do not add comments that narrate what the code does. The existing ZScript comments only explain intent (e.g. `// I call these "Mini Event Handlers" in decorate`).
- **Attribution.** Preserve the header comment `// IF YOU WANT TO USE STUFF FROM THIS MOD, GIVE ME CREDITS` at the top of `DECORATE` and any author credits in sub-files.
- **Reuse existing tokens.** Before defining a new flag-style `Inventory`, search `DECORATE` for an equivalent one.
- **DoomEdNum discipline.** Always update `DoomEdNums` in `zmapinfo.txt` and never reuse an existing number.

## 8. Reference documentation

When something is unclear about actor syntax, action functions, flags, or engine semantics, consult these sources (listed in priority order for this codebase):

- Primary authoritative ZScript reference: <https://github.com/zdoom-docs/stable>
- UZDoom source (versioned engine context, matches the engine PB targets): <https://github.com/UZDoom/UZDoom/tree/4.14.3>
- DECORATE format specifications: <https://zdoom.org/w/index.php?title=DECORATE_format_specifications>
- Action functions: <https://zdoom.org/w/index.php?title=Action_functions>
- Classes: <https://zdoom.org/w/index.php?title=Classes>
- Actor flags: <https://zdoom.org/w/index.php?title=Actor_flags>
- Actor properties: <https://zdoom.org/w/index.php?title=Actor_properties>
- Actor states: <https://zdoom.org/w/index.php?title=Actor_states>
- DECORATE expressions: <https://zdoom.org/w/index.php?title=DECORATE_expressions>

Rules of thumb:

- Prefer **zdoom-docs/stable** for ZScript (classes, event handlers, UI scopes, data types).
- Prefer the **zdoom.org wiki** pages above for DECORATE/actor authoring details (flags, state syntax, action-function signatures).
- Use the **UZDoom 4.14.3** tree to confirm engine-side behavior of an action function or flag when the wiki is ambiguous or stale.

## 9. Finding lumps in external GZDoom TCs & optional Brutal / BD22 “folds” (do not clobber core PB)

Use this when auditing **another mod** (e.g. Brutal Pack V10, Brutal Doom 22 test tree) to inventory graphics, models, and sounds, and when **folding** selected pieces into this repo.

### 9.1 How to *search* for content (lessons learned)

- **`glob` / `**/*.*` and similar patterns are a trap.** They usually list only files with a **dot extension**. A huge share of GZDoom content is **extensionless 8.3–style names** (e.g. `D_DM05`, `BSPRG0`, `KPRMA4A6`, root lumps `XHAIRS`, `BOTINFO`) and will **not** appear. Always supplement with a filter for `Extension` empty (or a directory listing that does not require `.`).
- **On Windows, use PowerShell and `-LiteralPath`** for paths with parentheses, spaces, or OneDrive — e.g. `…/((TEMP))/(CRASH)/01 bd22test6rc1`. A bare string can break; `-LiteralPath 'C:\…\01 bd22test6rc1'` is safe.
- **Extensionless inventory (examples to run in PowerShell):**
  - `Get-ChildItem -LiteralPath '…' -Recurse -File | Where-Object { -not $_.Extension }` — extensionless only.
  - `Get-ChildItem -LiteralPath '…' -Recurse -File | Where-Object { $_.Extension -match '(?i)\.(md2|md3|png|lmp|wad|pk3|pk7)$' }` — common asset extensions.
- **A folder mod may have no monolithic `*.wad` / `*.pk3` at the root** and still be a full mod: **loose** directories are valid for `-file` loads; don’t treat “no WAD found” as “no assets.”
- **Gore and props are often split** between **`sprites/…`** (loose `.png` in subfolders **or** extensionless image lumps), **`models/…/…md3`**, and **skin/texture `*.png`** next to the MD3. GZDoom ships **`modeldef*.txt`** and matches sprite frames to models via `FrameIndex`. Search for `modeldef` and `MODELS` in the other project.
- **Ripping from embedded WADs** inside a third-party pack: if the tree **does** include `SomePack.wad`, use **SLADE**, **Ultimate Doom Builder** resource browser, or similar to list **embedded** lumps; those never show up in a **recursive file search of only loose folders**.

### 9.2 Brutal Pack 10.4 (local asset source, not in repo)

Some developers keep **Brutal Pack V10** unpacked next to the repo (e.g. `…/temp/((TEMP))/(CRASH)/BRUTALPACK_10.4/BRUTAL-PACK-V10-main`). It is **not** part of this repository; use it only as a **reference or copy source** for sprites/sounds when porting finishers. Do not commit the whole pack.

- **Layout (typical):** `SPRITES/FATALITY` and `SPRITES/MONSTERFATALITY` hold first-person / finisher-related graphics; `SPRITES/MONSTERS`, `SPRITES/PLAYER`, `WEAPONS`, `GORE`, etc. follow the usual Doom layout. The pack root may ship **`.wad` resources** (e.g. `DeathIncarnate.wad`, `ExtraTextures.wad`) with **embedded** graphics.
- **Code crosswalk:** Brutal Pack’s `decorate/PLAYER.txt` is **not** a drop-in for this mod. Port **assets +** wire **new** tokens/states to PB’s existing Glory Kill / execution flow (`actors/Player/NEWPLAYE.dec` + `PLAYER.dec`).

### 9.3 Merging **Brutal Doom 22** (BDv22) gore *into* this mod *without* overwriting core files

**Goal:** add optional content under **new `BDv22_…` class names and paths**; only **insert** a single `DECORATE` include and matching `ZSCRIPT` includes — **do not** replace the bodies of `BLOOD.dec`, `PBGore.zc`, or Nash Gore sources wholesale.

- **Conventions in this mod:**
  - **ZScript (optional + handlers):** `zscript/Gore/BDv22GoreHandler.zc` (opt-in on-hit `BDv22GoreMist` when `bdv22_mist` is on), `BDv22GoreMergeHandler.zc` (spawns `BDv22_Guts*`, meat chunks, organs, etc. when the matching `bdv22_*` cvars are on), `BDv22Gore/BDv22GoreMist.zc`. **Do not** route unrelated content through `NashGoreHandler.zc` in place; add a separate handler and one `ZSCRIPT` include.
  - **Add-on folder:** `actors/Gore/BDv22Gore/` and `zscript/Gore/BDv22Gore/`. Stubs: `#include "actors/Gore/BDv22Gore/BDv22Gore.dec"` in `DECORATE`, and in `ZSCRIPT.zc` after `PBBlood`: `BDv22GoreHandler` → `BDv22Gore/BDv22GoreMist` → `BDv22GoreMergeHandler` → `PBGore` (order matters for `PB_Bloodmist`).
  - **Asset drops:** prefer **`SPRITES/BDv22/`** (lump prefixes `P22M*`, `B22G*`, `B22M*`, `B22T*`, `B22R*`, `B22S*`, `B22E*`, `B22P*`, `B22O*`, `B22U*`, …), **`models/BDv22/`** (or `MODELS/BDv22/`), add models under `lumps/includes/bdv22_modeldef.inc` (and `#include` from `modeldef.txt`); extend **`SNDINFO.txt`** with new logical names in a new section — **rename** every lump you copy from upstream so nothing collides with Project Brutality stock content.
  - **Cvars (Gore/Debris — menu labels start with “Brutal Doom 22:”):** `bdv22_mist`, `bdv22_corpse_meat`, `bdv22_flying_meat`, `bdv22_organs`.
  - **Actor / class names** use the **`BDv22_` / `BDv22*`** pattern (not the original Brutal class names), to avoid `Replaces` and spawn-name clashes, unless you are sure there is no conflict.
  - **Do not** blindly add `replaces` to core engine classes; use separate actors + `EventHandler` / spawns with cvar gates, or PB’s `CheckReplacement` path, after reading existing Nash Gore behavior.
- **Licensing / credits:** Brutal Doom 22 (and similar) art remains **third-party**; keep author credits and any distribution limits the upstream author requires.

### 9.4 Quick reference: where the Brutal Doom 22 (BDv22) add-on is wired in

| Entry | What to add (insert only) |
| --- | --- |
| `DECORATE` | One line: `#include "actors/Gore/BDv22Gore/BDv22Gore.dec"` (see “//New Blood” / Gore block). |
| `ZSCRIPT.zc` | `#include` `BDv22GoreHandler.zc` → `BDv22Gore/BDv22GoreMist.zc` → `BDv22GoreMergeHandler.zc` → `PBGore` (order matters for PBBlood bases). |
| `lumps/includes/bdv22_modeldef.inc` | Optional BDv22 model `Model` blocks, `#include`d from `modeldef.txt` (avoids an extra `modeldef*` root lump). |
| `zmapinfo.txt` | `BDv22GoreHandler` and `BDv22GoreMergeHandler` in `AddEventHandlers` (see that file for the current full list). |
| `MENUDEF` / `CVARINFO` / `language.enu` | Cvars and Gore/Debris menu lines for the `bdv22_*` options; menu labels credit **Brutal Doom 22**. |

### 9.5 Folding **Brutal Pack V10** (BPv10) gore *into* this mod (sibling add-on to BDv22)

Optional gore add-on built from the Brutal Pack V10 `SPRITES/GORE` set (original sprites by AWEZ). Wired in the same insert-only style as the BDv22 fold: new `BPv10_*` actor names, no `replaces` of core PB classes, all gates behind `bpv10_*` cvars. Defaults to **off** (`bpv10_enable = false`).

- **Scope:** humanoid grunts (`PB_ZombieMan`, `PB_ShotgunGuy`, `PB_ZombieScientist`, `PB_Commando`, `PB_ClassicCommando`, `PB_Nazi`) plus the imp family (`PB_Imp`, `PB_IceImp`, `PB_InfectedImp`, `PB_DarkImpNami/Nether/ST/Void`, `DNImpVariant1/2/3`). Imps skip the zombie-gear-debris path. The handler also resolves the killer to a `PlayerPawn` so non-player monster infighting does not trigger BPv10 gore.
- **Damage routing:**
  - Burn / fire / FlameBelch / Napalm → `BPv10_BurnedHusk` / `BPv10_BurnedHusk2` (BDT1/BDT2/BDT3 sprite strips, `SPRITES/GORE/BURNINGMAN/`).
  - Plasma / disintegrate / lightning / BFG → `BPv10_CarbonizedBody` (BRZ3 + CARB strips, `SPRITES/GORE/CARBONIZED/`).
  - X-deaths additionally roll: `BPv10_FlyingTorso1/2` (XMT1/XMT2), `BPv10_FlopOrgans` (MANA), `BPv10_ZombieGearDebris` (ZGEA-D, humanoids only), `BPv10_BloodSplat0–4` (BL00–BL04).
- **Add-on folder:** `actors/Gore/BPv10Gore/` and `zscript/Gore/BPv10Gore/`. Stubs: `#include "actors/Gore/BPv10Gore/BPv10Gore.dec"` in `DECORATE` (right after the `BDv22Gore` include), and `#include "zscript/Gore/BPv10Gore/BPv10GoreHandler.zc"` in `ZSCRIPT.zc` (right after `BDv22GoreMergeHandler.zc`, before `PBGore`).
- **Sprite layout:** All BPv10 frames live under `SPRITES/GORE/` and its `BURNINGMAN/` + `CARBONIZED/` subfolders. GZDoom recursively scans `SPRITES/` for loose-file mods so the nested layout still resolves to lump names. Do **not** flatten — lump-name collisions with the V10 source filenames (e.g. `BDT1A1.png`, `BRZ3A1.png`, `CARBA0.png`) are intentionally avoided by the subfolder split.
- **Sound reuse:** BPv10 actors call `nashgore/bloodsplash` (already defined in `SNDINFO.txt`) for landing splats — do not invent new `misc/*` sound names without registering them.

| Entry | What to add (insert only) |
| --- | --- |
| `DECORATE` | One line: `#include "actors/Gore/BPv10Gore/BPv10Gore.dec"` (placed next to the `BDv22Gore` include in the Gore block). |
| `ZSCRIPT.zc` | One line: `#include "zscript/Gore/BPv10Gore/BPv10GoreHandler.zc"` (after `BDv22GoreMergeHandler.zc`, before `PBGore`). |
| `zmapinfo.txt` | `AddEventHandlers = "BPv10GoreHandler"` (sibling to the `BDv22*` handlers). |
| `CVARINFO` | `bpv10_enable` master + `bpv10_burn_corpse`, `bpv10_carbonized`, `bpv10_xdeath_torso`, `bpv10_flop_organs`, `bpv10_zgear`, `bpv10_blood_splat`. |
| `MENUDEF.txt` | Extra block in `OptionMenu "PB_2022_BDv22GoreMenu"` (after the BDv22 options) with `NashGoreOption` entries for each `bpv10_*` cvar. |
| `language.enu` | `BPV10GOREMNU_*` and `*_TIP` strings. Menu labels credit **Brutal Pack V10** (sprites by AWEZ). |
