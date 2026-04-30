Add-Type -AssemblyName System.IO.Compression.FileSystem
$z = [IO.Compression.ZipFile]::OpenRead('C:\Program Files (x86)\Steam\steamapps\common\Ultimate Doom\(Doom Mod Builds)\.TCs\ProjectBrutality2022.zip')
try {
	$z.Entries | Where-Object { $_.FullName -match 'baseweapon|BaseWeapon' } | ForEach-Object { $_.FullName }
}
finally { $z.Dispose() }
