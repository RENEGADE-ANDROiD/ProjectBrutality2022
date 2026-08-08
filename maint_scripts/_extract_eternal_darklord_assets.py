"""One-shot extract of Eternal Dark Lord WAD sprites/sounds for PB2022 fold."""
import struct
from pathlib import Path

try:
	from PIL import Image
except ImportError:
	raise SystemExit("Pillow required")

WAD = Path(r"C:\Program Files (x86)\Steam\steamapps\common\Ultimate Doom\(Doom Mod Builds)\.MAPs\Dark_Lord(DoomEternalBossBattle).wad")
ROOT = Path(r"c:\Users\shawn\OneDrive\Desktop\temp\ProjectBrutality2022")
SPR = ROOT / "SPRITES" / "Monsters" / "EternalDarkLord"
SND = ROOT / "sounds" / "monsters" / "EternalDarkLord"

# Avoid HEAL / TRAI collisions with other content.
RENAME = {
	"HEAL": "EDHL",
	"TRAI": "EDTR",
}

SPRITE_PREFIXES = ("DARK", "SUMM", "DAZZ", "SFXG", "DLGR", "RBDL", "HEAL", "TRAI")

SOUND_EXACT = {
	"BATHE", "BOMB", "BOMBBOOM", "BURN", "DEATHDL", "DIE",
	"DMG1", "DMG2", "DMG3", "HIT1", "HIT2", "HIT3", "PHASEHIT",
	"SHIELDBO", "SHIELDHI", "SHOT1", "SHOT2", "SOUL",
	"SWORD1", "SWORD2", "SWORD3", "SWORDH1", "SWORDH2", "SWORDH3",
	"WOLF", "DAZZLED", "SUMMON", "HEAL",
}


def read_wad(path: Path):
	data = path.read_bytes()
	assert data[:4] in (b"IWAD", b"PWAD")
	n, inf = struct.unpack_from("<II", data, 4)
	entries = []
	for i in range(n):
		o = inf + i * 16
		pos, size = struct.unpack_from("<II", data, o)
		name = data[o + 8 : o + 16].split(b"\0", 1)[0].decode("ascii", "replace")
		entries.append((name, pos, size))
	return data, entries


def find_playpal(data, entries):
	for name, pos, size in entries:
		if name.upper() == "PLAYPAL" and size >= 768:
			return data[pos : pos + 768]
	for cand in (
		Path(r"C:\Program Files (x86)\Steam\steamapps\common\Ultimate Doom\base\doom2\DOOM2.WAD"),
		Path(r"C:\Program Files (x86)\Steam\steamapps\common\Ultimate Doom\(Doom Mod Builds)\DOOM2.WAD"),
	):
		if cand.is_file():
			d2, e2 = read_wad(cand)
			for name, pos, size in e2:
				if name.upper() == "PLAYPAL" and size >= 768:
					print("PLAYPAL from", cand)
					return d2[pos : pos + 768]
	raise RuntimeError("PLAYPAL not found")


def doom_pic_to_rgba(blob: bytes, pal: bytes):
	w, h, left, top = struct.unpack_from("<HHhh", blob, 0)
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
	return img


def out_name(name: str) -> str:
	for src, dst in RENAME.items():
		if name.startswith(src):
			return dst + name[len(src) :]
	return name


def ext_for_sound(blob: bytes) -> str:
	if blob[:4] == b"OggS":
		return ".ogg"
	if blob[:4] == b"RIFF":
		return ".wav"
	if blob[:3] == b"ID3" or blob[:2] in (b"\xff\xf3", b"\xff\xfb"):
		return ".mp3"
	if len(blob) > 8 and blob[0] == 3 and blob[1] == 0:
		return ".lmp"
	return ".bin"


def main():
	SPR.mkdir(parents=True, exist_ok=True)
	SND.mkdir(parents=True, exist_ok=True)
	data, entries = read_wad(WAD)
	pal = find_playpal(data, entries)
	spr_n = snd_n = 0
	for name, pos, size in entries:
		if size <= 0:
			continue
		blob = data[pos : pos + size]
		up = name.upper()
		if up in SOUND_EXACT:
			ext = ext_for_sound(blob)
			(SND / f"{up}{ext}").write_bytes(blob)
			snd_n += 1
			continue
		for p in SPRITE_PREFIXES:
			if name.startswith(p):
				oname = out_name(name)
				if blob[:8] == b"\x89PNG\r\n\x1a\n":
					(SPR / f"{oname}.png").write_bytes(blob)
				else:
					try:
						img = doom_pic_to_rgba(blob, pal)
						img.save(SPR / f"{oname}.png")
					except Exception as e:
						print("skip", name, e)
						break
				spr_n += 1
				break
	print(f"sprites={spr_n} sounds={snd_n} out={SPR}")


if __name__ == "__main__":
	main()
