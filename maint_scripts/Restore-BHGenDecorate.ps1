# Restore BHGen as DECORATE PB_Weapon in BLACKHOLE.dec (revert ZScript port).
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$old = git -C $root show fb0cc173d:actors/Weapons/Slot8/BLACKHOLE.dec
if (-not $old) { throw 'git show failed' }
$lines = $old -split "`n"
$end = 0
for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match '^Actor DMBall') { $end = $i; break }
}
if ($end -le 0) { throw 'DMBall marker not found' }
$block = ($lines[0..($end - 1)] -join "`n").TrimEnd() + "`n"

$block = $block -replace "`t`tWait`r?`n`r?`nDeselect:", "`t`tGoto Ready3`n`nDeselect:"
$block = $block -replace "PRDC ABCDCB 1 A_DoPBWeaponAction`r?`n`tGoto Ready\+8", "PRDC ABCDCB 1 A_DoPBWeaponAction`n`t`tLoop"
$block = $block -replace 'Goto Ready\+8', 'Goto Ready3'
$block = $block -replace 'Goto Ready\+7', 'Goto Ready3'

if ($block -notmatch 'Inventory\.Icon') {
    $block = $block -replace '(Tag "Black Hole Generator")', "`$1`nInventory.Icon `"PRDCZ0`"`nInventory.AltHUDIcon `"PRDCZ0`""
}

$oldFire = @"
Fire:
	TNT1 A 0 A_WeaponOffset(0,32)
"@
$newFire = @"
Fire:
	TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady")
	TNT1 A 0 A_JumpIfInventory("CantFire", 1, "Ready3")
	TNT1 A 0 A_JumpIfInventory("Cell", 1, 1)
	Goto Ready3
	TNT1 A 0 A_WeaponOffset(0,32)
"@
$block = $block.Replace($oldFire, $newFire)

$oldAlt = @"
AltFire:
	TNT1 A 0 A_WeaponOffset(0,32)
"@
$newAlt = @"
AltFire:
	TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady")
	TNT1 A 0 A_JumpIfInventory("CantFire", 1, "Ready3")
	TNT1 A 0 A_WeaponOffset(0,32)
"@
$block = $block.Replace($oldAlt, $newAlt)

$decPath = Join-Path $root 'actors\Weapons\Slot8\BLACKHOLE.dec'
$rest = Get-Content -LiteralPath $decPath -Raw
if ($rest -match '(?s)^//.*?\r?\n\r?\n') {
    $rest = $rest -replace '(?s)^//.*?\r?\n\r?\n', ''
}
$out = $block + "`n" + $rest.TrimStart()
[System.IO.File]::WriteAllText($decPath, $out.Replace("`n", "`r`n"))
Write-Host "Restored BHGen DECORATE block ($end lines) -> $decPath"
