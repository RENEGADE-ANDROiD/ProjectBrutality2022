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
| `zmapinfo.txt` | `TITLEMAP`, skill definitions, `GameInfo { AddEventHandlers ... }`, and the `DoomEdNums` table reserving editor numbers **23000–23133**. |
| `KEYCONF.txt` | `addplayerclass PB_Doomer`, custom keybinds, netevent aliases (`PBWeaponSpecialOn/Off`, `PBEquipSpecialOn/Off`, `EV_ClearGore`, etc.). |
| `CVARINFO` | All `pb_*`, `cl_*`, `fs_*`, `py_*`, `be_*`, `sv_*` cvars. Check here before inventing a new one. The `be_*` and `sv_fuelhud_*` / `sv_bonusrange` / `sv_ammorange` block (bottom of file, from `be_ExecutionsON` to `sv_fuelhud_y`) is the Glory Kills settings — read and written by the pinata + stagger system. |
| `MENUDEF.txt` | Options-menu structure for everything declared in `CVARINFO`. Includes the `Glorykill Options` submenu (`OptionMenu "Glorykills"`, reachable from the main options list) plus the shared `OptionValue "MaxStat"` / `"FHudsize"` / `"BackStyle"` definitions used by that submenu. |
| `SBARINFO.txt` | Status bar / HUD. |
| `language.enu` | All localized strings; every menu label and pickup message lives here. |
| `SNDINFO` + `SNDINFO.PB*` + `SNDINFO.GloryKills` + `SNDINFO.MonsterPack` | Sound logical names, split into per-category shards (`PBWeapons`, `PBMonsters`, `PBGore and Nashgore`, `PBDoomguy and Marines`, `PDA`, `ChexCompatibility`, `GloryKills`, `MonsterPack`). GZDoom auto-loads every `SNDINFO*` lump — no include list. |
| `GLDEFS` (+ `GLDEFS.OVERLORD`) | Dynamic-light definitions. The tail of `GLDEFS` holds the Glory Kills hardware-shader bindings (`glorykill.shader`) followed by Monster Pack light/brightmap definitions. |
| `doomdefs.bm`, `doommonsters.bm` | Brightmap bindings; sprites under `BMAP/` and `brightmaps/`. |
| `ANIMDEFS`, `DECALDEF`, `modeldef.txt`, `TEXTURES.*` (incl. `TEXTURES.FX` — shader-UV mappings for the Glory Kill shader), `Textures.txt`, `XHAIRS`, `TRNSLATE` / `trnslate.txt`, `Fontdefs.txt`, `TEXTCOLO.txt` | Assets and definitions wired in by the engine automatically. |
| `LOADACS.txt` | Lists compiled ACS lumps from `ACS/` to auto-load. Tail of the file is the Glory Kills block: `lowhealth`, `GloryMelee`, `GloryHUD`, `BloodPunch`. |
| `DECORATE` | Master `#include` list for every legacy actor under `actors/`, plus many small inventory-token actors defined inline. |
| `ZSCRIPT.zc` | Master `#include` list for every ZScript file under `zscript/`, plus a handful of inline classes (`Demonpickup`, `CameraRunner`, `MBlurHandler`, `XDeathGibBase`, `SpawnerBase`, `BossBrainBase`, `InvisiblePuff`, `EPBWeaponFlags`). |
| `MBlur.fp` | Fragment shader used by the optional motion blur (`MBlurHandler`). |
| `PDAMONST`, `PDAWEAP`, `PDAWEAPT` | Data tables consumed by the PDA (`zscript/PBPDA.zc`). |
| `titlemap.wad`, `TitleMap` | Title-screen level. |

## 3. Folder map

