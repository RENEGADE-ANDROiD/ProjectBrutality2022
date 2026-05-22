# Batch-convert remaining PB_Weapon actors to ZScript (skips RiotShield).
# Then Fix-ZScriptWeaponZs.ps1 and optional smoke (-Norun).

param(
    [string[]]$Only,
    [switch]$SkipSmoke,
    [switch]$SkipConvert
)

$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$convert = Join-Path $PSScriptRoot 'Convert-DecorateWeaponToZScript.ps1'
$fix = Join-Path $PSScriptRoot 'Fix-ZScriptWeaponZs.ps1'

$jobs = @(
    @{ Class = 'PB_MP40';       Dec = 'actors/Weapons/Slot2/MP40.dec';                    Zs = 'zscript/Weapons/Slot2/MP40/PB_MP40.zs' },
    @{ Class = 'PB_Pistol';     Dec = 'actors/Weapons/Slot2/PBPISTOL.dec';                Zs = 'zscript/Weapons/Slot2/Pistol/PB_Pistol.zs' },
    @{ Class = 'Rifle';         Dec = 'actors/Weapons/Slot4/PBRIFLE.dec';                 Zs = 'zscript/Weapons/Slot4/Rifle/Rifle.zs' },
    @{ Class = 'PB_LMG';        Dec = 'actors/Weapons/Slot4/LMG.dec';                     Zs = 'zscript/Weapons/Slot4/LMG/PB_LMG.zs' },
    @{ Class = 'PB_Nailgun';    Dec = 'actors/Weapons/Slot4/Nailgun.dec';                 Zs = 'zscript/Weapons/Slot4/Nailgun/PB_Nailgun.zs' },
    @{ Class = 'PB_XM21';       Dec = 'actors/Weapons/Slot4/XM21.dec';                    Zs = 'zscript/Weapons/Slot4/XM21/PB_XM21.zs' },
    @{ Class = 'PB_Fusil';      Dec = 'actors/Weapons/Slot4/PB_Fusil.dec';                Zs = 'zscript/Weapons/Slot4/Fusil/PB_Fusil.zs' },
    @{ Class = 'PB_SideFusil';  Dec = 'actors/Weapons/Slot4/PB_Fusil.dec';                Zs = 'zscript/Weapons/Slot4/Fusil/PB_SideFusil.zs' },
    @{ Class = 'ProSurv_Ballista'; Dec = 'actors/Weapons/Slot4/ProSurv_Ballista.dec';    Zs = 'zscript/Weapons/Slot4/Ballista/ProSurv_Ballista.zs' },
    @{ Class = 'MarauderSSG';   Dec = 'actors/Weapons/Slot3/MarauderSSG.dec';           Zs = 'zscript/Weapons/Slot3/MarauderSSG/MarauderSSG.zs' },
    @{ Class = 'X12Shotgun';    Dec = 'actors/Weapons/Slot3/X12Shotgun.dec';              Zs = 'zscript/Weapons/Slot3/X12Shotgun/X12Shotgun.zs' },
    @{ Class = 'PB_CryoASG';    Dec = 'actors/Weapons/Slot3/PB_CryoASG.dec';              Zs = 'zscript/Weapons/Slot3/CryoASG/PB_CryoASG.zs' },
    @{ Class = 'PB_M2Plasma';    Dec = 'actors/Weapons/Slot6/M2PLASMA.dec';                Zs = 'zscript/Weapons/Slot6/M2Plasma/PB_M2Plasma.zs' },
    @{ Class = 'PB_Freezer';    Dec = 'actors/Weapons/Slot7/FREEZER.dec';                 Zs = 'zscript/Weapons/Slot7/Freezer/PB_Freezer.zs' },
    @{ Class = 'PB_CryoElectroRifle'; Dec = 'actors/Weapons/Slot8/PB_CryoElectroRifle.dec'; Zs = 'zscript/Weapons/Slot8/CryoElectroRifle/PB_CryoElectroRifle.zs' },
    @{ Class = 'PB_BFG9000';    Dec = 'actors/Weapons/Slot8/BFGMKIV.dec';                Zs = 'zscript/Weapons/Slot8/BFG9000/PB_BFG9000.zs' },
    @{ Class = 'PB_Flamethrower'; Dec = 'actors/Weapons/Slot9/Flamethrower.dec';         Zs = 'zscript/Weapons/Slot9/Flamethrower/PB_Flamethrower.zs' },
    @{ Class = 'Hell_rifle';    Dec = 'actors/Weapons/Slot9/DemonTech.dec';               Zs = 'zscript/Weapons/Slot9/HellRifle/Hell_rifle.zs' },
    @{ Class = 'PB_Unmaker';    Dec = 'actors/Weapons/Slot9/Unmaker.dec';               Zs = 'zscript/Weapons/Slot9/Unmaker/PB_Unmaker.zs' },
    @{ Class = 'PB_CryoCannon'; Dec = 'actors/Weapons/Slot9/PB_CryoCannon.dec';          Zs = 'zscript/Weapons/Slot9/CryoCannon/PB_CryoCannon.zs' }
)

