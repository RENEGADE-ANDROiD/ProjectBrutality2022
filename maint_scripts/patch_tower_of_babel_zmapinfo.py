#!/usr/bin/env python3
"""Replace ZMAPINFO in The_Tower_of_Babel.wad with UZDoom 4.14-compatible MAPINFO."""

from __future__ import annotations

import shutil
import struct
import sys
from pathlib import Path

WAD_PATH = Path(
    r"C:\Program Files (x86)\Steam\steamapps\common\Ultimate Doom"
    r"\(Doom Mod Builds)\.MAPs\The_Tower_of_Babel.wad"
)
ZMAPINFO_TXT = Path(__file__).resolve().parent / "The_Tower_of_Babel_ZMAPINFO.txt"
LUMP_NAME = "ZMAPINFO"


def read_wad(path: Path) -> tuple[bytes, list[tuple[str, int, int]]]:
    data = path.read_bytes()
    if data[:4] != b"PWAD":
        raise ValueError(f"{path} is not a PWAD")
    num_lumps = struct.unpack_from("<I", data, 4)[0]
    dir_offset = struct.unpack_from("<I", data, 8)[0]
    entries: list[tuple[str, int, int]] = []
    off = dir_offset
    for _ in range(num_lumps):
        pos, size = struct.unpack_from("<II", data, off)
        off += 8
        name = data[off : off + 8].decode("ascii", errors="replace").rstrip("\x00")
        off += 8
        entries.append((name, pos, size))
    return data, entries


def write_wad(path: Path, lumps: list[tuple[str, bytes]]) -> None:
    header = b"PWAD" + struct.pack("<II", len(lumps), 0)
    body = bytearray(header)
    directory: list[tuple[int, int, str]] = []
    for name, payload in lumps:
        pos = len(body)
        body.extend(payload)
        directory.append((pos, len(payload), name))
    dir_offset = len(body)
    for pos, size, name in directory:
        body.extend(struct.pack("<II", pos, size))
        name_bytes = name.encode("ascii", errors="replace")[:8]
        body.extend(name_bytes.ljust(8, b"\x00"))
    struct.pack_into("<I", body, 8, dir_offset)
    path.write_bytes(body)


def main() -> int:
    if not ZMAPINFO_TXT.is_file():
        print(f"Missing {ZMAPINFO_TXT}", file=sys.stderr)
        return 1
    if not WAD_PATH.is_file():
        print(f"Missing {WAD_PATH}", file=sys.stderr)
        return 1

    new_zmapinfo = ZMAPINFO_TXT.read_bytes()
    backup = WAD_PATH.with_suffix(".wad.bak")
    if not backup.exists():
        shutil.copy2(WAD_PATH, backup)
        print(f"Backup: {backup}")

    data, entries = read_wad(WAD_PATH)
    if not any(name.upper() == LUMP_NAME for name, _, _ in entries):
        print(f"No {LUMP_NAME} lump in WAD", file=sys.stderr)
        return 1

    lumps: list[tuple[str, bytes]] = []
    replaced = False
    for name, pos, size in entries:
        if name.upper() == LUMP_NAME:
            lumps.append((name, new_zmapinfo))
            replaced = True
        else:
            lumps.append((name, data[pos : pos + size]))

    if not replaced:
        print("ZMAPINFO not replaced", file=sys.stderr)
        return 1

    write_wad(WAD_PATH, lumps)
    print(f"Patched {WAD_PATH}")
    print(f"  ZMAPINFO: {len(new_zmapinfo)} bytes")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
