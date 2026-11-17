"""Generate the website images from the app icon (assets/icon_orthoAutoAI.png).

    python site/tools/make-images.py

Requires Pillow. Writes into site/src/assets/:
  logo-64.png, icon-192.png, icon-512.png, apple-touch-icon.png, favicon.ico,
  og-<lang>.png (1200x630 social preview, one per language, tagline from i18n/<lang>.json)

Run it again only when the icon or the og_tagline translations change.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

HERE = Path(__file__).resolve().parent
SITE = HERE.parent
REPO = SITE.parent
SOURCE_ICON = REPO / "assets" / "icon_orthoAutoAI.png"
OUT = SITE / "src" / "assets"
I18N = SITE / "src" / "i18n"

BG = (11, 15, 21)
DOT = (34, 44, 58)
TEXT = (232, 237, 244)
MUTED = (154, 167, 185)
ACCENT = (93, 180, 240)
BORDER = (50, 64, 85)

# The source icon has a thick black frame; crop it off.
FRAME_RATIO = 0.055

FONT_CANDIDATES = {
    "bold": ["C:/Windows/Fonts/segoeuib.ttf", "/usr/share/fonts/TTF/DejaVuSans-Bold.ttf",
             "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", "/System/Library/Fonts/Supplemental/Arial Bold.ttf"],
    "regular": ["C:/Windows/Fonts/segoeui.ttf", "/usr/share/fonts/TTF/DejaVuSans.ttf",
                "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", "/System/Library/Fonts/Supplemental/Arial.ttf"],
    "mono": ["C:/Windows/Fonts/CascadiaMono.ttf", "C:/Windows/Fonts/consola.ttf",
             "/usr/share/fonts/TTF/DejaVuSansMono.ttf", "/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf"],
}


def font(kind: str, size: int) -> ImageFont.FreeTypeFont:
    for path in FONT_CANDIDATES[kind]:
        if Path(path).is_file():
            return ImageFont.truetype(path, size)
    sys.exit(f"No {kind} font found; edit FONT_CANDIDATES in {__file__}")


def cropped_icon() -> Image.Image:
    im = Image.open(SOURCE_ICON).convert("RGB")
    w, h = im.size
    m = round(min(w, h) * FRAME_RATIO)
    return im.crop((m, m, w - m, h - m))


def rounded(im: Image.Image, size: int, radius_ratio: float = 0.22) -> Image.Image:
    scale = 4  # supersample the mask for smooth corners
    big = im.resize((size * scale, size * scale), Image.LANCZOS).convert("RGBA")
    mask = Image.new("L", big.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle(
        (0, 0, big.size[0] - 1, big.size[1] - 1), radius=int(size * scale * radius_ratio), fill=255
    )
    big.putalpha(mask)
    return big.resize((size, size), Image.LANCZOS)


def wrap(draw: ImageDraw.ImageDraw, text: str, fnt, max_width: int) -> list[str]:
    lines, line = [], ""
    for word in text.split():
        trial = f"{line} {word}".strip()
        if draw.textlength(trial, font=fnt) <= max_width:
            line = trial
        else:
            if line:
                lines.append(line)
            line = word
    if line:
        lines.append(line)
    return lines


def og_image(icon: Image.Image, tagline: str) -> Image.Image:
    W, H = 1200, 630
    img = Image.new("RGB", (W, H), BG)
    d = ImageDraw.Draw(img)
    for y in range(11, H, 22):
        for x in range(11, W, 22):
            d.point((x, y), fill=DOT)

    # Icon card on the right
    size = 360
    x0, y0 = W - size - 90, (H - size) // 2
    d.rounded_rectangle((x0 - 6, y0 - 6, x0 + size + 5, y0 + size + 5), radius=90, fill=BORDER)
    img.paste(rounded(icon, size, 0.24), (x0, y0), rounded(icon, size, 0.24))

    left, max_w = 90, x0 - 90 - 70
    d.text((left, 120), "OrthoAutoAI", font=font("bold", 74), fill=TEXT)

    tag_font = font("regular", 40)
    y = 230
    for line in wrap(d, tagline, tag_font, max_w)[:4]:
        d.text((left, y), line, font=tag_font, fill=MUTED)
        y += 54

    d.text((left, H - 130), "Alt + C  ·  Windows  ·  Linux", font=font("mono", 28), fill=ACCENT)
    return img


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    icon = cropped_icon()

    def save_small(im: Image.Image, name: str) -> None:
        # 256-colour palette keeps the flat illustration crisp at a fraction of the size.
        im.quantize(colors=256, method=Image.Quantize.FASTOCTREE, dither=Image.Dither.NONE).save(
            OUT / name, optimize=True
        )

    save_small(rounded(icon, 64), "logo-64.png")
    save_small(rounded(icon, 192), "icon-192.png")
    save_small(rounded(icon, 512), "icon-512.png")
    # iOS applies its own mask: keep the touch icon square and opaque.
    save_small(icon.resize((180, 180), Image.LANCZOS), "apple-touch-icon.png")
    rounded(icon, 256).save(OUT / "favicon.ico", sizes=[(16, 16), (32, 32), (48, 48)])

    for path in sorted(I18N.glob("*.json")):
        lang = path.stem
        tagline = json.loads(path.read_text(encoding="utf-8"))["og_tagline"]
        og = og_image(icon, tagline)
        og.quantize(colors=256, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE).save(
            OUT / f"og-{lang}.png", optimize=True
        )

    for f in sorted(OUT.iterdir()):
        print(f"{f.name:24} {f.stat().st_size / 1024:7.1f} KB")


if __name__ == "__main__":
    main()
