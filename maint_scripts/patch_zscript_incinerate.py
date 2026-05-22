import re
from pathlib import Path

root = Path(__file__).resolve().parent.parent / "zscript" / "Monsters"
cmf = r"CMF_AIMDIRECTION\|CMF_ABSOLUTEPITCH\|CMF_OFFSETPITCH\|CMF_BADPITCH\|CMF_SAVEPITCH"

repls = [
    (
        re.compile(
            rf'TNT1 AAAA 0 A_SpawnProjectile \("ExplosionParticleHeavy", 32, 0, random \(0, 360\), {cmf}, random \(0, 360\)\);',
            re.M,
        ),
        "TNT1 A 0 A_PB_BurnFX_ExplosionHeavyBurst(32, 4);",
    ),
    (
        re.compile(
            rf'TNT1 AAAA 0 A_SpawnProjectile \("ExplosionParticleVeryFast", 32, 0, random \(0, 360\), {cmf}, random \(0, 360\)\);',
            re.M,
        ),
        "TNT1 A 0 A_PB_BurnFX_ExplosionVeryFastBurst(32, 4);",
    ),
    (
        re.compile(
            rf'TNT1 AAAA 0 A_SpawnProjectile \("ExplosionParticleHeavy", 32, 0, random \(0, 360\), {cmf}  , random \(0, 360\)\);',
            re.M,
        ),
        "TNT1 A 0 A_PB_BurnFX_ExplosionHeavyBurst(32, 4);",
    ),
    (
        re.compile(
            rf'TNT1 AAAA 0 A_SpawnProjectile \("ExplosionParticleVeryFast", 32, 0, random \(0, 360\), {cmf}  , random \(0, 360\)\);',
            re.M,
        ),
        "TNT1 A 0 A_PB_BurnFX_ExplosionVeryFastBurst(32, 4);",
    ),
    (
        re.compile(
            r'TNT1 A 0 A_SpawnItemEx\("TinyBurningPiece", random \(-15, 15\), random \(-15, 15\)\);\s*\n\s*TNT1 A 0 A_SpawnItemEx\("TinyBurningPiece2", random \(-35, 35\), random \(-35, 35\)\);\s*\n\s*TNT1 A 0 A_SpawnItemEx\("TinyBurningPiece3", random \(-45, 45\), random \(-45, 35\)\);',
            re.M,
        ),
        "TNT1 A 0 A_PB_BurnFX_TinyBurningPieces();",
    ),
    (
        re.compile(
            rf'A_SpawnProjectile \("BurningEmberParticlesFloating_Bigger", (\d+), 0, random \(0, 360\), {cmf}, random \(0, 160\)\)',
            re.M,
        ),
        r"A_PB_BurnFX_BurningEmberBigger(\1)",
    ),
    (
        re.compile(
            rf'A_SpawnProjectile \("BurningEmberParticlesFloating_Bigger", (\d+), 0, random \(0, 360\), {cmf}  , random \(0, 160\)\)',
            re.M,
        ),
        r"A_PB_BurnFX_BurningEmberBigger(\1)",
    ),
    (
        re.compile(
            rf'Z8RN HHHH 2 Light\("IncinerationGlow"\) A_SpawnProjectile \("PlasmaSmoke", 14, 0, random \(0, 360\), {cmf}, random \(0, 160\)\)',
            re.M,
        ),
        'Z8RN HHHH 2 Light("IncinerationGlow") A_PB_BurnFX_PlasmaSmoke(14)',
    ),
    (
        re.compile(
            rf'Z8RN HHHHHH 12 A_SpawnProjectile \("PlasmaSmoke", 14, 0, random \(0, 360\), {cmf}, random \(0, 160\)\)',
            re.M,
        ),
        "Z8RN HHHHHH 12 A_PB_BurnFX_PlasmaSmoke(14)",
    ),
]

# Z8RN / T6SB / etc. ember lines on incinerate frames
ember_pat = re.compile(
    rf'([A-Z0-9]+ [A-Z]+ \d+ BRIGHT Light\("IncinerationGlow"\) )A_SpawnProjectile \("BurningEmberParticlesFloating_Bigger", (\d+), 0, random \(0, 360\), {cmf}(  )?, random \(0, 160\)\)',
    re.M,
)
ember_sub = r"\1A_PB_BurnFX_BurningEmberBigger(\2)"

for path in root.rglob("*.zc"):
    text = path.read_text(encoding="utf-8", errors="replace")
    orig = text
    for pat, sub in repls[:8]:
        text = pat.sub(sub, text)
    text = ember_pat.sub(ember_sub, text)
    if text != orig:
        path.write_text(text, encoding="utf-8", newline="\n")
        print(path.name)

print("done")
