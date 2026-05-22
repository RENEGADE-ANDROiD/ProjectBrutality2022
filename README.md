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

- **Player and systems:** The **PB_Doomer** player class, movement (dash, slide, ledge grab), **Explosive Movement** (rocket jump & plasma climb — **Options → Brutality 2022 Additions → Explosive Movement**), tactical weapon feel, gore, executions, and HUD / PDA / wheel flows.
- **Combat depth:** Brutality-style damage, layered gore, and Glory Kills with their own menu.
- **Content breadth:** A large weapon roster, extra monsters, kill streaks, power-up hooks, and announcer support — most knobs live under Project Brutality menus.
- **Configuration:** Tune almost everything under **Options → Project Brutality Settings**, **Options → Brutality 2022 Additions**, **Options → Weapon Settings**, and **Options → Glory Kill Options**.
- **Gore and debris:** Core Project Brutality gore plus **Nash Gore**. Two **optional** stacks share one menu (**Brutality 2022 Additions → Brutal Doom 22 gore**, also under **Visual → Gore/Debris**):
  - **Brutal Doom 22** — extra mist, guts, organs, and a mix slider vs. core PB gore.
  - **Brutal Pack V10** — optional corpse and splat extras from Brutal Pack–style sprites (humanoids & imps); off by default. More detail and credits in **Credits**.

### Weapon roster

Big lineup by weapon slot — turn individual spawns on or off in **Weapon Settings** / **Add-On Toggles** where it applies. Glory Kill tools (**Crucible**, shoulder cannon, related pickups) use separate options, not these numbered slots.

**Slot 1 — Melee & heavy tools**

- **Fists / Melee**  
- **Axe**  
- **Chainsaw**  

**Slot 2 — Sidearms**

- **Pistol**  
- **Revolver**  
- **MP40**  
- **SMG**  
- **Riot Shield**  
- **Desert Eagle**  

**Slot 3 — Shotguns**

- **Pump Shotgun**  
- **Auto Shotgun**  
- **Super Shotgun**  
- **Combat Shotgun**  
- **X12 Shotgun**  
- **Quad-Barrel Shotgun**  
- **Marauder Super Shotgun**  

**Slot 4 — Rifles & precision**

- **DMR / Marksman Rifle** (dual wield & HDMR-style upgrades when unlocked)  
- **Carbine**  
- **LMG**  
- **Metal Sniper**  
- **Lever-Action Rifle**  
- **Pro-Surv Ballista**  
- **Battle Rifle**  

**Slot 5 — Heavy automatics**

- **Minigun** (includes triple-barrel upgrade paths — optional spawn toggles in menus)  
- **Nailgun**  
- **MG42**  

**Slot 6 — Launchers**

- **Super Grenade Launcher**  
- **Rocket Launcher**  
- **Paingiver**  
- **Excavator**  
- **Mastermind Chaingun**  
- **Cyberdemon Rocket Launcher**  

**Slot 7 — Energy rifles**

- **M1 Plasma Rifle**  
- **M2 Plasma Rifle**  

**Slot 8 — Special primaries**

- **Freezer Rifle**  
- **Railgun**  
- **Mancubus Flame Cannon**  

**Slot 9 — Super-weapons**

- **Blackhole Generator**  
- **Unmaker**  
- **BFG 9000**  
- **BFG Mk IV Beam**  
- **Demon Exterminator**  

**Slot 0 — Demon Tech pair**

- **Flamethrower**  
- **Hell Rifle**  

Modders: exact actor lists live in **`PLAYER.dec`** `WeaponSlot` blocks; Glory Kill–adjacent actors are described in **`AGENTS.md`**.

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

Rockets and certain plasma shots can double as **movement tools**, not just damage. With **Rocket Jumping** / **Plasma Wall Climbing** on, those player weapons skip harsh self-damage so you can blast-jump or scrape along surfaces without punishing yourself every time.

You do **not** need to jump first — firing behind you into floors or walls still shoves you forward. A brief **blast momentum** helper keeps that push from dying instantly to friction.

**Tip:** Most combat feel lives in the menus (movement, recoil, spawns, visuals). Skim **Project Brutality Settings** before judging difficulty.

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
