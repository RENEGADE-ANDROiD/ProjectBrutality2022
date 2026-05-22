import re
from pathlib import Path

roots = [
    Path(__file__).resolve().parent.parent / "actors",
    Path(__file__).resolve().parent.parent / "zscript",
]

# Revert mistaken PlasmaSmoke swaps (not on Death.Incinerate glow lines).
revert_pat = re.compile(r"A_PB_BurnFX_PlasmaSmoke\((\d+)\)")
keep_pat = re.compile(
    r"IncinerationGlow.*A_PB_BurnFX_PlasmaSmoke\(\d+\)|"
    r"\s12\s+A_PB_BurnFX_PlasmaSmoke\(14\)|"
    r"JJJJJJJ\s+12\s+A_PB_BurnFX_PlasmaSmoke|"
    r"HHHHHH\s+12\s+A_PB_BurnFX_PlasmaSmoke|"
    r"IIIIIII\s+12\s+A_PB_BurnFX_PlasmaSmoke|"
    r"EEEEEEE\s+12\s+A_PB_BurnFX_PlasmaSmoke|"
    r"HHHHHHHHH\s+12\s+A_PB_BurnFX_PlasmaSmoke|"
    r"KKKKKKKKK\s+12\s+A_PB_BurnFX_PlasmaSmoke",
    re.I,
)

def repl(m, line):
    h = m.group(1)
    # height 1 on projectiles often used 360 random; incinerate uses 160
    ang = "random (0, 360)" if h == "1" else "random (0, 160)"
    return f'A_CustomMissile ("PlasmaSmoke", {h}, 0, {ang}, 2, {ang})'

n = 0
for root in roots:
    for path in root.rglob("*"):
        if path.suffix.lower() not in (".dec", ".zc", ".zs"):
            continue
        lines = path.read_text(encoding="utf-8", errors="replace").splitlines(True)
        out = []
        changed = False
        for line in lines:
            if "A_PB_BurnFX_PlasmaSmoke" not in line:
                out.append(line)
                continue
            if keep_pat.search(line):
                out.append(line)
                continue
            new_line = revert_pat.sub(lambda m: repl(m, line), line)
            if new_line != line:
                n += 1
                changed = True
            out.append(new_line)
        if changed:
            path.write_text("".join(out), encoding="utf-8", newline="\n")
            print(path.relative_to(path.parent.parent.parent))

print(f"reverted {n} bad plasma lines")
