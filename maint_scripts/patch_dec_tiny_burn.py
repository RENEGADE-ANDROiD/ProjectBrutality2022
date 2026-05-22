import re
from pathlib import Path

root = Path(__file__).resolve().parent.parent / "actors" / "Monsters"
pat = re.compile(
    r'TNT1 A 0 A_SpawnItemEx\s*\(\s*"TinyBurningPiece"\s*,\s*random\s*\(\s*-15\s*,\s*15\s*\)\s*,\s*random\s*\(\s*-15\s*,\s*15\s*\)\s*\)\s*\n'
    r'\s*TNT1 A 0 A_SpawnItemEx\s*\(\s*"TinyBurningPiece2"\s*,\s*random\s*\(\s*-35\s*,\s*35\s*\)\s*,\s*random\s*\(\s*-35\s*,\s*35\s*\)\s*\)\s*\n'
    r'\s*TNT1 A 0 A_SpawnItemEx\s*\(\s*"TinyBurningPiece3"\s*,\s*random\s*\(\s*-45\s*,\s*45\s*\)\s*,\s*random\s*\(\s*-45\s*,\s*35\s*\)\s*\)',
    re.M,
)
sub = "TNT1 A 0 A_PB_BurnFX_TinyBurningPieces()"
n = 0
for path in root.rglob("*.dec"):
    text = path.read_text(encoding="utf-8", errors="replace")
    text2, c = pat.subn(sub, text)
    if c:
        path.write_text(text2, encoding="utf-8", newline="\n")
        print(f"{path.name}: {c}")
        n += c
print(f"total {n}")
