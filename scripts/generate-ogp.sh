#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if command -v magick >/dev/null 2>&1; then
  IM=(magick)
elif command -v convert >/dev/null 2>&1; then
  IM=(convert)
else
  echo "ImageMagick is required. Install 'magick' or 'convert'." >&2
  exit 1
fi

FONT_JA="/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc"
FONT_LATIN="/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"

if [[ ! -f "$FONT_JA" ]]; then
  echo "Japanese font not found: $FONT_JA" >&2
  exit 1
fi

TMP_LOGO="$(mktemp "${TMPDIR:-/tmp}/abst-ogp-logo.XXXXXX.png")"
trap 'rm -f "$TMP_LOGO"' EXIT

"${IM[@]}" -background none abst.svg -resize 112x112 "$TMP_LOGO"

"${IM[@]}" \
  -size 1200x630 xc:'#080809' \
  \( -size 1200x630 xc:none -fill 'rgba(176,92,175,0.20)' -draw 'circle 600,275 980,275' -blur 0x92 \) \
  -compose over -composite \
  \( -size 1200x630 xc:none -fill 'rgba(176,92,175,0.09)' -draw 'circle 600,360 1160,360' -blur 0x120 \) \
  -compose over -composite \
  \( -size 1200x630 gradient:'#100d12-#050506' \) \
  -compose multiply -composite \
  -gravity center "$TMP_LOGO" -geometry +0-104 -compose over -composite \
  -font "$FONT_JA" \
  -pointsize 58 \
  -fill '#f7f3ee' \
  -gravity center \
  -annotate +0+34 '仮想空間を' \
  -annotate +0+104 'もっと楽しく' \
  -font "$FONT_LATIN" \
  -pointsize 24 \
  -fill 'rgba(247,243,238,0.54)' \
  -annotate +0+190 'abst.im' \
  ogp.png

echo "Generated $ROOT_DIR/ogp.png"
