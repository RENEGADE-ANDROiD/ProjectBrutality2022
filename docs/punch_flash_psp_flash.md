# Punch‑flash psprite layer: why `FlashPunching` historically *had* to end with `Stop`, and how PB Staging quietly fixed it

Status: adopted in PB 2022 (see `actors/Weapons/BaseWeapon.dec` `GoMeleeInstead` /
end of `QuickMelee`, `zscript/Weapons/BaseWeapon.zc` ZScript `QuickMelee`
fallback, and the ZScript weapon overrides `zscript/Weapons/Slot1/BeamKatana_Weapon.zs`
+ `zscript/Weapons/Slot1/ArgentSith_Weapon.zs`).

This note exists because the fold looks trivial on the diff (`A_Overlay(4,
"FlashPunching")` → `A_Overlay(PSP_FLASH, "FlashPunching")`) but the engine
behaviour behind it is *not* trivial, and future porters will almost certainly
trip on the same rake we did.

---

## 1. Symptom

Historic PB 2022 rule (pre‑fold):

> *Punch flash must end with `Stop`. Kick flash must end with `Goto Ready3`.*

If any weapon's `FlashPunching` ended with `Goto Ready3`, a duplicate of the
`Ready3` weapon sprite would stick on screen — overlaid on top of the real
weapon — sometimes for ~1/3 second, sometimes indefinitely, until the next
`A_ClearOverlays(…)` call happened to cover that layer.

This is the bug that forced the asymmetric rule, and it is why the six ZScript
weapons' `FlashPunching` states were ending in `Stop;` while their
`FlashKicking` states ended in `Goto Ready3;`.

## 2. The actual mechanism

GZDoom's player pawn renders a *stack* of psprites. Each call to
`A_Overlay(layer, "StateName")` spawns a **new, independent psprite** on that
layer, which runs its own state chain from `StateName` and advances in parallel
with every other psprite the player owns. Critical properties:

- `Stop` at the end of a state chain **destroys** the psprite (the layer becomes
  empty).
- `Goto X` does **not** destroy anything; the psprite just keeps running,
  entering state `X`, on the same layer.
- `A_ClearOverlays(lo, hi)` destroys all psprites on layers in `[lo, hi]`
  **except the caller's own layer**.

Old PB 2022 flow (`actors/Weapons/BaseWeapon.dec`, circa pre‑fold):

```text
PSP_WEAPON (1)  : Ready3 → Fire → QuickMelee → GoMeleeInstead → MC3S ABCD... → ... → Goto Ready3
Layer 4         :                                 A_Overlay(4, "FlashPunching")
                                                  → <weapon-specific knife/punch frames>
                                                  → Goto Ready3    ← duplicate!
```

Layer 4 is a plain integer overlay with no special render rules. When the flash
chain hit `Goto Ready3`, the layer‑4 psprite faithfully started running the
weapon's own `Ready3` loop **on layer 4**, painting its idle sprite on top of
the main weapon. Because `Ready3` is a loop, nothing ever destroyed that
psprite, and the duplicate survived.

The historic workaround was simply: don't let the chain continue. End it with
`Stop` and the engine destroys the flash psprite, no duplicate possible.
Unfortunately that rules out a whole family of patterns that *depend on* ending
in `Ready3` — most importantly `DoEffect()` alt‑hold shield / barrier PSprites
on weapons like `PB_NeoHMG`, `PB_ArgentSith`, and `PB_BeamKatana`, which need
the weapon to settle back into a steady `player.ReadyWeapon == self` ready loop
to continue working.

## 3. What PB Staging does differently

PB Staging (PBv0.3 staging tree) ships the *exact same* weapon states, with the
*exact same* `Goto Ready3;` endings on `FlashPunching`. The only difference is
one token in `GoMeleeInstead`:

```text
// PB Staging — actors/Weapons/BaseWeapon.dec
GoMeleeInstead:
    TNT1 A 0 {
        A_Overlay(PSP_FLASH, "FlashPunching");   // <-- not layer 4
        A_GiveInventory("HasCutingWeapon", 1);
        ...
    }
```

`PSP_FLASH` is the built‑in constant for layer **1000** — the engine's dedicated
*gun‑flash* psprite layer. The key things about PSP_FLASH that layer 4 doesn't
have:

