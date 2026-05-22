"""Revert A_PB_BurnFX_* on DECORATE actors that do not inherit PB_Monster (ZScript actions)."""
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
MONSTERS = ROOT / "actors" / "Monsters"

ACTOR_RE = re.compile(
    r"^\s*(?:ACTOR|Actor)\s+(\w+)(?:\s*:\s*(\w+))?",
    re.I,
)
LABEL_RE = re.compile(r"^\s*([\w.]+):\s*$")
BURNFX_RE = re.compile(r"A_PB_BurnFX_(\w+)(?:\(([^)]*)\))?")

# Import revert helpers from sibling script
import importlib.util

_spec = importlib.util.spec_from_file_location(
    "fix_bad_burnfx_patch",
    Path(__file__).resolve().parent / "fix_bad_burnfx_patch.py",
)
_mod = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(_mod)
revert_action = _mod.revert_action


def build_parent_map() -> dict[str, str]:
    parents: dict[str, str] = {}
    for path in MONSTERS.rglob("*.dec"):
        for line in path.read_text(encoding="utf-8", errors="replace").splitlines():
            m = ACTOR_RE.match(line)
            if m:
                parents[m.group(1)] = m.group(2) or ""
    return parents


def inherits_pb_monster(name: str, parents: dict[str, str], cache: dict[str, bool]) -> bool:
    if name in cache:
        return cache[name]
    if name == "PB_Monster":
        cache[name] = True
        return True
    par = parents.get(name)
    if not par:
        cache[name] = False
        return False
    result = inherits_pb_monster(par, parents, cache)
    cache[name] = result
    return result


FULL_BURST = re.compile(
    r"TNT1 A 0 A_PB_BurnFX_Explosion(Heavy|VeryFast)Burst\(([^)]*)\)"
)
FULL_SPARKS = re.compile(r"TNT1 A 0 A_PB_BurnFX_RealisticFireSparks1\((\d+)\)")
FULL_TINY = re.compile(r"TNT1 A 0 A_PB_BurnFX_TinyBurningPieces\(\)")
EMBER_ON_LINE = re.compile(
    r"A_PB_BurnFX_BurningEmberBigger\((\d+)\)"
)
PLASMA_ON_LINE = re.compile(r"A_PB_BurnFX_PlasmaSmoke\((\d+)\)")


def process_line(line: str, can_throttle: bool) -> tuple[str, int]:
    if "A_PB_BurnFX_" not in line or can_throttle:
        return line, 0

    n = 0
    new_line = line

    if FULL_TINY.search(new_line):
        indent = new_line[: len(new_line) - len(new_line.lstrip())]
        new_line = (
            f'{indent}TNT1 A 0 A_SpawnItemEx ("TinyBurningPiece", random (-15, 15), random (-15, 15))\n'
            f'{indent}TNT1 A 0 A_SpawnItemEx ("TinyBurningPiece2", random (-35, 35), random (-35, 35))\n'
            f'{indent}TNT1 A 0 A_SpawnItemEx ("TinyBurningPiece3", random (-45, 45), random (-45, 35))'
        )
        if not line.endswith("\n"):
            new_line += "\n"
        n += 1
    else:
        def repl_burst(m: re.Match) -> str:
            kind, args = m.group(1), m.group(2)
            return revert_action(f"Explosion{kind}Burst", args) or m.group(0)

        nl2 = FULL_BURST.sub(repl_burst, new_line)
        if nl2 != new_line:
            n += 1
            new_line = nl2

        def repl_sparks(m: re.Match) -> str:
            return revert_action("RealisticFireSparks1", m.group(1)) or m.group(0)

        nl2 = FULL_SPARKS.sub(repl_sparks, new_line)
        if nl2 != new_line:
            n += 1
            new_line = nl2

        def repl_ember(m: re.Match) -> str:
            return revert_action("BurningEmberBigger", m.group(1)) or m.group(0)

        nl2 = EMBER_ON_LINE.sub(repl_ember, new_line)
        if nl2 != new_line:
            n += 1
            new_line = nl2

        def repl_plasma(m: re.Match) -> str:
            return revert_action("PlasmaSmoke", m.group(1)) or m.group(0)

        nl2 = PLASMA_ON_LINE.sub(repl_plasma, new_line)
        if nl2 != new_line:
            n += 1
            new_line = nl2
    return split_merged_tiny_line(new_line), n


def split_merged_tiny_line(line: str) -> str:
    """TinyBurningPiece3 + next state on one physical line (bad bulk revert)."""
    if 'TinyBurningPiece3"' not in line:
        return line
    m = re.search(r"(?<=\))\s+(TNT1\s)", line)
    if not m:
        return line
    head = line[: m.start()].rstrip()
    tail = line[m.start() :].lstrip()
    indent = line[: len(line) - len(line.lstrip())]
    out = head + "\n" + indent + tail
    return out + ("\n" if line.endswith("\n") else "")


def process_file(path: Path, parents: dict[str, str], cache: dict[str, bool]) -> int:
    lines = path.read_text(encoding="utf-8", errors="replace").splitlines(keepends=True)
    out = []
    n = 0
    actor = ""
    for line in lines:
        m = ACTOR_RE.match(line)
        if m and "{" not in line.split("//")[0]:
            actor = m.group(1)
        can = inherits_pb_monster(actor, parents, cache) if actor else False
        new_line, ch = process_line(line, can)
        n += ch
        split_line = split_merged_tiny_line(new_line)
        if split_line != new_line:
            new_line = split_line
            n += 1
        if "\n" in new_line and new_line != line:
            out.extend(new_line.splitlines(keepends=True))
        else:
            out.append(new_line)
    if n:
        path.write_text("".join(out), encoding="utf-8", newline="\n")
        print(f"{path.relative_to(ROOT)}: {n}")
    return n


def main():
    parents = build_parent_map()
    cache: dict[str, bool] = {}
    total = 0
    for path in sorted(MONSTERS.rglob("*.dec")):
        total += process_file(path, parents, cache)
    print(f"reverted {total} lines on non-PB_Monster actors")


if __name__ == "__main__":
    main()
