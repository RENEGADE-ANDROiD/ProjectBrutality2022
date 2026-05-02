#!/usr/bin/env python3
"""Cross-reference on-disk assets vs mod text lumps (heuristic orphan finder).

GZDoom mods reference assets indirectly (sprite prefixes, texture names, sound
logical names). This script finds *likely* unused files — always verify in
engine before deleting.
"""
from __future__ import annotations

import os
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SKIP_DIR_NAMES = {".git", "node_modules", "terminals", "mcps", "agent-transcripts"}
TEXT_EXTENSIONS = {
    ".dec", ".zc", ".zsc", ".txt", ".inc", ".bm", ".acs", ".enu", ".cfg", ".csv",
}
ROOT_LUMP_NAMES = {
    "DECORATE", "ZSCRIPT", "ZMAPINFO", "MAPINFO", "LOADACS", "CVARINFO", "KEYCONF",
    "SNDINFO", "SBARINFO", "MENUDEF", "LANGUAGE", "FONTDEFS", "TEXTURES", "GLDEFS",
    "MODELDEF", "ANIMDEFS", "GAMEINFO", "XHAIRS", "PDAMONST", "PDAWEAP", "PDAWEAPT",
}


def iter_text_files(root: Path) -> list[Path]:
    out: list[Path] = []
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [d for d in dirnames if d not in SKIP_DIR_NAMES and not d.startswith(".")]
        # skip this script folder for corpus (optional)
        if "scripts" in Path(dirpath).parts and Path(dirpath).name == "scripts":
            continue
        for fn in filenames:
            p = Path(dirpath) / fn
            if fn.upper() in ROOT_LUMP_NAMES or p.suffix.lower() in TEXT_EXTENSIONS:
                if p.resolve() == Path(__file__).resolve():
                    continue
                out.append(p)
    return out


def load_corpus(root: Path) -> tuple[str, list[Path]]:
    parts: list[str] = []
    paths = iter_text_files(root)
    for p in paths:
        try:
            parts.append(p.read_text(encoding="utf-8", errors="replace"))
        except OSError:
            pass
    return "\n".join(parts), paths


def sndinfo_referenced_paths(sndinfo_text: str, root: Path) -> set[str]:
    """Normalized posix-ish paths and bare lump basenames from SNDINFO."""
    ref: set[str] = set()
    for m in re.finditer(r'"([^"]+\.(?:ogg|wav|mp3|flac|opus))"', sndinfo_text, re.I):
        s = m.group(1).replace("\\", "/")
        ref.add(s.lower())
        ref.add(s.lower().lstrip("./"))
    # Lines like: name    lumpsoundname (no path)
    for line in sndinfo_text.splitlines():
        line = line.split("//")[0].strip()
        if not line or line.startswith("$"):
            continue
        # strip leading logical name, take remaining tokens
        toks = line.split()
        if len(toks) < 2:
            continue
        for t in toks[1:]:
            t = t.strip('"')
            if re.search(r"\.(ogg|wav|mp3|flac|opus)$", t, re.I):
                s = t.replace("\\", "/").lower().lstrip("./")
                ref.add(s)
    return ref


def collect_sound_files(root: Path) -> list[Path]:
    base = root / "sounds"
    if not base.is_dir():
        return []
    out: list[Path] = []
    for dirpath, _, filenames in os.walk(base):
        for fn in filenames:
            if fn.lower().endswith((".ogg", ".wav", ".mp3", ".flac", ".opus")):
                out.append(Path(dirpath) / fn)
    return out


def collect_sprite_like(root: Path) -> list[Path]:
    """Loose sprites / patches (common image extensions)."""
    exts = {".png", ".jpg", ".jpeg", ".tga", ".dds", ".bmp", ".lmp", ".gif", ".webp"}
    bases = [root / "sprites", root / "SPRITES", root / "graphics", root / "GRAPHICS",
             root / "patches", root / "PATCHES", root / "hires", root / "HIRES",
             root / "brightmaps", root / "BMAP"]
    out: list[Path] = []
    for b in bases:
        if not b.is_dir():
            continue
        for dirpath, _, filenames in os.walk(b):
            for fn in filenames:
                if Path(fn).suffix.lower() in exts or Path(fn).suffix == "":
                    out.append(Path(dirpath) / fn)
    return out


def lump_name_from_path(p: Path, root: Path) -> str:
    rel = p.relative_to(root)
    return "/".join(rel.parts).replace("\\", "/").lower()


def sprite_tokens_from_lumpname(name_no_ext: str) -> set[str]:
    """DOOM sprite ORBP from ORBPA0 -> {orbpa0, orbp}."""
    n = name_no_ext.upper()
    t = {n.lower()}
    if len(n) >= 4:
        t.add(n[:4].lower())
    return t


def build_token_sets(blob: str) -> tuple[set[str], set[str]]:
    """Isolated alnum tokens: 4-char (sprite-like) + 5–32 char (names, textures)."""
    lower = blob.lower()
    ref4: set[str] = set()
    ref_long: set[str] = set()
    for m in re.finditer(r'(?<![a-z0-9_])([a-z0-9]{4})(?![a-z0-9_])', lower):
        ref4.add(m.group(1))
    for m in re.finditer(r'(?<![a-z0-9_])([a-z0-9]{5,32})(?![a-z0-9_])', lower):
        ref_long.add(m.group(1))
    return ref4, ref_long


