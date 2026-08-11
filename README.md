# Project Brutality 2022 Enhanced
![Demo](https://github.com/user-attachments/assets/54fd583d-a94b-41d2-9cc8-e6e7e96be154)

Project Brutality 2022 Enhanced is a full gameplay and content overhaul for *Doom* and *Doom II*, built for [UZDoom](https://github.com/UZDoom/UZDoom), GZDoom & LZDoom.

For the official Project Brutality mod, see [pa1nki113r/Project_Brutality](https://github.com/pa1nki113r/Project_Brutality). This is Project Brutality 2022, an entirely separate yet parallel total conversion with both first and third person finishers.


## Requirements

- **UZDoom / GZDoom / LZDoom**
- **An IWAD**- `doom.wad`, `doom2.wad`, `tnt.wad`, `plutonia.wad`, or [Freedoom Phase 1+2](https://freedoom.github.io/download.html). Retail IWADs are available from the [Steam classics bundle](https://store.steampowered.com/sub/18397/) or GOG ([Doom II + Final Doom](https://www.gog.com/game/doom_ii_final_doom), [The Ultimate Doom](https://www.gog.com/game/the_ultimate_doom)).
- **Mobile (Android) use Delta Touch**

## Installation

1. Install **UZDoom 4.13+** from the [UZDoom releases](https://github.com/UZDoom/UZDoom/releases) and unpack it somewhere convenient.
2. Download this repository (**Code-> Download ZIP**) or clone it.
3. You should have a folder (for example `Project Brutality 2022`) that contains `gameinfo.txt` and the rest of the mod data. The mod ships as a **loose folder**, not a single packaged file.
4. Launch with that folder on the command line:

```
uzdoom.exe -iwad doom2.wad -file "Project Brutality 2022"
```

You can also drag the folder onto `uzdoom.exe` or add it in a launcher such as [ZDL](https://github.com/lcferrum/qzdl/releases), [DoomRunner](https://github.com/Youda008/DoomRunner/releases), or [SSGL](https://github.com/FreaKzero/ssgl-doom-launcher/releases)- set the engine path to your UZDoom binary.


-----------------------
**Optional:**

<img width="600" height="338" alt="reelism2forpb2022" src="https://github.com/user-attachments/assets/4ae1c6d3-8574-486c-95d0-7106cba1ebcf" />[REELISM 2 for PB2022](https://drive.google.com/file/d/1-TyYW_w2iH4bL5to6K9V24oWV3hWz8ix/view?usp=drive_link) 
Modified for PB2022; loads after it.

<img width="600" height="338" alt="backrooms_pb2022" src="https://github.com/user-attachments/assets/f8717581-c4cb-4164-8342-6bc0d1e829fa" />[BACKROOMS Redux from moddb |&](https://www.moddb.com/mods/backrooms-redux-an-immersive-backrooms-experience)[| BACKROOMS Redux PB2022 Compat Patch](https://drive.google.com/file/d/1lqsm1RH6DSSn7_3lP0E5tjqOjQjSTnVQ/view?usp=drive_link) Load Order = Redux > PB2022 > Compat

-----------------------

## What you get with PB2022

- Cinematic kills-in first and third person
- Explosive Movement (Shotgun/Rocket Jump and Plasma Wall-Climb)
- First-person flourishes 
- Second Chance & RIP AND TEAR
- In-game codex (PDA) with Reward Spin
- Kills grant XP, rank-ups award spendable Reward Points
- Damage & Experience Numbers display above enemies
- Built-in achievement system (based on Vortex Universal Achievement System)
- Select a weapon with Weapon Wheel and it will be quick-retrieved in that slot using next/previous weapon binds.
- Item pickups and armor variety
- Combat depth: Brutality-style damage and enemy reactions, weapon and monster variety, extended melee combat, double-tap Dash, Meat Hook,  Shieldsaw, Shoulder Launchers & Crucible...
- Possession Finishers
- Content breadth: Large weapon roster, extra monsters, kill streaks, power-up rewards and announcer support.
- LOADS OF EXTRA GORE & FATALITIES

### Included weapons

**Slot 1- Melee & blades**

- **Bare Hands**- fast close-range melee, kick, and execution starter. **Quick Melee** punches roll among **backhand** and **uppercut** by default; owning melee blades unlocks extra blade-style quick-melee strips, and owning the **chainsaw** can roll a saw swing. Glory Kill, Blood Punch, weapon executions, and Shield Saw throw still take priority when they apply. With **Berserk**, **Weapon Special** toggles **RIP AND TEAR** vs **SMASH** fatality style, and **Use** on nearby living fodder can meat-grab for a throw or meatshield.
- **Axe**- heavy melee pickup for chopping through low-tier enemies.
- **Chainsaw**- classic fuel-fed saw with Project Brutality gore and chainsaw-spawner variants.
- **UAC Nanotech Energy Beam Katana**- energy blade with quick melee integration and barrier-style behavior.
- **Argent Sith Beam Katana**- argent blade variant with its own energy attacks and shield/barrier handling.
- **Vorpal Blade**- exotic blade with charged and special attack behavior.
- **Battle Axe and Shield**- axe/shield melee set with bash and block-oriented play.

**Slot 2- Sidearms & personal defense**

- **UAC Portal Blasters**- dual-wield starter utility: Fire/AltFire shoots portal bolts that stuns enemies and place look-through portals on walls & glowing grids on floors and ceilings.  Inconsistent but fun.
- **Desert Eagle .50**- starter ballistic sidearm for high-damage precision shots.
- **UAC .45 Pistol**- lootable sidearm from pistol zombies; weapon-special options for pistol behavior. Helmeted pistol zombies drop the **Deagle**.
- **Revolver**- high-impact sidearm for heavier single shots.
- **Maschinenpistole 40**- compact automatic ballistic weapon.
- **UAC-17 SMG**- fast sidearm-class automatic with weapon-special handling.
- **Holy Bastard W-SMG**- high-rate SMG variant with dedicated handling.
- **Hell Pistoler**- demon sidearm with a special wheel for Hell Rounds, Shrink Beam, and rate-of-fire toggle behavior.
- **UAC Ballistic Shield Module**- inventory upgrade from **Riot-Shield Sergeants**; not a weapon-slot gun. With the module, open **Weapon Special** on the **.45 Pistol** or **Fire Axe** to toggle **ballistic shield + pistol** (block, bash, shielded reload) or **shield + axe** loadouts.

**Slot 3- Shotguns**

- **Shotgun**- pump-action workhorse with shell management and shotgun special modes.
- **M45 Halo 3 Shotgun**- tube combat shotgun with dedicated spawn toggle.
- **Auto-Shotgun**- faster shell-fed shotgun for sustained close-range fire.
- **Sawed-Off Shotgun**- classic double-barrel burst damage.
- **Commander Shotgun**- combat shotgun with its own ammo/mode logic.
- **SPAS-12**- tube-fed combat shotgun with **Weapon Special** modes: **Combat Pump** and **Riot Sweep**.
- **UAC XHAS-SP Lady Golide**- heavy automatic shotgun platform.
- **UAC-12P Rainmaker**- triple-barrel sequential fire with an Alt-Fire flak blast.
- **Cryo Shotgun**- TeiTenga C-2-1 Pump Shotgun with five **Weapon Special** fire modes: cryo buckshot and ADS ice spears (default), cryo pellet burst, cryo orb, electric bolt, and cryo wind cone. Uses cell reserve plus internal magazine for buckshot; alt modes draw from shells, cryo cells, or cryo cannon fuel pickups.
- **Quad-Barrel Shotgun**- four-barrel burst weapon with special-wheel behavior.
- **Marauder Shotgun**- Marauder-style Super Shotgun variant; uses a hidden **wear** pool (not reserve shells) that drops by one per meaningful shot, **breaks** the weapon when empty, and **refills wear to max** if you pick up another copy while still holding a depleted one. **Marauders** sometimes leave one on death.
- **Hexa-Overkill**- six-barrel shotgun with primary break-open fire and a dedicated **Alt-Fire** zoom blast.
- **Demon-Tech Shotgun**- demonic shell weapon with charged energy behavior.

**Slot 4- Rifles, precision & support**

- **UAC-30 DMR**- marksman rifle with upgrade/dual-wield style support.
- **UAC-41 Carbine**- flexible rifle with special-wheel fire modes.
- **Chex Quest Assault Rifle**- optional Chex-themed rifle variant.
- **Fusil Rifle**- compact automatic rifle with a 24-round internal magazine; **Alt-Fire** aims and **Weapon Special** swaps into its sidearm stance.
- **Light Machine Gun**- belt/magazine support rifle for sustained automatic fire.
- **Metal Sniper**- heavy precision rifle with custom ammo and unload behavior.
- **HL-300s Magnum Sniper**- heavy magnum sniper rifle.
- **UAC-320 Heavy Machine Gun**- older heavy automatic platform.
- **UAC M1893 Lever Action**- lever rifle with a weapon-special wheel for **.357** vs **.444 Marlin** calibers. **Hell Mod** upgrade (T3/T4 map drops) unlock a third wheel option to toggle **hell rounds**.
- **Pro-Surv Ballista**- precision projectile weapon for heavy single shots.
- **M41A Pulse Rifle**- pulse rifle with weapon-special wheel: 12-gauge or 30mm underbarrel Alt-Fire, plus optional dual-wield.
- **Battle Rifle**- modern rifle with magazine handling and tactical ready/fire flow.
- **Warbringer**- Cyberaugumented rifle with high-pressure automatic fire.
- **Anti-Tank Rifle**- mag-fed heavy rifle with **Weapon Special** modes: **Explosive Bolt** , **3-Round Burst**, and **Void Grenade**.
- **Hellshot**- inferno / caustic demon-tech rifle with DeathRay.

**Slot 5- Heavy automatics**

- **Flak Cannon**- heavy flak launcher.
- **Mach-3 Minigun**- sustained bullet hose with upgraded/triple-barrel.
- **UAC-240 Perforator Nailgun**- nail-firing heavy automatic with its own firing-state handling.
- **MG-42**- high-rate classic machine gun.
- **Neo HMG**- heavy machine gun with an Alt-Fire shield that can detach into a temporary deployed energy barrier.
- **Nightfall Augmented**- Cyberaugumented minigun-class heavy with chaotic fire modes.
- **SGP-331 Tactical Nailgun**- Stroggos-style tactical nailgun.
- **MACH-3 HYDRA**- multi-barrel heavy automatic sibling to the Mach-3 line.
- **Gallery Nailgun**- alternate nailgun platform with dedicated spawn toggle.

**Slot 6- Launchers & flame weapons**

- **Super Grenade Launcher**- automatic grenade launcher with selectable grenade behavior.
- **Rocket Launcher**- rocket launcher wired into the Explosive Movement rocket-jump path.
- **UAC-M3 Flamethrower**- flame weapon for burn damage and crowd control.
- **Paingiver**- launcher-class heavy weapon for pain/area damage.
- **UT2004 Triple Rocket Launcher**- three-tube launcher.
- **Excavator**- launcher/special weapon with mode-specific ammo behavior.
- **Mastermind's Chaingun**- boss-derived heavy chaingun Obtained from **Spider Mastermind**.
- **Cyberdemon Missile Launcher**- cyberdemon-style missile launcher obtained from killing **Baalgar / Cyber Boss**.
- **UAC Mancubus Flame Cannon / Daedabus Slime Cannon**- monster-tech cannon with flame/slime-style attacks. **Mancubus-family** enemies sometimes drop it.

**Slot 7- Energy rifles**

- **Cryo Rifle**- freezing rifle for slowing or locking down enemies.
- **Frostburn Device**- frost-energy rifle with dedicated spawn toggle.
- **MKIII Railgun**- precision rail weapon for piercing high-damage shots; **Alt-Fire** toggles the scope zoom when you are not scoped. **Hold Reload and press Alt-Fire** to deploy a holographic decoy.
- **UAC MK-1 Platinum Railgun**- alternate railgun platform alongside the MKIII.
- **UAC-UM-32P Biological Acid Launcher (Unengager)**- primary fire spits sustained acid slugs for damage and area denial; **hold Alt-Fire** for a **Daedabus-style slime stream**. **Acquisition:** rare **death drops** from **Daedabus** and **Belphegor** only.
- **Sirius Crisis Roscoe**- Cyberaugumented energy rifle with chargeable high-end shots.
- **UAC Plasma Beam Rifle**- sustained green rail beam with sphere Alt-Fire.
- **Dispatcher of Delusions**- Cyberaugumented full-auto plasma rifle that draws directly from its cell reserve.

**Slot 8- Plasma & heavy energy primaries**

- **Pulse Cannon**- plasma orb stream with charged Alt spread and optional Dark Matter Orb Alt mode.
- **UAC-M1 Plasma Rifle**- plasma rifle with single/dual weapon-special support and plasma wall-climb behavior.
- **UAC-M2 Plasma Rifle**- alternate plasma rifle using the same movement-friendly plasma impact family.
- **UAC Prototype Dark Matter Rifle**- magazine-fed plasma orbs; chargeable Alt-Fire that alternates Super Plasma Ball and Gravity Singularity after each successful shot; Weapon Special toggles dual-wield.
- **Extinction Ray / Argent Fury**- argent-energy beam rifle.
- **UAC PR-75 Plasma Assault**- assault-style plasma rifle variant.

**Slot 9- Super-weapons & late energy**

- **Demon-Tech Rifle**- demon-energy rifle with charged energy behavior.
- **Harvester of Souls**- soul-energy rifle.
 - **Primary**- depends on Weapon Special mode (below).
 - **Alt-Fire**- subtle zoom.
 - **Weapon Special**- mode wheel:
   - **Soul Bolt**- standard soul bolt (default).
   - **Storm**- bolt plus Overlord storm strike.
   - **Soul Possess**- possession ghost.
   - **Doom Seeker**- homing Unmaker-style seeker.
- **Unmaker**- demonic super-weapon for high-end energy damage.
- **BFG9000 MK IV**- BFG-class room clearer.
- **BFG 11K Prototype / BFG Beam**- beam-style BFG super-weapon entry.
- **Black Hole Generator**- singularity weapon for heavy crowd control.
- **Stormcast**- lightning cast with wizard's hands; chords replace the old weapon-special wheel.
 - **Primary**- staff lightning / melee (needs charge; **Berserk** upgrades the strikes).
 - **Alt-Fire (hold)**- build charge; **release** to cast a bolt scaled to charge.
 - **Primary while holding Alt-Fire**- orb attacks (stronger orbs at higher charge).
 - **Use Equipment** while charging- **stunwall** (bigger at higher charge).
 - **Weapon Special** (hold) while charging- **Arc of Death** at higher tiers.
 - **Reload** (tap) while charging- lightning warper.
 - **Alt-Fire in the air**- hover flight!

### Equipment

- Freeze Nade
- Hook
- Molotov
- StunGrenade
- Void Grenade
- Freezebot
- ElecPod

**Sentry Guns**- equipment-wheel deployable friendly turrets; choose a type from the sub-wheel; **Use Equipment** plants it. Map boxes and rare backpack grants refill ammo. Commandos can drop common kits; ZSpec Ops can drop specialty kits. **Zombie Tanks** always leave a themed kit plus a second kit from the full sentry roster.

**Enemy weapon drops**- many former humans roll a family loot pool filtered by **Spawn Balance** tier and weapon spawn toggles (helmet pistol → Deagle; plasma → Pulse Cannon; rifles / shotguns / ASG / Spec Ops slot-3 / nailguns / commando heavies / Demon Tech). About **60%** of those deaths drop matching ammo instead. Backpacks and ammo boxes can rarely replace with a weapon **upgrade** spawner.

**UAC Survival gear** on the same wheel: **pipe bomb** and **satchel charge** (throw, then detonate remotely) plus **flare** for lighting dark areas. Grunts that drop grenades can occasionally drop UAC kits instead (frags still most common); rocket->grenade map converts can too. Rare backpack bonuses still apply.

**Backpack** pickup also has a ~20% chance to grant a random Cat's Frozen equipment ammo charge. ZSpec Ops can rarely drop a Freezebot / Tesla / Freezenade or other CF item.

- **Snow Caster**- handheld cone-burst that lays cryo wind + ice particles in front of the player.
- **Ice Wall**- generator that drops a temporary line of cryo barrier segments.
- **Holographic Decoy**- places a flickering decoy that pulls monster aggro.
- **Tesla Turret**- friendly chained-lightning turret (won't take damage from your shots).
- **Freeze Mines**- proximity cryo mines; they won't trip under your feet, but you can rocket-jump off them when shot or when monsters set them off.

## Monster roster

Maps still mostly place vanilla Doom edits; pack rolls layer extra variants on top. Higher tiers skew toward late maps, boss slots, and optional pools.

### Tier 1- Grunts & fodder

Low-tier pressure, hierarchy fodder, and most of the wandering cannon fodder you clear between arenas.

Passive hazards from the same packs can share floors with Tier 1 without being "troops": pus pods, mimics, ceiling tentacles, hangman traps, and other Project Survival set-dressing monsters still read as grunt-tier threats because of how little space they need to ruin your day.

- **Project Survival fodder**- Shambler, Puker, Blighter, Screamer, Burster, Spiker, and Cyber Fodder. Spawn distribution skews toward variety- Shambler ~20%, the other five each ~16%. **Trite** pods on floors or ceilings burst into throngs of small **Trite** critters for swarm panic. (**Project Survival** by **The Pope of Dope / ThePopeOfDope**- see **`CREDITS.txt`**.)
- **Zombieman family**- pistol grunts, rifle grunts, carbine specialists, plasma zombies and their trooper-weight sibling, helmeted Phobos-style guards (pistol and rifle versions), and lab-coated scientists who still count as rank-and-file despite their animation set.
- **Shotgun Sergeants**- classic shotgun guys plus helmeted variants, quad-shot and auto-shotgun heavies, **Riot-Shield Sergeants**, rocket-salvo zombies, demon-tech shotgun troopers, and Z-spec squads built on the same sergeant chassis.
- **Chaingun Commandos**- modern Chaingunners next to the slower classic Chaingunner; expect helmet chaingunners and nailgun-style majors when spawns budget extra spice.
- **Imp family**- everyday fireball Imps, frost-breathing ice Imps, infected savage Imps, four themed dark Imps (Nami, Nether, ST, Void), and three nightmare variants.
- **Horrorspawn line**- Monster Pack mutants that can vomit fresh runners, screamers, bursters, decapitation variants, and other horror-themed zombies into low tiers.
- **Monster Pack zombie armor**- Hunger gaunt bruiser, treaded Zombie Tank, up-armored Zombie Tank Elite, shoulder-gun plasma and missile tanks, and the jetpack Zombie Flyer for aerial harassment.

### Tier 2- Pinkies & Cyber Demons

- **Pinkies and Spectres**- stock pink demons, nearly invisible void spectres, stompy mech demons, and oversized mean demons that keep pinky AI but hit like mini-bosses.
- **Classic Spectre**- the vanilla half-visible twin still shares spawn tables with pinkies when maps call for it.
- **Cracko Demon**- Monster Pack floater that mixes blue-lightning offense with cacodemon-scale HP.

### Tier 3- Mid-roster horrors

- **Arachnotrons**- plasma walkers span stock, elite chrome trims, infernal red edits, and the plant-chassis Arachnophyte experiment.
- **Aracnorb**- gravity- ignoring plasma jellyfish cousin to arachnotrons.
- **Mancubus family**- flame belching fatsos, slower Daedabus arc-casters, and lava-themed Volcabus variants sharing the fatso slot behaviors players already fear; they occasionally drop the **Mancubus Flame Cannon** pickup (chance-based **`DropItem`**, not guaranteed). **Daedabus** can also roll a rare **Biological Acid Launcher** (slot 7) on death.
- **Cacodemons and pain elementals**- meatball cannons plus vanilla pain elementals, infernal caco stand-ins, and suffering elementals that behave like souped-up pain mothers without stealing the boss spotlight.
- **Other floaters**- Watchers as silent floating eyes, Overlords as oversized aerial tyrants, Phantasms as smoky lost-soul upgrades, classic lost souls, and Afrits as winged harassers in the same sky-pest bucket.
- **Monster Pack elementals**- Helemental storm pillars and drifting ESoul wisps that peel off larger fights or environmental kills.
- **Revenants and cousins**- guided missile revs, beam-lance Beam Revs, and frost-themed Draugr skeletons sharing homing DNA.

### Tier 4- Hell nobility

- **Knights and barons**- hell knights, barons, cyber-knight/baron/paladin hybrids, sprinting Belphegors, and Infernus bruisers that still respect Baron-tier spacing. **Belphegor** can rarely drop the same **Biological Acid Launcher** as **Daedabus** (see slot 7).
- **Arch-viles and specialists**- flame arch-viles, ice arch-viles, flesh-summoning wizards, and Hellions occupying the same raise-and-burn psychological lane as vanilla arch-viles.
- **Marauder**- Eternal-inspired hunter demon with shields and shotgun snap-shots; counts as a noble-tier duelist when he crashes a fight. He sometimes drops his **Marauder Shotgun**.
- **Hierophant**- Monster Pack mastermind-scale glass cannon that trades armor for offense.

### Tier 5- Bosses

Icon of Sin-adjacent threats and custom megabosses.

These fights reserve the spotlight: huge hitboxes, splash damage, and arena-wide sound cues. Save rockets, cells, and breathing room.

- **Classic Doom bosses**- cyberdemons, spider masterminds, Annihilator missile brutes, Demolisher mastermind variants, and Juggernaut-class spider edits sized for map climax fights. **Baalgar** can sometimes yield the **Cyberdemon Missile Launcher**; masterminds can sometimes drop the **Mastermind's Chaingun**.
- **Monster Pack megabosses**- Hellduke cyber-duel, Hellsmith forge terror, Director spider mastermind remix, and Aracnorb Queen swarm mother.

The in-game **PDA** codex mirrors many of these families with dossiers that unlock as you kill matching creatures- use it when you forget which baddie interrupted your Baron fight.

## Feedback and bug reports

For problems with **this** project, use the [Project Brutality Discord](https://discord.gg/2hJxXPc). Please confirm the issue is reproducible with **only** this mod loaded (no extra weapon or gameplay packs) and that it has not already been reported. Read channel rules and pins first.

## Sources and important third-party lineage

This build layers several community sources into Project Brutality's own systems. Full names and per-asset notes remain in **`CREDITS.txt`** and **`DetailedCredits.txt`**.

| Area | What we ship / how it is used |
|--- |--- |
| **Realm667** | Many monster and prop bases and edits from the community resource site; authors are credited per creature and in the detailed lists. |
| **Monster Pack line** | Extra monsters and spawns (for example Crackodemon, Hellduke, Helemental, Hierophant) included in the main mod alongside standard Project Brutality enemies. |
| **Brutal Doom Plus** (formerly *El Diablo* Edition) | Extra first-person executions and finisher art wired through Glory Kills-not a standalone Brutal Doom Plus total conversion. Also the lineage for **Harvester of Souls**, the **Pulse Cannon** (**Yaelvolador**), and the **Anti-Tank Rifle** (sprites by **Tesefy**). |
| **Project Brutality Legacy (lineage)** | Older-style execution triggers and handoffs **included** in the main monster set so classic prompts still work with current Project Brutality. |
| **Brutal Pack (e.g. V10 class packs)** | Used in development as selective art and finisher reference; **this repo does not ship the Brutal Pack in full**-only what was adapted into Project Brutality 2022's roster and Glory Kill flows. |
| **Brutal Doom 22 (BDv22)** | Optional-style gore assets and handlers packaged under their own names; enabled through **2022 Enhanced Brootality**. Credit **Brutal Doom 22** as a project and respect its license if you redistribute those assets. |
| **Brutal Pack V10 (BPv10) gore** | Humanoid and imp-family death extras (burned bodies, carbonized remains, torsos, organs, splats); enabled through **2022 Enhanced Brootality**. Sprites credited to **AWEZ**; respect Brutal Pack licensing if you redistribute. |
| **Cat's Frozen Addon** (SchrodingCat) | Cryo slowdown, frozen-solid corpses, four frost monsters, six extra equipment-wheel tools plus Freeze Nade, and the **Cryo Shotgun** (slot 3) with five weapon-special fire modes-**always-on standard content.** Cryo cell and cryo cannon fuel pickups still appear for the shotgun's alt modes. Asset attribution: Schr├╢dingCat plus addon-listed contributors (Sergeant_Mark_IV, IDDQD_1337, TypicalSF, Eriance/Amuscaria, Electro7777, Captain Toenail, Rifleman, Gothic, Thanuris, Ganbare-Lucifer, DeVloek, Bloax, ZZrionTheInsect, Xaser, Ethril). See **`CREDITS.txt`** for the per-piece breakdown. |

## Credits

Project Brutality 2022 builds on [Project Brutality](https://github.com/pa1nki113r/Project_Brutality) and the work of that team and their contributors. It also includes Glory Kills and Monster Pack-line content, third-party systems such as **Nash Gore** (Nash Muhandes, modified here), and many named authors in **`CREDITS.txt`** and **`DetailedCredits.txt`**.

Credit to **BeefRice** and **Jaih1r0** for fullscreen weapon HUD elements and many weapon improvements and systems. Thanks to **HUNG** for the **Shield Saw** behavior included in this build (quick melee + recall).

**Harvester of Souls**- **Yaelvolador** and **Carrot** (Brutal Doom Plus lineage). Details: **`CREDITS.txt`**.

**Pulse Cannon**- **Yaelvolador** and **Brutal Doom Plus** (formerly El Diablo Edition). Details: **`CREDITS.txt`**.

**Anti-Tank Rifle**- Brutal Doom Plus; sprite artwork **Tesefy**. Details: **`CREDITS.txt`**.

**PB_MeleeWeaponPack** (including slot-1 **Dragon Slayer** & **Vorpal Blade**, slot-9 **Stormcast**): original credits per that add-on's `CREDITS.txt`- **Craneo**, **Dreo** & **Lord Lothar** (*Schism*), **Eriance** & **TiberiumSoul** (RIP); compatibility rework for PB 0.4.2+ by **Renegade Android**. Details: **`CREDITS.txt`**.

**Maintainers of this package:** RENEGADE ANDROID and doc.

**Contributors:** JhulkerCraft, BeefRice, Yaelvolador, Warcarlsson, TomiikiPro
