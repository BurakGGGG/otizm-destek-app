#!/usr/bin/env python3
"""Uygulama simgelerini üretir (Android mipmap + iOS AppIcon).

Simge, uygulama içindeki logoyla aynı: birincil mavi zemin üzerine beyaz
`volunteer_activism` (yardım eden eller) Material ikonu. Kaynak font Flutter
SDK önbelleğinden okunur, ek varlık gerekmez.

    python3 tool/generate_icons.py
"""
from __future__ import annotations

import json
import os
import shutil
import subprocess
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

PRIMARY = (37, 99, 235)  # AppColors.primary (#2563EB)
GLYPH = ""  # Icons.volunteer_activism
ROOT = Path(__file__).resolve().parent.parent


def flutter_root() -> Path:
    which = shutil.which("flutter")
    if which is None:
        raise SystemExit("flutter bulunamadı")
    return Path(os.path.realpath(which)).parent.parent


def material_font() -> Path:
    path = flutter_root() / "bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf"
    if not path.exists():
        raise SystemExit(f"Material ikon fontu yok: {path}")
    return path


def render(size: int, *, rounded: bool, glyph_ratio: float = 0.58) -> Image.Image:
    """Tek bir simge karesi üretir."""
    scale = 4  # kenar yumuşatma için büyük çizip küçültüyoruz
    canvas = Image.new("RGBA", (size * scale, size * scale), (0, 0, 0, 0))
    draw = ImageDraw.Draw(canvas)
    box = (0, 0, size * scale - 1, size * scale - 1)
    if rounded:
        draw.rounded_rectangle(box, radius=int(size * scale * 0.22), fill=PRIMARY)
    else:
        draw.rectangle(box, fill=PRIMARY)

    font = ImageFont.truetype(str(material_font()), int(size * scale * glyph_ratio))
    left, top, right, bottom = draw.textbbox((0, 0), GLYPH, font=font)
    draw.text(
        (
            (size * scale - (right - left)) / 2 - left,
            (size * scale - (bottom - top)) / 2 - top,
        ),
        GLYPH,
        font=font,
        fill=(255, 255, 255, 255),
    )
    return canvas.resize((size, size), Image.LANCZOS)


def write_android() -> list[Path]:
    # Legacy mipmap boyutları (dp: 48) — adaptive icon kullanılmıyor.
    sizes = {
        "mdpi": 48,
        "hdpi": 72,
        "xhdpi": 96,
        "xxhdpi": 144,
        "xxxhdpi": 192,
    }
    written = []
    for bucket, size in sizes.items():
        target = ROOT / f"android/app/src/main/res/mipmap-{bucket}/ic_launcher.png"
        target.parent.mkdir(parents=True, exist_ok=True)
        render(size, rounded=True).save(target)
        written.append(target)
    return written


def write_ios() -> list[Path]:
    appicon = ROOT / "ios/Runner/Assets.xcassets/AppIcon.appiconset"
    contents = json.loads((appicon / "Contents.json").read_text())
    written = []
    for image in contents.get("images", []):
        filename = image.get("filename")
        if not filename:
            continue
        # "60x60" + "@3x" → 180 piksel
        base = float(image["size"].split("x")[0])
        scale = int(image.get("scale", "1x").rstrip("x"))
        pixels = int(base * scale)
        # iOS simgeleri saydamlık kabul etmiyor; köşeleri sistem yuvarlıyor.
        icon = render(pixels, rounded=False).convert("RGB")
        icon.save(appicon / filename)
        written.append(appicon / filename)
    return written


def main() -> None:
    android = write_android()
    ios = write_ios()
    print(f"Android: {len(android)} simge")
    print(f"iOS: {len(ios)} simge")
    # Değişiklik özeti (git varsa).
    subprocess.run(["git", "status", "--short", "android", "ios"], cwd=ROOT, check=False)


if __name__ == "__main__":
    main()
