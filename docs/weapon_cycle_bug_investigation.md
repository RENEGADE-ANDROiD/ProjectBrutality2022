# Weapon Cycle / IDFA Bug Investigation

**Session date:** 2026-05-01  
**Reported by:** User (play-testing)  
**Status:** **Resolved 2026-05-02** — see the **Resolution** section at the bottom. Root Cause 1 (BHGen) **fixed** 2026-05-01 (lowered `Weapon.AmmoUse` / `AmmoUse2` from 100 to 50 in `actors/Weapons/Slot8/BLACKHOLE.dec`). Root Cause 2 (`+CHEATNOTWEAPON` / `+POWERED_UP` slot-8 gap) **eliminated** 2026-05-02 by removing `PB_PulseCannon` and `PB_DualPulseCannons` outright. Suspected Issue 4 (M2Plasma 0-tic `A_Lower` chain) **rejected** — see the rejection note in the Recommended Fixes section. Recommended Fix 4 (audit other `+CHEATNOTWEAPON` / `+POWERED_UP` weapons in slots 2–4) deferred pending a concrete repro.

---

## Observed Symptoms

1. After using the **IDFA cheat**, pressing the **slot 8 number key does nothing** (cannot directly select slot 8 weapons).
2. **Scrolling forward** (Next Weapon / mousewheel down) from the pistol cycles normally through all intermediate weapons, but **stops at the M2 Plasma Rifle** (`PB_M2Plasma`, slot 8 index 1) and refuses to advance further.
3. Pressing the **slot 9 key** selects the **Black Hole Generator** (`BHGen`) directly. However, **scrolling backward** (Prev Weapon) from BHGen immediately gets stuck — **cannot scroll back past BHGen** into slot 8 or lower.
4. Giving `PB_PulseCannon` via console did **not** fix the forward-scroll issue from M2Plasma.
5. Pressing the **slot 0 key does nothing** (expected — no weapons are defined in slot 0 for `PB_Doomer`).

---

## Relevant Code Locations

| File | Role |
|---|---|
| `zscript/PlayerPawn.zc` lines 207–260 | `PickNextWeapon` override |
| `zscript/PlayerPawn.zc` lines 262–315 | `PickPrevWeapon` override |
| `actors/Weapons/Slot6/M2PLASMA.dec` | `PB_M2Plasma` definition, Deselect/Select states |
| `actors/Weapons/Slot6/PulseCannon.dec` | `PB_PulseCannon` definition, flags |
| `actors/Weapons/Slot6/DUALPULSECANNON.dec` | `PB_DualPulseCannons` definition, flags |
| `actors/Weapons/Slot8/BLACKHOLE.dec` | `BHGen` definition, ammo properties |
| `actors/Weapons/Slot6/PLASMA.dec` | `NewCell` / `PlasmaAmmo` ammo definitions |
| `actors/Player/PLAYER.dec` lines 783–790 | `Player.WeaponSlot` definitions for `PB_Doomer` |

---

## How `PickNextWeapon` / `PickPrevWeapon` Work

Both functions are custom overrides in `PlayerPawnBase` (see `zscript/PlayerPawn.zc`). The logic:

1. Locate the **current ready weapon** (or pending weapon) in the player slot table via `player.weapons.LocateWeapon(class)`.
2. Iterate through the slot table with `++index` / `++slot` (forward) or `--index` / `--slot` (backward), wrapping around from slot 9 → slot 0.
3. For each candidate: check `FindInventory(weaponClass) != null` AND `weap.CheckAmmo(Weapon.EitherFire, false)`.
4. **If both pass, return that weapon.** If the loop completes the full cycle without finding anything, **return `ReadyWeapon` (no change)** — this is what produces the "stuck" feeling.
5. A `slotschecked <= 128` guard prevents infinite iteration but is far above what a full cycle requires (~10 slot increments).

**Key implication:** A weapon that is in your inventory but whose `CheckAmmo(EitherFire)` is `false` is **permanently invisible to the scroll wheel.** A weapon that is simply not in inventory is silently skipped.

---

## Root Cause 1 — BHGen Ammo Mismatch (CONFIRMED BUG)

### Evidence