1. **Render‑order treatment.** PSP_FLASH is drawn with the weapon's flash state
   conventions; in practice, when it hosts a non‑flash state like `Ready3`, the
   resulting sprite lines up with the main weapon psprite instead of visibly
   separating from it. In Staging's shipping content this is usually enough on
   its own — players never consciously notice any duplicate because it paints
   over the real weapon 1:1.
2. **It is the layer that `A_GunFlash` owns.** Any subsequent `A_GunFlash` call
   (next shot, next select, etc.) swaps what PSP_FLASH is showing. In PB 2022
   our `QuickMelee` entry already does `A_Gunflash("Null")`, which — once punch
   flash is routed through PSP_FLASH — *is also* a cleanup for residuals the
   next time the player fires.
3. **It is still a regular psprite**, so it *can* be destroyed deterministically
   — but only if you disable `A_ClearOverlays`' `safety` argument (see §4a
   below). This is the mistake the first version of this fold made; the
   sections below assume you have read that caveat.

In Staging these three properties combine to make the bug effectively
unobservable. Staging does **not** add explicit PSP_FLASH clears around
`GoMeleeInstead`; it simply relies on (1) and (2).

## 4a. CRITICAL GOTCHA: `A_ClearOverlays` has `safety = true` by default

This is the single most important thing to internalise in this document,
because the first version of the fold was silently broken without it.

The native signature of `A_ClearOverlays` in GZDoom / UZDoom is:

```zscript
native int A_ClearOverlays(int sstart = 0, int sstop = 0, bool safety = true);
```

The `safety` argument defaults to `true`, and its behaviour (from UZDoom
4.14.3 `src/playsim/p_pspr.cpp`) is:

```cpp
if (safety)
{
    if (id >= PSP_TARGETCENTER) break;
    else if (id == PSP_STRIFEHANDS || id == PSP_WEAPON || id == PSP_FLASH)
        continue;
}
pspr->SetState(nullptr);
```

In plain English: **with `safety = true`, `A_ClearOverlays` silently skips
`PSP_WEAPON` (layer 1) and `PSP_FLASH` (layer 1000), even when you pass them
explicitly in the layer range.** Neither the wiki nor most community tutorials
mention this. There is no compile error, no runtime warning — the call
succeeds, returns a count, and does nothing. For example:

- `A_ClearOverlays(10, 11)` — works, clears layers 10 and 11 (they are not in
  the safety allow‑list, so `safety=true` does not affect them).
- `A_ClearOverlays(PSP_FLASH, PSP_FLASH)` — **silently a no‑op**, because the
  only layer in the range is `PSP_FLASH` and `safety=true` skips it.
- `A_ClearOverlays(PSP_FLASH, PSP_FLASH, false)` — actually destroys the
  PSP_FLASH psprite, because `safety=false` removes the PSP_FLASH / PSP_WEAPON
  exemption.

Every PSP_FLASH clear in PB 2022's punch‑flash plumbing **must** pass
`false` as the third argument. The same applies to any future code that needs
to destroy PSP_WEAPON / PSP_FLASH directly via `A_ClearOverlays`.

When we got this wrong, the in‑game symptom was exactly what you would expect
from the `Goto Ready3` path running forever on PSP_FLASH: a stuck duplicate
weapon sprite, plus the player being unable to switch weapons or enter other
weapon states, because the duplicate `Ready3` on PSP_FLASH is calling
`A_DoPBWeaponAction` / `A_WeaponReady` in parallel with the real PSP_WEAPON
loop and the two state machines fight each other for input.

## 4. What we ship in PB 2022 (belt‑and‑suspenders)

We keep Staging's layer choice, and add two explicit clears that Staging
omits. Both clears pass `safety = false` per §4a. This makes the behaviour
*deterministic* rather than merely *usually invisible*:

```text
PSP_WEAPON (1): Ready3 → Fire → QuickMelee → GoMeleeInstead
                                 │
                                 ├─ A_ClearOverlays(PSP_FLASH, PSP_FLASH, false)   ← entry clear
                                 ├─ A_Overlay(PSP_FLASH, "FlashPunching")
                                 └─ MC3S ABCD... → ... → cleanup
                                                          │
                                                          ├─ A_ClearOverlays(PSP_FLASH, PSP_FLASH, false)
                                                          │   ← exit clear, fires before Goto Ready3
                                                          └─ Goto Ready3
PSP_FLASH (1000):                A_Overlay(PSP_FLASH, "FlashPunching")
                                 → <weapon-specific punch frames>
                                 → Stop  *or*  Goto Ready3   ← either is now safe
```

