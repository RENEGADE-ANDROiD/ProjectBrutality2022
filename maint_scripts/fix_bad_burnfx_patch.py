"""Revert mistaken A_PB_BurnFX_* from bulk incinerate patch (non-Death.Incinerate / non-PB_Monster)."""
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SCAN = [ROOT / "actors" / "Monsters", ROOT / "zscript" / "Monsters"]
SKIP = {
    ROOT / "actors" / "Gore" / "BURN.dec",
    ROOT / "zscript" / "Monsters" / "PBMonster.zc",
    ROOT / "zscript" / "Gore" / "PB_BurnFXThrottle.zc",
}

LABEL_RE = re.compile(r"^\s*([\w.]+):\s*$")
ACTOR_RE = re.compile(r"^\s*(?:ACTOR|Actor)\s+(\w+)\b", re.I)
PB_PARENT_RE = re.compile(r":\s*PB_", re.I)
ZS_PARENT_RE = re.compile(r"\bextends\s+PB_Monster\b", re.I)

# Trailing junk after Burst(...) from a failed corruption cleanup.
CORRUPT_BURST_RE = re.compile(
    r"A_PB_BurnFX_Explosion(Heavy|VeryFast)Burst\((\d+),\s*(\d+)\)\s+"
    r"([+-]?\d+),\s*random\s*\(0,\s*360\),\s*2,\s*random\s*\(0,\s*180\)\)"
)

BURNFX_RE = re.compile(r"A_PB_BurnFX_(\w+)(?:\(([^)]*)\))?")


def tnt_letters(count: int) -> str:
    n = max(1, min(int(count), 10))
    return "A" * n


def revert_action(name: str, args: str) -> str:
    args = (args or "").strip()
    if name == "TinyBurningPieces":
        return None  # handled as multi-line in process_line
    if name == "RealisticFireSparks1":
        z = args or "32"
        return (
            f'TNT1 A 0 A_SpawnItemEx ("RealisticFireSparks1", random (-2, 2), random (-2, 2), {z}, '
            "0, 0, 0, 0, SXF_NOCHECKPOSITION, 0)"
        )
    if name == "BurningEmberBigger":
        h = args or "32"
        return (
            f'A_CustomMissile ("BurningEmberParticlesFloating_Bigger", {h}, 0, '
            "random (0, 360), 2, random (0, 160))"
        )
    if name == "PlasmaSmoke":
        h = args or "14"
        return (
            f'A_CustomMissile ("PlasmaSmoke", {h}, 0, random (0, 360), 2, random (0, 160))'
        )
    if name in ("ExplosionHeavyBurst", "ExplosionVeryFastBurst"):
        parts = [p.strip() for p in args.split(",")] if args else ["32", "4"]
        h = parts[0] if parts else "32"
        c = parts[1] if len(parts) > 1 else "4"
        if not c.isdigit():
            c = "4"
        if not h.lstrip("-").isdigit():
            h = "32"
        missile = (
            "ExplosionParticleHeavy"
            if "Heavy" in name
            else "ExplosionParticleVeryFast"
        )
        ang = "random (0, 180)" if h == "0" else "random (0, 360)"
        return (
            f"TNT1 {tnt_letters(int(c))} 0 A_CustomMissile (\"{missile}\", {h}, 0, "
            f"{ang}, 2, {ang})"
        )
    if name == "ExplosionHeavy":
        h = args or "32"
        return (
            f'A_CustomMissile ("ExplosionParticleHeavy", {h}, 0, random (0, 360), 2, random (0, 360))'
        )
    if name == "ExplosionVeryFast":
        h = args or "32"
        return (
            f'A_CustomMissile ("ExplosionParticleVeryFast", {h}, 0, random (0, 360), 2, random (0, 360))'
        )
    return None


def is_incinerate_label(label: str) -> bool:
    return label is not None and "Incinerate" in label


