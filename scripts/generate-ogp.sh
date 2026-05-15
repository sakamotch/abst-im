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

TMP_LOGO="$(mktemp "${TMPDIR:-/tmp}/abst-ogp-logo.XXXXXX.png")"
trap 'rm -f "$TMP_LOGO"' EXIT

"${IM[@]}" -background none abst.svg -resize 230x230 "$TMP_LOGO"

"${IM[@]}" \
  -size 1200x630 gradient:'#111018-#030408' \
  \( -size 1200x630 xc:none -fill 'rgba(176,92,175,0.24)' -draw 'circle 965,110 1240,110' -blur 0x58 \) \
  -compose over -composite \
  \( -size 1200x630 xc:none -fill 'rgba(176,92,175,0.18)' -draw 'circle 235,500 430,500' -blur 0x48 \) \
  -compose over -composite \
  -fill 'rgba(247,245,248,0.10)' \
  -draw 'rectangle 84,78 1116,80' \
  -draw 'rectangle 84,550 1116,552' \
  -fill '#b05caf' \
  -draw 'rectangle 86,156 94,474' \
  "$TMP_LOGO" -geometry +128+202 -compose over -composite \
  -font Noto-Sans-CJK-JP-Bold \
  -pointsize 104 \
  -fill '#f7f5f8' \
  -annotate +392+245 'ABST' \
  -font Noto-Sans-CJK-JP-Medium \
  -pointsize 38 \
  -fill '#f7f5f8' \
  -annotate +398+308 '仮想空間を、' \
  -annotate +398+356 'もうひとつの人生を持てる場所にする' \
  -font Noto-Sans-CJK-JP \
  -pointsize 25 \
  -fill '#c4bfca' \
  -annotate +400+418 '仮想空間での「なりたい」と「やりたい」を' \
  -annotate +400+459 '制作・開発・企画で形にするプロジェクト' \
  -font Noto-Sans-CJK-JP \
  -pointsize 24 \
  -fill '#b05caf' \
  -annotate +400+510 'abst.im' \
  ogp.png

echo "Generated $ROOT_DIR/ogp.png"