Why both clears:

- **Entry clear** (`A_ClearOverlays(PSP_FLASH, PSP_FLASH, false)` at the top of
  `GoMeleeInstead`) is cheap insurance against a previous flash psprite that
  was somehow still alive when the player initiates a melee — for example, a
  `FlashPunching` state that started a long animation and hasn't completed
  before the player triggers another melee. Without this, the new
  `A_Overlay(PSP_FLASH, ...)` replaces the *visible* sprite but the old psprite
  keeps advancing in the background. Clearing first guarantees a fresh start.

- **Exit clear** (`A_ClearOverlays(PSP_FLASH, PSP_FLASH, false)` at the tail of
  `QuickMelee`, right before `Goto Ready3`) gives us the freedom to let
  `FlashPunching` *itself* terminate with either `Stop` or `Goto Ready3`. If a
  weapon's `FlashPunching` ends with `Stop`, the PSP_FLASH psprite destroys
  itself and the exit clear is a no‑op. If it ends with `Goto Ready3`, PSP_FLASH
  enters `Ready3` in parallel with the real weapon — but the exit clear wipes
  that parallel psprite the instant the main `QuickMelee` chain catches up, so
  at worst there is a very short window (bounded by the difference between the
  punch‑flash animation length and the ~14 tics of `MC3S ABCD... + TNT1 AAAA`
  cleanup) where PSP_FLASH holds `Ready3`. In that window PSP_FLASH's
  `Ready3` sprite renders *over* the knife swing on PSP_WEAPON, which is what
  makes the artifact visually unobtrusive in the first place (it looks like the
  weapon is still there — because it is).

The net effect is that **either terminator is valid** for `FlashPunching` in
PB 2022 post‑fold, and we default to `Goto Ready3` for symmetry with
`FlashKicking`.

### 4b. Alternatives to `A_ClearOverlays(..., false)`

A few equally valid ways to destroy a PSP_FLASH psprite, if `A_ClearOverlays`
with `safety=false` is ever inconvenient:

- `A_GunFlash("Null")` — `A_GunFlash` sets `PSP_FLASH` to whatever state label
  you pass; `"Null"` resolves to the engine‑provided `TNT1 A 0 Stop` state,
  which destroys the psprite the tic it runs. Readable and does not require
  understanding the safety flag, but only useful specifically for PSP_FLASH
  (the whole point of `A_GunFlash` is that it hard‑codes layer 1000).
- `player.SetPsprite(PSP_FLASH, null)` — ZScript‑only, direct. Destroys the
  psprite. Equivalent to what `A_GunFlash` ends up doing when given `null`.
- `A_Overlay(PSP_FLASH, "Null")` — spawns a new psprite on PSP_FLASH running
  the `Null` state, which immediately `Stop`s. Effectively the same end state
  but with one extra frame of bookkeeping.

Any of these work. We picked `A_ClearOverlays(..., false)` for symmetry with
the many existing `A_ClearOverlays(10, 11)` calls in this codebase — same
function shape, just with the safety argument visible so the intent is clear
to the next porter.

## 5. Why `FlashKicking` never had this problem

`FlashKicking` is launched on `PSP_WEAPON` itself, not on an overlay layer — see
`DoKick` / `SlideKick` / `AirKick` in `actors/Weapons/BaseWeapon.dec`, which all
do `A_Overlay(PSP_WEAPON, "FlashKicking")`. "Goto Ready3" from PSP_WEAPON simply
continues the main weapon psprite into its own `Ready3`; there is no second
psprite to leave behind, so no duplicate.

`FlashPunching` cannot mimic that because the knife/punch swing is meant to
play **over** the held weapon (pistol, rifle, SSG, …), not to replace it. It
*has* to live on an overlay psprite, which is why the layer choice matters.

## 6. One weapon that still uses `Stop` intentionally: `RiotShield`

`actors/Weapons/Slot2/RiotShield.dec` defines `RiotShieldModeFlashPunching`,
which is entered when the player is in active shield mode. It ends with `Stop`
on purpose. Targeting `ReadyShield` (a loop state) from PSP_FLASH would have
the same "stuck parallel psprite" problem the old layer‑4 dispatch had —
`ReadyShield` is designed to loop on PSP_WEAPON forever, so it would also loop
forever on PSP_FLASH. The exit clear in `QuickMelee` would eventually save it,
but the `Stop` is cleaner and is preserved deliberately; the file header
comment explains this for the next porter.

