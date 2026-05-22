# Fix ZScript weapon .zs ported from DECORATE: default semicolons, state line semicolons, digit sprites.

param(
    [Parameter(Mandatory = $true)][string[]]$Paths
)

function Fix-WeaponZsFile([string]$path) {
    $lines = Get-Content -LiteralPath $path -Encoding UTF8
    $out = New-Object System.Collections.Generic.List[string]
    $inClass = $false
    $inDefault = $false
    $inStates = $false
    $defDepth = 0
    $stateDepth = 0

    foreach ($line in $lines) {
        $t = $line.Trim()
        if ($line -match '^\s*class\s+\w+') { $inClass = $true }

        if ($inClass -and $t -eq 'default') {
            $inDefault = $true
            $defDepth = 0
            [void]$out.Add($line)
            continue
        }
        if ($inDefault) {
            if ($t -eq '{') { $defDepth++; [void]$out.Add($line); continue }
            if ($t -eq '}') {
                $defDepth--
                if ($defDepth -le 0) { $inDefault = $false }
                [void]$out.Add($line)
                continue
            }
            if ($t -match '^//\$') {
                [void]$out.Add(($line -replace '^\s*//\$', '		//'))
                continue
            }
            if ($t -match '^SpawnID\b') {
                [void]$out.Add('		// SpawnID (DECORATE only; not in ZScript default)')
                continue
            }
            if ($t -match '^Weapon\.BobStyle\s+InverseSmooth') {
                [void]$out.Add(($line -replace 'InverseSmooth', '"InverseSmooth"'))
                continue
            }
            if ($t -match '^Weapon\.SisterWeapon\s+(\w+)') {
                $cls = $Matches[1]
                if ($cls -notmatch '^"') {
                    [void]$out.Add("`t`tWeapon.SisterWeapon `"$cls`";")
                    continue
                }
            }
            if ($t.Length -gt 0 -and $t -notmatch '[;{}]$' -and $t -notmatch '^\s*//') {
                [void]$out.Add($line.TrimEnd() + ';')
                continue
            }
            [void]$out.Add($line)
            continue
        }

        if ($inClass -and $t -eq 'states') {
            $inStates = $true
            $stateDepth = 0
            [void]$out.Add($line)
            continue
        }
        if ($inStates) {
            $opens = ([regex]::Matches($line, '\{')).Count
            $closes = ([regex]::Matches($line, '\}')).Count
            if ($opens -gt 0 -or $closes -gt 0) {
                $stateDepth += $opens - $closes
                if ($stateDepth -le 0) { $inStates = $false }
                [void]$out.Add($line)
                continue
            }
            # State label only: "Ready:" (repair "Ready:;" from an earlier pass)
            if ($t -match '^[A-Za-z_][A-Za-z0-9_]*:\s*;?\s*$') {
                $label = ($t -replace ':\s*;?\s*$', ':')
                [void]$out.Add(($line -replace '\S+\s*:\s*;?\s*$', $label.Trim()))
                continue
            }
            # DECORATE "else;" before a block -> ZScript "else"
            if ($t -match '^else;\s*$') {
                [void]$out.Add(($line -replace 'else;', 'else'))
                continue
            }
            # Bare sprite lump on a state frame line (4A17, CB01, PZCR, 8HAF, etc.)
            if ($inStates -and $line -cmatch '^\s+([A-Z0-9]{2,8})\s+(.+)$' -and $Matches[1] -notin @('TNT1','Goto','Stop','Wait','Loop') -and $line -notmatch '^\s+"') {
                $spr = $Matches[1]
                [void]$out.Add(($line -replace "^(\s+)$([regex]::Escape($spr))\s+", "`$1`"$spr`" "))
                continue
            }
            if ($t.Length -eq 0) {
                [void]$out.Add($line)
                continue
            }
            if ($t -match '^(Goto|Loop|Wait|Stop)\b' -and $t -notmatch ';$') {
                [void]$out.Add($line.TrimEnd() + ';')
                continue
            }
            if ($t -notmatch '[;{}]$' -and $t -notmatch '^\s*//') {
                [void]$out.Add($line.TrimEnd() + ';')
                continue
            }
            [void]$out.Add($line)
            continue
        }

        [void]$out.Add($line)
    }

    $final = PostProcess-WeaponZsLines ($out.ToArray())
    [System.IO.File]::WriteAllLines($path, $final, [System.Text.UTF8Encoding]::new($false))
    Write-Host "Fixed $path"
}

