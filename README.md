# Project Brutality 2022 Enhanced

Project Brutality 2022 Enhanced is a full gameplay and content overhaul for *Doom* and *Doom II*, built for [UZDoom](https://github.com/UZDoom/UZDoom). It centers on a dedicated player class, deep weapon and monster variety, Brutality-style combat, and a wide set of menu options so you can tune intensity, spawns, and presentation.

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

**Glory Kills and finishers** are a major part of the fantasy: when enemies are weak enough, you can **stagger** them and rip into **cinematic kills**—in **first AND third person**, with different animations for a **wide** swath of the roster (vanilla-style demons, Brutality variants, and a lot of **extra / Monster Pack** cast). Layered on top are the **Crucible**, **Blood Punch**, **shoulder cannon** burn and freeze shots, **pinata**-style rewards, and a **Glory HUD** so you can see fuel, punch charges, and launcher cooldowns. Turn the system on or off and open the main tuning from **Options → PB 2022 Enhanced**; use **Glorykill Options** for HUD, range, and finer behavior.

- **Player and systems:** The **PB_Doomer** player class, movement (dash, slide, ledge grab), **Explosive Movement** (rocket jump & plasma climb — **PB 2022 Enhanced → Explosive Movement**), tactical weapon feel, layered gore, and HUD / PDA / weapon-special wheel flows.
- **Combat depth:** Brutality-style damage and reactions, plus the weapon and monster variety below—all adjustable from **PB 2022 Enhanced** and related submenus.
- **Content breadth:** Large weapon roster, extra monsters, kill streaks, power-up hooks, and announcer support.
- **Configuration:** Use **Options → PB 2022 Enhanced** (same screen is **PB 2022 Enhanced** on the main menu, bound to **P** when available). That hub groups **Gameplay Settings**, **Weapon Settings**, **Global Settings**, **Visual Settings**, finisher/Glory Kill toggles, **Explosive Movement**, UI/feel (damage numbers, tactical motion, PBX HUD, kill streaks), and **Content Packs**. Deeper monster/spawn work also lives under **Global Settings** and **Monster Pack Settings**.
- **Gore and debris:** Core Project Brutality gore plus **Nash Gore**. **2022 Enhanced Brootality** is the one-switch folded gore mix for BDv22 mist/meat/organs, BPv10 death extras, and extra death pools/trails.
- **Shield Saw:** Standard equipment—you start every new game with it. Quick Melee throws the ricocheting saw at range (close targets still get normal melee), and **Recall Shield Saw** brings it back.

### Included weapons

Weapons are grouped by their in-game number slots from `actors/Player/PLAYER.dec`. Individual spawn toggles live in **Weapon Settings** / **Add-On Toggles** where available. Glory Kill tools such as the **Crucible**, shoulder cannon actions, Blood Punch, pinata pickups, and related HUD pieces are separate systems, not normal numbered-slot weapons.

**Slot 1 — Melee & blades**

- **Bare Hands** — fast close-range melee, kick, and execution starter used by the core PB melee flow.
- **Axe** — heavy melee pickup for chopping through low-tier enemies.
- **Chainsaw** — classic fuel-fed saw with PB gore and chainsaw-spawner variants.
- **UAC Nanotech Energy Beam Katana** — energy blade with quick melee integration and barrier-style behavior.
- **Argent Sith Beam Katana** — argent blade variant with its own energy attacks and shield/barrier handling.
- **Tiberium's Soulblade / Vorpal Blade** — exotic blade with charged/special attack behavior (sprites **Eriance**; sword lineage *Insanity's Requiem Mk.2* by **TiberiumSoul**; folded from **PB_MeleeWeaponPack** / **Renegade Android** rework — see **`CREDITS.txt`**).
- **Dragon Slayer** — heavy energy-melee / bolt-repeater-style attacks (**Craneo**; Hexen ModDB per upstream pack notes; same pack fold — **`CREDITS.txt`**).
- **Shield Saw** — not a separate weapon slot entry; granted on spawn like other starter gear. With the saw “charged,” Quick Melee throws it at range; **Recall Shield Saw** pulls it back. It no longer drops from the chainsaw map spawner and is not shown on the HUD inventory strip.