`actors/Weapons/Slot8/BLACKHOLE.dec`:
```
Weapon.AmmoUse  100
Weapon.AmmoUse2 100
Weapon.AmmoType  "Cell"
Weapon.AmmoType2 "Cell"
```

`actors/Weapons/Slot6/PLASMA.dec` — the `NewCell` ammo actor that maps to `"Cell"`:
```
Actor NewCell : Ammo
{
    Inventory.MaxAmount 50
    Ammo.BackpackMaxAmount 50
    ...
}
```

### Analysis

`BHGen` is in **slot 9, index 0** (`Player.WeaponSlot 9, BHGen, PB_Unmaker, PB_BFG9000, ...` in PLAYER.dec). It is the **first** slot 9 weapon in the cycle order after M2Plasma.

Its `CheckAmmo(EitherFire)` check requires the player to hold **≥ 100 cells** for either primary or alt fire. PB overrides `Cell` ammo max to **50** units. Therefore **`CheckAmmo` permanently returns `false` for BHGen** — no matter how much ammo you have. IDFA gives max ammo (50 cells), which is still below the 100-cell threshold.

This is almost certainly unintentional. Either:
- `Weapon.AmmoUse` / `Weapon.AmmoUse2` should be ≤ 50, OR
- `BHGen` should use a dedicated high-capacity ammo type instead of raw `Cell`.

Note that **pressing the slot 9 key CAN select BHGen** because GZDoom's slot-key selection only checks inventory ownership, not `CheckAmmo`. The scroll wheel uses `CheckAmmo`; the slot key does not. This explains the asymmetry the user observed.

### Consequence for scroll wheel

Starting from M2Plasma (slot 8, index 1) going **forward**:

| Slot | Index | Weapon | Reason Skipped |
|---|---|---|---|
| 8 | 2 | `PB_PulseCannon` | Not in inventory (see Root Cause 2) |
| 8 | 3 | `PB_DualPulseCannons` | Not in inventory (see Root Cause 2) |
| 9 | 0 | `BHGen` | `CheckAmmo` always false (this bug) |
| 9 | 1+ | `PB_Unmaker`, `PB_BFG9000`, etc. | **Needs investigation** — may have similar ammo issues |

If all of slot 8 (indices 2–3) and all of slot 9 fail, the cycle continues wrapping through slots 0–7. Weapons in slots 1–7 that are owned and pass `CheckAmmo` (pistol, rifles, shotguns, etc.) **will** be found. Whether the user sees the cycle as "stuck at M2Plasma" or "jumping backwards to pistol" depends on whether all the intermediate weapons between M2Plasma and BHGen visibly present to the user as a wall.

**Giving PulseCannon did not fix the issue** because PulseCannon is at slot 8 index 2 — still before BHGen. After adding PulseCannon to inventory, the next weapon found was PulseCannon itself, which may still have been unexpected to the user, or BHGen continued to fail after PulseCannon.

---

## Root Cause 2 — `PB_PulseCannon` and `PB_DualPulseCannons` Not Given by IDFA

### Evidence

`actors/Weapons/Slot6/PulseCannon.dec`:
```
+WEAPON.CHEATNOTWEAPON
+POWERED_UP
Weapon.SisterWeapon PB_M1Plasma
```

`actors/Weapons/Slot6/DUALPULSECANNON.dec`:
```
+POWERED_UP
+WEAPON.NO_AUTO_SWITCH
Weapon.SisterWeapon PB_M1Plasma
```

### Analysis

- `+WEAPON.CHEATNOTWEAPON` on `PB_PulseCannon` explicitly tells GZDoom's IDFA / `give allweapons` cheat to **skip this weapon**. This is intentional design: the Pulse Cannon upgrade is meant to be found in-game, not granted by cheats.
- `+POWERED_UP` on both `PB_PulseCannon` and `PB_DualPulseCannons` flags them as powered-up sister variants of `PB_M1Plasma`. GZDoom's cheat-give logic also skips `+POWERED_UP` weapons.

After IDFA, the player has `PB_M1Plasma` and `PB_M2Plasma` in slot 8, but neither `PB_PulseCannon` nor `PB_DualPulseCannons`. This creates a **gap** in the slot 8 table that the scroll wheel skips over silently.

