# Post-port compile fixes for auto-converted PB_WeaponBase weapons only.
param(
    [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
)

$ported = @(
    'zscript/Weapons/Slot2/MP40/PB_MP40.zs',
    'zscript/Weapons/Slot2/Pistol/PB_Pistol.zs',
    'zscript/Weapons/Slot4/Rifle/Rifle.zs',
    'zscript/Weapons/Slot4/LMG/PB_LMG.zs',
    'zscript/Weapons/Slot4/Nailgun/PB_Nailgun.zs',
    'zscript/Weapons/Slot4/XM21/PB_XM21.zs',
    'zscript/Weapons/Slot4/Fusil/PB_Fusil.zs',
    'zscript/Weapons/Slot4/Fusil/PB_SideFusil.zs',
    'zscript/Weapons/Slot4/Ballista/ProSurv_Ballista.zs',
    'zscript/Weapons/Slot3/MarauderSSG/MarauderSSG.zs',
    'zscript/Weapons/Slot3/X12Shotgun/X12Shotgun.zs',
    'zscript/Weapons/Slot3/CryoASG/PB_CryoASG.zs',
    'zscript/Weapons/Slot6/M2Plasma/PB_M2Plasma.zs',
    'zscript/Weapons/Slot7/Freezer/PB_Freezer.zs',
    'zscript/Weapons/Slot8/CryoElectroRifle/PB_CryoElectroRifle.zs',
    'zscript/Weapons/Slot8/BFG9000/PB_BFG9000.zs',
    'zscript/Weapons/Slot9/Flamethrower/PB_Flamethrower.zs',
    'zscript/Weapons/Slot9/HellRifle/Hell_rifle.zs',
    'zscript/Weapons/Slot9/Unmaker/PB_Unmaker.zs',
    'zscript/Weapons/Slot9/CryoCannon/PB_CryoCannon.zs'
)

function Fix-PortedZs([string]$path) {
    $c = [IO.File]::ReadAllText($path)
    $orig = $c

    # State returns (any casing)
    $c = [regex]::Replace($c, '\breturn\s+state\s*\(', 'return ResolveState(', 'IgnoreCase')
    $c = [regex]::Replace($c, '\breturn\s+State\s*\(', 'return ResolveState(')

    # A_DoPBWeaponAction without call
    $c = [regex]::Replace($c, 'return\s+A_DoPBWeaponAction\s*;', 'return A_DoPBWeaponAction();')
    $c = [regex]::Replace($c, 'return\s+A_DoPBWeaponAction(\s*\r?\n)', 'return A_DoPBWeaponAction();$1')
    $c = [regex]::Replace($c, '(\d)\s+A_DoPBWeaponAction\s*;', '$1 A_DoPBWeaponAction();')
    $c = [regex]::Replace($c, 'A_DoPBWeaponAction\s*;', 'A_DoPBWeaponAction();')

    # Other bare actions
    $c = [regex]::Replace($c, '\bA_GunFlash\s*;', 'A_GunFlash();')
    $c = [regex]::Replace($c, '\bA_AlertMonsters\s*;', 'A_AlertMonsters();')
    $c = [regex]::Replace($c, '\bPB_FireOffset\s*;', 'PB_FireOffset();')

    # DECORATE/Python literals
    $c = [regex]::Replace($c, ',\s*none\)', ", 'none')")
    $c = [regex]::Replace($c, '\bnone\s*,\s*none\b', "'none', 'none'")
    $c = [regex]::Replace($c, '(\bA_RailAttack\([^;]*)\bnone\b', '$1''none''')
    # PlaySoundEx uses string slots; StartSound/StopSound need CHAN_* constants.
    $c = [regex]::Replace($c, 'A_StartSound\(([^,)]+),\s*"Auto"\s*,\s*CHANF_OVERLAP\s*\)', 'A_StartSound($1, CHAN_AUTO, CHANF_OVERLAP)')
    $c = [regex]::Replace($c, 'A_StartSound\(([^,)]+),\s*"Auto"\)', 'A_StartSound($1, CHAN_AUTO)')
    $c = [regex]::Replace($c, 'A_StopSound\("Auto"\)', 'A_StopSound(CHAN_AUTO)')
    $c = [regex]::Replace($c, 'A_PlaySoundEx\(([^,)]+),\s*"Auto"\)', 'A_PlaySoundEx($1, "Auto")')
    $c = [regex]::Replace($c, 'A_PlaySound\(([^,)]+),\s*"Auto"\)', 'A_PlaySound($1, CHAN_AUTO)')
    $c = [regex]::Replace($c, ',\s*''none''\)', ', 0)')
    # "SPR" ABCD 1 -> "SPR" "ABCD" 1 (frame letters must be quoted in ZScript)
    $c = [regex]::Replace($c, '"([A-Z0-9#][A-Z0-9#]*)"\s+([A-Z]{2,26})\s+(\d+)', '"$1" "$2" $3')
    $c = [regex]::Replace($c, '(TNT1 A 0 \{[^}]*A_StartSound\([^}]+\})\s*(\r?\n\s*\})', '$1$2return A_DoPBWeaponAction();$2')
    $c = [regex]::Replace($c, '(\d)\s+A_DoPBWeaponAction(\s*$)', '$1 A_DoPBWeaponAction();$2', 'Multiline')

    # Numeric PlaySoundEx channel -> string slot (DECORATE slot index)
    $c = [regex]::Replace($c, 'A_PlaySoundEx\(([^,]+),\s*5\)', 'A_PlaySoundEx($1, "SoundSlot5")')
    $c = [regex]::Replace($c, 'A_PlaySoundEx\(([^,]+),\s*6\)', 'A_PlaySoundEx($1, "SoundSlot6")')

    # M2Plasma / similar: return before dead code — move SetRoll before return
    $c = [regex]::Replace($c,
        'return A_DoPBWeaponAction\(\);\s*\r?\n(\s*)A_SetRoll',
        "A_SetRoll")
    # Re-add return after SetRoll line in blocks that had return-first pattern
    $c = [regex]::Replace($c,
        '(?m)^(\s*)A_SetRoll([^\r\n]+)\s*\r?\n(\s*)\}',
        "`$1A_SetRoll`$2`r`n`$1return A_DoPBWeaponAction();`r`n`$3}")

    # Unmaker: single-letter frames after quoted sprite confuse hex parser
    $c = [regex]::Replace($c, '("UNHF")\s+([NOPQ])\s+', '$1 "$2" ')

    if ($c -ne $orig) {
        [IO.File]::WriteAllText($path, $c, [Text.UTF8Encoding]::new($false))
        Write-Host "Fixed $path"
    }
}

foreach ($rel in $ported) {
    $full = Join-Path $Root $rel
    if (Test-Path -LiteralPath $full) { Fix-PortedZs $full }
    else { Write-Warning "Missing $rel" }
}
