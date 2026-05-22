# Project Brutality 2022 Enhanced

Project Brutality 2022 Enhanced is a full gameplay and content overhaul for *Doom* and *Doom II*, built for [UZDoom](https://github.com/UZDoom/UZDoom). Glory Kills, Project Survival Fodder/Passives, Monster Pack–style enemies and weapons, Cat's Frozen content, and the main roster are all **included** in this package—load **only** this folder with UZDoom; no extra companion files are required.

For the latest upstream mainline mod, see [pa1nki113r/Project_Brutality](https://github.com/pa1nki113r/Project_Brutality). This repository is the Project Brutality 2022 snapshot maintained here.

> **Engine:** This release targets **UZDoom**, the actively maintained fork in the GZDoom family. Please use a current UZDoom build (see Requirements). Older or unrelated source ports are not supported.

## Requirements

- **[UZDoom](https://github.com/UZDoom/UZDoom) 4.13 or newer.** Development tracks the [UZDoom 4.14.3](https://github.com/UZDoom/UZDoom/tree/4.14.3) line. Install a release from the [Releases](https://github.com/UZDoom/UZDoom/releases) page. The mod needs modern UZDoom features.
- **An IWAD** — `doom.wad`, `doom2.wad`, `tnt.wad`, `plutonia.wad`, or [Freedoom Phase 1+2](https://freedoom.github.io/download.html). Retail IWADs are available from the [Steam classics bundle](https://store.steampowered.com/sub/18397/) or GOG ([Doom II + Final Doom](https://www.gog.com/game/doom_ii_final_doom), [The Ultimate Doom](https://www.gog.com/game/the_ultimate_doom)).
- **Mobile (Android / iOS) is not supported.** There is no supported UZDoom build on those platforms with the feature set this mod needs.

## Installation

1. Install **UZDoom 4.13+** from the [UZDoom releases](https://github.com/UZDoom/UZDoom/releases) and unpack it somewhere convenient.
2. Download this repository (**Code → Download ZIP**) or clone it.
3. You should have a folder (for example `Project Brutality 2022`) that contains `gameinfo.txt` and the rest of the mod data. The mod ships as a **loose folder**, not a single packaged file.
4. Launch with that folder on the command line:

```
uzdoom.exe -iwad doom2.wad -file "Project Brutality 2022"
```

You can also drag the folder onto `uzdoom.exe` or add it in a launcher such as [ZDL](https://github.com/lcferrum/qzdl/releases), [DoomRunner](https://github.com/Youda008/DoomRunner/releases), or [SSGL](https://github.com/FreaKzero/ssgl-doom-launcher/releases) — set the engine path to your UZDoom binary.

## What you get

**Glory Kills and finishers** are a major part of the fantasy: when enemies are weak enough, you can **stagger** them and rip into **cinematic kills**—in **first and third person**, with different animations across vanilla demons, Brutality variants, and many **extra / Monster Pack** enemies. Layered on top are the **Crucible**, **Blood Punch**, **shoulder cannon** burn and freeze shots, **pinata**-style rewards, and a **Glory HUD** for fuel, punch charges, and launcher cooldowns. Turn the system on or off and tune it from **Options → PB 2022 Enhanced**; use **Glorykill Options** for HUD, range, and finer behavior.

**Experimental weapon executions** add an optional second finisher path. When the demon you're aiming at is close and badly wounded, supported weapons can trigger their own first-person finishing animation through **Quick Melee** or **User2**—separate from the stagger / Glory Kill chain, and only on weapons that ship with one. Toggle it under **Options → PB 2022 Enhanced → Finishers, Gore, Taunts → Experimental weapon executions**.

- **Player and systems:** Movement (dash, slide, ledge grab), **Explosive Movement** (rocket jump and plasma climb — **PB 2022 Enhanced → Explosive Movement**), tactical weapon feel, layered gore, HUD, weapon-special wheel, and related flows.
- **In-game codex (PDA):** Press **BACKSLASH** (rebindable) to flip through **Weapons**, **Monsters**, and **Equipment**. Entries unlock as you pick up gear or kill enemies; progress persists across saves. Pick an entry for its dossier and a small looping preview. Time pauses while the codex is open. Optional plain-text layout: **PB 2022 Enhanced → UI and Feel**. The same submenu offers **PDA XP & reward spin (single-player)** (default **Off**): when **On**, kills grant XP, rank-ups award spendable reward points, and—with the usual **blocky** PDA home layout—a **Reward Spin** tile appears on the left; each spin costs **3** points and tries to grant a **weapon** you do not already carry **and** that is not already unlocked in your PDA weapon codex (the roll rerolls within the pool); if nothing qualifies, **points are refunded**. With the toggle **Off**, the codex is unchanged and **no** spin panel appears.
- **Achievements (single-player):** PB ships a built-in achievement system (based on **Vortex Universal Achievement System**, MIT). Goals track combat, bosses, Glory Kills, PDA codex progress, movement, secrets, multi-kill shots (explosives, railgun, BFG, snipers, plasma, equipment), and **Explosive Movement** feats (**rocket jump** / **plasma wall climb** when those options are on). Unlock toasts appear as you play; browse everything under **PB 2022 Enhanced → Achievement Settings → PB 2022 Achievements**, or bind **Achievement Menu** in **Customize Controls → PB 2022 Achievements**. Turn the feature off with **Achievements** in **PB 2022 Enhanced** (disabled in multiplayer). Do not load a separate Vortex achievement WAD on top of this folder.
- **Combat depth:** Brutality-style damage and reactions, plus the weapon and monster variety below—all adjustable from **PB 2022 Enhanced** and related submenus.
- **Content breadth:** Large weapon roster, extra monsters, kill streaks, power-up hooks, and announcer support.
- **Configuration:** Use **Options → PB 2022 Enhanced** (same screen from the main menu, bound to **P** when available). That hub groups **Gameplay Settings**, **Weapon Settings**, **Global Settings**, **Visual Settings**, the **Finishers, Gore, Taunts** block (including **Experimental weapon executions** and **Glory Kill**), **Explosive Movement**, **UI and Feel** (damage numbers, tactical motion, weapon HUD modes, PDA blocky layout, optional **PDA XP & reward spin** for single-player, kill streaks), and **Content Packs**. Deeper monster and spawn options also live under **Global Settings** and **Monster Pack Settings**.
- **Gore and debris:** Core Project Brutality gore plus **Nash Gore**. **2022 Enhanced Brootality** (Options → PB 2022 Enhanced → *Finishers, Gore, Taunts*) is the single On/Off switch that adds Brutal Doom 22 mist and meat, Brutal Pack V10 death extras, and extra blood pools and trails on top of the base mix — no per-pack sliders to fiddle with. **AccuDeath** (by **Airehnr66**) is also included: kills from fire, plasma, and electric attacks can tint corpses and add light particle death FX on top of the normal gore stack (on by default; turn off under **Options → Gore/Debris Settings → AccuDeath (corpse tints)**).
- **Shield Saw:** Standard equipment—you start every new game with it. Quick Melee throws the ricocheting saw at range (close targets still get normal melee), and **Recall Shield Saw** brings it back.

### Possession finishers

Some fatalities briefly turn you into the demon you just killed. The rides are short and invulnerable.

- **Cacodemon** — matching glory-kill finish puts you in its body: you float, fire cacodemon shots, then drop back when the timer ends.
- **Spider Mastermind** — you stay on its chassis: walk it around and spray the chaingun until the timer ends.
- **Cyberdemon** — after the cyber fatality you shoulder its rocket arm, launch cyber rockets, then dismount with a shock burst when time runs out or you alt-fire.
- **Mancubus family** — after a standard mancubus / Daedabus / Volcabus fatality you get dual flame cannons, alternating left/right fireballs until the timer ends or you alt-fire.
- **Arachnotron** — the right finish seats you on its plasma turret (third-person view) until the rig tears apart.
- **Revenant** — revenant fatalities can roll into a third-person rocket-backpack ride: homing rockets fire on a short cadence while the chase camera stays active; leaving the ride restores the normal view.

### Item pickups and armor variety

- Colored health and armor bonuses, stimpacks, and medikits use **DarkShadow**'s **Custom Shards & Potions** content. Optional **Red Armor** (60% protection, 250 points) can appear when the blue-armor spawner rolls a heavy pickup (**Gameplay Settings**). Soulsphere, megasphere, and premium armor extras still use the **Item mutators** toggle in the same menu.

### Included weapons

Weapons are grouped by their in-game number slots. Individual spawn toggles live in **Weapon Settings** / **Add-On Toggles** where available. Glory Kill tools such as the **Crucible**, shoulder cannon actions, Blood Punch, pinata pickups, and related HUD pieces are separate systems, not normal numbered-slot weapons.

**Slot 1 — Melee & blades**

- **Bare Hands** — fast close-range melee, kick, and execution starter.
- **Axe** — heavy melee pickup for chopping through low-tier enemies.
- **Chainsaw** — classic fuel-fed saw with Project Brutality gore and chainsaw-spawner variants.
- **UAC Nanotech Energy Beam Katana** — energy blade with quick melee integration and barrier-style behavior.
- **Argent Sith Beam Katana** — argent blade variant with its own energy attacks and shield/barrier handling.
- **Tiberium's Soulblade / Vorpal Blade** — exotic blade with charged and special attack behavior (*see CREDITS.txt for attribution*).
- **Dragon Slayer** — heavy energy-melee / bolt-repeater with empowered strikes and an Alt-Fire nail volley. Uses a hidden **wear** pool that drops with slashes and volleys; the blade **breaks** at zero wear and a duplicate pickup **refills wear**. Obtained only from **Obsidian Ravager** kills (cyber-tier spawns can roll the Ravager); it is **not** placed by chainsaw **map** weapon spawners (*see CREDITS.txt*).
- **Shield Saw** — not a separate weapon slot entry; granted on spawn like other starter gear. With the saw “charged,” Quick Melee throws it at range; **Recall Shield Saw** pulls it back. It no longer drops from the chainsaw map spawner and is not shown on the HUD inventory strip.

**Slot 2 — Sidearms & personal defense**

- **UAC .45 Pistol** — starter sidearm with weapon-special options for pistol behavior.
- **Revolver** — high-impact sidearm for heavier single shots.
- **Maschinenpistole 40** — compact automatic ballistic weapon.
- **UAC-17 SMG** — fast sidearm-class automatic with weapon-special handling.
- **UAC Ballistic Shield Module** — inventory upgrade (icon **`5L1DI0`**) from **riot-shield sergeants**; not a weapon-slot gun. With the module, open **Weapon Special** on the **.45 Pistol** or **Fire Axe** to toggle **ballistic shield + pistol** (block, bash, shielded reload) or **shield + axe** loadouts. Settings: **Weapon Settings → Ballistic Shield Module** (optional fire-axe requirement for the axe loadout).
- **Hell Pistoler** — demon sidearm with a special wheel for Hell Rounds, Shrink Beam, and rate-of-fire toggle behavior.
- **Desert Eagle .50** — heavy pistol for high-damage precision sidearm shots.

**Slot 3 — Shotguns**

- **Shotgun** — pump-action workhorse with shell management and shotgun special modes.
- **Auto-Shotgun** — faster shell-fed shotgun for sustained close-range fire.
- **Sawed-Off Shotgun** — classic double-barrel burst damage.
- **Commander Shotgun** — combat shotgun with its own ammo/mode logic.
- **UAC XHAS-SP Lady Golide** — heavy automatic shotgun platform.
- **X12 Shotgun** — special shotgun with Project Brutality shell handling.
- **Quad-Barrel Shotgun** — four-barrel burst weapon with special-wheel behavior.
- **Marauder Shotgun** — Marauder-style super shotgun variant; uses a hidden **wear** pool (not reserve shells) that drops by one per meaningful shot, **breaks** the weapon when empty, and **refills wear to max** if you pick up another copy while still holding a depleted one. **Marauders** sometimes leave one on death; scripted fatality floor spawns are only ~50% likely.
- **Cryo Auto Shotgun** — Cat's Frozen cryo shotgun; shell-fed cryo pellet burst that applies brief cryo slow per pellet (always rolls from shotgun spawners).

**Slot 4 — Rifles, precision & support**

- **UAC-30 DMR** — marksman rifle with upgrade/dual-wield style support.
- **UAC-41 Carbine** — flexible rifle with special-wheel fire modes.
- **Chex Quest Assault Rifle** — optional Chex-themed rifle variant.
- **XM-21 Rifle** — sniper/marksman add-on included with dedicated ammo handling.
- **Fusil Rifle** — compact automatic rifle with a 24-round internal magazine; **Alt-Fire** aims and **Weapon Special** swaps into its sidearm stance.
- **Light Machine Gun** — belt/magazine support rifle for sustained automatic fire.
- **Metal Sniper** — heavy precision rifle with custom ammo and unload behavior.
- **UAC-320 Heavy Machine Gun** — older heavy automatic platform.
- **UAC M1893 Lever Action** — lever rifle with a weapon-special wheel for **.357** vs **.444 Marlin** calibers. **Hell Mod** upgrades (T3/T4 map drops) unlock a third wheel option to toggle **hell rounds**—Demon-Tech projectiles on hip-fire and ADS; T4 fires caustic slugs. Disable Hell Mod drops under **Gameplay Settings** if you do not want them in the loot pool.
- **Pro-Surv Ballista** — precision projectile weapon for heavy single shots.
- **M41A Pulse Rifle** — pulse rifle with weapon-special wheel: 12-gauge or 30mm underbarrel Alt-Fire, plus optional dual-wield.
- **Battle Rifle** — modern rifle with magazine handling and tactical ready/fire flow.

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
- **Mastermind's Chaingun** — boss-derived heavy chaingun; **wear** drops once per dual-rocket salvo, weapon **breaks** at zero wear, duplicate pickup **refills wear**. Obtained from **spider mastermind** kills (chance-based drop), not from rocket-launcher **map** spawns.
- **Cyberdemon Missile Launcher** — cyberdemon-style missile launcher; **wear** per two-rocket burst, **break** + duplicate-pickup **refill** like the chaingun. **Baalgar / cyber boss** death tables and the **flying cyber-arm gib** can spawn it with a chance (respects **`pb_NoPB_CyberdemonRLWeapon`** on the gib path).

**Slot 7 — Energy rifles (non-plasma line)**

- **Cryo Rifle** — freezing rifle for slowing or locking down enemies.
- **MKIII Railgun** — precision rail weapon for piercing high-damage shots; **Alt-Fire** toggles the scope zoom when you are not scoped. **Hold Reload and press Alt-Fire** to deploy a holographic decoy (same behavior as the Cat's Frozen equipment holo: line-of-sight anchor, animated decoy, monster retargeting).
- **UAC-UM-32P Biological Acid Launcher (Unengager)** — primary fire spits sustained acid slugs for damage and area denial; **hold Alt-Fire** for a **Daedabus-style slime stream** (same liquid feel as the enemy arc, fired as your own stream projectiles). Uses **PB_DTech** cells. **Acquisition:** rare **death drops** from **Daedabus** and **Belphegor** only — it is **not** rolled from plasma-rifle **map** weapon spawns (there is no longer a menu toggle for map placement).
- **UAC Mancubus Flame Cannon / Daedabus Slime Cannon** — monster-tech cannon with flame/slime-style attacks; **wear** ticks down with fuel spends on primary, alt stream, and slime modes, **breaks** at zero, duplicate pickup **refills wear**. **Mancubus-family** enemies (including Daedabus / Volcabus and Glory-Kill wrappers) sometimes drop it; it is **not** rolled from plasma-rifle **map** spawns.

**Slot 8 — Plasma & heavy energy primaries**

- **UAC-M1 Plasma Rifle** — plasma rifle with single/dual weapon-special support and plasma wall-climb behavior.
- **UAC-M2 Plasma Rifle** — alternate plasma rifle using the same movement-friendly plasma impact family.
- **Cryo Electro Rifle** — Cat's Frozen cryo + electric rifle; **Weapon Special** switches **Cryo** mode (cryo orb, slowdown) and **Electric** mode (lightning shot reused from Stormcast). Uses cryo cell ammo with standard cell packs as reload feed. HUD ammo color shifts with the active mode. Always rolls from plasma spawners.
- **UAC Prototype Dark Matter Rifle** — magazine-fed plasma orbs; chargeable Alt-Fire (super plasma ball vs gravity singularity via Weapon Special), standard cell reserve plus internal magazine, plasma wall-climb on primary impacts; rolls from plasma spawners with an optional **Weapon Settings** toggle.

**Slot 9 — Super-weapons**

- **Black Hole Generator** — singularity weapon for heavy crowd control.
- **Unmaker** — demonic super-weapon for high-end energy damage.
- **BFG9000 MK IV** — BFG-class room clearer.
- **BFG 11K Prototype / BFG Beam** — beam-style BFG super-weapon entry.
- **Cryo Cannon** — Cat's Frozen cryo cannon; cone-shaped cryo wind burst using cryo cannon cells with standard cell packs as reload. Heavy burst pattern; slows and chips at clusters. Always rolls from BFG spawners.
- **Stormcast** — lightning staff (*Schism* lineage; *see CREDITS.txt*). Slot **9**, one shared charge pool; chords replace the old weapon-special wheel.
  - **Primary** — staff lightning / melee (needs charge; **Berserk** upgrades the strikes).
  - **Alt-Fire (hold)** — build charge; **release** to cast a bolt scaled to charge.
  - **Primary while holding Alt-Fire** — orb attacks (stronger orbs at higher charge).
  - **Use Equipment** while charging — **stunwall** (bigger at higher charge).
  - **Weapon Special** (hold) while charging — **Arc of Death** at higher tiers.
  - **Reload** (tap) while charging — lightning warper (caps show as on-screen messages).
  - **Alt-Fire in the air** — hover flight; **Alt-Fire** in that state fires a quick lightning burst.

**Slot 0 — Demon-tech pair**

- **UAC-M3 Flamethrower** — flame weapon for burn damage and crowd control.
- **Demon-Tech Rifle** — demon-energy rifle with charged energy behavior.

The disabled **Demon-Tech Minigun** and **Demon Exterminator** sources remain on disk for possible future repair, but they are not part of the active player roster.

### Equipment

- Freeze Nade
- Hook
- Molotov
- StunGrenade
- Void Grenade
- Freezebot
- ElecPod

**Cat's Frozen equipment additions** (always-on; no per-piece toggles). The **Project Brutality backpack** pickup also has a ~20% chance to grant a random Cat's Frozen equipment ammo charge.

- **Snow Caster** — handheld cone-burst that lays cryo wind + ice particles in front of the player.
- **Ice Wall** — generator that drops a temporary line of cryo barrier segments.
- **Holographic Decoy** — places a flickering decoy that pulls monster aggro.
- **Tesla Turret** — friendly chained-lightning turret (won't take damage from your shots).
- **Flame Turret** — friendly flame-cone turret (same rule).
- **Freeze Mines** — proximity cryo mines; they won't trip under your feet, but you can rocket-jump off them when shot or when monsters set them off.

### Shield Saw

**Shield Saw** is included with Quick Melee rather than taking a weapon slot. You begin with the saw on a **new game**; map-placed pickups still work if a mapper adds them.

- **Quick Melee** near enemies uses the usual close-range melee.
- **Quick Melee** at range throws the saw as a projectile.
- **Recall Shield Saw** (default **T**) calls it back.
- Level transitions while the saw is still out refund it so it is not lost.

The vanilla **chainsaw** spawn point no longer rolls a Shield Saw drop—the saw is default kit, not spawner loot. There is no separate spawn-toggle menu entry.

## Monster roster

This section is a reader's map of enemy tiers and families—not a spawn manifest. Maps still mostly place vanilla Doom edits; pack rolls layer extra variants on top. Higher tiers skew toward late maps, boss slots, and optional pools. When **PB 2022 Enhanced** menus mention **Monster Pack** rolls or **disable new enemies**, those same gates decide whether the extras below appear.

Glory Kills and cinematic finishes apply across these tiers—this list only names who shows up, not how those kills unlock.

### Tier 1 — Grunts & fodder

Low-tier pressure, hierarchy fodder, and most of the wandering cannon fodder you clear between arenas.

Passive hazards from the same packs can share floors with Tier 1 without being “troops”: pus pods, mimics, ceiling tentacles, hangman traps, and other Project Survival set‑dressing monsters still read as grunt‑tier threats because of how little space they need to ruin your day.

Those hazards are optional encounters—many maps never place them—but when they appear they still credit **Project Survival** authorship alongside the wandering fodder listed below.

- **Project Survival fodder — the standard fodder backbone of this build.** Shambler, Puker, Blighter, Screamer, Burster, Spiker, and Cyber Fodder *(CyberFodder)* are the **default Tier 1 reinforcement roster**, not an opt-in pool: every zombieman, shotgunner, chaingunner, imp, pinky, and spectre spawn rolls extra PS fodder alongside the classic enemy, and PS fodder ignores the broader *disable new enemies* switch because it is treated as core content. Distribution skews toward variety — Shambler ~20%, the other five each ~16% — so the supporting cast carries the visual identity of the fodder layer instead of one face dominating. **Trite** pods on floors or ceilings burst into throngs of small **Trite** critters *(Trite)* for swarm panic. (**Project Survival** by **The Pope of Dope / ThePopeOfDope** — see **`CREDITS.txt`**.)
- **Zombieman family** — pistol grunts, rifle grunts, carbine specialists, plasma zombies and their trooper-weight sibling, helmeted Phobos-style guards (pistol and rifle versions), and lab-coated scientists who still count as rank‑and‑file despite their animation set.
- **Shotgun sergeants** — classic shotgun guys plus helmeted variants, quad‑shot and auto‑shotgun heavies, **riot‑shield sergeants** (**`PB_RiotShieldGuy`** — always drop the ballistic shield module on death; see drop table below), rocket‑salvo zombies, demon‑tech shotgun troopers, and Z‑spec squads built on the same sergeant chassis.
- **Chaingun commandos** — modern chaingunners next to the slower classic chaingunner rig; expect helmet chaingunners and nailgun‑style majors when spawns budget extra spice.
- **Nazi soldiers** — Wolfenstein‑flavored SS rips drop wherever Nazi episodes or replacement tables still call for them.
- **Imp family** — everyday fireball imps, frost‑breathing ice imps, infected savage imps, four themed dark imps (Nami, Nether, ST, Void), and three nightmare palette variants (DNImpVariant1–3) that read as imp squad remixes at a glance.
- **Horrorspawn line** — Monster Pack mutant spawner chain that can vomit fresh runners, screamers, bursters, decapitation variants, and other horror-themed zombies into low tiers while keeping the encounter readable as “grunt tier, louder.” Slimmer footprint than the PS fodder backbone above so the two layers don’t step on each other.
- **Monster Pack zombie armor** — Hunger gaunt bruiser *(console spawn name Hunger)*, treaded Zombie Tank *(ZombieTank)*, up‑armored Zombie Tank Elite *(ZombieTankelite)*, shoulder‑gun plasma and missile tanks *(ZombiePlasmaTank*, *ZombieMissileTank)*, and the jetpack Zombie Flyer *(PB_ZombieFlyer)* for aerial harassment.

### Tier 2 — Pinkies & cyber demons

Melee bruisers and the Monster Pack’s pinky-adjacent showcase demon.

Expect tight corridors to amplify every charging demon—these enemies punish corners and doorways harder than zombies ever could.

- **Pinkies and spectres** — stock pink demons, nearly invisible void spectres, stompy mech demons, and oversized mean demons that keep pinky AI but hit like mini‑bosses.
- **Classic spectre** — the vanilla half‑visible twin still shares spawn tables with pinkies when maps call for it.
- **Cracko Demon** — Monster Pack floater that mixes blue‑lightning offense with cacodemon‑scale HP *(CrackoDemon)*.

### Tier 3 — Mid-roster horrors

Mid-weight specials: walkers, floaters, and the missile ballet tier.

This tier is where projectile density spikes—open yards favor mancubi and cacos, while tight tech bases turn arachnotrons into lane denial.

- **Arachnotrons** — plasma walkers span stock, elite chrome trims, infernal red edits, and the plant‑chassis Arachnophyte experiment.
- **Aracnorb** — gravity‑ ignoring plasma jellyfish cousin to arachnotrons *(Aracnorb)*.
- **Mancubus family** — flame belching fatsos, slower Daedabus arc‑casters, and lava‑themed Volcabus variants sharing the fatso slot behaviors players already fear; they occasionally drop the **Mancubus Flame Cannon** pickup (chance-based **`DropItem`**, not guaranteed). **Daedabus** can also roll a rare **Biological Acid Launcher** (slot 7) on death.
- **Cacodemons and pain elementals** — meatball cannons plus vanilla pain elementals, infernal caco stand‑ins, and suffering elementals that behave like souped‑up pain mothers without stealing the boss spotlight.
- **Other floaters** — Watchers as silent floating eyes, Overlords as oversized aerial tyrants, Phantasms as smoky lost‑soul upgrades, classic lost souls, and Afrits as winged harassers in the same sky‑pest bucket.
- **Monster Pack elementals** — Helemental storm pillars *(Helemental)* and drifting ESoul wisps *(ESoul)* that peel off larger fights or environmental kills.
- **Revenants and cousins** — guided missile revs, beam‑lance Beam Revs, and frost‑themed Draugr skeletons sharing homing DNA.

### Tier 4 — Hell nobility

Heavy hitters below proper episode bosses—arena anchors and caster nightmares.

Knights and barons eat rockets; arch‑viles eat your patience. Bring plasma, corners, and priority target discipline.

- **Knights and barons** — hell knights, barons, cyber‑knight/baron/paladin hybrids, sprinting Belphegors, and Infernus bruisers that still respect Baron‑tier spacing. **Belphegor** can rarely drop the same **Biological Acid Launcher** as **Daedabus** (see slot 7).
- **Arch-viles and specialists** — flame arch‑viles, ice arch‑viles, flesh‑summoning wizards, and Hellions occupying the same raise‑and‑burn psychological lane as vanilla arch‑viles.
- **Marauder** — Eternal‑inspired hunter demon with shields and shotgun snap‑shots; counts as a noble‑tier duelist when he crashes a fight. He sometimes drops his **Marauder Shotgun** (weighted death drop; bonus weapon props after certain finishers are also chance-based).
- **Hierophant** — Monster Pack mastermind‑scale glass cannon that trades armor for offense *(Hierophant)*.

### Tier 5 — Bosses

Icon of Sin‑adjacent threats and custom megabosses.

These fights reserve the spotlight: huge hitboxes, splash damage, and arena‑wide sound cues. Save rockets, cells, and breathing room.

Some boss‑scale fights still reuse Doom II encounter vocabulary—two cyberdemons on a wide staircase still means “empty the backpack,” regardless of which cosmetic variant spawned.

- **Classic Doom bosses** — cyberdemons, spider masterminds, Annihilator missile brutes, Demolisher mastermind variants, and Juggernaut‑class spider edits sized for map climax fights. **Baalgar** (replaces the stock cyber) and related cyber gib FX can sometimes yield the **Cyberdemon Missile Launcher**; masterminds can sometimes drop the **Mastermind's Chaingun** (see weapon list above for wear rules).
- **Monster Pack megabosses** — Hellduke cyber‑duel *(Hellduke)*, Hellsmith forge terror *(Hellsmith)*, Director spider mastermind remix *(Director)*, and Aracnorb Queen swarm mother *(AracnorbQueen)*.

**Cat's Frozen frost roster** — **Frost Baron** rides Hell Knight / Baron spawns, **Cryocubus** rides mancubus tables, **Frostbrain** rides cacodemon tables, and **Cryotron** rides arachnotron tables. They are standard always‑on cryo guests unless **disable new enemies** hides the broader optional roster. (**SchrödingCat / Cat's Frozen Addon** — see **`CREDITS.txt`**.)

Frozen-solid corpse statues are a separate Cat's Frozen presentation layer: most monsters killed by ice or cryo damage can leave an authored frozen prop—not only the four frost monsters listed above.

**Realm667 community guests** — **Blood Ghost** and **Blood Skull** are Lost‑Soul‑tier flyers folded from the Realm667 resource line *(PB_Realm667_BloodGhost*, *PB_Realm667_BloodSkull)* — see **`CREDITS.txt`** / **`DetailedCredits.txt`** for authors.

The in-game **PDA** codex mirrors many of these families with dossiers that unlock as you kill matching creatures—use it when you forget which cryo cousin interrupted your Baron fight.

Unlocked codex rows persist across saves, so long campaigns slowly fill out the same roster this guide outlines.

### Monster-sourced weapons, modules, and drop chances

These are **not** rolled from normal map weapon spawners unless noted. **`DropItem "Class" N`** means roughly **`N / 256`** chance per death roll (engine picks one drop from the monster’s list). **`A_Jump(128, …)`** is a **50%** branch. Omitted probability = **always** when that drop is chosen.

| Source monster(s) | Pickup / module | Death-drop chance |
| --- | --- | --- |
| **`PB_RiotShieldGuy`** (riot-shield sergeant) | **`RiotShieldPickup`** → **`PB_RiotShieldModule`** | **100%** (guaranteed module when the sergeant dies) |
| **`PB_Mastermind`**, **`PB_MastermindGK`** | **`MastermindChaingun`** | **72 / 256** (~**28%**) |
| **`CyberdemonBoss`** (Baalgar / map cyber boss) | **`PB_CyberdemonRL`** | **64 / 256** (**25%**) |
| Cyber **arm gib** (`XDeathCyberdemonGun`, fatality / gore) | **`PB_CyberdemonRL`** | **50%** if **`pb_NoPB_CyberdemonRLWeapon`** is off |
| **`PB_Marauder`**, **`PB_MarauderGK`** | **`MarauderSSG`** | **80 / 256** (~**31%**) |
| Marauder scripted fatality floor props | **`MarauderSSG`** | **50%** (`A_Jump(128, …)`) |
| **`PB_Mancubus`**, **`PB_Daedabus`**, **`PB_Volcabus`**, GK fatso variants | **`MancubusFlameCannon`** | **56 / 256** (~**22%**) |
| **`PB_Daedabus`** | **`BioAcidLauncher`** (slot 7) | **44 / 256** (~**17%**) |
| **`PB_Belphegor`** | **`BioAcidLauncher`** | **36 / 256** (~**14%**) |
| **`PB_ObsidianRavager`** (cyber-tier spawns) | **`PB_ObsidianDragonSlayer`** | **Always** on Ravager death (unless **`pb_NoDragonSlayerWeapon`**) |

**Spawn rate vs. drop rate:** Riot-shield sergeants are an **extra** shotgun-guy variant from **`ShotgunGuySpawner`** (weighted **`A_Jump`** into **`RiotShieldGuyPack`** — e.g. **16 / 256** on one early tier, up to **36 / 256** on another). That controls how often the enemy appears, not whether the module drops (**always** once you kill one).

**`give all` / `idfa`:** Monster-drop guns and the ballistic shield module are excluded from bulk cheat grants; use **`give <ClassName>`** or play the drops above.

The base zombie, imp, pinky, floater, revenant, noble, arch‑vile, and Doom boss rosters come from **Project Brutality** and the **Monster Pack** line — see **`CREDITS.txt`** and **`DetailedCredits.txt`** for full per‑creature authorship.

## Settings and controls

- **Options → PB 2022 Enhanced** — every PB-specific menu lives here (also reachable from the main menu). Submenu inventory is in *What you get → Configuration* above.
- **Options → PB 2022 Enhanced → UI and Feel** — includes **PDA Blocky Layout** and **PDA XP & reward spin (single-player)**. The XP/spin switch defaults to **Off**; when **On**, only single-player games accrue XP and reward points from kills, and the blocky PDA home screen gains the **Reward Spin** panel (see *What you get → In-game codex (PDA)*). Multiplayer matches ignore this path so co-op and deathmatch stay unchanged.
- **Options → Customize Controls** — keybinds under **Project Brutality**, **Project Brutality - Interactions**, and **Glory kill** (Crucible / shoulder-cannon actions).

**Useful console cvars** for bisecting or performance work:

- `pb_classicmonsters` — classic vs. Brutality-style monsters.
- `pb_disablenewenemies`, `pb_disablenewguns`, `pb_disabledecorations`, `pb_disablemapenhancements` — gate the major content blocks on/off.
- `pb_lowgraphicsmode`, `pb_bloodamount` — lighter visuals and gore for low-end machines.

## Feedback and bug reports

For problems with **this** project, use the [Project Brutality Discord](https://discord.gg/2hJxXPc). Please confirm the issue is reproducible with **only** this mod loaded (no extra weapon or gameplay packs) and that it has not already been reported. Read channel rules and pins first.

## Sources and important third-party lineage

This build layers several community sources into Project Brutality’s own systems. Full names and per-asset notes remain in **`CREDITS.txt`** and **`DetailedCredits.txt`**.

| Area | What we ship / how it is used |
| --- | --- |
| **Realm667** | Many monster and prop bases and edits from the community resource site; authors are credited per creature and in the detailed lists. |
| **Monster Pack line** | Extra monsters and spawns (for example Crackodemon, Hellduke, Helemental, Hierophant) included in the main mod alongside standard Project Brutality enemies. |
| **Brutal Doom — *El Diablo* Edition** | Extra first-person executions and finisher art wired through Glory Kills—not a standalone El Diablo total conversion. |
| **Project Brutality Legacy (lineage)** | Older-style execution triggers and handoffs **included** in the main monster set so classic prompts still work with current Project Brutality. |
| **Brutal Pack (e.g. V10 class packs)** | Used in development as selective art and finisher reference; **this repo does not ship the Brutal Pack in full**—only what was adapted into Project Brutality 2022’s roster and Glory Kill flows. |
| **Brutal Doom 22 (BDv22)** | Optional-style gore assets and handlers packaged under their own names; enabled through **2022 Enhanced Brootality**. Credit **Brutal Doom 22** as a project and respect its license if you redistribute those assets. |
| **Brutal Pack V10 (BPv10) gore** | Humanoid and imp-family death extras (burned bodies, carbonized remains, torsos, organs, splats); enabled through **2022 Enhanced Brootality**. Sprites credited to **AWEZ**; respect Brutal Pack licensing if you redistribute. |
| **Cat's Frozen Addon** (SchrödingCat) | Cryo slowdown, frozen-solid corpses, four frost monsters, six extra equipment-wheel tools plus Freeze Nade, and three cryo weapons—**always-on standard content.** Asset attribution: SchrödingCat plus addon-listed contributors (Sergeant_Mark_IV, IDDQD_1337, TypicalSF, Eriance/Amuscaria, Electro7777, Captain Toenail, Rifleman, Gothic, Thanuris, Ganbare-Lucifer, DeVloek, Bloax, ZZrionTheInsect, Xaser, Ethril). See **`CREDITS.txt`** for the per-piece breakdown. |

## Credits

Project Brutality 2022 builds on [Project Brutality](https://github.com/pa1nki113r/Project_Brutality) and the work of that team and their contributors. It also includes Glory Kills and Monster Pack-line content, third-party systems such as **Nash Gore** (Nash Muhandes, modified here), and many named authors in **`CREDITS.txt`** and **`DetailedCredits.txt`**.

**Recent additions in this line:**

- **Boss-tech weapon wear:** cyber launcher, mastermind chaingun, mancubus / Daedabus flame cannon, Marauder shotgun, and **Dragon Slayer** use limited **durability** (separate from ammo) with weapon **break** at zero wear and **repair to full wear** when picking up the same gun again; monster **drops** use weighted chances instead of guaranteed boss loot where appropriate. The chaingun and flame cannon are **not** placed by rocket / plasma **map** weapon spawners (monster sources only). The **Dragon Slayer** is **not** placed by chainsaw **map** spawners (Obsidian Ravager death only). The **UAC Biological Acid Launcher** is also **monster-only**: weighted drops from **Daedabus** and **Belphegor**, with no plasma spawner placement.
- Combined **2022 Enhanced Brootality** gore from Brutal Doom 22 and Brutal Pack V10.
- Expanded first-person executions with art lineage from **Brutal Doom *El Diablo* Edition** and related packs.
- Glory Kill shoulder launcher art and Eternal-style fuel HUD glyphs aligned with the newer Glory Kills presentation.
- **Explosive Movement** extended to Mastermind chaingun tracers and Cat's Frozen freezenade / freeze mines.
- Cat's Frozen cryo enemies, statues, equipment, and weapons as always-on content.
- Kill-streak reward variety (including a revamped drone summon and optional flashlight glow).

Credit to **BeefRice** and **Jaih1r0** for fullscreen weapon HUD elements and many weapon improvements and systems. Thanks to **HUNG** for the **Shield Saw** behavior included in this build (quick melee + recall).

**PB_MeleeWeaponPack** (including slot-1 **Dragon Slayer** & **Vorpal Blade**, slot-9 **Stormcast**): original credits per that add-on’s `CREDITS.txt` — **Craneo**, **Dreo** & **Lord Lothar** (*Schism*), **Eriance** & **TiberiumSoul** (RIP); compatibility rework for PB 0.4.2+ by **Renegade Android**. Details: **`CREDITS.txt`**.

**Maintainers of this package:** RENEGADE ANDROID and doc.

**Contributors:** JhulkerCraft, TomiikiPro.