**Rule of thumb:** any ready state that is a `Loop` (not a one‑shot that
`Goto`s back to another ready) should still be terminated with `Stop` if reached
from PSP_FLASH, *unless* you are prepared to rely solely on the `QuickMelee`
exit clear to destroy it — which you usually aren't, because a weapon can be
selected/deselected or a new ready state entered by other means before that
exit fires.

## 7. Files touched by the fold

| File | Change |
| --- | --- |
| `actors/Weapons/BaseWeapon.dec` | `GoMeleeInstead`: `A_Overlay(4, ...)` → `A_Overlay(PSP_FLASH, ...)` with entry clear `A_ClearOverlays(PSP_FLASH, PSP_FLASH, false)`; `QuickMelee` exit: added matching clear with `safety=false` before `Goto Ready3`. |
| `zscript/Weapons/BaseWeapon.zc` | Same two changes in the ZScript `QuickMelee` fallback. Both clears pass `safety=false` (see §4a — non‑obvious but required). |
| `zscript/Weapons/Slot1/BeamKatana_Weapon.zs` | `QuickMelee` override already used `PSP_FLASH`; added matching `A_ClearOverlays(PSP_FLASH, PSP_FLASH, false)` at exit. `FlashPunching` now ends `Goto Ready3;` (was `Stop;`). |
| `zscript/Weapons/Slot1/ArgentSith_Weapon.zs` | Same as BeamKatana. |
| `zscript/Weapons/Slot3/CSSG/CSSG.zs` | `FlashPunching` end: `Stop;` → `Goto Ready3;`. |
| `zscript/Weapons/Slot4/BattleRifle/BDPBattleRifle.zs` | Same as CSSG. |
| `zscript/Weapons/Slot4/NeoHMG/NeoHMG.zs` | Same as CSSG. |
| `zscript/Weapons/Slot6/Excavator/PB_Excavator.zs` | Same as CSSG. |
| `actors/Weapons/Slot2/RiotShield.dec` | Comment refresh; code behaviour unchanged — `RiotShieldModeFlashPunching` still ends with `Stop;` because its ready target `ReadyShield` is a loop state. |
| `AGENTS.md` | Added a bullet under the ZScript‑only‑weapons section that documents the PSP_FLASH rule and the two‑clear pattern. |

## 8. In‑game test checklist

1. **DECORATE weapons (SSG, pistol, rifle, BFG, etc.):** punch a zombie repeatedly. No duplicate/ghost weapon sprite during the swing, during the settle frames, or after the swing ends.
2. **Six ZScript weapons** (`PB_CSSG`, `BDPBattleRifle`, `PB_NeoHMG`, `PB_Excavator`, `TheShieldKatana` / BeamKatana, `ArgentSith`): same.
3. **Barrel grabs** (`GrabbedBarrel`, `GrabbedFlameBarrel`, `GrabbedIceBarrel`): with `BeamKatana` / `ArgentSith`, punch while holding a barrel. Should jump to `FlashBarrelPunching` as before — the change is above that branch.
4. **RiotShield in shield mode** (`ShieldModeA == 1`): punch. Shield animation plays and returns to `ReadyShield` cleanly; no duplicate raised‑shield sprite.
5. **Alt‑hold shields / barrier psprites** on `PB_NeoHMG`, `PB_ArgentSith`, `PB_BeamKatana`: after punching, switch to alt‑fire and verify the barrier/shield still engages — this was the original motivation for letting `FlashPunching` terminate in `Ready3` so `DoEffect()` keeps running.

## 9. Further reading

- [`A_Overlay`](https://zdoom.org/wiki/A_Overlay) — spawns an independent psprite on a given layer.
- [`A_ClearOverlays`](https://zdoom.org/wiki/A_ClearOverlays) — destroys psprites on a range of layers (except the caller's).
- [Weapon states](https://zdoom.org/wiki/Weapon_states) — `Ready`, `Fire`, `Flash`, etc.
- UZDoom psprite code (engine reference): <https://github.com/UZDoom/UZDoom/tree/4.14.3/src/playsim/p_pspr.cpp>. Search that file for `A_ClearOverlays` to see the `safety` branch first‑hand (§4a).
- PB Staging reference tree: `…/PBv0.3.X_Final-PBWP-Addons/01 Project_Brutality-PB_Staging/Project_Brutality-PB_Staging/actors/Weapons/BaseWeapon.dec` — see `GoMeleeInstead` near line 707.
