"""Repair ZScript lines broken by burn-FX revert (missing semicolons, merged states)."""
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent / "zscript" / "Monsters"

MERGED_TINY = re.compile(
    r'^(\s*TNT1 A 0 A_SpawnItemEx \("TinyBurningPiece3", random \(-45, 45\), random \(-45, 35\)\))\s+(\S.*)$'
)


def fix_file(path: Path) -> int:
    lines = path.read_text(encoding="utf-8", errors="replace").splitlines(keepends=True)
    out = []
    n = 0
    for line in lines:
        m = MERGED_TINY.match(line.rstrip("\r\n"))
        if m:
            indent = m.group(1)[: len(m.group(1)) - len(m.group(1).lstrip())]
            out.append(f"{m.group(1)};\n")
            out.append(f"{indent}{m.group(2)}\n")
            n += 1
            continue
        if (
            'A_SpawnItemEx ("TinyBurningPiece' in line
            and not line.rstrip().endswith(";")
            and "A_PB_BurnFX" not in line
        ):
            out.append(line.rstrip() + ";\n")
            n += 1
            continue
        if "A_PB_BurnFX_RealisticFireSparks1(8)" in line and "Trite" in str(path):
            indent = line[: len(line) - len(line.lstrip())]
            out.append(
                f'{indent}TNT1 A 0 A_SpawnItemEx ("RealisticFireSparks1", random (-2, 2), random (-2, 2), 8, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);\n'
            )
            n += 1
            continue
        out.append(line)
    if n:
        path.write_text("".join(out), encoding="utf-8", newline="\n")
        print(f"{path.name}: {n}")
    return n


def main():
    total = 0
    for path in ROOT.rglob("*.zc"):
        total += fix_file(path)
    print(f"fixed {total}")


if __name__ == "__main__":
    main()