if ($Only) {
    $onlySet = @()
    foreach ($o in $Only) {
        if ($o -match ',') { $onlySet += $o.Split(',') | ForEach-Object { $_.Trim() } }
        else { $onlySet += $o.Trim() }
    }
    $jobs = $jobs | Where-Object { $onlySet -contains $_.Class }
}

$zsPaths = New-Object System.Collections.Generic.List[string]
foreach ($j in $jobs) {
    $decPath = Join-Path $root ($j.Dec -replace '/', '\')
    $zsPath = Join-Path $root ($j.Zs -replace '/', '\')
    if (-not (Test-Path -LiteralPath $decPath)) {
        Write-Warning "Skip $($j.Class): missing $decPath"
        continue
    }
    if (-not $SkipConvert) {
        Write-Host "Converting $($j.Class) ..."
        & $convert -DecPath $decPath -ClassName $j.Class -ZsPath $zsPath
        if (-not (Test-Path -LiteralPath $zsPath)) { throw "Convert did not write $zsPath for $($j.Class)" }
    }
    if (Test-Path -LiteralPath $zsPath) {
        [void]$zsPaths.Add($zsPath)
    }
}

if ($zsPaths.Count -gt 0) {
    Write-Host "Fix-ZScriptWeaponZs on $($zsPaths.Count) files ..."
    & $fix -Paths $zsPaths.ToArray()
}

# Patch ZSCRIPT.zc includes (idempotent block)
$zscript = Join-Path $root 'ZSCRIPT.zc'
$lines = Get-Content -LiteralPath $zscript -Encoding UTF8
$marker = '// === Remaining DECORATE weapon ports (auto) ==='
$start = [array]::IndexOf($lines, $marker)
$includeLines = @(
    $marker,
    '#include "zscript/Weapons/Slot2/MP40/PB_MP40.zs"',
    '#include "zscript/Weapons/Slot2/Pistol/PB_Pistol.zs"',
    '#include "zscript/Weapons/Slot4/Rifle/Rifle.zs"',
    '#include "zscript/Weapons/Slot4/LMG/PB_LMG.zs"',
    '#include "zscript/Weapons/Slot4/Nailgun/PB_Nailgun.zs"',
    '#include "zscript/Weapons/Slot4/XM21/PB_XM21.zs"',
    '#include "zscript/Weapons/Slot4/Fusil/PB_Fusil.zs"',
    '#include "zscript/Weapons/Slot4/Fusil/PB_SideFusil.zs"',
    '#include "zscript/Weapons/Slot4/Ballista/ProSurv_Ballista.zs"',
    '#include "zscript/Weapons/Slot3/MarauderSSG/MarauderSSG.zs"',
    '#include "zscript/Weapons/Slot3/X12Shotgun/X12Shotgun.zs"',
    '#include "zscript/Weapons/Slot3/CryoASG/PB_CryoASG.zs"',
    '#include "zscript/Weapons/Slot6/M2Plasma/PB_M2Plasma.zs"',
    '#include "zscript/Weapons/Slot7/Freezer/PB_Freezer.zs"',
    '#include "zscript/Weapons/Slot8/CryoElectroRifle/PB_CryoElectroRifle.zs"',
    '#include "zscript/Weapons/Slot8/BFG9000/PB_BFG9000.zs"',
    '#include "zscript/Weapons/Slot9/Flamethrower/PB_Flamethrower.zs"',
    '#include "zscript/Weapons/Slot9/HellRifle/Hell_rifle.zs"',
    '#include "zscript/Weapons/Slot9/Unmaker/PB_Unmaker.zs"',
    '#include "zscript/Weapons/Slot9/CryoCannon/PB_CryoCannon.zs"'
)
$anchor = '#include "zscript/Weapons/Slot8/PB_DarkMatterRifle/PB_DarkMatterRifle.zs"'
$anchorIdx = [array]::IndexOf($lines, $anchor)
if ($anchorIdx -lt 0) { throw "ZSCRIPT anchor not found: $anchor" }
if ($start -lt 0) {
    $newLines = New-Object System.Collections.Generic.List[string]
    for ($i = 0; $i -le $anchorIdx; $i++) { [void]$newLines.Add($lines[$i]) }
    foreach ($il in $includeLines) { [void]$newLines.Add($il) }
    for ($i = $anchorIdx + 1; $i -lt $lines.Count; $i++) { [void]$newLines.Add($lines[$i]) }
    [System.IO.File]::WriteAllLines($zscript, $newLines.ToArray(), [System.Text.UTF8Encoding]::new($false))
    Write-Host 'Patched ZSCRIPT.zc includes.'
} else {
    Write-Host 'ZSCRIPT.zc port includes already present.'
}

if (-not $SkipSmoke) {
    $smoke = Join-Path $PSScriptRoot 'Smoke-GZDoom.ps1'
    if (Test-Path -LiteralPath $smoke) {
        Write-Host 'Smoke compile (-Norun) ...'
        & $smoke -Norun
    } else {
        Write-Warning 'Smoke-GZDoom.ps1 missing; run gzdoom -file mod -norun manually.'
    }
}

Write-Host 'Port batch done.'