function PostProcess-WeaponZsLines([string[]]$lines) {
    $result = New-Object System.Collections.Generic.List[string]
    $i = 0
    while ($i -lt $lines.Count) {
        $line = $lines[$i]
        $t = $line.Trim()

        if ($t -match '^\*/\s*;?\s*$' -or $t -match '^\*/;') {
            [void]$result.Add(($line -replace '\*/\s*;', '*/'))
            $i++
            continue
        }

        # Semicolon wrongly placed after end-of-line comment -> before comment.
        if ($line -match '//' -and $line -notmatch ';\s*//' -and $line -match ';\s*$') {
            $line = [regex]::Replace($line, '^(.*)(\s*//.*?);\s*$', '$1;$2')
            $t = $line.Trim()
        }
        # Action line with trailing comment but no statement terminator before //.
        if ($line -match '//' -and $line -notmatch ';\s*//' -and $t.Length -gt 0 -and $t -notmatch '^\s*//') {
            $line = [regex]::Replace($line, '^(.*\S)(\s*//.*)$', '$1;$2')
            $t = $line.Trim()
        }

        # DECORATE "if (cond);" / "else;" before block
        if ($t -match '^if\s*\(') {
            $line = $line -replace '(\))\s*;\s*$', '$1'
            $t = $line.Trim()
        }
        if ($t -match '^else;\s*$') {
            [void]$result.Add(($line -replace 'else;', 'else'))
            $i++
            continue
        }
        if ($line -cmatch 'return State\("([^"]*)"\);?') {
            $label = $Matches[1]
            if ($label.Length -eq 0) {
                [void]$result.Add(($line -creplace 'return State\(""\);?', 'return ResolveState(null);'))
            } else {
                [void]$result.Add(($line -creplace 'return State\("' + [regex]::Escape($label) + '"\);?', "return ResolveState(`"$label`");"))
            }
            $i++
            continue
        }

        if ($t -eq 'A_DoPBWeaponAction;') {
            [void]$result.Add(($line -replace 'A_DoPBWeaponAction;', 'return A_DoPBWeaponAction();'))
            $i++
            continue
        }
        if ($line -cmatch 'return state\(') {
            [void]$result.Add(($line -creplace 'return state\(', 'return ResolveState('))
            $i++
            continue
        }
        if ($t -eq 'A_AlertMonsters;') {
            [void]$result.Add(($line -replace 'A_AlertMonsters;', 'A_AlertMonsters();'))
            $i++
            continue
        }
        if ($line -match 'return null\b') {
            [void]$result.Add(($line -replace 'return null\b', 'return ResolveState(null)'))
            $i++
            continue
        }
        if ($line -cmatch 'return State\(""\);?') {
            [void]$result.Add(($line -creplace 'return State\(""\);?', 'return ResolveState(null);'))
            $i++
            continue
        }
        if ($t -eq 'A_GunFlash;') {
            [void]$result.Add(($line -replace 'A_GunFlash;', 'A_GunFlash();'))
            $i++
            continue
        }
        if ($t -eq '+POWERED_UP;') {
            [void]$result.Add(($line -replace '\+POWERED_UP;', '+WEAPON.POWERED_UP;'))
            $i++
            continue
        }

        # Sprite frame line immediately followed by lone { -> merge.
        if ($t -match '^[A-Za-z0-9#"].* \d+.*;\s*$' -and $i + 1 -lt $lines.Count -and $lines[$i + 1].Trim() -eq '{') {
            [void]$result.Add(($line -replace ';\s*$', ' {'))
            $i += 2
            continue
        }

        [void]$result.Add($line)
        $i++
    }
    return $result.ToArray()
}

foreach ($p in $Paths) {
    $full = if ([System.IO.Path]::IsPathRooted($p)) { $p } else { Join-Path (Get-Location) $p }
    Fix-WeaponZsFile $full
}
