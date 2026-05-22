# Throttle Death.Incinerate / fire-death spawns on PB_Monster actors.
$roots = @(
    (Join-Path $PSScriptRoot '..\actors\Monsters'),
    (Join-Path $PSScriptRoot '..\zscript\Monsters')
)
$files = foreach ($r in $roots) {
    Get-ChildItem -LiteralPath $r -Recurse -File -Include '*.dec','*.zc','*.zs' -ErrorAction SilentlyContinue
}

$tripleTiny = @(
    'TNT1 A 0 A_SpawnItemEx("TinyBurningPiece", random (-15, 15), random (-15, 15))',
    'TNT1 A 0 A_SpawnItemEx("TinyBurningPiece2", random (-35, 35), random (-35, 35))',
    'TNT1 A 0 A_SpawnItemEx("TinyBurningPiece3", random (-45, 45), random (-45, 35))'
) -join "`r?`n"
$tripleTinyAlt = @(
    'TNT1 A 0 A_SpawnItemEx ("TinyBurningPiece", random (-15, 15), random (-15, 15))',
    'TNT1 A 0 A_SpawnItemEx ("TinyBurningPiece2", random (-35, 35), random (-35, 35))',
    'TNT1 A 0 A_SpawnItemEx ("TinyBurningPiece3", random (-45, 45), random (-45, 35))'
) -join "`r?`n"

