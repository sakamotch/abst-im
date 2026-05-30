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
  -fill '#b05caf' -draw 'rectangle 150,118 166,512' \
  -gravity northwest "$TMP_LOGO" -geometry +210+130 -compose over -composite \
  -font "$FONT_LATIN" \
  -pointsize 116 \
  -fill '#f7f3ee' \
  -gravity northwest \
  -annotate +210+296 'ABST' \
  -font "$FONT_JA" \
  -pointsize 34 \
  -fill 'rgba(247,243,238,0.68)' \
  -annotate +214+390 '仮想空間をもっと楽しくするためのプロダクトと制作' \
  -font "$FONT_LATIN" \
  -pointsize 24 \
  -fill 'rgba(247,243,238,0.42)' \
  -annotate +214+456 'abst.im' \
  ogp.png

echo "Generated $ROOT_DIR/ogp.png"
