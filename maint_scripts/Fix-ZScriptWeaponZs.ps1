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
            # State label only: "Ready:" or "WeaponRespect:"
            if ($t -match '^[A-Za-z_][A-Za-z0-9_]*:\s*$') {
                [void]$out.Add($line)
                continue
            }
            # Unquote digit-led sprites (quoted form breaks ZScript parse).
            if ($line -match '^(\s+)"(\d+[A-Za-z][A-Za-z0-9]*)"(\s+)(.*)$') {
                $rest = $Matches[4].TrimEnd()
                if ($rest -notmatch ';$' -and $rest -notmatch '\{$' -and $rest.Length -gt 0) { $rest += ';' }
                [void]$out.Add("$($Matches[1])$($Matches[2])$($Matches[3])$rest")
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

        # Do not rewrite DECORATE "if ();" deferrals — invalid in ZScript but needs manual porting.

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
