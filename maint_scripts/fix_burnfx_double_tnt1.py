"""Fix 'TNT1 A 0 TNT1 ...' double-prefix and merged TinyBurningPiece3 lines from burn-FX revert."""
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SCAN = [ROOT / "actors" / "Monsters", ROOT / "zscript" / "Monsters"]

LABEL_RE = re.compile(r"^\s*([\w.]+):\s*$")
DOUBLE_TNT1 = re.compile(r"TNT1 A 0 TNT1 ")

MERGED_TINY = re.compile(
    r'^(\s*TNT1 A 0 A_SpawnItemEx \("TinyBurningPiece3", random \(-45, 45\), random \(-45, 35\)\))\s+(TNT1\s+.*)$'
)


def process_file(path: Path) -> int:
    lines = path.read_text(encoding="utf-8", errors="replace").splitlines(keepends=True)
    out = []
    dbl = 0
    i = 0
    while i < len(lines):
        line = lines[i]

        if DOUBLE_TNT1.search(line):
            line = DOUBLE_TNT1.sub("TNT1 ", line)
            dbl += 1

        m = MERGED_TINY.match(line.rstrip("\r\n"))
        if m:
            indent = m.group(1)[: len(m.group(1)) - len(m.group(1).lstrip())]
            out.append(f"{m.group(1)}\n")
            out.append(f"{indent}{m.group(2)}\n")
            i += 1
            continue

        out.append(line)
        i += 1

    if dbl:
        path.write_text("".join(out), encoding="utf-8", newline="\n")
        print(f"{path.relative_to(ROOT)}: dbl={dbl}")
    return dbl


def main():
    td = 0
    for root in SCAN:
        for path in root.rglob("*"):
            if path.suffix.lower() not in (".dec", ".zc", ".zs"):
                continue
            td += process_file(path)
    print(f"total double-prefix fixes={td}")


if __name__ == "__main__":
    main()
