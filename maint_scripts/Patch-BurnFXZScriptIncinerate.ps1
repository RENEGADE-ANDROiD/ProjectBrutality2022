$dir = Join-Path $PSScriptRoot '..\zscript\Monsters'
$files = Get-ChildItem -LiteralPath $dir -Recurse -File -Include '*.zc','*.zs'
foreach ($f in $files) {
    $c = [System.IO.File]::ReadAllText($f.FullName)
    $orig = $c
    $c = [regex]::Replace($c,
        'TNT1 AAAA 0 A_SpawnProjectile\s*\(\s*"ExplosionParticleHeavy"\s*,\s*32\s*,\s*0\s*,\s*random\s*\([^)]+\)\s*,\s*CMF_[^)]+\)\s*,\s*random\s*\([^)]+\)\s*\)',
        'TNT1 A 0 A_PB_BurnFX_ExplosionHeavyBurst(32, 4)')
    $c = [regex]::Replace($c,
        'TNT1 AAAA 0 A_SpawnProjectile\s*\(\s*"ExplosionParticleVeryFast"\s*,\s*32\s*,\s*0\s*,\s*random\s*\([^)]+\)\s*,\s*CMF_[^)]+\)\s*,\s*random\s*\([^)]+\)\s*\)',
        'TNT1 A 0 A_PB_BurnFX_ExplosionVeryFastBurst(32, 4)')
    $c = [regex]::Replace($c,
        'TNT1 A 0 A_SpawnItemEx\("TinyBurningPiece", random \(-15, 15\), random \(-15, 15\)\)\s*\r?\n\s*TNT1 A 0 A_SpawnItemEx\("TinyBurningPiece2", random \(-35, 35\), random \(-35, 35\)\)\s*\r?\n\s*TNT1 A 0 A_SpawnItemEx\("TinyBurningPiece3", random \(-45, 45\), random \(-45, 35\)\)',
        'TNT1 A 0 A_PB_BurnFX_TinyBurningPieces()')
    $c = [regex]::Replace($c,
        'A_SpawnProjectile\s*\(\s*"BurningEmberParticlesFloating_Bigger"\s*,\s*(\d+)\s*,\s*0\s*,\s*random\s*\(\s*0\s*,\s*360\s*\)\s*,\s*CMF_[^)]+\)\s*,\s*random\s*\(\s*0\s*,\s*160\s*\)\s*\)',
        'A_PB_BurnFX_BurningEmberBigger($1)')
    $c = [regex]::Replace($c,
        'Z8RN HHHHHH 12 A_SpawnProjectile\s*\(\s*"PlasmaSmoke"\s*,\s*14\s*,\s*0\s*,\s*random\s*\([^)]+\)\s*,\s*CMF_[^)]+\)\s*,\s*random\s*\([^)]+\)\s*\)',
        'Z8RN HHHHHH 12 A_PB_BurnFX_PlasmaSmoke(14)')
    $c = [regex]::Replace($c,
        'Z8RN HHHH 2 Light\("IncinerationGlow"\) A_SpawnProjectile\s*\(\s*"PlasmaSmoke"\s*,\s*14\s*,\s*0\s*,\s*random\s*\([^)]+\)\s*,\s*CMF_[^)]+\)\s*,\s*random\s*\([^)]+\)\s*\)',
        'Z8RN HHHH 2 Light("IncinerationGlow") A_PB_BurnFX_PlasmaSmoke(14)')
    if ($c -ne $orig) {
        [System.IO.File]::WriteAllText($f.FullName, $c)
        Write-Host "Patched $($f.Name)"
    }
}
Write-Host 'ZScript incinerate patch done.'