This is **intentional** for `PB_PulseCannon` (it is an in-game upgrade). Whether the gap it creates combined with the BHGen `CheckAmmo` bug was anticipated is unclear.

---

## Root Cause 3 — Other `+POWERED_UP` / `+CHEATNOTWEAPON` Weapons Across All Slots

Other weapons in the mod also have these flags, creating additional scroll-wheel gaps for any IDFA loadout:

| File | Weapon Actor | Flags |
|---|---|---|
| `actors/Weapons/Slot2/Deagle.dec` | (Deagle powered-up variant) | `+POWERED_UP`, `+CHEATNOTWEAPON` |
| `actors/Weapons/Slot1/MELEE.dec` | (some melee variant) | `+CHEATNOTWEAPON` |
| `actors/Weapons/Slot4/LMG.dec` | (LMG powered-up variant) | `+POWERED_UP`, `+CHEATNOTWEAPON` |
| `actors/Weapons/Slot3/QUADBARREL.dec` | `PB_QuadSG` | `+POWERED_UP`, `+CHEATNOTWEAPON` |
| `actors/Weapons/Slot4/ChexRifle.dec` | `ChexRifle` (some state) | `+CHEATNOTWEAPON` |

These are not part of the immediate M2Plasma cycling bug but may produce similar "dead zones" in other slot ranges when using IDFA.

---

## Suspected Issue 4 — M2Plasma `Deselect` State Uses 0-Tic `A_Lower` Chain

### Evidence

`actors/Weapons/Slot6/M2PLASMA.dec` lines 479–505:

```
Deselect:
    TNT1 A 0 { A_WeaponOffset(0,32); A_SetRoll(0); ... }
    TNT1 A 0 A_StopSound(6)
    TNT1 A 0 { ... }
    TNT1 A 0 A_JumpIfInventory("GotMeatShield", 1, "GrabEnemy")
    TNT1 A 0 A_JumpIfInventory("DualWieldingM2Plasma",1,"DeselectDualWield")
    M230 EDCBA 1 { ... }     // 5-tic animation
    TNT1 AAAAAAAAAAAAAAAAAA 0 A_Lower    // 18 zero-tic calls
    Wait

DeselectDualWield:
    M231 GFED 1
    TNT1 AAAAAAAAAAAAAAAAAA 0 A_Lower    // same pattern
    Wait
```

The same 0-tic pattern also appears in the **`Select`** state:
```
SelectContinue:
    TNT1 A 0 A_Takeinventory("M2PlasmaUnloaded",1)
    TNT1 A 0 PB_WeapTokenSwitch("M2Selected")
    TNT1 A 0 A_GiveInventory("HasPlasmaWeapon",1)
    TNT1 AAAAAAAAAAAAAAAAAA 0 A_Raise    // 18 zero-tic raises
    TNT1 AAAAAAAA 1 A_Raise             // 8 one-tic raises
    Wait
```

### Analysis

In GZDoom's PSprite system, the behavior of 0-tic states followed by `Wait` differs from normal actor states. The standard pattern used by most PB weapons is `TNT1 AAAAAAAA 1 A_Lower / Wait` (one `A_Lower` call per tick).

The M2Plasma variant uses 18 zero-tic `A_Lower` calls. Depending on how GZDoom's PSprite tick processes zero-duration states:

- **If 0-tic PSprite states chain instantly** (all 18 `A_Lower` calls fire in one tic): the weapon lowers 18 × LowerSpeed pixels in tic 1, then `Wait` continues 1 × LowerSpeed per tick until WEAPONBOTTOM. This works but produces a lopsided lowering curve rather than a smooth descent.
- **If 0-tic PSprite states act like `Wait` states** (tics=0 → decrements to -1 → never auto-advances): only the first state in the chain is ever reached, and it fires `A_Lower` once per tick forever. The other 17 states and the `Wait` are unreachable. This also works (weapon lowers 1× LowerSpeed/tick), but the author's intent (fast initial drop) is lost.

In either case, the weapon **should eventually lower and transition to the pending weapon** — this is not a hard lock. However, if the engine behavior does not match the author's assumption, the transition timing may be erratic. This warrants verification against UZDoom 4.14.3's PSprite tick implementation (`src/playsim/p_pspr.cpp`).

