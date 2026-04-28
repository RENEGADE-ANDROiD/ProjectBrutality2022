# Project Brutality 2022

Project Brutality 2022 is a full gameplay and content overhaul for *Doom* and *Doom II*, built for [UZDoom](https://github.com/UZDoom/UZDoom). It centers on a dedicated player class, deep weapon and monster variety, Brutality-style combat, and a wide set of menu options so you can tune intensity, spawns, and presentation.

The project is derived from the long-running [Project Brutality](https://github.com/pa1nki113r/Project_Brutality) line and ships as a **self-contained** package: Glory Kills, Monster Pack–style content, and the main weapon roster are all included in this folder. Load **only** this directory with UZDoom; no extra companion wads are required for the full feature set.

For the latest upstream mainline mod, see [pa1nki113r/Project_Brutality](https://github.com/pa1nki113r/Project_Brutality). This repository is the Project Brutality 2022 snapshot and tooling described here.

> **Engine:** This release targets **UZDoom**, the actively maintained fork in the GZDoom family. Please use a current UZDoom build (see Requirements). Older or unrelated source ports are not supported.

## Requirements

- **[UZDoom](https://github.com/UZDoom/UZDoom) 4.13 or newer.** Development tracks the [UZDoom 4.14.3](https://github.com/UZDoom/UZDoom/tree/4.14.3) line. Install a release from the [Releases](https://github.com/UZDoom/UZDoom/releases) page. The mod uses ZScript and other features that only exist on recent UZDoom builds.
- **An IWAD** — `doom.wad`, `doom2.wad`, `tnt.wad`, `plutonia.wad`, or [Freedoom Phase 1+2](https://freedoom.github.io/download.html). Retail IWADs are available from the [Steam classics bundle](https://store.steampowered.com/sub/18397/) or GOG ([Doom II + Final Doom](https://www.gog.com/game/doom_ii_final_doom), [The Ultimate Doom](https://www.gog.com/game/the_ultimate_doom)).
- **Mobile (Android / iOS) is not supported.** There is no supported UZDoom build on those platforms with the feature set this mod needs.

## Installation

1. Install **UZDoom 4.13+** from the [UZDoom releases](https://github.com/UZDoom/UZDoom/releases) and unpack it somewhere convenient.
2. Download this repository (**Code → Download ZIP**) or clone it.
3. You should have a folder (for example `Project Brutality 2022`) that contains `gameinfo.txt`, `ZSCRIPT.zc`, `DECORATE`, and the rest of the data. The mod is a **loose folder**, not a single PK3 file.
4. Launch with that folder on the command line:

```
uzdoom.exe -iwad doom2.wad -file "Project Brutality 2022"
```

You can also drag the folder onto `uzdoom.exe` or add it in a launcher such as [ZDL](https://github.com/lcferrum/qzdl/releases), [DoomRunner](https://github.com/Youda008/DoomRunner/releases), or [SSGL](https://github.com/FreaKzero/ssgl-doom-launcher/releases) — set the engine path to your UZDoom binary.

## What you get

- **Player and systems:** The `PB_Doomer` player class, movement (dash, slide, ledge grab, and related options), **Explosive Movement** rocket-jump / plasma-boost tech (toggle under **Options → Brutality 2022 Additions → Explosive Movement** — **`pb_rocketjump`**, **`pb_plasma_wallclimb`**), tactical weapon feel, gore, executions, and integrated HUD / PDA / wheel flows.
- **Combat depth:** Brutality-style damage, gore layers, and Glory Kill content with its own options menu.
- **Content breadth:** A large weapon roster, extra monsters, kill streaks and power-up reward hooks, and announcer support, all tied into Project Brutality cvars and menus.
- **Configuration:** Most systems can be toggled or tuned under **Options → Project Brutality Settings**, **Options → Brutality 2022 Additions** (includes **Explosive Movement** next to UI blocks like instant weapon switch), **Options → Weapon Settings**, and **Options → Glory Kill Options**.
- **Gore and debris:** Core Project Brutality gore plus **Nash Gore**. On top of that, two optional add-on stacks share one menu screen (**Options → Brutality 2022 Additions → Brutal Doom 22 gore**, also linked from **Project Brutality Settings → Visual → Gore/Debris**):
  - **Brutal Doom 22** (`bdv22_*`) — hit mist, corpse guts, flying meat, organs, and a **PB/BDv22 gore mix** slider. Content under `actors/Gore/BDv22Gore/`, `zscript/Gore/`, and `SPRITES/BDv22/`.
  - **Brutal Pack V10** (`bpv10_*`) — optional extras adapted from **Brutal Pack V10** sprites (AWEZ): burned husks, carbonized corpses, X-death torso bits, flop organs, zombie gear debris, and blood splats. Applies to **humanoid grunts and imps** only; master toggle **`bpv10_enable`** defaults **off**, with per-feature **`bpv10_burn_corpse`**, **`bpv10_carbonized`**, **`bpv10_xdeath_torso`**, **`bpv10_flop_organs`**, **`bpv10_zgear`**, **`bpv10_blood_splat`**. Content under `actors/Gore/BPv10Gore/` and `SPRITES/GORE/` (see **Credits**). Respect upstream licensing if you redistribute any of this.

### Weapon roster (spawn and options)

Canonical cycle weapons match **`PLAYER.dec`** `WeaponSlot` entries (what **`PB_Doomer`** can equip outside scripted cheats). Glory Kill gear (**Crucible**, shoulder cannon, etc.) lives outside normal weapon slots—see Glory Kill options, not this list.

**Slot 1 — melee / specials**

- Melee (`Melee_Attacks`)  
- Axe  
- Chainsaw  
- Argent Sith Beam Katana  
- Beam Katana (Nanotech)  
- Vorpal Blade  
- Shield Saw  

**Slot 2 — pistols / PDWs**

- Pistol  
- Revolver  
- MP40  
- Submachine Gun (UAC SMG)  
- Riot Shield  
- Deagle  
- Hell Pistoler  

**Slot 3 — shotguns**

- Shotgun (pump)  
- Autoshotgun  
- Super shotgun (`PB_SSG`)  
- Combat shotgun (`PB_CSSG`)  
- HASG (“Lady Golide”)  
- X12 shotgun  
- Quad-barrel shotgun  
- Marauder super shotgun  

**Slot 4 — rifles / precision**

- DMR / Rifle (dual wield when unlocked; **HDMR** modes via upgrades—spawn/menu **`pb_NoHDMRWeapon`**)  
- Carbine  
- Chex rifle *(temporary Chex Quest hook)*  
- XM-21 Sniper  
- LMG  
- Metal sniper  
- Old HMG  
- Lever Action rifle  
- Pro-Surv Ballista  
- M41A  
- Battle Rifle (BDP Battle Rifle)  

**Slot 5 — heavy bullet hoses**

- Minigun (triple-barrel upgrade—spawn/menu **`pb_NoMinigunUpgradeWeapon`** alongside **`pb_NoMinigunUpgrade`**)  
- Nailgun  
- MG42  
- Demon Tech Minigun  

**Slot 6 — launchers**

- Super grenade launcher  
- Rocket Launcher  
- Paingiver  
- Excavator Launcher  
- Mastermind Chaingun  
- Cyberdemon rocket launcher  

**Slot 7 — energy rifles**

- M1 Plasma Rifle  
- M2 Plasma Rifle  
- Pulse Cannon  
- Dual Pulse Cannons  

**Slot 8 — specials**

- Freezer Rifle  
- Rail Gun  
- Bio Acid Launcher  
- Mancubus Flame Cannon  

**Slot 9 — super-weapons**

- Blackhole Generator (`BHGen`)  
- Unmaker  
- BFG 9000  
- BFG MKIV beam (**PB_BFGBeam**)  
- Demon Exterminator  

**Slot 0 — Demon Tech pair**

- Flamethrower  
- Hell rifle (`Hell_rifle` pickup alongside Demon Tech)  

Glory Kill–adjacent actors (**Crucible**, pinata pickups under **`SoulCube`**, shoulder cannon FX) are separate from normal **`WeaponSlot`** cycling—see **`AGENTS.md`**.

### Equipment

- Freeze Nade  
- Hook  
- Void Grenade  
- Freezebot  
- ElecPod  

### Explosive Movement (rocket jump & plasma wall boost)

**Explosive Movement** is the 2022 submenu where you turn **Rocket Jumping** and **Plasma Wall Climbing** on or off. Open **Options → Brutality 2022 Additions** and scroll to the **Explosive Movement** section (same screen as **Instant Weapon Switch**, damage numbers, tactical weapon motion, PBX HUD, kill streaks, etc.). Both options are **On/Off** toggles:

| Menu label | CVar | Role |
| --- | --- | --- |
| **Rocket Jumping** | `pb_rocketjump` | Player rocket explosions launch you from floors/walls/ceilings without self-splash when **On**; vanilla-style self-splash when **Off**. |
| **Plasma Wall Climbing** | `pb_plasma_wallclimb` | Plasma-ball impacts can thrust you along the same idea; **Off** restores small self-damage on those hits. |

Rocket Launcher explosions and supported plasma-ball impacts can drive **movement tech**, not only damage:

- Player rockets use **`PB_PlayerRocketExplosion`** (radius thrust + **`PBBlastMomentum`**) instead of tying **`pb_rocketjump`** to generic **`RocketExplosion`** used by monsters and barrels.
- When **Rocket Jumping** is **On**, your own explosion splash does **not** self-damage; when **Off**, you take normal self-splash (`XF_HURTSOURCE`). **Plasma Wall Climbing** follows the same philosophy on its weapon paths (**On** = thrust tech without self-splash on that branch; **Off** = self-splash returns).

You do **not** need to jump first for thrust — sprinting and shooting **behind you** (floor/wall) still pushes you forward. **`PBBlastMomentum`** (short-lived inventory stack, ticks down in `PlayerPawn`) keeps knockback from being erased by caps/friction: it relaxes **air** horizontal limits, **softens ground friction**, and enables **`ApplyWallBlastEscape`** wall nudges when momentum is active.

**Note:** Balance and feel are highly option-driven. Spend a few minutes in the Project Brutality menus before changing difficulty expectations — movement, recoil, spawns, rewards, and visual intensity are all user-configurable.

## Settings and controls

- **Options → Brutality 2022 Additions** — Merged 2022 systems: finishers/taunts, **Brutal Doom 22 gore** (`bdv22_*` plus **`bpv10_*` Brutal Pack V10** on one screen), UI (damage numbers, tactical weapon motion, PBX HUD, kill streaks), **Instant Weapon Switch**, and **Explosive Movement** (**`pb_rocketjump`**, **`pb_plasma_wallclimb`** — see **Explosive Movement** below).  
- **Options → Project Brutality Settings** — Main `pb_*` cvars, rendering, blood, recoil, feature toggles, and submenus such as **Gore/Debris** (with a link to that **BDv22 + BPv10** gore screen).  
- **Options → Glory Kill Options** — Glory Kills: range, HUD, fuel HUD placement, and related settings.  
- **Options → Customize Controls** — **Project Brutality** and **Project Brutality - Interactions** sections, plus **Glory kill** for the Crucible (`+glorysaw`) and shoulder-cannon actions.
- **Options → Brutality 2022 Additions → Explosive Movement** — Same submenu title as in-game (**Explosive Movement**): **Rocket Jumping** (`pb_rocketjump`) and **Plasma Wall Climbing** (`pb_plasma_wallclimb`). Full behavior: section **Explosive Movement (rocket jump & plasma wall boost)** above.

**Useful cvars for testing or performance:**

- `pb_classicmonsters` — classic vs. Brutality-style monsters.  
- `pb_disablenewenemies`, `pb_disablenewguns`, `pb_disabledecorations`, `pb_disablemapenhancements` — turn major blocks on or off.  
- `pb_lowgraphicsmode`, `pb_bloodamount`, `zdoombrutalblood`, `zdoombrutaljanitor`, `zdoombrutaljanitorcasings` — lighter visuals and gore.  
- `bdv22_mist`, `bdv22_corpse_meat`, `bdv22_flying_meat`, `bdv22_organs`, `bdv22_gore_mix` — optional **Brutal Doom 22** gore.  
- `bpv10_enable` plus `bpv10_burn_corpse`, `bpv10_carbonized`, `bpv10_xdeath_torso`, `bpv10_flop_organs`, `bpv10_zgear`, `bpv10_blood_splat` — optional **Brutal Pack V10** gore (humanoids + imps; same menus as BDv22).  
- `pb_rocketjump`, `pb_plasma_wallclimb` — **Explosive Movement**: rocket-jump and plasma climb/boost toggles (**Options → Brutality 2022 Additions**, section **Explosive Movement**). Both default **On** in **`CVARINFO`**; set either **Off** for vanilla-style self-splash on that weapon path.

## Feedback and bug reports

For problems with **this** project, use the [Project Brutality Discord](https://discord.gg/2hJxXPc). Please confirm the issue is reproducible with **only** this mod loaded (no extra weapon or gameplay packs) and that it has not already been reported. Read channel rules and pins first.

## Sources and important third-party lineage

This build layers several community sources into Project Brutality’s own systems. Full names and per-asset notes remain in **`CREDITS.txt`** and **`DetailedCredits.txt`**.

| Area | What we ship / how it is used |
| --- | --- |
| **Realm667** | Many monster and prop **bases and edits** (community resource site). Specific authors appear on actors, in `SNDINFO`, and in the detailed list (e.g. **Overlord**, **Ice Vile**-line content, and hundreds of one-off credits). |
| **Monster Pack line** | Extra **MP-style monsters and spawners** (e.g. Crackodemon, Hellduke, Helemental, Hierophant) folded into the main mod; see `SNDINFO.MonsterPack` and tier `actors/Monsters/`. |
| **Brutal Doom — *El Diablo* Edition** | **Extra first-person executions / finisher** art and pools (`eld_eld_*` and related paths under `SPRITES/MONSTERS/fatalitys/…`, e.g. zombieman, sarge, imp, caco, revenant, arch-vile, nobles, Hellduke). Wired through **Glory Kills** / `actors/Player/NEWPLAYE.dec`—not a standalone El Diablo TC. |
| **Project Brutality Legacy (lineage)** | **Execution routing** and third-person **“legacy”** handoff (`GoExecution`, `Death.ExeCution` / `Death.ExeCution1` / `SpecialFatality` style pivots) **folded** into core monster DECORATE so older-style triggers still work with current PB. |
| **Brutal Pack (e.g. V10 class packs)** | Used in development as a **selective art / finisher reference** when porting assets; **this repo does not ship the Brutal Pack in full**—only what was adapted into PB 2022’s class names and Glory Kill / weapon flows. |
| **Brutal Doom 22 (BDv22)** | **Optional** gore: separate `BDv22_*` actors, `SPRITES/BDv22/`, and event handlers. Toggle with **`bdv22_*`** under **Options → Brutality 2022 Additions → Brutal Doom 22 gore** (or via **Gore/Debris**). Credit **Brutal Doom 22** as a project—observe its license if you redistribute those lumps. |
| **Brutal Pack V10 (BPv10) gore** | **Optional** fold-on add-on (`BPv10_*` actors, `actors/Gore/BPv10Gore/`, `SPRITES/GORE/`). **`bpv10_*`** toggles on the **same** menu as BDv22 (subsection labeled Brutal Pack V10). Sprites credited to **AWEZ** in menu strings—observe Brutal Pack licensing if you redistribute. |

## Credits

Project Brutality 2022 builds on [Project Brutality](https://github.com/pa1nki113r/Project_Brutality) and the work of that team and their contributors. It also includes Glory Kills and Monster Pack-line content, third-party systems such as **Nash Gore** (Nash Muhandes, modified here), and many named authors in **`CREDITS.txt`** and **`DetailedCredits.txt`**.

**Recent additions in this line:** optional **Brutal Doom 22 (BDv22)** gore and mix (`bdv22_*` cvars, `actors/Gore/BDv22Gore/`, `zscript/Gore/BDv22Gore*.zc`, `SPRITES/BDv22/`); optional **Brutal Pack V10** gore (`bpv10_*`, `actors/Gore/BPv10Gore/`, `SPRITES/GORE/`); **first-person and expanded executions** with art lineage from the **Brutal Doom *El Diablo* Edition** family and related packs (under `SPRITES/MONSTERS/fatalitys/eld_eld_*` and similar); **Realm667**-sourced and **Realm667-style** community monsters and props (see in-file and **DetailedCredits**); **Project Brutality Legacy**-style **execution / stagger handoff** behavior merged into the main actor set; and **Brutal Pack**-sourced *fragments* only where they were reauthored for PB 2022 (not the pack as a whole). See the table in **Sources and important third-party lineage** above.

Credit to BeefRice for PBX HUD elements and many weapon improvements and systems.

**Maintainers of this package:** RENEGADE ANDROID and doc.
