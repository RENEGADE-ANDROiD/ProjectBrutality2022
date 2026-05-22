$path = Join-Path $PSScriptRoot '..\actors\Gore\BURN.dec'
$c = Get-Content -LiteralPath $path -Raw
$c = [regex]::Replace($c, 'A_CustomMissile\s*\(\s*"BurnParticles"\s*,\s*(\d+)\s*,\s*0\s*,\s*random\s*\(\s*0\s*,\s*360\s*\)\s*,\s*2\s*,\s*random\s*\(\s*50\s*,\s*130\s*\)\s*\)', 'A_PB_BurnFX_BurnParticles($1)')
$c = [regex]::Replace($c, 'A_CustomMissile\s*\(\s*"BurnParticles"\s*,\s*(\d+)\s*,\s*0\s*,\s*random\s*\(\s*0\s*,\s*180\s*\)\s*,\s*2\s*,\s*random\s*\(\s*0\s*,\s*180\s*\)\s*\)', 'A_PB_BurnFX_BurnParticlesWide($1)')
$c = [regex]::Replace($c, 'A_CustomMissile\s*\(\s*"BurnParticles"\s*,\s*(\d+)\s*,\s*0\s*,\s*random\s*\([^)]+\)\s*,\s*2\s*,\s*random\s*\([^)]+\)\s*\)', 'A_PB_BurnFX_BurnParticles($1)')
$c = [regex]::Replace($c, 'A_CustomMissile\s*\(\s*"SmallBurnParticles"\s*,\s*(\d+)\s*,\s*0\s*,\s*random\s*\([^)]+\)\s*,\s*2\s*,\s*random\s*\([^)]+\)\s*\)', 'A_PB_BurnFX_SmallBurnParticles($1)')
$c = [regex]::Replace($c, 'A_CustomMissile\s*\(\s*"ExplosionParticleVerySlow"\s*,\s*(\d+)\s*,\s*0\s*,\s*random\s*\([^)]+\)\s*,\s*2\s*,\s*random\s*\([^)]+\)\s*\)', 'A_PB_BurnFX_ExplosionVerySlow($1)')
$c = [regex]::Replace($c, 'A_SpawnItemEx\s*\(\s*"TinyBurningPiece3"\s*,\s*random\s*\(\s*-15\s*,\s*15\s*\)\s*,\s*random\s*\(\s*-15\s*,\s*15\s*\)\s*\)', 'A_PB_BurnFX_TinyBurningPiece3()')
$c = [regex]::Replace($c, 'A_CustomMissile\s*\(\s*"BurnParticles"\s*,\s*random\s*\(\s*24\s*,\s*26\s*\)\s*,\s*random\s*\(\s*-4\s*,\s*4\s*\)\s*,\s*random\s*\(\s*0\s*,\s*360\s*\)\s*,\s*2\s*,\s*random\s*\(\s*50\s*,\s*130\s*\)\s*\)', 'A_PB_BurnFX_BurnParticlesVar(random(24,26), random(-4,4))')
$c = [regex]::Replace($c, 'A_CustomMissile\s*\(\s*"BurnParticles"\s*,\s*random\s*\(\s*20\s*,\s*26\s*\)\s*,\s*0\s*,\s*random\s*\(\s*0\s*,\s*360\s*\)\s*,\s*2\s*,\s*random\s*\(\s*50\s*,\s*130\s*\)\s*\)', 'A_PB_BurnFX_BurnParticles(random(20,26))')
[System.IO.File]::WriteAllText($path, $c)
Write-Host "Patched $path"