This pattern should be **normalized to `TNT1 AAAAAAAA 1 A_Lower / Wait`** (matching the rest of the codebase) to eliminate ambiguity.

---

## Summary: Why Slot 8 Key Appears to Do Nothing

After IDFA, the player is **on** M2Plasma (reached by scrolling). Pressing slot key 8 selects the weapon with the highest priority in slot 8 that the player **owns** — which is M2Plasma itself (already the current weapon). GZDoom's slot-key cycle within a slot does step to the next weapon in the same slot, but if nothing else in slot 8 is owned (PulseCannon and DualPulseCannons are absent post-IDFA), pressing 8 repeatedly just re-selects M2Plasma with no visible change. This may appear as "the key does nothing" but is expected behavior given the empty slot.

---

## Slot 9 Weapons: Still Need Investigation

The following slot 9 weapons need their `Weapon.AmmoUse` / `Weapon.AmmoType` values audited against PB's custom ammo maxima to confirm whether they also fail `CheckAmmo` and are therefore invisible to the scroll wheel:

- `PB_Unmaker` (`actors/Weapons/Slot9/Unmaker.dec`)
- `PB_BFG9000` (`actors/Weapons/Slot8/BFGMKIV.dec` — note: folder says Slot8, Player.dec places it in slot 9)
- `PB_BFGBeam` (same file?)
- `PB_DemonExterminator` (`actors/Weapons/Slot9/DemonExterminator.dec`)
- `PB_Flamethrower` (`actors/Weapons/Slot9/Flamethrower.dec`)
- `Hell_rifle` (`actors/Weapons/Slot9/DemonTech.dec`)

If all slot 9 weapons have broken or unreachable `CheckAmmo`, the scroll wheel will never reach any slot 9 weapon regardless of whether the player owns them.

---

## Recommended Fixes

### Fix 1 — BHGen `Weapon.AmmoUse` (HIGH PRIORITY)

`actors/Weapons/Slot8/BLACKHOLE.dec`:

Either reduce `AmmoUse` to match the Cell cap:
```
Weapon.AmmoUse  50
Weapon.AmmoUse2 50
```

Or introduce a dedicated BHGen ammo type with a higher `Inventory.MaxAmount` (e.g. 200 or 300) and update `Weapon.AmmoType` / `Weapon.AmmoType2` accordingly. Check how BHGen ammo pickups work (`Weapon.AmmoGive 100` currently also gives more than the max, which is a silent clamp) and pick the approach that matches design intent.

### Fix 2 — M2Plasma 0-Tic Deselect/Select States (REJECTED 2026-05-01)

**Do not re-attempt without new evidence.** A grep of the entire `actors/Weapons/` tree shows the `TNT1 AAAAAAAAAAAAAAAAAA 0 A_Lower / Wait` (and the matching `A_Raise`) pattern is the **dominant codebase convention**, not a deviation: it appears in [actors/Weapons/BaseWeapon.dec](actors/Weapons/BaseWeapon.dec) lines 1516 / 1532 (the meatshield + barrel-grab paths the rest of the mod inherits), in `Slot1/SAW.dec`, `Slot2/Deagle.dec`, `Slot2/REVOLVER.dec`, `Slot3/SHOTGUN.dec`, `Slot3/SSG.dec`, `Slot4/LeverAction.dec`, `Slot4/LMG.dec`, `Slot4/MG42.dec`, `Slot5/ROCKETLAUNCHER.dec`, `Slot7/FREEZER.dec`, `Slot9/Unmaker.dec`, `Slot9/Flamethrower.dec`, and many more. Normalizing only M2Plasma would diverge from the established pattern without addressing the actual cycle bug, which is purely a `CheckAmmo` issue (Root Cause 1). If the chain ever proves materially broken, the fix needs to be a single sweeping pass across all the listed files plus `BaseWeapon.dec`, justified by an engine-side reproduction in UZDoom 4.14.3.

### ~~Fix 2 (rejected, preserved for context)~~ — M2Plasma 0-Tic Deselect/Select States (LOW-MEDIUM PRIORITY)

`actors/Weapons/Slot6/M2PLASMA.dec` — replace both occurrences:

```
// Before
TNT1 AAAAAAAAAAAAAAAAAA 0 A_Lower
Wait

// After
TNT1 AAAAAAAA 1 A_Lower
Wait
```

And in `SelectContinue`:
```
// Before
TNT1 AAAAAAAAAAAAAAAAAA 0 A_Raise
TNT1 AAAAAAAA 1 A_Raise
Wait

// After
TNT1 AAAAAAAAAAAAAAAAAA 1 A_Raise
Wait
```

### Fix 3 — Audit All Slot 9 Weapons' Ammo Requirements (MEDIUM PRIORITY)

For each weapon in `Player.WeaponSlot 9`, verify that `Weapon.AmmoUse` / `Weapon.AmmoUse2` do not exceed the `Inventory.MaxAmount` of the referenced ammo type. Any weapon requiring more ammo than the game allows the player to carry will be permanently invisible to the scroll wheel.

### Fix 4 — Audit Other CHEATNOTWEAPON / POWERED_UP Weapons (LOW PRIORITY)

Review whether the gaps created by `+CHEATNOTWEAPON` and `+POWERED_UP` weapons in slots 2, 3, 4 cause similar "dead ends" in other slot ranges. If a powered-up weapon is the **only** weapon in a slot (or is surrounded by weapons the player also cannot obtain via IDFA), it creates the same cycling dead zone.

---

## Debug Commands for the Next Agent

These console commands can help reproduce and verify the bug state in-game:

```
// Give IDFA loadout (all weapons + max ammo)
idfa

// Check if BHGen is in inventory
give BHGen

// Inspect ammo count
give Cell  (should cap at 50)

// Give PulseCannon upgrade directly
give PB_PulseCannon

// Check scrolling behavior by checking current weapon class each tick
// (Use GZDoom's built-in stat display if available, or add a debug print)
```

A smoke-test run with `+logfile` will surface any parse errors introduced by fixes. See the local-paths rule for the canonical smoke-test command.

---

## Files to Edit for Fixes

1. `actors/Weapons/Slot8/BLACKHOLE.dec` — reduce `Weapon.AmmoUse` and `Weapon.AmmoUse2`
2. `actors/Weapons/Slot6/M2PLASMA.dec` — normalize 0-tic `A_Lower` / `A_Raise` chains in `Deselect`, `DeselectDualWield`, and `SelectContinue`
3. `actors/Weapons/Slot9/*.dec` — audit and patch any weapons with `AmmoUse > Inventory.MaxAmount` of their ammo type

---

## Resolution

This document is now **historical**. Both root causes the investigation identified have been addressed:

- **Root Cause 1 (BHGen `CheckAmmo` failure)** — fixed 2026-05-01 by lowering `Weapon.AmmoUse` / `AmmoUse2` from 100 to 50 in `actors/Weapons/Slot8/BLACKHOLE.dec` so a freshly-IDFA'd cell pool of 50 is enough to keep BHGen on the cycle list.
- **Root Cause 2 (`+CHEATNOTWEAPON` / `+POWERED_UP` slot-8 gap)** — eliminated 2026-05-02 by **removing `PB_PulseCannon` and `PB_DualPulseCannons` outright**, along with their entire support surface (DECORATE actors, ACS toggles, sprite/brightmap folders, friendly Marine ally, wheel hooks, status-bar `IsSelected` blocks, language strings, DoomEdNums, cvars, menu rows, and the `SpawnFriends9` ally-summon chain in `PLAYER.dec`). Slot 8 now contains only `PB_M1Plasma` and `PB_M2Plasma`, both of which are fully cheat-grantable, so `idfa` followed by forward-scrolling from M2Plasma now advances cleanly into slot 9 (`BHGen`) without skipping over an empty slot. The cross-cutting helpers `PulseCannonBall`, `PulseBeamLaser`, and `PulseCannonBeamTrail` were renamed to `ChexBall` / `BHBeamLaser` / `BHBeamTrail` and relocated into `actors/Weapons/Slot4/ChexRifle.dec` and `actors/Weapons/Slot8/BLACKHOLE.dec` respectively, since their only surviving consumers are `ChexProjectile` and `BHGen` / `OldBlackHole`. See `CHANGELOG.md` (`[Unreleased]` → `Removed`) for the player-facing summary.
