"""One-shot BVCH guest asset extract for PB2022 fold. Not loaded by the engine."""
import struct
import zipfile
from pathlib import Path

try:
	from PIL import Image
except ImportError:
	raise SystemExit("Pillow required: py -3 -m pip install Pillow")

SRC = Path(
	r"C:\Program Files (x86)\Steam\steamapps\common\Ultimate Doom"
	r"\(Doom Mod Builds)\.TCs\(MonsterPacks)\BrutalVoxelCyberHorrorMix.wad"
)
ROOT = Path(r"c:\Users\shawn\OneDrive\Desktop\temp\ProjectBrutality2022")
SPR = ROOT / "SPRITES" / "Monsters" / "BVCH"
SND = ROOT / "sounds" / "monsters" / "BVCH"

# (zip path prefix/match, dest subfolder under SPR, name filter)
SPRITE_FOLDERS = [
	("sprites/Monsters/Cacodemon/Glaucoma/", "Glaucoma", None),
	("sprites/Monsters/Cacodemon/Witherdemon/", "Witherdemon", None),
	("sprites/Monsters/Demon/Mauler/", "Mauler", None),
	("sprites/Monsters/Original Monsters/Overdemoniac/", "Overdemoniac", None),
	("sprites/Monsters/Original Monsters/Dastard/", "Dastard", None),
	("sprites/Monsters/Vile/Machina/", "Machina", None),
]

# FGO2 projectile frames live at sprites/FGO2*
FGO2_PREFIX = "sprites/FGO2"
BZRD_PREFIX = "sprites/BZRD"