```
actors/                    DECORATE actors, organized by domain
  Brutality/               Brutality-style variants of vanilla grunts
  Weapons/
    BaseWeapon.dec         Common PB_Weapon base + shared overlays
    Slot1 .. Slot9/        Player weapons grouped by slot. Slot1 now also holds Crucible.dec + BloodPunch.dec; Slot8 holds SoulCube.dec (Glory Kill pinata pickups, NOT a SoulCube weapon); Slot9 holds ShoulderCannon.dec (Glory Kill shoulder-cannon fire / cryo grenade / floor-ice FX, NOT a standalone weapon).
    Meatshields/           "Grab enemy as a shield" variants per monster
  Monsters/
    T1-Grunts/             Zombiemen, Sergeants, Commandos, Nazis; plus MP additions: Horrorspawn, Hunger, ZombieTank, ZombieTankElite, ZombiePlasmaTank, ZombieMissileTank, PB_ZombieFlyer (+ lasertracer model)
    T1-Imps/               Imp family (incl. DarkImp variants)
    T2-Pinkies/            Demons, Spectres, MeanDemon, MechDemon; plus MP Crackodemon
    T3-Arachnos/           Arachnotrons, Aracnorb (+ MP-ported AracnorbPassiveSpawn), Arachnophyte
    T3-Fats/               Mancubus + Daedabus / Volcabus
    T3-Floaters/           Cacodemon, Lost Soul, Pain, Watcher, Overlord, etc.; plus MP Helemental and ESoul (Etherealsoul.dec)
    T3-Revies/             Revenant, BeamRev, Draugr
    T4-Nobles/             Knight, Baron, Cyber* variants, Belphegor, Infernus
    T4-Viles/              Archvile, IceVile, FleshWizard, Hellion; plus MP Hierophant
    Tz-Bosses/             Cyberdemon, Mastermind, Annihilator, Demolisher, Juggernaut; plus MP Hellduke, Hellsmith, Director, AracnorbQueen
    Tz-Frozen/              Frozen death variants per tier
    Tz-Shrinks/            "Lil Guys" shrunk variants
    <Tier>/GloryKills.dec  Per-tier GK monster wrappers (PB_ImpGK, AracnorbGK, PB_CyberdemonGK, …) that `replaces` the base actor and add stagger / execution states. One file per tier.
  GloryKills/              GloryKill common tokens & pinata/highlight/particle actors (GloryKillCommon.dec)
  Items/{Ammo,Health,Powerups}/   Items/Ammo/ now also holds PinataAmmo.dec; Items/Powerups/ holds Pinata.dec-style pickups
  Decorations/Barrels/     Replacement barrel set
  Effects/                 Puffs, tracers, smoke, sparks, splashes, decals. Also PinataParticles.dec (GK particle effects)
  Gore/                    Blood, gibs, burn, sticky, underwater, black-hole
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
    PBBlood.zc, PBGore.zc, PBGoreEffects.zc
    NashGore/              Nash Muhandes' gore system + NashGoreHandler
  PbWheel/                 Weapon / equipment selection wheel (note the casing: `PbWheel` with a capital P — the GK add-on shipped `pbWheel` but that was normalized on merge)
  TiltPlus/                Tilt++ screen-tilt system + menu
  Spawner/                 PB_SpawnerBase + weapon spawners (e.g. shotgun)
  LaserAPI/                lewisk3's laser sight API
  PBVP/                    PB Voxel Project hooks (model toggle)
  SpecialShit/             "Hat extravaganza" cosmetic system
  Separated Movement Modes/
  Decorations/, Effects/

ACS/                       Compiled ACS object lumps (LOADACS.txt lists them). Glory Kills additions: lowhealth.o, GloryMelee.o (compiled from SRC/GloryChain.acs, script numbers 6000/6001/6003/6004), GloryHUD.o, BloodPunch.o.
SRC/                       ACS source (.acs) matching files in ACS/. GloryChain.acs compiles to GloryMelee.o (not GloryChain.o — filename differs by convention).
Shaders/                   GZDoom hardware-shader source. Currently just glorykill.shader (wired in through the Glory Kills block in GLDEFS).
SPRITES/, GRAPHICS/, HIRES/, PATCHES/, MODELS/, SOUNDS/, BMAP/, brightmaps/   Assets. GK sprite subfolders: Crucible/, CrucibleTrail/, Effect/, FATALITY/, GLORYKILL/, GLORYSAW/, ShoulderCannon/, SOULCUBE/. MP monster sprite subfolders under SPRITES/Monsters/ follow MP's original folder names (Aracnorb/, Crackodemon/, Director/, Etherealsoul/, Helemental/, Hellduke/, Hellsmith/, Hierophant/, Fodder/, Zombie Tank/, Zombie Flyer/, Zombiemissiletank/, Zombieplasmatank/, Zombietankelite/, Lost Spirit/).
titlemap.wad, TitleMap     Title-screen content
```

