# Restore full DECORATE PB_Weapon blocks from pre-ZScript-port commit (default: fdc95b6b0).
# Usage: .\maint_scripts\Restore-DecorateWeapons.ps1 -Weapons HellPistoler,Paingiver,BioAcidLauncher,PB_DemonExterminator,OldHMG

param(
    [string]$Commit = 'fdc95b6b0',
    [string[]]$Weapons = @(
        'HellPistoler',
        'Paingiver',
        'BioAcidLauncher',
        'PB_DemonExterminator',
        'OldHMG',
        'BHGen'
    )
)

$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path

$map = @{
    HellPistoler         = 'actors/Weapons/Slot2/HellPistoler.dec'
    Paingiver            = 'actors/Weapons/Slot5/Paingiver.dec'
    BioAcidLauncher      = 'actors/Weapons/Slot8/BioAcidLauncher.dec'
    PB_DemonExterminator = 'actors/Weapons/Slot9/DemonExterminator.dec'
    OldHMG               = 'actors/Weapons/Slot4/OldHMG.dec'
    BHGen                = 'actors/Weapons/Slot8/BLACKHOLE.dec'
}

foreach ($w in $Weapons) {
    if (-not $map.ContainsKey($w)) { throw "Unknown weapon: $w" }
    $rel = $map[$w]
    $out = Join-Path $root ($rel -replace '/', '\')
    $content = git -C $root show "${Commit}:$rel"
    if (-not $content) { throw "git show failed for $rel @ $Commit" }
    [System.IO.File]::WriteAllText($out, ($content -join "`n").Replace("`n", "`r`n"))
    Write-Host "Restored $w -> $rel"
}

Write-Host 'Done. Remove matching #include lines from ZSCRIPT.zc and delete zscript/Weapons/*/*.zs if reverting ports.'