SOUND_MAP = [
	# (zip path, dest relative under SND)
	("sounds/Monster/Cacodemon/Glaucoma/", "Glaucoma"),
	("sounds/Glaucoma/", "Glaucoma"),
	("sounds/Monsters/Demon/Mauler/", "Mauler"),
	("sounds/Monsters/Vile/Machina/", "Machina"),
	("sounds/Monsters/Bloodfiend/", "Bloodfiend"),
	("sounds/BZRD_DED.ogg", "Bloodfiend/BZRD_DED.ogg"),
	("sounds/BZRD_HIT.ogg", "Bloodfiend/BZRD_HIT.ogg"),
	("sounds/BZRD_PRD.ogg", "Bloodfiend/BZRD_PRD.ogg"),
	("sounds/BZRD_SI1.ogg", "Bloodfiend/BZRD_SI1.ogg"),
	("sounds/BZRD_SI2.ogg", "Bloodfiend/BZRD_SI2.ogg"),
	("sounds/Projectiles/dcy_dastard_fire.ogg", "Dastard/dcy_dastard_fire.ogg"),
	("sounds/Projectiles/dcy_dastard_fire_impact1.ogg", "Dastard/dcy_dastard_fire_impact1.ogg"),
	("sounds/Projectiles/dcy_dastard_fire_impact2.ogg", "Dastard/dcy_dastard_fire_impact2.ogg"),
	("sounds/Projectiles/dcy_dastard_fire_impact3.ogg", "Dastard/dcy_dastard_fire_impact3.ogg"),
	("sounds/Projectiles/dcy_dastard_fire_impact4.ogg", "Dastard/dcy_dastard_fire_impact4.ogg"),
	("sounds/Projectiles/dcy_overdemoniac_orb.ogg", "Overdemoniac/dcy_overdemoniac_orb.ogg"),
	("sounds/Projectiles/dcy_overdemoniac_orb_impact.ogg", "Overdemoniac/dcy_overdemoniac_orb_impact.ogg"),
	("sounds/Projectiles/dcy_overdemoniac_ripper.ogg", "Overdemoniac/dcy_overdemoniac_ripper.ogg"),
	("sounds/Projectiles/dcy_overdemoniac_ripper_impact.ogg", "Overdemoniac/dcy_overdemoniac_ripper_impact.ogg"),
	# Voice packs missing for Dastard/Overdemoniac in this mix — use Oddity/Haunted stand-ins.
	("sounds/DCY Monsters/Oddity/sight.ogg", "Overdemoniac/dcy_overdemoniac_sight1.ogg"),
	("sounds/DCY Monsters/Oddity/idle.ogg", "Overdemoniac/dcy_overdemoniac_sight2.ogg"),
	("sounds/DCY Monsters/Oddity/pain.ogg", "Overdemoniac/dcy_overdemoniac_pain.ogg"),
	("sounds/DCY Monsters/Oddity/death.ogg", "Overdemoniac/dcy_overdemoniac_death.ogg"),
	("sounds/DCY Monsters/Haunted/sight1.ogg", "Dastard/dcy_dastard_sight1.ogg"),
	("sounds/DCY Monsters/Haunted/sight2.ogg", "Dastard/dcy_dastard_sight2.ogg"),
	("sounds/DCY Monsters/Haunted/sight3.ogg", "Dastard/dcy_dastard_sight3.ogg"),
	("sounds/DCY Monsters/Haunted/sight4.ogg", "Dastard/dcy_dastard_sight4.ogg"),
	("sounds/DCY Monsters/Haunted/sight5.ogg", "Dastard/dcy_dastard_sight5.ogg"),
	("sounds/DCY Monsters/Haunted/sight6.ogg", "Dastard/dcy_dastard_sight6.ogg"),
	("sounds/DCY Monsters/Haunted/idle1.ogg", "Dastard/dcy_dastard_idle.ogg"),
	("sounds/DCY Monsters/Haunted/pain1.ogg", "Dastard/dcy_dastard_pain1.ogg"),
	("sounds/DCY Monsters/Haunted/pain2.ogg", "Dastard/dcy_dastard_pain2.ogg"),
	("sounds/DCY Monsters/Haunted/pain3.ogg", "Dastard/dcy_dastard_pain3.ogg"),
	("sounds/DCY Monsters/Haunted/death1.ogg", "Dastard/dcy_dastard_death1.ogg"),
	("sounds/DCY Monsters/Haunted/death2.ogg", "Dastard/dcy_dastard_death2.ogg"),
	("sounds/DCY Monsters/Haunted/death3.ogg", "Dastard/dcy_dastard_death3.ogg"),
	("sounds/DCY Monsters/Haunted/death4.ogg", "Dastard/dcy_dastard_death4.ogg"),
]


def find_playpal(z: zipfile.ZipFile) -> bytes:
	for n in z.namelist():
		if Path(n).name.upper() == "PLAYPAL" and z.getinfo(n).file_size >= 768:
			return z.read(n)[:768]
	for cand in (
		Path(r"C:\Program Files (x86)\Steam\steamapps\common\Ultimate Doom\base\doom2\DOOM2.WAD"),
		Path(r"C:\Program Files (x86)\Steam\steamapps\common\Ultimate Doom\rerelease\doom2.wad"),
	):
		if cand.is_file():
			data = cand.read_bytes()
			if data[:4] not in (b"IWAD", b"PWAD"):
				continue
			n, inf = struct.unpack_from("<II", data, 4)
			for i in range(n):
				o = inf + i * 16
				pos, size = struct.unpack_from("<II", data, o)
				name = data[o + 8 : o + 16].split(b"\0", 1)[0].decode("ascii", "replace")
				if name.upper() == "PLAYPAL" and size >= 768:
					print("PLAYPAL from", cand)
					return data[pos : pos + 768]
	raise RuntimeError("PLAYPAL not found")


