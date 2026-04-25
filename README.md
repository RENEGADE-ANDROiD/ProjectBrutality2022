# Project Brutality 2022

Project Brutality 2022 is a standalone spin-off of the long-running [Project Brutality](https://github.com/pa1nki113r/Project_Brutality) mod for *Doom* and *Doom II*. It is a large gameplay and content overhaul built for [UZDoom](https://github.com/UZDoom/UZDoom), rebuilt around the 2022-era feature set with the old **Glory Kills** and **Monster Pack** add-ons folded directly into the main mod so there is nothing extra to load on top.

If you want the latest bleeding-edge mainline mod, head upstream to [pa1nki113r/Project_Brutality](https://github.com/pa1nki113r/Project_Brutality). If you want this specific, self-contained 2022 snapshot with the integrated add-ons, you are in the right place.

> **Note on engine choice.** This release targets **UZDoom**, the actively maintained modern fork of GZDoom. Old GZDoom builds are considered outdated for this mod and are **not** supported — please install UZDoom instead.

## Requirements

- **[UZDoom](https://github.com/UZDoom/UZDoom) 4.13 or newer.** Development currently tracks the [UZDoom 4.14.3](https://github.com/UZDoom/UZDoom/tree/4.14.3) line. Grab a release build from the UZDoom [Releases page](https://github.com/UZDoom/UZDoom/releases). Stock/outdated GZDoom, Zandronum, and similar forks are not supported — the mod relies on ZScript and other UZDoom features that older ports do not implement correctly.
- **An IWAD** — `doom.wad`, `doom2.wad`, `tnt.wad`, `plutonia.wad`, or [Freedoom Phase 1+2](https://freedoom.github.io/download.html). Retail IWADs are available from the [Steam classics bundle](https://store.steampowered.com/sub/18397/) or GOG ([Doom II + Final Doom](https://www.gog.com/game/doom_ii_final_doom), [The Ultimate Doom](https://www.gog.com/game/the_ultimate_doom)).
- **Mobile (Android / iOS) is not supported.** There is no known current UZDoom port for either platform that covers the feature set this mod depends on.

## Installation

1. Install **UZDoom 4.13+** from the [UZDoom releases](https://github.com/UZDoom/UZDoom/releases). Unpack it somewhere you can find it.
2. Click the green **Code** button at the top of this repository page and choose **Download ZIP** (or clone the repo).
3. Unpack the archive. You should end up with a folder named `Project Brutality 2022` that contains `gameinfo.txt`, `ZSCRIPT.zc`, `DECORATE`, and many others.
4. Launch UZDoom with the folder as a file argument. The folder is loaded directly — the mod is **not** a packed PK3.

```
uzdoom.exe -iwad doom2.wad -file "Project Brutality 2022"
```

You can also drag the `Project Brutality 2022` folder straight onto `uzdoom.exe`, or add it as a file in a front-end launcher such as [ZDL](https://github.com/lcferrum/qzdl/releases), [DoomRunner](https://github.com/Youda008/DoomRunner/releases), or [SSGL](https://github.com/FreaKzero/ssgl-doom-launcher/releases) — point the launcher's engine path at your UZDoom executable rather than a GZDoom binary.

## What's inside

- **A dedicated player class — `PB_Doomer`.** Random player class is disabled; you always play as the PB Doomer.
- **Extended movement kit.** Dashing, sliding, ledge-grab, grappling hook support, optional Tilt++ screen lean, a speedometer, a wall-slide system and a selectable movement-modes set.
- **Weapon and equipment wheel menus** for fast switching without cycling through the full slot.
- **An in-game PDA** for browsing weapon and monster info.
- **Brutality-style combat** — kicks, executions, meat-shields (grabbing an enemy to use as a human shield), gory finishers, headshots and limb-specific hitboxes, plus sticky and underwater blood variants via the Nash Muhandes gore system.
- **Glory Kills system (integrated).** Stagger, finish and farm low-health enemies. Ships with the Crucible melee weapon, the shoulder-cannon alt-fire, cryo grenades, floor-ice effects, and the full pinata loot chain. Its own submenu of cvars for range, hud style and other knobs lives under **Options → Glory Kill Options**.
- **Monster Pack (integrated).** Crackodemon, Hellduke, Hellsmith, Director, Horrorspawn, Hunger, Aracnorb Queen, Helemental, Hierophant, Ethereal Soul, Zombie Tank / Plasma / Missile / Elite variants, Zombie Flyer, and more, all slotted into the normal spawn tables.
- **Optional motion blur** on sprites for a cinematic feel.
- **Title-screen map**, custom HUD, and a full set of localized menu and pickup strings.
- **Chex Quest compatibility shard** for the brave.

> Motion blur on sprites is an artistic choice, not laziness. It stays.

## Settings and controls

All settings live in the main UZDoom Options menu:

- **Options → Project Brutality Settings** — the master submenu with the bulk of `pb_*` cvars, including rendering, blood amount, recoil scale and feature toggles.
- **Options → Glory Kill Options** — the integrated Glory Kills controls (execution range, HUD size, back style, fuel-HUD placement, etc.).
- **Options → Customize Controls** — look for the **Project Brutality** and **Project Brutality - Interactions** key sections for the extra actions, plus a dedicated **Glory kill** section for the Crucible (`+glorysaw`) and shoulder-cannon bindings.

Useful cvars if you want to tweak or bisect behavior:

- `pb_classicmonsters` — switch between Brutality-style and classic monster rosters.
- `pb_disablenewenemies`, `pb_disablenewguns`, `pb_disabledecorations`, `pb_disablemapenhancements` — gate large feature blocks on or off.
- `pb_lowgraphicsmode`, `pb_bloodamount`, `zdoombrutalblood`, `zdoombrutaljanitor`, `zdoombrutaljanitorcasings` — performance and gore-density knobs.

## Feedback and bug reporting

For bugs specific to **this** build, please surface issues on the [Project Brutality Discord server](https://discord.gg/2hJxXPc). Please make sure:

- The bug is with Project Brutality 2022 itself, not a third-party add-on you are loading alongside it.
- The issue has not already been reported.

Check the rules, FAQ, and channel pins first.

## Credits

Project Brutality 2022 is a redistribution/derivative of [pa1nki113r/Project_Brutality](https://github.com/pa1nki113r/Project_Brutality) with the Glory Kills and Monster Pack add-ons merged in. All of the underlying weapon, monster, HUD, PDA, wheel, movement, execution, and gore systems come from the Project Brutality dev team and its contributors. Please refer to the upstream repository and to `DetailedCredits.txt` in this folder for the full contributor list.

The Nash Gore system used for the persistent gore is by Nash Muhandes, modified here for Project Brutality.

This package is maintained by **RENEGADE ANDROID** and **doc**.
