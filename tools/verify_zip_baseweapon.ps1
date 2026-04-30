Add-Type -AssemblyName System.IO.Compression.FileSystem
$zipPath = 'C:\Program Files (x86)\Steam\steamapps\common\Ultimate Doom\(Doom Mod Builds)\.TCs\ProjectBrutality2022.zip'
$z = [IO.Compression.ZipFile]::OpenRead($zipPath)
try {
	$e = $z.GetEntry('actors/weapons/baseweapon.dec')
	if (-not $e) { Write-Host 'MISSING baseweapon entry'; exit 1 }
	$r = New-Object IO.StreamReader($e.Open())
	$c = $r.ReadToEnd()
	$r.Close()
	Write-Host ('GoMeleeInstead label: {0}' -f ($c -match '(?m)^\tGoMeleeInstead:'))
	Write-Host ('Inline GoMeleePunchSetup jumps: {0}' -f ($c -match 'TNT1 A 0 A_JumpIfCloser\(99, "GoMeleePunchSetup"\)'))
	$i = $c.IndexOf('QuickMelee:')
	if ($i -ge 0) {
		$len = [Math]::Min(900, $c.Length - $i)
		Write-Host '--- snippet ---'
		Write-Host $c.Substring($i, $len)
	}
}
finally { $z.Dispose() }