def actor_is_pb_monster(decl: str, actor_name: str) -> bool:
    # Most roster actors inherit HellKnight/Demon/etc., not PB_Monster directly.
    if actor_name in NON_PB_ACTORS:
        return False
    if PB_PARENT_RE.search(decl) or ZS_PARENT_RE.search(decl):
        return True
    return True  # under actors/Monsters — treat as PB unless denylisted


NON_PB_ACTORS = frozenset(
    {
        "FireBall_",
        "FireBallWeapon",
        "RocketImpVictim",
        "KnightAttack",
        "IncinerateDyingD3Maledict1",
        "MaledictCometSupport",
    }
)


def process_line(
    line: str,
    in_incinerate: bool,
    pb_monster: bool,
) -> tuple[str, bool]:
    changed = False

    m = CORRUPT_BURST_RE.search(line)
    if m:
        kind, h, c, tail = m.group(1), m.group(2), m.group(3), m.group(4)
        # tail is ", 19, random..." or ", -19, random..."
        off = tail.strip().split(",", 1)[0].strip()
        missile = (
            "ExplosionParticleHeavy" if kind == "Heavy" else "ExplosionParticleVeryFast"
        )
        rep = (
            f"TNT1 {tnt_letters(int(c))} 0 A_CustomMissile (\"{missile}\", {h}, {off}, "
            "random (0, 360), 2, random (0, 180))"
        )
        line = CORRUPT_BURST_RE.sub(rep, line)
        changed = True

    if "A_PB_BurnFX_" not in line:
        return line, changed

    if "action void A_PB_BurnFX" in line or "int height" in line:
        return line, changed

    if in_incinerate and pb_monster:
        return line, changed

    if "A_PB_BurnFX_TinyBurningPieces()" in line:
        indent = line[: len(line) - len(line.lstrip())]
        rep = (
            f'{indent}TNT1 A 0 A_SpawnItemEx ("TinyBurningPiece", random (-15, 15), random (-15, 15))\n'
            f'{indent}TNT1 A 0 A_SpawnItemEx ("TinyBurningPiece2", random (-35, 35), random (-35, 35))\n'
            f'{indent}TNT1 A 0 A_SpawnItemEx ("TinyBurningPiece3", random (-45, 45), random (-45, 35))'
        )
        if not line.endswith("\n"):
            rep += "\n"
        return rep, True

    def repl(m: re.Match) -> str:
        name = m.group(1)
        args = m.group(2)
        new = revert_action(name, args)
        return new if new else m.group(0)

    new_line = BURNFX_RE.sub(repl, line)
    if new_line != line:
        changed = True
    return new_line, changed


def process_file(path: Path) -> int:
    if path.resolve() in {p.resolve() for p in SKIP}:
        return 0

    text = path.read_text(encoding="utf-8", errors="replace")
    lines = text.splitlines(keepends=True)
    out = []
    n = 0

    state = ""
    in_incinerate = False
    pb_monster = True
    actor_decl = ""

    for line in lines:
        stripped = line.strip()
        am = ACTOR_RE.match(line)
        if am and "{" not in stripped.split("//")[0]:
            actor_decl = line
            pb_monster = actor_is_pb_monster(actor_decl, am.group(1))
            in_incinerate = False
            state = ""

        lm = LABEL_RE.match(line)
        if lm:
            state = lm.group(1)
            in_incinerate = is_incinerate_label(state)

        new_line, changed = process_line(line, in_incinerate, pb_monster)
        if changed:
            n += 1
        if "\n" in new_line and new_line != line:
            out.extend(new_line.splitlines(keepends=True))
        else:
            out.append(new_line)

    if n:
        path.write_text("".join(out), encoding="utf-8", newline="\n")
        print(path.relative_to(ROOT))
    return n


def main():
    total = 0
    for root in SCAN:
        if not root.is_dir():
            continue
        for path in root.rglob("*"):
            if path.suffix.lower() not in (".dec", ".zc", ".zs"):
                continue
            total += process_file(path)
    print(f"reverted {total} lines")


if __name__ == "__main__":
    main()
