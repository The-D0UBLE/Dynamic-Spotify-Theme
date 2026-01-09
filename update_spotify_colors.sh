#!/usr/bin/env bash
set -e

ROFI_COLORS="$HOME/.config/rofi/colors.rasi"
SPICE_COLORS="$HOME/.config/spicetify/Themes/Retroblur/color.ini"
TMP_FILE="$(mktemp)"

# --- extract ONE valid hex per value ---
bg=$(grep -oP 'surface\s*:\s*#\K[0-9a-fA-F]{6}' "$ROFI_COLORS" | head -n1)
fg=$(grep -oP 'on-surface\s*:\s*#\K[0-9a-fA-F]{6}' "$ROFI_COLORS" | head -n1)
accent=$(grep -oP 'primary\s*:\s*#\K[0-9a-fA-F]{6}' "$ROFI_COLORS" | head -n1)

# --- hard fallbacks (never fail) ---
bg=${bg:-0c0e14}
fg=${fg:-e2e2e9}
accent=${accent:-aac7ff}

# --- remove existing [current] section cleanly ---
awk '
BEGIN { skip=0 }
/^\[current\]$/ { skip=1; next }
skip && /^\[/ { skip=0 }
!skip { print }
' "$SPICE_COLORS" > "$TMP_FILE"

# --- append new [current] ---
cat >> "$TMP_FILE" <<EOF

[current]
text               = $fg
subtext            = $fg
main               = $bg
sidebar            = $bg
player             = $bg
card               = $bg
shadow             = $bg
selected-row       = $accent
button             = $accent
button-active      = $accent
button-disabled    = 444444
tab-active         = $accent
notification       = $bg
notification-error = ff0000
misc               = $bg
EOF

# --- replace atomically ---
mv "$TMP_FILE" "$SPICE_COLORS"

