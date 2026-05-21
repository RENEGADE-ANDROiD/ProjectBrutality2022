# Convert ACTOR PB_* : PB_Weapon in a DECORATE file to ZScript PB_WeaponBase + support shard.
# Usage: .\Convert-PBWeaponDecToZs.ps1 -DecPath actors/Weapons/Slot4/Carbine.dec -ClassName PB_Carbine

param(
    [Parameter(Mandatory = $true)][string]$DecPath,
    [Parameter(Mandatory = $true)][string]$ClassName,
    [string]$ZsRel,
    [string]$SupportRel
)

$root = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
if (Test-Path (Join-Path $PSScriptRoot "..\ZSCRIPT.zc")) { $root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path }
elseif (Test-Path (Join-Path $PSScriptRoot "ZSCRIPT.zc")) { $root = $PSScriptRoot }
else { $root = (Get-Location).Path }

$dec = Join-Path $root $DecPath
if (-not $ZsRel) {
    $slot = if ($DecPath -match 'Slot(\d)') { $Matches[1] } else { "0" }
    $short = $ClassName -replace '^PB_', ''
    $ZsRel = "zscript\Weapons\Slot$slot\$short\$ClassName.zs"
}
if (-not $SupportRel) {
    $SupportRel = $DecPath -replace '\.dec$', '_Support.dec'
}
# DECORATE / ZSCRIPT #include paths must use forward slashes (Linux + UZDoom lump lookup).
$DecPath = $DecPath -replace '\\', '/'
$ZsRel = $ZsRel -replace '\\', '/'
$SupportRel = $SupportRel -replace '\\', '/'

$all = Get-Content -LiteralPath $dec -Encoding UTF8
$actorIdx = -1
for ($i = 0; $i -lt $all.Count; $i++) {
    if ($all[$i] -match "^ACTOR $ClassName ") { $actorIdx = $i; break }
}
if ($actorIdx -lt 0) { throw "ACTOR $ClassName not found in $DecPath" }

$statesIdx = -1
for ($i = $actorIdx + 1; $i -lt $all.Count; $i++) {
    if ($all[$i] -match '^\s*States\s*$') { $statesIdx = $i; break }
}
if ($statesIdx -lt 0) { throw "States block not found for $ClassName" }

$closeIdx = -1
$depth = 0
for ($i = $actorIdx; $i -lt $all.Count; $i++) {
    foreach ($ch in $all[$i].ToCharArray()) {
        if ($ch -eq '{') { $depth++ }
        elseif ($ch -eq '}') { $depth--; if ($depth -eq 0) { $closeIdx = $i; break } }
    }
    if ($closeIdx -ge 0) { break }
}

$defStart = $actorIdx + 1
while ($defStart -le $statesIdx - 1 -and $all[$defStart].Trim() -eq '{') { $defStart++ }
$defEnd = $statesIdx - 1
$stateBodyStart = $statesIdx + 2
$stateBodyEnd = $closeIdx - 1

$outDir = Split-Path (Join-Path $root $ZsRel) -Parent
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$sb = [System.Text.StringBuilder]::new()
[void]$sb.AppendLine("// $ClassName — ZScript port (DECORATE PB_Weapon retired).")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("class $ClassName : PB_WeaponBase")
[void]$sb.AppendLine("{")
[void]$sb.AppendLine("`tdefault")
[void]$sb.AppendLine("`t{")
for ($i = $defStart; $i -le $defEnd; $i++) {
    $line = $all[$i]
    if ($line -match '^\s*Game\s+Doom\s*$') {
        [void]$sb.AppendLine("`t// Game Doom — DECORATE-only; omitted in ZScript default")
        continue
    }
    [void]$sb.AppendLine($line)
}
[void]$sb.AppendLine("`t}")
[void]$sb.AppendLine("`tstates")
[void]$sb.AppendLine("`t{")
for ($i = $stateBodyStart; $i -le $stateBodyEnd; $i++) { [void]$sb.AppendLine($all[$i]) }
[void]$sb.AppendLine("`t}")
[void]$sb.AppendLine("}")

[System.IO.File]::WriteAllText((Join-Path $root $ZsRel), $sb.ToString(), [System.Text.UTF8Encoding]::new($false))

$support = [System.Collections.Generic.List[string]]::new()
[void]$support.Add("// $ClassName support — tokens, ammo, projectiles (weapon in $ZsRel).")
[void]$support.Add("")
for ($i = 0; $i -lt $actorIdx; $i++) { [void]$support.Add($all[$i]) }
[void]$support.Add("")
for ($i = $closeIdx + 1; $i -lt $all.Count; $i++) { [void]$support.Add($all[$i]) }
[System.IO.File]::WriteAllLines((Join-Path $root $SupportRel), $support, [System.Text.UTF8Encoding]::new($false))

$stub = @(
    "// $ClassName weapon states: $ZsRel",
    "#include `"$SupportRel`""
)
[System.IO.File]::WriteAllLines($dec, $stub, [System.Text.UTF8Encoding]::new($false))

Write-Host "Wrote $ZsRel and $SupportRel; stubbed $DecPath"