def doom_pic_to_png(blob: bytes, pal: bytes, dest: Path):
	w, h, left, top = struct.unpack_from("<HHhh", blob, 0)
	if w <= 0 or h <= 0 or w > 4096 or h > 4096:
		raise ValueError("bad dims")
	colofs = [struct.unpack_from("<I", blob, 8 + i * 4)[0] for i in range(w)]
	px = [(0, 0, 0, 0)] * (w * h)
	for x, off in enumerate(colofs):
		p = off
		while True:
			rowstart = blob[p]
			p += 1
			if rowstart == 255:
				break
			length = blob[p]
			p += 2
			for i in range(length):
				y = rowstart + i
				ci = blob[p + i]
				if 0 <= y < h:
					r, g, b = pal[ci * 3 : ci * 3 + 3]
					px[y * w + x] = (r, g, b, 255)
			p += length + 1
	img = Image.new("RGBA", (w, h))
	img.putdata(px)
	dest.parent.mkdir(parents=True, exist_ok=True)
	img.save(dest)


def ext_for_sound(blob: bytes) -> str:
	if blob[:4] == b"OggS":
		return ".ogg"
	if blob[:4] == b"RIFF":
		return ".wav"
	if blob[:3] == b"ID3" or blob[:2] == b"\xff\xfb":
		return ".mp3"
	return ".wav"


def write_bytes(dest: Path, data: bytes):
	dest.parent.mkdir(parents=True, exist_ok=True)
	dest.write_bytes(data)


def main():
	z = zipfile.ZipFile(SRC)
	pal = find_playpal(z)
	copied = 0
	converted = 0

	for prefix, sub, _ in SPRITE_FOLDERS:
		for n in z.namelist():
			if not n.startswith(prefix) or n.endswith("/"):
				continue
			name = Path(n).name
			if name.startswith("."):
				continue
			data = z.read(n)
			dest_dir = SPR / sub
			if name.lower().endswith(".png") or data[:8] == b"\x89PNG\r\n\x1a\n":
				out = dest_dir / (name if name.lower().endswith(".png") else name + ".png")
				write_bytes(out, data if name.lower().endswith(".png") else data)
				copied += 1
			elif len(data) > 16 and data[0:2] != b"\x89P":
				# doom picture (GHFX etc.)
				base = name if "." not in name else Path(name).stem
				try:
					doom_pic_to_png(data, pal, dest_dir / (base + ".png"))
					converted += 1
				except Exception as e:
					print("skip pic", n, e)

	# FGO2 for Glaucoma ball
	for n in z.namelist():
		if not Path(n).name.upper().startswith("FGO2"):
			continue
		if not n.lower().startswith("sprites/"):
			continue
		name = Path(n).name
		data = z.read(n)
		out = SPR / "Glaucoma" / (name if name.lower().endswith(".png") else name + ".png")
		write_bytes(out, data if data[:8] == b"\x89PNG\r\n\x1a\n" or name.lower().endswith(".png") else data)
		copied += 1

	# BZRD (often PNG without extension)
	for n in z.namelist():
		if not Path(n).name.upper().startswith("BZRD"):
			continue
		if not n.lower().startswith("sprites/"):
			continue
		name = Path(n).name
		data = z.read(n)
		out_name = name if name.lower().endswith(".png") else name + ".png"
		write_bytes(SPR / "Bloodfiend" / out_name, data)
		copied += 1

	for src, dst_rel in SOUND_MAP:
		if src.endswith("/"):
			for n in z.namelist():
				if not n.startswith(src) or n.endswith("/"):
					continue
				data = z.read(n)
				name = Path(n).name
				if "." not in name:
					name = name + ext_for_sound(data)
				write_bytes(SND / dst_rel / name, data)
				copied += 1
		else:
			if src not in z.namelist():
				print("MISSING sound", src)
				continue
			data = z.read(src)
			dest = SND / dst_rel
			if dest.suffix == "":
				dest = dest.with_suffix(ext_for_sound(data))
			write_bytes(dest, data)
			copied += 1

	print(f"done copied={copied} converted={converted}")
	for sub in ("Glaucoma", "Witherdemon", "Mauler", "Overdemoniac", "Dastard", "Machina", "Bloodfiend"):
		d = SPR / sub
		print(sub, "sprites", len(list(d.glob("*"))) if d.is_dir() else 0)


if __name__ == "__main__":
	main()
