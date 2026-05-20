from pathlib import Path
from math import cos, sin, radians

from PIL import Image, ImageDraw, ImageFilter


SIZE = 1024
SCALE = 4
CANVAS = SIZE * SCALE
CENTER = CANVAS // 2
OUTER_RADIUS = 350 * SCALE
INNER_RADIUS = 260 * SCALE
GAP_DEGREES = 45

OUTPUT_PATH = Path(
    r"C:\Users\Windows\ShiryokuCheck\ShiryokuCheck\Assets.xcassets\AppIcon.appiconset\icon_1024.png"
)


def lerp(a, b, t):
    return int(a + (b - a) * t)


def make_background():
    top = (255, 255, 255)
    bottom = (232, 244, 253)
    image = Image.new("RGB", (CANVAS, CANVAS), top)
    draw = ImageDraw.Draw(image)

    for y in range(CANVAS):
        t = y / (CANVAS - 1)
        color = tuple(lerp(top[i], bottom[i], t) for i in range(3))
        draw.line([(0, y), (CANVAS, y)], fill=color)

    return image


def make_landolt_mask():
    mask = Image.new("L", (CANVAS, CANVAS), 0)
    draw = ImageDraw.Draw(mask)

    outer_box = [
        CENTER - OUTER_RADIUS,
        CENTER - OUTER_RADIUS,
        CENTER + OUTER_RADIUS,
        CENTER + OUTER_RADIUS,
    ]
    inner_box = [
        CENTER - INNER_RADIUS,
        CENTER - INNER_RADIUS,
        CENTER + INNER_RADIUS,
        CENTER + INNER_RADIUS,
    ]

    draw.ellipse(outer_box, fill=255)
    draw.ellipse(inner_box, fill=0)

    half_gap = GAP_DEGREES / 2
    cut_radius = OUTER_RADIUS + 80 * SCALE
    gap_points = [(CENTER, CENTER)]
    for angle in (-half_gap, half_gap):
        rad = radians(angle)
        gap_points.append(
            (
                CENTER + int(cos(rad) * cut_radius),
                CENTER + int(sin(rad) * cut_radius),
            )
        )
    draw.polygon(gap_points, fill=0)

    return mask.filter(ImageFilter.GaussianBlur(radius=0.25 * SCALE))


def main():
    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)

    background = make_background().convert("RGBA")

    shadow_mask = make_landolt_mask().filter(ImageFilter.GaussianBlur(radius=4 * SCALE))
    shadow = Image.new("RGBA", (CANVAS, CANVAS), (26, 82, 118, 42))
    background.alpha_composite(shadow, mask=shadow_mask)

    landolt_mask = make_landolt_mask()
    landolt = Image.new("RGBA", (CANVAS, CANVAS), (26, 82, 118, 255))
    background.alpha_composite(landolt, mask=landolt_mask)

    icon = background.resize((SIZE, SIZE), Image.Resampling.LANCZOS)
    icon.save(OUTPUT_PATH, format="PNG", optimize=True)


if __name__ == "__main__":
    main()
