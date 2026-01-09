#!/usr/bin/env bash

# Paths
ML4W_CURRENT="$HOME/.config/ml4w/cache/current_wallpaper"
SPOTIFY_ASSETS="$HOME/.config/spicetify/Themes/Retroblur/assets"
OUTPUT="$SPOTIFY_ASSETS/blurred_wallpaper.jpg"


# Safety checks
[ -f "$ML4W_CURRENT" ] || exit 1
WALLPAPER="$(cat "$ML4W_CURRENT")"
[ -f "$WALLPAPER" ] || exit 1

mkdir -p "$SPOTIFY_ASSETS"

# Convert + lightly blur
magick "$WALLPAPER" \
  -resize 2560x1440^ \
  -gravity center \
  -extent 2560x1440 \
  -blur 0x8 \
  -sampling-factor 4:2:0 \
  -strip \
  -quality 92 \
  "$OUTPUT"