foreach ($f in $files) {
    $c = [System.IO.File]::ReadAllText($f.FullName)
    $orig = $c

    $c = [regex]::Replace($c, $tripleTiny, 'TNT1 A 0 A_PB_BurnFX_TinyBurningPieces()')
    $c = [regex]::Replace($c, $tripleTinyAlt, 'TNT1 A 0 A_PB_BurnFX_TinyBurningPieces()')

    $c = [regex]::Replace($c,
        'TNT1 A 0 A_SpawnItemEx\s*\(\s*"RealisticFireSparks1"\s*,\s*random\s*\(\s*-2\s*,\s*2\s*\)\s*,\s*random\s*\(\s*-2\s*,\s*2\s*\)\s*,\s*(\d+)\s*,\s*0\s*,\s*0\s*,\s*0\s*,\s*0\s*,\s*SXF_NOCHECKPOSITION\s*,\s*0\s*\)',
        'TNT1 A 0 A_PB_BurnFX_RealisticFireSparks1($1)')
    $c = [regex]::Replace($c,
        'TNT1 A 0 A_SpawnItemEx\s*\(\s*"RealisticFireSparks1"\s*,\s*random\s*\(\s*-2\s*,\s*2\s*\)\s*,\s*random\s*\(\s*-2\s*,\s*2\s*\)\s*,\s*(\d+)\s*,\s*0\s*,\s*0\s*,\s*0\s*,\s*0\s*,\s*SXF_NOCHECKPOSITION\s*\)',
        'TNT1 A 0 A_PB_BurnFX_RealisticFireSparks1($1)')

    $c = [regex]::Replace($c,
        'TNT1 AAAAAA 0 A_CustomMissile\s*\(\s*"ExplosionParticleHeavy"\s*,\s*(\d+)\s*,',
        'TNT1 A 0 A_PB_BurnFX_ExplosionHeavyBurst($1, 6)')
    $c = [regex]::Replace($c,
        'TNT1 AAAAA 0 A_CustomMissile\s*\(\s*"ExplosionParticleHeavy"\s*,\s*(\d+)\s*,',
        'TNT1 A 0 A_PB_BurnFX_ExplosionHeavyBurst($1, 5)')
    $c = [regex]::Replace($c,
        'TNT1 AAAA 0 A_CustomMissile\s*\(\s*"ExplosionParticleHeavy"\s*,\s*(\d+)\s*,',
        'TNT1 A 0 A_PB_BurnFX_ExplosionHeavyBurst($1, 4)')
    $c = [regex]::Replace($c,
        'TNT1 AAA 0 A_CustomMissile\s*\(\s*"ExplosionParticleHeavy"\s*,\s*(\d+)\s*,',
        'TNT1 A 0 A_PB_BurnFX_ExplosionHeavyBurst($1, 3)')

    $c = [regex]::Replace($c,
        'TNT1 AAAAAA 0 A_CustomMissile\s*\(\s*"ExplosionParticleVeryFast"\s*,\s*(\d+)\s*,',
        'TNT1 A 0 A_PB_BurnFX_ExplosionVeryFastBurst($1, 6)')
    $c = [regex]::Replace($c,
        'TNT1 AAAAA 0 A_CustomMissile\s*\(\s*"ExplosionParticleVeryFast"\s*,\s*(\d+)\s*,',
        'TNT1 A 0 A_PB_BurnFX_ExplosionVeryFastBurst($1, 5)')
    $c = [regex]::Replace($c,
        'TNT1 AAAA 0 A_CustomMissile\s*\(\s*"ExplosionParticleVeryFast"\s*,\s*(\d+)\s*,',
        'TNT1 A 0 A_PB_BurnFX_ExplosionVeryFastBurst($1, 4)')
    $c = [regex]::Replace($c,
        'TNT1 AAA 0 A_CustomMissile\s*\(\s*"ExplosionParticleVeryFast"\s*,\s*(\d+)\s*,',
        'TNT1 A 0 A_PB_BurnFX_ExplosionVeryFastBurst($1, 3)')

    $c = [regex]::Replace($c,
        'TNT1 AAAA 0 A_SpawnProjectile\s*\(\s*"ExplosionParticleHeavy"\s*,\s*(\d+)\s*,\s*0\s*,\s*random\s*\([^)]+\)\s*,\s*CMF_[^)]+\)\s*,\s*random\s*\([^)]+\)\s*\)',
        'TNT1 A 0 A_PB_BurnFX_ExplosionHeavyBurst($1, 4)')
    $c = [regex]::Replace($c,
        'TNT1 AAAA 0 A_SpawnProjectile\s*\(\s*"ExplosionParticleVeryFast"\s*,\s*(\d+)\s*,\s*0\s*,\s*random\s*\([^)]+\)\s*,\s*CMF_[^)]+\)\s*,\s*random\s*\([^)]+\)\s*\)',
        'TNT1 A 0 A_PB_BurnFX_ExplosionVeryFastBurst($1, 4)')

    $c = [regex]::Replace($c,
        'A_CustomMissile\s*\(\s*"BurningEmberParticlesFloating_Bigger"\s*,\s*(\d+)\s*,\s*0\s*,\s*random\s*\(\s*0\s*,\s*360\s*\)\s*,\s*2\s*,\s*random\s*\(\s*0\s*,\s*160\s*\)\s*\)',
        'A_PB_BurnFX_BurningEmberBigger($1)')
    $c = [regex]::Replace($c,
        'A_SpawnProjectile\s*\(\s*"BurningEmberParticlesFloating_Bigger"\s*,\s*(\d+)\s*,\s*0\s*,\s*random\s*\(\s*0\s*,\s*360\s*\)\s*,\s*CMF_[^)]+\)\s*,\s*random\s*\(\s*0\s*,\s*160\s*\)\s*\)',
        'A_PB_BurnFX_BurningEmberBigger($1)')

    # PlasmaSmoke only on same line as IncinerationGlow (see fix_bad_plasma_patch.py).
    $c = [regex]::Replace($c,
        '(?m)(^.*IncinerationGlow.*)\sA_CustomMissile\s*\(\s*"PlasmaSmoke"\s*,\s*(\d+)\s*,\s*0\s*,\s*random\s*\([^)]+\)\s*,\s*2\s*,\s*random\s*\([^)]+\)\s*\)',
        '${1} A_PB_BurnFX_PlasmaSmoke($2)')

    $c = [regex]::Replace($c,
        'TNT1 AAAA 0 A_SpawnProjectile\s*\(\s*"ExplosionParticleHeavy"\s*,\s*32\s*,\s*0\s*,\s*random\s*\([^)]+\)\s*,\s*CMF_[^)]+\)\s*,\s*random\s*\([^)]+\)\s*\)',
        'TNT1 A 0 A_PB_BurnFX_ExplosionHeavyBurst(32, 4)')
    $c = [regex]::Replace($c,
        'TNT1 AAAA 0 A_SpawnProjectile\s*\(\s*"ExplosionParticleVeryFast"\s*,\s*32\s*,\s*0\s*,\s*random\s*\([^)]+\)\s*,\s*CMF_[^)]+\)\s*,\s*random\s*\([^)]+\)\s*\)',
        'TNT1 A 0 A_PB_BurnFX_ExplosionVeryFastBurst(32, 4)')

    if ($c -ne $orig) {
        [System.IO.File]::WriteAllText($f.FullName, $c)
        Write-Host "Patched $($f.FullName)"
    }
}

Write-Host 'Done.'