## 4. Architecture notes that catch agents off guard

- **Mixed DECORATE + ZScript.** Most actors are still DECORATE (`actors/**/*.dec`). Newer systems — event handlers, HUD UI, wheel UI, gore, PlayerPawn movement, execution GUI — are ZScript (`zscript/**/*.zc|.zsc|.txt`). **Do not port DECORATE to ZScript wholesale.** Follow the convention of the file you're editing.
- **Inventory tokens as flags.** A large block at the top of `DECORATE` defines tiny `Inventory` actors (`EvadeCheck`, `ExecutionToken`, `IsDead`, `PlayerWheelOpen`, `CantFire`, `NoZombieGrenade`, `BrutalCounter`, `FallingHeight`, `TargetIsACyberdemon`, etc.) that are used as booleans/counters through `A_GiveInventory` / `CountInv` / `CheckInventory`. Scan these before adding a new one — many already exist.
- **Event handlers are registered via MAPINFO**, not in ZScript. See the `GameInfo { AddEventHandlers = ... }` block in `zmapinfo.txt`. Currently registered:
  `pb_ExecutionHandler`, `PB_EventHandler`, `MBlurHandler`, `NashGoreHandler`, `TiltPlusPlusHandler`, `DeathFadeBootstrap`, `DEDashJumpHandler`, `GrapplingHookHandler`, `SpeedoMeterHandler`, `WallSlideHandler`, `PB_SpecialWheelHandler`, `HatExtravaganza`.
  Adding a handler requires both a ZScript class **and** a new `AddEventHandlers` line.
