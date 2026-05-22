# Revert FlashPunching Stop -> Goto Ready3 (undo Fix-FlashPunchingStop.ps1)
$root = Split-Path $PSScriptRoot -Parent
$count = 0
Get-ChildItem -Path $root -Recurse -Include *.dec,*.zs,*.zsc |
    Where-Object { $_.FullName -notmatch '_ballista' } |
    ForEach-Object {
        $lines = [IO.File]::ReadAllLines($_.FullName)
        $changed = $false
        for ($i = 0; $i -lt $lines.Count - 1; $i++) {
            if ($lines[$i] -match '^\s*TNT1 A 0 A_ClearOverlays\(PSP_FLASH, PSP_FLASH, false\)' -and
                $lines[$i + 1] -match '^\s*Stop;') {
                $indent = ($lines[$i + 1] -replace 'Stop;.*', '')
                $lines[$i + 1] = $indent + 'Goto Ready3;'
                $changed = $true
            }
        }
        if ($changed) {
            [IO.File]::WriteAllLines($_.FullName, $lines)
            $count++
            Write-Host $_.Name
        }
    }
Write-Host "Reverted $count files"
