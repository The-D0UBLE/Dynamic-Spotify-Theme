#!/usr/bin/env bash
set -e

SPOTIFY_COLOR_SCRIPT="$HOME/Documents/scripts/spotify/custom_scripts/Dynamic-Spotify-Theme/update_spotify_colors.sh"
SPOTIFY_WALLPAPER_SCRIPT="$HOME/Documents/scripts/spotify/custom_scripts/Dynamic-Spotify-Theme/update_spotify_wallpaper.sh"

# remove cache from spotify for wallpaper change
rm -rf ~/.cache/spotify/Default/Cache/

$SPOTIFY_COLOR_SCRIPT
$SPOTIFY_WALLPAPER_SCRIPT

# reload spotify
spicetify apply