- **Editor numbers** come from the reserved **23000–23133** range in the `DoomEdNums` block of `zmapinfo.txt`. Add a new entry there when introducing a placeable actor; do not reuse numbers.
- **ACS workflow.** Edit `.acs` in `SRC/`, recompile to `.o` in `ACS/` with ACC (matching the GZDoom version), and make sure the lump name is listed in `LOADACS.txt`. Never hand-edit `.o` files.
- **Player class is fixed** to `PB_Doomer`. It is defined in `actors/Player/PLAYER.dec` and extended by `PlayerPawnBase : PlayerPawn` in `zscript/PlayerPawn.zc`. `gameinfo.txt` enforces `NoRandomPlayerClass = True`.
- **Custom weapon flags** live in `EPBWeaponFlags` (inside `ZSCRIPT.zc`): `PBWEAP_KEEPYOFFSET`, `PBWEAP_ISPISTOLSILENCERSTATE`, `PBWEAP_UNLOADED`. Weapons extend `PB_Weapon` (DECORATE) on top of `PB_WeaponBase` (ZScript).
- **Monster base classes.** DECORATE monsters extend `PB_Monster` (or its DECORATE wrappers) and usually declare `Replaces <VanillaActor>`. ZScript monster logic lives in the abstract `PB_Monster` class in `zscript/Monsters/PBMonster.zc` (hitbox handler, `A_SmartChase`, execution handler).
- **Global constants.** Defined in `ZSCRIPT.zc`: `MAXITERATIONS`, `STAT_NashGore_Gore`, `STAT_PB_BULLETS`, `C_TID`, `MAX_R`, `ADJUST_R`, `VIEW_HEIGHT`.
- **Many lump names are case-sensitive on Linux GZDoom.** Preserve the exact casing used in `DECORATE` / `ZSCRIPT.zc` include paths (e.g. `Actors/Decorations/Barrels/BarrelEffects.dec` vs `actors/Effects/PARTICLES.dec`). Do not "normalize" capitalization.
- **Glory Kills system** layers on top of everything else via four parallel surfaces:
  1. Per-tier `actors/Monsters/<Tier>/GloryKills.dec` files define `*GK` wrappers (e.g. `PB_ImpGK`, `AracnorbGK`, `PB_CyberdemonGK`) that `replaces` the underlying monster and add stagger / execution / finisher states.
  2. `actors/GloryKills/GloryKillCommon.dec` plus the pinata items in `actors/Weapons/Slot8/SoulCube.dec` (misleading filename — it's pinata pickups) and `actors/Items/Ammo/PinataAmmo.dec` provide the loot-drop chain.
  3. ZScript overrides in `zscript/Monsters/<Family>/<Family>GloryKill.zc` wire ZScript-native stagger checks onto the DECORATE wrappers above.
  4. ACS scripts (`GloryMelee.o` → 6000/6001/6003/6004; `GloryHUD.o`, `BloodPunch.o`, `lowhealth.o`) driven by the `+glorysaw` / `-glorysaw` / `shouldercannon` `alias` + `puke` bindings in `KEYCONF.txt`.
  When editing this system, touch all four surfaces that apply, and add any new cvar to the `be_*` block in `CVARINFO` + the `Glorykill Options` submenu in `MENUDEF.txt`.
- **Glory Kills controls.** `KEYCONF.txt` exposes a `Glory kill` keysection with two menu-bindable actions:
  `+glorysaw` / `-glorysaw` (Crucible, `puke 6000` / `puke 6001`) and `shouldercannon` (`puke 6003`). Use `addmenukey` for any further Glory-kill actions so they land in the same section.
- **Weapon-class naming caveats inherited from the Glory Kills merge.** The files at `actors/Weapons/Slot8/SoulCube.dec` and `actors/Weapons/Slot9/ShoulderCannon.dec` **do not** define actors called `SoulCube` or `ShoulderCannon`. They hold Glory-Kill-adjacent support actors (Pinata pickups, `DoShoulderCannon` inventory token, `GloryFireMissile`, `SC_CryoGrenade`, `GKFloorIce`, `FireArmorPinata`, …). The only new top-level weapon from the GK merge is `Crucible` (`CustomInventory`, `actors/Weapons/Slot1/Crucible.dec`), driven by the `+glorysaw` ACS scripts. Don't `summon SoulCube` / `summon ShoulderCannon` expecting a weapon — those class names don't exist.
- **Monster Pack spawners.** The `actors/SPAWNERS/MonsterSpawners/*.dec` files were replaced with MP's versions during the merge; they reference `PB_RifleCommando`, `RailNullPuff`, `OrangeShockwave`, `ZombieTankMissile`, `ZombiePlasmaTankExplosion`, and the brightmap set `brightmaps/monsters/Hellduke/DUKEC7–D7.png`, **none of which are defined/shipped in the mod or in the original Monster Pack add-on**. These produce console warnings at startup but the game boots and runs fine — treat them as pre-existing MP bugs, not regressions. Defining any of these actors (or supplying the missing brightmaps) will silence the warnings.

## 5. Common-change recipes

**Add a new monster (DECORATE path)**
1. Create `actors/Monsters/<Tier>/<Name>.dec` extending `PB_Monster` (or an appropriate sibling).
2. Add `#include "actors/Monsters/<Tier>/<Name>.dec"` near the other monsters in `DECORATE`.
3. Reserve a `DoomEdNum` in `zmapinfo.txt` (next free in 23000–23133 range).
4. Register sounds in `SNDINFO.PBMonsters`.
5. Add sprites under `SPRITES/`, brightmaps in `BMAP/` + bindings in `doommonsters.bm`, and any dynamic lights in `GLDEFS`.
6. If the monster should spawn in vanilla levels, either use `Replaces` on the actor or hook into the appropriate spawner under `actors/SPAWNERS/MonsterSpawners/`.

**Add a new weapon**
1. Create `actors/Weapons/Slot<N>/<Name>.dec` extending `PB_Weapon` (from `actors/Weapons/BaseWeapon.dec`).
2. `#include` it under the matching section in `DECORATE`.
3. Reserve a `DoomEdNum` in `zmapinfo.txt`.
4. Add ammo (if needed) in `actors/Items/Ammo/` and pickup strings to `language.enu`.
5. Register sounds in `SNDINFO.PBWeapons`.
6. Add sprites/graphics and any `TEXTURES.*` patches.
7. If the weapon needs ZScript-side hooks (overlays, laser, execution), extend/reuse `PB_WeaponBase` in `zscript/Weapons/BaseWeapon.zc`.

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
