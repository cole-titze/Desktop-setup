#!/usr/bin/env bash
set -euo pipefail

echo "==> Setting desktop wallpaper from repo"

# Resolve script directory (works even if run from elsewhere)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WALLPAPER="$SCRIPT_DIR/../files/wallpaper.jpg"

if [ ! -f "$WALLPAPER" ]; then
  echo "Wallpaper not found at $WALLPAPER"
  exit 1
fi

# Convert to file:// URI format
WALLPAPER_URI="file://$WALLPAPER"

gsettings set org.gnome.desktop.background picture-uri "$WALLPAPER_URI"
gsettings set org.gnome.desktop.background picture-uri-dark "$WALLPAPER_URI"

echo "Wallpaper set successfully"
echo "01-wallpaper complete"
