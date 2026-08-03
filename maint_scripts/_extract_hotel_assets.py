"""One-shot Hotel WAD asset extract for PB2022 fold. Not loaded by the engine."""
import os, struct, zlib
from pathlib import Path

try:
	from PIL import Image
except ImportError:
	raise SystemExit("Pillow required")

WAD = Path(r"C:\Program Files (x86)\Steam\steamapps\common\Ultimate Doom\(Doom Mod Builds)\.MAPs\TheHotel-LostContactv4.8.wad")
ROOT = Path(r"c:\Users\shawn\OneDrive\Desktop\temp\ProjectBrutality2022")
SPR_HOTEL = ROOT / "SPRITES" / "Monsters" / "Hotel"
SPR_GORE = ROOT / "SPRITES" / "Decoration" / "HotelGore"
SND = ROOT / "sounds" / "monsters" / "Hotel"

# Rename colliding sprite prefixes on write
RENAME = {
	"BOS2": "HTB2",
	"BRUS": "HTBS",
	"BRUD": "HTBD",
}

SPRITE_PREFIXES = (
	"BOS2", "BRUS", "BRUD",
	"OGRA", "OGRB", "OGRC", "OGRE", "OGRG", "OGRH",
	"A4IM", "A4IW", "A4IF", "HMDY",
	"B4IM", "B4IW", "B4IF", "BMDY",
	"MORY", "HLGR", "HLGU",
)

SOUND_EXACT = {
	"CRWLWL", "CRWLSEE", "MORYDIE", "MORYSE1", "MORYSE2", "MORYSE3", "MORYSE4", "MORYATK",
	"HMAC", "HIT2", "MONACT1", "MONACT2", "MONACT3", "MONDTH", "MONDTH2", "MONDTH3", "MONPN",
	"SHOTGUN7", "SHOTGNCK", "SMGF", "CSAWREDY", "CHNSWF", "CHNSWF1",
	"CSWMACT1", "CSWMACT2", "CSWMACT3", "CSWMACT4", "CSWMACT5", "CSWMACT6", "CSWMACT7", "CSWMACT8",
	"CSWMFAL1", "CSWMFAL2", "CSWMFAL3",
	"CSWMSEE1", "CSWMSEE2", "CSWMSEE3",
	"EBSS1", "EBSS2", "EBSS3", "EBSS4", "EBSS5", "EBSS6",
	"EBSP1", "EBSP2", "EBSP3", "EBSP4", "EBSP5", "EBSP6", "EBSP7", "EBSP8", "EBSP9",
	"EBSP10", "EBSP11", "EBSP12", "EBSP13",
	"EBSD1", "EBSD2", "EBSD3", "EBSD4", "EBSD5", "EBSD6", "EBSD7", "EBSD8", "EBSD9",
	"EBSD10", "EBSD11", "EBSD12", "EBSD13",
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


def find_playpal_in(data, entries):
	for name, pos, size in entries:
		if name.upper() == "PLAYPAL" and size >= 768:
			return data[pos : pos + 768]
	return None


def find_playpal(data, entries):
	pal = find_playpal_in(data, entries)
	if pal:
		return pal
	# Hotel WAD has no PLAYPAL; A4I* doom-pics need IWAD palette.
	for cand in (
		Path(r"C:\Program Files (x86)\Steam\steamapps\common\Ultimate Doom\base\doom2\DOOM2.WAD"),
		Path(r"C:\Program Files (x86)\Steam\steamapps\common\Ultimate Doom\(Doom Mod Builds)\DOOM2.WAD"),
		Path(r"C:\Program Files (x86)\Steam\steamapps\common\Ultimate Doom\rerelease\doom2.wad"),
	):
		if cand.is_file():
			d2, e2 = read_wad(cand)
			pal = find_playpal_in(d2, e2)
			if pal:
				print("PLAYPAL from", cand)
				return pal
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
			p += 2  # length + unused
			for i in range(length):
				y = rowstart + i
				ci = blob[p + i]
				if 0 <= y < h:
					r, g, b = pal[ci * 3 : ci * 3 + 3]
					px[y * w + x] = (r, g, b, 255)
			p += length + 1  # pixels + unused
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
	if blob[:2] == b"\xff\xf3" or blob[:2] == b"\xff\xfb" or blob[:3] == b"ID3":
		return ".mp3"
	# doom sound: 0x03 00 + rate + samples
	if len(blob) > 8 and blob[0] == 3 and blob[1] == 0:
		return ".lmp"
	return ".bin"


def main():
	SPR_HOTEL.mkdir(parents=True, exist_ok=True)
	SPR_GORE.mkdir(parents=True, exist_ok=True)
	SND.mkdir(parents=True, exist_ok=True)
	data, entries = read_wad(WAD)
	pal = find_playpal(data, entries)

	spr_n = snd_n = 0
	for name, pos, size in entries:
		if size <= 0:
			continue
		blob = data[pos : pos + size]
		up = name.upper()

		# sounds first so MORYDIE / CRWLSEE are not mistaken for MORY* / CRWL* sprites
		if up in SOUND_EXACT or name in SOUND_EXACT:
			ext = ext_for_sound(blob)
			(SND / f"{up}{ext}").write_bytes(blob)
			snd_n += 1
			continue

		pref = None
		for p in SPRITE_PREFIXES:
			if name.startswith(p):
				pref = p
				break
		if pref:
			oname = out_name(name)
			dest_dir = SPR_GORE if pref in ("HLGR", "HLGU") else SPR_HOTEL
			if blob[:8] == b"\x89PNG\r\n\x1a\n":
				(dest_dir / f"{oname}.png").write_bytes(blob)
			else:
				img = doom_pic_to_rgba(blob, pal)
				img.save(dest_dir / f"{oname}.png")
			spr_n += 1
			continue

	print(f"sprites={spr_n} sounds={snd_n}")
	print("hotel dir", len(list(SPR_HOTEL.glob('*.png'))))
	print("gore dir", len(list(SPR_GORE.glob('*.png'))))


if __name__ == "__main__":
	main()