**Slot 2 — Sidearms & personal defense**

- **UAC .45 Pistol** — starter sidearm with weapon-special options for pistol behavior.
- **Revolver** — high-impact sidearm for heavier single shots.
- **Maschinenpistole 40** — compact automatic ballistic weapon.
- **UAC-17 SMG** — fast sidearm-class automatic with weapon-special handling.
- **Riot Shield** — defensive sidearm slot weapon built around shield blocking and close fighting.
- **Hell Pistoler** — demon sidearm with a special wheel for Hell Rounds, Shrink Beam, and rate-of-fire toggle behavior.
- **Desert Eagle .50** — heavy pistol for high-damage precision sidearm shots.

**Slot 3 — Shotguns**

- **Shotgun** — pump-action workhorse with shell management and shotgun special modes.
- **Auto-Shotgun** — faster shell-fed shotgun for sustained close-range fire.
- **Sawed-Off Shotgun** — classic double-barrel burst damage.
- **Commander Shotgun** — combat shotgun with its own ammo/mode logic.
- **UAC XHAS-SP Lady Golide** — heavy automatic shotgun platform.
- **X12 Shotgun** — special shotgun using the PBWP shell alias path.
- **Quad-Barrel Shotgun** — four-barrel burst weapon with special-wheel behavior.
- **Marauder Shotgun** — Marauder-style super shotgun variant.

**Slot 4 — Rifles, precision & support**

- **UAC-30 DMR** — marksman rifle with upgrade/dual-wield style support.
- **UAC-41 Carbine** — flexible rifle with special-wheel fire modes.
- **Chex Quest Assault Rifle** — optional Chex-themed rifle variant.
- **XM-21 Rifle** — sniper/marksman add-on fold with dedicated ammo handling.
- **Light Machine Gun** — belt/magazine support rifle for sustained automatic fire.
- **Metal Sniper** — heavy precision rifle with custom ammo and unload behavior.
- **UAC-320 Heavy Machine Gun** — older heavy automatic platform.
- **UAC M1893 Lever Action** — lever rifle with a weapon-special caliber swap.
- **Pro-Surv Ballista** — precision projectile weapon for heavy single shots.
- **M41A Pulse Rifle** — pulse rifle with weapon-special wheel: 12-gauge or 30mm underbarrel Alt-Fire, plus optional dual-wield.
- **Battle Rifle** — modern rifle with magazine handling and PB tactical weapon flow.

**Slot 5 — Heavy automatics**

- **Mach-3 Minigun** — sustained bullet hose with upgraded/triple-barrel style paths.
- **UAC-240 Perforator Nailgun** — nail-firing heavy automatic with its own firing-state handling.
- **MG-42** — high-rate classic machine gun.
- **Neo HMG** — heavy machine gun with an Alt-Fire shield that can detach into a temporary deployed energy barrier.

**Slot 6 — Launchers**

- **Super Grenade Launcher** — automatic grenade launcher with selectable grenade behavior.
- **Rocket Launcher** — rocket launcher wired into the Explosive Movement rocket-jump path.
- **Paingiver** — launcher-class heavy weapon for pain/area damage.
- **Excavator** — launcher/special weapon with mode-specific ammo behavior.
- **Mastermind's Chaingun** — boss-derived heavy chaingun.
- **Cyberdemon Missile Launcher** — cyberdemon-style missile launcher.

**Slot 7 — Plasma & energy rifles**

- **UAC-M1 Plasma Rifle** — plasma rifle with single/dual weapon-special support and plasma wall-climb behavior.
- **UAC-M2 Plasma Rifle** — alternate plasma rifle using the same movement-friendly plasma impact family.
- **UAC-Prototype Dark Matter Rifle / Pulse Cannon** — energy rifle with Gravity and Super mode selection.
- **Dual Pulse Cannons** — dual-wield pulse cannon loadout.

**Slot 8 — Special primaries**