def model_files(root: Path) -> list[Path]:
    out: list[Path] = []
    for sub in ("models", "MODELS"):
        b = root / sub
        if not b.is_dir():
            continue
        for dirpath, _, filenames in os.walk(b):
            for fn in filenames:
                if fn.lower().endswith((".md3", ".md2", ".pk3", ".obj")):
                    out.append(Path(dirpath) / fn)
    return out


def main() -> None:
    blob, corpus_paths = load_corpus(ROOT)
    print(f"# Asset reference audit — {ROOT.name}")
    print(f"- Corpus: {len(corpus_paths)} text files, {len(blob):,} characters")
    print("- Building token index...")
    ref4, ref_long = build_token_sets(blob)
    print(f"  4-char tokens: {len(ref4):,}; 5–32 char tokens: {len(ref_long):,}")
    print()

    # --- sounds ---
    snd_path = ROOT / "SNDINFO.txt"
    snd_text = snd_path.read_text(encoding="utf-8", errors="replace") if snd_path.is_file() else ""
    ref_snd = sndinfo_referenced_paths(snd_text, ROOT)
    sounds = collect_sound_files(ROOT)
    orphans_snd: list[Path] = []
    for p in sounds:
        rel = lump_name_from_path(p, ROOT)
        rel_noprefix = rel[len("sounds/"):] if rel.startswith("sounds/") else rel
        stem = p.stem.lower()
        ok = False
        for candidate in (rel, rel_noprefix, f"sounds/{rel_noprefix}"):
            if candidate in ref_snd:
                ok = True
                break
        if not ok:
            if any(rel_noprefix in r or r.endswith(rel_noprefix) for r in ref_snd):
                ok = True
        if not ok and stem in ref_long:
            ok = True
        if not ok:
            orphans_snd.append(p)

    print("## Sounds (files under `sounds/` not matched to SNDINFO path or corpus substring)")
    print(f"- Total audio files: {len(sounds)}")
    print(f"- Likely unreferenced: {len(orphans_snd)} (heuristic)")
    for p in sorted(orphans_snd)[:80]:
        print(f"  - {p.relative_to(ROOT)}")
    if len(orphans_snd) > 80:
        print(f"  ... and {len(orphans_snd) - 80} more")
    print()

    # --- sprites / graphics: lump stem + 4-char prefix ---
    spr = collect_sprite_like(ROOT)
    orphan_spr: list[Path] = []
    checked = 0
    for p in spr:
        checked += 1
        stem = p.stem
        if stem.lower() in ("license", "readme", "credit"):
            continue
        tokens = sprite_tokens_from_lumpname(stem)
        rel = str(p.relative_to(ROOT)).replace("\\", "/").lower()
        hit = False
        for t in tokens:
            if len(t) == 4 and t in ref4:
                hit = True
                break
            if len(t) >= 5 and t in ref_long:
                hit = True
                break
        if not hit and stem.lower() in ref_long:
            hit = True
        if not hit:
            for part in Path(rel).parts:
                pl = part.lower()
                if len(pl) == 4 and pl in ref4:
                    hit = True
                    break
                if len(pl) >= 5 and pl in ref_long:
                    hit = True
                    break
        if not hit:
            orphan_spr.append(p)

    print("## Sprites / graphics / patches / brightmaps (PNG etc. under common asset dirs)")
    print(f"- Total image-like files scanned: {len(spr)}")
    print(f"- Likely unreferenced (token heuristic): {len(orphan_spr)}")
    print("  (Many false positives: composite TEXTURES, runtime-built names, ACS.)")
    for p in sorted(orphan_spr)[:60]:
        print(f"  - {p.relative_to(ROOT)}")
    if len(orphan_spr) > 60:
        print(f"  ... and {len(orphan_spr) - 60} more")
    print()

    # --- models ---
    mfs = model_files(ROOT)
    orphan_md: list[Path] = []
    for p in mfs:
        rel = str(p.relative_to(ROOT)).replace("\\", "/").lower()
        st = p.stem.lower()
        parts = [st] + [x.lower() for x in Path(rel).parts]
        if any(
            (len(x) == 4 and x in ref4) or (len(x) >= 5 and x in ref_long)
            for x in parts
        ):
            continue
        orphan_md.append(p)
    print("## Models (md2/md3 under models/ MODELS/)")
    print(f"- Total: {len(mfs)}, likely unreferenced: {len(orphan_md)}")
    for p in sorted(orphan_md)[:40]:
        print(f"  - {p.relative_to(ROOT)}")
    if len(orphan_md) > 40:
        print(f"  ... and {len(orphan_md) - 40} more")
    print()
    print("## Caveats")
    print("- Sound list: patch lumps, ZScript string concatenation, and `$random` chains may omit paths.")
    print("- Sprites: TEXTURES composites often reference patches by name not present as raw substrings in .dec.")
    print("- Always confirm with GZDoom (`-voicedebug`, missing sprite warnings) before deleting.")


if __name__ == "__main__":
    main()
