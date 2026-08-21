#!/usr/bin/env python3
"""Uygulama simgelerini üretir (Android mipmap + iOS AppIcon).

Simge, uygulama içindeki logoyla aynı: birincil mavi zemin üzerine beyaz
`volunteer_activism` (yardım eden eller) Material ikonu. Kaynak font Flutter
SDK önbelleğinden okunur, ek varlık gerekmez.

Üretilenler:
  * Android eski mipmap'ler (API < 26) — yuvarlatılmış kare, tam kare simge.
  * Android uyarlanabilir simge katmanları (API 26+) — ön plan (saydam zemin,
    %66 güvenli alan) + tek renk (API 33+ tema simgesi). Zemin rengi
    `values/colors.xml` içindeki `ic_launcher_background`.
  * iOS AppIcon seti (Contents.json'daki her boyut).

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
ANDROID_RES = ROOT / "android/app/src/main/res"

# Yoğunluk kovaları: eski simge kenarı (dp 48) ve uyarlanabilir katman (dp 108).
DENSITIES = {
    "mdpi": 1,
    "hdpi": 1.5,
    "xhdpi": 2,
    "xxhdpi": 3,
    "xxxhdpi": 4,
}


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


def render(
    size: int,
    *,
    rounded: bool,
    glyph_ratio: float = 0.58,
    background: tuple[int, int, int] | None = PRIMARY,
    glyph: tuple[int, int, int, int] = (255, 255, 255, 255),
) -> Image.Image:
    """Tek bir simge karesi üretir. `background=None` → saydam zemin."""
    scale = 4  # kenar yumuşatma için büyük çizip küçültüyoruz
    canvas = Image.new("RGBA", (size * scale, size * scale), (0, 0, 0, 0))
    draw = ImageDraw.Draw(canvas)
    box = (0, 0, size * scale - 1, size * scale - 1)
    if background is not None:
        if rounded:
            draw.rounded_rectangle(box, radius=int(size * scale * 0.22), fill=background)
        else:
            draw.rectangle(box, fill=background)

    font = ImageFont.truetype(str(material_font()), int(size * scale * glyph_ratio))
    left, top, right, bottom = draw.textbbox((0, 0), GLYPH, font=font)
    draw.text(
        (
            (size * scale - (right - left)) / 2 - left,
            (size * scale - (bottom - top)) / 2 - top,
        ),
        GLYPH,
        font=font,
        fill=glyph,
    )
    return canvas.resize((size, size), Image.LANCZOS)


def write_android() -> list[Path]:
    written: list[Path] = []
    for bucket, factor in DENSITIES.items():
        folder = ANDROID_RES / f"mipmap-{bucket}"
        folder.mkdir(parents=True, exist_ok=True)

        # Eski (API < 26) simge: 48dp, zeminiyle birlikte tam kare.
        legacy = folder / "ic_launcher.png"
        render(int(48 * factor), rounded=True).save(legacy)
        written.append(legacy)

        # Uyarlanabilir katmanlar: 108dp tuval, ikon 72dp'lik güvenli alanda
        # kalmalı (maske kırpıyor) — 0.44 oranı ≈ 47dp.
        edge = int(108 * factor)
        foreground = folder / "ic_launcher_foreground.png"
        render(edge, rounded=False, glyph_ratio=0.44, background=None).save(foreground)
        written.append(foreground)

        # Tema simgesi (API 33+): sistem tek renge boyar, alfa yeterli.
        monochrome = folder / "ic_launcher_monochrome.png"
        render(edge, rounded=False, glyph_ratio=0.44, background=None).save(monochrome)
        written.append(monochrome)

    anydpi = ANDROID_RES / "mipmap-anydpi-v26"
    anydpi.mkdir(parents=True, exist_ok=True)
    adaptive = anydpi / "ic_launcher.xml"
    adaptive.write_text(
        '<?xml version="1.0" encoding="utf-8"?>\n'
        '<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">\n'
        '    <background android:drawable="@color/ic_launcher_background" />\n'
        '    <foreground android:drawable="@mipmap/ic_launcher_foreground" />\n'
        '    <monochrome android:drawable="@mipmap/ic_launcher_monochrome" />\n'
        "</adaptive-icon>\n"
    )
    written.append(adaptive)
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
    print(f"Android: {len(android)} dosya")
    print(f"iOS: {len(ios)} simge")
    # Değişiklik özeti (git varsa).
    subprocess.run(["git", "status", "--short", "android", "ios"], cwd=ROOT, check=False)


if __name__ == "__main__":
    main()
