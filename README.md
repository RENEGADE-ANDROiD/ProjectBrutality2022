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

- **Player and systems:** The `PB_Doomer` player class, movement (dash, slide, ledge grab, and related options), tactical weapon feel, gore, executions, and integrated HUD / PDA / wheel flows.
- **Combat depth:** Brutality-style damage, gore layers, and Glory Kill content with its own options menu.
- **Content breadth:** A large weapon roster, extra monsters, kill streaks and power-up reward hooks, and announcer support, all tied into Project Brutality cvars and menus.
- **Configuration:** Most systems can be toggled or tuned under **Options → Project Brutality Settings**, **Options → 2022 Additions**, **Options → Weapon Settings**, and **Options → Glory Kill Options**.
- **Gore and debris:** In addition to Project Brutality’s gore and **Nash Gore** integration, you can turn on optional **Brutal Doom 22**–sourced add-ons (hit mist, corpse guts, flying meat, organs, and a **PB/BDv22 gore mix** slider) from **Options → Brutality 2022 Additions → Brutal Doom 22 gore** (the same options also appear as a link under **Project Brutality Settings → Visual → Gore/Debris**). Those assets live under `actors/Gore/BDv22Gore/`, `zscript/Gore/`, and `SPRITES/BDv22/`; see **Credits** below. Respect upstream licensing if you redistribute.

### Weapon roster (spawn and options)

- Revolver  
- Submachine Gun  
- Autoshotgun  
- Combat Shotgun  
- Carbine  
- Nailgun  
- Excavator Launcher  
- Super Grenade Launcher  
- M2 Plasma Rifle  
- Freezer Rifle  
- Rail Gun  
- BFG 11K Beam  
- Blackhole Generator  
- Lever Action  
- Paingiver  
- Shotgun  
- CSSG
- Rocket Launcher  
- Plasma Rifle  
- BFG 9000  
- Chainsaw  
- Flamethrower  
- Minigun  
- LMG  
- HDMR Upgrade  
- Minigun Upgrade  
- Metal Sniper  
- XM-21 Sniper  
- Old HMG  
- NeoHMG  
- M41A  
- Battle Rifle  
- Pro-Surv Ballista  
- Pulse Cannon  
- Demon Exterminator  
- MG42  
- Mastermind Chaingun  
- ShieldSaw  
- Hell Pistoler  
- Bio Acid Launcher  
- Mancubus Flame Cannon  
- Demon Tech Minigun  
- Argent Sith  
- Beam Katana  
- Razorjack  
- Legacy of Rust Calamity Blade

### Equipment

- Freeze Nade  
- Hook  
- Void Grenade  
- Freezebot  
- ElecPod  

### Rocket jump & plasma wall boost

Rocket Launcher explosions and plasma-ball impacts can be used for **movement tech**, not only damage:

- **Options → Brutality 2022 Additions → Explosive Movement**
  - **Rocket Jumping** (`pb_rocketjump`) — Player rockets (`PB_Rocket` line) use a dedicated explosion actor (`PB_PlayerRocketExplosion`) with **`A_RadiusThrust`** rocket-jump push. When **On**, your own explosion splash does **not** self-damage; when **Off**, you take normal self-splash again (`XF_HURTSOURCE` on that path). Other actors still use the generic **`RocketExplosion`** so monster/boss rockets are not tied to your menu toggle.
  - **Plasma Wall Climbing** (`pb_plasma_wallclimb`) — Supported plasma weapons split climb vs non-climb death states; when **On**, impacts apply thrust without self-splash on the tech path; when **Off**, small self-splash returns so careless shots hurt.

You do **not** need to jump first for these to apply thrust — sprinting and shooting **behind you** (floor/wall) still pushes you forward. To avoid movement code **clamping** sprint speed after a blast, the player briefly gains **`PBBlastMomentum`** (inventory stack, consumed over tics in `PlayerPawn`): it relaxes **air** horizontal caps, **softens ground friction**, and allows **`ApplyWallBlastEscape`** wall‑scrape nudges while grounded when momentum is active.