- **Cryo Rifle** — freezing rifle for slowing or locking down enemies.
- **MKIII Railgun** — precision rail weapon for piercing high-damage shots.
- **UAC-UM-32P Biological Acid Launcher - Unengager** — caustic launcher for acid damage and area denial.
- **UAC Mancubus Flame Cannon / Daedabus Slime Cannon** — monster-tech cannon with flame/slime-style attacks.

**Slot 9 — Super-weapons**

- **Black Hole Generator** — singularity weapon for heavy crowd control.
- **Unmaker** — demonic super-weapon for high-end energy damage.
- **BFG9000 MK IV** — BFG-class room clearer.
- **BFG 11K Prototype / BFG Beam** — beam-style BFG super-weapon entry.
- **Demon Exterminator** — endgame demon-killing super-weapon.
- **Stormcast** — lightning / energy weapon from *Schism* lineage (**Dreo** & **Lord Lothar**; **PB_MeleeWeaponPack** / **Renegade Android** — **`CREDITS.txt`**).

**Slot 0 — Demon-tech pair**

- **UAC-M3 Flamethrower** — flame weapon for burn damage and crowd control.
- **Demon-Tech Rifle** — demon-energy rifle with charged energy behavior and shared demon-tech support actors.

Modders: `PLAYER.dec` is the source of truth for slotted weapons. The disabled **Demon-Tech Minigun** source remains on disk for possible future repair, but it is not part of the active player roster.

**`GRAPHICS/`** (committed **uppercase**, hundreds of PNGs: wheel icons, blood decals, dash overlay, Glory Kill NewHud art, etc.) must remain in your working copy. If the folder is missing, restore it from version control (e.g. **`git restore GRAPHICS`**). After editing **`SRC/GloryHUD.acs`** or other ACS sources, recompile with **`tools/compile_acs.ps1`** or **`tools/compile_gloryhud.cmd`** (set **`PB_ACC`** to **`acc.exe`** if needed).

### Equipment

- Freeze Nade  
- Hook  
- Void Grenade  
- Freezebot  
- ElecPod  

### Explosive Movement (rocket jump & plasma wall boost)

**Explosive Movement** is where you turn **Rocket Jumping** and **Plasma Wall Climbing** on or off. Open **Options → PB 2022 Enhanced** (or **PB 2022 Enhanced** from the title menu) and scroll to the **Explosive Movement** section. Both options are **On/Off** toggles:

| Menu label | CVar | Role |
| --- | --- | --- |
| **Rocket Jumping** | `pb_rocketjump` | Player rocket explosions launch you from floors/walls/ceilings without self-splash when **On**; vanilla-style self-splash when **Off**. |
| **Plasma Wall Climbing** | `pb_plasma_wallclimb` | Plasma-ball impacts (slot-6 plasma family **and** **Mastermind's Chaingun** tracers) can thrust you along the same idea; **Off** restores small self-damage on those hits, and the chaingun tracer applies a full **120 / 140** radius self-splash (**`XF_HURTSOURCE`**) before the usual explosion VFX. |

Rockets and certain plasma shots **and the Mastermind chaingun's explosive tracers** can double as **movement tools**, not just damage. With **Rocket Jumping** / **Plasma Wall Climbing** on, those player weapons skip harsh self-damage so you can blast-jump or scrape along surfaces without punishing yourself every time.

You do **not** need to jump first — firing behind you into floors or walls still shoves you forward. A brief **blast momentum** helper keeps that push from dying instantly to friction.

**Tip:** Most combat feel lives in **PB 2022 Enhanced** and its submenus (gameplay, weapons, global spawns, visuals/gore). Skim those before judging difficulty.

### 2022 Enhanced Brootality

**2022 Enhanced Brootality** is the single switch for the folded 2022 gore mix. It keeps the normal Project Brutality and Nash Gore stack in place, then layers in the extra BDv22, BPv10, and PB death-boost effects when `pb_enhanced_brutality_2022` is on.

Turn it on from **Options → PB 2022 Enhanced** (the **2022 Enhanced Brootality** row under *Finishers, Gore, Taunts*) when you want the full mixed presentation. Nash Gore and classic PB blood/gib options remain under **Visual Settings** → **Gore/Debris Settings** (see the on-screen hint in PB 2022 Enhanced).

- **BDv22 gore:** hit mist plus guts, flying meat, ribs, organs, and brain chunks.
- **BPv10 gore:** burned and carbonized bodies, flying torsos, flopping organs, zombie gear, and extra blood splats.
- **PB death boost:** extra blood sprites, pools, and short trails on monster deaths.
- **Simple setup:** one On/Off option instead of separate sliders and per-pack toggles.

The internal BDv22 blend is tuned to about **66.6%** so the BDv22 pieces are common but the base PB/Nash/BPv10 mix still shows through. Legacy `bdv22_*` and `bpv10_*` cvars remain declared for old configs and compatibility, but the player-facing control is **2022 Enhanced Brootality**.

### Shield Saw

**Shield Saw** is folded into Quick Melee rather than taking a weapon slot. You begin with the saw token on a **new game**; map-placed pickups (or `summon ShieldSaw_token`) still work if a mapper extras them.

- **Quick Melee** near enemies uses the usual close-range melee.
- **Quick Melee** at range throws the saw as a projectile.
- **Recall Shield Saw** (default **T**) calls it back through the **FastCall** inventory.
- Level transitions while the saw is still out refund the token via the map-enter script so it is not lost.

The vanilla **chainsaw** spawn point no longer rolls a Shield Saw drop—the saw is default kit, not spawner loot. There is no separate spawn-toggle menu entry.

## Settings and controls

- **Options → PB 2022 Enhanced** — Primary hub (title **PB 2022 Enhanced**). Contains shortcuts to **Gameplay Settings**, **Advanced Weapon Spawns**, **Weapon Settings**, **Global Settings**, **Visual Settings**, the **Finishers, Gore, Taunts** block (auto-fatality, **Glory Kill**, **2022 Enhanced Brootality**), **Explosive Movement**, **UI and Feel** (taunts, damage numbers, tactical weapon motion, PBX weapon HUD, kill streaks, instant weapon switch, optional arcade/mutator rows), and **Content Packs** (monster pack options, festive hats). The same entry appears on the **main menu** for quick access.
- **PB 2022 Enhanced → Glorykill Options** — Glory Kills: protection/fear, range, execution key mode, Crucible/Blood Punch behavior, fuel HUD layout, shoulder-cannon helpers, and related `be_*` / `sv_fuelhud_*` options.
- **PB 2022 Enhanced → Visual Settings** — Rendering, motion blur, Tilt++, weapon bob/sway, **Gore/Debris Settings**, voxel pack options, and other presentation toggles.
- **PB 2022 Enhanced → Global Settings** — Spawn presets, advanced monster/weapon spawn lists, monster abilities, add-on compatibility toggles.
- **Options → Customize Controls** — **Project Brutality** and **Project Brutality - Interactions** sections, plus **Glory kill** for the Crucible (`+glorysaw`) and shoulder-cannon actions.

### Experimental weapon executions (`pb_experimental`)

**`pb_experimental`** is a **server** boolean in **`CVARINFO`** (toggle from the console: `pb_experimental 0` / `pb_experimental 1`). It is **not** mirrored on an options row; treat it as a power-user / server flag.

When **on**, **Quick Melee** and **User2** branches on supported weapons can call **`PB_Execute()`**: if your aim target is a nearby, visible **`PB_Monster`** under about **20% max health** (or **below 65** HP), the weapon jumps into **`Execution_*`** states and spawns the first-person **`PB_*_Execution_*`** actor chains (plus the Monster Pack execution table in **`BaseWeapon_MPExecutionHelpers`** / **`BaseWeapon_MPExecutions`**). That path is **separate** from Glory Kill stagger / **`FatalityChecker`** token finishers in **`NEWPLAYE.dec`**—those still come from the Glory Kill death pools and inventory tokens.

When **off**, **`PB_Execute()`** no-ops and normal melee/punch flow continues.

**Useful cvars for testing or performance:**

- `pb_classicmonsters` — classic vs. Brutality-style monsters.  
- `pb_disablenewenemies`, `pb_disablenewguns`, `pb_disabledecorations`, `pb_disablemapenhancements` — turn major blocks on or off.  
- `pb_lowgraphicsmode`, `pb_bloodamount`, `zdoombrutalblood`, `zdoombrutaljanitor`, `zdoombrutaljanitorcasings` — lighter visuals and gore.  
- `pb_enhanced_brutality_2022` — one-switch full mix for the folded BDv22 / BPv10 / extra death-pool gore behavior (**PB 2022 Enhanced**). Legacy `bdv22_*` and `bpv10_*` cvars remain declared for old configs, but are no longer exposed as tuning options.
- `pb_experimental` — enables weapon-initiated **`PB_Execute`** finishers on wounded monsters (see **Experimental weapon executions** above). Default follows **`CVARINFO`** in your build.
- `pb_rocketjump`, `pb_plasma_wallclimb` — **Explosive Movement**: rocket-jump and plasma climb/boost toggles (**PB 2022 Enhanced**, section **Explosive Movement**). Both default **On** in **`CVARINFO`**; set either **Off** for vanilla-style self-splash on that weapon path.

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
| **Brutal Doom 22 (BDv22)** | Folded gore: separate `BDv22_*` actors, `SPRITES/BDv22/`, and event handlers. Enabled by **`pb_enhanced_brutality_2022`**. Credit **Brutal Doom 22** as a project; observe its license if you redistribute those lumps. |
| **Brutal Pack V10 (BPv10) gore** | Folded gore add-on (`BPv10_*` actors, `actors/Gore/BPv10Gore/`, `SPRITES/GORE/`). Enabled by **`pb_enhanced_brutality_2022`**. Sprites credited to **AWEZ**; observe Brutal Pack licensing if you redistribute. |

## Credits

Project Brutality 2022 builds on [Project Brutality](https://github.com/pa1nki113r/Project_Brutality) and the work of that team and their contributors. It also includes Glory Kills and Monster Pack-line content, third-party systems such as **Nash Gore** (Nash Muhandes, modified here), and many named authors in **`CREDITS.txt`** and **`DetailedCredits.txt`**.

**Recent additions in this line:** **2022 Enhanced Brootality** folded **Brutal Doom 22 (BDv22)** gore (`actors/Gore/BDv22Gore/`, `zscript/Gore/BDv22Gore*.zc`, `SPRITES/BDv22/`) and **Brutal Pack V10** gore (`actors/Gore/BPv10Gore/`, `SPRITES/GORE/`) behind `pb_enhanced_brutality_2022`; **first-person and expanded executions** with art lineage from the **Brutal Doom *El Diablo* Edition** family and related packs (under `SPRITES/MONSTERS/fatalitys/eld_eld_*` and similar); **Glory Kill equipment launcher** first-person sprites (**`SPRITES/ShoulderCannon/`**) and **Eternal fuel-HUD** glyphs aligned with the **PB_Staging** Glory Kills line; **Explosive Movement** extended to **Mastermind's Chaingun** tracers (`pb_plasma_wallclimb`); **Realm667**-sourced and **Realm667-style** community monsters and props (see in-file and **DetailedCredits**); **Project Brutality Legacy**-style **execution / stagger handoff** behavior merged into the main actor set; and **Brutal Pack**-sourced *fragments* only where they were reauthored for PB 2022 (not the pack as a whole). See the table in **Sources and important third-party lineage** above.

Credit to **BeefRice** and **Jaih1r0** for PBX HUD elements and many weapon improvements and systems. Thanks to **HUNG** for the **Shield Saw** (**GK_ShieldSaw**) behavior folded into this build (quick melee + recall).

**PB_MeleeWeaponPack** (folded slot-1 **Dragon Slayer** & **Vorpal Blade**, slot-9 **Stormcast**): original credits per that add-on’s `CREDITS.txt` — **Craneo**, **Dreo** & **Lord Lothar** (*Schism*), **Eriance** & **TiberiumSoul** (RIP); compatibility rework for PB 0.4.2+ by **Renegade Android**. Details: **`CREDITS.txt`**.

**Maintainers of this package:** RENEGADE ANDROID and doc.
