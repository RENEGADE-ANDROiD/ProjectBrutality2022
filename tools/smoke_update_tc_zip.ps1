Add-Type -AssemblyName System.IO.Compression.FileSystem
# Sync selected repo files into the packaged TC zip (edit $pairs when you add hotfix lumps).
# After changing anything in $pairs, run: powershell -NoProfile -ExecutionPolicy Bypass -File tools/smoke_update_tc_zip.ps1
$zipPath = 'C:\Program Files (x86)\Steam\steamapps\common\Ultimate Doom\(Doom Mod Builds)\.TCs\ProjectBrutality2022.zip'
$root = Split-Path $PSScriptRoot -Parent
# Each pair: @(<source path>, <canonical lump path inside zip>, <list of any duplicate lump paths to remove>)
$pairs = @(
	, @((Join-Path $root 'SNDINFO.txt'), 'SNDINFO.txt', @())
	, @((Join-Path $root 'DECORATE'), 'DECORATE', @())
	, @((Join-Path $root 'AGENTS.md'), 'AGENTS.md', @())
	, @((Join-Path $root 'README.md'), 'README.md', @())
	, @((Join-Path $root 'CREDITS.txt'), 'CREDITS.txt', @())
	, @((Join-Path $root 'actors\Player\PLAYER.dec'), 'actors/Player/PLAYER.dec', @())
	, @((Join-Path $root 'actors\Weapons\Slot1\ShieldSaw.dec'), 'actors/Weapons/Slot1/ShieldSaw.dec', @())
	, @((Join-Path $root 'actors\SPAWNERS\WeaponSpawners\ChainsawWeaponSpawner.dec'), 'actors/SPAWNERS/WeaponSpawners/ChainsawWeaponSpawner.dec', @())
	, @((Join-Path $root 'actors\Weapons\Slot4\LeverAction.dec'), 'actors/Weapons/Slot4/LeverAction.dec', @())
	, @((Join-Path $root 'Fontdefs.txt'), 'Fontdefs.txt', @())
	, @((Join-Path $root 'language.enu'), 'language.enu', @())
	, @((Join-Path $root 'CVARINFO'), 'CVARINFO', @())
	, @((Join-Path $root 'MENUDEF.txt'), 'MENUDEF.txt', @())
	, @((Join-Path $root 'actors\Weapons\BaseWeapon.dec'), 'actors/weapons/baseweapon.dec', @('actors/Weapons/BaseWeapon.dec'))
	, @((Join-Path $root 'actors\GloryKills\GloryKillCommon.dec'), 'actors/glorykills/glorykillcommon.dec', @('actors/GloryKills/GloryKillCommon.dec'))
	, @((Join-Path $root 'ZSCRIPT.zc'), 'ZSCRIPT.zc', @())
	, @((Join-Path $root 'zmapinfo.txt'), 'zmapinfo.txt', @())
	, @((Join-Path $root 'zscript\Weapons\BaseWeapon.zc'), 'zscript/weapons/baseweapon.zc', @('zscript/Weapons/BaseWeapon.zc'))
	, @((Join-Path $root 'zscript\Weapons\PB_WeaponTacticalFeel.zc'), 'zscript/weapons/pb_weapontacticalfeel.zc', @('zscript/Weapons/PB_WeaponTacticalFeel.zc'))
	, @((Join-Path $root 'zscript\PbWheel\ev_core_special.zsc'), 'zscript/pbwheel/ev_core_special.zsc', @('zscript/PbWheel/ev_core_special.zsc'))
	, @((Join-Path $root 'zscript\Gore\PB_EnhancedBrutality2022.zc'), 'zscript/gore/pb_enhancedbrutality2022.zc', @('zscript/Gore/PB_EnhancedBrutality2022.zc'))
	, @((Join-Path $root 'zscript\Gore\BDv22GoreHandler.zc'), 'zscript/gore/bdv22gorehandler.zc', @('zscript/Gore/BDv22GoreHandler.zc'))
	, @((Join-Path $root 'zscript\Gore\BDv22GoreMergeHandler.zc'), 'zscript/gore/bdv22goremergehandler.zc', @('zscript/Gore/BDv22GoreMergeHandler.zc'))
	, @((Join-Path $root 'zscript\Gore\PB_DeathGoreBoostHandler.zc'), 'zscript/gore/pb_deathgoreboosthandler.zc', @('zscript/Gore/PB_DeathGoreBoostHandler.zc'))
	, @((Join-Path $root 'zscript\Gore\BPv10Gore\BPv10GoreHandler.zc'), 'zscript/gore/bpv10gore/bpv10gorehandler.zc', @('zscript/Gore/BPv10Gore/BPv10GoreHandler.zc'))
	, @((Join-Path $root 'zscript\Gore\NashGore\NashGoreHandler.zc'), 'zscript/gore/nashgore/nashgorehandler.zc', @('zscript/Gore/NashGore/NashGoreHandler.zc'))
	, @((Join-Path $root 'zscript\Gore\NashGore\NashGoreActor.zc'), 'zscript/gore/nashgore/nashgoreactor.zc', @('zscript/Gore/NashGore/NashGoreActor.zc'))
	, @((Join-Path $root 'zscript\Items\PBKillstreak\PB_Killstreak_Handler.zc'), 'zscript/items/pbkillstreak/pb_killstreak_handler.zc', @('zscript/Items/PBKillstreak/PB_Killstreak_Handler.zc'))
	, @((Join-Path $root 'zscript\Items\PBKillstreak\PB_Killstreak_Items.zc'), 'zscript/items/pbkillstreak/pb_killstreak_items.zc', @('zscript/Items/PBKillstreak/PB_Killstreak_Items.zc'))
	, @((Join-Path $root 'zscript\Items\PBKillstreak\PB_Killstreak_Messages.zc'), 'zscript/items/pbkillstreak/pb_killstreak_messages.zc', @('zscript/Items/PBKillstreak/PB_Killstreak_Messages.zc'))
	, @((Join-Path $root 'actors\Items\PBKillstreak\PB_UnlessYouHavePowah.dec'), 'actors/items/pbkillstreak/pb_unlessyouhavepowah.dec', @('actors/Items/PBKillstreak/PB_UnlessYouHavePowah.dec'))
	, @((Join-Path $root 'zscript\Weapons\Slot4\BattleRifle\BDPBattleRifle.zs'), 'zscript/Weapons/Slot4/BattleRifle/BDPBattleRifle.zs', @('zscript/weapons/slot4/battlerifle/bdpbattlerifle.zs'))
	, @((Join-Path $root 'zscript\Weapons\Slot4\NeoHMG\NeoHMG.zs'), 'zscript/weapons/slot4/neohmg/neohmg.zs', @('zscript/Weapons/Slot4/NeoHMG/NeoHMG.zs'))
	, @((Join-Path $root 'zscript\Weapons\Slot3\CSSG\CSSG.zs'), 'zscript/weapons/slot3/cssg/cssg.zs', @('zscript/Weapons/Slot3/CSSG/CSSG.zs'))
	, @((Join-Path $root 'actors\Weapons\Slot3\SSG.dec'), 'actors/weapons/slot3/ssg.dec', @('actors/Weapons/Slot3/SSG.dec'))
	, @((Join-Path $root 'actors\Weapons\Slot3\X12Shotgun.dec'), 'actors/weapons/slot3/x12shotgun.dec', @('actors/Weapons/Slot3/X12Shotgun.dec'))
	, @((Join-Path $root 'actors\Weapons\Slot7\RAILGUN.dec'), 'actors/weapons/slot7/railgun.dec', @('actors/Weapons/Slot7/RAILGUN.dec'))
	, @((Join-Path $root 'actors\Friendly Marines\CapturedMarine.dec'), 'actors/friendly marines/capturedmarine.dec', @('actors/Friendly Marines/CapturedMarine.dec'))
	, @((Join-Path $root 'actors\Gore\BURN.dec'), 'actors/gore/burn.dec', @('actors/Gore/BURN.dec'))
	, @((Join-Path $root 'actors\Monsters\T3-Fats\Daedabus.dec'), 'actors/monsters/t3-fats/daedabus.dec', @('actors/Monsters/T3-Fats/Daedabus.dec'))
	, @((Join-Path $root 'zscript\Weapons\Slot6\Excavator\PB_Excavator.zs'), 'zscript/weapons/slot6/excavator/pb_excavator.zs', @('zscript/Weapons/Slot6/Excavator/PB_Excavator.zs'))
	, @((Join-Path $root 'zscript\Weapons\Slot4\MetalSniper\MetalSniper.zs'), 'zscript/Weapons/Slot4/MetalSniper/MetalSniper.zs', @('zscript/weapons/slot4/metalsniper/metalsniper.zs'))
	, @((Join-Path $root 'actors\Weapons\MeleeWeaponPack\DragonSlayer.dec'), 'actors/weapons/meleeweaponpack/dragonslayer.dec', @('actors/Weapons/MeleeWeaponPack/DragonSlayer.dec'))
	, @((Join-Path $root 'actors\Weapons\MeleeWeaponPack\Stormcast.dec'), 'actors/weapons/meleeweaponpack/stormcast.dec', @('actors/Weapons/MeleeWeaponPack/Stormcast.dec'))
	, @((Join-Path $root 'zscript\Weapons\MeleeWeaponPack\DragonSlayer.zc'), 'zscript/weapons/meleeweaponpack/dragonslayer.zc', @('zscript/Weapons/MeleeWeaponPack/DragonSlayer.zc'))
	, @((Join-Path $root 'zscript\Weapons\MeleeWeaponPack\Stormcast.zc'), 'zscript/weapons/meleeweaponpack/stormcast.zc', @('zscript/Weapons/MeleeWeaponPack/Stormcast.zc'))
)

if (-not (Test-Path -LiteralPath $zipPath)) { throw "Zip not found: $zipPath" }
foreach ($p in $pairs) {
	if (-not (Test-Path -LiteralPath $p[0])) { throw ('Missing source: {0}' -f $p[0]) }
}

$z = [System.IO.Compression.ZipFile]::Open($zipPath, 'Update')
try {
	foreach ($p in $pairs) {
		$src, $entry, $dups = $p[0], $p[1], $p[2]
		foreach ($name in (@($entry) + $dups)) {
			$existing = $z.GetEntry($name)
			if ($existing) { $existing.Delete() }
		}
		[System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($z, $src, $entry) | Out-Null
		Write-Host ('  wrote {0}' -f $entry)
	}
}
finally { $z.Dispose() }

Write-Host 'Zip updated.'