**Note:** Balance and feel are highly option-driven. Spend a few minutes in the Project Brutality menus before changing difficulty expectations — movement, recoil, spawns, rewards, and visual intensity are all user-configurable.

## Settings and controls

- **Options → Brutality 2022 Additions** — Merged 2022 systems, including **Brutal Doom 22 gore** (`bdv22_*`).  
- **Options → Project Brutality Settings** — Main `pb_*` cvars, rendering, blood, recoil, feature toggles, and submenus such as **Gore/Debris** (with a link to the same **Brutal Doom 22 gore** screen).  
- **Options → Glory Kill Options** — Glory Kills: range, HUD, fuel HUD placement, and related settings.  
- **Options → Customize Controls** — **Project Brutality** and **Project Brutality - Interactions** sections, plus **Glory kill** for the Crucible (`+glorysaw`) and shoulder-cannon actions.
- **Options → Brutality 2022 Additions → Explosive Movement** — **`pb_rocketjump`** (Rocket Jumping) and **`pb_plasma_wallclimb`** (Plasma Wall Climbing); see **Rocket jump & plasma wall boost** above.

**Useful cvars for testing or performance:**

- `pb_classicmonsters` — classic vs. Brutality-style monsters.  
- `pb_disablenewenemies`, `pb_disablenewguns`, `pb_disabledecorations`, `pb_disablemapenhancements` — turn major blocks on or off.  
- `pb_lowgraphicsmode`, `pb_bloodamount`, `zdoombrutalblood`, `zdoombrutaljanitor`, `zdoombrutaljanitorcasings` — lighter visuals and gore.  
- `bdv22_mist`, `bdv22_corpse_meat`, `bdv22_flying_meat`, `bdv22_organs`, `bdv22_gore_mix` — optional **Brutal Doom 22** gore (menus: **Brutality 2022 Additions** or **Gore/Debris**).  
- `pb_rocketjump`, `pb_plasma_wallclimb` — rocket/plasma movement tech toggles (**Brutality 2022 Additions → Explosive Movement**).

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
| **Brutal Doom 22 (BDv22)** | **Optional** gore: separate `BDv22_*` actors, `SPRITES/BDv22/`, and event handlers. Toggle with **`bdv22_*`** under **Options → Brutality 2022 Additions** (or via the link in **Gore/Debris**). Credit **Brutal Doom 22** as a project—observe its license if you redistribute those lumps. |

## Credits

Project Brutality 2022 builds on [Project Brutality](https://github.com/pa1nki113r/Project_Brutality) and the work of that team and their contributors. It also includes Glory Kills and Monster Pack-line content, third-party systems such as **Nash Gore** (Nash Muhandes, modified here), and many named authors in **`CREDITS.txt`** and **`DetailedCredits.txt`**.

**Recent additions in this line:** optional **Brutal Doom 22 (BDv22)** gore and mix (`bdv22_*` cvars, `actors/Gore/BDv22Gore/`, `zscript/Gore/BDv22Gore*.zc`, `SPRITES/BDv22/`); **first-person and expanded executions** with art lineage from the **Brutal Doom *El Diablo* Edition** family and related packs (under `SPRITES/MONSTERS/fatalitys/eld_eld_*` and similar); **Realm667**-sourced and **Realm667-style** community monsters and props (see in-file and **DetailedCredits**); **Project Brutality Legacy**-style **execution / stagger handoff** behavior merged into the main actor set; and **Brutal Pack**-sourced *fragments* only where they were reauthored for PB 2022 (not the pack as a whole). See the table in **Sources and important third-party lineage** above.

Credit to BeefRice for PBX HUD elements and many weapon improvements and systems.

**Maintainers of this package:** RENEGADE ANDROID and doc.
